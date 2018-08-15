#!/bin/bash

echo "---- Printing out test resources ----"
oc get all,secrets,sa,templates,configmaps,daemonsets,clusterroles,rolebindings,serviceaccounts || true

echo "---- Describe Pods ----"
oc describe pods || true

echo "---- Docker PS ----"
docker ps || true

echo "---- Caching Service logs ----"
oc logs caching-service-app-0 || true
oc logs caching-service-app-0 -c pem-to-keystore || true

echo "---- Shared Memory logs ----"
oc logs shared-memory-service-app-0 || true
oc logs shared-memory-service-app-0 -c pem-to-keystore || true

echo "---- Test Runner logs ----"
oc logs testrunner || true
oc logs testrunner -c pem-to-truststore || true

echo "---- EAP Testrunner logs  ----"
oc logs testrunner || true

oc cp testrunner:/tmp/readiness-* ${WORKSPACE} || true

echo "---- Clearing up test resources ---"
oc delete all,secrets,sa,templates,configmaps,daemonsets,clusterroles,rolebindings,serviceaccounts --selector=template=caching-service || true
oc delete all,secrets,sa,templates,configmaps,daemonsets,clusterroles,rolebindings,serviceaccounts --selector=template=shared-memory-service || true
oc delete template caching-service || true
oc delete template shared-memory-service || true
oc delete service testrunner || true
oc delete route testrunner || true


