all:

.PHONY:deploy-all deploy-k3s copy-kubeconfig reboot-k3s shutdown-k3s help

deploy-all:deploy-k3s copy-kubeconfig help ## Deploy dev-k3s.cluster and copy kube config

deploy-k3s: ## Deploy dev-k3s.cluster.
	@echo "\nsDeploy dev-k3s.cluster ..."
	@ansible-playbook site.yml  -i ./inventory/my-cluster/hosts.ini

copy-kubeconfig: ## Copy 'kubeconfig'.
	@echo "\nCopy kubeconfig to ~/.kube/ ...\n"
	@scp vagrant@192.168.40.119:~/.kube/config ~/.kube/config
	@kubectl get nodes --show-kind

reboot-k3s: ## Reboot dev-k3s.cluster.
	@echo "\nReboot dev-k3s.cluster ..."
	@ansible-playbook reboot.yml  -i ./inventory/my-cluster/hosts.ini

shutdown-k3s: ## Shutdown dev-k3s.cluster.
	@echo "\nShutdown dev-k3s.cluster ..."
	@ansible-playbook reset.yml  -i ./inventory/my-cluster/hosts.ini

help: ## Display this help.
	@echo "\nDisplay this help ..."
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
