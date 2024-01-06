# Hetzner Workstation

This sets up a workstation VM at Hetzner Cloud.

Prerequisites:
* store the Hetzner API token in `$HOME/.hetzner/token`
* have `ansible` and `ansible.pub` keys in `~/.ssh`
* have Terraform installed

If you want to see what images Hetzner offers, run:
`curl -s -H "Authorization: Bearer $(cat ~/.hetzner/token)"  https://api.hetzner.cloud/v1/images?page=3`

## Creation and Destruction

What you get: a user philipp that is in group sudo (nopasswd for them) and .dotfiles is already present. Remember to set a password on first login (`sudo passwd $USER`)

```
make init apply connect
make destroy
```

