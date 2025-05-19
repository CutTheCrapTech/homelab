# Cloudflare Adblock & Malware DNS Filtering

OpenTofu module for Cloudflare Zero Trust Gateway DNS policies to block ads/malware. Fetches external domain lists, processes them, and updates Cloudflare.

## Overview

Enhances network security and user experience by filtering unwanted content at the DNS level using Cloudflare Gateway.

**Key Components & Functionality:**

1.  **`adblock_urls.txt`**:
    *   Contains URLs to ad/malware domain lists (e.g., Hagezi). Add/Delete lists from here.

2.  **`chunk_adblock_lists.sh` (Shell Script)**:
    *   **Purpose**: Downloads domains from `adblock_urls.txt`, processes them into a unique sorted list, and splits them into chunk files (e.g., `adblock_chunk_000.txt`) in `./processed_adblock_chunks/`.
    *   **Usage**: Used by `tofu plan/apply` and GitHub Actions to update domain lists for Cloudflare.

3.  **OpenTofu Configuration (`.tofu` files)**:
    *   **`cloudflare_zero_trust_list.tofu`**: Creates `cloudflare_zero_trust_list` resources from chunk files in `./processed_adblock_chunks/`, populating them with domains.
    *   **`cloudflare_zero_trust_gateway_policy.tofu`**: Defines DNS Gateway policies: `block_ads` uses the generated domain lists, and `block_malware` uses Cloudflare's predefined categories.
    *   **`cloudflare_zero_trust_dns_location.tofu` (Optional/Example)**: Sets up a custom DNS location (e.g., "HomeLab") in Cloudflare Zero Trust for DoH endpoints.
    *   **`backend.tofu`**: Configures GCS backend for OpenTofu state (prefix: `cf-adblock/prod` or per environment).
    *   **`providers.tofu`**: Defines Cloudflare and HTTP providers, versions, and state encryption.
    *   **`variables.tofu`**: Defines input variables (Cloudflare details, GCS bucket, encryption passphrase).

## GitHub Action Automation (`cf_adblock.yaml`)

Automates blocklist updates using [github action](/.github/workflows/cf_adblock.yaml):

1.  **Triggers**: Scheduled (e.g., monthly) and manual (`workflow_dispatch`) triggers.
2.  **Setup**: Checks out code, loads `.env` variables. Authenticates to Infisical (fetches secrets for `/tofu` and `/tofu_rw`) and Google Cloud (WIF for GCS access). Sets up OpenTofu.
3.  **Execution**: Runs `chunk_adblock_lists.sh` (in `tofu/cf-adblock/`) to generate domain chunks. Then runs `tofu init`, `tofu plan`, and `tofu apply -auto-approve` (if changes) to update Cloudflare.

## Required Inputs (Variables)

Configure these via Infisical secrets (surfaced as `TF_VAR_...` environment variables):

*   `TF_VAR_cloudflare_secondary_account_id`: Your Cloudflare Account ID for Zero Trust configurations.
*   `TF_VAR_cloudflare_secondary_api_token`: Cloudflare API Token for Zero Trust management. **Sensitive secret.**
*   `TF_VAR_bucket_name`: GCS bucket name for OpenTofu remote state.
*   `TF_VAR_tofu_encryption_passphrase`: Passphrase for OpenTofu state encryption. **Sensitive secret.**

## Manual Setup & Execution (Local Environment)

Note: By default, every month, it updates the list, running as a [github action](/.github/workflows/cf_adblock.yaml). To run manually (e.g., in devcontainer):

1.  **Prerequisites**:
    *   Follow instructions in [devcontainer](/.devcontainer/README.md) on the steps to setup devcontainer.
    *   `cd tofu/cf-adblock`.

2.  **Prepare Domain Lists**:
    *   Run `bash ./chunk_adblock_lists.sh <chunk_size>` (e.g., 1000).
    *   Verify files in `./processed_adblock_chunks/`.

3.  **Initialize OpenTofu**:
    *   Run `tofu init` (uses `TF_VAR_bucket_name` & `TF_VAR_gcs_env`).

4.  **Plan Changes**:
    *   Run `tofu plan`. Review changes.

5.  **Apply Changes**:
    *   If acceptable, run `tofu apply`.

Provides automated, robust ad/malware blocking via Cloudflare DNS filtering.
