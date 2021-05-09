provider "oci" {
  tenancy_ocid = var.oci_tenancy
  user_ocid = var.oci_user
  private_key_path = pathexpand(var.oci_path_ssh_key_private)
  fingerprint = var.oci_fingerprint
  region = var.oci_region
}

resource "oci_identity_compartment" "obj_ic" {
    # Required
    compartment_id = var.oci_tenancy
    description = "Compartment for Terraform resources."
    name = "ic_ocicode_002"
}
