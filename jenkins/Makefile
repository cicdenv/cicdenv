include $(CURDIR)/vars.make

builds: build-server build-agent

UNAME=$(shell uname)
ifeq ($(UNAME), Linux)
    include $(CURDIR)/makefiles/linux/Makefile
endif
ifeq ($(UNAME), Darwin)
    include $(CURDIR)/makefiles/mac/Makefile
endif

include $(CURDIR)/makefiles/certs.make
include $(CURDIR)/makefiles/creds.make
include $(CURDIR)/makefiles/plugins.make
include $(CURDIR)/makefiles/build.make
include $(CURDIR)/makefiles/debug.make
include $(CURDIR)/makefiles/maint.make
include $(CURDIR)/makefiles/clean.make
include $(CURDIR)/makefiles/cli.make
