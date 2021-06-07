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

* Create new project / login to your existing project: 

```
$ oc new-project locust --display-name=Locust --description="Locust.io load tests cluster";
```

```
$ oc project locust;
```

* give the setup load test file permissions to run : 

```
$ chmod a+x setup_load_tests.sh
```

* change the project on line 36 of seed.sh

* add host name to each load test file according to the format of locust_test_oc.py line 4


* place all you load tests in the root directory

```
$ ./setup_load_tests.sh
```