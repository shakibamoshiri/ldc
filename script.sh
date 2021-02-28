#!/bin/bash

################################################################################
# an associative array for storing color and a function for colorizing
################################################################################
declare -A _colors_;
_colors_[ 'red' ]='\x1b[1;31m';
_colors_[ 'green' ]='\x1b[1;32m';
_colors_[ 'yellow' ]='\x1b[1;33m';
_colors_[ 'cyan' ]='\x1b[1;36m';
_colors_[ 'reset' ]='\x1b[0m';

function colorize(){
    if [[ ${_colors_[ $1 ]} ]]; then
        echo -e "${_colors_[ $1 ]}$2${_colors_[ 'reset' ]}";
    else
        echo 'wrong color name!';
    fi
}


################################################################################
# __help function
################################################################################
function __help(){
    echo -e  " $0 help ...

 -h | --help            print this help

    | --os              OS actions ...
    |                   $(colorize 'cyan' 'type'): show / check the name
    |                   $(colorize 'cyan' 'version'): show / check the version
    |                   $(colorize 'cyan' 'update'): update the OS
    |                   $(colorize 'cyan' 'upgrade'): upgrade the OS
    |                   $(colorize 'cyan' 'info'): more info about OS

    | --docker          docker actions ...
    |                   $(colorize 'cyan' 'install'): try to install docker
    |                   $(colorize 'cyan' 'uninstall'): try to uninstall docker

    | --container       container actions ...
    |                   $(colorize 'cyan' 'install'): install a container

Company   Derak.Cloud
Developer Shakiba Moshiri
source    https://github.com/k-five/idac "

    exit 0;
}


################################################################################
# if there is no flags, prints help
################################################################################
if [[ $1 == "" ]]; then
    __help;
fi


function unknown_option(){
    echo "$(colorize red $1) is unknown option for $(colorize 'green' $2)";
    echo "Use '-h' or '--help' to see the available options";
    exit 1;
}


################################################################################
# main flags, both longs and shorts
################################################################################
ARGS=`getopt -o "h" -l "help,os:,docker:,container:" -- "$@"`
eval set -- "$ARGS"


################################################################################
# check OS name and version
################################################################################
declare -A  os_support;
os_support['centos']='centos';
os_support['debian']='debian';
os_support['ubuntu']='ubuntu';
os_support['arch']='arch';

os_release=$(tr A-Z a-z < /etc/os-* | egrep -io '(debian|ubuntu|centos|arch)' | uniq | head -n 1);
os_version=$(tr A-Z a-z < /etc/os-* | egrep -i 'version' | grep -Po '\d[^ "]*' | uniq | head -n 1);

declare -A _os
_os['flag']=0;
_os['action']='';

declare -A _docker;
_docker['flag']=0;
_docker['action']='';

declare -A _container;
_container['flag']=0;
_container['action']='';

while true ; do
    case "$1" in
        -h | --help )
            __help;
        ;;

        --os )
            _os['flag']=1;
            _os['action']=$2;
            shift 2;
        ;;

        --docker )
            _docker['flag']=1;
            _docker['action']=$2;
            shift 2;
        ;;

        --con | --container )
            _container['flag']=1;
            _container['action']=$2;
            shift 2;
        ;;


         --)
            shift;
            break;
         ;;

         *) echo "Internal error!" ; exit 1 ;;
    esac
done


################################################################################
# check and run _os action
################################################################################
if [[ ${_os['flag']} == 1 ]]; then
    case ${_os['action']} in
        type )
        
            echo $os_release
        ;;

        version )
            echo $os_version
        ;;

        update )
            echo 'os update'
        ;;

        info )
            cat /etc/os-*
        ;;
        
        * )
            unknown_option ${_os['action']} --os;
        ;;
    esac
fi

################################################################################
# check and run _docker action
################################################################################
if [[ ${_docker['flag']} == 1 ]]; then
    case ${_docker['action']} in
        install )
            echo "selecting ${_docker['action']}";
        ;;
        uninstall )
            echo "selecting ${_docker['action']}";
        ;;

        * )
            unknown_option ${_docker['action']} --docker;
        ;;
    esac
fi

################################################################################
# check and run _container action
################################################################################
if [[ ${_container['flag']} == 1 ]]; then
    case ${_container['action']} in
        install )
            echo "selecting ${_container['action']}";
        ;;

        * )
            unknown_option ${_container['action']} --container;
        ;;
    esac
fi