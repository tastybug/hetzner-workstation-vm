terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.30.0"
    }
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

variable "hcloud_token" {
  sensitive = true
}

locals {
  pubkey_content = file("~/.ssh/id_rsa.pub")
}

# Create a new server running debian
resource "hcloud_server" "node1" {
  name        = "node1"
  image       = "debian-11"
  server_type = "cx11"
  ssh_keys    = [hcloud_ssh_key.default.id]

  # https://cloudinit.readthedocs.io/en/latest/topics/examples.html
  user_data   = <<-EOT
  #cloud-config
  package_update: true
  packages:
   - git
  users:
   - name: root
  runcmd:
   - [usermod, --shell, /bin/bash, root]
   - [git, clone, https://github.com/tastybug/dotfiles-ansible, /root/.dotfiles]
   - [sed, -i, -e, '$aPasswordAuthentication no', /etc/ssh/sshd_config]
   - [systemctl, restart, sshd]
  EOT
}

resource "hcloud_ssh_key" "default" {
  name       = "TF managed ssh key"
  public_key = local.pubkey_content 
}

output "instance_ip" {
  description = "IP of the VM"
  value       = hcloud_server.node1.ipv4_address
}

