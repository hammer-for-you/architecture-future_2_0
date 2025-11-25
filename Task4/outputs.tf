output "vpc_id" {
  description = "ID созданной VPC"
  value = yandex_vpc_network.future_vpc.id
}

### S3 outputs
output "aiflow_dag_bucket" {
  description = "Бакеты в S3 Storage"
  value =  {
    airflow_dags = yandex_storage_bucket.airflow_dags.bucket
    data_lakehouse = yandex_storage_bucket.data_lakehouse.bucket
  }
}

### PostgreSQL cluster outputs
output "pg_cluster_status" {
  description = "Статус кластера PostgreSQL"
  value = yandex_mdb_postgresql_cluster.future_pg_cluster.status
}

### Airflow cluster outputs
output "airflow_cluster_status" {
  description = "Статус кластера Airflow"
  value = yandex_airflow_cluster.future_airflow_cluster.status
}

### Clickhouse cluster outputs
output "clickhouse_cluster_status" {
  description = "Статус кластера Clickhouse"
  value = yandex_mdb_clickhouse_cluster.future_clickhouse_cluster.status
}

### Kafka cluster outputs
output "kafka_cluster_status" {
  description = "Статус кластера Kafka"
  value = yandex_mdb_kafka_cluster.future_kafka_cluster.status
}

### VM outputs
output "vm_data" {
  description = "Параметры созданной VM"
  value = {
    name = yandex_compute_instance.future_vm.name
    cores = yandex_compute_instance.future_vm.resources[0].cores
    memory = "${yandex_compute_instance.future_vm.resources[0].memory} GB"
    disk_size = "${yandex_compute_instance.future_vm.boot_disk[0].initialize_params[0].size} GB"
    status = yandex_compute_instance.future_vm.status
  }
}