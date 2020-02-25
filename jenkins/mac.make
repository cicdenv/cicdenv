console:
	screen ~/Library/Containers/com.docker.docker/Data/vms/0/tty

host:
	docker run --rm -it \
	    --privileged \
	    --pid=host \
	    --env PS1=$(_PS1) \
	    debian \
	    nsenter -t 1 -m -u -n -i bash
