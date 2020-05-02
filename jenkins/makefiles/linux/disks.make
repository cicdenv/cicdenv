volumes:
	docker volume list | grep jenkins-server-home      >/dev/null || docker volume create --name jenkins-server-home;      \
	docker volume list | grep jenkins-agent-workspace  >/dev/null || docker volume create --name jenkins-agent-workspace;  \
	docker volume list | grep jenkins-agent-cache      >/dev/null || docker volume create --name jenkins-agent-cache;      \

rm-volumes:
	for vol in jenkins-server-home jenkins-agent-workspace jenkins-agent-cache; do \
	    if docker volume list | grep $$vol >/dev/null; then docker volume rm $$vol; fi; \
	done
