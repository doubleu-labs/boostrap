---
apiVersion: v1
kind: Namespace
metadata:
  name: metallb-system
---
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  name: metallb
  namespace: metallb-system
spec:
  repo: https://metallb.github.io/metallb
  chart: metallb
  targetNamespace: metallb-system
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: l2-advertisement
  namespace: metallb-system
---
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: dns
  namespace: metallb-system
spec:
  addresses:
  - 10.0.0.10-10.0.0.11
