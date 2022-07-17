# Notes


## Setup 

add image to server

```bash
docker pull richardchesterwood/istio-fleetman-webapp-angular:6-experimental

k3d images import richardchesterwood/istio-fleetman-webapp-angular:6-experimental --cluster lab3
```

- Test the initial configuration

```bash
curl -s 127.0.0.1:30080/ | grep title
```
## Notes

virtual gateways are how you expose resources outside the cluster or on the edge.  puts a proxy in front of the exposed service (Edge Service).

### Links

- https://istio.io/latest/docs/tasks/traffic-management/ingress/ingress-control/