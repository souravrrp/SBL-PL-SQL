/* Formatted on 6/22/2021 5:23:14 PM (QP5 v5.287) */
SELECT ICRM.SET_OF_BOOKS_ID,
       ICRM.ORGANIZATION_ID,
       ICRM.ORGANIZATION_NAME,
       ICRM.TR_TYPE,
       ICRM.TRANSACTION_ID,
       ICRM.TRANSACTION_DATE,
       ICRM.MO_NO,
       ICRM.ITEM_CODE,
       ICRM.ITEM_DESCRIPTION,
       ICRM.UOM,
       ICRM.ITEM_CATEGORY,
       ICRM.ITEM_TYPE,
       ICRM.USE_AREA,
       ICRM.LOCATION_DESC,
       ICRM.PRODUCT_LINE_DESC,
       ICRM.COST_CENTER_DESC,
       ICRM.NATURAL_ACCOUNT_DESC,
       ICRM.SUB_ACCCOUNT_DESC,
       ICRM.INTER_COMPANY,
       ICRM.EXP_CATEGORY_DESC,
       ICRM.CODE_COMBINATION,
       ICRM.QTY,
       ICRM.UNIT_COST,
       ICRM.TOTAL_COST,
       ICRM.BUYER_NAME,
       ICRM.CUSTOMER_NAME,
       ICRM.CREATED_BY,
       NULL DEPARTMENT,
       NULL ASSET_DESCRIPTION,
       ICRM.NATURAL_ACC,
       ICRM.COMPANY_CODE
  FROM APPS.XXDBL_INV_CON_RPT_MVIEW ICRM
 WHERE     (   :P_SET_OF_BOOKS_ID IS NULL
            OR ICRM.SET_OF_BOOKS_ID = :P_SET_OF_BOOKS_ID)
       AND ( :P_COMPANY IS NULL OR ICRM.COMPANY_CODE = :P_COMPANY)
       AND ( :P_ORG_ID IS NULL OR ICRM.ORGANIZATION_ID = :P_ORG_ID)
       AND ( :P_ACCOUNT IS NULL OR ICRM.NATURAL_ACC = :P_ACCOUNT)
       AND :P_REPORT_TYPE = 'Rawdata'
       AND TRUNC (ICRM.TRANSACTION_DATE) BETWEEN :P_DATE_FROM AND :P_DATE_TO;