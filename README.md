# Hetzner Workstation

This sets up a workstation VM at Hetzner Cloud.

Prerequisites:
* store the Hetzner API token in `$HOME/.hetzner/token`
* have `ansible` and `ansible.pub` keys in `~/.ssh`
* have Terraform installed

If you want to see what images Hetzner offers, run:
`curl -s -H "Authorization: Bearer $(cat ~/.hetzner/token)"  https://api.hetzner.cloud/v1/images?page=3`

## Creation

What you get: a user philipp that is in group sudo (nopasswd for them) and .dotfiles is already present. Remember to set a password on first login (`sudo passwd $USER`)

```
terraform init \
&& terraform apply -var hcloud_token=$(cat $HOME/.hetzner/token) \
&& ssh-keygen -R $(terraform output -raw instance_ip) \
&& ssh-add $HOME/.ssh/ansible \
&& ssh $USER@$(terraform output -raw instance_ip)
```

## Destruction

`terraform destroy -var hcloud_token=$(cat ~/.hetzner/token)`
