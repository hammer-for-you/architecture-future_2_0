terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.170.0"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = var.zone
}

resource "yandex_vpc_network" "future_vpc" {
  name = "future-network"
}

resource "yandex_vpc_subnet" "future_subnet" {
  network_id     = yandex_vpc_network.future_vpc.id
  name           = "future-subnet"
  v4_cidr_blocks = var.subnet_v4_cidr_blocks
  zone           = var.zone
}

### S3 Storage
resource "yandex_storage_bucket" "airflow_dags" {
  bucket                = var.airflow_dag_bucket
  default_storage_class = "STANDARD"
  max_size              = var.airflow_dag_bucket_size
}

resource "yandex_storage_bucket" "data_lakehouse" {
  bucket                = var.data_lakehouse_bucket
  default_storage_class = "STANDARD"
  max_size              = var.data_lakehouse_bucket_size
}

### Managed PostgreSQL
resource "yandex_mdb_postgresql_cluster" "future_pg_cluster" {
  name        = "future-pg-cluster"
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.future_vpc.id

  config {
    version = var.pg_version

    resources {
      resource_preset_id = var.pg_resource_preset_id
      disk_size          = var.pg_disk_size
      disk_type_id       = var.pg_disk_type_id
    }

    disk_size_autoscaling {
      disk_size_limit           = var.pg_disk_size_limit
      emergency_usage_threshold = var.pg_emergency_usage_threshold
      planned_usage_threshold   = var.pg_planned_usage_threshold
    }
  }

  host {
    zone             = var.zone
    subnet_id        = yandex_vpc_subnet.future_subnet.id
    assign_public_ip = true # Исключительно для демонстрационных целей.
  }

  maintenance_window {
    type = "WEEKLY"
    day  = "MON"
    hour = 24
  }
}

### Managed Airflow
resource "yandex_airflow_cluster" "future_airflow_cluster" {
  name           = "future-airflow-cluster"
  subnet_ids     = [yandex_vpc_subnet.future_subnet.id]
  admin_password = var.aifrlow_admin_password

  code_sync = {
    s3 = {
      bucket = yandex_storage_bucket.airflow_dags.bucket
    }
  }

  webserver = {
    count              = var.airflow_webserver_count
    resource_preset_id = "c1-m4"
  }

  scheduler = {
    count              = var.airflow_scheduler_count
    resource_preset_id = "c1-m4"
  }

  worker = var.airflow_worker_cfg

  service_account_id = var.service_account_id

  pip_packages = ["dbt"]
}

### Managed Clickhouse cluster
resource "yandex_mdb_clickhouse_cluster" "future_clickhouse_cluster" {
  name        = "future-clickhouse-cluster"
  environment = "PRODUCTION"
  network_id  = yandex_vpc_network.future_vpc.id

  clickhouse {
    resources {
      resource_preset_id = var.clickhouse_resource_preset_id
      disk_type_id = var.clickhouse_disk_type_id
      disk_size = var.clickhouse_disk_size
    }
  }

  host {
    type = "CLICKHOUSE"
    zone = var.zone
    subnet_id = yandex_vpc_subnet.future_subnet.id
  }

  service_account_id = var.service_account_id
}

### Managed Kafka cluster
resource "yandex_mdb_kafka_cluster" "future_kafka_cluster" {
  name       = "future-kafka-cluster"
  environment = "PRODUCTION"
  network_id = yandex_vpc_network.future_vpc.id
  subnet_ids = [yandex_vpc_subnet.future_subnet.id]

  config {
    version = "3.9"
    brokers_count = var.kafka_brokers_count
    zones = [var.zone]
    assign_public_ip = false
    rest_api {
      enabled = true
    }
    kafka_ui {
      enabled = true
    }
    kafka {
      resources {
        resource_preset_id = var.kafka_resource_preset_id
        disk_type_id       = var.kafka_disk_type_id
        disk_size          = var.kafka_disk_size
      }
    }
  }
}

### VM
resource "yandex_compute_instance" "future_vm" {
  name = "future-app-vm"
  platform_id = "standard-v3"
  zone = var.zone

  resources {
    cores  = var.vm_cores
    memory = var.vm_memory
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size = var.vm_disk_size
      type = var.vm_disk_type_id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.future_subnet.id
    nat = true
  }
}