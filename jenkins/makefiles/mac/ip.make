MAC_INTERFACE=en9

IP_ADDRESS=$(shell ipconfig getifaddr $(MAC_INTERFACE))
UNSECURE_URL=http://$(IP_ADDRESS):$(HTTP_PORT)
SERVER_URL=https://$(IP_ADDRESS):$(HTTPS_PORT)

ip-address:
	@echo $(IP_ADDRESS)
