-- ==============================================================
-- 06: SLOWLY CHANGING DIMENSIONS - TYPE 2
-- Historical versioning for Product & Customer dimensions
-- ==============================================================

-- CREATION OF PROCEDURE FOR REFRESHING THE PRODUCT DIMENSION TYPE 2 CHANGES:

ALTER TABLE Product_Dimension
ADD dvf DATE,
ADD dvu DATE,
ADD currentstatus boolean

UPDATE Product_Dimension
SET dvf = '2013-01-01',
dvu = '2035-01-01',
currentstatus = TRUE 

-- Updating Product Refresh Procedure with new columns
BEGIN

INSERT INTO diffots_ZAGIMORE_ds.Product_Dimension(productid, productname, vendorid, categoryid, categoryname, vendorname, ProductType, productsalesprice, productdailyrentalprice, productweeklyrentalprice, ExtractionTimeStamp, pd_loaded, dvu, dvf, currentstatus)
SELECT r.productid, r.productname, r.vendorid, r.categoryid, c.categoryname, v.vendorname, 'R', NULL, r.productpricedaily, r.productpriceweekly, NOW(), FALSE, '2035-01-01', NOW(), TRUE
FROM diffots_ZAGIMORE.rentalProducts r, diffots_ZAGIMORE.vendor v, diffots_ZAGIMORE.category c
WHERE r.categoryid = c.categoryid
AND v.vendorid = r.vendorid
AND r.productid NOT IN (SELECT DISTINCT productid FROM diffots_ZAGIMORE_ds.Product_Dimension WHERE ProductType = "R")
UNION
SELECT p.productid, p.productname, p.vendorid, p.categoryid, c.categoryname, v.vendorname, 'S', p.productprice, NULL, NULL, NOW(), FALSE, '2035-01-01', NOW(), TRUE
FROM diffots_ZAGIMORE.product p, diffots_ZAGIMORE.vendor v, diffots_ZAGIMORE.category c
WHERE p.categoryid = c.categoryid
AND v.vendorid = p.vendorid
AND p.productid NOT IN (SELECT DISTINCT productid FROM diffots_ZAGIMORE_ds.Product_Dimension WHERE ProductType = "S");

-- Loading Product Dimensions into data warehouse
INSERT INTO diffots_ZAGIMORE_dw.Product_Dimension(productkey, productid, productname, vendorid, categoryid, categoryname, vendorname, ProductType, productsalesprice, productdailyrentalprice, productweeklyrentalprice, dvu, dvf, currentstatus)
SELECT pd.productkey, pd.productid, pd.productname, pd.vendorid, pd.categoryid, pd.categoryname, pd.vendorname, pd.ProductType, pd.productsalesprice, pd.productdailyrentalprice, pd.productweeklyrentalprice, pd.dvu, pd.dvf, pd.currentstatus
FROM diffots_ZAGIMORE_ds.Product_Dimension pd
WHERE pd_loaded = FALSE;

UPDATE diffots_ZAGIMORE_ds.Product_Dimension
SET pd_loaded = TRUE
WHERE pd_loaded = FALSE;

END


-- Updating values for testing the procedure
UPDATE `product` SET `productname` = 'Sleeping Bag' WHERE `product`.`productid` = '1X1';
UPDATE `product` SET `productprice` = '155.00' WHERE `product`.`productid` = '1X2';
UPDATE `rentalProducts` SET `productname` = 'Comfy Sock', `productpricedaily` = '7.00' WHERE `rentalProducts`.`productid` = '3X3';

--- Inserting New rows in the product dimension with updated values for attributes that have changed.

CREATE PROCEDURE product_dimension_type2_refresh()

BEGIN

INSERT INTO diffots_ZAGIMORE_ds.Product_Dimension(productid, productname, vendorid, categoryid, categoryname, vendorname, ProductType, productsalesprice, productdailyrentalprice, productweeklyrentalprice, ExtractionTimeStamp, pd_loaded, dvu, dvf, currentstatus)
SELECT r.productid, r.productname, r.vendorid, r.categoryid, c.categoryname, v.vendorname, 'R', NULL, r.productpricedaily, r.productpriceweekly, NOW(), FALSE, '2035-01-01', NOW(), TRUE
FROM diffots_ZAGIMORE.rentalProducts r, diffots_ZAGIMORE.vendor v, diffots_ZAGIMORE.category c, diffots_ZAGIMORE_ds.Product_Dimension pd
WHERE r.categoryid = c.categoryid
AND v.vendorid = r.vendorid
AND r.productid = pd.productid
AND pd.ProductType = 'R'
AND pd.currentstatus = TRUE
AND (r.productpricedaily != pd.productdailyrentalprice OR r.productpriceweekly != pd.productweeklyrentalprice OR r.productname != pd.productname
OR c.categoryname != pd.categoryname OR v.vendorid != pd.vendorid OR v.vendorname != pd.vendorname)
UNION
SELECT p.productid, p.productname, p.vendorid, p.categoryid, c.categoryname, v.vendorname, 'S', p.productprice, NULL, NULL, NOW(), FALSE, '2035-01-01', NOW(), TRUE
FROM diffots_ZAGIMORE.product p, diffots_ZAGIMORE.vendor v, diffots_ZAGIMORE.category c, diffots_ZAGIMORE_ds.Product_Dimension pd
WHERE p.categoryid = c.categoryid
AND v.vendorid = p.vendorid
AND p.productid = pd.productid
AND (p.productprice != pd.productsalesprice OR p.productname != pd.productname
OR c.categoryname != pd.categoryname OR v.vendorid != pd.vendorid OR v.vendorname != pd.vendorname) 
AND pd.ProductType = 'S'
AND pd.currentstatus = TRUE;

-- Updating existing corresponding rows in the product dimension for the instances of product dimension that have changed attributes
-- Making old versions of the product dimension not current

UPDATE diffots_ZAGIMORE_ds.Product_Dimension pd, diffots_ZAGIMORE.product p, diffots_ZAGIMORE.vendor v, diffots_ZAGIMORE.category c
SET pd.dvu = NOW() - INTERVAL 1 DAY,
pd.currentstatus = FALSE,
pd.pd_loaded = FALSE  
WHERE p.categoryid = c.categoryid
AND v.vendorid = p.vendorid
AND p.productid = pd.productid
AND (p.productprice != pd.productsalesprice OR p.productname != pd.productname
OR c.categoryname != pd.categoryname OR v.vendorid != pd.vendorid OR v.vendorname != pd.vendorname) 
AND pd.ProductType = 'S'
AND pd.pd_loaded = TRUE;

UPDATE diffots_ZAGIMORE_ds.Product_Dimension pd, diffots_ZAGIMORE.rentalProducts r, diffots_ZAGIMORE.vendor v, diffots_ZAGIMORE.category c
SET pd.dvu = NOW() - INTERVAL 1 DAY,
pd.currentstatus = FALSE,
pd.pd_loaded = FALSE  
WHERE r.categoryid = c.categoryid
AND v.vendorid = r.vendorid
AND r.productid = pd.productid
AND (r.productpricedaily != pd.productdailyrentalprice OR r.productpriceweekly != pd.productweeklyrentalprice OR r.productname != pd.productname
OR c.categoryname != pd.categoryname OR v.vendorid != pd.vendorid OR v.vendorname != pd.vendorname) 
AND pd.ProductType = 'R'
AND pd.pd_loaded = TRUE;

-- Loading new instances of product dimension into product dimension table into Data Warehouse
-- Updating old instances of product dimensions in product dimensions table that are not current anymore

REPLACE INTO diffots_ZAGIMORE_dw.Product_Dimension(productkey, productid, productname, vendorid, categoryid, categoryname, vendorname, ProductType, productsalesprice, productdailyrentalprice, productweeklyrentalprice, dvu, dvf, currentstatus)
SELECT productkey, productid, productname, vendorid, categoryid, categoryname, vendorname, ProductType, productsalesprice, productdailyrentalprice, productweeklyrentalprice, dvu, dvf, currentstatus
FROM diffots_ZAGIMORE_ds.Product_Dimension pd
WHERE pd.pd_loaded = FALSE;

UPDATE diffots_ZAGIMORE_ds.Product_Dimension
SET pd_loaded = TRUE
WHERE pd_loaded = FALSE;

END


-- CUSTOMER DIMENSION TYPE 2 REFRESH PROCEDURE

ALTER TABLE Customer_Dimension --For both ds and dw
ADD dvf DATE,
ADD dvu DATE,
ADD currentstatus boolean

UPDATE Customer_Dimension  --For both ds and dw
SET dvf = '2013-01-01',
dvu = '2035-01-01',
currentstatus = TRUE

-- Updating Customer Refresh Procedure with new columns

BEGIN

INSERT INTO diffots_ZAGIMORE_ds.Customer_Dimension(customerid, customername, customerzip, ExtractionTimeStamp, cd_loaded, dvu, dvf, currentstatus)
SELECT c.customerid, c.customername, c.customerzip, NOW(), FALSE, '2035-01-01', NOW(), TRUE
FROM diffots_ZAGIMORE.customer c
WHERE c.customerid NOT IN (SELECT DISTINCT customerid FROM diffots_ZAGIMORE_ds.Customer_Dimension);

-- Loading Customer Dimension into data warehouse
INSERT INTO diffots_ZAGIMORE_dw.Customer_Dimension(customerid, customername, customerzip, customerkey, dvu, dvf, currentstatus)
SELECT c.customerid, c.customername, c.customerzip, c.customerkey, c.dvu, c.dvf, c.currentstatus
FROM diffots_ZAGIMORE_ds.Customer_Dimension c
WHERE cd_loaded = FALSE;

UPDATE diffots_ZAGIMORE_ds.Customer_Dimension
SET cd_loaded = TRUE
WHERE cd_loaded = FALSE;

END

-- Changes to track
customername
customerzip

-- Updates for testing the procedure
UPDATE `customer` SET `customername` = 'Rayan' WHERE `customer`.`customerid` = '9-0-111';
UPDATE `customer` SET `customerzip` = '13676' WHERE `customer`.`customerid` = '2-3-444';


--- Inserting New rows in the customer dimension with updated values for attributes that have changed.

CREATE PROCEDURE customer_type2_change_refresh()

BEGIN


INSERT INTO diffots_ZAGIMORE_ds.Customer_Dimension(customerid, customername, customerzip, ExtractionTimeStamp, cd_loaded, dvu, dvf, currentstatus)
SELECT c.customerid, c.customername, c.customerzip, NOW(), FALSE, '2035-01-01', NOW(), TRUE
FROM diffots_ZAGIMORE.customer c, diffots_ZAGIMORE_ds.Customer_Dimension cd
WHERE c.customerid = cd.customerid
AND cd.currentstatus = 1
AND(c.customername != cd.customername OR c.customerzip != cd.customerzip);


-- Updating existing corresponding rows in the customer dimension for the instances of customer dimension that have changed attributes
-- Making old versions of the customer dimension not current

UPDATE diffots_ZAGIMORE_ds.Customer_Dimension cd, diffots_ZAGIMORE.customer c
SET cd.dvu = NOW() - INTERVAL 1 DAY,
cd.currentstatus = FALSE,
cd.cd_loaded = FALSE  
WHERE c.customerid = cd.customerid
AND (c.customername != cd.customername OR c.customerzip != cd.customerzip) 
AND cd.cd_loaded = TRUE;


-- Loading new instances of customer dimension into customer dimension table into Data Warehouse
-- Updating old instances of customer dimensions in customer dimension table that are not current anymore

REPLACE INTO diffots_ZAGIMORE_dw.Customer_Dimension(customerid, customername, customerzip, customerkey, dvu, dvf, currentstatus)
SELECT cd.customerid, cd.customername, cd.customerzip, cd.customerkey, cd.dvu, cd.dvf, cd.currentstatus
FROM diffots_ZAGIMORE_ds.Customer_Dimension cd
WHERE cd.cd_loaded = FALSE;

UPDATE diffots_ZAGIMORE_ds.Customer_Dimension
SET cd_loaded = TRUE
WHERE cd_loaded = FALSE;

END


-- END OF PROJECT