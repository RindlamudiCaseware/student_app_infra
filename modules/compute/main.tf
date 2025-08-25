terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0"
    }
  }
}

# ---------------------------------------
# EC2(VM) CREATION
# ---------------------------------------

resource "aws_instance" "dev_deploy_ec2" {
  ami           = var.ami_name[0]
  instance_type = var.instance_typ[0]

  user_data_base64            = filebase64("automation.sh")
  associate_public_ip_address = true
  availability_zone           = var.azs[0]

  key_name = var.key_name
  ebs_block_device {
    device_name = var.device_name
    volume_type = var.vol_type
    volume_size = var.vol_size[0]
  }

  tags = {
    Name        = var.instance_name
    Environment = var.env[0]
  }
}