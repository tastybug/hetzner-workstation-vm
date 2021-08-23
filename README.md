# Hetzner Workstation

This sets up a workstation VM at Hetzner Cloud.

Prerequisites:
* store the API token in `~/.hetzner/token`
* have Terraform installed

Run `terraform apply -var hcloud_token=$(cat ~/.hetzner/token)`.

### Further reads on cloud-init

* https://cloudinit.readthedocs.io/en/latest/topics/examples.html
* https://www.digitalocean.com/community/tutorials/how-to-use-cloud-config-for-your-initial-server-setup
