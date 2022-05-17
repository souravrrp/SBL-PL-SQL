/* Formatted on 6/6/2021 12:10:52 PM (QP5 v5.287) */
CREATE MATERIALIZED VIEW APPS.XXDBL_INV_CON_REPORT_MV
(
   TRANSACTION_ID,
   ITEM_CODE,
   ITEM_DESCRIPTION,
   UOM,
   ITEM_CATEGORY,
   ITEM_TYPE,
   TRX_QUANTITY
)
   TABLESPACE APPS_TS_SUMMARY
   PCTUSED 0
   PCTFREE 10
   INITRANS 10
   MAXTRANS 255
   STORAGE (INITIAL 16 K
            NEXT 64 K
            MAXSIZE UNLIMITED
            MINEXTENTS 1
            MAXEXTENTS UNLIMITED
            PCTINCREASE 0
            BUFFER_POOL DEFAULT
            FLASH_CACHE DEFAULT
            CELL_FLASH_CACHE DEFAULT)
   NOCACHE
   LOGGING
   NOCOMPRESS
   NOPARALLEL
   BUILD DEFERRED
   USING INDEX
      TABLESPACE APPS_TS_SUMMARY
      PCTFREE 10
      INITRANS 11
      MAXTRANS 255
      STORAGE (INITIAL 16 K
               NEXT 64 K
               MINEXTENTS 1
               MAXEXTENTS UNLIMITED
               PCTINCREASE 0
               BUFFER_POOL DEFAULT
               FLASH_CACHE DEFAULT
               CELL_FLASH_CACHE DEFAULT)
   REFRESH
      FORCE
      ON DEMAND
      WITH PRIMARY KEY
AS
   SELECT "ICRM"."TRANSACTION_ID" "TRANSACTION_ID",
          "ICRM"."ITEM_CODE" "ITEM_CODE",
          "ICRM"."ITEM_DESCRIPTION" "ITEM_DESCRIPTION",
          "ICRM"."UOM" "UOM",
          "ICRM"."ITEM_CATEGORY" "ITEM_CATEGORY",
          "ICRM"."ITEM_TYPE" "ITEM_TYPE",
          "ICRM"."TRX_QUANTITY" "TRX_QUANTITY"
     FROM "APPS"."XXDBL_INV_CON_RPT_MV" "ICRM";