// Map updated
output "result" {
  value = "${merge(var.source_map, var.new_values)}"
}
