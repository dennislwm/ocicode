# ocicode
Terraform starter project for Oracle Cloud Infrastructure ["OCI].

<!-- TOC -->

- [ocicode](#ocicode)
- [About ocicode](#about-ocicode)
  - [Creating SSH Keys](#creating-ssh-keys)
  - [Gathering required information](#gathering-required-information)
- [Project Structure](#project-structure)
- [Installation](#installation)
  - [Terraform](#terraform)
- [References](#references)

<!-- /TOC -->

---
# About ocicode
**ocicode** was a personal project to:
- automate setting up remote state in cloud storage
- automate SSH key generation and uploading to cloud server
- automate vm creation in a cloud server
- automate package installation in a cloud server
- automate make swapfile in a cloud server
- automate docker-compose in a cloud server
- automate restore files to a cloud server
- automate backup files from a cloud server

## Creating SSH Keys

Create SSH keys for API signing into your OCI account.

```bash
mkdir $HOME/.ssh
openssl genrsa -out $HOME/.ssh/<your-ssh-key-name> 2048
chmod 600 $HOME/.ssh/<your-ssh-key-name>
openssl rsa -pubout -in $HOME/.ssh/<your-ssh-key-name> -out $HOME/.ssh/<your-ssh-key-name>.pub
```

You'll require your public key file `<your-ssh-key-name>.pub` in the next step. 

Login to your [OCI account](https://www.oracle.com/sg/cloud/sign-in.html). From your user avatar, go to **User Settings**.

click **Add API Keys**, and select **Paste Public Keys**. Paste the content of your public key, including the lines with `BEGIN` and `END`.

## Gathering required information

Copy and paste the following information into your secrets Terraform variables file `terraform.tfvars`.

From the OCI Console and search for `Tenancy Details`. 

* `oci_tenancy="ocid1.tenancy.oc1.."`

Search for `User Details`. 

* `oci_user="ocid1.user.oc1.."`

Search for `API Keys`.

* `oci_fingerprint="f9:2b:2a:02.."`

Lookup the Region Identifier from [Regions and Availability Domains](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm)

* `oci_region="us-phoenix-1"`

Copy the following information from your environment.

* `oci_path_ssh_key_private="~/.ssh/id_rsa_oci"`

Your secrets file `terraform.tfvars`.

```json
oci_tenancy="ocid1.tenancy.oc1.."
oci_user="ocid1.user.oc1.."
oci_fingerprint="f9:2b:2a:02.."
oci_region="us-phoenix-1"
oci_path_ssh_key_private="~/.ssh/id_rsa_oci"
```

Your `variables.tf` file.

```json
variable oci_tenancy {
  description = "secret in terraform.tfvars"
}
variable oci_user {
  description = "secret in terraform.tfvars"
}
variable oci_fingerprint {
  description = "secret in terraform.tfvars"
}
variable oci_region {
  description = "secret in terraform.tfvars"
}
variable oci_path_ssh_key_private {
  description = "secret in terraform.tfvars"
}
```

Creating your `main.tf` and `outputs.tf` files.

```json
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
```

```json
output "lst_availability_domains" {
  value = data.oci_identity_availability_domains.obj_iad.availability_domains
}
```

---
# Project Structure
     ocicode/                         <-- Root of your project
       |- README.md                   <-- This README markdown file
       +- tf/                         <-- Terraform root folder
          +- 001/                     <-- Minimal Terraform project
             |- main.tf               <-- Main TF file (required)
             |- outputs.tf            <-- TF outputs file
             |- terraform.tfvars      <-- Secrets Terraform variables file (.gitignore)
             |- variables.tf          <-- TF variables file
             |- versions.tf           <-- TF versions file (required >= 0.13)
          +- 002/                     <-- Create a compute instance Terraform project

---
# Installation

## Terraform

* [Download Terraform 0.14.9](https://releases.hashicorp.com/terraform)

Terraform is distributed as a single binary. Install Terraform (64-bit) by unzipping it and moving it to a directory included in your system's ```PATH```.

# References

* [Terraform: Set Up OCI Terraform](https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-provider/01-summary.htm)
