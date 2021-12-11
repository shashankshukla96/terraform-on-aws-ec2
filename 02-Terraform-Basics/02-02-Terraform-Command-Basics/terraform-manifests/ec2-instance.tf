# # Terraform Settings Block
# terraform {
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       #version = "~> 3.21" # Optional but recommended in production
#     }
#   }
# }

# # Provider Block
# provider "aws" {
#   profile    = "default" # AWS Credentials Profile configured on your local desktop terminal  $HOME/.aws/credentials
#   region     = "ap-south-1"
#   secret_key = "kq8ruRHvneMJ2n1OD7LOu5Nh6PXliIPDO75PPHfs"
#   access_key = "AKIAXUHYNQPAZKH3JXUA"
# }

# resource "aws_s3_bucket" "bucket" {
#   bucket = "shashank-demo-bucket-for-test"
# }

# resource "aws_s3_bucket_object" "object" {
#   bucket = "shashank-demo-bucket-for-test"
#   key    = "index.js"
#   source = "./index.js"
#   acl    = "public-read"

#   etag = filemd5("./index.js")
# }

# resource "aws_s3_bucket_object" "dist" {
#   for_each = fileset("./test_folder/", "*")

#   bucket = "shashank-demo-bucket-for-test"
#   key    = "folder/${each.value}"
#   source = "./test_folder/${each.value}"
#   # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
#   etag = filemd5("./test_folder/${each.value}")
#   acl  = "public-read"
# }

# resource "aws_efs_file_system" "demo_file_system" {
#   creation_token = "demo_fs"
#   lifecycle_policy {
#     transition_to_ia = "AFTER_30_DAYS"
#   }
# }

# data "aws_vpc" "selected" {
#   id = "vpc-03cbf7c9e5b3eb293"
# }

# output "vpc" {
#   value = data.aws_vpc.selected.cidr_block
# }

# resource "aws_security_group" "allow_nfs_sg" {
#   name        = "allow_nfs"
#   description = "Allow NFS inbound and outbound traffic"
#   vpc_id      = data.aws_vpc.selected.id

#   ingress {
#     description      = "Allow 2049"
#     from_port        = 2049
#     to_port          = 2049
#     protocol         = "tcp"
#     cidr_blocks      = [data.aws_vpc.selected.cidr_block]
#     # ipv6_cidr_blocks = [data.aws_vpc.selected.ipv6_cidr_block]
#   }

#   egress {
#     from_port        = 2049
#     to_port          = 2049
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "allow_nfs"
#   }
# }

# resource "aws_efs_mount_target" "alpha" {
#   file_system_id = aws_efs_file_system.demo_file_system.id
#   subnet_id      = "subnet-05ddf4e725635cd90"
#   security_groups = [ aws_security_group.allow_nfs_sg.id ]
# }


# resource "aws_datasync_location_efs" "destination_efs" {
#   efs_file_system_arn = aws_efs_file_system.demo_file_system.arn
#   subdirectory        = "/"

#   ec2_config {
#     security_group_arns = [aws_security_group.allow_nfs_sg.arn]
#     subnet_arn          = "arn:aws:ec2:ap-south-1:524506989505:subnet/subnet-05ddf4e725635cd90"
#   }

#   tags = {
#     Name = "destination_efs"
#   }
# }

# resource "aws_datasync_location_s3" "source_s3" {
#   s3_bucket_arn = aws_s3_bucket.bucket.arn
#   subdirectory  = "/"

#   s3_config {
#     bucket_access_role_arn = "arn:aws:iam::524506989505:role/service-role/AWSDataSyncS3BucketAccess-shashank-demo-bucket-for-test"
#   }

#   tags = {
#     Name = "source_s3"
#   }
# }

# resource "aws_datasync_task" "datasync_task" {
#   destination_location_arn = aws_datasync_location_efs.destination_efs.arn
#   name                     = "examlpe_datasync_task"
#   source_location_arn      = aws_datasync_location_s3.source_s3.arn

#   options {
#     bytes_per_second = -1
#     log_level        = "OFF"
#     verify_mode      = "NONE"
#   }

#   schedule {
#     schedule_expression = "cron(24/60 * * * ? *)"
#   }
# }