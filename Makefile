OUT_ZIP=FedoraRawhide.zip
LNCR_EXE=Fedora.exe

DLR=curl
DLR_FLAGS=-L
LNCR_ZIP_URL=https://github.com/yuk7/wsldl/releases/download/21071600/icons.zip
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
	@echo "# This file was automatically generated by WSL. To stop automatic generation of this file, remove this line." | sudo tee rootfs/etc/resolv.conf > /dev/null
	sudo chmod +x rootfs

base.tar:
	@echo -e '\e[1;31mExporting base.tar using docker...\e[m'
	docker run --name fedorawsl library/fedora:rawhide /bin/bash -c "rpm --import https://src.fedoraproject.org/rpms/fedora-repos/blob/rawhide/f/RPM-GPG-KEY-fedora-35-primary; dnf update -y --enablerepo=rawhide fedora-gpg-keys --release 34; dnf install -y dnf-plugins-core; dnf config-manager --set-disabled fedora-cisco-openh264; echo 'deltarpm=true' >> /etc/dnf/dnf.conf; echo 'fastestmirror=1' >> /etc/dnf/dnf.conf; dnf --refresh --allowerasing update -y; dnf install -y deltarpm rng-tools pinentry libxcrypt-compat cracklib-dicts flex openssl-devel elfutils-libelf-devel rsync perl bc hostname procps e2fsprogs passwd nano neofetch p7zip p7zip-plugins ImageMagick @development-tools android-tools automake bison bzip2 bzip2-libs ccache curl dpkg-dev gcc gcc-c++ gperf libstdc++.i686 libxml2-devel lz4-libs lzop make ncurses-compat-libs openssl openssl-devel optipng pngcrush python python2 python3 schedtool squashfs-tools syslinux-devel zip zlib-devel zlib-devel.i686; dnf clean all; pwconv; grpconv; chmod 0744 /etc/shadow; chmod 0744 /etc/gshadow;"
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
