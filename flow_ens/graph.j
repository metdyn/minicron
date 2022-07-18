#!/bin/bash 

# ---
# Usage:  
#   ./graph.j  NaN    df      1       2                 -1 
#              ck    git-df  submit  sub + mv graph     move graph

export cmd="source ./setconf.sh default_graph.yaml input_graph.yaml graph"
$cmd T0
$cmd T1
$cmd prefix_cycle_dir
$cmd d_mj_graph

base=/glade/scratch/$USER/br_autotest
dX0="${prefix_cycle_dir}$T0"
dX1="${prefix_cycle_dir}$T1"
f_an="analyze_config.py"

cd $d_mj_graph
#---- test .org exist ---- 
#
s="f_an "
for i in $s; do
  j=$( eval echo \$${i} )
  if [[ ! -f ${j}.org ]]; then
     echo "non-exist: ${j}.org"
     cp ${j}  ${j}.org
  else
     cp ${j}.org  ${j}
  fi
done


sed -i -e "s#T0=.*#T0= '$T0'#g"  \
    -e "s#T1=.*#T1= '$T1'#g"     \
    -e "s#dX0=.*#dX0= '$dX0'#g"  \
    -e "s#dX1=.*#dX1= '$dX1'#g"  \
    -e "s#user =.*#user = 'yonggangyu'#g" \
    -e "s#VerificationSpace = 'obs'.*#VerificationSpace = 'model'#g" \
    -e "s#dbConf\['cntrlExpName'\] =.*#dbConf\['cntrlExpName'\] = T0#g" \
    -e "s#dbConf\['lastCycleDTime'\].*#dbConf\['lastCycleDTime'\] = dt.datetime(2018,5,1,0,0,0)#g" \
    -e "s#dbConf\['expDirectory'\] =.*#dbConf\['expDirectory'\] = os.getenv('EXP_DIR','/glade/scratch/'+user+'/br_autotest')#g" \
    analyze_config.py
# git diff

echo "T0  = $T0"
echo "T1  = $T1"
echo "dX0 = $dX0"
echo "dX1 = $dX1"
echo "d_mj_graph = $d_mj_graph"
echo  "f_an = $f_an"

if [ $# -ge 1 ]; then
  if [ $1 == 'df' ]; then
    echo
    git diff 
  elif [ $1 -eq -1 ]; then
    mv mpas_analyses  $base/mpas_analyses_${T0}_vs_${T1}
  elif [ $1 -eq 1 ]; then
    python3 SpawnAnalyzeStats.py -d mpas
  #  /usr/bin/sleep 100m
  #  mv mpas_analyses  $base/mpas_analyses_${T0}_vs_${T1}
  elif [ $1 -eq 2 ]; then
    python3 SpawnAnalyzeStats.py -d mpas
    /usr/bin/sleep 150m
    mv mpas_analyses  $base/mpas_analyses_${T0}_vs_${T1}
  else
    echo "\$1 -ne -1, 1, 2,  Code Error ! Exit"
    exit
  fi
else
 echo
 #  git diff 
fi
