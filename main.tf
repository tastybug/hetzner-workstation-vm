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

# Create a new server running debian
resource "hcloud_server" "node1" {
  name        = "node1"
  image       = "debian-11"
  server_type = "cx11"
  ssh_keys    = [hcloud_ssh_key.default.id]
}

resource "hcloud_ssh_key" "default" {
  name       = "TF managed ssh key"
  public_key = file("~/.ssh/id_rsa.pub")
}

output "instance_ip" {
  description = "IP of the VM"
  value       = hcloud_server.node1.ipv4_address
}
