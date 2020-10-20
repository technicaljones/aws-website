resource "aws_codebuild_project" "build_project" {
  name           = "${var.short_name}-deploy"
  description    = "Build deploy project for ${var.short_name}"
  service_role   = aws_iam_role.codebuild_assume_role.arn
  build_timeout  = "5"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/ubuntu-base:14.04"
    type            = "LINUX_CONTAINER"
    privileged_mode = "false"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }
}