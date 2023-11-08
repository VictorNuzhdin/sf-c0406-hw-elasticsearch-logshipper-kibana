output "srv1_external_ip" {
  value       = "${yandex_compute_instance.srv1.name}: ${yandex_compute_instance.srv1.network_interface.0.nat_ip_address}"
  description = "The Name and public IP address of SRV1 instance."
  sensitive   = false
}

output "srv1_internal_ip" {
  value       = "${yandex_compute_instance.srv1.name}: ${yandex_compute_instance.srv1.network_interface.0.ip_address}"
  description = "The Name and internal IP address of SRV1 instance."
  sensitive   = false
}

output "srv2_external_ip" {
  value       = "${yandex_compute_instance.srv2.name}: ${yandex_compute_instance.srv2.network_interface.0.nat_ip_address}"
  description = "The Name and public IP address of SRV2 instance."
  sensitive   = false
}

output "srv2_internal_ip" {
  value       = "${yandex_compute_instance.srv2.name}: ${yandex_compute_instance.srv2.network_interface.0.ip_address}"
  description = "The Name and internal IP address of SRV2 instance."
  sensitive   = false
}


/*=EXAMPLE_OUTPUT:

    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

    Outputs:

    srv1_external_ip = "srv1: 84.201.164.102"
    srv1_internal_ip = "srv1: 10.0.10.13"
    srv2_external_ip = "srv2: 51.250.18.184"
    srv2_internal_ip = "srv2: 10.0.10.14"
*/
