# GNU make is required to run this file. To install on *BSD, run:
#   gmake PREFIX=/usr/local install

PREFIX ?= /usr
IGNORE ?=
THEMES ?= color-schemes plasma wallpapers

# excludes IGNORE from THEMES list
THEMES := $(filter-out $(IGNORE), $(THEMES))

# Define the directory containing the source images
SRC_DIR := ./wallpapers/Crowded/source

# Define output directory
BUILD_DIR := ./wallpapers/Crowded/contents/images

# Define image sizes for different orientations
HORIZONTAL_SIZES := 5120x2880 3840x2160 3200x2000 3200x1800 2560x1600 2560x1440 1920x1200 1920x1080 1680x1050 1600x1200 1440x900 1366x768 1280x1024 1280x800 1024x768 800x600 440x247
VERTICAL_SIZES := 2880x5120 2160x3840 2000x3200 1800x3200 1600x2560 1440x2560 1200x1920 1080x1920 1050x1680 1200x1600 900x1440 768x1366 1024x1280 800x1280 768x1024 600x800 247x440

.PHONY: preprocess_images install


# Target for preprocessing images
preprocess_images:
	mkdir -p $(BUILD_DIR)
	for inputFile in $(SRC_DIR)/*.png; do \
		filename=$$(basename "$$inputFile" .png); \
		for res in $(HORIZONTAL_SIZES); do \
			outputFile="$(BUILD_DIR)/$${res}.png"; \
			if [ ! -f "$$outputFile" ]; then \
				convert "$$inputFile" -resize "$$res"^ -gravity center -extent "$$res" "$$outputFile"; \
			fi; \
		done; \
		for res in $(VERTICAL_SIZES); do \
			outputFile="$(BUILD_DIR)/$${res}.png"; \
			if [ ! -f "$$outputFile" ]; then \
				convert "$$inputFile" -resize "$$res"^ -gravity center -extent "$$res" "$$outputFile"; \
			fi; \
		done; \
	done

all:

install: 
	mkdir -p $(DESTDIR)$(PREFIX)/share
	cp -R $(THEMES) $(DESTDIR)$(PREFIX)/share
	rm -rf $(DESTDIR)$(PREFIX)/share/wallpapers/Crowded/source $(DESTDIR)$(PREFIX)/share/wallpapers/Crowded/crop_wallpaper.sh
	cp -R wallpapers $(DESTDIR)$(PREFIX)/share/plasma/desktoptheme/BigBother/
	cp -R wallpapers $(DESTDIR)$(PREFIX)/share/plasma/look-and-feel/com.github.bigbotherlinux.kde-theme/

uninstall:
	-rm -rf $(DESTDIR)$(PREFIX)/share/aurorae/themes/Arc
	-rm -rf $(DESTDIR)$(PREFIX)/share/aurorae/themes/Arc-Dark
	-rm -r  $(DESTDIR)$(PREFIX)/share/color-schemes/BigBother.colors
	-rm -r  $(DESTDIR)$(PREFIX)/share/konsole/Arc.colorscheme
	-rm -r  $(DESTDIR)$(PREFIX)/share/konsole/ArcDark.colorscheme
	-rm -rf $(DESTDIR)$(PREFIX)/share/konversation/themes/papirus
	-rm -rf $(DESTDIR)$(PREFIX)/share/konversation/themes/papirus-dark
	-rm -rf $(DESTDIR)$(PREFIX)/share/Kvantum/Arc
	-rm -rf $(DESTDIR)$(PREFIX)/share/Kvantum/ArcDark
	-rm -rf $(DESTDIR)$(PREFIX)/share/Kvantum/ArcDarker
	-rm -rf $(DESTDIR)$(PREFIX)/share/plasma/desktoptheme/BigBother
	-rm -rf $(DESTDIR)$(PREFIX)/share/plasma/look-and-feel/com.github.bigbotherlinux.kde-theme
	-rm -rf $(DESTDIR)$(PREFIX)/share/wallpapers/BigBother

_get_version:
	$(eval VERSION := $(shell git show -s --format=%cd --date=format:%Y%m%d HEAD))
	@echo $(VERSION)

dist: _get_version
	git archive --format=tar.gz -o $(notdir $(CURDIR))-$(VERSION).tar.gz master -- $(THEMES)

release: _get_version
	git tag -f $(VERSION)
	git push origin
	git push origin --tags

undo_release: _get_version
	-git tag -d $(VERSION)
	-git push --delete origin $(VERSION)


.PHONY: all install uninstall _get_version dist release undo_release

# .BEGIN is ignored by GNU make so we can use it as a guard
.BEGIN:
	@head -3 Makefile
	@false
