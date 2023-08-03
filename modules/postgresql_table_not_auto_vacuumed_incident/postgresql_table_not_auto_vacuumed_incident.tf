resource "shoreline_notebook" "postgresql_table_not_auto_vacuumed_incident" {
  name       = "postgresql_table_not_auto_vacuumed_incident"
  data       = file("${path.module}/data/postgresql_table_not_auto_vacuumed_incident.json")
  depends_on = [shoreline_action.invoke_check_autovacuum,shoreline_action.invoke_vacuum_table,shoreline_action.invoke_vacuum_table,shoreline_action.invoke_vacuum_settings_adjust]
}

resource "shoreline_file" "check_autovacuum" {
  name             = "check_autovacuum"
  input_file       = "${path.module}/data/check_autovacuum.sh"
  md5              = filemd5("${path.module}/data/check_autovacuum.sh")
  description      = "The autovacuum process may not be enabled or configured properly in the database, causing tables to not be vacuumed automatically."
  destination_path = "/agent/scripts/check_autovacuum.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "vacuum_table" {
  name             = "vacuum_table"
  input_file       = "${path.module}/data/vacuum_table.sh"
  md5              = filemd5("${path.module}/data/vacuum_table.sh")
  description      = "Force a vacuum on the specific table"
  destination_path = "/agent/scripts/vacuum_table.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "vacuum_table" {
  name             = "vacuum_table"
  input_file       = "${path.module}/data/vacuum_table.sh"
  md5              = filemd5("${path.module}/data/vacuum_table.sh")
  description      = "Manually vacuum the affected table(s) to free up space and update statistics using the VACUUM command."
  destination_path = "/agent/scripts/vacuum_table.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "vacuum_settings_adjust" {
  name             = "vacuum_settings_adjust"
  input_file       = "${path.module}/data/vacuum_settings_adjust.sh"
  md5              = filemd5("${path.module}/data/vacuum_settings_adjust.sh")
  description      = "Adjust the automatic vacuum process settings to ensure that it runs more frequently or with different parameters that are more appropriate for your database workload."
  destination_path = "/agent/scripts/vacuum_settings_adjust.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_autovacuum" {
  name        = "invoke_check_autovacuum"
  description = "The autovacuum process may not be enabled or configured properly in the database, causing tables to not be vacuumed automatically."
  command     = "`chmod +x /agent/scripts/check_autovacuum.sh && /agent/scripts/check_autovacuum.sh`"
  params      = ["DATABASE_USER","DATABASE_PASSWORD","DATABASE_NAME","DATABASE_HOST"]
  file_deps   = ["check_autovacuum"]
  enabled     = true
  depends_on  = [shoreline_file.check_autovacuum]
}

resource "shoreline_action" "invoke_vacuum_table" {
  name        = "invoke_vacuum_table"
  description = "Force a vacuum on the specific table"
  command     = "`chmod +x /agent/scripts/vacuum_table.sh && /agent/scripts/vacuum_table.sh`"
  params      = ["TABLE_NAME"]
  file_deps   = ["vacuum_table"]
  enabled     = true
  depends_on  = [shoreline_file.vacuum_table]
}

resource "shoreline_action" "invoke_vacuum_table" {
  name        = "invoke_vacuum_table"
  description = "Manually vacuum the affected table(s) to free up space and update statistics using the VACUUM command."
  command     = "`chmod +x /agent/scripts/vacuum_table.sh && /agent/scripts/vacuum_table.sh`"
  params      = ["DATABASE_NAME","TABLE_NAME"]
  file_deps   = ["vacuum_table"]
  enabled     = true
  depends_on  = [shoreline_file.vacuum_table]
}

resource "shoreline_action" "invoke_vacuum_settings_adjust" {
  name        = "invoke_vacuum_settings_adjust"
  description = "Adjust the automatic vacuum process settings to ensure that it runs more frequently or with different parameters that are more appropriate for your database workload."
  command     = "`chmod +x /agent/scripts/vacuum_settings_adjust.sh && /agent/scripts/vacuum_settings_adjust.sh`"
  params      = ["DATABASE_USER","DATABASE_PASSWORD","DATABASE_NAME"]
  file_deps   = ["vacuum_settings_adjust"]
  enabled     = true
  depends_on  = [shoreline_file.vacuum_settings_adjust]
}

