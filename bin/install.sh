# configuring paths
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
CONFIG_PATH=$DIR"/../conf/";

# loading config
source $CONFIG_PATH"config";

LOCAL_CONFIG_FILE=$CONFIG_PATH"local"

if [ -f $CONFIG_PATH"local" ]; then
    mv $LOCAL_CONFIG_FILE $LOCAL_CONFIG_FILE"-prev"
fi

cp $LOCAL_CONFIG_FILE"-dist" $LOCAL_CONFIG_FILE

function configure () {
    TYPE=$1
    VAR=$2
    MESSAGE=$3

    DEFAULT_NAME="DEFAULT_"$VAR;

    read -p "Enter your $MESSAGE ("${!DEFAULT_NAME}" by default): " VALUE
    if [ "$VALUE" == "" ]; then
        VALUE=${!DEFAULT_NAME};
    fi

    sed -i "" "s|__REPLACE_"$VAR"|"$VALUE"|g" $LOCAL_CONFIG_FILE
}

configure string CODEBASE_PATH "local HuffPost codebase path";
configure string GIT_BRANCH "git branch";
