#!/bin/bash

# Get the directory of the script itself
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Check if the first argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory-name>"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "jq is not installed. Please install it to run this script."
    exit 1
fi

# Directory name from the argument
DIR_NAME=$1

# Check for the --sdk flag
SDK_MODE=false
if [[ "$2" == "--sdk" ]]; then
    SDK_MODE=true
fi

# Full directory path, relative from the script's location
CHAINID="$SCRIPT_DIR/../packages/contracts-bedrock/deployments/$DIR_NAME"


# Declare an array of filenames to check when in SDK mode
declare -a SDK_FILES=("AddressManager" "L1CrossDomainMessengerProxy" "L1StandardBridgeProxy" "OptimismPortalProxy" "L2OutputOracleProxy")

filename=("$CHAINID"-deploy.json)
#cat $filename
echo $filename
#address=$(jq -r '.AddressManager' "$filename")
echo const AddressManager = `echo $(jq -r '.AddressManager' "$filename")`;
echo const L1CrossDomainMessengerProxy = `echo $(jq -r '.L1CrossDomainMessengerProxy' "$filename")`;
echo const L1StandardBridgeProxy = `echo $(jq -r '.L1StandardBridgeProxy' "$filename")`;
echo const L2OutputOracleProxy = `echo $(jq -r '.L2OutputOracleProxy' "$filename")`;
echo const OptimismPortalProxy = `echo $(jq -r '.OptimismPortalProxy' "$filename")`;

