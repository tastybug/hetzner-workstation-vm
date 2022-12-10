# Hetzner Workstation

This sets up a workstation VM at Hetzner Cloud.

Prerequisites:
* store the API token in `~/.hetzner/token`
* have Terraform installed

## Creation 

What you get: a user philipp that is in group sudo (nopasswd for them) and .dotfiles is already present. Remember to set a password on first login (`sudo passwd $USER`)

```
terraform init \
&& terraform apply -var hcloud_token=$(cat ~/.hetzner/token) \
&& ssh-keygen -R $(terraform output -raw instance_ip) \
&& ssh-add /home/philipp/.ssh/ansible \
&& ssh philipp@$(terraform output -raw instance_ip)
```


## Destruction

`terraform destroy -var hcloud_token=$(cat ~/.hetzner/token)`
