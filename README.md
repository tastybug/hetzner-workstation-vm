# Hetzner Workstation

This sets up a workstation VM at Hetzner Cloud.

Prerequisites:
* store the API token in `~/.hetzner/token`
* have Terraform installed

Run `terraform apply -var hcloud_token=$(cat ~/.hetzner/token)`.
