#!/system/bin/sh
#Jancox-tool-Android
#by wahyu6070


#PATH
jancox=`dirname "$(readlink -f $0)"`
#functions
. $jancox/bin/jancox_functions
chmod -R 755 $bin
[ $(pwd) != $jancox ] && cd $jancox

for W777 in $TMP $EDITOR; do
 [ -d $W777 ] && del $W777 && cdir $W777 || cdir $W777
done

#
check_python

#input.zip
for ajax in $jancox /data/media/0 /data/media/0/Download; do
     if [ -f $ajax/input.zip ]; then
        input=$ajax/input.zip
        break
     fi;
done
clear
if [ ! -f $jancox/credits.txt ]; then
ERROR "Please dont delete credits"
fi
printmid "${Y}Jancox Tool by wahyu6070${W}"
printlog " "
printlog "       Unpack"
printlog " "
if [ $input ]; then
printlog "- Using input.zip from $input "
else
printlog "${R}- Input.zip not found "
printlog "- please add input.zip in /sdcard or $jancox/ ${W}"
fi

if [ $input ]; then
printlog "- Extracting input.zip..."
$BIN/unzip -o $input -d $TMP >> $LOG
listlog "$TMP"
fi

if [ -f $TMP/*.bin ]; then
printlog "- Extracting Payload.bin"
$PY $PYBIN/payload_dumper.py $TMP/*.bin --out $TMP >> $LOG
payloadbin=true
fi

if [ -f $TMP/system.new.dat.br ]; then
printlog "- Extraction system.new.dat.br... "
$BIN/brotli -d $TMP/system.new.dat.br -o $TMP/system.new.dat
del $TMP/system.new.dat.br $TMP/system.patch.dat
fi

if [ -f $TMP/product.new.dat.br ]; then
printlog "- Extraction product.new.dat.br... "
$BIN/brotli -d $TMP/system.new.dat.br -o $TMP/system.new.dat
del $TMP/product.new.dat.br $TMP/product.patch.dat
fi

if [ -f $TMP/vendor.new.dat.br ]; then
printlog "- Extraction vendor.new.dat.br... "
$BIN/brotli -d $TMP/vendor.new.dat.br -o $TMP/vendor.new.dat
del $TMP/vendor.new.dat.br $TMP/vendor.patch.dat
fi

if [ -f $TMP/system.new.dat ]; then
printlog "- Extraction system.new.dat... "
$PY $PYBIN/sdat2img.py $TMP/system.transfer.list $TMP/system.new.dat $TMP/system.img >> $LOG
del $TMP/system.new.dat $TMP/system.transfer.list
fi

if [ -f $TMP/product.new.dat ]; then
printlog "- Extraction product.new.dat... "
$PY $PYBIN/sdat2img.py $TMP/product.transfer.list $TMP/product.new.dat $TMP/product.img >> $LOG
del $TMP/product.new.dat $TMP/product.transfer.list
fi

if [ -f $TMP/vendor.new.dat ]; then
printlog "- Extraction vendor.new.dat... "
$PY $PYBIN/sdat2img.py $TMP/vendor.transfer.list $TMP/vendor.new.dat $TMP/vendor.img >> $LOG
del $TMP/vendor.new.dat $TMP/vendor.transfer.list
fi

if [ -f $TMP/system.img ]; then
printlog "- Extraction system.img... "
$PY $PYBIN/imgextractor.py $TMP/system.img $EDITOR/system >> $LOG
del $TMP/system.img
fi

if [ -f $TMP/product.img ]; then
printlog "- Extraction product.img... "
mv $TMP/product.img $TMP/system.img
$PY $PYBIN/imgextractor.py $TMP/system.img $EDITOR/product >> $LOG
del $TMP/system.img
fi

if [ -f $TMP/vendor.img ]; then
printlog "- Extraction vendor.img... "
$py $pybin/imgextractor.py $TMP/vendor.img $EDITOR/vendor >/dev/null
del $TMP/vendor.img
fi

if [ -f $TMP/boot.img ]; then
printlog "- Extraction boot.img"
$bin/magiskboot unpack $TMP/boot.img  2>> $LOG
cdir $EDITOR/boot
for MV_BOOT in ramdisk.cpio kernel kernel_dtb dtb second; do
[ -f $jancox/$MV_BOOT ] && mv -f $jancox/$MV_BOOT $EDITOR/boot/
sedlog "- Moving boot file $jancox/$MVBOOT to $EDITOR/boot/"
done
fi

[ -d $TMP/META-INF ] && mv -f $TMP/META-INF $EDITOR
[ -d $TMP/system ] && mv -f $TMP/system $EDITOR/system2
[ -d $TMP/firmware-update ] && mv -f $TMP/firmware-update $EDITOR
[ -d $TMP/install ] && mv -f $TMP/install $EDITOR
[ -f $TMP/boot.img ] && mv $TMP/boot.img $EDITOR/boot
[ -f $TMP/compatibility.zip ] && mv $TMP/compatibility.zip $EDITOR
[ -f $TMP/system_file_contexts ] && mv -f $TMP/system_file_contexts $EDITOR/system_file_contexts
[ -f $TMP/vendor_file_contexts ] && mv -f $TMP/vendor_file_contexts $EDITOR/vendor_file_contexts
[ -f $TMP/system_fs_config ] && mv -f $TMP/system_fs_config $EDITOR/system_fs_config
[ -f $TMP/vendor_fs_config ] && mv -f $TMP/vendor_fs_config $EDITOR/vendor_fs_config

test $payloadbin && del $TMP

if [ -f $EDITOR/system/build.prop ]; then
printlog "- Done "
printlog " "
rom-info $EDITOR > $editor/rom-info
elif [ -f $EDITOR/system/system/build.prop ]; then
printlog "- Done"
printlog " "
rom-info $EDITOR > $editor/rom-info
cat $EDITOR/rom-info
else
printlog "- Finished with the problem"
fi
