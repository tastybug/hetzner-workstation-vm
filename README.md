# Hetzner Workstation

This sets up a workstation VM at Hetzner Cloud.

Prerequisites:
* store the API token in `~/.hetzner/token`
* have Terraform installed

Run `terraform init && terraform apply -var hcloud_token=$(cat ~/.hetzner/token) && ssh-keygen -R $(terraform output -raw instance_ip) && ssh philipp@$(terraform output -raw instance_ip)`.

What you get: a user philipp that is in group sudo (nopasswd for them) and .dotfiles is already present. Remember to set a password on first login (`sudo passwd $USER`)
