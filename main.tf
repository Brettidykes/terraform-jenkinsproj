resource "aws_instance" "jenkins_server" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.jenkins_sg.name]
  user_data       = file("userdata.sh")

  tags = {
    Name = "Jenkins-Server"
  }
}

resource "aws_s3_bucket" "jenkins_artifacts" {
  bucket = var.bucket_name

  tags = {
    Name = "Jenkins Artifacts Bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.jenkins_artifacts.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_security_group" "jenkins_sg" {
  name        = var.jenkins_sg_name
  description = "Security Group for Jenkins Server"

  tags = {
    Name = var.jenkins_sg_name
  }
}

# Allow SSH from IP
resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "your-ip/32"  # Replace with your actual IP
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# Allow Jenkins UI access on port 8080 from anywhere
resource "aws_vpc_security_group_ingress_rule" "jenkins_ui" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
}

# Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
}
