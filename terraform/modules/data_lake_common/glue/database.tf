module "database_ingest" {
  source = "../../glue_database"

  count = length(local.catalogue_names_ingest)

  database_name = trimprefix("${replace(var.name, "bi", "")}-${local.catalogue_names_ingest[count.index]}", "-")
}

module "database_store" {
  source = "../../glue_database"

  count = length(local.catalogue_names_store)

  database_name = trimprefix("${replace(var.name, "bi", "")}-${local.catalogue_names_store[count.index]}", "-")
}

module "database_underscore_ingest" {
  source = "../../glue_database"

  count = length(local.catalogue_names_ingest)

  database_name = trimprefix("${replace(var.name, "bi", "")}_${replace(local.catalogue_names_ingest[count.index], "-", "_")}", "_")
}

module "database_underscore_store" {
  source = "../../glue_database"

  count = length(local.catalogue_names_store)

  database_name = trimprefix("${replace(var.name, "bi", "")}_${replace(local.catalogue_names_store[count.index], "-", "_")}", "_")
}