provider "oci" {
  tenancy_ocid = var.oci_tenancy
  user_ocid = var.oci_user
  private_key_path = pathexpand(var.oci_path_ssh_key_private)
  fingerprint = var.oci_fingerprint
  region = var.oci_region
}

data "oci_identity_availability_domains" "obj_iad" {
  compartment_id = var.oci_tenancy
}
