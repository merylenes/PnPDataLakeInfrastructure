module "mvnx_bucket" {
  source = "../../modules/s3"

  bucket_name = "mvnx"
  policy = data.aws_iam_policy_document.mvnx_bucket_policy.json

  application_name = var.application_name
  project_name = var.project_name
  department = var.department

  # NOTE 20201208:  Terraform plan output showed these grants as marked for removal.  Added here to create clean plan during upgrade.
  grants = [
    {
      enabled     = true
      id          = "66c50d7dba7b8b7ad31ac725250414bf57021bdb9f89e011ba7a63d2e64aef70"
      type        = "CanonicalUser"
     permissions  = ["READ", "READ_ACP", "WRITE", "WRITE_ACP"]
      uri         = null
    },
    {
      enabled     = true
      id          = "c6cae3d66864bcafd4668755353018dce830f486fbafd8c1b8968e06d9bb4e30"
      type        = "CanonicalUser"
      permissions = ["READ", "READ_ACP"]
      uri         = null
    }
  ]
}

data "aws_iam_policy_document" "mvnx_bucket_policy" {
  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:GetBucketAcl",
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    effect = "Allow"

    resources = [
      "arn:aws:s3:::pnp-data-lake-pnp-mobile-mvnx/*",
      "arn:aws:s3:::pnp-data-lake-pnp-mobile-mvnx",
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.aws_account_ids_external.data_science}:root",
        # "arn:aws:iam::${var.aws_account_ids_external.data_science}:role/pnp-data-science-mvnx"  # NOTE 20201208:  Shows as a diff during planning.  Remove to create clean plan during upgrade.
      ]
    }
  }
}