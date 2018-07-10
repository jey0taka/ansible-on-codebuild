resource "aws_codecommit_repository" "repository" {
  repository_name = "${var.resource-name}-repository"
  default_branch = "master"
}