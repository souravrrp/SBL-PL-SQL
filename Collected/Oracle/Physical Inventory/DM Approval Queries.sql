--Approval Status Check of a Shop
select a.approve_status
  from IFSAPP.SBL_SHOP_ARRPOVE_TBL a
 WHERE a.shop_code = '&Shop_Code'

--Short/Over List of a Shop
SELECT v.site,
       v.PRODUCT_CATEGORY,
       v.catalog_no,
       v.qty_short_over,
       v.remarks
  FROM IFSAPP.SBL_PHYSICAL_INVENTORY_STATUS v
 WHERE v.qty_short_over != 0
   and v.site LIKE '&Shop_Code'

--Approver List Table
/*CREATE TABLE SBL_PI_SO_APPROVER
AS (select U.USER_ID, U.PASS, U.SITE, U.COUNT_YEAR
  from SBL_USER_LIST U
 WHERE U.USER_ID = 'E10206');*/

--Added Columns SETTLEMENT_DEADLINE, APPROVER_COMMENT IN THE TABLE SBL_INVENTORY_COUNTING_DTS
--Added Column APPR_COMMENT, COMMENT_DATE IN THE TABLE SBL_SHOP_ARRPOVE_TBL
