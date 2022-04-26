# step3.sh [ use MPASWorkflow to submit cycle jobs ]

export PATH=$PATH:/opt/pbs/bin
mydate=$(date '+%Y-%m-%d')
#mydate="2022-03-21"
base=/glade/scratch/$USER/br_autotest/br_$mydate
d_build=${base}/build
d_s="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
d_flow=${d_s}/MPAS-Workflow
cd $d_flow
echo `pwd`
sed -i "s#commonBuild =.*#commonBuild = ${d_build}#g" $d_flow/config/builds.csh 
sed -i -e "s#ExpSuffix:.*#ExpSuffix: _br_${mydate}#" \
       -e "s#ParentDirectorySuffix:.*#ParentDirectorySuffix: br_autotest#" \
       $d_flow/scenarios/base/experiment.yaml
./drive.csh  &> ../out_cron_4_flow
