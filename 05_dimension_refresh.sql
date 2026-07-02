-- ==============================================================
-- 05: DIMENSION REFRESH PROCEDURES
-- Product, Customer, Store dimension refresh (pre-SCD2)
-- ==============================================================

-- CREATION OF REFRESH PROCEDURES FOR DIMENSIONS

-- Product Dimension Refresh
INSERT INTO diffots_ZAGIMORE.product(productid, productname, productprice, vendorid, categoryid)
VALUES("1Y1","Test Product",100.00,"PG","CP")
INSERT INTO diffots_ZAGIMORE.rentalProducts(productid, productname, productpricedaily, productpriceweekly, vendorid, categoryid)
VALUES("1Z1","Test rental Product",10.00,70.00,"PG","CP")

-- Adding two new columns to the data staging area
ALTER TABLE diffots_ZAGIMORE_ds.Product_Dimension
ADD ExtractionTimeStamp timestamp,
ADD pd_loaded boolean;

UPDATE diffots_ZAGIMORE_ds.Product_Dimension
SET ExtractionTimeStamp = NOW() - INTERVAL 14 DAY;

UPDATE diffots_ZAGIMORE_ds.Product_Dimension
SET pd_loaded = TRUE

-- Rewriting the Product Dimension with 2 new columns
CREATE PROCEDURE ProductRefresh()
BEGIN

INSERT INTO diffots_ZAGIMORE_ds.Product_Dimension(productid, productname, vendorid, categoryid, categoryname, vendorname, ProductType, productsalesprice, productdailyrentalprice, productweeklyrentalprice, ExtractionTimeStamp, pd_loaded)
SELECT r.productid, r.productname, r.vendorid, r.categoryid, c.categoryname, v.vendorname, 'R', NULL, r.productpricedaily, r.productpriceweekly, NOW(), FALSE
FROM diffots_ZAGIMORE.rentalProducts r, diffots_ZAGIMORE.vendor v, diffots_ZAGIMORE.category c
WHERE r.categoryid = c.categoryid
AND v.vendorid = r.vendorid
AND r.productid NOT IN (SELECT DISTINCT productid FROM diffots_ZAGIMORE_ds.Product_Dimension WHERE ProductType = "R")
UNION
SELECT p.productid, p.productname, p.vendorid, p.categoryid, c.categoryname, v.vendorname, 'S', p.productprice, NULL, NULL, NOW(), FALSE
FROM diffots_ZAGIMORE.product p, diffots_ZAGIMORE.vendor v, diffots_ZAGIMORE.category c
WHERE p.categoryid = c.categoryid
AND v.vendorid = p.vendorid
AND p.productid NOT IN (SELECT DISTINCT productid FROM diffots_ZAGIMORE_ds.Product_Dimension WHERE ProductType = "S");

-- Loading Product Dimensions into data warehouse
INSERT INTO diffots_ZAGIMORE_dw.Product_Dimension(productkey, productid, productname, vendorid, categoryid, categoryname, vendorname, ProductType, productsalesprice, productdailyrentalprice, productweeklyrentalprice)
SELECT pd.productkey, pd.productid, pd.productname, pd.vendorid, pd.categoryid, pd.categoryname, pd.vendorname, pd.ProductType, pd.productsalesprice, pd.productdailyrentalprice, pd.productweeklyrentalprice
FROM diffots_ZAGIMORE_ds.Product_Dimension pd
WHERE pd_loaded = FALSE;

UPDATE diffots_ZAGIMORE_ds.Product_Dimension
SET pd_loaded = TRUE
WHERE pd_loaded = FALSE;

END

-- Test 1
INSERT INTO diffots_ZAGIMORE.product(productid, productname, productprice, vendorid, categoryid)
VALUES("2Y2","Test Product02",100.00,"PG","CP");
INSERT INTO diffots_ZAGIMORE.rentalProducts(productid, productname, productpricedaily, productpriceweekly, vendorid, categoryid)
VALUES("2Z2","Test rental Product02",10.00,70.00,"PG","CP")

-- Test 2
INSERT INTO diffots_ZAGIMORE.product(productid, productname, productprice, vendorid, categoryid)
VALUES("3Y3","Test Product03",100.00,"PG","CP");
INSERT INTO diffots_ZAGIMORE.rentalProducts(productid, productname, productpricedaily, productpriceweekly, vendorid, categoryid)
VALUES("3Z3","Test rental Product03",10.00,70.00,"PG","CP")


-- ROW COUNT CHECK
CREATE PROCEDURE Rowcountcheck()
BEGIN

SELECT COUNT(*) AS NumberofRows, "RentalProduct rows" AS SourceTable
FROM diffots_ZAGIMORE.rentalProducts
UNION 
SELECT COUNT(*) AS NumberofRows, "Product rows" AS SourceTable
FROM diffots_ZAGIMORE.product
UNION
SELECT COUNT(*) AS NumberofRows, "Product Dimension Table rows in DS" AS SourceTable
FROM diffots_ZAGIMORE_ds.Product_Dimension
UNION
SELECT COUNT(*) AS NumberofRows, "Product Dimension Table rows in DW" AS SourceTable
FROM diffots_ZAGIMORE_dw.Product_Dimension
UNION 
SELECT COUNT(*) AS NumberofRows, "Current Product Dimension Table rows in DS" AS SourceTable
FROM diffots_ZAGIMORE_ds.Product_Dimension
WHERE currentstatus = TRUE
UNION 
SELECT COUNT(*) AS NumberofRows, "Current Product Dimension Table rows in DW" AS SourceTable
FROM diffots_ZAGIMORE_dw.Product_Dimension
WHERE currentstatus = TRUE;

SELECT COUNT(*) AS NumberofRows, "soldvia rows" AS SourceTable
FROM diffots_ZAGIMORE.soldvia
UNION 
SELECT COUNT(*) AS NumberofRows, "rentvia rows" AS SourceTable
FROM diffots_ZAGIMORE.rentvia
UNION
SELECT COUNT(*) AS NumberofRows, "Revenue Fact Table rows in DS" AS SourceTable
FROM diffots_ZAGIMORE_ds.Revenue_Fact_Table
UNION
SELECT COUNT(*) AS NumberofRows, "Revenue Fact Table rows in DW" AS SourceTable
FROM diffots_ZAGIMORE_dw.Revenue_Fact_Table;

SELECT COUNT(*) AS NumberofRows, "Customers rows" AS SourceTable
FROM diffots_ZAGIMORE.customer
UNION
SELECT COUNT(*) AS NumberofRows, "Customer Dimension Table rows in DS" AS SourceTable
FROM diffots_ZAGIMORE_ds.Customer_Dimension
UNION
SELECT COUNT(*) AS NumberofRows, "Customer Dimension Table rows in DW" AS SourceTable
FROM diffots_ZAGIMORE_dw.Customer_Dimension
UNION 
SELECT COUNT(*) AS NumberofRows, "Current Customer Dimension Table rows in DS" AS SourceTable
FROM diffots_ZAGIMORE_ds.Customer_Dimension
WHERE currentstatus = TRUE
UNION 
SELECT COUNT(*) AS NumberofRows, "Current Customer Dimension Table rows in DW" AS SourceTable
FROM diffots_ZAGIMORE_dw.Customer_Dimension
WHERE currentstatus = TRUE;

SELECT COUNT(*) AS NumberofRows, "Store rows" AS SourceTable
FROM diffots_ZAGIMORE.store
UNION
SELECT COUNT(*) AS NumberofRows, "Store Dimension Table rows in DS" AS SourceTable
FROM diffots_ZAGIMORE_ds.Store_Dimension
UNION
SELECT COUNT(*) AS NumberofRows, "Store Dimension Table rows in DW" AS SourceTable
FROM diffots_ZAGIMORE_dw.Store_Dimension;

END


--REFRESH PROCEDURE FOR CUSTOMER DIMENSION AND STORE DIMENSION

--CUSTOMER DIMESION REFRESH

INSERT INTO `customer` (`customerid`, `customername`, `customerzip`) VALUES ('9-9-999', 'Samy', '13676');

ALTER TABLE diffots_ZAGIMORE_ds.Customer_Dimension
ADD ExtractionTimeStamp timestamp,
ADD cd_loaded boolean;

UPDATE diffots_ZAGIMORE_ds.Customer_Dimension
SET ExtractionTimeStamp = NOW() - INTERVAL 14 DAY;

UPDATE diffots_ZAGIMORE_ds.Customer_Dimension
SET cd_loaded = TRUE

-- Rewriting the Customer Dimension with 2 new columns
CREATE PROCEDURE customer dimension refresh()
BEGIN

INSERT INTO diffots_ZAGIMORE_ds.Customer_Dimension(customerid, customername, customerzip, ExtractionTimeStamp, cd_loaded)
SELECT c.customerid, c.customername, c.customerzip, NOW(), FALSE
FROM diffots_ZAGIMORE.customer c
WHERE c.customerid NOT IN (SELECT DISTINCT customerid FROM diffots_ZAGIMORE_ds.Customer_Dimension);

-- Loading Customer Dimension into data warehouse
INSERT INTO diffots_ZAGIMORE_dw.Customer_Dimension(customerid, customername, customerzip, customerkey)
SELECT c.customerid, c.customername, c.customerzip, c.customerkey
FROM diffots_ZAGIMORE_ds.Customer_Dimension c
WHERE cd_loaded = FALSE;

UPDATE diffots_ZAGIMORE_ds.Customer_Dimension
SET cd_loaded = TRUE
WHERE cd_loaded = FALSE;

END

-- Test
INSERT INTO `customer` (`customerid`, `customername`, `customerzip`) VALUES ('9-9-987', 'Dieubeni', '33602');


--STORE DIMENSION REFRESH

INSERT INTO `store` (`storeid`, `storezip`, `regionid`) VALUES ('S21', '13676', 'N');

ALTER TABLE diffots_ZAGIMORE_ds.Store_Dimension
ADD ExtractionTimeStamp timestamp,
ADD sd_loaded boolean;

UPDATE diffots_ZAGIMORE_ds.Store_Dimension
SET ExtractionTimeStamp = NOW() - INTERVAL 14 DAY;

UPDATE diffots_ZAGIMORE_ds.Store_Dimension
SET sd_loaded = TRUE

-- Rewriting the Store Dimension with 2 new columns
CREATE PROCEDURE storedimensionrefresh()
BEGIN

INSERT INTO diffots_ZAGIMORE_ds.Store_Dimension(storeid, storezip, regionid, regionname, ExtractionTimeStamp, sd_loaded)
SELECT s.storeid, s.storezip, s.regionid, r.regionname, NOW(), FALSE
FROM diffots_ZAGIMORE.store s
JOIN diffots_ZAGIMORE.region r ON s.regionid = r.regionid
WHERE s.storeid NOT IN (SELECT DISTINCT storeid FROM diffots_ZAGIMORE_ds.Store_Dimension);

-- Loading Store Dimension into data warehouse
INSERT INTO diffots_ZAGIMORE_dw.Store_Dimension(storekey, storeid, storezip, regionid, regionname)
SELECT s.storekey, s.storeid, s.storezip, s.regionid, s.regionname
FROM diffots_ZAGIMORE_ds.Store_Dimension s
WHERE sd_loaded = FALSE;

UPDATE diffots_ZAGIMORE_ds.Store_Dimension
SET sd_loaded = TRUE
WHERE sd_loaded = FALSE;

END

-- Test
INSERT INTO `store` (`storeid`, `storezip`, `regionid`) VALUES ('S22', '33602', 'T');


