## Terraform configuration files to quickly provision a wiregurad server on an AWS's EC2 instance.
  - Change the AWS region you want on the variables.tf file.
  - Follow the output message of Terraform to import the wireguard conf to clients.
  - You may need to update the public IP on the WireGuard client if you rebooted the instance without an Elastic IP.

