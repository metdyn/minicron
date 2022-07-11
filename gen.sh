mydate=$(date '+%Y-%m-%d')
base=/glade/scratch/$USER/br_autotest/br_$mydate
d_here="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cat > crontab.txt <<EOF
08 12 * * 1,2,3,4,5,6  $d_here/step1.sh
25 12 * * 1,2,3,4,5,6  /opt/pbs/bin/qsub ${d_here}/job_make_ctest.scr
00 13 * * 2,3,4,5           $d_here/step3.sh &> $d_here/out.3
00 23 * * 2,3,4,5           $d_here/step4.sh &> $d_here/out.4
#
#crontab $d_here/crontab.txt
EOF

cat > job_make_ctest.scr <<EOF
#!/bin/bash
#PBS -A NMMM0015
#PBS -l walltime=00:55:00
#PBS -l select=1:ncpus=16:mpiprocs=16
#PBS -N make_ctest
#PBS -q premium
#PBS -o p2.log 
#PBS -e p2.err
##PBS -j oe
$d_here/step2.sh
EOF
