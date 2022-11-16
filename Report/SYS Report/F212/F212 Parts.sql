/* Formatted on 9/5/2022 9:27:42 AM (QP5 v5.381) */
----------------------------------Receipt Summary-------------------------------

  SELECT HRIT.RSL_ITEM_DESCRIPTION, SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         AND rsl_item_type = 'RECEIPT'
         AND rsl_item_category = 'DOWNINSTALL'
         AND CONTRACT = 'DUTB'
         --AND RSL_ITEM_DESCRIPTION LIKE '%Penelty%'
         AND SEQUENCE_NO = 'DUTRSL-741'
GROUP BY HRIT.RSL_ITEM_DESCRIPTION;


----------------------------------Receipt Summary(Cash Sales)-------------------

  SELECT HRIT.RSL_ITEM_DESCRIPTION, SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         AND rsl_item_category = 'CASHSALES'
         AND rsl_item_id = 'CASHSALES'
         AND CONTRACT = 'DUTB'
         --AND RSL_ITEM_DESCRIPTION LIKE '%Penelty%'
         AND SEQUENCE_NO = 'DUTRSL-741'
GROUP BY HRIT.RSL_ITEM_DESCRIPTION;

----------------------------------Receipt Summary(Sales Return)-----------------

  SELECT HRIT.RSL_ITEM_DESCRIPTION, SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         AND rsl_item_category = 'SALESRETURN'
         AND rsl_item_type = 'RECEIPT'
         AND CONTRACT = 'DUTB'
         --AND RSL_ITEM_DESCRIPTION LIKE '%Penelty%'
         AND SEQUENCE_NO = 'DUTRSL-741'
GROUP BY HRIT.RSL_ITEM_DESCRIPTION;

----------------------------------Receipt Summary(HP Penalty)-------------------

  SELECT HRIT.RSL_ITEM_DESCRIPTION, SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         AND rsl_item_category = 'PENALTY'
         AND rsl_item_type = 'RECEIPT'
         AND CONTRACT = 'DUTB'
         --AND RSL_ITEM_DESCRIPTION LIKE '%Penelty%'
         AND SEQUENCE_NO = 'DUTRSL-741'
GROUP BY HRIT.RSL_ITEM_DESCRIPTION;

----------------------------------Receipt Summary(Cash Penalty)-----------------

  SELECT HRIT.RSL_ITEM_DESCRIPTION, SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         AND rsl_item_category = 'CASHPENALTY'
         AND rsl_item_type = 'RECEIPT'
         AND CONTRACT = 'DUTB'
         --AND RSL_ITEM_DESCRIPTION LIKE '%Penelty%'
         AND SEQUENCE_NO = 'DUTRSL-741'
GROUP BY HRIT.RSL_ITEM_DESCRIPTION;

----------------------------------Receipt Summary(First payment unpaid amount)--

  SELECT HRIT.RSL_ITEM_DESCRIPTION, SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         AND rsl_item_category = 'FIRSTDUE'
         AND rsl_item_type = 'FIRSTDUE'
         AND CONTRACT = 'DUTB'
         --AND RSL_ITEM_DESCRIPTION LIKE '%Penelty%'
         AND SEQUENCE_NO = 'DUTRSL-741'
GROUP BY HRIT.RSL_ITEM_DESCRIPTION;

----------------------------------EXPENSE SUMMARY-------------------------------

  SELECT HRIT.RSL_ITEM_DESCRIPTION, SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         AND rsl_item_category = 'EXPENSE'
         AND CONTRACT = 'DUTB'
         --AND RSL_ITEM_DESCRIPTION LIKE '%Shop%'
         AND SEQUENCE_NO = 'DUTRSL-741'
GROUP BY HRIT.RSL_ITEM_DESCRIPTION;

----------------------------------REMITTANCE SUMMARY(ADD)-----------------------

  SELECT HRIT.RSL_ITEM_DESCRIPTION, SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         AND rsl_item_category = 'REMITTANCESUMMARY'
         AND rsl_item_type = 'RECEIPT'
         AND CONTRACT = 'DUTB'
         --AND RSL_ITEM_DESCRIPTION LIKE '%Neg%'
         AND SEQUENCE_NO = 'DUTRSL-741'
GROUP BY HRIT.RSL_ITEM_DESCRIPTION;

----------------------------------REMITTANCE SUMMARY(LESS)-----------------------

  SELECT HRIT.RSL_ITEM_DESCRIPTION, SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         AND rsl_item_category = 'REMITTANCESUMMARY'
         AND rsl_item_type = 'EXPENSE'
         AND CONTRACT = 'DUTB'
         --AND RSL_ITEM_DESCRIPTION LIKE '%Penelty%'
         AND SEQUENCE_NO = 'DUTRSL-741'
GROUP BY HRIT.RSL_ITEM_DESCRIPTION;

------------------------------------No Of Docs(Banking)-------------------------

  SELECT HRIT.RSL_ITEM_DESCRIPTION, SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         AND rsl_item_category = 'DOCCUMENTSUMMARY'
         AND rsl_item_type = 'RECEIPT'
         AND CONTRACT = 'DUTB'
         --AND RSL_ITEM_DESCRIPTION LIKE '%Penelty%'
         AND SEQUENCE_NO = 'DUTRSL-741'
GROUP BY HRIT.RSL_ITEM_DESCRIPTION;


--------------------------------------Credit Sales------------------------------

  SELECT HRIT.RSL_ITEM_DESCRIPTION, SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         AND rsl_item_category = 'CREDITSALEADJUSTMENT'
         AND rsl_item_type = 'EXPENSE'
         AND CONTRACT = 'DUTB'
         --AND RSL_ITEM_DESCRIPTION LIKE '%Penelty%'
         AND SEQUENCE_NO = 'DUTRSL-741'
GROUP BY HRIT.RSL_ITEM_DESCRIPTION;

--------------------------------------ADVANCE REMITTANCE-212A DETAILS-----------

  SELECT HRIT.RSL_ITEM_DESCRIPTION, SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         AND rsl_item_type = 'RECEIPT'
         AND rsl_item_category = '212A'
         AND CONTRACT = 'DUTB'
         --AND RSL_ITEM_DESCRIPTION LIKE '%Penelty%'
         AND SEQUENCE_NO = 'DUTRSL-741'
GROUP BY HRIT.RSL_ITEM_DESCRIPTION;

--------------------------------------------------------------------------------Checking

SELECT HRIT.*
--SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         AND CONTRACT = 'DUTB'
         --AND RSL_ITEM_DESCRIPTION LIKE '%Negative Commissions%'
         AND SEQUENCE_NO = 'DUTRSL-741'
--GROUP BY HRIT.RSL_ITEM_DESCRIPTION
;


--------------------------------------------------------------------------------NO-Data

  SELECT HRIT.RSL_ITEM_DESCRIPTION, SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         AND rsl_item_type = 'RECEIPT'
         AND rsl_item_category = 'EANCATEGORY'
         AND CONTRACT = 'DUTB'
         --AND RSL_ITEM_DESCRIPTION LIKE '%Penelty%'
         AND SEQUENCE_NO = 'DUTRSL-741'
GROUP BY HRIT.RSL_ITEM_DESCRIPTION;

  SELECT HRIT.RSL_ITEM_TYPE,HRIT.RSL_ITEM_CATEGORY,HRIT.RSL_ITEM_DESCRIPTION, SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         --AND rsl_item_category = 'DOWNINSTALL'
         AND upper(RSL_ITEM_DESCRIPTION) LIKE upper('%adjust%')
         AND CONTRACT = 'DUTB'
         AND SEQUENCE_NO = 'DUTRSL-741'
GROUP BY HRIT.RSL_ITEM_TYPE,HRIT.RSL_ITEM_CATEGORY,HRIT.RSL_ITEM_DESCRIPTION;

  SELECT HRIT.RSL_ITEM_DESCRIPTION, SUM (HRIT.AMOUNT) VAL_AMOUNT
    FROM hpnret_rsl_item_tab HRIT
   WHERE     1 = 1
         AND rsl_item_category = 'UNPAIDACCOUNTS'
         AND rsl_item_type = 'UNPAIDACCOUNTS'
         AND CONTRACT = 'DUTB'
         --AND RSL_ITEM_DESCRIPTION LIKE '%Penelty%'
         AND SEQUENCE_NO = 'DUTRSL-741'
GROUP BY HRIT.RSL_ITEM_DESCRIPTION;