# Test Istio pod-to-pod connectivity

This script tests Istio connectivity:
- Pod to Service
- Pod to pod
- Pod to itself

## Run:
```
./test-istio.sh
```

## Expected output on GKE with Istio

```console
# Creating Ns
namespace/istio-test created
# Creating Pods
pod/nginx-01 created
pod/nginx-02 created
# Creating Svc
service/nginx-svc created
service/nginx-headless-svc created
# Waiting for Pods
pod/nginx-01 condition met
pod/nginx-02 condition met
Checking connectivity to svc - nginx-svc.istio-test.svc.cluster.local                                         [32m[OK][m
Checking connectivity pod-to-pod - nginx-02.nginx-headless-svc.istio-test.svc.cluster.local                   [31m[FAIL][m
Checking connectivity pod-to-self - nginx-01.nginx-headless-svc.istio-test.svc.cluster.local                  [31m[FAIL][m
# Creating ServiceEntry
serviceentry.networking.istio.io/nginx created
Checking connectivity to svc - nginx-svc.istio-test.svc.cluster.local                                         [32m[OK][m
Checking connectivity pod-to-pod - nginx-02.nginx-headless-svc.istio-test.svc.cluster.local                   [32m[OK][m
Checking connectivity pod-to-self - nginx-01.nginx-headless-svc.istio-test.svc.cluster.local                  [31m[FAIL][m
# Creting Policy
policy.authentication.istio.io/nginx-permissive created
Checking connectivity to svc - nginx-svc.istio-test.svc.cluster.local                                         [32m[OK][m
Checking connectivity pod-to-pod - nginx-02.nginx-headless-svc.istio-test.svc.cluster.local                   [32m[OK][m
Checking connectivity pod-to-self - nginx-01.nginx-headless-svc.istio-test.svc.cluster.local                  [32m[OK][m
# Cleaning up
namespace "istio-test" deleted
```

### GKE version

```
NAME         LOCATION     MASTER_VERSION  MASTER_IP     MACHINE_TYPE  NODE_VERSION   NUM_NODES  STATUS
k8s-cluster  us-central1  1.12.8-gke.10   35.226.36.16  n1-highcpu-4  1.12.8-gke.10  3          RUNNING
```
