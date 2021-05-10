# packer-proxmox-ubuntu2004

[![Github Actions](https://img.shields.io/github/workflow/status/justin-p/packer-proxmox-ubuntu2004/CI?label=Github%20Actions&logo=github&style=flat-square)](https://github.com/justin-p/packer-proxmox-ubuntu2004/actions)

Packer files to build Ubuntu 20.04 (subiquity-based) images on Proxmox. Ansible is used for 'pre' and 'post' provisioning tasks. 
Intended to be used in combination with [this Terraform module.](https://github.com/justin-p/terraform-proxmox-ubuntu2004)

Pre-provisioning tasks are used to dynamically generated local files such as the cloud-init user-data. This allows you to easily change the username/password used for the initial user created by cloud-init. SSH keys for the initial account are also generated and stored in the `output/ssh_keys` folder.

Post-provisioning tasks currently disable password based authentication in the sshd_config. This is enabled by cloud-init during the provisioning. The current packer proxmox provider does not support key based authentication and needs to connect with ssh during the provisioning [to verify if cloud-init has finished](https://github.com/justin-p/packer-proxmox-ubuntu2004/blob/72153e30393ede40f12b610d4961c9a0f26fa43c/ubuntu2004.pkr.hcl#L55). 

Since the cloud-init template adds a public key to [authorized_keys](https://github.com/justin-p/packer-proxmox-ubuntu2004/blob/d53fdda704347affb6b74668ee2915100efc8a94/playbooks/templates/user-data.j2#L24) file password based authentication is not needed after image creation and thus disabled once packer verifies that cloud-init has finished.

Another post-provisioning is to ensure the template is 'cloud-init ready'. This is added so Terraform can setup the new networking configuration (for example: correct bridge/vlan + static ip). In order for this to work properly cloud-init must be 'enabled/in unfinished state' when Terraform first boots the cloned image. Besides enabling/placing cloud-init in a unfinished state, files added by subiquity should also be removed in order for cloud-init to manage netplan. This way cloud-init can create a new netplan configuration during the initial boot of the cloned image.

The idea is to add a provisioner to the Terraform code that disables cloud-init after the deployment. The Terraform code/cloud-init should not manage netplan from that point onward. The [current provider](https://github.com/danitso/terraform-provider-proxmox) I use also [doesn't support this (errors out)](https://github.com/danitso/terraform-provider-proxmox/issues/91) and if enforced sometimes breaks the password of the cloud-init created user.

Initial code is based on [prior work](https://github.com/aerialls/madalynn-packer) by [Julien Brochet](https://twitter.com/aerialls). [Link to his blog post](https://www.aerialls.io/posts/ubuntu-server-2004-image-packer-subiquity-for-proxmox/).

## Usage

- `git clone https://github.com/justin-p/packer-proxmox-ubuntu2004`
- `cd packer-proxmox-ubuntu2004`
- `cp secrets.auto.pkrvars.hcl.example secrets.auto.pkrvars.hcl`
- Overwrite desired variables in `secrets.auto.pkrvars.hcl`.
  See `variables.pkr.hcl` for all variables, most have sane defaults. The `secrets.auto.pkrvars.hcl.example` file includes most variables you want to overwrite.
- `packer build .`  
  *Ensure the machine you are running packer from can be reached by the guest VM. Packer spins up a HTTP server to transmit the cloud-init template. Using [template_network_bridge](https://github.com/justin-p/packer-proxmox-ubuntu2004/blob/d41c5ba08b2770d3d3753659ad54af0eb75491c9/variables.pkr.hcl#L98) might help you.*

## License

MIT

## Author Information

- Justin Perdok ([@justin-p](https://github.com/justin-p/))

## Contributing

Feel free to open issues, contribute and submit your Pull Requests. You can also ping me on Twitter ([@JustinPerdok](https://twitter.com/JustinPerdok)).
