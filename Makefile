extract:
	xorriso -osirrox on -indev "debian-live-12.5.0-amd64-gnome.iso" -extract / iso && chmod -R +w iso
	cp iso/live/filesystem.squashfs .
	sudo rm squashfs-root
	sudo unsquashfs filesystem.squashfs
chroot:
	sudo sh -c 'echo "nameserver 8.8.8.8" > ./squashfs-root/etc/resolv.conf'
	sudo chroot squashfs-root/
pack:
	rm live.iso
	sudo sh -c 'echo " " > ./squashfs-root/etc/resolv.conf'
	sudo mksquashfs  squashfs-root/ filesystem.squashfs -comp xz -b 1M -noappend
	cp filesystem.squashfs ./iso/live/filesystem.squashfs
	md5sum iso/.disk/info > iso/md5sum.txt
	sed -i 's|iso/|./|g' iso/md5sum.txt
	xorriso -as mkisofs -r -V "Debian live" -o live.iso -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin iso/boot iso

