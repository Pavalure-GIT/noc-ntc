resource "aws_iam_role" "ecsServiceRoleNOLNTC" {
  name = "ecsServiceRoleNOLNTC_ntc${terraform.workspace}"
  tags   = "${merge(local.tags, map("Name", "ecsServiceRoleNOLNTC_ntc${terraform.workspace}"))}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "ecsInstanceProfile" {
  name = "ecsInstanceProfile_ntc${terraform.workspace}"
  role = "${aws_iam_role.ecsInstanceRole.name}"
}


resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerServiceforEC2Role" {
  role       = "${aws_iam_role.ecsInstanceRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  
}


resource "aws_iam_role" "ecsInstanceRole" {
  name = "ecsInstanceRole_ntc${terraform.workspace}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "EC2ContainerServiceRoleNOLNTC" {
  name        = "EC2ContainerServiceRoleNOLNTC_ntc${terraform.workspace}"
  description = "Policy that is used as part of the ecsServiceRoleNOLNTC nol ${terraform.workspace}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:Describe*",
                "elasticloadbalancing:Deregister*",
                "elasticloadbalancing:Describe*",
                "elasticloadbalancing:Register*",
                "ecs:DiscoverPollEndpoint",
                "ecs:Poll",
                "ecs:RegisterContainerInstance",
                "ecs:StartTask",
                "ecs:StartTelemetrySession",
                "ecs:Submit*",
                "ecr:BatchCheckLayerAvailability",
                "ecr:ListImages",
                "ecr:BatchGetImage",
                "ecr:PutImage",
                "ecr:UploadLayerPart",
                "ecr:InitiateLayerUpload",
                "ecr:GetDownloadUrlForLayer",
                "ecr:DescribeImages",
                "ecr:GetAuthorizationToken",
                "ecr:CompleteLayerUpload",
                "s3:GetObject",
                "s3:HeadObject"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ParameterStoreFullAccessNOLNTC" {
  name        = "ParameterStoreFullAccessNOLNTC_ntc${terraform.workspace}"
  description = "Policy that is used to access the NOLNTC parameter store"
  policy      = "${data.template_file.ntc_parameterstore.rendered}"
}

resource "aws_iam_role_policy_attachment" "EC2ContainerServiceRoleNOLNTC" {
  role       = "${aws_iam_role.ecsServiceRoleNOLNTC.name}"
  policy_arn = "${aws_iam_policy.EC2ContainerServiceRoleNOLNTC.arn}"
}

resource "aws_iam_role_policy_attachment" "ParameterStoreFullAccessNOLNTC1" {
  role       = "${aws_iam_role.ecsInstanceRole.name}"
  policy_arn = "${aws_iam_policy.ParameterStoreFullAccessNOLNTC.arn}"
}

resource "aws_iam_role_policy_attachment" "ParameterStoreFullAccessNOLNTC" {
  role       = "${aws_iam_role.ecsServiceRoleNOLNTC.name}"
  policy_arn = "${aws_iam_policy.ParameterStoreFullAccessNOLNTC.arn}"
}

data "template_file" "ntc_parameterstore" {
  template = "${file(format("%s/assets/ntc_parameterstore.json", path.module))}"

  vars {
    account_id = "${data.aws_caller_identity.aws_account.account_id}"
  }
}

