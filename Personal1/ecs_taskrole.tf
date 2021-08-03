resource "aws_iam_role" "nolntc-default-task" {
  name = "nolntc-default-task_ntc${terraform.workspace}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "nolntc-default-task-profile" {
  name = "nolntc-default-task-profile_ntc${terraform.workspace}"
  role = "${aws_iam_role.nolntc-default-task.name}"
}


resource "aws_iam_policy" "nolntc-default-task-policy" {
  name        = "nolntc-default-task-policy_ntc${terraform.workspace}"
  description = "Policy that is used as part of the ECS task for ntc ${terraform.workspace}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "kms:ListKeys",
                "ssm:DescribeParameters",
                "kms:ListAliases",
                "ecr:*",
                "logs:*",
                "logs:CreateLogStream"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:Describe*",
                "ssm:GetParameters"
            ],
            "Resource": [
                "arn:aws:ssm:${var.region}:${data.aws_caller_identity.aws_account.account_id}:parameter/*",
                "arn:aws:kms:${var.region}:${data.aws_caller_identity.aws_account.account_id}:key/alias/aws/ssm"
            ]
        }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "nolntc-default-task-pa" {
  role       = "${aws_iam_role.nolntc-default-task.name}"
  policy_arn = "${aws_iam_policy.nolntc-default-task-policy.arn}"
}


