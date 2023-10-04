module "control_m_iam_user" {
  source = "../../modules/iam_user"

  user_name = "etl-control-m"

  short_environment = var.short_environment
  short_region = var.short_region
  tags = var.default_tags

  policy = data.aws_iam_policy_document.control_m_iam_user_policy
}

data "aws_iam_policy_document" "control_m_iam_user_policy" {

  statement {
    actions = [
      "states:DescribeExecution",
      "states:StartExecution",
      "states:StopExecution",
      "states:StartSyncExecution",
      "states:DescribeStateMachineForExecution",
      "states:GetExecutionHistory"
    ]
    effect = "Allow"

    resources = [
      "arn:aws:states:${var.aws_region}:${var.aws_account_id}:execution:pnp-data-lake-etl-sfn-${var.short_environment}-${var.aws_region}:*",
      "arn:aws:states:${var.aws_region}:${var.aws_account_id}:stateMachine:pnp-data-lake-etl-sfn-${var.short_environment}-${var.aws_region}"
    ]
  }

  statement {
    actions = [
      "states:ListStateMachines"
    ]
    effect = "Allow"

    resources = [
      "arn:aws:states:${var.aws_region}:${var.aws_account_id}:stateMachine:*"
    ]
  }  
}

module "control_m_validation_iam_user" {
  source = "../../modules/iam_user"

  user_name = "validation-control-m"

  short_environment = var.short_environment
  short_region = var.short_region
  tags = var.default_tags

  policy = data.aws_iam_policy_document.control_m_validation_iam_user_policy
}

data "aws_iam_policy_document" "control_m_validation_iam_user_policy" {

  statement {
    actions = [
      "states:DescribeExecution",
      "states:StartExecution",
      "states:StopExecution",
      "states:StartSyncExecution"
    ]
    effect = "Allow"

    resources = [
      "arn:aws:states:${var.aws_region}:${var.aws_account_id}:execution:pnp-data-lake-validation-sfn-${var.short_environment}-${var.aws_region}:*",
      "arn:aws:states:${var.aws_region}:${var.aws_account_id}:stateMachine:pnp-data-lake-validation-sfn-${var.short_environment}-${var.aws_region}"
    ]
  }

  statement {
    actions = [
      "states:ListStateMachines"
    ]
    effect = "Allow"

    resources = [
      "arn:aws:states:${var.aws_region}:${var.aws_account_id}:stateMachine:*"
    ]
  }  
}