MAC_INTERFACE=en0
LINUX_INTERFACE=eno1

IP_ADDRESS=\
$(shell \
if uname -s | grep Darwin > /dev/null; \
then ipconfig getifaddr $(MAC_INTERFACE); \
else ip route get 1 | awk '{print $$(NF); exit}'; \
fi\
)

ip-address:
	@echo $(IP_ADDRESS)

update-hosts:
	if ! grep -E '$(IP_ADDRESS)\s+jenkins-server' /etc/hosts; then         \
	    sudo bash -c 'echo "$(IP_ADDRESS) jenkins-server" >> /etc/hosts';  \
	fi
	if ! grep -E '$(IP_ADDRESS)\s+builds-server' /etc/hosts; then          \
	    sudo bash -c 'echo "$(IP_ADDRESS) builds-server" >> /etc/hosts';   \
	fi
