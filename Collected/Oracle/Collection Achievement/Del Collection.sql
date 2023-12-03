SELECT M.*,
       CASE
         WHEN M.STATUS IS NOT NULL THEN
          (M.ARR_DEL_AMT - ARR_DEL_Collection)
         ELSE
          0
       END ADJ_AMT
  FROM (select E.SHOP_CODE,
               E.ACCT_NO,
               E.MONTHLY_PAY,
               E.ACT_OUT_BAL,
               E.ARR_AMT,
               E.DEL_AMT,
               E.ADV_AMT,
               (E.ARR_AMT + E.DEL_AMT) ARR_DEL_AMT,
               F.payment_date,
               NVL(F.collected_amt, 0) TOTAL_COLLECTION,
               CASE
                 WHEN F.collected_amt IS NULL THEN
                  0
                 WHEN F.collected_amt > (E.ARR_AMT + E.DEL_AMT) THEN
                  (E.ARR_AMT + E.DEL_AMT)
                 WHEN F.collected_amt <= (E.ARR_AMT + E.DEL_AMT) THEN
                  F.collected_amt
               END ARR_DEL_Collection,
               L.status
          from IFSAPP.SBL_DEL_AMT_OF_HP_ACC E
          LEFT JOIN (select c.account_no,
                           min(c.payment_date) payment_date,
                           sum(c.amount) collected_amt
                      from ifsapp.sbl_collection_info c
                     where c.payment_date between
                           to_date('&YEAR_I' || '/' || '&PERIOD' || '/1',
                                   'YYYY/MM/DD') and
                           last_day(to_date('&YEAR_I' || '/' || '&PERIOD' || '/1',
                                            'YYYY/MM/DD')) --(sysdate - 1)
                     group by c.account_no) F
            ON E.ACCT_NO = F.account_no
          LEFT JOIN (select h.contract, h.account_no, h.status
                      from ifsapp.HPNRET_HP_LINE_HISTORY_TAB h
                     WHERE TRUNC(h.ENTERED_DATE) BETWEEN
                           TO_DATE('&YEAR_I' || '/' || '&PERIOD' || '/1',
                                   'YYYY/MM/DD') AND
                           last_day(to_date('&YEAR_I' || '/' || '&PERIOD' || '/1',
                                            'YYYY/MM/DD')) --(sysdate - 1)
                       and h.status in ('Returned',
                                        'ExchangedIn',
                                        'DiscountClosed',
                                        'Reverted',
                                        'CashConverted',
                                        'TransferAccount')
                     group by h.contract, h.account_no, h.status) L
            on E.ACCT_NO = L.account_no
           and E.SHOP_CODE = L.contract
         WHERE E.YEAR =
               EXTRACT(YEAR FROM(TO_DATE('&YEAR_I' || '/' || '&PERIOD' || '/1',
                                    'YYYY/MM/DD') - 1))
           AND E.PERIOD =
               EXTRACT(MONTH FROM(TO_DATE('&YEAR_I' || '/' || '&PERIOD' || '/1',
                                    'YYYY/MM/DD') - 1))
           AND (E.ARR_AMT + E.DEL_AMT) > 0
        /*AND F.collected_amt IS NULL*/
         ORDER BY 2) M
