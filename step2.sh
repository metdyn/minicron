# step2.sh [ make_ctest.sh   make -j 24; ctest ]

mydate=$(date '+%Y-%m-%d')
base=/glade/scratch/$USER/br_autotest/br_$mydate
[[ $# -ge 1 ]] && base=/glade/scratch/$USER/br_autotest/br_$1
mkdir -p $base; cd $base
#
source  ./mpas-bundle/env-setup/gnu-openmpi-cheyenne.sh
f=z.ctest.all
cd build
make -j16 &> zb
cd mpas-jedi
ctest -VV &> $f
w=`grep -i "tests passed" $f`
tail -20 $f | mail -s "$w : $base" $USER@ucar.edu


#
# analysis step
if [[ -f "$base/build/bin/mpasjedi_variational.x" ]]; then
 is=0; s="success"
else
 is=1; s="fail"
fi
note="build = $s"
echo "$mydate $note" | mail -s "$mydate mpas-bundle cron: $note" $USER@ucar.edu
#
# check hash number for git tag
f="CMakeLists.txt"
cd $base/mpas-bundle
cp -rp $f $f.org
source .github/stable_mark.sh
mv $f  $base/../${f}_${mydate}_$s
cp -rp $f.org $f
