data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    merge_type   = "list(append)+dict(recurse_array)+str()"
    content      = <<EOF
#cloud-config
---
write_files:
- path: "/etc/sysctl.d/90-redis.conf"
  content: |
    ${indent(4, file("${path.module}/files/etc/sysctl.d/90-redis.conf"))}
- path: "/etc/redis/defaults.conf"
  content: |
    ${indent(4, file("${path.module}/files/etc/redis/defaults.conf"))}
- path: "/etc/systemd/system/redis-node@.service"
  content: |
    ${indent(4, file("${path.module}/files/etc/systemd/system/redis-node@.service"))}
- path: "/usr/local/bin/redis-cli"
  owner: root:root
  permissions: '0755'
  content: |
    ${indent(4, file("${path.module}/files/usr/local/bin/redis-cli.sh"))}
EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = <<EOF
#!/bin/bash
set -eu -o pipefail

#
# sysctl kernel settings
#
service procps restart

#
# Turn of virutal memory transparent huge pages
#
# always madvise [never]
#
echo never > /sys/kernel/mm/transparent_hugepage/enabled

#
# Common config snippet
#
total_memory=$(($(awk '/MemTotal/ {print $2}' /proc/meminfo) /(1024 * 1024)))
usable_memory=$(python -c "print(int($${total_memory} * .80))")
maxmemory="$(($usable_memory / ($(nproc) / 2)))GB"
cat <<EOFF > /etc/redis/local.conf
############################# MEMORY MANAGEMENT ###############################
maxmemory $${maxmemory}
EOFF

#
# Per process configs
#
zone_name=$(ec2-metadata --availability-zone)
zone_code=$${zone_name: -1}
declare -A zone_offsets
zone_offsets["a"]=0
zone_offsets["b"]=1
zone_offsets["c"]=2
zone_offset=$${zone_offsets[$zone_code]}

# Set 'host' hostname to match dns
hostnamectl set-hostname "${var.name}-$${zone_code}"

redis_procs=$(($(nproc) / 2))

base_port=$((6379 + ("$redis_procs" * "$zone_offset")))

for redis_proc in $(seq 0 $(("$redis_procs" - 1))); do
    redis_port=$(("$base_port" + "$redis_proc"))
    sibling_cpu=$(("$redis_proc" + "$redis_procs"))
    cat <<EOFF > /etc/redis/$${redis_port}.conf
################################## INCLUDES ###################################
include /etc/redis/defaults.conf
include /etc/redis/local.conf

################################## NETWORK ####################################
port $${redis_port}

################################ REDIS CLUSTER  ###############################
cluster-config-file nodes-$${redis_port}.conf

############################### ADVANCED CONFIG ###############################
server_cpulist $${redis_proc}-$${sibling_cpu}:$${redis_procs}
EOFF
done

docker pull redis

#
# Redis unix user and working directories
#
adduser --system --group --no-create-home redis
for redis_proc in $(seq 0 $(("$redis_procs" - 1))); do
    redis_port=$(("$base_port" + "$redis_proc"))

    mkdir -p mkdir "/var/lib/redis/$${redis_port}"
done
chown -R redis:redis /var/lib/redis
chmod -R 770 /var/lib/redis

systemctl daemon-reload

#
# Start redis-server cluster processes
#
for redis_proc in $(seq 0 $(("$redis_procs" - 1))); do
    redis_port=$(("$base_port" + "$redis_proc"))

    systemctl enable redis-node@$${redis_port}.service
    systemctl start redis-node@$${redis_port}.service
done
EOF
  }
}
