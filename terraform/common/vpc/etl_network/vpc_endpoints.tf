# Security Group - VPC Endpoints
resource "aws_security_group" "endpoints" {
  description = "Security Group for VPC Endpoints"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.default_tags,
    {
      Name = lower(replace("${var.default_tags.Application}-etl-private-${var.short_environment}-${var.short_region}", "_", "-"))
    }
  )
}

# VPC Endpoints
resource "aws_vpc_endpoint" "interface" {
  count               = length(local.vpc_endpoints_interface_list)
  vpc_id              = aws_vpc.vpc.id
  service_name        = local.vpc_endpoints_interface_list[count.index]
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = "true"
  security_group_ids  = [aws_security_group.endpoints.id]
  subnet_ids          = aws_subnet.private.*.id

  tags = merge(
    var.default_tags,
    {
      Name = lower(replace(replace("${var.default_tags.Application}-etl-${var.vpc_endpoints_interface[count.index]}-${var.short_environment}-${var.short_region}", "_", "-"), ".", "-"))
    }
  )
}

data "aws_iam_policy_document" "s3_vpc_endpoint_policy" {
  statement {
    sid     = "DataLakeBuckets"
    actions = ["s3:*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      # This pattern covers the environment buckets that follow our naming convention and a few on top of that:
      #   "arn:aws:s3:::*-data-lake*${var.short_environment}*${var.short_region}",
      # Ex.  arn:aws:s3:::pnp-data-lake-dev-stz-crm-euw1
      #      arn:aws:s3:::pnp-data-lake-dev-bi-emr-logs-euw1
      #      arn:aws:s3:::pnp-data-lake-logging-dev-euw1
      "arn:aws:s3:::*-data-lake*${var.short_environment}*${var.short_region}",
      "arn:aws:s3:::*-data-lake*${var.short_environment}*${var.short_region}/*",
      # Add any additional bucket requirements here:
      "arn:aws:s3:::pnp-data-lake-etl-scripts-${var.short_region}",
      "arn:aws:s3:::pnp-data-lake-etl-scripts-${var.short_region}/*",
      "arn:aws:s3:::pnp-data-lake-etl-deployment-lambda-${var.environment}-${var.aws_region}",
      "arn:aws:s3:::pnp-data-lake-etl-deployment-lambda-${var.environment}-${var.aws_region}/*",
      "arn:aws:s3:::pnp-data-lake-glue-schema-${var.short_region}-${var.aws_region}",
      "arn:aws:s3:::pnp-data-lake-glue-schema-${var.short_region}-${var.aws_region}/*",
    ]
  }

  statement {
    # During the development phase, allow all clusters to read from the production EMR bootstrapping scripts bucket.
    sid     = "TempBootstrap"
    actions = ["s3:*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::pnp-data-lake-*-bi-emr-bootstrap-${var.short_region}",
      "arn:aws:s3:::pnp-data-lake-*-bi-emr-bootstrap-${var.short_region}/*",
      "arn:aws:s3:::pnp-data-lake-*-bi-emr-logs-${var.short_region}",
      "arn:aws:s3:::pnp-data-lake-*-bi-emr-logs-${var.short_region}/*",
    ]
  }

  statement {
    # The development and production EMR clusters use resources from both of those environments.  Allow both environments
    # to copy objects between and list object in both environments' acquisition layer buckets.
    # Using a wildcard to include QA, since it will likely have the same requirements untill we move to the ETL framework.
    sid     = "TempAcz"
    actions = [
      "s3:GetObject",
      "s3:List*",
      "s3:PutObject",
      "s3:DeleteObject", # Require when moving objects.
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::pnp-data-lake-*-acz*${var.short_region}",
      "arn:aws:s3:::pnp-data-lake-*-acz*${var.short_region}/*",
      "arn:aws:s3:::pnp-data-lake-*-stz*${var.short_region}",
      "arn:aws:s3:::pnp-data-lake-*-stz*${var.short_region}/*",
    ]
  }

  statement {
    sid     = "EMRScripts"
    actions = ["s3:*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::aws-glue-scripts-538635328987-${var.aws_region}",
      "arn:aws:s3:::aws-glue-scripts-538635328987-${var.aws_region}/*"
    ]
  }

  statement {
    sid     = "ECR"
    actions = ["s3:*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::prod-${var.aws_region}-starport-layer-bucket/*",
      "arn:aws:s3:::prod-${var.aws_region}-starport-layer-bucket",
    ]
  }

  statement {
    sid     = "DataPipeline"
    actions = ["s3:*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::datapipeline-${var.aws_region}/*",
      "arn:aws:s3:::datapipeline-${var.aws_region}",
    ]
  }

  statement {
    # Enable Amazon Linux 1 and 2 AMIs to do Yum updates.
    sid     = "YumUpdates"
    actions = ["s3:*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::${var.aws_region}.elasticmapreduce",
      "arn:aws:s3:::${var.aws_region}.elasticmapreduce/*",
      "arn:aws:s3:::amazonlinux-2-repos-${var.aws_region}",
      "arn:aws:s3:::amazonlinux-2-repos-${var.aws_region}/*",
      "arn:aws:s3:::amazonlinux.${var.aws_region}.amazonaws.com",
      "arn:aws:s3:::amazonlinux.${var.aws_region}.amazonaws.com/*",
      "arn:aws:s3:::packages.${var.aws_region}.amazonaws.com",
      "arn:aws:s3:::packages.${var.aws_region}.amazonaws.com/*",
      "arn:aws:s3:::repo.${var.aws_region}.amazonaws.com",
      "arn:aws:s3:::repo.${var.aws_region}.amazonaws.com/*",
      "arn:aws:s3:::repo.${var.aws_region}.emr.amazonaws.com",
      "arn:aws:s3:::repo.${var.aws_region}.emr.amazonaws.com/*",
    ]
  }

  statement {
    sid     = "EMREnableApplicationHistory"
    actions = ["s3:*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::prod.${var.aws_region}.appinfo.src/*",
      "arn:aws:s3:::prod.${var.aws_region}.appinfo.src",
    ]
  }
}

resource "aws_vpc_endpoint" "gateway" {
  count           = length(local.vpc_endpoints_gateway_list)
  vpc_id          = aws_vpc.vpc.id
  service_name    = local.vpc_endpoints_gateway_list[count.index]
  route_table_ids = aws_route_table.private.*.id
  policy          = var.vpc_endpoints_gateway[count.index] == "s3" ? data.aws_iam_policy_document.s3_vpc_endpoint_policy.json : null

  tags = merge(
    var.default_tags,
    {
      Name = lower(replace(replace("${var.default_tags.Application}-etl-${var.vpc_endpoints_gateway[count.index]}-${var.short_environment}-${var.short_region}", "_", "-"), ".", "-"))
    }
  )
}
