-- START OF PROJECT

-- CREATION OF TABLES

CREATE TABLE vendor
(vendorid CHAR(2) NOT NULL,
 vendorname VARCHAR(25) NOT NULL,
 PRIMARY KEY (vendorid));
 
CREATE TABLE category
(categoryid CHAR(2) NOT NULL,
 categoryname VARCHAR(25) NOT NULL,
 PRIMARY KEY (categoryid));
 
CREATE TABLE product
(productid CHAR(3) NOT NULL,
 productname VARCHAR(25) NOT NULL,
 productprice NUMERIC (7,2) NOT NULL,
 vendorid CHAR(2) NOT NULL,
 categoryid CHAR(2) NOT NULL,
 PRIMARY KEY (productid),
 FOREIGN KEY (vendorid)
 REFERENCES vendor(vendorid),
 FOREIGN KEY (categoryid) REFERENCES category(categoryid));
 
CREATE TABLE region
(regionid CHAR NOT NULL,
 regionname VARCHAR(25) NOT NULL,
 PRIMARY KEY (regionid));
 
CREATE TABLE store
(storeid VARCHAR(3) NOT NULL,
 storezip CHAR(5) NOT NULL,
 regionid CHAR NOT NULL,
 PRIMARY KEY (storeid),
 FOREIGN KEY (regionid) REFERENCES region(regionid));
 
CREATE TABLE customer
(customerid CHAR(7) NOT NULL,
 customername VARCHAR(15) NOT NULL,
 customerzip CHAR(5) NOT NULL,
 PRIMARY KEY (customerid));
 
CREATE TABLE salestransaction
(tid VARCHAR(8) NOT NULL,
 customerid CHAR(7) NOT NULL,
 storeid VARCHAR(3) NOT NULL,
 tdate DATE NOT NULL,
 PRIMARY KEY (tid),
 FOREIGN KEY (customerid) REFERENCES customer(customerid),
 FOREIGN KEY (storeid)REFERENCES store(storeid));
 
CREATE TABLE soldvia
(productid CHAR(3) NOT NULL,
 tid VARCHAR(8) NOT NULL,
 noofitems INT NOT NULL,
 PRIMARY KEY (productid, tid),
 FOREIGN KEY (productid) REFERENCES product(productid),
 FOREIGN KEY (tid) REFERENCES salestransaction(tid));
 
 
CREATE TABLE rentalProducts
(productid CHAR(3) NOT NULL,
 productname VARCHAR(25) NOT NULL,
 vendorid CHAR(2) NOT NULL,
 categoryid CHAR(2) NOT NULL,
 productpricedaily NUMERIC(7,2) NOT NULL,
 productpriceweekly NUMERIC(7,2) NOT NULL,
 PRIMARY KEY (productid),
 FOREIGN KEY (vendorid) REFERENCES vendor(vendorid),
 FOREIGN KEY (categoryid) REFERENCES category(categoryid));
 
 
 
CREATE TABLE rentaltransaction
(tid VARCHAR(8) NOT NULL,
 customerid CHAR(7) NOT NULL,
 storeid VARCHAR(3) NOT NULL,
 tdate DATE NOT NULL,
 PRIMARY KEY (tid),
 FOREIGN KEY (customerid) REFERENCES customer(customerid),
 FOREIGN KEY (storeid) REFERENCES store(storeid));
 
CREATE TABLE rentvia
(productid CHAR(3) NOT NULL,
 tid VARCHAR(8) NOT NULL,
 rentaltype CHAR(1) NOT NULL,
 duration INT(2) NOT NULL,
 PRIMARY KEY (productid,tid),
 FOREIGN KEY (productid) REFERENCES rentalProducts(productid),
 FOREIGN KEY (tid) REFERENCES rentaltransaction(tid));
 
 
 
INSERT INTO vendor VALUES('PG','Pacifica Gear');
INSERT INTO vendor VALUES('MK','Mountain King');
INSERT INTO vendor VALUES('OA','Outdoor Adventures');
INSERT INTO vendor VALUES('WL','Wilderness Limited');
 
INSERT INTO category VALUES('CP','Camping');
INSERT INTO category VALUES('FW','Footwear');
INSERT INTO category VALUES('CL','Climbing');
INSERT INTO category VALUES('EL','Electronics');
INSERT INTO category VALUES('CY','Cycling');
 
INSERT INTO product VALUES('1X1','Zzz Bag',100,'PG','CP');
INSERT INTO product VALUES('2X2','Easy Boot',70,'MK','FW');
INSERT INTO product VALUES('3X3','Cosy Sock',15,'MK','FW');
INSERT INTO product VALUES('4X4','Dura Boot',90,'PG','FW');
INSERT INTO product VALUES('5X5','Tiny Tent',150,'MK','CP');
INSERT INTO product VALUES('6X6','Biggy Tent',250,'MK','CP');
INSERT INTO product VALUES('7X7','Hi-Tec GPS',300,'OA','EL');
INSERT INTO product VALUES('8X8','Power Pedals',20,'MK','CY');
INSERT INTO product VALUES('9X9','Trusty Rope',30,'WL','CL');
INSERT INTO product VALUES('1X2','Comfy Harness',150,'MK','CL');
INSERT INTO product VALUES('1X3','Sunny Charger',125,'OA','EL');
INSERT INTO product VALUES('1X4','Safe-T Helmet',40,'PG','CY');
INSERT INTO product VALUES('2X1','Mmm Stove',80,'WL','CP');
INSERT INTO product VALUES('2X3','Reflect-o Jacket',35,'PG','CY');
INSERT INTO product VALUES('2X4','Strongster Carribeaner',20,'MK','CL');
INSERT INTO product VALUES('3X1','Sleepy Pad',25,'WL','CP');
INSERT INTO product VALUES('3X2','Bucky Knife',60,'WL','CP');
INSERT INTO product VALUES('3X4','Treado Tire',30,'OA','CY');
INSERT INTO product VALUES('4X1','Slicky Tire',25,'OA','CY');
INSERT INTO product VALUES('4X2','Electra Compass',45,'MK','EL');
INSERT INTO product VALUES('4X3','Mega Camera',275,'WL','EL');
INSERT INTO product VALUES('5X1','Simple Sandal',50,'PG','FW');
INSERT INTO product VALUES('5X2','Action Sandal',70,'PG','FW');
INSERT INTO product VALUES('5X3','Luxo Tent',500,'OA','CP');
 
INSERT INTO region VALUES('C','Chicagoland');
INSERT INTO region VALUES('T','Tristate');
INSERT INTO region VALUES('I','Indiana');
INSERT INTO region VALUES('N','North'); 
INSERT INTO store VALUES('S1','60600','C ');
INSERT INTO store VALUES('S2','60605','C');
INSERT INTO store VALUES('S3','35400','T');
INSERT INTO store VALUES('S4','60640','C');
INSERT INTO store VALUES('S5','46307','T');
INSERT INTO store VALUES('S6','47374','I');
INSERT INTO store VALUES('S7','47401','I');
INSERT INTO store VALUES('S8','55401','N');
INSERT INTO store VALUES('S9','54937','N');
INSERT INTO store VALUES('S10','60602','C');
INSERT INTO store VALUES('S11','46201','I');
INSERT INTO store VALUES('S12','55701','N');
INSERT INTO store VALUES('S13','60085','T');
INSERT INTO store VALUES('S14','53140','T');
 
INSERT INTO customer VALUES('1-2-333','Tina','60137');
INSERT INTO customer VALUES('2-3-444','Tony','60611');
INSERT INTO customer VALUES('3-4-555','Pam','35401');
INSERT INTO customer VALUES('4-5-666','Elly','47374');
INSERT INTO customer VALUES('5-6-777','Nora','60640');
INSERT INTO customer VALUES('6-7-888','Miles','60602');
INSERT INTO customer VALUES('7-8-999','Neil','55403');
INSERT INTO customer VALUES('8-9-000','Maggie','47401');
INSERT INTO customer VALUES('9-0-111','Ryan','46202');
INSERT INTO customer VALUES('0-1-222','Dan','55499');
 
 
INSERT INTO salestransaction VALUES ('T111','1-2-333','S1','2013-01-01');
INSERT INTO salestransaction VALUES ('T222','2-3-444','S2','2013-01-01');
INSERT INTO salestransaction VALUES ('T333','1-2-333','S3','2013-01-02');
INSERT INTO salestransaction VALUES ('T444','3-4-555','S3','2013-01-02');
INSERT INTO salestransaction VALUES ('T555','2-3-444','S3','2013-01-02');
INSERT INTO salestransaction VALUES ('T666','5-6-777','S10','2013-01-03');
INSERT INTO salestransaction VALUES ('T777','6-7-888','S13','2013-01-03');
INSERT INTO salestransaction VALUES ('T888','8-9-000','S4','2013-01-04');
INSERT INTO salestransaction VALUES ('T999','4-5-666','S6','2013-01-04');
INSERT INTO salestransaction VALUES ('T101','7-8-999','S12','2013-01-04');
INSERT INTO salestransaction VALUES ('T202','0-1-222','S8','2013-01-04');
INSERT INTO salestransaction VALUES ('T303','4-5-666','S6','2013-01-05');
INSERT INTO salestransaction VALUES ('T404','8-9-000','S6','2013-01-05');
INSERT INTO salestransaction VALUES ('T505','6-7-888','S14','2013-01-05');
INSERT INTO salestransaction VALUES ('T606','0-1-222','S11','2013-01-06');
INSERT INTO salestransaction VALUES ('T707','5-6-777','S4','2013-01-06');
INSERT INTO salestransaction VALUES ('T808','7-8-999','S9','2013-01-06');
INSERT INTO salestransaction VALUES ('T909','5-6-777','S4','2013-01-06');
INSERT INTO salestransaction VALUES ('T011','8-9-000','S7','2013-01-07');
INSERT INTO salestransaction VALUES ('T022','9-0-111','S5','2013-01-07');
 
INSERT INTO soldvia VALUES('1X1','T111',1);
INSERT INTO soldvia VALUES('2X2','T222',1);
INSERT INTO soldvia VALUES('3X3','T333',5);
INSERT INTO soldvia VALUES('1X1','T333',1);
INSERT INTO soldvia VALUES('4X4','T444',1);
INSERT INTO soldvia VALUES('2X2','T444',2);
INSERT INTO soldvia VALUES('4X4','T555',4);
INSERT INTO soldvia VALUES('5X5','T555',2);
INSERT INTO soldvia VALUES('6X6','T555',1);
INSERT INTO soldvia VALUES('7X7','T666',1);
INSERT INTO soldvia VALUES('9X9','T666',1);
INSERT INTO soldvia VALUES('1X3','T666',2);
INSERT INTO soldvia VALUES('8X8','T777',1);
INSERT INTO soldvia VALUES('1X4','T888',4);
INSERT INTO soldvia VALUES('2X3','T888',3);
INSERT INTO soldvia VALUES('9X9','T999',1);
INSERT INTO soldvia VALUES('1X2','T999',5);
INSERT INTO soldvia VALUES('8X8','T999',3);
INSERT INTO soldvia VALUES('1X3','T999',1);
INSERT INTO soldvia VALUES('1X2','T101',3);
INSERT INTO soldvia VALUES('1X4','T101',1);
INSERT INTO soldvia VALUES('2X4','T202',4);
INSERT INTO soldvia VALUES('9X9','T303',3);
INSERT INTO soldvia VALUES('1X4','T303',2);
INSERT INTO soldvia VALUES('2X1','T303',2);
INSERT INTO soldvia VALUES('3X1','T303',2);
INSERT INTO soldvia VALUES('2X4','T404',1);
INSERT INTO soldvia VALUES('2X3','T404',2);
INSERT INTO soldvia VALUES('2X2','T505',3);
INSERT INTO soldvia VALUES('3X2','T505',1);
INSERT INTO soldvia VALUES('2X1','T505',4);
INSERT INTO soldvia VALUES('2X4','T606',7);
INSERT INTO soldvia VALUES('3X1','T606',4);
INSERT INTO soldvia VALUES('2X2','T606',3);
INSERT INTO soldvia VALUES('3X4','T606',2);
INSERT INTO soldvia VALUES('4X4','T606',2);
INSERT INTO soldvia VALUES('3X2','T707',1);
INSERT INTO soldvia VALUES('3X4','T707',4);
INSERT INTO soldvia VALUES('4X1','T707',2);
INSERT INTO soldvia VALUES('5X3','T808',1);
INSERT INTO soldvia VALUES('4X2','T808',1);
INSERT INTO soldvia VALUES('2X2','T808',1);
INSERT INTO soldvia VALUES('4X3','T808',1);
INSERT INTO soldvia VALUES('3X3','T808',4);
INSERT INTO soldvia VALUES('4X2','T909',3);
INSERT INTO soldvia VALUES('6X6','T909',1);
INSERT INTO soldvia VALUES('3X3','T011',3);
INSERT INTO soldvia VALUES('4X3','T022',3);
INSERT INTO soldvia VALUES('2X2','T022',3);
INSERT INTO soldvia VALUES('5X1','T022',2);
 
INSERT INTO rentalProducts(productid, productname, productpricedaily, productpriceweekly, vendorid, categoryid) VALUES ('5X5','Tiny Tent',15, 50,'MK','CP');
INSERT INTO rentalProducts(productid, productname, productpricedaily, productpriceweekly, vendorid, categoryid) VALUES ('7X7','Hi-Tec GPS',20, 80,'OA','EL');
 
INSERT INTO rentaltransaction(tid, customerid, storeid, tdate) VALUES('123','0-1-222','S1','2019-01-16');
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('5X5','123','D',2);
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('7X7','123','D',2);
 
INSERT INTO rentaltransaction(tid, customerid, storeid, tdate) VALUES('456','1-2-333','S10','2019-01-16');
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('5X5','456','W',1);
 
INSERT INTO rentalProducts(productid, productname, productpricedaily, productpriceweekly, vendorid, categoryid) VALUES ('1X1','Zzz Bag',10, 60,'MK','CL');
INSERT INTO rentalProducts(productid, productname, productpricedaily, productpriceweekly, vendorid, categoryid) VALUES ('2X2','Easy Boot',18, 75,'OA','FW');
INSERT INTO rentalProducts(productid, productname, productpricedaily, productpriceweekly, vendorid, categoryid) VALUES ('3X3','Cosy Sock',5, 25,'PG','FW');
INSERT INTO rentalProducts(productid, productname, productpricedaily, productpriceweekly, vendorid, categoryid) VALUES ('4X4','Dura Boot',25, 120,'WL','FW');
 
INSERT INTO rentaltransaction(tid, customerid, storeid, tdate) VALUES('231','2-3-444','S11','2020-01-01');
INSERT INTO rentaltransaction(tid, customerid, storeid, tdate) VALUES('312','3-4-555','S12','2019-12-21');
INSERT INTO rentaltransaction(tid, customerid, storeid, tdate) VALUES('321','4-5-666','S3','2019-11-28');
INSERT INTO rentaltransaction(tid, customerid, storeid, tdate) VALUES('564','5-6-777','S2','2019-10-07');
INSERT INTO rentaltransaction(tid, customerid, storeid, tdate) VALUES('645','6-7-888','S7','2019-09-16');
 
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('4X4','231','W',2);
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('4X4','312','D',3);
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('2X2','564','D',5);
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('1X1','564','W',4);
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('1X1','456','D',6);
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('7X7','231','D',1);
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('2X2','645','W',3);
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('5X5','645','D',5);
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('2X2','321','D',3);
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('4X4','321','D',3);
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('3X3','312','W',1);
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('1X1','312','D',5);
INSERT INTO rentvia(productid, tid, rentaltype, duration) VALUES ('7X7','312','D',5);



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


-- CREATION OF DAILY FACT REFRESH PROCEDURE

-- Adding two new columns to the data staging area
ALTER TABLE diffots_ZAGIMORE_ds.Revenue_Fact_Table
ADD ExtractionTimeStamp timestamp,
ADD f_loaded boolean

UPDATE Revenue_Fact_Table
SET ExtractionTimeStamp = NOW() - INTERVAL 14 DAY

UPDATE Revenue_Fact_Table
SET f_loaded = TRUE

-- DAILY FACT REFRESH 

DROP TABLE IF EXISTS IFT;

CREATE TABLE IFT AS 
SELECT sv.noofitems*p.productprice AS DollarAmount, sv.tid, 'Sales' AS revenuetype, st.customerid, sv.productid, st.storeid, st.tdate
FROM diffots_ZAGIMORE.product p, diffots_ZAGIMORE.soldvia sv, diffots_ZAGIMORE.salestransaction st
WHERE p.productid = sv.productid
AND sv.tid = st.tid
AND st.tdate > (SELECT MAX(ExtractionTimeStamp) FROM Revenue_Fact_Table)

UNION
SELECT rv.duration*rp.productpricedaily AS DollarAmount, rv.tid, 'Rental, daily' AS revenuetype, rt.customerid, rv.productid, rt.storeid, rt.tdate
FROM diffots_ZAGIMORE.rentalProducts rp, diffots_ZAGIMORE.rentvia rv, diffots_ZAGIMORE.rentaltransaction rt
WHERE rp.productid = rv.productid
AND rv.tid = rt.tid
AND rv.rentaltype = 'D'
AND rt.tdate > (SELECT MAX(ExtractionTimeStamp) FROM Revenue_Fact_Table)

UNION
SELECT rv.duration*rp.productpriceweekly AS DollarAmount, rv.tid, 'Rental, weekly' AS revenuetype, rt.customerid, rv.productid, rt.storeid, rt.tdate
FROM diffots_ZAGIMORE.rentalProducts rp, diffots_ZAGIMORE.rentvia rv, diffots_ZAGIMORE.rentaltransaction rt
WHERE rp.productid = rv.productid
AND rv.tid = rt.tid
AND rv.rentaltype = 'W'
AND rt.tdate > (SELECT MAX(ExtractionTimeStamp) FROM Revenue_Fact_Table);


-- Changing the collation of the Revenue Type column in IFT
ALTER TABLE `IFT` CHANGE `revenuetype` `revenuetype` VARCHAR(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL;

-- Populating Core Revenue Fact Table in Data Staging
INSERT INTO diffots_ZAGIMORE_ds.Revenue_Fact_Table(DollarAmount, tid, revenuetype, customerkey, productkey, storekey, calendarkey, ExtractionTimeStamp, f_loaded)
SELECT i.DollarAmount, i.tid, i.revenuetype, cu.customerkey, pd.productkey, sd.storekey, cd.calendarkey, NOW(), FALSE
FROM IFT i, Customer_Dimension cu, Product_Dimension pd, Store_Dimension sd, Calendar_Dimension cd
WHERE i.customerid = cu.customerid
AND i.productid = pd.productid
AND LEFT(revenuetype,1) = pd.ProductType
AND i.storeid = sd.storeid
AND i.tdate = cd.fulldate


-- Loading Revenue Fact table from Data Staging into data warehouse
INSERT INTO diffots_ZAGIMORE_dw.Revenue_Fact_Table(DollarAmount, tid, revenuetype, customerkey, productkey, storekey, calendarkey)
SELECT rf.DollarAmount, rf.tid, rf.revenuetype, rf.customerkey, rf.productkey, rf.storekey, rf.calendarkey
FROM diffots_ZAGIMORE_ds.Revenue_Fact_Table rf
WHERE f_loaded = FALSE

UPDATE diffots_ZAGIMORE_ds.Revenue_Fact_Table
SET f_loaded = TRUE
WHERE f_loaded = FALSE

-- Creating a Daily Fact Refresh Procedure
CREATE PROCEDURE DailyFactRefresh()
BEGIN
DROP TABLE IF EXISTS IFT;

CREATE TABLE IFT AS
SELECT sv.noofitems*p.productprice AS DollarAmount, sv.tid, 'Sales' AS revenuetype, st.customerid, sv.productid, st.storeid, st.tdate
FROM diffots_ZAGIMORE.product p, diffots_ZAGIMORE.soldvia sv, diffots_ZAGIMORE.salestransaction st
WHERE p.productid = sv.productid
AND sv.tid = st.tid
AND st.tdate > (SELECT MAX(ExtractionTimeStamp) FROM Revenue_Fact_Table)
UNION
SELECT rv.duration*rp.productpricedaily AS DollarAmount, rv.tid, 'Rental, daily' AS revenuetype, rt.customerid, rv.productid, rt.storeid, rt.tdate
FROM diffots_ZAGIMORE.rentalProducts rp, diffots_ZAGIMORE.rentvia rv, diffots_ZAGIMORE.rentaltransaction rt
WHERE rp.productid = rv.productid
AND rv.tid = rt.tid
AND rv.rentaltype = 'D'
AND rt.tdate > (SELECT MAX(ExtractionTimeStamp) FROM Revenue_Fact_Table)
UNION
SELECT rv.duration*rp.productpriceweekly AS DollarAmount, rv.tid, 'Rental, weekly' AS revenuetype, rt.customerid, rv.productid, rt.storeid, rt.tdate
FROM diffots_ZAGIMORE.rentalProducts rp, diffots_ZAGIMORE.rentvia rv, diffots_ZAGIMORE.rentaltransaction rt
WHERE rp.productid = rv.productid
AND rv.tid = rt.tid
AND rv.rentaltype = 'W'
AND rt.tdate > (SELECT MAX(ExtractionTimeStamp) FROM Revenue_Fact_Table);

-- Changing the collation of the Revenue Type column in IFT
ALTER TABLE `IFT` CHANGE `revenuetype` `revenuetype` VARCHAR(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL;

-- Populating Core Revenue Fact Table in Data Staging
INSERT INTO diffots_ZAGIMORE_ds.Revenue_Fact_Table(DollarAmount, tid, revenuetype, customerkey, productkey, storekey, calendarkey, ExtractionTimeStamp, f_loaded)
SELECT i.DollarAmount, i.tid, i.revenuetype, cu.customerkey, pd.productkey, sd.storekey, cd.calendarkey, NOW(), FALSE
FROM IFT i, Customer_Dimension cu, Product_Dimension pd, Store_Dimension sd, Calendar_Dimension cd
WHERE i.customerid = cu.customerid
AND i.productid = pd.productid
AND LEFT(revenuetype,1) = pd.ProductType
AND i.storeid = sd.storeid
AND i.tdate = cd.fulldate
AND cu.currentstatus = TRUE
AND pd.currentstatus = TRUE;

-- Loading Revenue Fact table from Data Staging into data warehouse
INSERT INTO diffots_ZAGIMORE_dw.Revenue_Fact_Table(DollarAmount, tid, revenuetype, customerkey, productkey, storekey, calendarkey)
SELECT rf.DollarAmount, rf.tid, rf.revenuetype, rf.customerkey, rf.productkey, rf.storekey, rf.calendarkey
FROM diffots_ZAGIMORE_ds.Revenue_Fact_Table rf
WHERE f_loaded = FALSE;

UPDATE diffots_ZAGIMORE_ds.Revenue_Fact_Table
SET f_loaded = TRUE
WHERE f_loaded = FALSE;
END;

-- Testing the procedure
INSERT INTO `salestransaction` (`tid`, `customerid`, `storeid`, `tdate`) VALUES ('BBB', '3-4-555', 'S2', '2026-03-31');
INSERT INTO `soldvia` (`productid`, `tid`, `noofitems`) VALUES ('3X1', 'BBB', '2');
INSERT INTO `soldvia` (`productid`, `tid`, `noofitems`) VALUES ('2X4', 'BBB', '1');
INSERT INTO `rentaltransaction` (`tid`, `customerid`, `storeid`, `tdate`) VALUES ('CCC', '1-2-333', 'S7', '2026-03-31');
INSERT INTO `rentvia` (`productid`, `tid`, `rentaltype`, `duration`) VALUES ('2X2', 'CCC', 'D', '5');
INSERT INTO `rentvia` (`productid`, `tid`, `rentaltype`, `duration`) VALUES ('4X4', 'CCC', 'W', '7');
INSERT INTO `salestransaction` (`tid`, `customerid`, `storeid`, `tdate`) VALUES ('FFF', '3-4-555', 'S2', '2026-04-01');
INSERT INTO `soldvia` (`productid`, `tid`, `noofitems`) VALUES ('3X1', 'FFF', '2');
INSERT INTO `soldvia` (`productid`, `tid`, `noofitems`) VALUES ('2X4', 'FFF', '1');
INSERT INTO `rentaltransaction` (`tid`, `customerid`, `storeid`, `tdate`) VALUES ('GGG', '1-2-333', 'S7', '2026-04-01');
INSERT INTO `rentvia` (`productid`, `tid`, `rentaltype`, `duration`) VALUES ('2X2', 'GGG', 'D', '5');
INSERT INTO `rentvia` (`productid`, `tid`, `rentaltype`, `duration`) VALUES ('4X4', 'GGG', 'W', '7');

CALL DailyFactRefresh()


-- CREATION OF LATE ARRIVING FACTS REFRESH PROCEDURE

SELECT sv.noofitems*p.productprice AS DollarAmount, sv.tid, 'Sales' AS revenuetype, st.customerid, sv.productid, st.storeid, st.tdate
FROM diffots_ZAGIMORE.product p, diffots_ZAGIMORE.soldvia sv, diffots_ZAGIMORE.salestransaction st
WHERE p.productid = sv.productid
AND sv.tid = st.tid
AND st.tid NOT IN (SELECT DISTINCT tid FROM Revenue_Fact_Table)
UNION
SELECT rv.duration*rp.productpricedaily AS DollarAmount, rv.tid, 'Rental, daily' AS revenuetype, rt.customerid, rv.productid, rt.storeid, rt.tdate
FROM diffots_ZAGIMORE.rentalProducts rp, diffots_ZAGIMORE.rentvia rv, diffots_ZAGIMORE.rentaltransaction rt
WHERE rp.productid = rv.productid
AND rv.tid = rt.tid
AND rv.rentaltype = 'D'
AND rt.tid NOT IN (SELECT DISTINCT tid FROM Revenue_Fact_Table)
UNION
SELECT rv.duration*rp.productpriceweekly AS DollarAmount, rv.tid, 'Rental, weekly' AS revenuetype, rt.customerid, rv.productid, rt.storeid, rt.tdate
FROM diffots_ZAGIMORE.rentalProducts rp, diffots_ZAGIMORE.rentvia rv, diffots_ZAGIMORE.rentaltransaction rt
WHERE rp.productid = rv.productid
AND rv.tid = rt.tid
AND rv.rentaltype = 'W'
AND rt.tid NOT IN (SELECT DISTINCT tid FROM Revenue_Fact_Table);


-- Creation of Procedure for Late Arriving Facts
CREATE PROCEDURE LateArrivingFactRefresh()
BEGIN
DROP TABLE IF EXISTS IFT;

CREATE TABLE IFT AS
SELECT sv.noofitems*p.productprice AS DollarAmount, sv.tid, 'Sales' AS revenuetype, st.customerid, sv.productid, st.storeid, st.tdate
FROM diffots_ZAGIMORE.product p, diffots_ZAGIMORE.soldvia sv, diffots_ZAGIMORE.salestransaction st
WHERE p.productid = sv.productid
AND sv.tid = st.tid
AND st.tid NOT IN (SELECT DISTINCT tid FROM Revenue_Fact_Table)
UNION
SELECT rv.duration*rp.productpricedaily AS DollarAmount, rv.tid, 'Rental, daily' AS revenuetype, rt.customerid, rv.productid, rt.storeid, rt.tdate
FROM diffots_ZAGIMORE.rentalProducts rp, diffots_ZAGIMORE.rentvia rv, diffots_ZAGIMORE.rentaltransaction rt
WHERE rp.productid = rv.productid
AND rv.tid = rt.tid
AND rv.rentaltype = 'D'
AND rt.tid NOT IN (SELECT DISTINCT tid FROM Revenue_Fact_Table)
UNION
SELECT rv.duration*rp.productpriceweekly AS DollarAmount, rv.tid, 'Rental, weekly' AS revenuetype, rt.customerid, rv.productid, rt.storeid, rt.tdate
FROM diffots_ZAGIMORE.rentalProducts rp, diffots_ZAGIMORE.rentvia rv, diffots_ZAGIMORE.rentaltransaction rt
WHERE rp.productid = rv.productid
AND rv.tid = rt.tid
AND rv.rentaltype = 'W'
AND rt.tid NOT IN (SELECT DISTINCT tid FROM Revenue_Fact_Table);

-- Changing the collation of the Revenue Type column in IFT
ALTER TABLE `IFT` CHANGE `revenuetype` `revenuetype` VARCHAR(14) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL;

-- Populating Core Revenue Fact Table in Data Staging
INSERT INTO diffots_ZAGIMORE_ds.Revenue_Fact_Table(DollarAmount, tid, revenuetype, customerkey, productkey, storekey, calendarkey, ExtractionTimeStamp, f_loaded)
SELECT i.DollarAmount, i.tid, i.revenuetype, cu.customerkey, pd.productkey, sd.storekey, cd.calendarkey, NOW(), FALSE
FROM IFT i, Customer_Dimension cu, Product_Dimension pd, Store_Dimension sd, Calendar_Dimension cd
WHERE i.customerid = cu.customerid
AND i.productid = pd.productid
AND LEFT(revenuetype,1) = pd.ProductType
AND i.storeid = sd.storeid
AND i.tdate = cd.fulldate
AND pd.currentstatus = TRUE
AND cu.currentstatus = TRUE;


-- Loading Revenue Fact table from Data Staging into data warehouse
INSERT INTO diffots_ZAGIMORE_dw.Revenue_Fact_Table(DollarAmount, tid, revenuetype, customerkey, productkey, storekey, calendarkey)
SELECT rf.DollarAmount, rf.tid, rf.revenuetype, rf.customerkey, rf.productkey, rf.storekey, rf.calendarkey
FROM diffots_ZAGIMORE_ds.Revenue_Fact_Table rf
WHERE f_loaded = FALSE;

UPDATE diffots_ZAGIMORE_ds.Revenue_Fact_Table
SET f_loaded = TRUE
WHERE f_loaded = FALSE;
END;

-- Testing the procedure
INSERT INTO `salestransaction` (`tid`, `customerid`, `storeid`, `tdate`) VALUES ('LLL', '3-4-555', 'S4', '2026-03-28');
INSERT INTO `soldvia` (`productid`, `tid`, `noofitems`) VALUES ('3X1', 'LLL', '2');
INSERT INTO `salestransaction` (`tid`, `customerid`, `storeid`, `tdate`) VALUES ('NFL', '3-4-555', 'S2', '2026-03-15');
INSERT INTO `soldvia` (`productid`, `tid`, `noofitems`) VALUES ('3X1', 'NFL', '2');
INSERT INTO `soldvia` (`productid`, `tid`, `noofitems`) VALUES ('2X4', 'NFL', '1');
INSERT INTO `rentaltransaction` (`tid`, `customerid`, `storeid`, `tdate`) VALUES ('NBA', '1-2-333', 'S7', '2026-03-17');
INSERT INTO `rentvia` (`productid`, `tid`, `rentaltype`, `duration`) VALUES ('2X2', 'NBA', 'D', '5');
INSERT INTO `rentvia` (`productid`, `tid`, `rentaltype`, `duration`) VALUES ('4X4', 'NBA', 'W', '7');
INSERT INTO `salestransaction` (`tid`, `customerid`, `storeid`, `tdate`) VALUES ('LIV', '3-4-555', 'S2', '2026-03-15');
INSERT INTO `soldvia` (`productid`, `tid`, `noofitems`) VALUES ('3X1', 'LIV', '2');
INSERT INTO `soldvia` (`productid`, `tid`, `noofitems`) VALUES ('2X4', 'LIV', '1');
INSERT INTO `rentaltransaction` (`tid`, `customerid`, `storeid`, `tdate`) VALUES ('ARS', '1-2-333', 'S7', '2026-03-17');
INSERT INTO `rentvia` (`productid`, `tid`, `rentaltype`, `duration`) VALUES ('2X2', 'ARS', 'D', '5');
INSERT INTO `rentvia` (`productid`, `tid`, `rentaltype`, `duration`) VALUES ('4X4', 'ARS', 'W', '7');

-- Checking for the accuracy of Fact Refresh
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
FROM diffots_ZAGIMORE_dw.Revenue_Fact_Table


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