# Module modules/utils/concat version 1.0.0

Create a string from the list in input with the separator in the variable separator (default: `-`)

## Requirements

terraform ~> 0.10.4

## Usage

```
module "concat" {
  source = "modules/utils/concat"

  input = [
    "${var.var1}",
    "${var.var2}",
    "${var.var3}",
    "${var.var4}",
    "${var.var5}",
    "${var.var6}",
  ]

  separator = "%"
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| input | List of variables  in input | list | - | yes |
| separator | Separator | string | `-` | no |

## Outputs

| Name | Description |
|------|-------------|
| result | Resulting output |

