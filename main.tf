terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_iam_role" "lab6role" {
  name = "lab6-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lab6policy" {
  name        = "policy"
  description = "Allow EC2 to access S3"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ],
        Effect   = "Allow",
        Resource = ["arn:aws:s3:::${var.s3_bucket_name}", "arn:aws:s3:::${var.s3_bucket_name}/*"]
      }
    ]
  })
}

resource "aws_instance" "lab6_instance" {
  ami                  = var.ubuntu_ami
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.lab_key.key_name
    iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  tags = {
    Name = "lab6-instance"
  }
}

resource "aws_s3_bucket" "lab6_bucket" {
  bucket = var.s3_bucket_name
  tags = {
    Env = "lab"
  }
}



resource "aws_iam_role_policy_attachment" "attachment" {
  policy_arn = aws_iam_policy.lab6policy.arn
  role       = aws_iam_role.lab6role.name
  depends_on = [aws_instance.lab6_instance] 
  lifecycle {
    ignore_changes = [policy_arn]  
  }
}
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.lab6role.name
}



// create a ssh key pair
resource "aws_key_pair" "lab_key" {
  key_name   = "lab6-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

// crate a ubuntu ec2 instance
resource "aws_iam_role_policy_attachment" "deattachment" {
  policy_arn = aws_iam_policy.lab6policy.arn
  role       = aws_iam_role.lab6role.name
  depends_on = [aws_instance.lab6_instance]  
  lifecycle {
    ignore_changes = [policy_arn] 
  }
}