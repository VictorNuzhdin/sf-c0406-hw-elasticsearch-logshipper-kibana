output "srv1_info" {
  value       = "${yandex_compute_instance.srv1.name} | ${yandex_compute_instance.srv1.network_interface.0.ip_address} | ${yandex_compute_instance.srv1.network_interface.0.nat_ip_address}"
  description = "The Name, Internal and Public IP address of SRV1 instance."
  sensitive   = false
}

output "srv2_info" {
  value       = "${yandex_compute_instance.srv2.name} | ${yandex_compute_instance.srv2.network_interface.0.ip_address} | ${yandex_compute_instance.srv2.network_interface.0.nat_ip_address}"
  description = "The Name, Internal and Public IP address of SRV2 instance."
  sensitive   = false
}

/*=EXAMPLE_OUTPUT:

    Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

    Outputs:

    vm1_info = "vm1 | 10.0.10.13 | 84.201.164.102"
    vm2_info = "vm2 | 10.0.10.14 | 51.250.18.184"
*/
