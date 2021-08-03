# Module modules/utils/updatemap version 1.0.0

Utility for merging 2 maps into a single map.

## Description

The value added with the variables `new_values` will integrate the missing values and override the already existing
maps in the `source_map`.

## Requirements

terraform ~> 0.10.4

## Usage
```
module "updated_map" {
  source     = "modules/utils/updatemap"
  source_map = "${var.original_map}"
  new_values = "${var.new_values}"
}

resource "aws_instance" "instance" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"

  tags          = "${module.updated_map.result}"
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| new_values | New value to integrate | map | - | yes |
| source_map | Map to be updated | map | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| result | Map updated |

