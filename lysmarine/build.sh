#! /bin/bash -e
source ./config ;

echo "";
echo "Install script for Lysmarine :)"
echo "";


## Check variable declaration
if [[ -z $LMARCH ]];then
  export LMARCH="$(dpkg --print-architecture)"
fi
echo "Architecture : $LMARCH"

if [[ -z $LMOS ]];then
  export LMOS="$(lsb_release -id -s | head -1)"
fi
echo "Base OS : $LMOS"

if [[ -z $LMBUILD ]];then
  echo ''
  echo '*DEPRICATED*'
  echo "variable $LMBUILD is not set, choices are: "
  echo ''
  echo "export LMBUILD=debian-vbox"
  echo "export LMBUILD=raspbian"
  echo "export LMBUILD=armbian-pineA64"
  echo "export LMBUILD=debian-64"
  echo ''
  exit
fi
echo "Build tag : $LMBUILD"



## This help making less noice in cross-build environment. 
export LANG="en_US.UTF-8"
export LANGUAGE=en_US:en
export LC_NUMERIC="C"
export LC_CTYPE="C"
export LC_MESSAGES="C"
export LC_ALL="C"



## If no build stage is provided, build all stages.
if [ "$#" -gt "0" ]; then
  stageList="$@"
else
  stageList="*" 
fi


## Loop stages.
for number in $stageList; do
  for stage in ./$number*; do
    if [ -d $stage ]; then
      if [ -f $stage/run.sh ]; then
        echo '';
        echo '==========================================';
        echo "From request $number "
        echo "Running stage $stage/run.sh"
        echo '==========================================';
        echo '';

        export FILE_FOLDER=$stage/files/
       
        # [[ $? -ne 0 ]] && exit # Exit if non-zero exit code
        $stage/run.sh 2>&1 | tee "logs/$stage.log"
         echo "===========>>> Stage returned the status $?"
      fi
    fi
  done
done


echo "";
echo "Done Installing script for Lysmarine $ARCH :)"
echo "";