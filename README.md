# k3d w/ istio

## Setup k3d

```bash
k3d cluster create istio-playground --servers 1 --agents 3 --port 9080:80@loadbalancer --port 9443:443@loadbalancer --api-port 6443 --k3s-arg='--disable=traefik@server:0'
```

- `--servers 1` there will be one server node for the control plane.
- `--agents 3` there will be 3 nodes to run containers on
- `--port 9080:80@loadbalancer` the load balancer (in docker, which is exposed), will forward requests to port 9080 to 80 in the k8 cluster, you can check this out after creation by running docker ps
- `--port 9443:443@loadbalancer` same as above, just for HTTPS (later)
- `--api-port 6443` the k8 API port will be port 6443 instead of randomly generated
- `--k3s-arg='--disable=traefik@server:0'` tell k3d to not deploy the Traefik v1 ingress controller

```bash
# Alternative simpler istio setup

k3d cluster create istio-playground --k3s-arg='--disable=traefik@server:0'
```

**NOTE** I also have octant running on the dev container so can restart it by running

```bash
nohup bash -c 'octant --disable-origin-check --disable-open-browser &' > ./.devcontainer/logs/octant.log
```

## Docker ps to check everything is working

```bash
$ docker ps --format 'table {{.ID}}\t{{.Image}}\t{{.Names}}\t{{.Ports}}'

CONTAINER ID   IMAGE                            NAMES                           PORTS
31ab70b634e8   ghcr.io/k3d-io/k3d-proxy:5.4.4   k3d-istio-playground-serverlb   0.0.0.0:6443->6443/tcp, 0.0.0.0:9080->80/tcp, 0.0.0.0:9443->443/tcp
4f5b81fd5b3b   rancher/k3s:v1.23.8-k3s1         k3d-istio-playground-agent-2    
4353f4b77119   rancher/k3s:v1.23.8-k3s1         k3d-istio-playground-agent-1    
0ef708df5271   rancher/k3s:v1.23.8-k3s1         k3d-istio-playground-agent-0    
e9665d8f41bd   rancher/k3s:v1.23.8-k3s1         k3d-istio-playground-server-0   

```

## Install Istio

Download the latest version of istio

```bash
curl -L https://istio.io/downloadIstio | sh -

# Add istio to your path in the current session
export PATH="$PATH:/workspaces/k3d/istio-1.14.1/bin"

# Check it is working by running 
istioctl version

# Install istio w/ default profile
istioctl install --set profile=default

# To enable automatic injection of Envoy sidecar proxy run below, otherwise you will have to do it yourself
kubectl label namespace default istio-injection=enabled

```

## Let's deploy something

### DEPLOYMENT

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: echoserver-v1
  labels:
    app: echoserver
    version: v1
spec:
  replicas: 3
  selector:
    matchLabels:
      app: echoserver
      version: v1
  template:
    metadata:
      labels:
        app: echoserver
        version: v1
    spec:
      containers:
      - name: echoserver
        image: gcr.io/google_containers/echoserver:1.0
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 8080
```

Save the above YAML into a file called deployment.yaml and run

```bash
kubectl apply -f ./deployment.yaml
```
### SERVICE

```yaml
apiVersion: v1
kind: Service
metadata:
  name: echoserver
  labels:
    app: echoserver
    service: echoserver
spec:
  selector:
    app: echoserver
  ports:
  - port: 80
    targetPort: 8080
    name: http
```

Save the above yaml into a file called service.yaml and run

```bash
kubectl apply -f ./service.yaml
```

### INGRESS

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: gateway
  annotations:
    kubernetes.io/ingress.class: "istio"
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: echoserver
            port:
              number: 80
```

Save the above yaml into a file called ingress.yaml and run

```bash
kubectl apply -f ./ingress.yaml
```

## Check that service is running

```bash
curl http://127.0.0.1:9080
```

## Links

- [k3d manual](https://k3d.io/v5.4.4/)
- [Medium post](https://brettmostert.medium.com/k3d-kubernetes-istio-service-mesh-286a7ba3a64f)
- [Disable Traefik](https://k3d.io/v5.4.1/design/concepts/)
- https://istio.io/latest/docs/
- https://istio.io/latest/docs/ops/deployment/architecture/
- https://servicemesh.es/
- https://www.istiobyexample.dev/
- https://blog.jayway.com/2018/10/22/understanding-istio-ingress-gateway-in-kubernetes/
- https://brettmostert.medium.com/k3d-kubernetes-up-and-running-quickly-d80f47bab48e
- https://dev.to/bufferings/tried-k8s-istio-in-my-local-machine-with-k3d-52gg
- https://www.udemy.com/course/istio-hands-on-for-kubernetes/learn/lecture/16779002?start=0#content
- https://www.tetrate.io/blog/debugging-your-istio-networking-configuration/
- https://docs.tetrate.io/blog/debugging-services-with-istio/