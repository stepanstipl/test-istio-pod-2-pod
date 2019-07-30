#!/bin/bash

TEST_NS="istio-test"
TEST_SVC="nginx-svc"
TEST_SVC_HEADLESS="nginx-headless-svc"
TEST_SVC_DNS="${TEST_SVC}.${TEST_NS}.svc.cluster.local"
TEST_SVC_HEADLESS_DNS="${TEST_SVC_HEADLESS}.${TEST_NS}.svc.cluster.local"
POD_01="nginx-01"
POD_02="nginx-02"
TEST_TEXT="May the Force be with you"

[ "${DEBUG:=false}" = 'true' ] && set -x

# Check if we have colors available, it looks good
COLORS=$(tput colors)
if [[ -n $COLORS && $COLORS -ge 8 ]]; then
        GREEN=$(tput setaf 2)
        RED=$(tput setaf 1)
        NOCOL=$(tput sgr0)
        BOLD=$(tput bold)
fi

test_cmd() {
	printf '%*s' "-110" "$1"
  shift
  "$@" \
    && echo_ok \
    || echo_fail
}

echo_ok() {
	printf '%*s\n' "-10" "${GREEN}[OK]${NOCOL}"
	return $?
}

echo_fail() {
	printf '%*s\n' "-10" "${RED}[FAIL]${NOCOL}"
	return $?
}

test_curl() {
  test_cmd "Checking connectivity ${1} - ${2}" \
    kubectl exec -it "${POD_01}" -n "${TEST_NS}" -c nginx -- \
      /bin/sh -c "curl -s -o /dev/null -w '%{http_code}' --max-time 2 'http://${2}' | grep -q '200'" 2>/dev/null
}

test() {
  test_curl "to svc" "${TEST_SVC_DNS}"

  test_curl "pod-to-pod" "${POD_02}.${TEST_SVC_HEADLESS_DNS}"

  test_curl "pod-to-self" "${POD_01}.${TEST_SVC_HEADLESS_DNS}"
}

echo "# Creating Ns"
kubectl apply -f 01_*.yaml

echo "# Creating Pods"
kubectl apply -f 02_*.yaml

echo "# Creating Svc"
kubectl apply -f 03_*.yaml

echo "# Waiting for Pods"
kubectl wait --for=condition=Ready -n "${TEST_NS}" "pod/${POD_01}"
kubectl wait --for=condition=Ready -n "${TEST_NS}" "pod/${POD_02}"

test

echo "# Creating ServiceEntry"
kubectl apply -f 04_*.yaml

test

echo "# Creting Policy"
kubectl apply -f 05_*.yaml

test

echo "# Cleaning up"
kubectl delete ns "${TEST_NS}"
