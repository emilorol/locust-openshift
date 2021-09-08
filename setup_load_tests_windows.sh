#!/bin/bash
for fileName in ./*.py; do
    # extract host
    tempHost=$(grep '# host' $fileName)
    tempHost=${tempHost/'# host='/''}
    onlyName=${fileName/'.py'/''}
    onlyName=${onlyName:2}
    onlyName=${onlyName/'_'/'-'}
    onlyName=${onlyName/'_'/'-'}
    echo $onlyName

    # create copies of master deployment
    tempfileName='master-deployment-_.yaml'
    newName=${tempfileName/'_'/$onlyName}
    cp ./master-deployment.yaml $newName
    # echo $onlyName
    master="-master"
    slave="-slave"
    onlyNamemaster="$onlyName$master"
    onlyNameslave="$onlyName$slave"
    oldName='service_name'

    # sed -i '' "s/${oldName}/${onlyNamemaster}/g" $newName
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' -e "s/${oldName}/${onlyNamemaster}/g" $newName
    else
        sed -i -e "s/${oldName}/${onlyNamemaster}/g" $newName
    fi

    
    
    oldName='script-file'
    scriptName="$oldName-$onlyName"

    # sed -i '' "s/${oldName}/${scriptName}/g" $newName
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' -e "s/${oldName}/${scriptName}/g" $newName
    else
        sed -i -e "s/${oldName}/${scriptName}/g" $newName
    fi  
    
    oldName='host-url'
    hostUrlName="$oldName-$onlyName"
    # sed -i '' "s/${oldName}/${hostUrlName}/g" $newName
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' -e "s/${oldName}/${hostUrlName}/g" $newName
    else
        sed -i -e "s/${oldName}/${hostUrlName}/g" $newName
    fi  

    # create copies of slave deployment
    tempfileName='slave-deployment-_.yaml'
    newNameSlave=${tempfileName/'_'/$onlyName}
    cp ./slave-deployment.yaml $newNameSlave
    oldName='service_name'
    # sed -i '' "s/${oldName}/${onlyNameslave}/g" $newNameSlave
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' -e "s/${oldName}/${onlyNameslave}/g" $newNameSlave
    else
        sed -i -e "s/${oldName}/${onlyNameslave}/g" $newNameSlave
    fi  

    oldName='LOCUST_SERVICE_HOST'
    hostAppend="_PORT_8089_TCP_ADDR"
    newHost="$onlyNamemaster$hostAppend"
    newHost=${newHost/'-'/'_'}
    newHost=${newHost/'-'/'_'}
    newHost=${newHost/'-'/'_'}
    newHost=`echo "${newHost}" | tr '[a-z]' '[A-Z]'`

    # sed -i '' "s/${oldName}/${newHost}/g" $newNameSlave
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' -e "s/${oldName}/${newHost}/g" $newNameSlave
    else
        sed -i -e "s/${oldName}/${newHost}/g" $newNameSlave
    fi  
    
    oldName='script-file'
    scriptName="$oldName-$onlyName"

    # sed -i '' "s/${oldName}/${scriptName}/g" $newNameSlave
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' -e "s/${oldName}/${scriptName}/g" $newNameSlave
    else
        sed -i -e "s/${oldName}/${scriptName}/g" $newNameSlave
    fi 
    
    oldName='host-url'
    # sed -i '' "s/${oldName}/${hostUrlName}/g" $newNameSlave
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' -e "s/${oldName}/${hostUrlName}/g" $newNameSlave
    else
        sed -i -e "s/${oldName}/${hostUrlName}/g" $newNameSlave
    fi 
    
    
    # first create config variables
    sh ./seed.sh $fileName $tempHost $onlyNamemaster $onlyNameslave $scriptName $hostUrlName
    
    # create deployments which consume the configs
    oc process -f $newName | oc create -f -
    oc process -f $newNameSlave | oc create -f -
    

    # cleanup
    rm $newName $newNameSlave
done