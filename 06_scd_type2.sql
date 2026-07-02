-- ==============================================================
-- 04: ETL - INCREMENTAL & LATE-ARRIVING FACT LOADS
-- Timestamp-based delta extraction + late-arriving fact handling
-- ==============================================================

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


