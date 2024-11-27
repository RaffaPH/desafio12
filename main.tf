provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2 (Free Tier)
  instance_type = var.ec2_instance_type
  tags          = var.tags

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              echo "Bienvenido a mi servidor Apache" > /var/www/html/index.html
              mkfs.ext4 /dev/xvdf
              mkdir -p /desafios
              mount /dev/xvdf /desafios
              echo "/dev/xvdf /desafios ext4 defaults,nofail 0 2" >> /etc/fstab
              aws s3 cp s3://${aws_s3_bucket.test_bucket.bucket}/desafio.pdf /desafios/desafio.pdf
              EOF
}

resource "aws_security_group" "web_sg" {
  name   = "web_sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_s3_bucket" "test_bucket" {
  bucket_prefix = "facu-miglio-actividad-aws-"
  acl           = "private"
  tags          = var.tags
}

resource "aws_s3_bucket_object" "test_file" {
  bucket = aws_s3_bucket.test_bucket.id
  key    = "desafio.pdf"
  source = "ruta/a/tu/desafio.pdf" # Reemplaza con la ruta local del archivo
  tags   = var.tags
}

resource "aws_ebs_volume" "example" {
  availability_zone = aws_instance.web_server.availability_zone
  size              = var.ebs_volume_size
  tags              = var.tags
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.web_server.id
}
