#!/bin/bash

testFile=""
hostName=""
dcMasterName=""
dcSlaveName=""
scriptName=""

# Display prompt if not arguments passed
if [[ -z "$1" && -z "$2" && -z "$3" && -z "$4" && -z "$5"  && -z "$6" ]]
then
  read -p 'File to run: ' testFile
  read -p 'Host to attack: ' hostName
  read -p 'Name of master service: ' dcmastername
  read -p 'Host to worker service: ' dcslavename
  read -p 'Name of the script: ' scriptName
  read -p 'Name of the host url: ' hostUrlName
else
  testFile=$1
  hostName=$2
  dcMasterName=$3
  dcSlaveName=$4
  scriptName=$5
  hostUrlName=$6
fi

# Confirmation
echo "Confirmation: file to run is: $testFile, the host: $hostName and the script name is $scriptName"

# Prepare Config map with new values
cat > config-map.yaml << EOF1
kind: ConfigMap
apiVersion: v1
metadata:
  name: $hostUrlName
  namespace: locust
data:
  ATTACKED_HOST: $hostName
EOF1

# Push it to cluster
cat config-map.yaml | oc apply -f -

# Clean after yourself
rm ./config-map.yaml

# Prepare Config map with new values
cat > config-map.yaml << EOF1
kind: ConfigMap
apiVersion: v1
metadata:
  name: $scriptName
  namespace: locust
data:
  locustfile.py: |
$(cat $testFile | sed 's/^/    /')
EOF1
# oldName='script-file'
# sed -i '' "s/${oldName}/${scriptName}/g" config-map.yaml

# Push it to cluster
cat config-map.yaml | oc apply -f -

# Clean after yourself
rm ./config-map.yaml

# Update the environment variable to trigger a change
oc project locust
#oc set env dc/locust-master --overwrite CONFIG_HASH=`date +%s%N`
#oc set env dc/locust-slave --overwrite CONFIG_HASH=`date +%s%N`

# confighash=`date +%s%N`

# oc set env dc/${dcMasterName} --overwrite CONFIG_HASH=$confighash
# oc set env dc/${dcSlaveName} --overwrite CONFIG_HASH=$confighash