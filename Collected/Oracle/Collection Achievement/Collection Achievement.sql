--Collection Achievement
select E.SHOP_CODE,
       E.ACCT_NO,
       E.MONTHLY_PAY,
       E.ACT_OUT_BAL,
       E.ARR_AMT,
       E.DEL_AMT,
       E.ADV_AMT,
       E.EXPECTED_COLLECTIBLE,
       F.payment_date,
       F.collected_amt
  from IFSAPP.SBL_EXP_COLLECT_OF_HP_ACC E
 INNER JOIN (select c.account_no,
                    c.payment_date,
                    sum(c.amount) collected_amt
               from ifsapp.sbl_collection_info c
              where c.payment_date between
                    (LAST_DAY(to_date('&YEAR_I' || '/' || '&PERIOD' || '/1',
                                      'YYYY/MM/DD')) + 1) and (sysdate - 1)
              group by c.account_no, c.payment_date) F
    ON E.ACCT_NO = F.account_no
 WHERE E.YEAR = '&YEAR_I'
   AND E.PERIOD = '&PERIOD'
 ORDER BY 2, 9
