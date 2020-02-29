#!/bin/bash
{
source lib.sh

thisArch="raspbian-lite"
imageSource="https://downloads.raspberrypi.org/raspbian_lite_latest"
zipName="raspbian_lite_latest"
imageName="2020-02-05-raspbian-buster-lite.img"



checkRoot ;



# Create caching folder hierarchy to work with this architecture.
setupWorkSpace $thisArch



# Download or copy the official image from cache
if [ ! -f ./cache/$thisArch/$imageName ]; then
	log "Downloading official image from internet."
	wget -P ./cache/$thisArch/  $imageSource
	7z e -o./cache/$thisArch/   ./cache/$thisArch/$zipName
	rm ./cache/$thisArch/$zipName

else
	log "Using official image from cache."

fi



# Copy image file to work folder add temporary space to it.
inflateImage $thisArch ./cache/$thisArch/$imageName ;



# copy ready image from cache to the work dir
cp -fv ./cache/$thisArch/$imageName-inflated ./work/$thisArch/$imageName



# Mount the image and make the binds required to chroot.
mountImageFile $thisArch ./work/$thisArch/$imageName



# Copy the lysmarine and origine OS config files in the mounted rootfs
addLysmarineScripts $thisArch



# Display build tips
echo "";echo "";echo "";echo "";echo "";
echo "========================================================================="
echo "You are now in the chroot environement.";
echo "Start the build script with by pasting one of the following line in the terminal:";
echo "";
echo "cd /lysmarine; ./build.sh 1 2 3 4 5 6 7 86 9"
echo "cd /lysmarine; ./build.sh ";
echo "========================================================================="
echo "";echo "";



# chroot into the
proot -q qemu-arm \
	--root-id \
	--rootfs=work/${thisArch}/rootfs \
	--cwd=/ \
	--mount=/etc/resolv.conf:/etc/resolv.conf \
	--mount=/dev:/dev \
	--mount=/sys:/sys \
	--mount=/proc:/proc \
	--mount=/tmp:/tmp \
	--mount=/run/shm:/run/shm \
	/bin/bash



# Unmount
umountImageFile $thisArch ./work/$thisArch/$imageName



# Renaming the OS and moving it to the release folder.
cp -v ./work/$thisArch/$imageName  ./release/$thisArch/LysMarine_$thisArch-0.9.0.img



log "Pro Tip:"
echo ""
echo "sudo cp -v ./release/$thisArch/LysMarine_$thisArch-0.9.0.img ./cache/$thisArch/$imageName-inflated"
echo ""
echo "sudo dd of=/dev/mmcblk0 if=./release/$thisArch/LysMarine_$thisArch-0.9.0.img status=progress"
echo ""
exit
}
