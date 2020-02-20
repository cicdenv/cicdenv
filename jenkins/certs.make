tls:
	mkdir -p "$(TLS_CONFIG)"
	openssl req \
	    -newkey rsa:2048 \
	    -nodes \
	    -keyout "$(TLS_CONFIG)/server-key.pem" \
	    -x509 \
	    -days 36500 \
	    -out "$(TLS_CONFIG)/server-cert.pem" \
	    -subj "/C=US/ST=CA/L=San Francisco/O=cicdenv/OU=local/CN=localhost/emailAddress=jenkins@cicdenv.com" \
	    -reqexts SAN \
	    -extensions SAN \
	    -config <(cat /etc/ssl/openssl.cnf <(printf "\n[SAN]\nsubjectAltName=DNS:localhost,DNS:127.0.0.1,DNS:jenkins-server\n")) \
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
	rm -f "$(TLS_CONFIG)/agent-truststore.jks"
	keytool -import \
	    -file "$(TLS_CONFIG)/server-cert.pem" \
	    -alias "jenkins-server" \
	    -trustcacerts \
	    -noprompt \
	    -storepass "jenkins" \
	    -storetype "jks" \
	    -keystore "$(TLS_CONFIG)/agent-truststore.jks"
	keytool -list -keystore "$(TLS_CONFIG)/agent-truststore.jks" -storepass jenkins
	keytool -list -keystore "$(TLS_CONFIG)/agent-truststore.jks" -storepass jenkins -rfc -alias "jenkins-server"

print-server-cert:
	openssl s_client -showcerts -servername localhost -connect localhost:8443 </dev/null \
	| openssl x509 -text
