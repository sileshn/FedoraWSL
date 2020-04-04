OUT_ZIP=FedoraRawhide.zip
LNCR_EXE=Fedora.exe

DLR=curl
DLR_FLAGS=-L
LNCR_ZIP_URL=https://github.com/yuk7/wsldl/releases/download/20100500/icons.zip
LNCR_ZIP_EXE=Fedora.exe

all: $(OUT_ZIP)

zip: $(OUT_ZIP)
$(OUT_ZIP): ziproot
	@echo -e '\e[1;31mBuilding $(OUT_ZIP)\e[m'
	cd ziproot; zip ../$(OUT_ZIP) *

ziproot: Launcher.exe rootfs.tar.gz
	@echo -e '\e[1;31mBuilding ziproot...\e[m'
	mkdir ziproot
	cp Launcher.exe ziproot/${LNCR_EXE}
	cp rootfs.tar.gz ziproot/

exe: Launcher.exe
Launcher.exe: icons.zip
	@echo -e '\e[1;31mExtracting Launcher.exe...\e[m'
	unzip icons.zip $(LNCR_ZIP_EXE)
	mv $(LNCR_ZIP_EXE) Launcher.exe

icons.zip:
	@echo -e '\e[1;31mDownloading icons.zip...\e[m'
	$(DLR) $(DLR_FLAGS) $(LNCR_ZIP_URL) -o icons.zip

rootfs.tar.gz: rootfs
	@echo -e '\e[1;31mBuilding rootfs.tar.gz...\e[m'
	cd rootfs; sudo tar -zcpf ../rootfs.tar.gz `sudo ls`
	sudo chown `id -un` rootfs.tar.gz

rootfs: base.tar
	@echo -e '\e[1;31mBuilding rootfs...\e[m'
	mkdir rootfs
	sudo tar -xpf base.tar -C rootfs
	echo "# This file was automatically generated by WSL. To stop automatic generation of this file, remove this line." | sudo tee rootfs/etc/resolv.conf
	sudo chmod +x rootfs

base.tar:
	@echo -e '\e[1;31mExporting base.tar using docker...\e[m'
	docker run --name fedorawsl library/fedora:rawhide /bin/bash -c "rpm -Uvh http://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm; rpm -Uvh http://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm; dnf update -y; echo 'deltarpm=true' >> /etc/dnf/dnf.conf; dnf install -y flex openssl-devel elfutils-libelf-devel rsync perl bc hostname procps e2fsprogs passwd nano neofetch p7zip ImageMagick @development-tools android-tools automake bison bzip2 bzip2-libs ccache curl dpkg-dev gcc gcc-c++ gperf java-1.8.0-openjdk libstdc++.i686 libxml2-devel lz4-libs lzop make ncurses-compat-libs openssl-devel optipng pngcrush python2 python3 python3-mako python-mako python-networkx schedtool squashfs-tools syslinux-devel zip zlib-devel zlib-devel.i686; curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo; chmod a+x /usr/bin/repo; dnf clean all; pwconv; grpconv; chmod 0744 /etc/shadow; chmod 0744 /etc/gshadow;"
	docker export --output=base.tar fedorawsl
	docker rm -f fedorawsl

clean:
	@echo -e '\e[1;31mCleaning files...\e[m'
	-rm ${OUT_ZIP}
	-rm -r ziproot
	-rm Launcher.exe
	-rm icons.zip
	-rm rootfs.tar.gz
	-sudo rm -r rootfs
	-rm base.tar
	-docker rmi library/fedora:rawhide
