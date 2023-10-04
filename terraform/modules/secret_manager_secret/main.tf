resource "aws_secretsmanager_secret" "secret" {
  name  = "secret/${var.application_name}-${var.project_name}-${var.secret_name}"

  tags = merge(
    var.tags,
    {
      Project = var.project_name,
      Application = var.application_name,
      Department = var.department,
    },
  )
}