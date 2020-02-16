clean: stop-agent stop-server clean-server clean-agent #secrets-files

stop-agent:
	-@docker stop $$(docker ps -a -q -f name=jenkins-agent) &>/dev/null || true
	-@docker rm   $$(docker ps -a -q -f name=jenkins-agent) &>/dev/null || true

stop-server:
	-@docker stop $$(docker ps -a -q -f name=jenkins-server) &>/dev/null || true
	-@docker rm   $$(docker ps -a -q -f name=jenkins-server) &>/dev/null || true

clean-server:
	docker run --rm \
	    -v jenkins-server-home:/var/jenkins_home \
	    ubuntu \
	    bash -c "rm -rf /var/jenkins_home/*"

clean-agent:
	docker run --rm \
	    -v jenkins-agent-workspace:/var/lib/jenkins/workspace \
	    ubuntu \
	    bash -c "rm -rf /var/lib/jenkins/workspace/*"

clean-images:
	for image in $(SERVER_IMAGE_NAME)  \
	             jenkins-upstream      \
	             $(AGENT_IMAGE_NAME)   \
	; do  \
	    if [ "$$(docker images -q $$image | wc -l)" -gt 0 ]; then                 \
	        for img_id in $$(docker images -q $$image | uniq); do                 \
	            for dep_id in                                                     \
	                    $$(for id in $$(docker images -q); do                     \
	                        docker history $$id | grep -q $$img_id && echo $$id;  \
	                    done | sort -u); do                                       \
	                docker rmi --force $$dep_id;                                  \
	            done;                                                             \
	            docker rmi --force $$img_id;                                      \
	        done;                                                                 \
	    fi;                                                                       \
	done
