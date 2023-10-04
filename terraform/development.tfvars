aws_profile         = "default"
aws_assume_role_arn = "arn:aws:iam::538635328987:role/20fifty_deployer"
application_name    = "pnp-data-lake"
aws_account_ids_external = {
  data_science : "491408137367",
  decision_support : "316585047597",
}

cidr_etl_network_vpc = "10.20.0.0/16"

cidr_etl_network_private = [
  "10.20.0.0/23",
  "10.20.64.0/23",
  "10.20.128.0/23",
]

cidr_etl_network_public = [
  "10.20.251.0/24",
  "10.20.252.0/24",
  "10.20.253.0/24",
]

buckets_ingestion_retention_days = {
  "default" : 30
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
    },
    "IHLambdaAPIRealestateAnnualDownload" : {
      "actions" : [
        "s3:GetObject"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::059820608761:role/pnp-info-hub-lambda-api_realestate_annual_download-eu-west-1"
      ]
      "data_sets" : [
        "doc/real_estate_annual_cert/*"
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
        "md/article/article_bw_article_01*/*",
        "md/site/site_bw_site_01*/*",
        "md/time/time_bw_time_01*/*",
        "td/sales/sales_bw_hrsaw01*/*",
        "td/stock/stock_bw_hrstw15*/*",
        "td/stock/stock_bw_hrstw16*/*",
        "md/selling_price/selling_price_bw_hrspw02*/*",
        "md/selling_price/selling_price_bw_hrspw04*/*",
        "md/selling_price/selling_price_bw_hrspw05*/*",
        "md/promotions/promotions_bw_promo_01*/*",
        "md/selling_price/selling_price_bw_hrspw02*/*",
        "md/selling_price/selling_price_bw_hrspw04*/*",
        "md/selling_price/selling_price_bw_hrspw05*/*",
        "md/promotions/promotions_bw_promo_01*/*",
        "md/article/article_bw_articleuom_01*/*",
        "md/article/article_bw_pricingfamilypurchorg_01*/*",
        "md/article/article_bw_pricingfamilysalesorg_01*/*",
        "td/rebates/rebates_bw_hrrbw01*/*",
        "md/selling_price/selling_price_bw_hrspw01*/*",
        "td/forecasting/forecasting_bw_hsfaw01*/*",
        "md/sitearticle/sitearticle_bw_sitearticle_01*/*",
        "td/availability/availability_bw_hravm01*/*",
        "td/swr/swr_bw_hrcfm01*/*",
        "md/article/article_erp_mean*/*",
        "md/site/site_bw_hrsiw06*/*",
        "md/site/site_erp_wagu*/*",
        "md/site/site_box_site_01*/*",
        "md/article/article_erp_mara_01*/*",
        "md/article/article_erp_maw1_01*/*",
        "md/assortment/assortment_erp_wlk1*/*",
        "md/assortment/assortment_erp_wrs1*/*",
        "md/assortment/assortment_erp_wrsz*/*",
        "md/bom/bom_erp_mast*/*",
        "md/bom/bom_erp_stpo*/*",
        "md/sitearticle/sitearticle_bw_hrsmw05*/*",
        "md/sitearticle/sitearticle_bw_hrsmw16*/*",
        "md/sitearticle/sitearticle_bw_sitearticle_01_snapshot*/*",
        "md/sitearticle/sitearticle_erp_eord_01*/*",
        "md/sitearticle/sitearticle_erp_marc*/*",
        "md/tax/tax_erp_mlan*/*",
        "md/time/time_bw_hatmw03*/*",
        "td /sales/sales_box_sales_01*/*",
        "td/article_movements/article_move_bw_hrmvw01*/*",
        "td/sales/sales_bw_hrsam01*/*",
        "td/sales/sales_bw_hrsam03*/*",
        "td/sales/sales_bw_hrsam04*/*",
        "td/sales/sales_bw_hrsam06*/*",
        "td/sales/sales_bw_hrsaw03*/*",
        "md/item/item_bw_hrmaw32*/*",
        "md/item_mapping/item_bw_hrmaw34*/*",
      ]
    },
    "SapPO" : {
      "actions" : [
        "s3:Get*"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::491408137367:role/AD-Data-Science-GCCRAWL1",
        "arn:aws:iam::491408137367:role/AD-Data-Science-S3-Sync",
        "arn:aws:iam::491408137367:role/AD-Data-Science-EC2-Role",
        "arn:aws:iam::491408137367:role/AD-Data-Science-EMR-DefaultRole",
        "arn:aws:iam::491408137367:role/AD-Data-Science-EMR-EC2-DefaultRole"
      ]
      "data_sets" : [
        "md/article/article_bw_article_01*/**",
        "md/site/site_bw_site_01*/*"
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
        "arn:aws:iam::491408137367:role/AD-Data-Science-S3-Sync",
        "arn:aws:iam::491408137367:role/AD-Data-Science-EMR-DefaultRole",
        "arn:aws:iam::491408137367:role/AD-Data-Science-EC2-Role",
        "arn:aws:iam::491408137367:role/AD-Data-Science-EMR-EC2-DefaultRole"
      ]
      "data_sets" : [
        "td/pos/pos_bw_hprcm08*/*",
        "td/pos/pos_bw_hprcw01*/*"

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
        "td/pos/pos_bw_hprcw01*/*",
        "td/pos/pos_bw_hprcc10*/*",
        "td/pos/pos_bw_hprcc11*/*",
        "td/pos/pos_bw_hprcc12*/*",
        "td/pos/pos_bw_hprcm08*/*",
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
        "s3:Get*"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::491408137367:role/AD-Data-Science-GCCRAWL1",
        "arn:aws:iam::491408137367:role/AD-Data-Science-S3-Sync"
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
        "s3:Get*"
      ]
      "principal_identifiers" : [
        "arn:aws:iam::491408137367:role/AD-Data-Science-GCCRAWL1",
        "arn:aws:iam::491408137367:role/AD-Data-Science-S3-Sync"
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
        "arn:aws:iam::491408137367:role/AD-Data-Science-GCCRAWL1",
        "arn:aws:iam::491408137367:role/AD-Data-Science-EC2-Role",
        "arn:aws:iam::491408137367:role/AD-Data-Science-EMR-DefaultRole",
        "arn:aws:iam::491408137367:role/AD-Data-Science-EMR-EC2-DefaultRole"
      ]
      "data_sets" : [
        "md/bp/*",
        "md/customer/*",
        "md/loyalty/*",
        "md/member/*",
        "md/offer_engine/*",
        "td/email/*",
        "td/sms/*",
        "td/target_grp/*",
        "td/member_activities/*",
        "td/points_account/*",
        "td/survey/*",
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
        "md/bp/bp_bw_bp_01/*"
      ]
    }
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
        "md/vendor/vendor_bw_vendor_01*/*",
        "td/cos/cos_bw_hfglm01_01*/*",
        "td/cos/cos_bw_hfglm01*/*",
        "td/cos/cos_bw_hfglm02*/*",
        "td/margin_man_adj/margin_man_adj_hfglm03*/*",
        "td/gl_line_items/gl_line_items_bw_hfglw02*/*",
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
        "md/site/site_box_site_01*/*",
        "md/article/article_box_article_01*/*",
        "md/article/article_box_articlebarcode_01*/*",
        "td /sales/sales_box_sales_01*/*",
        "td/sales/sales_box_salesplan_01*/*",
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
      snowflake_external_id : "LE32952_SFCRole=2_uL1Ja5aYNZDSKq74s6+vZXE0yYw="
    },
    hub-bi-planning : {
      snowflake_canonical_user : "arn:aws:iam::270302263326:user/89at-s-iest2166"
      snowflake_external_id : "LE32952_SFCRole=2_Po0GXvDrSp/RuphskHho/vlM+Rc="
    },
    hub-bi-datascience : {
      snowflake_canonical_user : "arn:aws:iam::270302263326:user/89at-s-iest2166"
      snowflake_external_id : "LE32952_SFCRole=2_QjausrCKSkf4gALx5tNFt2IC8bw="
    },
    hub-bi-ols : {
      snowflake_canonical_user : "arn:aws:iam::270302263326:user/89at-s-iest2166"
      snowflake_external_id : "LE32952_SFCRole=2_H0nLoQ6AAPIcOi2Vl+admLa6LqY="
    },
    hub-bi-marketing : {
      snowflake_canonical_user : "arn:aws:iam::270302263326:user/89at-s-iest2166"
      snowflake_external_id : "LE32952_SFCRole=2_iJLTC3kvMQqL/287CxCH+Lq+Wfw="
    },
    hub-bi-assortment-space-planning : {
      snowflake_canonical_user : "arn:aws:iam::270302263326:user/89at-s-iest2166"
      snowflake_external_id : "LE32952_SFCRole=2_vhQz/utfrqHEscd2TCHW4pbRrKE="
    }
  }
  box : {
    hub-box : {
      snowflake_canonical_user : "arn:aws:iam::270302263326:user/89at-s-iest2166"
      snowflake_external_id : "LE32952_SFCRole=2_vEYOULu6ibrDvRaZen5htSAY28E="
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
