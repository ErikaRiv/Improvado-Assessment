---

## Cross-Chanel Performance Dashboard Dashboard 

Link: https://lookerstudio.google.com/s/ouNrb1tZ2BQ

By Erika Rivadeneira

---
## Unified Marketing Ads Data (Snowflake)

## Overview
This project standardizes and unifies advertising data from **Facebook, Google, and TikTok** into a single cross-channel analytics table using **Snowflake SQL**.

The goal is to transform raw, platform-specific datasets into a consistent data model that enables reliable cross-channel performance analysis and visualization.

---

## Data Sources
The following raw datasets are used as inputs:

- **Facebook Ads** (`FACABOOK`)
- **Google Ads** (`GOOGLE`)
- **TikTok Ads** (`TIKTOK`)

All source tables are stored in the `MARKETING_ASSIGNMENT.RAW` schema.

---

## Data Modeling Approach

### 1. Column Standardization (Staging Layer)
Each platform uses different naming conventions and available metrics.  
To handle this, the SQL script creates **staging views** that:

- Standardize common dimensions:
  - `date`
  - `campaign_id`
  - `campaign_name`
  - `ad_set_id`
  - `ad_set_name`
- Normalize metric names (e.g. `cost` → `spend`)
- Add missing platform-specific fields as `NULL` to ensure a consistent schema

Staging views:
- `STG_FACEBOOK`
- `STG_GOOGLE`
- `STG_TIKTOK`

---

### 2. Unified Table
The final table, **`UNIFIED_ADS`**, is created by vertically combining the staging views using `UNION ALL`.

Each record includes a `channel` field to identify the source platform:
- `facebook`
- `google`
- `tiktok`

This table represents daily performance at the campaign and ad set (or ad group) level across all platforms.

---

## Output Table
**Schema:** `MARKETING_ASSIGNMENT.ANALYTICS`  
**Table:** `UNIFIED_ADS`

The unified table supports:
- Cross-channel spend and performance analysis
- Consistent aggregation by date, campaign, and ad set
- Downstream visualization in BI tools

---

## Data Quality Checks
The following validations were performed:
- Verified total spend by channel against source data
- Checked for duplicate records at the  
  `date + channel + campaign_id + ad_set_id` level
- Confirmed consistent daily granularity across all platforms

---

## SQL Script
The full transformation logic is contained in:
