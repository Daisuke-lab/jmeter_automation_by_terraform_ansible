# Install ansible
```
$ sudo apt update
$ sudo apt install software-properties-common
$ sudo add-apt-repository --yes --update ppa:ansible/ansible
$ sudo apt install ansible
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
ansible-playbook -i inventory_aws_ec2.yaml playbook.yaml --check
```