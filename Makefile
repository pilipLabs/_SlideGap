.PHONY:create

# Package configuration
PACKAGE=net.pilip.labs.slidegap
PACKAGE_NAME=_SlideGap
PACKAGE_VERSION=0.1.0-alpha
PACKAGE_ACTIVITY=SlideGap
PACKAGE_AS_PATH=$(shell echo ${PACKAGE} | sed 's/\./\//g')
PACKAGE_ACTIVITY_PATH=./src/${PACKAGE_AS_PATH}/${PACKAGE_ACTIVITY}.java
PACKAGE_MANIFEST_PATH=./AndroidManifest.xml

# Android related
ANDROID_TARGET=2

# Phonegap related
PHONEGAP_PREFIX=./vendors/phonegap
PHONEGAP_VERSION=`cat ${PHONEGAP_PREFIX}/VERSION`


all:

create: android-create

banner:
	@echo +------------------------------------------------------------+
	@echo "  Package name: ${PACKAGE_NAME} ${PACKAGE_VERSION}"
	@echo "  Phonegap version ${PHONEGAP_VERSION}"
	@echo +------------------------------------------------------------+

android-create: banner
	@android -s create project  --target $(ANDROID_TARGET) \
						    --path . \
						    --package $(PACKAGE) \
						    --activity $(PACKAGE_ACTIVITY) 2> /dev/null;

	@cp -r $(PHONEGAP_PREFIX)/lib/android/example/phonegap/templates/project/* .
	@ln -f $(PHONEGAP_PREFIX)/lib/android/phonegap-$(PHONEGAP_VERSION).js  ./assets/www/phonegap.js
	@ln -f $(PHONEGAP_PREFIX)/lib/android/phonegap-$(PHONEGAP_VERSION).jar ./libs/phonegap-$(PHONEGAP_VERSION).jar

	@cat $(PHONEGAP_PREFIX)/lib/android/example/phonegap/templates/Activity.java > $(PACKAGE_ACTIVITY_PATH)

	@find "$(PACKAGE_ACTIVITY_PATH)" | xargs grep '__ACTIVITY__' -sl | xargs -L1 sed -i -e "s/__ACTIVITY__/$(PACKAGE_ACTIVITY)/g"
	@find "$(PACKAGE_ACTIVITY_PATH)" | xargs grep '__ID__' -sl | xargs -L1 sed -i -e "s/__ID__/$(PACKAGE)/g"
	@find "$(PACKAGE_MANIFEST_PATH)" | xargs grep '__ACTIVITY__' -sl | xargs -L1 sed -i -e "s/__ACTIVITY__/$(PACKAGE_ACTIVITY)/g"
	@find "$(PACKAGE_MANIFEST_PATH)" | xargs grep '__PACKAGE__' -sl | xargs -L1 sed -i -e "s/__PACKAGE__/$(PACKAGE)/g"

	@echo "$(PACKAGE_VERSION)" > VERSION
