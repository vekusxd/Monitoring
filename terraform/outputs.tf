output "external_ip" {
  description = "External IP of monitoring VM"
  value       = yandex_compute_instance.monitoring.network_interface.0.nat_ip_address
}

output "internal_ip" {
  description = "Internal IP of monitoring VM"
  value       = yandex_compute_instance.monitoring.network_interface.0.ip_address
}
