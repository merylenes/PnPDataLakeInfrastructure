resource "aws_iam_role" "role" {
  name = "${var.project_name}-${var.role_name}"

  assume_role_policy = var.assume_role_policy.json

  tags = merge(
    var.tags,
    {
      Project = var.project_name,
      Application = var.application_name,
      Department = var.department,
    },
  )
}

resource "aws_iam_role_policy" "policies" {
  count = length(var.policies)
  name = "${var.project_name}-${var.role_name}-${count.index}"
  role = aws_iam_role.role.id
  policy = var.policies[count.index].json
}