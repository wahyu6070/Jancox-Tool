#!/system/bin/sh
#Jancox-Tool-Android
#by wahyu6070


#PATH
jancox=`dirname "$(readlink -f $0)"`
#functions
. $jancox/bin/jancox_functions

clear
[ $(pwd) != $jancox ] && cd $jancox
del $LOG
if [ ! -d $EDITOR/system ]; then 
ERROR " Please Unpack"
fi
for W7878 in $TMP $EDITOR; do
test ! -d $W7878 && cdir $W7878
done

check_python

printmid "${Y}Jancox Tool by wahyu6070${W}"
printlog "       Repack "
printlog " "
rom_info $EDITOR
printlog " "

if [[ $(get_config set.time) == true ]]; then
setime -r $EDITOR/system $(getp setime.date)
setime -r $EDITOR/vendor $(getp setime.date)
fi

if [ -d $EDITOR/system9 ]; then
printlog "- Repack system"
if [ -f $EDITOR/system/system/build.prop ]; then
SYSDIR=$EDITOR/system/system
else
SYSDIR=$EDITOR/system
fi
	if [ -f $SYSDIR/etc/selinux/plat_file_contexts ]; then
	[ -f "$TMP/system_file_contexts" ] && del "$TMP/system_file_contexts"
	echo "/firmware(/.*)?         u:object_r:firmware_file:s0" >> "$TMP/system_file_contexts"
    echo "/bt_firmware(/.*)?      u:object_r:bt_firmware_file:s0" >> "$TMP/system_file_contexts"
    echo "/persist(/.*)?          u:object_r:mnt_vendor_file:s0" >> "$TMP/system_file_contexts"
    echo "/dsp                    u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/oem                    u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/op1                    u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/op2                    u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/charger_log            u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/audit_filter_table     u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/keydata                u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/keyrefuge              u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/omr                    u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/publiccert.pem         u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/sepolicy_version       u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/cust                   u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/donuts_key             u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/v_key                  u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/carrier                u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/dqmdbg                 u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/ADF                    u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/APD                    u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/asdf                   u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/batinfo                u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/voucher                u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/xrom                   u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/custom                 u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/cpefs                  u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/modem                  u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/module_hashes          u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/pds                    u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/tombstones             u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/factory                u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/oneplus(/.*)?          u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/addon.d                u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/op_odm                 u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    echo "/avb                    u:object_r:rootfs:s0" >> "$TMP/system_file_contexts"
    cat $SYSDIR/etc/selinux/plat_file_contexts >> "$TMP/system_file_contexts"
    SYSTEM_FILE_CONTEXTS="$TMP/system_file_contexts"
	elif [ -f $EDITOR/system_file_contexts ]; then
		SYSTEM_FILE_CONTEXTS=$EDITOR/system_file_contexts
	else
		ERROR "system file contexts not found"
	fi
	if [ -f $EDITOR/system_size.txt ]; then
		SYSTEM_SIZE=`cat $EDITOR/system_size.txt`
	else
		SYSTEM_SIZE=`$BIN/busybox du -sk $EDITOR/system | $BIN/busybox awk '{$1*=1024;$1=int($1*1.05);printf $1}'`
	fi
$BIN/make_ext4fs -T 0 -S $SYSTEM_FILE_CONTEXTS -l $SYSTEM_SIZE -L system -a system -s $TMP/system.img $EDITOR/system
[ -f "$TMP/system_file_contexts" ] && del "$TMP/system_file_contexts"
sedlog "System size = $SYSTEM_SIZE"
fi

if [ -d $EDITOR/vendor ]; then
	printlog "- Repack vendor"
	if [ -f $EDITOR/vendor_file_contexts ]; then
		VENDOR_FILE_CONTEXTS=$EDITOR/vendor_file_contexts
	elif [ -f $EDITOR/vendor/etc/selinux/vendor_file_contexts ]; then
		[ -f "$TMP/vendor_file_contexts" ] && del "$TMP/vendor_file_contexts"
		cat $EDITOR/vendor/etc/selinux/vendor_file_contexts >> "$TMP/vendor_file_contexts"
    	VENDOR_FILE_CONTEXTS="$TMP/vendor_file_contexts"
	else
		ERROR "vendor file contexts not found"
	fi
	if [ -f $EDITOR/vendor_size.txt ]; then
		VENDOR_SIZE=`cat $EDITOR/vendor_size.txt`
	else
		VENDOR_SIZE=`$BIN/busybox du -sk $EDITOR/vendor | $BIN/busybox awk '{$1*=1024;$1=int($1*1.05);printf $1}'`
	fi
$BIN/make_ext4fs -T 0 -S $VENDOR_FILE_CONTEXTS -l $VENDOR_SIZE -L vendor -a vendor -s $TMP/vendor.img $EDITOR/vendor
#[ -f "$TMP/vendor_file_contexts" ] && del "$TMP/vendor_file_contexts"
sedlog "Vendor size = $VENDOR_SIZE"
fi;


if [ -f $TMP/system.img ] && [ $(get_config compress.dat) = true ]; then
printlog "- Repack system.img"
[ -f $TMP/system.new.dat ] && rm -rf $TMP/system.new.dat
$PY $PYBIN/img2sdat.py $TMP/system.img -o $TMP -v 4 >> $LOG
[ -f $TMP/system.img ] && rm -rf $TMP/system.img
fi

if [ -f $TMP/vendor.img ] && [ $(get_config compress.dat) = true ]; then
printlog "- Repack vendor.img"
[ -f $TMP/vendor.new.dat ] && rm -rf $TMP/vendor.new.dat
$PY $PYBIN/img2sdat.py $TMP/vendor.img -o $TMP -v 4 -p vendor >> $LOG
[ -f $TMP/vendor.img ] && rm -rf $TMP/vendor.img
fi

#level brotli
case $(get_config brotli.level) in
1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 ) brlvl=`get_config brotli.level`
;;
*) brlvl=1
;;
esac
exit 0
sedlog "- Brotli level : $brlvl"
if [ -f $TMP/system.new.dat ]; then
printlog "- Repack system.new.dat"
[ -f $TMP/system.new.dat.br ] && rm -rf $TMP/system.new.dat.br
$BIN/brotli -$brlvl -j -w 24 $TMP/system.new.dat >> $LOG
fi

if [ -f $TMP/vendor.new.dat ]; then
[ -f $TMP/vendor.new.dat.br ] && rm -rf $TMP/vendor.new.dat.br
printlog "- Repack vendor.new.dat"
$BIN/brotli -$brlvl -j -w 24 $TMP/vendor.new.dat >> $LOG
fi

if [ -d $EDITOR/boot ] && [ -f $EDITOR/boot/boot.img ]; then
printlog "- Repack boot"
for BOOT_FILES in kernel kernel_dtb ramdisk.cpio second; do
[ -f $EDITOR/boot/$BOOT_FILES ] && cp -f $EDITOR/boot/$BOOT_FILES $jancox
sedlog "- Moving boot file $EDITOR/boot/$BOOT_FILES to $jancox"
done
$BIN/magiskboot repack $EDITOR/boot/boot.img 2>> $LOG
sleep 1s
[ -f $jancox/new-boot.img ] && mv -f $jancox/new-boot.img $TMP/boot.img
for RM_BOOT_FILES in kernel kernel_dtb ramdisk.cpio second; do
test -f $jancox/$RM_BOOT_FILES && del $jancox/$RM_BOOT_FILES
sedlog "- Removing boot file $janxoz$RM_BOOT_FILES"
done
fi

[ -d $EDITOR/META-INF ] && cp -a $EDITOR/META-INF $TMP/
[ -d $EDITOR/install ] && cp -a $EDITOR/install $TMP/
[ -d $EDITOR/system2 ] && cp -a $EDITOR/system2 $TMP/system
[ -d $EDITOR/firmware-update ] && cp -a $EDITOR/firmware-update $TMP/
[ -f $EDITOR/compatibility.zip ] && cp -f $EDITOR/compatibility.zip $TMP/
[ -f $EDITOR/compatibility_no_nfc.zip ] && cp -f $EDITOR/compatibility_no_nfc.zip $TMP/

if [ -d $TMP/META-INF ] && [ $(get_config zipping) = true ]; then
printlog "- Zipping"
ZIPNAME=`echo "new-rom_$(date +%Y-%m-%d)"`
[ $(get_config zip.level) -le 9 ] && ZIPLEVEL=`get_config zip.level` || ZIPLEVEL=1
[ -f ${ZIPNAME}.zip ] && del ${ZIPNAME}.zip
cd $TMP
$BIN/zip -r${ZIPLEVEL} $jancox/"${ZIPNAME}.zip" . >> $loglive || sedlog "Failed creating $jancox/${zipname}.zip"
sedlog "ZIP NAME  : ${ZIPNAME}.zip"
sedlog "ZIP LEVEL : ${ZIPLEVEL}"
cd $jancox
fi


if [ -f "${ZIPNAME}.zip" ]; then
      printlog "- Repack done"
      del $TMP
else
      printlog "- Repack error"
      del $TMP
fi

clog

