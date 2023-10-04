module "pnp_redshift" {
  source = "./consumer_pnp_redshift"

  application_name   = var.application_name
  bucket_name_prefix = "pnp-data-lake"

  lake_tags    = {}
  project_name = "redshift"

  redshift_account_arn = var.redshift_external_config.pnp.pnp.redshift_account_arn
  short_environment    = var.environment_abbreviations[local.environment]
  short_region         = var.region_abbreviations[local.region]

  redshift = {
    "pnp" : {
      "stz-retail" : [
        "md/article/article_bw_article_01/*",
        "md/site/site_bw_site_01/*",
        "md/time/time_bw_time_01/*",
      ]
    }
  }
}