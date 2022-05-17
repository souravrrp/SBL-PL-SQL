/* Formatted on 5/16/2022 2:18:37 PM (QP5 v5.381) */
SELECT hm.id,
       c.CUST_NAME,
       c.PHONE,
       hd.ACCOUNT_NO,
       hd.LINE_NO,
       hd.SALES_DATE,
       hd.CATALOG_NO,
       hd.QUANTITY,
       hd.CASH_PRICE,
       dic.DISCOUNT_AMOUNT,
       arr.LAST_MON_BALANCE,
       arr.LAST_MON_ARR,
       vat.TAX_AMOUNT     VAT,
       pay.last_pay_dt,
       pay.New_collection,
       hd.ROWSTATE
  FROM ifsapp.HPNRET_HP_DTL_TAB              hd,
       ifsapp.Cust_Order_Line_Discount       dic,
       ifsapp.cust_order_line_tax_lines_tab  vat,
       ifsapp.sbl_arr_data_history           arr,
       ifsapp.HPNRET_HP_HEAD_TAB             hm,
       (  SELECT pay_m.ACCOUNT_NO,
                 MAX (pay_d.VOUCHER_DATE)     Last_pay_dt,
                 SUM (pay_d.AMOUNT)           New_collection
            FROM ifsapp.hpnret_pay_receipt_tab     pay_d,
                 ifsapp.HPNRET_PAY_RECEIPT_head_TAB pay_m
           WHERE     pay_m.RECEIPT_NO = pay_d.RECEIPT_NO
                 AND TO_DATE ('&START_DATE_yyy/mm/dd', 'yyyy/mm/dd') <=
                     pay_d.VOUCHER_DATE
                 AND pay_d.VOUCHER_DATE <=
                     TO_DATE (' &END_DATE_yyy/mm/dd ', ' YYYY / MM / DD ')
        GROUP BY pay_m.ACCOUNT_NO) pay,
       sbl_cust_info                         c
 WHERE     hd.ACCOUNT_NO = dic.ORDER_NO(+)
       AND hd.LINE_NO = dic.LINE_NO(+)
       AND pay.account_no(+) = hm.ACCOUNT_NO
       AND hd.ACCOUNT_NO = hm.ACCOUNT_NO
       AND arr.ACCOUNT_NO = hm.ACCOUNT_NO
       AND hm.ID = c.CUST_ID
       AND SUBSTR (hd.ACCOUNT_NO, 1, 3) = '&SHOP_CODE'
       AND hd.ACCOUNT_NO = vat.ORDER_NO
       AND hd.LINE_NO = vat.LINE_NO
       AND hd.ROWSTATE IN ('Active',
                           'CashConverted',
                           'Closed',
                           'DiscountClosed',
                           'ExchangedIn',
                           'Returned',
                           'Reverted')
       AND hd.CATALOG_TYPE IN ('PKG', 'INV')
       AND hm.ACCOUNT_NO IN
               (SELECT account_no FROM ifsapp.sbl_arr_data_history)