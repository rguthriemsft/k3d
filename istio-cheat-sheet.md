# Commands

- [generate manifest](https://istio.io/v1.6/docs/setup/install/istioctl/#generate-a-manifest-before-installation) `istioctl manifest generate -o <dir_path>`
- [istioctl](https://istio.io/latest/docs/reference/commands/istioctl/)


Verify Istio install 
`istioctl verify-install`

Look at all proxies status 
`istioctl proxy-status`

Check TLS for foo pod in default namespace  
`istioctl authn tls-check foo-656bd7df7c-5zp4s.default`

Open Istio dashboard  
`istioctl dashboard grafana`

Open Pilot Dashboard 
`istioctl dashboard controlz $(kubectl get pod -n istio-system -l app=pilot -o jsonpath='{..metadata.name}').istio-system`

## Notes

If attempting to install and manage Istio using `istioctl manifest` generate, please note the following caveats:

- The Istio namespace (`istio-system` by default) must be created manually.

- While `istioctl` install will automatically detect environment specific settings from your Kubernetes context, manifest generate cannot as it runs offline, which may lead to unexpected results. In particular, you must ensure that you follow [these steps](https://istio.io/v1.6/docs/ops/best-practices/security/#configure-third-party-service-account-tokens) if your Kubernetes environment does not support third party service account tokens.

- `kubectl apply` of the generated manifest may show transient errors due to resources not being available in the cluster in the correct order.

- `istioctl` install automatically prunes any resources that should be removed when the configuration changes (e.g. if you remove a gateway). This does not happen when you use `istio manifest generate` with kubectl and these resources must be removed manually.
