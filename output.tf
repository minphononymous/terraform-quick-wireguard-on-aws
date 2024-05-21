output "public_ip" {
  description = "The Public IP address used to access the instance"
  value       = aws_instance.wiregurad.public_ip
}

output "ssh_key" {
    description = "SSH keypair to access the instance"
    value = aws_key_pair.kp.key_name  
}
/*
output "connect_to_wireguard_server" {
  description = "Login to the wireguard to generate the wireguard config."
  value       = <<-EOT
                Use the following command to login into wireguard

                ssh -i ubuntu@${aws_instance.wireguard.public_ip}
                cd /opt/wireguard-server/config/peer1 && qrencode -t ansiutf8 < peer1.conf

                You should wait till all instances are fully ready in the EC2 console.
                The Status Check colunm should contain "2/2 checks passed"

                EOT
}
*/