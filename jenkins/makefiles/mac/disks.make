volumes:
	_dpid=$(shell docker run --rm -i \
	    --privileged \
	    --pid=host \
	    debian \
	    nsenter -t 1 -m -u -n -i bash -c 'ctr -n services.linuxkit tasks ls | grep docker | awk '\''{print $$2}'\'); \
	docker run --rm -it \
	    --privileged \
	    --pid=host \
	    debian \
	    nsenter -t 1 -m -u -n -i bash -c 'ctr -n services.linuxkit tasks exec -t --exec-id '$$_dpid' docker sh -c '\''\
mkdir -p /var/jenkins_home /var/lib/jenkins/workspace /var/lib/jenkins/cache; \
docker volume list | grep jenkins-server-home      >/dev/null || docker volume create -o type=none -o o=bind -o device=/var/jenkins_home          --name jenkins-server-home;      \
docker volume list | grep jenkins-agent-workspace  >/dev/null || docker volume create -o type=none -o o=bind -o device=/var/lib/jenkins/workspace --name jenkins-agent-workspace;  \
docker volume list | grep jenkins-agent-cache      >/dev/null || docker volume create -o type=none -o o=bind -o device=/var/lib/jenkins/cache     --name jenkins-agent-cache       \
'\'; \

rm-volumes:
	for vol in jenkins-server-home jenkins-agent-workspace jenkins-agent-cache; do \
	    if docker volume list | grep $$vol >/dev/null; then docker volume rm $$vol; fi; \
	done
	if uname -s | grep Darwin > /dev/null; then \
	    _dpid=$(shell docker run --rm -i \
	        --privileged \
	        --pid=host \
	        debian \
	        nsenter -t 1 -m -u -n -i bash -c 'ctr -n services.linuxkit tasks ls | grep docker | awk '\''{print $$2}'\'); \
	    docker run --rm -it \
	        --privileged \
	        --pid=host \
	        debian \
	        nsenter -t 1 -m -u -n -i bash -c 'ctr -n services.linuxkit tasks exec -t --exec-id '$$_dpid' docker sh -c '\''\
rm -rf /var/jenkins_home /var/lib/jenkins/workspace /var/lib/jenkins/cache \
'\'; \
	fi

flush-agent-cache:
	_dpid=$(shell docker run --rm -i \
	    --privileged \
	    --pid=host \
	    debian \
	    nsenter -t 1 -m -u -n -i bash -c 'ctr -n services.linuxkit tasks ls | grep docker | awk '\''{print $$2}'\'); \
	docker run --rm -it \
	    --privileged \
	    --pid=host \
	    debian \
	    nsenter -t 1 -m -u -n -i bash -c 'ctr -n services.linuxkit tasks exec -t --exec-id '$$_dpid' docker sh -c '\''\
rm -rf /var/lib/jenkins/cache/* \
'\'; \
