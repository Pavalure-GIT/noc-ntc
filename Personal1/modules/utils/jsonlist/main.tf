/**
# Module modules/utils/jsonlist version 1.0.0

Utility for converting a Terraform list in a JSON string. The main scope is for improving the readability of main
modules.

## Requirements

terraform ~> 0.10.4

## Usage
```
* module "jsonlist" {
*   source = "modules/utils/jsonlist"
*   input  = ["value1", "value2"]
* }
*
* output "out" {
*   value = "${module.jsonlist.output}"
* }
```
*/

terraform {
  required_version = ">=0.10.4"
}
