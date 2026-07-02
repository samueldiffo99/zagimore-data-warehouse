-- ==============================================================
-- 03: AGGREGATE TABLES, VIEWS & SNAPSHOTS
-- Category/Region rollups + Daily Store Snapshot for reporting
-- ==============================================================

-- Creating One-Way Aggregate by Category Table in Data Staging
SELECT SUM(r.DollarAmount), r.customerkey, r.storekey, r.calendarkey, cad.categorykey
FROM Revenue_Fact_Table r, Category_Dimension cad, Product_Dimension pd
WHERE cad.categoryname = pd.categoryname
AND r.productkey = pd.productkey
GROUP BY r.customerkey, r.storekey, r.calendarkey, cad.categorykey

CREATE TABLE OneWayAggregateByCategory AS
SELECT SUM(r.DollarAmount), r.customerkey, r.storekey, r.calendarkey, cad.categorykey
FROM Revenue_Fact_Table r, Category_Dimension cad, Product_Dimension pd
WHERE cad.categoryname = pd.categoryname
AND r.productkey = pd.productkey
GROUP BY r.customerkey, r.storekey, r.calendarkey, cad.categorykey


-- Creating Category Dimension and One-Way Aggregate by Category in Data Warehouse
CREATE TABLE diffots_ZAGIMORE_dw.Category_Dimension AS
SELECT *
FROM Category_Dimension

CREATE TABLE diffots_ZAGIMORE_dw.OneWayAggregateByCategory AS 
SELECT *
FROM OneWayAggregateByCategory

ALTER TABLE diffots_ZAGIMORE_dw.Category_Dimension
ADD PRIMARY KEY (categorykey)

ALTER TABLE diffots_ZAGIMORE_dw.OneWayAggregateByCategory
ADD FOREIGN KEY (customerkey) REFERENCES diffots_ZAGIMORE_dw.Customer_Dimension(customerkey),
ADD FOREIGN KEY (storekey) REFERENCES diffots_ZAGIMORE_dw.Store_Dimension(storekey),
ADD FOREIGN KEY (calendarkey) REFERENCES diffots_ZAGIMORE_dw.Calendar_Dimension(calendarkey),
ADD FOREIGN KEY (categorykey) REFERENCES diffots_ZAGIMORE_dw.Category_Dimension(categorykey)

ALTER TABLE diffots_ZAGIMORE_dw.OneWayAggregateByCategory 
ADD PRIMARY KEY (customerkey, storekey, calendarkey, categorykey)


-- Creating Store Region Dimension in Data Staging
SELECT DISTINCT regionid, regionname
FROM Store_Dimension

CREATE TABLE Region_Dimension
(regionkey INT AUTO_INCREMENT,
regionid CHAR(1) NOT NULL,
regionname VARCHAR(25) NOT NULL,
PRIMARY KEY (regionkey))

INSERT INTO diffots_ZAGIMORE_ds.Region_Dimension(regionid, regionname)
SELECT DISTINCT regionid, regionname
FROM Store_Dimension

-- Creating One-Way Aggregate by Region in Data Staging
SELECT SUM(rf.DollarAmount), rf.customerkey, rf.productkey, re.regionkey, rf.calendarkey
FROM Revenue_Fact_Table rf, Store_Dimension s, Region_Dimension re
WHERE re.regionname = s.regionname
AND rf.storekey = s.storekey
GROUP BY rf.customerkey, rf.productkey, re.regionkey, rf.calendarkey

CREATE TABLE OneWayAggregateByRegion AS
SELECT SUM(rf.DollarAmount), rf.customerkey, rf.productkey, re.regionkey, rf.calendarkey
FROM Revenue_Fact_Table rf, Store_Dimension s, Region_Dimension re
WHERE re.regionname = s.regionname
AND rf.storekey = s.storekey
GROUP BY rf.customerkey, rf.productkey, re.regionkey, rf.calendarkey


-- Creating Region Dimension and One-Way Aggregate by Region in Data Warehouse
CREATE TABLE diffots_ZAGIMORE_dw.Region_Dimension AS
SELECT *
FROM Region_Dimension

CREATE TABLE diffots_ZAGIMORE_dw.OneWayAggregateByRegion AS
SELECT *
FROM OneWayAggregateByRegion

ALTER TABLE diffots_ZAGIMORE_dw.Region_Dimension
ADD PRIMARY KEY (regionkey)

ALTER TABLE diffots_ZAGIMORE_dw.OneWayAggregateByRegion
ADD FOREIGN KEY (customerkey) REFERENCES diffots_ZAGIMORE_dw.Customer_Dimension(customerkey),
ADD FOREIGN KEY (productkey) REFERENCES diffots_ZAGIMORE_dw.Product_Dimension(productkey),
ADD FOREIGN KEY (regionkey) REFERENCES diffots_ZAGIMORE_dw.Region_Dimension(regionkey),
ADD FOREIGN KEY (calendarkey) REFERENCES diffots_ZAGIMORE_dw.Calendar_Dimension(calendarkey)

ALTER TABLE diffots_ZAGIMORE_dw.OneWayAggregateByRegion
ADD PRIMARY KEY (customerkey, productkey, regionkey, calendarkey)


-- CREATION OF SNAPSHOTS

-- Creation of Daily Store Snapshot
SELECT SUM(r.DollarAmount) AS TotalRevenue, COUNT(DISTINCT r.tid) AS NumOfTransactions, AVG(r.DollarAmount) AS AverageRevenuePerLineItem, SUM(r.DollarAmount)/COUNT(DISTINCT r.tid) AS AverageRevenuePerTransaction, r.storekey, r.calendarkey 
FROM Revenue_Fact_Table r
GROUP BY r.storekey, r.calendarkey 

CREATE TABLE DailyStoreSnapshot AS
SELECT SUM(r.DollarAmount) AS TotalRevenue, COUNT(DISTINCT r.tid) AS NumOfTransactions, AVG(r.DollarAmount) AS AverageRevenuePerLineItem, SUM(r.DollarAmount)/COUNT(DISTINCT r.tid) AS AverageRevenuePerTransaction, r.storekey, r.calendarkey 
FROM Revenue_Fact_Table r
GROUP BY r.storekey, r.calendarkey 

-- Other specific snapshots

ALTER TABLE DailyStoreSnapshot
ADD TotalFootwearRevenue DECIMAL(8,2),
ADD TotalNumHighRevTransaction INT,
ADD TotalLocalRevenue DECIMAL(8,2)

-- Total Footwear Revenue
CREATE VIEW FR AS
SELECT SUM(r.DollarAmount) AS TotalFootwearRevenue, r.storekey, r.calendarkey 
FROM Revenue_Fact_Table r, Product_Dimension p
WHERE r.productkey = p.productkey
AND p.categoryname = "Footwear"
GROUP BY r.storekey, r.calendarkey 

-- Total Number of $100+ Transactions
CREATE VIEW RT AS
SELECT SUM(r.DollarAmount) AS TotalRevPerTransaction, r.storekey, r.calendarkey, r.tid
FROM Revenue_Fact_Table r
GROUP BY r.storekey, r.calendarkey, r.tid

CREATE VIEW HT AS
SELECT COUNT(DISTINCT r.tid) AS TotalNumHighRevTransaction, r.storekey, r.calendarkey 
FROM RT r
WHERE r.TotalRevPerTransaction > 100
GROUP BY r.storekey, r.calendarkey

-- Total Local Revenue
CREATE VIEW LR AS
SELECT SUM(r.DollarAmount) AS TotalLocalRevenue, r.storekey, r.calendarkey 
FROM Revenue_Fact_Table r, Store_Dimension s, Customer_Dimension c
WHERE r.storekey = s.storekey
AND r.customerkey = c.customerkey
AND LEFT(c.customerzip,2) = LEFT(s.storezip,2)
GROUP BY r.storekey, r.calendarkey

-- Populate Total Footwear Revenue table
UPDATE DailyStoreSnapshot ds, FR
SET ds.TotalFootwearRevenue = FR.TotalFootwearRevenue
WHERE ds.storekey = FR.storekey
AND ds.calendarkey = FR.calendarkey

UPDATE DailyStoreSnapshot ds
SET ds.TotalFootwearRevenue = 0
WHERE ds.TotalFootwearRevenue IS NULL

-- Populate Total Number of High Revenue Transactions table
UPDATE DailyStoreSnapshot ds, HT
SET ds.TotalNumHighRevTransaction = HT.TotalNumHighRevTransaction
WHERE ds.storekey = HT.storekey
AND ds.calendarkey = HT.calendarkey

UPDATE DailyStoreSnapshot ds
SET ds.TotalNumHighRevTransaction = 0
WHERE ds.TotalNumHighRevTransaction IS NULL

-- Populate Total Local Revenue table
UPDATE DailyStoreSnapshot ds, LR
SET ds.TotalLocalRevenue = LR.TotalLocalRevenue
WHERE ds.storekey = LR.storekey
AND ds.calendarkey = LR.calendarkey

UPDATE DailyStoreSnapshot ds
SET ds.TotalLocalRevenue = 0
WHERE ds.TotalLocalRevenue IS NULL


-- Creation of Daily Store Snapshot in Data Warehouse
CREATE TABLE diffots_ZAGIMORE_dw.DailyStoreSnapshot AS
SELECT *
FROM DailyStoreSnapshot

ALTER TABLE diffots_ZAGIMORE_dw.DailyStoreSnapshot
ADD PRIMARY KEY (storekey, calendarkey),
ADD FOREIGN KEY (storekey) REFERENCES Store_Dimension(storekey),
ADD FOREIGN KEY (calendarkey) REFERENCES Calendar_Dimension(calendarkey)


