aws_profile         = "default"
aws_assume_role_arn = "arn:aws:iam::538635328987:role/20fifty_deployer"
application_name    = "pnp-data-lake"
aws_account_ids_external = {
  data_science : "491408137367",
  decision_support : "316585047597",
}

cidr_etl_network_vpc = "10.21.0.0/16"

cidr_etl_network_private = [
  "10.21.0.0/23",
  "10.21.64.0/23",
  "10.21.128.0/23",
]

cidr_etl_network_public = [
  "10.21.251.0/24",
  "10.21.252.0/24",
  "10.21.253.0/24",
]

buckets_ingestion_retention_days = {
  "default" : 182
}

buckets_external_config = {
  "stz_doc" : {
    "VirtualAssistant" : {
      "actions" : [
        "s3:GetObject"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::442224908429:role/pnp-air-lambda-api_rec_report_download-eu-west-1",
        "arn:aws:iam::442224908429:role/pnp-air-lambda-lex_fullfilment_rec_report-eu-west-1"
      ]
      "data_sets" : [
        "rpt/rec_rpt/*"
      ]
    }
  },
  "stz_retail" : {
    "PnPRedshift" : {
      "actions" : [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::316585047597:role/RedshiftS3Access-pnp-eu-decisionsupport-redshift",
        "arn:aws:iam::316585047597:role/AD-DecisionSupport-RedShiftAdmin"
      ]
      "data_sets" : [
        "md/article/article_bw_article_01/*",
        "md/site/site_bw_site_01/*",
        "md/time/time_bw_time_01/*",
        "td/sales/sales_bw_hrsaw01/*",
        "td/stock/stock_bw_hrstw15/*",
        "td/stock/stock_bw_hrstw16/*",
        "md/selling_price/selling_price_bw_hrspw02/*",
        "md/selling_price/selling_price_bw_hrspw04/*",
        "md/selling_price/selling_price_bw_hrspw05/*",
        "md/promotions/promotions_bw_promo_01/*",
        "md/selling_price/selling_price_bw_hrspw02/*",
        "md/selling_price/selling_price_bw_hrspw04/*",
        "md/selling_price/selling_price_bw_hrspw05/*",
        "md/promotions/promotions_bw_promo_01/*",
        "md/article/article_bw_articleuom_01/*",
        "md/article/article_bw_pricingfamilypurchorg_01/*",
        "md/article/article_bw_pricingfamilysalesorg_01/*",
        "td/rebates/rebates_bw_hrrbw01/*",
        "md/selling_price/selling_price_bw_hrspw01/*",
        "td/forecasting/forecasting_bw_hsfaw01/*",
        "md/sitearticle/sitearticle_bw_sitearticle_01/*"
      ]
    }
  },
  "stz_pos" : {
    "SapPO" : {
      "actions" : [
        "s3:Get*"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::491408137367:role/AD-Data-Science-GCCRAWL1",
        "arn:aws:iam::491408137367:role/AD-Data-Science-S3-Sync"
      ]
      "data_sets" : [
        "td/pos/pos_bw_hprcm08/*"
      ]
    },
    "PnPRedshift" : {
      "actions" : [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::316585047597:role/RedshiftS3Access-pnp-eu-decisionsupport-redshift",
        "arn:aws:iam::316585047597:role/AD-DecisionSupport-RedShiftAdmin"
      ]
      "data_sets" : [
        "td/pos/pos_bw_hprcw01/*"
      ]
    }
  },
  "acz_retail" = {
    "DecisionSupport" : {
      "actions" : [
        "s3:PutObject"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::316585047597:root"
      ]
      "data_sets" : [
        "*"
      ]
    },
    "SapPO" : {
      "actions" : [
        "s3:Get*",
      ]
      "principal_identifiers" : [
        "arn:aws:iam::491408137367:role/AD-Data-Science-GCCRAWL1"
      ]
      "data_sets" : [
        "*"
      ]
    }
  },
  "acz_pos" = {
    "DecisionSupport" : {
      "actions" : [
        "s3:PutObject"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::316585047597:root"
      ]
      "data_sets" : [
        "*"
      ]
    },
    "SapPO" : {
      "actions" : [
        "s3:Get*",
      ]
      "principal_identifiers" : [
        "arn:aws:iam::491408137367:role/AD-Data-Science-GCCRAWL1"
      ]
      "data_sets" : [
        "*"
      ]
    }
  },
  "acz_doc" = {
    "DecisionSupport" : {
      "actions" : [
        "s3:PutObject"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::316585047597:root"
      ]
      "data_sets" : [
        "*"
      ]
    },
  },
  "acz_crm" = {
    "DecisionSupport" : {
      "actions" : [
        "s3:PutObject"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::316585047597:root"
      ]
      "data_sets" : [
        "*"
      ]
    },
  },
  "stz_crm" = {
    "SapPO" : {
      "actions" : [
        "s3:Get*"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::491408137367:role/AD-Data-Science-GCCRAWL1"
      ]
      "data_sets" : [
        "md/bp/bp_bw_bp_01/*"
      ]
    },
  },
  "acz_finance" = {
    "DecisionSupport" : {
      "actions" : [
        "s3:PutObject"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::316585047597:root"
      ]
      "data_sets" : [
        "*"
      ]
    },
  },
  "stz_finance" = {
    "PnPRedshift" : {
      "actions" : [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::316585047597:role/RedshiftS3Access-pnp-eu-decisionsupport-redshift",
        "arn:aws:iam::316585047597:role/AD-DecisionSupport-RedShiftAdmin"
      ]
      "data_sets" : [
        "md/vendor/vendor_bw_vendor_01/*",
        "td/cos/cos_bw_hfglm01_01/*",

      ]
    }
  },
  "acz_scl" = {
    "DecisionSupport" : {
      "actions" : [
        "s3:PutObject"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::316585047597:root"
      ]
      "data_sets" : [
        "*"
      ]
    },
    "SapPo" : {
      "actions" : [
        "s3:PutObject"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::101377780047:role/POServeUserRole-RootRole-31NJ111L9IMC",
        "arn:aws:iam::101377780047:user/PO_Serve"
      ]
      "data_sets" : [
        "*"
      ]
    },
  },
  "acz_sud" = {
    "Memoria" : {
      "actions" : [
        "s3:PutObject"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::059820608761:role/pnp-memoria-lambda-queue_to_datalake-eu-west-1"
      ]
      "data_sets" : [
        "*"
      ]
    },
  },
  "stz_cross" = {
    "PnPRedshift" : {
      "actions" : [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::316585047597:role/RedshiftS3Access-pnp-eu-decisionsupport-redshift",
        "arn:aws:iam::316585047597:role/AD-DecisionSupport-RedShiftAdmin"
      ]
      "data_sets" : [
        "md/parameters/parameters_zdt_const*/*",

      ]
    }
  },
  "stz_datascience" = {
    "PnPRedshift" : {
      "actions" : [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::316585047597:role/RedshiftS3Access-pnp-eu-decisionsupport-redshift",
        "arn:aws:iam::316585047597:role/AD-DecisionSupport-RedShiftAdmin"
      ]
      "data_sets" : [
        "md/member/member_engagement_segmentation_01*/*",
        "md/member/member_lifestyle_segmentation_01*/*"

      ]
    }
  }
}
buckets_external_config_boxer = {
  "stz_retail" : {
    "PnPRedshift" : {
      "actions" : [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::316585047597:role/RedshiftS3Access-pnp-eu-decisionsupport-redshift",
        "arn:aws:iam::316585047597:role/AD-DecisionSupport-RedShiftAdmin"
      ]
      "data_sets" : [
        "change_me",
      ]
    },
  },
  "acz_retail" = {
    "SapPO" : {
      "actions" : [
        "s3:Get*"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::491408137367:role/AD-Data-Science-GCCRAWL1",
        "arn:aws:iam::491408137367:role/AD-Data-Science-S3-Sync"
      ]
      "data_sets" : [
        "change_me"
      ]
    }
  }
}
snowflake_externalConfig = {
  bi : {
    hub-bi : {
      snowflake_canonical_user : "arn:aws:iam::270302263326:user/89at-s-iest2166"
      snowflake_external_id : "LE32952_SFCRole=2_rWZ4u+Oa8b+PHC8ZjmaWsqofrv4="
    },
    hub-bi-logistics : {
      snowflake_canonical_user : "arn:aws:iam::270302263326:user/89at-s-iest2166"
      snowflake_external_id : "LE32952_SFCRole=2_/f5lLXV7vdG0yxZZrrBv3ZTQmaE="
    },
    hub-bi-planning : {
      snowflake_canonical_user : "arn:aws:iam::270302263326:user/89at-s-iest2166"
      snowflake_external_id : "LE32952_SFCRole=2_Xo7QtRA+ugE5qRDGKxx228oggew="
    },
    hub-bi-datascience : {
      snowflake_canonical_user : "arn:aws:iam::270302263326:user/89at-s-iest2166"
      snowflake_external_id : "LE32952_SFCRole=2_M9mCHGOtYJPJd/qumimeL2NrBlA="
    },
    hub-bi-ols : {
      snowflake_canonical_user : "arn:aws:iam::270302263326:user/89at-s-iest2166"
      snowflake_external_id : "LE32952_SFCRole=2_2XZfW92/o8oSm419KrqA65Dv3jU="
    },
    hub-bi-marketing : {
      snowflake_canonical_user : "arn:aws:iam::270302263326:user/89at-s-iest2166"
      snowflake_external_id : "LE32952_SFCRole=2_g0n1XIBmU7GK3/InY7y3UIC9EaA="
    },
    hub-bi-assortment-space-planning : {
      snowflake_canonical_user : "arn:aws:iam::270302263326:user/89at-s-iest2166"
      snowflake_external_id : "LE32952_SFCRole=2_UBcvSjTROy3WG/ujs06mx6VcB9I="
    }
  },
  box : {
    hub-box : {
      snowflake_canonical_user : "arn:aws:iam::270302263326:user/89at-s-iest2166"
      snowflake_external_id : "LE32952_SFCRole=2_W0I6384ET6z7WzQoMhX4i8aHG1o="
    }
  }
}
redshift_external_config = {
  pnp : {
    pnp : {
      redshift_account_arn : "arn:aws:iam::316585047597:root"
    }
  }
}
