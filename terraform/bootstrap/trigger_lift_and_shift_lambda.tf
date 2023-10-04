data "aws_lambda_function" "trigger_lift_and_shift" {
  function_name = "pnp-data-lake-etl-trigger_lift_and_shift-${var.environment}"
}