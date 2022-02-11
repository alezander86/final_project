#for static ip ElasticIP

#output "Webserver_public_ip" {
#  value = aws_eip_association.eip_assoc.public_ip
#}

#output "Webserver_public_ip_db" {
#  value = aws_eip_association.eip_assoc_db.public_ip
#}

#automate dynamic public_ip

output "Webserver_public_ip" {
  value = aws_instance.ubuntu_webserver.public_ip
}

output "Webserver_public_ip_db" {
  value = aws_instance.ubuntu_webserver_db.public_ip
}

#automate dynamic private_ip

output "Webserver_private_ip" {
  value = aws_instance.ubuntu_webserver.private_ip
}

output "Webserver_private_ip_db" {
  value = aws_instance.ubuntu_webserver_db.private_ip
}

output "Webserver_id" {
  value = "${aws_instance.ubuntu_webserver.id}"
}

output "Webserverdb_id" {
  value = "${aws_instance.ubuntu_webserver_db.id}"
}

# vpc id

output "vpc_id" {
  value = "${aws_vpc.prod-vpc.id}"
}

# vpc security_group_id

output "security_group_id" {
  value = "${aws_security_group.allowed.id}"
}

# ami names

output "ubuntu_webserver_ami_id" {
  value = "${data.aws_ami.latest_ubuntu.id}"
}

output "ubuntu_webserver_ami_name" {
  value = "${data.aws_ami.latest_ubuntu.name}"
}

#output "ssh_key" {
#  value = "${tls_private_key.pk.private_key_pem}"
#}
