# Building VMs and Installing ICP Cluster

**Very Important**: Please make sure that you can reach internet from your laptop. This is required for the  installation as install program downloads package from Linux repo. This is not true offline install. I have issue opened up with the install team.

Once cluster is successfully built, you can work offline.

The directory structure is as below:

```
|-- icp01
|   |---icp01.vmx
|   |---icp01.vmdk
|   |---icp01-tmp.vmdk
|   |---dockerbackend.vmdk
|   |---gpfs.vmdk
|   |---gluster.vmdk
|-- icp02
|   |---icp02.vmx
|-- icp03
|   |---icp03.vmx
|-- icp04
|   |---icp04.vmx
|-- icp05
|   |---icp05.vmx   
|   ReadMe.txt
|-- RUN00-Build-All.CMD
|-- RUN01-Check-Free-Space.ps1
|-- RUN02-RunAsAdmin.ps1
|-- RUN03-FixVMMemory.ps1
|-- RUN04-FixVMNetAddress.CMD
|-- RUN05-CloneBuild.CMD
|-- RUN06-TakeSnapshot.CMD
|-- RUN07-Create-Desktop-Shortcut.CMD
|-- RUN08-Create-Desktop-Shortcut.vbs
```

Please note that the VMware disks (vmdk) files are not in this repository. Please do not clone this repository. This ICP image can be downloaded from this [link](http://ibm.com)

Instructions for building the image and VMs on W540 32 GB Laptop (minimum) or Levovo 64 GB P50 laptop are as under.

Note: This will not work on Mac as it does not have 32 GB of RAM.

# Check List before you run the command

* PLEASE DO NOT RUN or double click `icp01.vmx` as this will break the build process.
* The single command to build all VMs and build ICP cluster is `RUN00-Build-All.CMD` which will build things in the right order.
* Please close resource hog applications from laptop. For example - Lotus Notes, close unnecessary tabs from Chrome or Firefix (each tab consumes lots of memory), close Slack application and all other software that are not critical.

## Install latest VMware Workstation.

* Please get the latest VMware Workstation software from vmware.com.

### VMware Workstation Dependencies and vmnet setting

* Start VMware Work Station and click `Help` > `About`
* Your VMware Workstation must be  14.1.1 or higher
* If it is not, please procure / upgrade your VMware Workstation. All technical sellers have entitlement to a VMware Workstation license.

* Please make sure that `vmrun.exe` is available in `C:\Program Files (x86)\VMware\VMware VIX`
* If `vmrun` is not available, please install it using VMware Workstation software install.
* Click on `Edit` > `Preferences` and click on `Memory`. If using 32 GB RAM, change the reserved memory to **28368** KB. If using 64 GB RAM, change the reserved memory to **57200** MB.
* Close existing VM tabs, if any.
* Close VMware Work Station. Click `File` > `Exit`.

## Minimum Memory Requirement

* You must have minimum **32 GB RAM** and minimum 130 GB of free storage space.
* You must have SSD in your laptop. If you have HDD, the experience will be worst. Please do not try it with HDD. Please check if you have 250 MB / sec speed from SSD.

## PowerShell
* Please open a command line window and type `powershell` and you should see another
   command line window. We run a PowerShell script to change the VMware vmx file to set memory appropriately.
* If your Windows machine does not have PowerShell, please install it.   

## Unzip the files to a folder of your choice

The image was packaged 7z software. If you do not have it, please download this from [7z site](http://www.7-zip.org/download.html)

We will use 5 virtual machines for this proof of technology.

Please notice that the VMDK files are given only for the first machine having full GUI with server. The second VM has only minimum install (no GUI) and this VMDK is copied to the other VMs through the build process.

## We need an Elevated Shell

* Open a command window with Administrative privileges.
* Click `Start`, click `All Programs`, and then click `Accessories`
* Right-click `Command prompt`, and then click `Run as administrator`
* If the `User Account Control` dialog box appears, confirm the action it displays is what you want, and then click `Continue`.

# Clone Machines and build ICP cluster

* Change directory in your elevated shell where you unzipped files

* Type command `RUN00-Build-All.CMD` and this will run all commands in the sequence to clone and prepare all 5 machines

* `RUN00-Build-All.CMD` may take 50-70 minutes to complete all operations. Please be patient.         

Note: While commands are running, please do not perform other activity. You may see VMware prompt and click Yes or OK to continue.

# Start VMs

* After build process is complete. Click Close (x) (top right hand of the VMware Workstation) window. This will power off all VMs.

* Go to your folder and **double click** `icp01.vmx `to open the VM and start it.
* Repeat same for `icp02.vmx` in folder `icp02` and all the way up to `icp05.vmx` in `icp05` folder and power on all VMs.
* Wait for VM to power on
* Switch to `icp01` VM.
* Double click `GNOME Terminal` on the desktop.
* Type `root` to become root.
* Type `kubectl -n kube-system get pods` to check the status pod status.

You may see the followng output.

```
[root@node01 ~]# kubectl -n kube-system get pods
NAME                                                 READY     STATUS     RESTARTS   AGE
auth-apikeys-j9488                                   0/1       Init:0/1   2          11h
auth-idp-pvqc7                                       0/3       Init:0/1   2          11h
auth-pap-9vs8r                                       0/1       Init:0/1   2          11h
auth-pdp-prczr                                       0/1       Init:0/2   2          11h
calico-node-amd64-rrlcz                              2/2       Running    4          12h
calico-node-amd64-wk9mc                              2/2       Running    4          12h
calico-node-amd64-x9clf                              2/2       Running    4          12h
calico-node-amd64-xhwwn                              2/2       Running    4          12h
calico-node-amd64-zwd2c                              2/2       Running    4          12h
calico-policy-controller-5997c6c956-nkmd5            1/1       Running    2          12h
catalog-catalog-apiserver-5n56r                      1/1       Running    2          11h
catalog-catalog-controller-manager-bd9f49c8c-hdrtg   1/1       Running    4          11h
catalog-ui-n77bj                                     1/1       Running    2          11h
default-http-backend-8448fbc655-xp2hk                1/1       Running    2          11h
elasticsearch-client-6c9fc8b5b6-jhch9                2/2       Running    4          11h
elasticsearch-data-0                                 1/1       Running    2          11h
elasticsearch-master-667485dfc5-m7qkg                1/1       Running    2          11h
filebeat-ds-amd64-8f65x                              1/1       Running    2          11h
filebeat-ds-amd64-8klvx                              1/1       Running    2          11h
filebeat-ds-amd64-hptkv                              1/1       Running    2          11h
filebeat-ds-amd64-q77tn                              1/1       Running    2          11h
filebeat-ds-amd64-q9f95                              1/1       Running    2          11h
glusterfs-99hkk                                      1/1       Running    2          12h
glusterfs-g5l8g                                      1/1       Running    0          3m
glusterfs-wdzmh                                      1/1       Running    0          3m
heapster-5fd94775d5-p8v4f                            2/2       Running    4          11h
heketi-7cf876ddcd-s8zrw                              1/1       Running    2          12h
helm-api-6f5bdf8494-tv65l                            1/1       Running    4          11h
helmrepo-69f457dd8b-98qxh                            1/1       Running    4          11h
icp-ds-0                                             0/1       Running    2          11h
icp-router-n5tbb                                     1/1       Running    6          11h
image-manager-0                                      2/2       Running    4          11h
k8s-etcd-192.168.142.102                             1/1       Running    2          12h
k8s-mariadb-192.168.142.102                          1/1       Running    2          12h
k8s-master-192.168.142.102                           3/3       Running    6          12h
k8s-proxy-192.168.142.101                            1/1       Running    2          12h
k8s-proxy-192.168.142.102                            1/1       Running    2          12h
k8s-proxy-192.168.142.103                            1/1       Running    3          12h
k8s-proxy-192.168.142.104                            1/1       Running    2          12h
k8s-proxy-192.168.142.105                            1/1       Running    2          12h
kube-dns-9494dc977-8w8w4                             3/3       Running    6          12h
logstash-5ccb9849d6-kpvsk                            1/1       Running    2          11h
nginx-ingress-lb-amd64-7grl7                         1/1       Running    2          11h
platform-api-6pqxf                                   1/1       Running    2          11h
platform-ui-r2xjt                                    1/1       Running    2          11h
rescheduler-sgwdr                                    1/1       Running    2          11h
tiller-deploy-55fb4d8dcc-7lqxg                       1/1       Running    2          11h
unified-router-r6xl4                                 1/1       Running    6          11h
```

Please notice that auth-apikeys and auth containers at the top are in init state. The icp-ds (Cloudant) has not yet started.

The Ready state should be such that number of replicas should match.

For example:
```
auth-idp-pvqc7                                       0/3       Init:0/1   2          11h
```

The auth-idp has not yet started and it needs to have 3 replicas running.

Try same command `kubectl -n kube-system get pods` again to check the status.

You may see that the auth containers may show in Error state. Kubernetes will try to recover these.

For example:

```
auth-apikeys-j9488                                   0/1       Error     1          11h
auth-idp-pvqc7                                       0/3       Error     3          12h
auth-pap-9vs8r                                       0/1       Error     1          11h
auth-pdp-prczr                                       0/1       Error     1          11h
.......
icp-ds-0                                             1/1       Running   2          11h
```

Wait for few minutes and try command again. You should see all pods running. Make sure that all replicas are running.

```
[root@node01 ~]# kubectl -n kube-system get pods
NAME                                                 READY     STATUS    RESTARTS   AGE
auth-apikeys-j9488                                   1/1       Running   2          12h
auth-idp-pvqc7                                       3/3       Running   6          12h
auth-pap-9vs8r                                       1/1       Running   2          12h
auth-pdp-prczr                                       1/1       Running   2          12h
calico-node-amd64-rrlcz                              2/2       Running   4          12h
calico-node-amd64-wk9mc                              2/2       Running   4          12h
calico-node-amd64-x9clf                              2/2       Running   4          12h
calico-node-amd64-xhwwn                              2/2       Running   4          12h
calico-node-amd64-zwd2c                              2/2       Running   4          12h
calico-policy-controller-5997c6c956-nkmd5            1/1       Running   2          12h
catalog-catalog-apiserver-5n56r                      1/1       Running   2          11h
catalog-catalog-controller-manager-bd9f49c8c-hdrtg   1/1       Running   4          11h
catalog-ui-n77bj                                     1/1       Running   2          12h
default-http-backend-8448fbc655-xp2hk                1/1       Running   2          11h
elasticsearch-client-6c9fc8b5b6-jhch9                2/2       Running   4          12h
elasticsearch-data-0                                 1/1       Running   2          12h
elasticsearch-master-667485dfc5-m7qkg                1/1       Running   2          12h
filebeat-ds-amd64-8f65x                              1/1       Running   2          12h
filebeat-ds-amd64-8klvx                              1/1       Running   2          12h
filebeat-ds-amd64-hptkv                              1/1       Running   2          12h
filebeat-ds-amd64-q77tn                              1/1       Running   2          12h
filebeat-ds-amd64-q9f95                              1/1       Running   2          12h
glusterfs-99hkk                                      1/1       Running   2          12h
glusterfs-g5l8g                                      1/1       Running   0          6m
glusterfs-wdzmh                                      1/1       Running   0          6m
heapster-5fd94775d5-p8v4f                            2/2       Running   4          11h
heketi-7cf876ddcd-s8zrw                              1/1       Running   2          12h
helm-api-6f5bdf8494-tv65l                            1/1       Running   5          11h
helmrepo-69f457dd8b-98qxh                            1/1       Running   5          11h
icp-ds-0                                             1/1       Running   2          11h
icp-router-n5tbb                                     1/1       Running   6          11h
image-manager-0                                      2/2       Running   4          11h
k8s-etcd-192.168.142.102                             1/1       Running   2          12h
k8s-mariadb-192.168.142.102                          1/1       Running   2          12h
k8s-master-192.168.142.102                           3/3       Running   6          12h
k8s-proxy-192.168.142.101                            1/1       Running   2          12h
k8s-proxy-192.168.142.102                            1/1       Running   2          12h
k8s-proxy-192.168.142.103                            1/1       Running   3          12h
k8s-proxy-192.168.142.104                            1/1       Running   2          12h
k8s-proxy-192.168.142.105                            1/1       Running   2          12h
kube-dns-9494dc977-8w8w4                             3/3       Running   6          12h
logstash-5ccb9849d6-kpvsk                            1/1       Running   2          12h
nginx-ingress-lb-amd64-7grl7                         1/1       Running   2          11h
platform-api-6pqxf                                   1/1       Running   2          12h
platform-ui-r2xjt                                    1/1       Running   2          12h
rescheduler-sgwdr                                    1/1       Running   2          11h
tiller-deploy-55fb4d8dcc-7lqxg                       1/1       Running   2          12h
unified-router-r6xl4                                 1/1       Running   6          11h
```

When you see the above state, you are sure that all containers and associated replicas are running.

Now, go back to the desktop and double click **IBM Cloud Private Web Console** and it should open the URL https://192.168.142.102:8443 which will open the web console from icp02.

The user id and password is admin/admin.

Please note that the topology of this ICP cluster is:

```
# cdc
# pwd
/root/download/icp2.1.0.1/cluster
# cat hosts
[management]
192.168.142.101

[master]
192.168.142.102

[worker]
192.168.142.103
192.168.142.104
192.168.142.105

[proxy]
192.168.142.101

# cat config.yaml
# General config
wait_for_timeout: 600
skip_pre_check: true
firewall_enabled: false
auditlog_enabled: false
federation_enabled: false
secure_connection_enabled: false
network_type: calico
network_cidr: 10.1.0.0/16
service_cluster_ip_range: 10.0.0.1/24
kubelet_extra_args: ["--fail-swap-on=false"]
cluster_name: pot_icp_cluster
default_admin_user: admin
default_admin_password: admin
disabled_management_services: ["metering", "monitoring", "va"]
kibana_install: false
glusterfs: true
storage:
  - kind: glusterfs
    nodes:
      - ip: 192.168.142.103
        device: /dev/disk/by-path/pci-0000:00:10.0-scsi-0:0:3:0
      - ip: 192.168.142.104
        device: /dev/disk/by-path/pci-0000:00:10.0-scsi-0:0:3:0
      - ip: 192.168.142.105
        device: /dev/disk/by-path/pci-0000:00:10.0-scsi-0:0:3:0
    storage_class:
      name: glusterfs-storage
      default: false
docker_log_max_size: 10m
docker_log_max_file: 10
```

The management node is `icp02`, the worker nodes are `icp03`, `icp04` and `icp05`. The boot and proxy node is `icp01`.

The web console would need to run from `icp02` - which is `192.168.142.102`.

The GlusterFS volumes are on Workers nodes. The device ``/dev/disk/by-path/pci-0000:00:10.0-scsi-0:0:3:0` is `gluster.vmdk` on worker nodes.

The IBM Bluemix CLI is also installed.

The Helm client is also installed.

## Install Helm client.

What is helm? Consider this like rpm of Redhat - which is a package manager. Helm is the package manager in ICP through which you can install any available software.

Type following commands as root
```
# cd3
# ./icp09
==========================================================
Install Helm client
==========================================================
mv: cannot stat ‘helm’: No such file or directory
$HELM_HOME has been configured at /var/lib/helm.
Not installing Tiller due to 'client-only' flag having been set
Happy Helming!
Client: &version.Version{SemVer:"v2.6.0", GitCommit:"5bc7c619f85d74702e810a8325e0a24f729aa11a", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.6.0", GitCommit:"5bc7c619f85d74702e810a8325e0a24f729aa11a", GitTreeState:"clean"}
"incubator" has been added to your repositories
# helm search -l
```

You should see a long list of packages available.

## Check Bluemix client

Type the following commands.

```
# bx help
NAME:
   bx - A command line tool to interact with IBM Cloud

USAGE:
   [environment variables] bx [global options] command [arguments...] [command options]

VERSION:
   0.6.5+0183260-2018-02-05T06:56:08+00:00

COMMANDS:
   api        Set or view target API endpoint
   login      Log user in
   logout     Log user out
   target     Set or view the targeted region, account, resource group, org or space
   info       View cloud information
   config     Write default values to the config
   update     Update CLI to the latest version
   regions    List all the regions
   account    Manage accounts, users, orgs and spaces
   catalog    Manage catalog
   resource   Manage resource groups and resources
   iam        Manage identities and access to resources
   app        Manage Cloud Foundry applications and application related domains, routes and certificates
   service    Manage Cloud Foundry services
   billing    Retrieve usage and billing information
   plugin     Manage plug-ins and plug-in repositories
   cf         Run Cloud Foundry CLI with Bluemix CLI context
   sl         Gen1 infrastructure Infrastructure services
   help       

Enter 'bx help [command]' for more information about a command.

ENVIRONMENT VARIABLES:
   BLUEMIX_COLOR=false                     Do not colorize output
   BLUEMIX_TRACE=true                      Print API request diagnostics to stdout
   BLUEMIX_TRACE=path/to/trace.log         Append API request diagnostics to a log file
   BLUEMIX_API_KEY=api_key_value           API key to use during login

GLOBAL OPTIONS:
   --version, -v                      Print the version
   --help, -h                         Show help
```

## The screen resize fix for VMware Guest

Sometime, it may so happen that when you resize the VMware workstation, the Linux VM does not resize.

Make sure that you **View** > **Autosize** > **Autofit Guest** and check **Autofit Window**

If you still see that the window inside VM guest is not changing, open a command shell run following two commands.

```
$ root
# vmware-user-suid-wrapper
```
