# ocicode
Terraform starter project for Oracle Cloud Infrastructure ["OCI].

<!-- TOC -->

- [ocicode](#ocicode)
- [About ocicode](#about-ocicode)
  - [TL;DR](#tldr)
  - [Creating SSH Keys](#creating-ssh-keys)
  - [Gathering required information](#gathering-required-information)
  - [Create scripts for a minimal Terraform project](#create-scripts-for-a-minimal-terraform-project)
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

## TL;DR

There is a quicker method to perform both [Creating SSH Keys](#creating-ssh-keys) and [Gathering required information](#gathering-required-information). Login to your [OCI account](https://www.oracle.com/sg/cloud/sign-in.html). 

From your user avatar, go to **User Settings**. Click **Add API Keys**, and select **Generate API Key Pair**.

Download both the generated private `<ssh_key_private>` and public `<ssh_key_private>.pub` keys and save them under your folder `~/.ssh/`.

Click **Add** button and it will automatically gather the required information for you. Copy and paste this into your secret `terraform.tfvars` file.

```json
tenancy="ocid1.tenancy.oc1.."
user="ocid1.user.oc1.."
fingerprint="f9:2b:2a:02.."
region="us-phoenix-1"
path_ssh_key_private="~/.ssh/<ssh_key_private>"
```

Append the prefix `oci_`to the variables above for compatibility with existing Terraform code, e.g. `oci_user`.

## Creating SSH Keys

Skip this if you have already completed [TL;DR](#tldr). Otherwise, create SSH keys for API signing into your OCI account.

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

Skip this if you have already completed [TL;DR](#tldr). Otherwise, copy and paste the following information into your secrets Terraform variables file `terraform.tfvars`.

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

## Create scripts for a minimal Terraform project

Before you can use your secret `terraform.tfvars` file, you must create a `variables.tf` file with the following placeholders, one for each variable.

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

Next create your `main.tf` and `outputs.tf` files for a minimal Terraform project that lists all available domains. This project is found under `tf/001/` folder.

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

Create the `versions.tf` file if the provider isn't supported by `hashi`. However, OCI is supported, hence this file is optional.

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
          +- 002/                     <-- Create a compartment Terraform project
          +- 003/                     <-- Create a compute instance Terraform project

---
# Installation

## Terraform

* [Download Terraform 0.14.9](https://releases.hashicorp.com/terraform)

Terraform is distributed as a single binary. Install Terraform (64-bit) by unzipping it and moving it to a directory included in your system's ```PATH```.

# References

* [Terraform: Set Up OCI Terraform](https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-provider/01-summary.htm)

* [Terraform: Create a Compartment](https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-compartment/01-summary.htm)

* [Compute Shapes](https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm)
