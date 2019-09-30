# Locust on OpenShift

Run distributed load tests using Locust and OpenShift. 

Original idea and inspiration came from: https://medium.com/locust-io-experiments/locust-io-experiments-running-in-kubernetes-95447571a550

### Seed the project with your data to test

Run the following command to move the test data to the cluster.

```
$ ./seed.sh file_name_with_test.py https://www.url-to-test.com
```

__Note:__ the `seed.sh` use the `oc` command to push the changes.


### Install OC command

* Download oc Client Tools

```
$ wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
```

* Extract the downloaded .tar.gz

```
$ tar -xf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
```

* Move oc binary file to a directory in your local machine path

```
cd openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit
$ mv oc /usr/local/bin/
```

* Apply Executable Permissions to the Binary

```
$ chmod +x /usr/local/bin/oc
```

## Install on OpenShift

* Login to the OpenShift Cluster

```
$ oc login https://www.cluster-address.com
```

* Create new project:

```
$ oc new-project locust --display-name=Locust --description="Locust.io load tests cluster";
```

* Select project namespace:

```
$ oc project locust;
```

* Deploy Locust `master` pod:

```
$ oc process -f master-deployment.yaml | oc create -f -
```

* Deploy Locust `slave` pod:

```
$ oc process -f slave-deployment.yaml | oc create -f -
```

__Note:__ the `slave-deployment.yaml` has the comment out code for setting up auto scaling the pods, but `Locust` will reset the test to distribute the load every time a new slave is added. You can manually create the `slave` pods before starting the test and destroy them when done.
