# Azure Project Deployment Plan

This document outlines the Azure resources to be deployed using Terraform for the CLO800 Project 1, including naming conventions, values, and design decisions.

**Student ID:** `178000238`

## 1. Naming Convention

All primary Azure resources will be prefixed with the `StudentID` (`178000238`) to ensure uniqueness and adherence to project requirements.

**Example:**
*   Resource Group: `178000238-s24-RG`
*   Virtual Network: `178000238-vnet1`
*   Virtual Machine: `178000238-R1-VM1`

## 2. Azure Regions

The application will be deployed across two Azure regions to ensure high availability and proximity-based traffic routing.

*   **Region 1:** `West US` (Terraform value: `westus`)
*   **Region 2:** `West Europe` (Terraform value: `westeurope`)

## 3. IP Address Planning

The project requires using a personal IP address range for all subnets. The provided range is `172.16.135.0/24`. This `/24` range will be carefully subnetted to accommodate two Virtual Networks, each with two subnets.

**Decision:** The `/24` range will be split into two `/25` networks, and then each `/25` will be further split into two `/26` subnets.

*   **Overall Personal IP Range:** `172.16.135.0/24`

*   **Virtual Network 1 (West US):**
    *   **VNet CIDR:** `172.16.135.0/25` (128 IP addresses)
    *   **Subnet for Application VMs:** `172.16.135.0/26` (64 IP addresses)
    *   **Subnet for Client VM:** `172.16.135.64/26` (64 IP addresses)

*   **Virtual Network 2 (West Europe):**
    *   **VNet CIDR:** `172.16.135.128/25` (128 IP addresses)
    *   **Subnet for Application VMs:** `172.16.135.128/26` (64 IP addresses)
    *   **Subnet for Client VM:** `172.16.135.192/26` (64 IP addresses)

## 4. Core Infrastructure Resources

### 4.1. Resource Group

*   **Name:** `178000238-s24-RG`
*   **Location:** `West US` (Resource group location is flexible, but chosen for proximity to one of the main regions).
*   **Tags:**
    *   `Project`: `Project1`
    *   `Course`: `CLO800`

### 4.2. Virtual Machines (VMs)

*   **Operating System:** Windows Server 2019 Datacenter (Latest version)
*   **VM Size:** `Standard_B2s`
*   **Admin Username:** `kevinadmin`
*   **Admin Password:** `P@ssw0rd1234` (Sensitive, stored in `terraform.tfvars`)
*   **IIS Deployment:** VMs will be deployed with network connectivity. IIS installation and webpage modification will be performed manually after deployment.
*   **Security Locks:** All VMs will have a `CanNotDelete` lock applied to prevent accidental deletion.

**Application VMs (4 total):**
*   **Region 1 (West US):**
    *   `178000238-R1-VM1`
    *   `178000238-R1-VM2`
*   **Region 2 (West Europe):**
    *   `178000238-R2-VM3`
    *   `178000238-R2-VM4`

**Client VMs (2 total):**
*   **Region 1 (West US):** `178000238-Client-R1` (with a dedicated Public IP for RDP access)
*   **Region 2 (West Europe):** `178000238-Client-R2` (with a dedicated Public IP for RDP access)

### 4.3. Network Security Groups (NSGs)

*   **Application VM NSGs (one per region):**
    *   Allow Inbound TCP Port 80 (HTTP) from Internet (for Load Balancer health probes and application traffic).
    *   Allow Inbound TCP Port 3389 (RDP) from Internet (for management access).
*   **Client VM NSG (shared):**
    *   Allow Inbound TCP Port 3389 (RDP) from Internet (for management access).

## 5. Load Balancing (Layer 4)

Each region will have a Standard Azure Load Balancer to distribute traffic among the two application VMs in that region using a Round Robin algorithm.

*   **Load Balancer 1 (West US):**
    *   **Name:** `178000238-lb1`
    *   **Public IP:** `178000238-lb1-pip` (Standard SKU, Static allocation)
    *   **Backend Pool:** `178000238-lb1-backendpool` (contains `178000238-R1-VM1` and `178000238-R1-VM2`)
    *   **Health Probe:** TCP Port 80
    *   **Load Balancing Rule:** Frontend Port 80 -> Backend Port 80 (TCP)

*   **Load Balancer 2 (West Europe):**
    *   **Name:** `178000238-lb2`
    *   **Public IP:** `178000238-lb2-pip` (Standard SKU, Static allocation)
    *   **Backend Pool:** `178000238-lb2-backendpool` (contains `178000238-R2-VM3` and `178000238-R2-VM4`)
    *   **Health Probe:** TCP Port 80
    *   **Load Balancing Rule:** Frontend Port 80 -> Backend Port 80 (TCP)

## 6. Traffic Redirection Service (Azure Traffic Manager)

Azure Traffic Manager will be used to redirect user traffic to the closest available region based on performance.

*   **Traffic Manager Profile Name:** `178000238-kevinwang-mywebapp-trafficmanager`
*   **Routing Method:** `Performance` (routes users to the endpoint with the lowest latency).
*   **DNS Config:** Relative name enabled, TTL 60 seconds.
*   **Monitor Config:**
    *   Protocol: HTTP
    *   Port: 80
    *   Path: `/` (assumes IIS default page is at root)
    *   Interval: 30 seconds
    *   Timeout: 9 seconds
    *   Tolerated Failures: 3

*   **Endpoints:**
    *   **Endpoint 1 (West US):**
        *   **Name:** `178000238-tm-endpoint-r1`
        *   **Target:** FQDN of `178000238-lb1-pip`
        *   **Location:** `westus`
    *   **Endpoint 2 (West Europe):**
        *   **Name:** `178000238-tm-endpoint-r2`
        *   **Target:** FQDN of `178000238-lb2-pip`
        *   **Location:** `westeurope`

## 7. Azure Policy Enforcement

An Azure Policy will be assigned to the main resource group to enforce the presence of specific tags on resources within it.

*   **Policy Definition:** Built-in policy "Append tags and their values to resources".
*   **Policy Assignment Name:** `178000238-tag-enforcement-policy-assignment`
*   **Scope:** `178000238-s24-RG` (the main resource group)
*   **Parameters:**
    *   `tagName1`: `Project`, `tagValue1`: `Project1`
    *   `tagName2`: `Course`, `tagValue2`: `CLO800`

**Decision:** This policy will ensure that any new or updated resources within the resource group will have these tags appended or modified if they are missing or have different values. All resources created by this Terraform script already explicitly include these tags.

## 8. Terraform Files Overview

*   **`main.tf`**: Contains the primary resource definitions for the Azure infrastructure.
*   **`variables.tf`**: Defines all input variables, allowing for flexible configuration without hardcoding values.
*   **`outputs.tf`**: Specifies the important information to be displayed after a successful Terraform deployment, such as FQDNs and public IP addresses.
*   **`terraform.tfvars`**: Stores the actual values for the variables, including sensitive information like passwords. This file should be kept secure.

---

This document provides a comprehensive overview of the planned Azure deployment.