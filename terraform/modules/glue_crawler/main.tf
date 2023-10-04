resource "aws_glue_crawler" "crawler" {
  database_name = var.database_name
  name          = var.database_name
  role          = var.role.arn

  s3_target {
    path = "s3://update_me"
  }

  configuration = <<-EOF
  {
    "Version":1.0,
    "Grouping": {
      "TableGroupingPolicy": "CombineCompatibleSchemas"
    }
  }
  EOF

  lifecycle {
    ignore_changes = [
      s3_target
    ]
  }
}
