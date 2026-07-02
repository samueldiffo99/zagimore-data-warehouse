-- ==============================================================
-- 02: DIMENSIONAL MODEL (STAR SCHEMA)
-- Warehouse + staging DDL: Customer, Product, Store, Calendar dims
-- and the conformed Revenue Fact Table (unifies sales + rentals)
-- ==============================================================

-- DIMENSIONAL MODELING: CREATION OF DATA WAREHOUSE

CREATE TABLE Customer_Dimension
(
  customerid CHAR(7) NOT NULL,
  customername VARCHAR(15) NOT NULL,
  customerzip CHAR(5) NOT NULL,
  customerkey INT NOT NULL,
  PRIMARY KEY (customerkey)
);

CREATE TABLE Product_Dimension
(
  productkey INT NOT NULL,
  productid CHAR(3) NOT NULL,
  productname VARCHAR(25) NOT NULL,
  vendorid CHAR(2) NOT NULL,
  categoryid CHAR(2) NOT NULL,
  categoryname VARCHAR(25) NOT NULL,
  vendorname VARCHAR(25) NOT NULL,
  ProductType CHAR(1) NOT NULL,
  productsalesprice NUMERIC(7,2),
  productdailyrentalprice NUMERIC(7,2),
  productweeklyrentalprice NUMERIC(7,2),
  PRIMARY KEY (productkey)
);

CREATE TABLE Store_Dimension
(
  storekey INT NOT NULL,
  storeid VARCHAR(3) NOT NULL,
  storezip CHAR(5) NOT NULL,
  regionid CHAR(1) NOT NULL,
  regionname VARCHAR(25) NOT NULL,
  PRIMARY KEY (storekey)
);

CREATE TABLE Calendar_Dimension
(
  calendarkey INT NOT NULL,
  fulldate DATE NOT NULL,
  monthyear CHAR(6) NOT NULL,
  calendaryear CHAR(4) NOT NULL,
  PRIMARY KEY (calendarkey)
);

CREATE TABLE Revenue_Fact_Table
(
  DollarAmount NUMERIC(8,2) NOT NULL,
  tid VARCHAR(8) NOT NULL,
  revenuetype VARCHAR(20) NOT NULL,
  customerkey INT NOT NULL,
  productkey INT NOT NULL,
  storekey INT NOT NULL,
  calendarkey INT NOT NULL,
  PRIMARY KEY (customerkey, productkey, storekey, calendarkey, tid, revenuetype),
  FOREIGN KEY (customerkey) REFERENCES Customer_Dimension(customerkey),
  FOREIGN KEY (productkey) REFERENCES Product_Dimension(productkey),
  FOREIGN KEY (storekey) REFERENCES Store_Dimension(storekey),
  FOREIGN KEY (calendarkey) REFERENCES Calendar_Dimension(calendarkey)
);

-- DIMENSIONAL MODELING: CREATION OF DATA STAGING AREA

CREATE TABLE IF NOT EXISTS Customer_Dimension
(
  customerid CHAR(7) NOT NULL,
  customername VARCHAR(15) NOT NULL,
  customerzip CHAR(5) NOT NULL,
  customerkey INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (customerkey)
);

CREATE TABLE IF NOT EXISTS Product_Dimension
(
  productkey INT NOT NULL AUTO_INCREMENT,
  productid CHAR(3) NOT NULL,
  productname VARCHAR(25) NOT NULL,
  vendorid CHAR(2) NOT NULL,
  categoryid CHAR(2) NOT NULL,
  categoryname VARCHAR(25) NOT NULL,
  vendorname VARCHAR(25) NOT NULL,
  ProductType CHAR(1) NOT NULL,
  productsalesprice NUMERIC(7,2),
  productdailyrentalprice NUMERIC(7,2),
  productweeklyrentalprice NUMERIC(7,2),
  PRIMARY KEY (productkey)
);

CREATE TABLE IF NOT EXISTS Store_Dimension
(
  storekey INT NOT NULL AUTO_INCREMENT,
  storeid VARCHAR(3) NOT NULL,
  storezip CHAR(5) NOT NULL,
  regionid CHAR(1) NOT NULL,
  regionname VARCHAR(25) NOT NULL,
  PRIMARY KEY (storekey)
);

CREATE TABLE IF NOT EXISTS Calendar_Dimension
(
  calendarkey INT NOT NULL AUTO_INCREMENT,
  fulldate DATE NOT NULL,
  monthyear CHAR(6) NOT NULL,
  calendaryear CHAR(4) NOT NULL,
  PRIMARY KEY (calendarkey)
);

CREATE TABLE IF NOT EXISTS Revenue_Fact_Table
(
  DollarAmount NUMERIC(8,2) NOT NULL,
  tid VARCHAR(8) NOT NULL,
  revenuetype VARCHAR(20) NOT NULL,
  customerkey INT NOT NULL,
  productkey INT NOT NULL,
  storekey INT NOT NULL,
  calendarkey INT NOT NULL,
  PRIMARY KEY (customerkey, productkey, storekey, calendarkey, tid, revenuetype)
);


-- CREATION OF THE CALENDAR DIMENSION PROCEDURE

DELIMITER $$

CREATE PROCEDURE p()

BEGIN

  DECLARE i INT DEFAULT 1;   

myloop: LOOP

    SET i=i+1;

	SELECT CONCAT('I can count to ', i);

    IF i=10 then

            LEAVE myloop;

    END IF;

END LOOP myloop;

END;

DELIMITER $$

CREATE PROCEDURE populate_calendar()

BEGIN

  DECLARE i INT DEFAULT 0;   
  DECLARE fulldate DATE DEFAULT '2013-01-01';

myloop: LOOP

    	INSERT INTO Calendar_Dimension(fulldate) SELECT DATE_ADD(fulldate, INTERVAL i DAY);
    SET i=i+1;
    IF i=8000 then

            LEAVE myloop;

    END IF;

END LOOP myloop;

END;


DELIMITER $$

CREATE PROCEDURE update_calendar()

BEGIN

UPDATE Calendar_Dimension
SET monthyear = LPAD(CONCAT(MONTH(fulldate),YEAR(fulldate)), 6, '0'), calendaryear = YEAR(fulldate), calendarweekday = DAYNAME(fulldate);


END;


-- EXTRACTION OF DIMENSIONS

-- Code for extracting the Customer data from the source ZAGIMORE into the Customer dimension in ZAGIMORE_ds data staging.

INSERT INTO diffots_ZAGIMORE_ds.Customer_Dimension(customerid, customername, customerzip)
SELECT c.customerid, c.customername, c.customerzip
FROM diffots_ZAGIMORE.customer c;

-- Code for extracting the Store and Region data from the source ZAGIMORE into the Store dimension in ZAGIMORE_ds data staging.

INSERT INTO diffots_ZAGIMORE_ds.Store_Dimension(storeid, storezip, regionid, regionname)
SELECT s.storeid, s.storezip, s.regionid, r.regionname
FROM diffots_ZAGIMORE.store s
JOIN diffots_ZAGIMORE.region r ON s.regionid = r.regionid;

-- Code for extracting data from various tables in ZAGIMORE into the Product dimension table in ZAGIMORE_ds data staging.

-- SALES PRODUCT
SELECT p.productid, p.productname, p.vendorid, p.categoryid, c.categoryname, v.vendorname, 'S', p.productprice, NULL, NULL
FROM diffots_ZAGIMORE.product p, diffots_ZAGIMORE.vendor v, diffots_ZAGIMORE.category c
WHERE p.categoryid = c.categoryid
AND v.vendorid = p.vendorid

-- RENTAL PRODUCT
SELECT r.productid, r.productname, r.vendorid, r.categoryid, c.categoryname, v.vendorname, 'R', NULL, r.productpricedaily, r.productpriceweekly
FROM diffots_ZAGIMORE.rentalProducts r, diffots_ZAGIMORE.vendor v, diffots_ZAGIMORE.category c
WHERE r.categoryid = c.categoryid
AND v.vendorid = r.vendorid

-- UNION OF SALES PRODUCT AND RENTAL PRODUCTS
INSERT INTO diffots_ZAGIMORE_ds.Product_Dimension(productid, productname, vendorid, categoryid, categoryname, vendorname, ProductType, productsalesprice, productdailyrentalprice, productweeklyrentalprice)
SELECT r.productid, r.productname, r.vendorid, r.categoryid, c.categoryname, v.vendorname, 'R', NULL, r.productpricedaily, r.productpriceweekly
FROM diffots_ZAGIMORE.rentalProducts r, diffots_ZAGIMORE.vendor v, diffots_ZAGIMORE.category c
WHERE r.categoryid = c.categoryid
AND v.vendorid = r.vendorid
UNION
SELECT p.productid, p.productname, p.vendorid, p.categoryid, c.categoryname, v.vendorname, 'S', p.productprice, NULL, NULL
FROM diffots_ZAGIMORE.product p, diffots_ZAGIMORE.vendor v, diffots_ZAGIMORE.category c
WHERE p.categoryid = c.categoryid
AND v.vendorid = p.vendorid

-- EXTRACTING INTERMEDIATE REVENUE FACT TABLE

-- SALES REVENUE
SELECT sv.noofitems*p.productprice AS DollarAmount, sv.tid, 'Sales' AS revenuetype, st.customerid, sv.productid, st.storeid, st.tdate
FROM diffots_ZAGIMORE.product p, diffots_ZAGIMORE.soldvia sv, diffots_ZAGIMORE.salestransaction st
WHERE p.productid = sv.productid
AND sv.tid = st.tid

-- RENTAL REVENUE,DAILY RENTALS
SELECT rv.duration*rp.productpricedaily AS DollarAmount, rv.tid, 'Rental, daily' AS revenuetype, rt.customerid, rv.productid, rt.storeid, rt.tdate
FROM diffots_ZAGIMORE.rentalProducts rp, diffots_ZAGIMORE.rentvia rv, diffots_ZAGIMORE.rentaltransaction rt
WHERE rp.productid = rv.productid
AND rv.tid = rt.tid
AND rv.rentaltype = 'D'

-- RENTAL REVENUE,WEEKLY RENTALS
SELECT rv.duration*rp.productpriceweekly AS DollarAmount, rv.tid, 'Rental, weekly' AS revenuetype, rt.customerid, rv.productid, rt.storeid, rt.tdate
FROM diffots_ZAGIMORE.rentalProducts rp, diffots_ZAGIMORE.rentvia rv, diffots_ZAGIMORE.rentaltransaction rt
WHERE rp.productid = rv.productid
AND rv.tid = rt.tid
AND rv.rentaltype = 'W'


-- ALL REVENUE
CREATE TABLE IF NOT EXISTS IFT AS 
SELECT sv.noofitems*p.productprice AS DollarAmount, sv.tid, 'Sales' AS revenuetype, st.customerid, sv.productid, st.storeid, st.tdate
FROM diffots_ZAGIMORE.product p, diffots_ZAGIMORE.soldvia sv, diffots_ZAGIMORE.salestransaction st
WHERE p.productid = sv.productid
AND sv.tid = st.tid
UNION
SELECT rv.duration*rp.productpricedaily AS DollarAmount, rv.tid, 'Rental, daily' AS revenuetype, rt.customerid, rv.productid, rt.storeid, rt.tdate
FROM diffots_ZAGIMORE.rentalProducts rp, diffots_ZAGIMORE.rentvia rv, diffots_ZAGIMORE.rentaltransaction rt
WHERE rp.productid = rv.productid
AND rv.tid = rt.tid
AND rv.rentaltype = 'D'
UNION
SELECT rv.duration*rp.productpriceweekly AS DollarAmount, rv.tid, 'Rental, weekly' AS revenuetype, rt.customerid, rv.productid, rt.storeid, rt.tdate
FROM diffots_ZAGIMORE.rentalProducts rp, diffots_ZAGIMORE.rentvia rv, diffots_ZAGIMORE.rentaltransaction rt
WHERE rp.productid = rv.productid
AND rv.tid = rt.tid
AND rv.rentaltype = 'W'

-- Changing the collation of the Revenue Type column in IFT
ALTER TABLE `IFT` CHANGE `revenuetype` `revenuetype` VARCHAR(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL;

-- Populating Core Revenue Fact Table
INSERT INTO diffots_ZAGIMORE_ds.Revenue_Fact_Table(DollarAmount, tid, revenuetype, customerkey, productkey, storekey, calendarkey)
SELECT i.DollarAmount, i.tid, i.revenuetype, cu.customerkey, pd.productkey, sd.storekey, cd.calendarkey
FROM IFT i, Customer_Dimension cu, Product_Dimension pd, Store_Dimension sd, Calendar_Dimension cd
WHERE i.customerid = cu.customerid
AND i.productid = pd.productid
AND LEFT(revenuetype,1) = pd.ProductType
AND i.storeid = sd.storeid
AND i.tdate = cd.fulldate
AND cu.currentstatus = TRUE
AND pd.currentstatus = TRUE


-- LOADING INSIDE THE DATA WAREHOUSE

-- Loading Customer Dimensions into data warehouse
INSERT INTO diffots_ZAGIMORE_dw.Customer_Dimension(customerkey, customerid, customername, customerzip)
SELECT cd.customerkey, cd.customerid, cd.customername, cd.customerzip
FROM diffots_ZAGIMORE_ds.Customer_Dimension cd

-- Loading Store Dimensions into data warehouse
INSERT INTO diffots_ZAGIMORE_dw.Store_Dimension(storekey, storeid, storezip, regionid, regionname)
SELECT st.storekey, st.storeid, st.storezip, st.regionid, st.regionname
FROM diffots_ZAGIMORE_ds.Store_Dimension st

-- Loading Calendar Dimensions into data warehouse
INSERT INTO diffots_ZAGIMORE_dw.Calendar_Dimension(calendarkey, fulldate, monthyear, calendaryear)
SELECT ca.calendarkey, ca.fulldate, ca.monthyear, ca.calendaryear
FROM diffots_ZAGIMORE_ds.Calendar_Dimension ca

-- Loading Product Dimensions into data warehouse
INSERT INTO diffots_ZAGIMORE_dw.Product_Dimension(productkey, productid, productname, vendorid, categoryid, categoryname, vendorname, ProductType, productsalesprice, productdailyrentalprice, productweeklyrentalprice)
SELECT pd.productkey, pd.productid, pd.productname, pd.vendorid, pd.categoryid, pd.categoryname, pd.vendorname, pd.ProductType, pd.productsalesprice, pd.productdailyrentalprice, pd.productweeklyrentalprice
FROM diffots_ZAGIMORE_ds.Product_Dimension pd

-- Loading Revenue Fact table into data warehouse
INSERT INTO diffots_ZAGIMORE_dw.Revenue_Fact_Table(DollarAmount, tid, revenuetype, customerkey, productkey, storekey, calendarkey)
SELECT rf.DollarAmount, rf.tid, rf.revenuetype, rf.customerkey, rf.productkey, rf.storekey, rf.calendarkey
FROM diffots_ZAGIMORE_ds.Revenue_Fact_Table rf


-- AGGREGATION


-- Creating Product Category Dimension in Data Staging
SELECT DISTINCT categoryid, categoryname
FROM Product_Dimension

CREATE TABLE Category_Dimension
(categorykey INT AUTO_INCREMENT,
categoryid CHAR(2),
categoryname VARCHAR(25),
PRIMARY KEY (categorykey))

INSERT INTO diffots_ZAGIMORE_ds.Category_Dimension(categoryid, categoryname)
SELECT DISTINCT categoryid, categoryname
FROM Product_Dimension

