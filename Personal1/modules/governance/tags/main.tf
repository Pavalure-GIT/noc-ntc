/**
# Module modules/governance/tags version 1.0.0

Minimum set of required tags for governance purposes.

_NB. The tag Name should be unique for each resource generated, therefore it has been excluded from this module._

## Requirements

terraform ~> 0.10.4

## Usage

```
* module "tags" {
*   source          = "modules/governance/tags"
*   tag_environment = "Environment referenced"
*   tag_application = "Application referenced"
*   tag_costcode    = "Costcode"
*   tag_owner       = "Product owner"
* }
```

The output generated is a map containing the required tags.

```
* resource "aws_instance" "instance" {
*   ami           = "${var.ami}"
*   instance_type = "${var.instance_type}"
*
*   tags          = "${module.tags.tags}"
* }
```

If needed, the resulting map can be updated using the module
[`modules/utils/updatemap`](../../../modules/utils/updatemap/README.md)

```
* module "updated_tags" {
*   source     = "modules/utils/updatemap"
*   source_map = "${modules.tags.tags}"
*   new_values = "${var.new_values}"
* }
*
* resource "aws_instance" "instance" {
*   ami           = "${var.ami}"
*   instance_type = "${var.instance_type}"
*
*   tags          = "${module.updated_tags.result}"
* }
```
*/

terraform {
  required_version = ">=0.10.4"
}
