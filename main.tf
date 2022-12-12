terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.32.2"
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
  privkey_location = "~/.ssh/ansible"
  pubkey_location = "~/.ssh/ansible.pub"
}

resource "hcloud_firewall" "fw-rules" {
  name = "ssh-plus-9000"

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "9000"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

}

# Create a new server running debian
resource "hcloud_server" "node1" {
  name        = "hetzner-vm"
  image       = "ubuntu-22.04"
  server_type = "cx11"
  ssh_keys    = [hcloud_ssh_key.default.id]
  firewall_ids = [hcloud_firewall.fw-rules.id]

  ## hack: this remote-exec provisioner will retry until a ssh connection can be made (ergo: the instance is up)
  ## at this point the local-exec below can start. The local exec has no retry and no idea when the instance is ready.
  provisioner "remote-exec" {
    inline = ["echo instance is up!"]

    connection {
      host        = self.ipv4_address
      type        = "ssh"
      user        = "root"
      private_key = file(local.privkey_location)
    }
  }

  provisioner "local-exec" {
	command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${self.ipv4_address},' --private-key ${local.privkey_location} -e 'pubkey_location=${local.pubkey_location}' ansible-setup.yml"
  }

}

resource "hcloud_ssh_key" "default" {
  name       = "TF managed ssh key"
  public_key = file(local.pubkey_location)
}

output "instance_ip" {
  description = "IP of the VM"
  value       = hcloud_server.node1.ipv4_address
}

