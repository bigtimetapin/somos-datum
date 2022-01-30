# This file was autogenerated by the scalambdaTerraform command from the Scalambda SBT plugin!

resource "aws_lambda_function" "main_lambda" {
  layers = [
    aws_lambda_layer_version.dependency_layer.arn
  ]
  function_name = "Main${title(terraform.workspace)}"
  s3_bucket = aws_s3_bucket.somos_download_lambda.id
  role = var.main_lambda_role_arn
  s3_key = aws_s3_bucket_object.sources.key
  tags = merge({}, var.main_lambda_billing_tags)
  depends_on = [
    aws_lambda_layer_version.dependency_layer
  ]
  memory_size = 1536
  source_code_hash = filebase64sha256(aws_s3_bucket_object.sources.source)
  publish = true
  s3_object_version = aws_s3_bucket_object.sources.version_id
  environment {
    variables = {
      SCALAMBDA_VERSION = "ae21cb3a410790d2043f0bdba0f993bff15bab54"
    }
  }
  timeout = 900
  handler = "world.somos.download.Main::handler"
  runtime = "java11"
}

resource "aws_lambda_layer_version" "dependency_layer" {
  s3_bucket = aws_s3_bucket_object.dependencies.bucket
  compatible_runtimes = [
    "java8",
    "java11"
  ]
  s3_key = aws_s3_bucket_object.dependencies.key
  description = "thick dependency layer created by Scalambda"
  layer_name = "download_assembled_dependencies"
  s3_object_version = aws_s3_bucket_object.dependencies.version_id
}

resource "aws_lambda_alias" "main_lambda_ae21cb3a410790d2" {
  name = "ae21cb3a410790d2043f0bdba0f993bff15bab54"
  description = "Managed by Scalambda. The name of this alias is the version of the code that this function is using. It is either a version of a commit SHA."
  function_name = aws_lambda_function.main_lambda.function_name
  function_version = aws_lambda_function.main_lambda.version
}
