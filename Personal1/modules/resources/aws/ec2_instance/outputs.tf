// ID of the instance
output "instance_id" {
  value = "${aws_instance.instance.id}"
}

// Public IP assigned to the instance
output "public_ip" {
  value = "${aws_instance.instance.public_ip}"
}

// Private IP assigned to the instance
output "private_ip" {
  value = "${aws_instance.instance.private_ip}"
}
