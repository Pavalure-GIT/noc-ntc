// Map converted
output "output" {
  value = "${jsonencode(var.input)}"
}
