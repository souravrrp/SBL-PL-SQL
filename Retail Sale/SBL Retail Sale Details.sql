/* Formatted on 3/29/2023 9:35:55 AM (QP5 v5.381) */
SELECT AREA_CODE,
       DISTRICT_CODE,
       SHOP_CODE,
       ORDER_NO,
       PRODUCT_CODE,
       SALES_QUANTITY,
       SALES_PRICE,
       VAT,
       AMOUNT_RSP,
       DISCOUNT,
       SALES_DATE,
       STATUS,
       PART_TYPE
  FROM (SELECT SDI.AREA_CODE,
               SDI.DISTRICT_CODE,
               SDI.SHOP_CODE,
               DI.ORDER_NO,
               DI.PRODUCT_CODE,
               DI.SALES_QUANTITY,
               DI.SALES_PRICE,
               DI.VAT,
               DI.AMOUNT_RSP,
               DI.DISCOUNT,
               DI.SALES_DATE,
               DI.Status,
               'INVENTORY'     PART_TYPE
          FROM SBL_JR_SALES_DTL_INV DI, SHOP_DTS_INFO SDI
         WHERE     DI.SITE = SDI.SHOP_CODE
               AND DI.Status NOT IN ('CashConverted',
                                     'PositiveCashConv',
                                     'TransferAccount',
                                     'PositiveTransferAccount')
        UNION ALL
        SELECT SDI.AREA_CODE,
               SDI.DISTRICT_CODE,
               SDI.SHOP_CODE,
               DK.ORDER_NO,
               DK.PRODUCT_CODE,
               DK.SALES_QUANTITY,
               DK.SALES_PRICE,
               DK.VAT,
               DK.AMOUNT_RSP,
               DK.DISCOUNT,
               DK.SALES_DATE,
               DK.Status,
               'PACKAGE'     PART_TYPE
          FROM SBL_JR_SALES_DTL_PKG DK, SHOP_DTS_INFO SDI
         WHERE     DK.SITE = SDI.SHOP_CODE
               AND DK.Status NOT IN ('CashConverted',
                                     'PositiveCashConv',
                                     'TransferAccount',
                                     'PositiveTransferAccount'))
 WHERE     1 = 1
       AND (   :p_area_code IS NULL
            OR (UPPER (AREA_CODE) = UPPER ( :p_area_code)))
       AND (   :p_district_code IS NULL
            OR (UPPER (DISTRICT_CODE) = UPPER ( :p_district_code)))
       AND (   :p_shop_code IS NULL
            OR (UPPER (SHOP_CODE) = UPPER ( :p_shop_code)))
       AND ( :p_order_no IS NULL OR (UPPER (order_no) = UPPER ( :p_order_no)))
       AND TRUNC (SALES_DATE) BETWEEN NVL ( :p_date_from, TRUNC (SALES_DATE))
                                  AND NVL ( :p_date_to, TRUNC (SALES_DATE));