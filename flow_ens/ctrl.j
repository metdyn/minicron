# ---
# Usage:  
#   ./ctrl.j  NaN    df      1       
#              ck    git-df  submit


#!/bin/bash 

cwd=`pwd`
export cmd="source ./setconf.sh default.yaml input.yaml control"
$cmd compiler
$cmd flow
$cmd build
n=`echo $build | tr "/" "\n" | wc  | awk '{print $1}'`
n=$(( n-1 ))
suf=`echo $build | cut -d/ -f$n`
echo $suf

case="3denvar_OIE120km_WarmStart"
#case="3dvar_OIE120km_WarmStart"

fconf="$cwd/$flow/config/scenario.csh"
fexp="$cwd/$flow/scenarios/${case}.yaml"
frc="$cwd/$flow/include/tasks.rc"
fenv="$cwd/$flow/config/environmentJEDI.csh"

echo "flow = $flow"
echo "build= $build"
echo "suf  = $suf"
echo "case = $case"
echo "compiler = $compiler"
echo "fconf= $fconf"
echo "fexp = $fexp"
echo "frc  = $frc"
echo "fenv = $fenv"

#---- test .org exist ---- 
#
s="fconf fexp frc fenv" 
for i in $s; do
  j=$( eval echo \$${i} )
  if [[ ! -f ${j}.org ]]; then
     echo "non-exist: ${j}.org"
     cp ${j}  ${j}.org
  else
     cp ${j}.org  ${j}
  fi
done


sed -i "s# scenario =.*# scenario = $case#g" $fconf
grep -v -e "-m =" $frc > zb
mv zb $frc
#sed -i 's#-m =.*#-m =#g' $frc
sed -i "s#setenv BuildCompiler.*#setenv BuildCompiler '$compiler'#g" $fenv


grep -i -v -e workflow -e InitializationType $fexp > zb
cat >> zb << EOF
builds:
  commonBuild:  $build
experiment:
  ExpSuffix: '_$suf'
  ParentDirectorySuffix:  br_autotest
workflow:
  InitializationType: WarmStart
  initialCyclePoint: 20180414T18
  finalCyclePoint:   20180415T00
#  finalCyclePoint:   20180501T00
EOF
mv zb $fexp


cd $flow
if [ $# -ge 1 ]; then
  if [ $1 == 'df' ]; then
     git diff
  elif [ $1 -eq 1 ]; then

  # module purge
  # source  env-setup/cheyenne.sh
    ./drive.csh  &> ../out.flow_$suf
  else
    echo "\$1 -ne 1 or 'df',  error exit"
    exit
  fi
else
  echo
fi
