import-cert:
	sudo security add-trusted-cert \
	    -k /Library/Keychains/System.keychain \
	    -d "$(HOME)/.jenkins/tls/server-cert.pem"; \
