// Resulting output
output "result" {
  value = "${join(var.separator, var.input)}"
}
