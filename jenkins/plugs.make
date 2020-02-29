build-plugins: build-scriptler-plugin \
               build-github-oauth-plugin

local-plugin-builder:
	printf "\
	FROM $(PLUGIN_BUILD_IMAGE)\n\
	RUN adduser -u $(user_id) -S $(user_name) -G root\n\
	ENV MAVEN_CONFIG /home/$(user_name)/.m2\n\
	"\
	| docker build -t "$(PLUGIN_BUILD_IMAGE)-local" -

m2:
	if [[ ! -d "$(CURDIR)/.m2" ]]; then mkdir -p "$(CURDIR)/.m2"; fi

build-scriptler-plugin: local-plugin-builder m2
	if [[ ! -d server-image/plugins/scriptler-plugin ]]; then \
	    git clone --depth 1 \
	        git@github.com:jenkinsci/scriptler-plugin.git \
	        --branch master server-image/plugins/scriptler-plugin; \
	else \
		(cd server-image/plugins/scriptler-plugin; git pull origin master); \
	fi
	(cd server-image/plugins/scriptler-plugin; \
	 time docker run -it --rm \
	     -v "$(CURDIR)/.m2:/home/$(user_name)/.m2" \
	     -v "$$(pwd):/project" \
	     -w /project \
	     -u $(user_name) \
	      $(PLUGIN_BUILD_IMAGE)-local \
	      mvn package)

build-github-oauth-plugin: local-plugin-builder m2
	(cd server-image/plugins/github-oauth-plugin; \
	 time docker run -it --rm \
	     -v "$(CURDIR)/.m2:/home/$(user_name)/.m2" \
	     -v "$$(pwd):/project" \
	     -w /project \
	     -u $(user_name) \
	      $(PLUGIN_BUILD_IMAGE)-local \
	      mvn package)
