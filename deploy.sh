#!/bin/bash -e
# this should be run after check-build finishes.
. /etc/profile.d/modules.sh
echo ${SOFT_DIR}
module add deploy
echo ${SOFT_DIR}
cd ${WORKSPACE}/
echo "All tests have passed, will now build into ${SOFT_DIR}"
mkdir -p ${SOFT_DIR}

echo "Creating the modules file directory ${LIBRARIES_MODULES}"
mkdir -p ${BIOINFORMATICS_MODULES}/${NAME}
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION : See https://github.com/SouthAfricaDigitalScience/gmp-deploy"
setenv SHAPEIT_VERSION       $VERSION
setenv SHAPEIT_DIR           $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path PATH            $::env(SHAPEIT_DIR)/bin
MODULE_FILE
) > ${BIOINFORMATICS_MODULES}/${NAME}/${VERSION}


module avail ${NAME}
module add ${NAME}
