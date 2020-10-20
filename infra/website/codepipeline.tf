resource "aws_codepipeline" "aws_website_pipeline" {
  name     = "${var.domain_name}-pipeline"
  role_arn = aws_iam_role.codepipeline_assume_role.arn

  #depends_on = ["aws_s3_bucket.bucket_site", "aws_s3_bucket.source"]

  artifact_store {
    location = "artifacts.${var.domain_name}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source"]

      configuration = {
        OAuthToken  = var.github_oauth_token
        Owner       = var.source_owner
        Repo        = var.source_repo
        Branch      = "master"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["source"]

      configuration = {
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }
}