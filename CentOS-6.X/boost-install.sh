#!/bin/sh


MAJOR_NUMBER=1
MINOR_NUMBER=55
REVISION_NUMBER=0


VERSION0=${MAJOR_NUMBER}.${MINOR_NUMBER}.${REVISION_NUMBER}
FILENAME=boost_${MAJOR_NUMBER}_${MINOR_NUMBER}_${REVISION_NUMBER}.tar.gz
PATHNAME=boost_${MAJOR_NUMBER}_${MINOR_NUMBER}_${REVISION_NUMBER}
echo "Upgrade gcc ${VERSION0}"

if [ ! -f ${FILENAME} ]; then

  wget https://jaist.dl.sourceforge.net/project/boost/boost/${VERSION0}/${FILENAME}

fi


if [ ! -x ${PATHNAME} ]; then
   tar vcpf ${FILENAME}
fi

cd ${PATHNAME}

ls
`pwd` ./bootstarp.sh 

./b2 install
