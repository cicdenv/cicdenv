data "template_file" "bin_mysql" {
  template = file("${path.module}/templates/usr/local/bin/mysql.tpl")

  vars = {
    image_tag = local.mysql_version
  }
}

data "template_file" "bin_wait_for_mysql" {
  template = file("${path.module}/templates/usr/local/bin/wait-for-mysql.sh.tpl")

  vars = {
    image_tag = local.mysql_version
  }
}

data "template_file" "bin_mysql_set_security" {
  template = file("${path.module}/templates/usr/local/bin/mysql-set-security.sh.tpl")

  vars = {
    image_tag  = local.mysql_version
    secret_arn = local.creds_secret.arn
  }
}

data "template_file" "mysql_primary_service" {
  template = file("${path.module}/templates/etc/systemd/system/mysql-primary.service.tpl")

  vars = {
    image_tag  = local.mysql_version
    from       = local.from_email
    to         = local.to_email
  }
}

data "template_file" "mysql_replica_service" {
  template = file("${path.module}/templates/etc/systemd/system/mysql-replica.service.tpl")

  vars = {
    image_tag  = local.mysql_version
  }
}

data "template_file" "bin_create_replica_dump" {
  template = file("${path.module}/templates/usr/local/bin/create-replica-dump.sh.tpl")

  vars = {
    image_tag = local.mysql_version
    bucket    = local.mysql_backups.bucket.name
    name      = var.name
    id        = var.id
    databases = local.databases
  }
}

data "template_file" "mysql_replica_dump_timer" {
  template = file("${path.module}/templates/etc/systemd/system/mysql-replica-dump.timer.tpl")

  vars = {
    schedule = local.dump_schedule
  }
}

data "template_file" "mysql_replica_dump_failed_service" {
  template = file("${path.module}/templates/etc/systemd/system/mysql-replica-dump-failed.service.tpl")

  vars = {
    image_tag  = local.mysql_version
    from       = local.from_email
    to         = local.to_email
  }
}

data "template_file" "mysql_replica_dump_service" {
  template = file("${path.module}/templates/etc/systemd/system/mysql-replica-dump.service.tpl")

  vars = {
    image_tag  = local.mysql_version
  }
}

data "template_file" "bin_create_replica_snapshot" {
  template = file("${path.module}/templates/usr/local/bin/create-replica-snapshot.sh.tpl")

  vars = {
    name = var.name
    id   = var.id
  }
}

data "template_file" "mysql_replica_snapshot_timer" {
  template = file("${path.module}/templates/etc/systemd/system/mysql-replica-snapshot.timer.tpl")

  vars = {
    schedule = local.snap_schedule
  }
}

data "template_file" "mysql_replica_snapshot_failed_service" {
  template = file("${path.module}/templates/etc/systemd/system/mysql-replica-snapshot-failed.service.tpl")

  vars = {
    image_tag  = local.mysql_version
    from       = local.from_email
    to         = local.to_email
  }
}
