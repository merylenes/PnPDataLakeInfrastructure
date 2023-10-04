resource "aws_iam_user" "user" {
  name = "${var.user_name}-${var.short_environment}-${var.short_region}"
  tags = var.tags
}

resource "aws_iam_user_policy" "policy" {
  name = "${var.user_name}-${var.short_environment}-${var.short_region}"
  user = aws_iam_user.user.name

  policy = var.policy.json
}