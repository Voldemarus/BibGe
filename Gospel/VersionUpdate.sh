#!/bin/sh

#  VersionUpdate.sh
#  Snapwit
#
#  Created by Водолазкий В.В. on 19.09.15.
#  Copyright © 2015 Pinwheel. All rights reserved.
#!/bin/sh

# Based on: http://habrahabr.ru/post/162575/

set -x

if [ -z "${PROJECT_DIR}" ]; then
PROJECT_DIR=`pwd`
fi

if [ -z "${PREFIX}" ]; then
PREFIX=""
fi

GIT_DIR="${PROJECT_DIR}/.git"

if [ -d "${GIT_DIR}" ]; then
	if [ -z "${GIT_BRANCH}" ]; then
		GIT_BRANCH="master"
	fi

	GIT_TAG=`xcrun git describe --tags`
	GIT_COMMIT_COUNT=`xcrun git rev-list ${GIT_TAG}..HEAD | wc -l | tr -d ' '`
	BUILD_NUMBER=`xcrun git rev-list ${GIT_BRANCH} | wc -l | tr -d ' '`
	BUILD_HASH=`xcrun git rev-parse --short --verify ${GIT_BRANCH} | tr -d ' '`
elif [ -d "${SVN_DIR}" ]; then

	BUILD_NUMBER=`xcrun svnversion -nc "${PROJECT_DIR}" | sed -e 's/^[^:]*://;s/[A-Za-z]//' | tr -d ' '`
	BUILD_HASH="${BUILD_NUMBER}"
else
	BUILD_NUMBER='100'
	BUILD_HASH='101'
fi

if [ -z "$1" ]; then
if [ "${BUILD_NUMBER}" == "${BUILD_HASH}" ]; then
echo "${BUILD_NUMBER}"
else
echo "${BUILD_NUMBER}/${BUILD_HASH}"
fi
else
echo "#define ${PREFIX}BUILD_NUMBER ${BUILD_NUMBER}" > $1
echo "#define ${PREFIX}BUILD_HASH @\"${BUILD_HASH}\"" >> $1
echo "#define ${PREFIX}PUBLIC_VERSION_NUMBER ${GIT_TAG}.${GIT_COMMIT_COUNT}" >> $1

find "${PROJECT_DIR}" -iname "*.plist" -maxdepth 1 -exec touch {} \;
fi
