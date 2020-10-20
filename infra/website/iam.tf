# User access policy
data "aws_iam_policy_document" "aws_website_policy" {
    statement {
        actions = ["s3:GetObject"]
        principals {
            identifiers = ["*"]
            type = "AWS"
        }
        resources = [
        "arn:aws:s3:::${var.domain_name}/*"
        ]
    }
}



#### Codepipeline
# Assume role
resource "aws_iam_role" "codepipeline_assume_role" {
  name               = "codepipeline-${var.domain_name}-role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
}
data "aws_iam_policy_document" "codepipeline_assume_role" {
    statement {
        effect = "Allow"

        principals {
            type = "Service"
            identifiers = ["codepipeline.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
        
      }
  }


# Template policy from file
data "template_file" "codepipeline_policy" {
  template = file("${path.module}/policies/code_pipeline_policy.json")

  vars = {
    aws_s3_bucket_arn           = aws_s3_bucket.aws_website.arn
    aws_s3_artifact_bucket_arn  = aws_s3_bucket.codepipeline_artifacts.arn
    aws_codebuild_project_arn   = aws_codebuild_project.build_project.arn
  }
}

# Policy
resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_assume_role.id
  policy = data.template_file.codepipeline_policy.rendered
}

#### Codebuild
# Assume role
resource "aws_iam_role" "codebuild_assume_role" {
  name               = "codebuild-${var.domain_name}-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}
data "aws_iam_policy_document" "codebuild_assume_role" {
statement {
        effect = "Allow"

        principals {
            type = "Service"
            identifiers = ["codebuild.amazonaws.com"]
        }

        actions = ["sts:AssumeRole"]
        
      }
  }

# Template policy from file
data "template_file" "codebuild_policy" {
  template = file("${path.module}/policies/codebuild_policy.json")

  vars = {
    aws_s3_bucket_arn = aws_s3_bucket.aws_website.arn
  }
}

# Policy
resource "aws_iam_role_policy" "codebuild_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codebuild_assume_role.id
  policy = data.template_file.codebuild_policy.rendered
}
