import-cert:
	certutil -d "sql:$(HOME)/.pki/nssdb" -D -n "jenkins-local" || true; \
	certutil -d "sql:$(HOME)/.pki/nssdb" -A -t "C,," -n "jenkins-local" -i "$(HOME)/.jenkins/tls/server-cert.pem"; \
	certutil -d "sql:$(HOME)/.pki/nssdb" -L; \
