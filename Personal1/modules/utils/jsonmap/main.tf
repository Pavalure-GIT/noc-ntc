/**
# Module modules/utils/jsonmap version 1.0.0

Utility for converting a Terraform map in a JSON string

## Requirements

terraform ~> 0.10.4

## Usage
```
* module "jsonmap" {
*   source = "modules/utils/jsonmap"
*   input  = {
*     key1 = "value1"
*     key2 = "value2"
*   }
* }
*
* output "out" {
*   value = "${module.jsonmap.output}"
* }
```
*/

terraform {
  required_version = ">=0.10.4"
}
