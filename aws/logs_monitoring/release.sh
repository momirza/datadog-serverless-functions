#!/bin/bash

set -e

# Makes sure any subprocesses will be terminated with this process
trap "pkill -P $$; exit 1;" INT

AVAILABLE_REGIONS=(us-east-2 us-east-1 us-west-1 us-west-2 ap-south-1 ap-northeast-2 ap-southeast-1 ap-southeast-2 ap-northeast-1 ca-central-1 eu-north-1 eu-central-1 eu-west-1 eu-west-2 eu-west-3 sa-east-1)


# Check version arg
if [ -z "$1" ]; then
    echo "New version not specified"
    echo ""
    echo "EXITING SCRIPT."
    exit 1
else
    echo "New version specified: $1"
    VERSION=$1
fi

# Check region arg
if [ -z "$2" ]; then
    echo "Region parameter not specified, running for all available regions."
    REGIONS=("${AVAILABLE_REGIONS[@]}")
else
    echo "Region parameter specified: $2"
    if [[ ! " ${AVAILABLE_REGIONS[@]} " =~ " ${2} " ]]; then
        echo "Could not find $2 in available regions: ${AVAILABLE_REGIONS[@]}"
        echo ""
        echo "EXITING SCRIPT."
        exit 1
    fi
    REGIONS=($2)
fi

echo "Releasing the Datadog Forwarder version ${VERSION} for regions: ${REGIONS[*]}"




# echo "Publishing layers: ${LAYER_NAMES[*]}"

# publish_layer() {
#     region=$1
#     layer_name=$2
#     aws_version_key=$3
#     layer_path=$4
#     version_nbr=$(aws lambda publish-layer-version --layer-name $layer_name \
#         --description "Datadog Lambda Layer for Python" \
#         --zip-file "fileb://$layer_path" \
#         --region $region \
#         --compatible-runtimes $aws_version_key \
#                         | jq -r '.Version')

#     aws lambda add-layer-version-permission --layer-name $layer_name \
#         --version-number $version_nbr \
#         --statement-id "release-$version_nbr" \
#         --action lambda:GetLayerVersion --principal "*" \
#         --region $region

#     echo "Published layer for region $region, python version $aws_version_key, layer_name $layer_name, layer_version $version_nbr"
# }

# BATCH_SIZE=60
# PIDS=()

# wait_for_processes() {
#     for pid in "${PIDS[@]}"; do
#         wait $pid
#     done
#     PIDS=()
# }

# for region in "${REGIONS[@]}"
# do
#     echo "Starting publishing layer for region $region..."

#     # Publish the layers for each version of python
#     i=0
#     for layer_name in "${LAYER_NAMES[@]}"; do
#         aws_version_key="${PYTHON_VERSIONS_FOR_AWS_CLI[$i]}"
#         layer_path="${LAYER_PATHS[$i]}"

#         publish_layer $region $layer_name $aws_version_key $layer_path &
#         PIDS+=($!)
#         if [ ${#PIDS[@]} -eq $BATCH_SIZE ]; then
#             wait_for_processes
#         fi

#         i=$(expr $i + 1)

#     done
# done

# wait_for_processes

# echo "Done !"
