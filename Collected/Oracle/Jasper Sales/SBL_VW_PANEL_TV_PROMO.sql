CREATE OR REPLACE VIEW SBL_VW_PANEL_TV_PROMO AS
SELECT I.SITE,
       (SELECT S.AREA_CODE
          FROM IFSAPP.SHOP_DTS_INFO S
         WHERE S.SHOP_CODE = I.SITE) AREA_CODE,
       (SELECT S.DISTRICT_CODE
          FROM IFSAPP.SHOP_DTS_INFO S
         WHERE S.SHOP_CODE = I.SITE) DISTRICT_CODE,
       I.ORDER_NO,
       I.LINE_NO,
       I.REL_NO,
       I.STATUS,
       I.DELIVERY_SITE,
       I.SALES_DATE,
       I.PRODUCT_CODE,
       P.PRODUCT_FAMILY,
       P.BRAND,
       I.SALES_QUANTITY,
       I.SALES_PRICE,
       I.VAT,
       I.DISCOUNT,
       I.AMOUNT_RSP,
       I.CUSTOMER_NO,
       ifsapp.customer_info_api.Get_Name(I.CUSTOMER_NO) customer_name,
       ifsapp.CUSTOMER_INFO_COMM_METHOD_API.Get_Any_Phone_No(I.CUSTOMER_NO) phone_no,
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address1(I.CUSTOMER_NO, 1) || ' ' ||
       IFSAPP.CUSTOMER_INFO_ADDRESS_API.Get_Address2(I.CUSTOMER_NO, 1) customer_address,
       (select d.down_payment
          from HPNRET_HP_DTL_TAB d
         where d.account_no = I.ORDER_NO
           and d.ref_line_no = I.LINE_NO
           and d.ref_rel_no = I.REL_NO
           and d.catalog_no = I.PRODUCT_CODE) down_payment,
       (select d.service_charge
          from HPNRET_HP_DTL_TAB d
         where d.account_no = I.ORDER_NO
           and d.ref_line_no = I.LINE_NO
           and d.ref_rel_no = I.REL_NO
           and d.catalog_no = I.PRODUCT_CODE) service_charge,
       case substr(I.ORDER_NO, 4, 2)
         when '-H' then
          (select h.VAT_RECEIPT
             from IFSAPP.HPNRET_PAY_RECEIPT_head_tab h
            where substr(h.receipt_no, 4, 3) = '-HF'
              and h.rowstate = 'Printed'
              and h.account_no = I.ORDER_NO)
         when '-R' then
          (select max(p.vat_receipt)
             from hpnret_co_pay_head_tab p
            inner join hpnret_co_pay_dtl_tab d
               on p.PAY_NO = d.PAY_NO
            where p.lpr_printed is null
              and p.ROWSTATE = 'Printed'
              and d.rowstate = 'Paid'
              and d.curr_amount > 0
              and d.ORDER_NO = I.ORDER_NO)
       END VAT_RECEIPT_RETAIL,
       CASE
         WHEN I.SITE IN
              ('JWSS', 'SAOS', 'SCSM', 'SESM', 'SHOM', 'SWSS', 'WSMO') AND
              I.DELIVERY_SITE NOT IN
              (select W.WARE_HOUSE_NAME from IFSAPP.WARE_HOUSE_INFO W) THEN
          (select c.vat_receipt
             from ifsapp.hpnret_customer_order_tab c
            where c.order_no = I.ORDER_NO)
         ELSE
          ''
       END VAT_RECEIPT_WS
  FROM IFSAPP.SBL_JR_SALES_DTL_INV I
 INNER JOIN IFSAPP.SBL_JR_PRODUCT_DTL_INFO P
    ON I.PRODUCT_CODE = P.PRODUCT_CODE
 WHERE I.SALES_PRICE != 0
   AND P.PRODUCT_FAMILY IN
       ('REFRIGERATOR-DIRECT-COOL',
        'REFRIGERATOR-FREEZER',
        'REFRIGERATOR-NOFROST',
        'REFRIGERATOR-SEMI-COMM',
        'REFRIGERATOR-SIDE-BY-SIDE')
   AND I.STATUS IN ('CashSale',
                    'ReturnCompleted',
                    'HireSale',
                    'Returned',
                    'ReturnAfterCashConv',
                    'ExchangedIn',
                    'PositiveExchangedIn')
 ORDER BY TO_NUMBER((SELECT S.DISTRICT_CODE
                      FROM IFSAPP.SHOP_DTS_INFO S
                     WHERE S.SHOP_CODE = I.SITE)),
          I.ORDER_NO,
          I.LINE_NO,
          I.REL_NO,
          I.PRODUCT_CODE
