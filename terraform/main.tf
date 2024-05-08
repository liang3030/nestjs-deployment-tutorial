terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

# Declare the variable
variable "db_password" {
  type        = string
  description = "The password for the database"
}

variable "security_group_ids" {
  type    = list(string)
  default = []
}

variable "db_security_group_ids" {
  type    = list(string)
  default = []
}

# Create an instance
resource "aws_instance" "deployment-nestjs-ec2" {
  ami                         = "ami-098c93bd9d119c051"    # Specify your desired AMI ID
  instance_type               = "t2.micro"                 # Specify your desired instance type
  key_name                    = "deployment"               # Specify the key pair name
  subnet_id                   = "subnet-0afafaac4e3519899" # subnet ID that allows public IP
  associate_public_ip_address = true                       # Ensure that the instance gets a public IP address


  vpc_security_group_ids = var.security_group_ids # Set the security group IDs
  tags = {
    Name = "Deployment-NestJS-Instance"
  }
}

resource "aws_db_instance" "my_postgresql_instance" {
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16.1"
  instance_class         = "db.t3.micro" # Replace with your desired instance class
  username               = "postgres"
  password               = var.db_password
  db_name                = "demo"
  port                   = 5432
  availability_zone      = "eu-central-1a"
  vpc_security_group_ids = var.db_security_group_ids
  skip_final_snapshot    = true
}
