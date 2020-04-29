#!/bin/bash
set -e

usage() { 
    cat <<EOF
Generate deploy script for new kubeflow instance with specified parameters.

usage: ${0} [OPTIONS]

The following flags are required.
    
    --namespace       namespace of kubeflow instance
    --user            user name used in default login(without@kubeflow.org)
    --passwd          user login password  
EOF
    exit 1
}

while [[ $# -gt 0 ]]; do
    case ${1} in
	    --namespace)
            namespace="$2"
	    shift
	    ;;
        --user)
            user="$2"
	    shift
	    ;;
        --passwd)
            passwd="$2"
	    shift
	    ;;
        *)
            usage
	    ;;
    esac
    shift
done

if [ -z ${namespace} ]; then
       echo "must provide namespace"
       exit 1
fi       

[ -z ${user} ] && user=admin
[ -z ${passwd} ] && passwd='$2y$12$ruoM7FqXrpVgaol44eRZW.4HWS8SAvg6KYVVSCIwKQPBmTpCm.EeO'

cat kfctl_istio_dex.v1.0.1_each.yaml | 
       sed -e "s|\${NAMESPACE}|${namespace}|g" |
       sed -e "s|\${USER}|${user}|g" |
       sed -e "s|\${PASSWD}|${passwd}|g" | 
       tee kfctl_istio_dex.v1.0.1_each_${namespace}.yaml
