locals {
  # Database names
  #   Replace any underscores with dashes to comply with naming convention, convert to lowercase.
  #   Naming convention:
  #     Default                                   = <Data Lake Name> - <Bucket purpose> - <Short Environment>
  #     If zone/function designations are present = <Zone + Functional Area> - <Short Environment>
  catalogue_names_ingest = length(var.functional_zone_ingestion) > 0 ? formatlist(replace(lower("%s-${var.short_environment}"), "_", "-"), var.functional_zone_ingestion.*.ID) : list(lower(replace("${var.name}-ingestion-${var.short_environment}", "_", "-")))
  catalogue_names_store = length(var.functional_zone_store) > 0 ? formatlist(replace(lower("%s-${var.short_environment}"), "_", "-"), var.functional_zone_store.*.ID) : list(lower(replace("${var.name}-ingestion-${var.short_environment}", "_", "-")))
}
