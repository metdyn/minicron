#!/bin/bash

pr_name="remove_geom_copy_July_12"

mydate=$(date '+%Y-%m-%d')
base=/glade/scratch/$USER/br_autotest/br_$mydate
d_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
min_hour=$(date --date 'now + 3 minutes' "+%M %H ")
day_of_week=$(date --date 'now + 3 minutes' "+%u ")
min_hour2=$(date --date 'now + 23 minutes' "+%M %H ")

#min_hour=$(date -v +10M "+%M %H ")  on Mac
#day_of_week=$(date -v +10M "+%u")  on Mac

nrepo=1
List[1]="internal/mpas-jedi.git: feature/geom_copy"
List[2]="internal/oops.git:  bugfix/lost_geometry"

#List[3]="internal/saber.git:  bugfix/atlas_backward_compatibility"
#List[3]="internal/oops.git:  feature/refactor_observer_params"
#List[5]="internal/ufo.git:  develop"

f="CMakeLists.txt"
cp ${f}.org $f
i=1
while [[ $i -le $nrepo ]]; do
 echo $i
 w=${List[$i]}
 name=`echo $w | cut -d: -f1`
 repo=`echo $w | cut -d: -f2`
# echo w=$w
# echo $name $repo
 sed -i -e "s#${name}.*#${name}\" BRANCH ${repo} UPDATE \)#g" $f
 i=$(( i+1 ))
done
diff ${f}.org $f



cat > crontab2.txt <<EOF
$min_hour  * *  $day_of_week  $d_here/step1.sh  $pr_name
$min_hour2 * *  $day_of_week  /opt/pbs/bin/qsub  ${d_here}/job_make_ctest2.scr
#crontab $d_here/crontab2.txt
EOF
cat crontab.txt   crontab2.txt  > crontab3.txt 
mv crontab3.txt crontab2.txt 


cat > job_make_ctest2.scr <<EOF
#!/bin/bash
#PBS -A NMMM0015
#PBS -l walltime=00:29:00
#PBS -l select=1:ncpus=16:mpiprocs=16
#PBS -N make_ctest
#PBS -q premium
#PBS -o p2.log 
#PBS -e p2.err
##PBS -j oe
$d_here/step2.sh $pr_name
EOF
