variable "dataset" {}
variable "location" {}
variable "project" {}
variable "transfer_service_account" {}
variable "overture_version" {}
variable "AWS_ACCESS_KEY_ID" {}
variable "AWS_SECRET_ACCESS_KEY" {}

terraform {
  backend "gcs" {
    bucket = var.bucket
  }
}
provider "google" {
  project     = var.project
  region      = var.location
}

data "google_project" "project" {
}

/*
resource "google_project_iam_member" "permissions" {
  project = data.google_project.project.project_id
  role   = "roles/iam.serviceAccountTokenCreator"
  member = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-bigquerydatatransfer.iam.gserviceaccount.com"
}
*/


resource "google_bigquery_dataset" "overture_dataset" {
  dataset_id = var.dataset
  default_partition_expiration_ms = null
  default_table_expiration_ms = null
  description = "Overture Maps dataset"
  location = "US"
}

resource "google_bigquery_table" "building_table" {
  depends_on = [google_bigquery_dataset.overture_dataset]
  dataset_id = var.dataset
  table_id = "building_stage"
  schema = file("schemas/building.json")
}
resource "google_bigquery_table" "building_part_table" {
  depends_on = [google_bigquery_dataset.overture_dataset]
  dataset_id = var.dataset
  table_id = "building_part_stage"
  schema = file("schemas/building_part.json")
}
resource "google_bigquery_table" "land_table" {
  depends_on = [google_bigquery_dataset.overture_dataset]
  dataset_id = var.dataset
  table_id = "land_stage"
  schema = file("schemas/land.json")
}
resource "google_bigquery_table" "land_use_table" {
  depends_on = [google_bigquery_dataset.overture_dataset]
  dataset_id = var.dataset
  table_id = "land_use_stage"
  schema = file("schemas/land_use.json")
}
resource "google_bigquery_table" "water_table" {
  depends_on = [google_bigquery_dataset.overture_dataset]
  dataset_id = var.dataset
  table_id = "water_stage"
  schema = file("schemas/water.json")
}
resource "google_bigquery_table" "place_table" {
  depends_on = [google_bigquery_dataset.overture_dataset]
  dataset_id = var.dataset
  table_id = "place_stage"
  schema = file("schemas/place.json")
}
resource "google_bigquery_table" "connector_table" {
  depends_on = [google_bigquery_dataset.overture_dataset]
  dataset_id = var.dataset
  table_id = "connector_stage"
  schema = file("schemas/connector.json")
}
resource "google_bigquery_table" "segment_table" {
  depends_on = [google_bigquery_dataset.overture_dataset]
  dataset_id = var.dataset
  table_id = "segment_stage"
  schema = file("schemas/segment.json")
}
resource "google_bigquery_table" "infrastructure_table" {
  depends_on = [google_bigquery_dataset.overture_dataset]
  dataset_id = var.dataset
  table_id = "infrastructure_stage"
  schema = file("schemas/infrastructure.json")
}
resource "google_bigquery_table" "boundary_table" {
  depends_on = [google_bigquery_dataset.overture_dataset]
  dataset_id = var.dataset
  table_id = "boundary_stage"
  schema = file("schemas/boundary.json")
}
resource "google_bigquery_table" "division_table" {
  depends_on = [google_bigquery_dataset.overture_dataset]
  dataset_id = var.dataset
  table_id = "division_stage"
  schema = file("schemas/division.json")
}
resource "google_bigquery_table" "division_area_table" {
  depends_on = [google_bigquery_dataset.overture_dataset]
  dataset_id = var.dataset
  table_id = "division_area_stage"
  schema = file("schemas/division_area.json")
}

resource "google_bigquery_table" "building_mv" {
  depends_on = [google_bigquery_table.building_table]
  dataset_id = google_bigquery_dataset.overture_dataset.dataset_id
  table_id = "building"
  clustering = ["geometry"]
  deletion_protection = false

  materialized_view {
    enable_refresh = true
    refresh_interval_ms = null
    query = <<EOH
      select
        * except(geometry),
        st_geogFromWKB(geometry, make_valid => true) as geometry
      from `${var.project}.${var.dataset}.building_stage`
    EOH
  }
}
resource "google_bigquery_table" "building_part_mv" {
  depends_on = [google_bigquery_table.building_part_table]
  dataset_id = google_bigquery_dataset.overture_dataset.dataset_id
  table_id = "building_part"
  clustering = ["geometry"]
  deletion_protection = false

  materialized_view {
    enable_refresh = true
    refresh_interval_ms = null
    query = <<EOH
      select
        * except(geometry),
        st_geogFromWKB(geometry, make_valid => true) as geometry
      from `${var.project}.${var.dataset}.building_part_stage`
    EOH
  }
}
resource "google_bigquery_table" "connector_mv" {
  depends_on = [google_bigquery_table.connector_table]
  dataset_id = google_bigquery_dataset.overture_dataset.dataset_id
  table_id = "connector"
  clustering = ["geometry"]
  deletion_protection = false

  materialized_view {
    enable_refresh = true
    refresh_interval_ms = null
    query = <<EOH
      select
        * except(geometry),
        st_geogFromWKB(geometry, make_valid => true) as geometry
      from `${var.project}.${var.dataset}.connector_stage`
    EOH
  }
}
resource "google_bigquery_table" "segment_mv" {
  depends_on = [google_bigquery_table.segment_table]
  dataset_id = google_bigquery_dataset.overture_dataset.dataset_id
  table_id = "segment"
  clustering = ["geometry"]
  deletion_protection = false

  materialized_view {
    enable_refresh = true
    refresh_interval_ms = null
    query = <<EOH
      select
        * except(geometry),
        st_geogFromWKB(geometry, make_valid => true) as geometry
      from `${var.project}.${var.dataset}.segment_stage`
    EOH
  }
}
resource "google_bigquery_table" "place_mv" {
  depends_on = [google_bigquery_table.place_table]
  dataset_id = google_bigquery_dataset.overture_dataset.dataset_id
  table_id = "place"
  clustering = ["geometry"]
  deletion_protection = false

  materialized_view {
    enable_refresh = true
    refresh_interval_ms = null
    query = <<EOH
      select
        * except(geometry),
        st_geogFromWKB(geometry, make_valid => true) as geometry
      from `${var.project}.${var.dataset}.place_stage`
    EOH
  }
}
resource "google_bigquery_table" "land_mv" {
  depends_on = [google_bigquery_table.land_table]
  dataset_id = google_bigquery_dataset.overture_dataset.dataset_id
  table_id = "land"
  clustering = ["geometry"]
  deletion_protection = false

  materialized_view {
    enable_refresh = true
    refresh_interval_ms = null
    query = <<EOH
      select
        * except(geometry),
        st_geogFromWKB(geometry, make_valid => true) as geometry
      from `${var.project}.${var.dataset}.land_stage`
    EOH
  }
}
resource "google_bigquery_table" "land_use_mv" {
  depends_on = [google_bigquery_table.land_use_table]
  dataset_id = google_bigquery_dataset.overture_dataset.dataset_id
  table_id = "land_use"
  clustering = ["geometry"]
  deletion_protection = false

  materialized_view {
    enable_refresh = true
    refresh_interval_ms = null
    query = <<EOH
      select
        * except(geometry),
        st_geogFromWKB(geometry, make_valid => true) as geometry
      from `${var.project}.${var.dataset}.land_use_stage`
    EOH
  }
}
resource "google_bigquery_table" "water_mv" {
  depends_on = [google_bigquery_table.water_table]
  dataset_id = google_bigquery_dataset.overture_dataset.dataset_id
  table_id = "water"
  clustering = ["geometry"]
  deletion_protection = false

  materialized_view {
    enable_refresh = true
    refresh_interval_ms = null
    query = <<EOH
      select
        * except(geometry),
        st_geogFromWKB(geometry, make_valid => true) as geometry
      from `${var.project}.${var.dataset}.water_stage`
    EOH
  }
}
resource "google_bigquery_table" "infrastructure_mv" {
  depends_on = [google_bigquery_table.infrastructure_table]
  dataset_id = google_bigquery_dataset.overture_dataset.dataset_id
  table_id = "infrastructure"
  clustering = ["geometry"]
  deletion_protection = false

  materialized_view {
    enable_refresh = true
    refresh_interval_ms = null
    query = <<EOH
      select
        * except(geometry),
        st_geogFromWKB(geometry, make_valid => true) as geometry
      from `${var.project}.${var.dataset}.infrastructure_stage`
    EOH
  }
}
resource "google_bigquery_table" "boundary_mv" {
  depends_on = [google_bigquery_table.boundary_table]
  dataset_id = google_bigquery_dataset.overture_dataset.dataset_id
  table_id = "boundary"
  clustering = ["geometry"]
  deletion_protection = false

  materialized_view {
    enable_refresh = true
    refresh_interval_ms = null
    query = <<EOH
      select
        * except(geometry),
        st_geogFromWKB(geometry, make_valid => true) as geometry
      from `${var.project}.${var.dataset}.boundary_stage`
    EOH
  }
}
resource "google_bigquery_table" "division_mv" {
  depends_on = [google_bigquery_table.division_table]
  dataset_id = google_bigquery_dataset.overture_dataset.dataset_id
  table_id = "division"
  clustering = ["geometry"]
  deletion_protection = false

  materialized_view {
    enable_refresh = true
    refresh_interval_ms = null
    query = <<EOH
      select
        * except(geometry),
        st_geogFromWKB(geometry, make_valid => true) as geometry
      from `${var.project}.${var.dataset}.division_stage`
    EOH
  }
}
resource "google_bigquery_table" "division_area_mv" {
  depends_on = [google_bigquery_table.division_area_table]
  dataset_id = google_bigquery_dataset.overture_dataset.dataset_id
  table_id = "division_area"
  clustering = ["geometry"]
  deletion_protection = false

  materialized_view {
    enable_refresh = true
    refresh_interval_ms = null
    query = <<EOH
      select
        * except(geometry),
        st_geogFromWKB(geometry, make_valid => true) as geometry
      from `${var.project}.${var.dataset}.division_area_stage`
    EOH
  }
}

resource "google_bigquery_data_transfer_config" "building_transfer" {
  depends_on = [google_bigquery_table.building_table]

  display_name           = "Overture Maps: buildings->building"
  data_source_id         = "amazon_s3"
  schedule               = "first day of month 00:00"
  destination_dataset_id = var.dataset
  service_account_name   = var.transfer_service_account
  params = {
    data_path = "s3://overturemaps-us-west-2/release/${var.overture_version}/theme=buildings/type=building/*"
    destination_table_name_template = "building_stage"
    write_disposition = "WRITE_TRUNCATE"
    access_key_id = var.AWS_ACCESS_KEY_ID
    file_format = "PARQUET"
  }
  sensitive_params {
    secret_access_key = var.AWS_SECRET_ACCESS_KEY
  }
}

resource "time_sleep" "wait_1" {
  depends_on = [google_bigquery_data_transfer_config.building_transfer]
  create_duration = "1s"
}

resource "google_bigquery_data_transfer_config" "building_part_transfer" {
  depends_on = [google_bigquery_table.building_part_table, time_sleep.wait_1]

  display_name           = "Overture Maps: buildings->building_part"
  data_source_id         = "amazon_s3"
  schedule               = "first day of month 00:00"
  destination_dataset_id = var.dataset
  service_account_name   = var.transfer_service_account
  params = {
    data_path = "s3://overturemaps-us-west-2/release/${var.overture_version}/theme=buildings/type=part/*"
    destination_table_name_template = "building_part_stage"
    write_disposition = "WRITE_TRUNCATE"
    access_key_id = var.AWS_ACCESS_KEY_ID
    file_format = "PARQUET"
  }
  sensitive_params {
    secret_access_key = var.AWS_SECRET_ACCESS_KEY
  }
}


resource "time_sleep" "wait_2" {
  depends_on = [google_bigquery_data_transfer_config.building_part_transfer]
  create_duration = "1s"
}

resource "google_bigquery_data_transfer_config" "connector_transfer" {
  depends_on = [google_bigquery_table.connector_table, time_sleep.wait_2]

  display_name           = "Overture Maps: transportation->connector"
  data_source_id         = "amazon_s3"
  schedule               = "first day of month 00:00"
  destination_dataset_id = var.dataset
  service_account_name   = var.transfer_service_account
  params = {
    data_path = "s3://overturemaps-us-west-2/release/${var.overture_version}/theme=transportation/type=connector/*"
    destination_table_name_template = "connector_stage"
    write_disposition = "WRITE_TRUNCATE"
    access_key_id = var.AWS_ACCESS_KEY_ID
    file_format = "PARQUET"
  }
  sensitive_params {
    secret_access_key = var.AWS_SECRET_ACCESS_KEY
  }
}

resource "time_sleep" "wait_3" {
  depends_on = [google_bigquery_data_transfer_config.connector_transfer]
  create_duration = "1s"
}

resource "google_bigquery_data_transfer_config" "segment_transfer" {
  depends_on = [google_bigquery_table.connector_table, time_sleep.wait_3]

  display_name           = "Overture Maps: transportation->connector"
  data_source_id         = "amazon_s3"
  schedule               = "first day of month 00:00"
  destination_dataset_id = var.dataset
  service_account_name   = var.transfer_service_account
  params = {
    data_path = "s3://overturemaps-us-west-2/release/${var.overture_version}/theme=transportation/type=segment/*"
    destination_table_name_template = "segment_stage"
    write_disposition = "WRITE_TRUNCATE"
    access_key_id = var.AWS_ACCESS_KEY_ID
    file_format = "PARQUET"
  }
  sensitive_params {
    secret_access_key = var.AWS_SECRET_ACCESS_KEY
  }
}

resource "time_sleep" "wait_4" {
  depends_on = [google_bigquery_data_transfer_config.segment_transfer]
  create_duration = "1s"
}

resource "google_bigquery_data_transfer_config" "place_transfer" {
  depends_on = [google_bigquery_table.connector_table, time_sleep.wait_4]

  display_name           = "Overture Maps: places->place"
  data_source_id         = "amazon_s3"
  schedule               = "first day of month 00:00"
  destination_dataset_id = var.dataset
  service_account_name   = var.transfer_service_account
  params = {
    data_path = "s3://overturemaps-us-west-2/release/${var.overture_version}/theme=places/type=place/*"
    destination_table_name_template = "place_stage"
    write_disposition = "WRITE_TRUNCATE"
    access_key_id = var.AWS_ACCESS_KEY_ID
    file_format = "PARQUET"
  }
  sensitive_params {
    secret_access_key = var.AWS_SECRET_ACCESS_KEY
  }
}

resource "time_sleep" "wait_5" {
  depends_on = [google_bigquery_data_transfer_config.place_transfer]
  create_duration = "1s"
}

resource "google_bigquery_data_transfer_config" "land_transfer" {
  depends_on = [google_bigquery_table.connector_table, time_sleep.wait_5]

  display_name           = "Overture Maps: base->land"
  data_source_id         = "amazon_s3"
  schedule               = "first day of month 00:00"
  destination_dataset_id = var.dataset
  service_account_name   = var.transfer_service_account
  params = {
    data_path = "s3://overturemaps-us-west-2/release/${var.overture_version}/theme=base/type=land/*"
    destination_table_name_template = "land_stage"
    write_disposition = "WRITE_TRUNCATE"
    access_key_id = var.AWS_ACCESS_KEY_ID
    file_format = "PARQUET"
  }
  sensitive_params {
    secret_access_key = var.AWS_SECRET_ACCESS_KEY
  }
}

resource "time_sleep" "wait_6" {
  depends_on = [google_bigquery_data_transfer_config.land_transfer]
  create_duration = "1s"
}

resource "google_bigquery_data_transfer_config" "land_use_transfer" {
  depends_on = [google_bigquery_table.connector_table, time_sleep.wait_6]

  display_name           = "Overture Maps: base->land_use"
  data_source_id         = "amazon_s3"
  schedule               = "first day of month 00:00"
  destination_dataset_id = var.dataset
  service_account_name   = var.transfer_service_account
  params = {
    data_path = "s3://overturemaps-us-west-2/release/${var.overture_version}/theme=base/type=land_use/*"
    destination_table_name_template = "land_use_stage"
    write_disposition = "WRITE_TRUNCATE"
    access_key_id = var.AWS_ACCESS_KEY_ID
    file_format = "PARQUET"
  }
  sensitive_params {
    secret_access_key = var.AWS_SECRET_ACCESS_KEY
  }
}

resource "time_sleep" "wait_7" {
  depends_on = [google_bigquery_data_transfer_config.land_use_transfer]
  create_duration = "1s"
}

resource "google_bigquery_data_transfer_config" "water_transfer" {
  depends_on = [google_bigquery_table.connector_table, time_sleep.wait_7]

  display_name           = "Overture Maps: base->water"
  data_source_id         = "amazon_s3"
  schedule               = "first day of month 00:00"
  destination_dataset_id = var.dataset
  service_account_name   = var.transfer_service_account
  params = {
    data_path = "s3://overturemaps-us-west-2/release/${var.overture_version}/theme=base/type=water/*"
    destination_table_name_template = "water_stage"
    write_disposition = "WRITE_TRUNCATE"
    access_key_id = var.AWS_ACCESS_KEY_ID
    file_format = "PARQUET"
  }
  sensitive_params {
    secret_access_key = var.AWS_SECRET_ACCESS_KEY
  }
}

resource "time_sleep" "wait_8" {
  depends_on = [google_bigquery_data_transfer_config.water_transfer]
  create_duration = "1s"
}

resource "google_bigquery_data_transfer_config" "infrastructure_transfer" {
  depends_on = [google_bigquery_table.connector_table, time_sleep.wait_8]

  display_name           = "Overture Maps: base->infrastructure"
  data_source_id         = "amazon_s3"
  schedule               = "first day of month 00:00"
  destination_dataset_id = var.dataset
  service_account_name   = var.transfer_service_account
  params = {
    data_path = "s3://overturemaps-us-west-2/release/${var.overture_version}/theme=base/type=infrastructure/*"
    destination_table_name_template = "infrastructure_stage"
    write_disposition = "WRITE_TRUNCATE"
    access_key_id = var.AWS_ACCESS_KEY_ID
    file_format = "PARQUET"
  }
  sensitive_params {
    secret_access_key = var.AWS_SECRET_ACCESS_KEY
  }
}

resource "time_sleep" "wait_9" {
  depends_on = [google_bigquery_data_transfer_config.infrastructure_transfer]
  create_duration = "1s"
}

resource "google_bigquery_data_transfer_config" "boundary_transfer" {
  depends_on = [google_bigquery_table.connector_table, time_sleep.wait_9]

  display_name           = "Overture Maps: divisions->boundary"
  data_source_id         = "amazon_s3"
  schedule               = "first day of month 00:00"
  destination_dataset_id = var.dataset
  service_account_name   = var.transfer_service_account
  params = {
    data_path = "s3://overturemaps-us-west-2/release/${var.overture_version}/theme=divisions/type=boundary/*"
    destination_table_name_template = "boundary_stage"
    write_disposition = "WRITE_TRUNCATE"
    access_key_id = var.AWS_ACCESS_KEY_ID
    file_format = "PARQUET"
  }
  sensitive_params {
    secret_access_key = var.AWS_SECRET_ACCESS_KEY
  }
}

resource "time_sleep" "wait_10" {
  depends_on = [google_bigquery_data_transfer_config.boundary_transfer]
  create_duration = "1s"
}

resource "google_bigquery_data_transfer_config" "division_transfer" {
  depends_on = [google_bigquery_table.connector_table, time_sleep.wait_10]

  display_name           = "Overture Maps: divisions->division"
  data_source_id         = "amazon_s3"
  schedule               = "first day of month 00:00"
  destination_dataset_id = var.dataset
  service_account_name   = var.transfer_service_account
  params = {
    data_path = "s3://overturemaps-us-west-2/release/${var.overture_version}/theme=divisions/type=division/*"
    destination_table_name_template = "division_stage"
    write_disposition = "WRITE_TRUNCATE"
    access_key_id = var.AWS_ACCESS_KEY_ID
    file_format = "PARQUET"
  }
  sensitive_params {
    secret_access_key = var.AWS_SECRET_ACCESS_KEY
  }
}

resource "time_sleep" "wait_11" {
  depends_on = [google_bigquery_data_transfer_config.division_transfer]
  create_duration = "1s"
}

resource "google_bigquery_data_transfer_config" "division_area_transfer" {
  depends_on = [google_bigquery_table.connector_table, time_sleep.wait_11]

  display_name           = "Overture Maps: divisions->division_area"
  data_source_id         = "amazon_s3"
  schedule               = "first day of month 00:00"
  destination_dataset_id = var.dataset
  service_account_name   = var.transfer_service_account
  params = {
    data_path = "s3://overturemaps-us-west-2/release/${var.overture_version}/theme=divisions/type=division_area/*"
    destination_table_name_template = "division_area_stage"
    write_disposition = "WRITE_TRUNCATE"
    access_key_id = var.AWS_ACCESS_KEY_ID
    file_format = "PARQUET"
  }
  sensitive_params {
    secret_access_key = var.AWS_SECRET_ACCESS_KEY
  }
}
