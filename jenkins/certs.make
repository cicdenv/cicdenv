tls:
	mkdir -p "$(TLS_CONFIG)"
	openssl req \
	    -newkey rsa:2048 \
	    -nodes \
	    -keyout "$(TLS_CONFIG)/server-key.pem" \
	    -x509 \
	    -days 30 \
	    -out "$(TLS_CONFIG)/server-cert.pem" \
	    -subj "/C=US/ST=CA/L=San Francisco/O=cicdenv/OU=local/CN=localhost/emailAddress=jenkins@cicdenv.com" \
	    -reqexts SAN \
	    -extensions SAN \
	    -config <(cat /etc/ssl/openssl.cnf <(printf "\n[SAN]\nsubjectAltName=DNS:localhost,IP:127.0.0.1,IP:$(IP_ADDRESS),DNS:jenkins-server,DNS:builds-server\n")) \
	    -addext "basicConstraints=CA:TRUE"
	    -passin "pass:jenkins"
	openssl rsa \
	    -in "$(TLS_CONFIG)/server-key.pem" \
	    -out "$(TLS_CONFIG)/server-rsa.pem"
	openssl x509 \
	    -in "$(TLS_CONFIG)/server-cert.pem" \
	    -text \
	    -noout
	chmod o+r "$(TLS_CONFIG)/server-rsa.pem"
	openssl pkcs12 \
	    -export \
	    -out "$(TLS_CONFIG)/server.pfx" \
	    -inkey "$(TLS_CONFIG)/server-rsa.pem" \
	    -in "$(TLS_CONFIG)/server-cert.pem" \
	    -password "pass:jenkins"
	rm -f "$(TLS_CONFIG)/truststore.jks"
	cp "/usr/lib/jvm/java-11-openjdk/lib/security/cacerts" "$(TLS_CONFIG)/truststore.jks"
	chmod u+w "$(TLS_CONFIG)/truststore.jks"
	keytool -storepasswd \
	    -new "jenkins" \
	    -keystore "$(TLS_CONFIG)/truststore.jks" \
	    -storepass "changeit"
	keytool -import \
	    -file "$(TLS_CONFIG)/server-cert.pem" \
	    -alias "jenkins-server" \
	    -trustcacerts \
	    -noprompt \
	    -storepass "jenkins" \
	    -storetype "jks" \
	    -keystore "$(TLS_CONFIG)/truststore.jks"
	keytool -list -keystore "$(TLS_CONFIG)/truststore.jks" -storepass "jenkins"
	keytool -list -keystore "$(TLS_CONFIG)/truststore.jks" -storepass "jenkins" -rfc -alias "jenkins-server"

import-cert:
	if uname -s | grep Darwin > /dev/null; then \
	    sudo security add-trusted-cert \
	        -k /Library/Keychains/System.keychain \
	        -d "$(HOME)/.jenkins/tls/server-cert.pem"; \
	else \
	    if [ -x $(which certutil) ]; then \
	        certutil -d "sql:$(HOME)/.pki/nssdb" -D -n "jenkins-local" || true; \
	        certutil -d "sql:$(HOME)/.pki/nssdb" -A -t "C,," -n "jenkins-local" -i "$(HOME)/.jenkins/tls/server-cert.pem"; \
	        certutil -d "sql:$(HOME)/.pki/nssdb" -L; \
	    fi; \
	fi

print-server-cert:
	openssl s_client -showcerts -servername localhost -connect localhost:8443 </dev/null \
	| openssl x509 -text
