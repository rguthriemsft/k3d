# Notes

- Control Plane is istiod (Istio Daemon, Kiali UI)
- Data plane is all the proxies running with your containers
- when applying the course warmup, need to enable sidecar injection 

## K3d setup steps

```bash

# expose 80/443 through load balancer. 
# expose webapp nodeport on 30080
# expose jaeger ui nodeport on 31001

k3d cluster create istio-playground --port 9080:80@loadbalancer --port 9443:443@loadbalancer --port 30080:30080@server:0 --port 31001:31001@server:0 --api-port 6443 --k3s-arg='--disable=traefik@server:0'
```

Run lab/1-3 steps

```bash
kubectl label namespace default istio-injection=enabled

# Import images for fleetman
# Import images for fleetman and istio to speed up setup
k3d images import richardchesterwood/istio-fleetman-position-simulator:5 richardchesterwood/istio-fleetman-position-tracker:5 richardchesterwood/istio-fleetman-api-gateway:5 richardchesterwood/istio-fleetman-webapp-angular:5 richardchesterwood/istio-fleetman-vehicle-telemetry:5 richardchesterwood/istio-fleetman-staff-service:5 richardchesterwood/istio-fleetman-photo-service:5 docker.io/istio/proxyv2:1.10.3 grafana/grafana:7.2.1 docker.io/istio/pilot:1.10.3 docker.io/jaegertracing/all-in-one:1.20 quay.io/kiali/kiali:v1.23 jimmidyson/configmap-reload:v0.4.0 prom/prometheus:v2.21.0 --cluster lab2
```

Run lab step 4

## Links

- [Course Repo](https://github.com/DickChesterwood/istio-fleetman)
- [Exposing ports in k3d](https://k3d.io/v5.0.1/usage/exposing_services/)