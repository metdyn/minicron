# step4.sh [ search valid date between 7 and 14 days, graph d2 vs d1 ]

mydate=$(date '+%Y-%m-%d')
base=/glade/scratch/$USER/br_autotest
d_build=${base}/build
d_s="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

d1=$(date '+%Y-%m-%d')
j=7
key="${USER}_3denvar-60-iter_OIE120km_WarmStart_br_"
while [ $j -le 14 ]; do
 d2=$(date --date="$j day  ago" +"%Y-%m-%d")
 f="$base/../${key}$d2/CyclingDA/2018050100/run/mem001/jedi.log"
 is=`grep "with status =" $f | cut -d= -f2` 
 j=$(( j+1 ))
 if [[ $is -eq 0 ]]; then  
   echo "d2=$d2 f=$f"
   echo "j=$j,  is=$is"
   break
 fi
done
if [ $j -gt 14 ]; then 
  echo "failed to find any successful dir"
  exit -1
fi

dX0=${key}$d2
dX1=${key}$d1
cd $d_s
cd graphics_March16
echo "dX0 dX1 = $dX0 $dX1"

sed -i -e "s#dX0 =.*#dX0 = '$dX0'#" \
       -e "s#dX1 =.*#dX1 = '$dX1'#" \
       analyze_config_mpas_yg.py

. /etc/profile.d/modules.sh
module load python/3.7.9
module load ncarenv
ncar_pylib
python SpawnAnalyzeStats.py -d mpas
sleep 10m
mv mpas_analyses   $base/mpas_analyses_${d1}_vs_${d2}
deactivate ncar_pylib

