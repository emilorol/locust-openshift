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
    sed -i '' "s/${oldName}/${onlyNamemaster}/g" $newName
    
    oldName='script-file'
    scriptName="$oldName-$onlyName"
    sed -i '' "s/${oldName}/${scriptName}/g" $newName
    
    oldName='host-url'
    hostUrlName="$oldName-$onlyName"
    sed -i '' "s/${oldName}/${hostUrlName}/g" $newName

    # create copies of slave deployment
    tempfileName='slave-deployment-_.yaml'
    newNameSlave=${tempfileName/'_'/$onlyName}
    cp ./slave-deployment.yaml $newNameSlave
    oldName='service_name'
    sed -i '' "s/${oldName}/${onlyNameslave}/g" $newNameSlave

    oldName='LOCUST_SERVICE_HOST'
    hostAppend="_PORT_8089_TCP_ADDR"
    newHost="$onlyNamemaster$hostAppend"
    newHost=${newHost/'-'/'_'}
    newHost=${newHost/'-'/'_'}
    newHost=${newHost/'-'/'_'}
    newHost=`echo "${newHost}" | tr '[a-z]' '[A-Z]'`
    sed -i '' "s/${oldName}/${newHost}/g" $newNameSlave
    
    oldName='script-file'
    scriptName="$oldName-$onlyName"
    sed -i '' "s/${oldName}/${scriptName}/g" $newNameSlave
    
    oldName='host-url'
    sed -i '' "s/${oldName}/${hostUrlName}/g" $newNameSlave
    
    # first create config variables
    sh ./seed.sh $fileName $tempHost $onlyNamemaster $onlyNameslave $scriptName $hostUrlName $namespace
    
    # create deployments which consume the configs
    oc process -f $newName | oc create -f -
    oc process -f $newNameSlave | oc create -f -
    

    # cleanup
    rm $newName $newNameSlave
done