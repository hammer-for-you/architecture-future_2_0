variable "service_account_id" {
  type = string
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "subnet_v4_cidr_blocks" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}
### S3 storage variables

variable "airflow_dag_bucket" {
  type    = string
  default = "airflow.dags"
}

variable "airflow_dag_bucket_size" {
  type    = number
  default = 1073741824
}

variable "data_lakehouse_bucket" {
  type    = string
  default = "data.lakehouse"
}

variable "data_lakehouse_bucket_size" {
  type    = number
  default = 536870912000
}
### PostgreSQL cluster variables

variable "pg_version" {
  type    = number
  default = 16
}

variable "pg_resource_preset_id" {
  type = string
  default = "s2.micro"
}

variable "pg_disk_size" {
  type = number
}

variable "pg_disk_type_id" {
  type    = string
  default = "network-ssd"
}

variable "pg_disk_size_limit" {
  type = number
}

variable "pg_emergency_usage_threshold" {
  type = number
}

variable "pg_planned_usage_threshold" {
  type = number
}
### Airflow cluster variables

variable "airflow_webserver_count" {
  type    = number
  default = 1
}

variable "airflow_scheduler_count" {
  type    = number
  default = 1
}

variable "airflow_worker_cfg" {
  type = object({
    min_count : number
    max_count : number
    resource_preset_id : string
  })
  default = {
    min_count          = 1
    max_count          = 2
    resource_preset_id = "c1-m4"
  }
}

variable "aifrlow_admin_password" {
  type = string
}

### Clickhouse cluster variables
variable "clickhouse_resource_preset_id" {
  type = string
  default = "s2.micro"
}

variable "clickhouse_disk_size" {
  type = number
}

variable "clickhouse_disk_type_id" {
  type    = string
  default = "network-ssd"
}

### Kafka cluster variables
variable "kafka_brokers_count" {
  type = number
  default = 1
}

variable "kafka_resource_preset_id" {
  type = string
  default = "s2.micro"
}

variable "kafka_disk_size" {
  type = number
}

variable "kafka_disk_type_id" {
  type    = string
  default = "network-ssd"
}

### VM variables
variable "vm_cores" {
  type = number
}

variable "vm_memory" {
  type = number
}

variable "vm_image_id" {
  type = string
}

variable "vm_disk_size" {
  type = number
}

variable "vm_disk_type_id" {
  type    = string
  default = "network-ssd"
}
