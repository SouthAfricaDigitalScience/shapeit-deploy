#!/bin/bash -e
. /etc/profile.d/modules.sh

module add ci
# these dudes don't really do version control :-/
# and they don't publish their source either.
SOURCE_FILE=${NAME}.${VERSION}.Linux.static.tgz

mkdir -p ${WORKSPACE}
mkdir -p ${SRC_DIR}
mkdir -p ${SOFT_DIR}

#  Download the prebuilt binary
if [ ! -e ${SRC_DIR}/${SOURCE_FILE}.lock ] && [ ! -s ${SRC_DIR}/${SOURCE_FILE} ] ; then
  touch  ${SRC_DIR}/${SOURCE_FILE}.lock
  echo "seems like this is the first build - let's geet the source"
  wget https://mathgen.stats.ox.ac.uk/genetics_software/shapeit/files/${NAME}/${SOURCE_FILE} -O ${SRC_DIR}/${SOURCE_FILE}
  echo "releasing lock"
  rm -v ${SRC_DIR}/${SOURCE_FILE}.lock
elif [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; then
  # Someone else has the file, wait till it's released
  while [ -e ${SRC_DIR}/${SOURCE_FILE}.lock ] ; do
    echo " There seems to be a download currently under way, will check again in 5 sec"
    sleep 5
  done
else
  echo "continuing from previous builds, using source at " ${SRC_DIR}/${SOURCE_FILE}
fi

mkdir -p ${WORKSPACE}/${NAME}
tar xzf  ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE}/${NAME}-${VERSION} --skip-old-files
cd ${WORKSPACE}/${NAME}-${VERSION}
#there are some examples in the 'examples' directory - try this ?
cd example
../bin/shapeit -B gwas -M genetic_map.txt -O gwas.phased --window 0.5
