resource "aws_iam_role" "codebuild-role" {
  name = "${var.resource-name}-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild-role-policy" {
  role        = "${aws_iam_role.codebuild-role.name}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_codebuild_project" "build-project" {
  name         = "${var.resource-name}-project"
  build_timeout      = "10"
  service_role = "${aws_iam_role.codebuild-role.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "NO_CACHE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "ubuntu/python/2.7.12"
    type         = "LINUX_CONTAINER"
  }

  source {
    type            = "CODECOMMIT"
    location        = "${aws_codecommit_repository.repository.clone_url_http}"
    git_clone_depth = 1
  }
}