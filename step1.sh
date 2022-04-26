# - step1.sh [ br: layout, check out bundle, ecbuild ]
#
mydate=$(date '+%Y-%m-%d')
base=/glade/scratch/$USER/br_autotest/br_$mydate
mkdir -p $base; cd $base
#
ecbuild_option=""
if [[ ! -d mpas-bundle ]]; then
    echo " ! -d mpas-bundle "
    git clone  https://github.com/JCSDA-internal/mpas-bundle.git
fi
source  ./mpas-bundle/env-setup/gnu-openmpi-cheyenne.sh
mkdir -p build
cd build
ecbuild  $ecbuild_option  ../mpas-bundle  &> za
