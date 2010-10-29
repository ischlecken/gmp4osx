#! /bin/bash
# Michael Aaron Safyan (michaelsafyan@gmail.com). Copyright (C) 2009. Simplified BSD License.

##
## Program: make-iphone-framework
## Authors: Michael Aaron Safyan
## Synopsis:
##       make-framework <name>
##       
## Description:
##       Constructs an iPhone framework "<name>.framework", that bundles
##       "lib<name>.a" and "<name>/*.h". The name that is given must not
##       start with the "lib" prefix. This utility will search the folders
##       "iphone-<sdkver>" and "iphone-simulator-<sdkver>" relative to the 
##       folders "/opt" and "/usr/local" for library "lib/lib<name>.a" and 
##       headers "include/name/*.h". The libraries for each architecture
##       will be merged via "lipo" into a universal binary, and the resulting
##       library and headers will be copied into the framework bundle. 
##

function create_folder()
{
    mkdir -p $@ >/dev/null 2>&1
}

function create_bundle_for_prefixes()
{
   local NAME="$1"
   local DEVICEPREFIX="$2"
   local SIMULATORPREFIX="$3"
   local OUTPUTDIR="$4"
   
   if [ ! \( -e "$DEVICEPREFIX/lib/lib$NAME.a" \) ] ; then
       return 1
   fi
   
   create_folder "$OUTPUTDIR/Libraries"
   
   if [ -e "$SIMULATORPREFIX/lib/lib$NAME.a" ] ; then
       lipo -create "$DEVICEPREFIX/lib/lib$NAME.a" "$SIMULATORPREFIX/lib/lib$NAME.a" -output "$OUTPUTDIR/Libraries/lib$NAME.a"
   else
       lipo -create "$DEVICEPREFIX/lib/lib$NAME.a" -output "$OUTPUTDIR/Libraries/lib$NAME.a"
   fi
   
   if [ -d "$DEVICEPREFIX/include/$NAME" ] ; then
       cp -rf "$DEVICEPREFIX/include/$NAME" "$OUTPUTDIR/Headers"
   elif [ -d "$SIMULATORPREFIX/include/$NAME" ] ; then
       cp -rf "$SIMULATORPREFIX/include/$NAME" "$OUTPUTDIR/Headers"
   fi
   return 0
}

function create_bundle_for_sdk()
{
   local NAME="$1"
   local SDKVER="$2"
   local OUTPUTDIR="$3"
   
   local prefix
   for prefix in "./build/debug" ; do
      if create_bundle_for_prefixes "$NAME" "$prefix-iphoneOS" "$prefix-iphoneSimulator" "$OUTPUTDIR" ; then
        return 0
      fi
   done
   return 1
}

function main()
{
    if [ $# -ne 1 ] ; then
       echo "Usage: make-framework <name>"
       echo "Note: <name> should not begin with 'lib'"
       exit 1
    fi
    
    local NAME="$1"
    
    if [ -d "$NAME.framework" ] ; then
       rm -rf "$NAME.framework"
    fi
    
    local sdkver
    for sdkver in 4.1 ; do
        if create_bundle_for_sdk "$NAME" "$sdkver" "$NAME.framework/SDKs/$sdkver" ; then
            (cd "$NAME.framework/SDKs" >/dev/null 2>&1; rm -f "Current"; ln -s "$sdkver" "Current")
        fi
    done

    if [ -d "$NAME.framework/SDKs/Current" ] ; then
        (cd "$NAME.framework" >/dev/null 2>&1; ln -s "SDKs/Current" "Home"; ln -s "Home/Headers" "Headers"; ln -s "Home/Libraries" "Libraries"; ln -s "Libraries/lib$NAME.a" "$NAME")
        echo "Created framework: \"$NAME.framework\""
    else
        echo "Unable to find libraries and headers for \"$NAME\"."
        echo "Note: the parameter to this utility should not contain a 'lib' prefix or '.a' suffix."
        exit 1
    fi
}

main $@
