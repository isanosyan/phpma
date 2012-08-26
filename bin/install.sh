# configuring paths
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";
CONFIG_PATH=$DIR"/../conf/";

# loading config
source $CONFIG_PATH"config";

# init local config file
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

    case $TYPE in
        string )
            read -p "Enter your $MESSAGE ("${!DEFAULT_NAME}" by default): " VALUE
            if [ "$VALUE" == "" ]; then
                VALUE=${!DEFAULT_NAME};
            fi
            ;;
        bool )
            while true; do
                read -p "$MESSAGE (y/n) " VALUE
                case $VALUE in
                    [Yy]* ) 
                        VALUE="true";
                        break;
                        ;;
                    [Nn]* )
                        VALUE="false";
                        break;
                        ;;
                esac
            done
            ;;
        * )
            echo "*";
            ;;
    esac

    sed -i "" "s|__REPLACE_"$VAR"|"$VALUE"|g" $LOCAL_CONFIG_FILE
}

configure string CODEBASE_PATH "local HuffPost codebase path";
configure string GIT_BRANCH "git branch";
configure bool GIT_PULL_BEFORE_RUN "Pull before analysis?";
