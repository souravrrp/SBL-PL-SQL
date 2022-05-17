/* Formatted on 8/26/2021 10:39:51 AM (QP5 v5.287) */
CREATE OR REPLACE FORCE VIEW APPS.XXDBLCL_SALES_ORDER_DTL_MV#
(
   ORG_ID,
   CUSTOMER_NUMBER,
   CUSTOMER_NAME,
   CUST_CATEGORY,
   C_TYPE,
   ADDRESS1,
   ORDER_NUMBER,
   ORDER_TYPE,
   ORDERED_DATE,
   INVOICE_DATE,
   PRIORITY,
   FREIGHT,
   FREIGHT_CHARGE,
   FLOW_STATUS_CODE,
   FLOW_STATUS_CODE_1,
   ORDERED_ITEM,
   DESCRIPTION,
   SHIPPING_INSTRUCTIONS,
   LINE_INSTRUCTIONS,
   CUST_PO_NUMBER,
   PREFERRED_GRADE,
   ITEM_SIZE,
   PRODUCT_CATEGORY,
   PRODUCT_TYPE,
   ORDERED_QUANTITY,
   ORDER_QUANTITY_UOM,
   UNIT_LIST_PRICE,
   UNIT_SELLING_PRICE,
   ORDERED_QUANTITY2,
   ORDERED_QUANTITY_UOM2,
   SHIPPED_QUANTITY,
   SHIPPED_QUANTITY2,
   LINE_DISCOUNT,
   RESOURCE_NAME,
   SALESREP_ID,
   CUSTOMER_ID,
   CORRESPONDING_DEALER_CODE,
   CORRESPONDING_DEALER
)
   BEQUEATH DEFINER
AS
   SELECT OHA.ORG_ID,
          CUST.CUSTOMER_NUMBER,
          CUST.CUSTOMER_NAME,
          CUST.CUSTOMER_CATEGORY_CODE CUST_CATEGORY,
          CUST.CUSTOMER_TYPE C_TYPE,
          CUST.ADDRESS1,
          OHA.ORDER_NUMBER,
          OTT.NAME ORDER_TYPE,
          TRUNC (OHA.ORDERED_DATE) ORDERED_DATE,
          TRUNC (OLA.ACTUAL_SHIPMENT_DATE) INVOICE_DATE,
          OHA.SHIPMENT_PRIORITY_CODE PRIORITY,
          OLA.FREIGHT_TERMS_CODE FREIGHT,
          CASE
             WHEN     OLA.FREIGHT_TERMS_CODE = 'DEALER'
                  AND OTT.TRANSACTION_TYPE_ID NOT IN (1006, 1014)
             THEN
                OLA.ORDERED_QUANTITY * .8
             ELSE
                0
          END
             Freight_Charge,
          OHA.FLOW_STATUS_CODE,
          OLA.FLOW_STATUS_CODE,
          OLA.ORDERED_ITEM,
          MSI.DESCRIPTION,
          OHA.SHIPPING_INSTRUCTIONS,
          OLA.SHIPPING_INSTRUCTIONS LINE_INSTRUCTIONS,
          OHA.CUST_PO_NUMBER,
          OLA.PREFERRED_GRADE,
          CAT.ITEM_SIZE ITEM_SIZE,
          CAT.PRODUCT_CATEGORY PRODUCT_CATEGORY,
          CAT.PRODUCT_TYPE PRODUCT_TYPE,
          OLA.ORDERED_QUANTITY,
          OLA.ORDER_QUANTITY_UOM,
          OLA.UNIT_LIST_PRICE,
          OLA.UNIT_SELLING_PRICE,
          OLA.ORDERED_QUANTITY2,
          OLA.ORDERED_QUANTITY_UOM2,
          OLA.SHIPPED_QUANTITY,
          OLA.SHIPPED_QUANTITY2,
            (OLA.UNIT_LIST_PRICE - OLA.UNIT_SELLING_PRICE)
          * OLA.ORDERED_QUANTITY
             LINE_DISCOUNT,
          RSV.RESOURCE_NAME,
          OHA.SALESREP_ID,
          CUST.CUSTOMER_ID,
          NVL (ACD.CUSTOMER_NUMBER, CUST.CUSTOMER_NUMBER) CORRESPONDING_DEALER_CODE,
          NVL (ACD.CUSTOMER_NAME, CUST.CUSTOMER_NAME) CORRESPONDING_DEALER
     FROM OE_ORDER_HEADERS_ALL OHA,
          OE_ORDER_LINES_ALL OLA,
          APPS.OE_TRANSACTION_TYPES_TL OTT,
          INV.MTL_SYSTEM_ITEMS_B MSI,
          XX_AR_CUSTOMER_SITE_V CUST,
          APPS.AR_CUSTOMERS ACD,
          XXDBL_MTL_ITEM_CTG_INFO CAT,
          JTF_RS_SALESREPS SAL,
          JTF_RS_DEFRESOURCES_V RSV
    WHERE     OHA.HEADER_ID = OLA.HEADER_ID
          AND OHA.ORDER_TYPE_ID = OTT.TRANSACTION_TYPE_ID
          AND OLA.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID
          AND OLA.SHIP_FROM_ORG_ID = MSI.ORGANIZATION_ID
          AND MSI.INVENTORY_ITEM_ID = CAT.INVENTORY_ITEM_ID
          AND MSI.ORGANIZATION_ID = CAT.ORGANIZATION_ID
          AND OHA.SALESREP_ID = SAL.SALESREP_ID
          AND OHA.ORG_ID = SAL.ORG_ID
          AND SAL.RESOURCE_ID = RSV.RESOURCE_ID
          AND CUST.ACCT_USE_STATUS = 'A'
          AND CUST.SITE_USE_STATUS = 'A'
          AND OLA.SOLD_TO_ORG_ID = CUST.CUSTOMER_ID
          AND OLA.SHIP_TO_ORG_ID = CUST.SHIP_TO_ORG_ID
          AND OHA.ATTRIBUTE3 = ACD.CUSTOMER_ID(+)
          AND OHA.ORG_ID = 126;

GRANT SELECT ON APPS.XXDBLCL_SALES_ORDER_DTL_MV# TO APPSRO;