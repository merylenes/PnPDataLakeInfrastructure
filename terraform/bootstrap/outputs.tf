output "lambda_functions" {
  value = {
    trigger_lift_and_shift: data.aws_lambda_function.trigger_lift_and_shift
  }
}