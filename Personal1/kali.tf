## This was asked for for the IT Health check. Show this now be removed?
## Who knows what to do for the best. Ill comment it out anyway as its probably
## not a good idea to have this knocking about .... 


# resource "aws_security_group" "kali_sg" {
#   vpc_id = "${module.vpc_mgmt.vpc_id}"

#   count = "${terraform.workspace != "nonproduction" ? 1 : 0}"

#   ingress {
#     from_port = 22
#     to_port = 22
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port = 8834
#     to_port = 8834
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = -1
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags   = "${merge(module.tags.tags, map("Name", "Kali security group access"))}"
# }

# resource "aws_instance" "instance" {
#   ami                    = "ami-0effb6b7c7602646a"
#   instance_type          = "t2.xlarge"
#   iam_instance_profile   = "ecsInstanceProfile"
#   vpc_security_group_ids = ["${aws_security_group.kali_sg.id}"]
#   subnet_id              = "${module.vpc_mgmt_subnets.subnet_ids[0]}"
#   ebs_optimized          = false
#   key_name               = "nol_key1"
#   private_ip             = "10.92.20.11"
#   count = "${terraform.workspace != "nonproduction" ? 1 : 0}"
#   user_data = "${data.template_file.kaliuserdata.rendered}"
#   tags {
#     Name = "Kali"
#   }
# }

# data "template_file" "kaliuserdata" {
#   template = "${file("${path.module}/assets/kali-userdata.tpl")}"

# }