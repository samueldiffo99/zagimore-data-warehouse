# Zagimore Data Warehouse

A dimensional data warehouse and incremental ETL pipeline built for **Zagimore**, a fictional outdoor-gear retailer that both **sells and rents** equipment across multiple stores and regions. Designed and implemented in MySQL as part of a graduate Data Warehousing course (MBA in Business Analytics, Clarkson University).

## Business Problem

Zagimore's operational system tracks sales and rentals as two completely separate transaction flows, across products, stores, customers, and regions. Leadership had no unified way to answer basic revenue questions — "how much revenue came from Region 3 last month, sales and rentals combined?" — without manually stitching together multiple source tables. This project builds a warehouse that unifies both revenue streams into a single, analysis-ready fact table, with a pipeline that keeps it up to date automatically.

## Architecture

<p align="center">
  <img src="star_schema_diagram.jpg" alt="Zagimore OLTP schema to star schema mapping" width="900">
</p>

The diagram above shows the transformation from the OLTP source schema (left) into the dimensional star schema (right). Color coding maps each source table's key attributes to the dimension or fact table they feed.

**Star schema:**
- **Revenue Fact Table** — grain: one row per product, per transaction, per revenue type (`Sales`, `Rental, daily`, `Rental, weekly`). Sales and rentals are conformed into a single `DollarAmount` measure, so reporting doesn't care which operational system a dollar came from.
- **Customer Dimension** — SCD Type 2
- **Product Dimension** — SCD Type 2 (includes sales price and both rental price tiers)
- **Store Dimension** — includes denormalized region attributes for one-hop regional rollups
- **Calendar Dimension** — standard date dimension (full date, month-year, year)

**Two-tier pipeline:** every load moves data through a **staging area** (`diffots_ZAGIMORE_ds`) before landing in the **warehouse** (`diffots_ZAGIMORE_dw`), so failed or partial loads never corrupt production warehouse tables.

## What This Project Demonstrates

| Capability | Where |
|---|---|
| Star schema design from a normalized OLTP source | `01_oltp_schema.sql` |
| Conforming two transaction types (sales + rentals) into one fact grain | `02_dimensional_model.sql` |
| Aggregate tables & reporting views (by category, by region, daily snapshot) | `03_aggregates_and_views.sql` |
| Incremental ("delta") ETL using extraction timestamps, not full reloads | `04_etl_incremental_load.sql` |
| Late-arriving fact handling | `04_etl_incremental_load.sql` |
| Slowly Changing Dimension Type 2 (historical attribute versioning) | `06_scd_type2.sql` |

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

- **Why a staging area instead of loading straight into the warehouse?** Isolates raw incremental extracts from the warehouse, so a bad batch can be inspected or discarded before it touches reporting tables.
- **Why SCD Type 2 instead of just overwriting changed attributes?** Overwriting a customer's zip code or a product's price would silently corrupt historical revenue reports (a sale made in the old region would get misattributed after the fact). Type 2 preserves both versions with validity windows (`dvu`/`dvf`) so historical facts always join to the dimension version that was true at transaction time.
- **Why unify sales and rentals into one fact table instead of two?** Most revenue questions ("total revenue by store," "top-performing region") don't care about the transaction mechanism. A single conformed grain with a `revenuetype` attribute avoids duplicating every downstream aggregate and view.

## Tech Stack

MySQL · Dimensional modeling · Stored procedures · ETL design
