terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "postgresql_table_not_auto_vacuumed_incident" {
  source    = "./modules/postgresql_table_not_auto_vacuumed_incident"

  providers = {
    shoreline = shoreline
  }
}