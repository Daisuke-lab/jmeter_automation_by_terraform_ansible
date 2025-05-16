# Install ansible
```
$ sudo apt update
$ sudo apt install software-properties-common
$ sudo add-apt-repository --yes --update ppa:ansible/ansible
$ sudo apt install ansible
```

```
sudo apt install pipx
apt install python3.8-venv
pipx install --include-deps ansible
```

# install amazon extension
```
ansible-galaxy collection install amazon.aws
sudo apt install python3-pip
pip install boto3
```

*filename has to be ended with aws_ec2
ansible-inventory -i inventory_aws_ec2.yaml --graph

# check command
```
ansible-playbook init_playbook.yaml --check
ansible-playbook -i inventory_aws_ec2.yaml playbook.yaml --check
```

## get windows passowrd
```
aws ec2 get-password-data --instance-id $(terraform output -raw windows_instance_id) --priv-launch-key ~/.ssh/demo.pem  | jq -r ".PasswordData"
```
👆
Ideally, you join your windows instance into your active directory, and fixed user and password is available for you.



### how to access windows instance using ansible
you don't need script
https://github.com/ansible/ansible-documentation/tree/devel/examples/scripts



## Intall helm
```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

## Install Prometheus

```
kubectl create namespace prometheus
sudo helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
sudo helm repo update
sudo helm install prometheus prometheus-community/prometheus -n prometheus --kubeconfig=/etc/rancher/k3s/k3s.yaml
kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext -n prometheus
```


## Install Grafana

```
kubectl create namespace grafana
sudo helm repo add grafana https://grafana.github.io/helm-charts
sudo helm repo update
sudo helm install grafana grafana/grafana -n grafana --kubeconfig=/etc/rancher/k3s/k3s.yaml
kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-ext -n grafana
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

### Login Grafana
```
username:admin
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```

```
kubectl delete service grafana-ext -n grafana
kubectl delete service prometheus-server-ext -n prometheus
```

sudo helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n prometheus --kubeconfig=/etc/rancher/k3s/k3s.yaml

kubectl expose service kube-prometheus-stack-operator --type=NodePort --target-port=9090 --name=prometheus-server-ext -n prometheus
kubectl expose service kube-prometheus-stack-grafana --type=NodePort --target-port=3000 --name=grafana-ext -n prometheus
kubectl get secret kube-prometheus-stack-grafana -o jsonpath="{.data.admin-password}" -n prometheus | base64 --decode ; echo


## Ref
- https://spacelift.io/blog/prometheus-kubernetes
- https://medium.com/@gayatripawar401/deploy-prometheus-and-grafana-on-kubernetes-using-helm-5aa9d4fbae66