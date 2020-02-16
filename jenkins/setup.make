# https://hub.docker.com/_/maven
# https://github.com/carlossg/docker-maven#running-as-non-root
local-plugin-builder:
	printf "\
	FROM $(PLUGIN_BUILD_IMAGE)\n\
	RUN adduser -u $(user_id) -S $(user_name) -G root\n\
	ENV MAVEN_CONFIG /home/$(user_name)/.m2\n\
	"\
	| docker build -t "$(PLUGIN_BUILD_IMAGE)-local" -

build-scriptler-plugin: local-plugin-builder
	if [[ ! -d server-image/plugins/scriptler-plugin ]]; then \
	    git clone --depth 1 git@github.com:jenkinsci/scriptler-plugin.git --branch master server-image/plugins/scriptler-plugin; \
	fi
	(cd server-image/plugins/scriptler-plugin; \
	 time docker run -it --rm \
	     -v $(CURDIR)/.m2:/home/$(user_name)/.m2 \
	     -v $$(pwd):/project \
	     -w /project \
	     -u $(user_name) \
	      $(PLUGIN_BUILD_IMAGE)-local \
	      mvn package)

volumes:
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
mkdir -p /var/jenkins_home /var/lib/jenkins/workspace /var/lib/jenkins/cache; \
docker volume list | grep jenkins-server-home      >/dev/null || docker volume create -o type=none -o o=bind -o device=/var/jenkins_home          --name jenkins-server-home;      \
docker volume list | grep jenkins-agent-workspace  >/dev/null || docker volume create -o type=none -o o=bind -o device=/var/lib/jenkins/workspace --name jenkins-agent-workspace;  \
docker volume list | grep jenkins-agent-cache      >/dev/null || docker volume create -o type=none -o o=bind -o device=/var/lib/jenkins/cache     --name jenkins-agent-cache       \
'\'; \
	else \
	    docker volume list | grep jenkins-server-home      >/dev/null || docker volume create -o type=none -o o=bind -o device=/var/jenkins_home          --name jenkins-server-home;      \
	    docker volume list | grep jenkins-agent-workspace  >/dev/null || docker volume create -o type=none -o o=bind -o device=/var/lib/jenkins/workspace --name jenkins-agent-workspace;  \
	    docker volume list | grep jenkins-agent-workspace  >/dev/null || docker volume create -o type=none -o o=bind -o device=/var/lib/jenkins/cache     --name jenkins-agent-cache;      \
	fi

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
rm -rf /var/lib/jenkins/cache/* \
'\'; \
	fi

network:
	if ! docker network inspect '$(DOCKER_NETWORK)' &>/dev/null; then \
	    docker network create '$(DOCKER_NETWORK)'; \
	fi
