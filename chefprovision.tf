variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "instance_key" {
  type    = string
  default = "cptest"
}
variable "access_key" {
  type = string
}
variable "secret_access_key" {
  type = string
}
variable "ami" {
  type = string
}
variable "subnetID" {
  type = string
}
variable "securityGroups" {
  type = string
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_access_key
}
resource "aws_instance" "web" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnetID
  security_groups             = [var.securityGroups]
  associate_public_ip_address = true
  key_name                    = var.instance_key
  tags = {
    Name = "chefclient"
  }
  provisioner "chef" {
    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = aws_instance.web.public_ip
      private_key = file("/home/ubuntu/chefprovision/cptest.pem")
    }
    os_type                 = "linux"
    prevent_sudo            = false
    client_options          = ["chef_license 'accept'"]
    environment             = "_default"
    log_to_file             = true
    fetch_chef_certificates = true
    node_name               = "client1"
    server_url              = "https://ec2-54-89-95-15.compute-1.amazonaws.com/organizations/cloudlego"
    recreate_client         = true
    run_list                = [""]
    user_name               = "legoadmin"
    user_key                = file("/home/ubuntu/chefprovision/legoadmin.pem")
    ssl_verify_mode         = ":verify_none"
  }
}
