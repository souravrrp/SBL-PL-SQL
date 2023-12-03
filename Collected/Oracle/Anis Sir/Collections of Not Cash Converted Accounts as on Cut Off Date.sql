--Positive Collections
select c.contract,
       c.account_no,
       c.original_acc_no,
       c.receipt_no,
       c.amount amount,
       c.payment_date,
       F.CASH_CONVERSION_ON_DATE,
       c.pay_method,
       c.rowstate
  from ifsapp.SBL_COLLECTION_INFO c
 RIGHT JOIN (SELECT H.YEAR,
                    H.PERIOD,
                    H.SHOP_CODE,
                    H.ACCT_NO,
                    H.ORIGINAL_ACCT_NO,
                    H.PRODUCT_CODE,
                    H.CASH_CONVERSION_ON_DATE
               FROM HPNRET_FORM249_ARREARS_TAB H
              WHERE H.YEAR = '&YEAR_I'
                AND H.PERIOD = '&PERIOD'
                AND H.ACT_OUT_BAL > 0
                AND TRUNC(H.CASH_CONVERSION_ON_DATE) >
                    TO_DATE('2015/12/31', 'YYYY/MM/DD')) F
    ON C.contract = F.SHOP_CODE
   AND C.account_no = F.ACCT_NO
   AND C.receipt_no = F.ORIGINAL_ACCT_NO
   
union all

--Negative Cllections
SELECT r.contract,
       r.order_no account_no,
       c.original_acc_no,
       c.receipt_no,
       (-1) * c.amount amount,
       r.date_returned,
       F.CASH_CONVERSION_ON_DATE,
       c.pay_method,
       c.rowstate
  FROM ifsapp.SBL_RETURN_INFO r
  left join ifsapp.SBL_COLLECTION_INFO c
    on r.order_no = c.account_no
   and r.contract = c.contract
 right join (SELECT H.YEAR,
                    H.PERIOD,
                    H.SHOP_CODE,
                    H.ACCT_NO,
                    H.ORIGINAL_ACCT_NO,
                    H.PRODUCT_CODE,
                    H.CASH_CONVERSION_ON_DATE
               FROM HPNRET_FORM249_ARREARS_TAB H
              WHERE H.YEAR = '&YEAR_I'
                AND H.PERIOD = '&PERIOD'
                AND H.ACT_OUT_BAL > 0
                AND TRUNC(H.CASH_CONVERSION_ON_DATE) >
                    TO_DATE('2015/12/31', 'YYYY/MM/DD')) F
    ON r.contract = F.SHOP_CODE
   AND r.order_no = F.ACCT_NO
--AND C.original_acc_no = F.ORIGINAL_ACCT_NO

