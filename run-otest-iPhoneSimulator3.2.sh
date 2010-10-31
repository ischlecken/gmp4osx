#!/bin/sh

SDKROOT=/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator3.2.sdk
OTEST=${SDKROOT}/Developer/usr/bin/otest
BUILD_PRODUCTS_DIR=/Users/fe/Projects/osx/gmp/gmp4osx/build/Debug-iphonesimulator
DEVELOPER_LIBRARY_DIR=/Developer/Library

export DYLD_ROOT_PATH=${SDKROOT}
export DYLD_LIBRARY_PATH=${BUILD_PRODUCTS_DIR}:${SDKROOT}/usr/lib
export DYLD_FRAMEWORK_PATH=${BUILD_PRODUCTS_DIR}:${SDKROOT}/Developer/Library/Frameworks:${DEVELOPER_LIBRARY_DIR}/Frameworks
export DYLD_FORCE_FLAT_NAMESPACE=YES
export DYLD_NO_FIX_PREBINDING=YES
export DYLD_NEW_LOCAL_SHARED_REGIONS=YES
export OBJC_DISABLE_GC=YES
export IPHONE_SIMULATOR_ROOT=${SDKROOT}
export CFFIXED_USER_HOME="${HOME}/Library/Application Support/iPhone Simulator/User/"
#export DYLD_PRINT_ENV=YES
#export DYLD_PRINT_OPTS=YES

echo $OTEST -SenTest Self $BUILD_PRODUCTS_DIR/gmp-unittest.octest
$OTEST -SenTest Self $BUILD_PRODUCTS_DIR/gmp-unittest.octest
