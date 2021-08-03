// Resulting map of tags
output "tags" {
  value = "${merge(
    map("Environment", var.tag_environment),
    map("Application", var.tag_application),
    map("Costcode", var.tag_costcode),
    map("Owner", var.tag_owner)
  )}"
}
