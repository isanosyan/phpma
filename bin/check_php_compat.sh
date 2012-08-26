#!/bin/bash

if [ -z "$1" ]; then
    path="./";
else
    path=$1;
fi

if [ -z "$2" ]; then
    me=`basename $0`;
    logfile="${me%.*}.log";
else
    logfile=$2;
fi

blacklist=( "gz" "js" "jar" "png" "gif" "ico" "jpg" "ttf" "css" "otf" "swf" "json" "flv" "fla" "zip" "eot" "woff" "svg" "ipa" "crx" "psd" "apk" "plist" "mobileprovision" "xml" "z" );

function in_array() {
    local x;
    ENTRY=$1
    shift 1
    ARRAY=( "$@" )
    [ -z "${ARRAY}" ] && return 0
    [ -z "${ENTRY}" ] && return 0
    for x in ${ARRAY[@]}; do
        [ "${x}" == "${ENTRY}" ] && return 1
    done
    return 0
}

rm -rf $logfile;
touch $logfile;

echo "`date +"%d.%m.%Y %T"`	##START##" >> $logfile;

for file in $( find $path -type f ); do
    now=`date +"%d.%m.%Y %T"`

    in_array ${file##*.} ${blacklist[@]};
    RET=$?

    if [ "${RET}" -eq 1 ] || [ $( echo $file | grep ".git" ) ]; then
        echo "$now	##FILE## SKIP	$file" >> $logfile;
    else
        echo "$now	##FILE## SNIFF	$file" >> $logfile;
        phpcs --standard=PHPCompatibility "$file" >> $logfile;
    fi
done

echo "`date +"%d.%m.%Y %T"`	##STOP##" >> $logfile;
