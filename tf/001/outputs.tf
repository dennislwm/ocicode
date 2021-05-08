output "lst_availability_domains" {
  value = data.oci_identity_availability_domains.obj_iad.availability_domains
}
