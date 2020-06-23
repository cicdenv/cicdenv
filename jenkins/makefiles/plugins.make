build-plugins: build-github-oauth-plugin

local-plugin-builder:
	printf "\
	FROM $(PLUGIN_BUILD_IMAGE)\n\
	RUN adduser -u $(user_id) -S $(user_name) -G root\n\
	ENV MAVEN_CONFIG /home/$(user_name)/.m2\n\
	"\
	| docker build -t "$(PLUGIN_BUILD_IMAGE)-local" -

m2:
	if [[ ! -d "$(CURDIR)/.m2" ]]; then mkdir -p "$(CURDIR)/.m2"; fi

build-github-oauth-plugin: local-plugin-builder m2
	if [[ ! -d images/server/plugins/github-oauth-plugin ]]; then \
	    git clone --depth 1 \
	        git@github.com:vogtech/github-oauth-plugin.git \
	        --branch JENKINS-43214 images/server/plugins/github-oauth-plugin; \
	else \
		(cd images/server/plugins/github-oauth-plugin; git pull origin master); \
	fi
	(cd images/server/plugins/github-oauth-plugin; \
	 time docker run -it --rm \
	     -v "$(CURDIR)/.m2:/home/$(user_name)/.m2" \
	     -v "$$(pwd):/project" \
	     -w /project \
	     -u $(user_name) \
	      $(PLUGIN_BUILD_IMAGE)-local \
	      mvn package)
