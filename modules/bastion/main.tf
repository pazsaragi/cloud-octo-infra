variable "key_name" {}

variable "public_key" {}

variable "vpc_id" {}

variable "ami" {
  default = "ami-0d37e07bd4ff37148"
}
variable "instance_type" {
  default = "t2.micro"
}

resource "aws_key_pair" "bastion_key" {
  key_name   = var.key_name
  public_key = var.public_key
}

resource "aws_security_group" "bastion" {
  name   = "bastion-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
}

output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

