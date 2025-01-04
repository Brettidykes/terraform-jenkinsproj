variable "aws_region" {
  default = "us-east-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-0e2c8caa4b6378d8c" #Ubuntu
}

variable "key_name" {
  description = "Windows_EC2_Project_Key"
}

variable "jenkins_sg_name" {
  default = "jenkins-security-group"
}

variable "bucket_name" {
  description = "S3 bucket for Jenkins artifacts"
}

variable "my_ip" {
  description = "Your personal public IP"
  type        = string
}
