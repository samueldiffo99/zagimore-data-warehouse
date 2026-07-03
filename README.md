# Zagimore Data Warehouse

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat&logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-CC2927?style=flat&logo=microsoft-sql-server&logoColor=white)
![Database](https://img.shields.io/badge/Dimensional%20Modeling-4B0082?style=flat)

A dimensional data warehouse and incremental ETL pipeline built for **Zagimore**, a fictional outdoor-gear retailer that both **sells and rents** equipment across multiple stores and regions. Designed to unify disparate transactional flows into a cohesive star schema for unified reporting.

**[Star Schema Diagram](./star_schema_diagram.jpg)**

## Business Problem

Zagimore's operational system tracks sales and rentals as two completely separate transaction flows, across products, stores, customers, and regions. Leadership had no unified way to answer basic revenue questions like "total sales by region" or "top 10 products by revenue type."

This project demonstrates how to consolidate fragmented OLTP data into a clean, dimensional schema optimized for reporting.

## Architecture

<p align="center">
  <img src="star_schema_diagram.jpg" alt="Zagimore OLTP schema to star schema mapping" width="900">
</p>

The diagram above shows the transformation from the OLTP source schema (left) into the dimensional star schema (right). Color coding maps each source table's key attributes to the dimension or fact table it populates.

**Star schema:**
- **Revenue Fact Table** — grain: one row per product, per transaction, per revenue type (`Sales`, `Rental, daily`, `Rental, weekly`). Sales and rentals are conformed into a single `DollarAmount` for seamless aggregation.
- **Customer Dimension** — SCD Type 2 (tracks historical address, segment, tier changes)
- **Product Dimension** — SCD Type 2 (includes sales price and both rental price tiers)
- **Store Dimension** — includes denormalized region attributes for one-hop regional rollups
- **Calendar Dimension** — standard date dimension (full date, month-year, year)

**Two-tier pipeline:** every load moves data through a **staging area** (`diffots_ZAGIMORE_ds`) before landing in the **warehouse** (`diffots_ZAGIMORE_dw`), so failed or partial loads never corrupt the reporting layer.

## What This Project Demonstrates

| Capability | Where |
|---|---|
| Star schema design from a normalized OLTP source | `01_oltp_schema.sql` |
| Conforming two transaction types (sales + rentals) into one fact grain | `02_dimensional_model.sql` |
| Aggregate tables & reporting views (by category, by region, daily snapshot) | `03_aggregates_and_views.sql` |
| Incremental ("delta") ETL using extraction timestamps, not full reloads | `04_etl_incremental_load.sql` |
| Late-arriving fact handling | `04_etl_incremental_load.sql` |
| Slowly Changing Dimension Type 2 (historical attribute versioning) | `06_scd_type2.sql` |

## Installation & Quick Start

### Prerequisites
- MySQL 5.7+ or MySQL 8.0+
- MySQL client command line or GUI (e.g., MySQL Workbench)

### Setup

```bash
# Clone the repo
git clone https://github.com/samueldiffo99/zagimore-data-warehouse.git
cd zagimore-data-warehouse

# Log into MySQL
mysql -u root -p

# Run the setup scripts in order
SOURCE 01_oltp_schema.sql;
SOURCE 02_dimensional_model.sql;
SOURCE 03_aggregates_and_views.sql;
SOURCE 04_etl_incremental_load.sql;
SOURCE 05_dimension_refresh.sql;
SOURCE 06_scd_type2.sql;

# Verify the warehouse
SELECT COUNT(*) FROM diffots_ZAGIMORE_dw.Fact_Revenue;
```

## Repo Structure

```
01_oltp_schema.sql          -- source operational tables (vendor, product, transactions...)
02_dimensional_model.sql    -- star schema DDL: dimensions + Revenue Fact Table
03_aggregates_and_views.sql -- category/region rollups, daily store snapshot
04_etl_incremental_load.sql -- daily fact refresh + late-arriving fact procedures
05_dimension_refresh.sql    -- baseline dimension refresh procedures
06_scd_type2.sql             -- Type 2 historical versioning for Product & Customer
star_schema_diagram.jpg     -- ER diagram: OLTP source → star schema mapping
```

## Key Design Decisions

- **Why a staging area instead of loading straight into the warehouse?** Isolates raw incremental extracts from the warehouse, so a bad batch can be inspected or discarded before it touches reporting tables. Prevents silent corruption.
- **Why SCD Type 2 instead of just overwriting changed attributes?** Overwriting a customer's zip code or a product's price would silently corrupt historical revenue reports (a sale made in the old price tier must forever reflect that tier, not tomorrow's price). Type 2 maintains versioned history.
- **Why unify sales and rentals into one fact table instead of two?** Most revenue questions ("total revenue by store," "top-performing region") don't care about the transaction mechanism. A single conformed fact table makes aggregation simple and avoids redundant calculations.

## Sample Queries

```sql
-- Total revenue by region and product category
SELECT 
    s.Region,
    p.Category,
    SUM(f.DollarAmount) AS TotalRevenue
FROM diffots_ZAGIMORE_dw.Fact_Revenue f
JOIN diffots_ZAGIMORE_dw.Dim_Store s ON f.StoreKey = s.StoreKey
JOIN diffots_ZAGIMORE_dw.Dim_Product p ON f.ProductKey = p.ProductKey
GROUP BY s.Region, p.Category
ORDER BY TotalRevenue DESC;

-- Year-over-year revenue trend
SELECT 
    c.Year,
    SUM(f.DollarAmount) AS YearlyRevenue
FROM diffots_ZAGIMORE_dw.Fact_Revenue f
JOIN diffots_ZAGIMORE_dw.Dim_Calendar c ON f.DateKey = c.DateKey
GROUP BY c.Year
ORDER BY c.Year;
```

## Tech Stack

MySQL · Dimensional modeling · Stored procedures · ETL design · Slowly Changing Dimensions
