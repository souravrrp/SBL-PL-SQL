--Product Model-wise Selling Commission
select t.CATALOG_NO SALE_PART_NO,
       to_char(t.VALID_FROM_DATE, 'YYYY/MM/DD') VALID_FROM_DATE,
       t.SALES_PRICE SALE_PRICE_NSP,
       NVL((select DISTINCT c.AMOUNT
             from ifsapp.commission_agree_line_tab c
            where c.AGREEMENT_ID = 'SP_SC_RTL'
              and c.CATALOG_NO = t.CATALOG_NO
              and c.COMMISSION_SALES_TYPE = 'CASH'
              and c.VALID_FROM =
                  (select max(VALID_FROM)
                     from ifsapp.commission_agree_line_tab cc
                    where cc.AGREEMENT_ID = 'SP_SC_RTL'
                      and cc.CATALOG_NO = c.CATALOG_NO
                      and cc.COMMISSION_SALES_TYPE = 'CASH')),
           0) CASH_COMISSION,
       NVL((select DISTINCT ct.AMOUNT
             from ifsapp.commission_agree_line_tab ct
            where ct.AGREEMENT_ID = 'SP_SC_RTL'
              and ct.CATALOG_NO = t.CATALOG_NO
              and ct.COMMISSION_SALES_TYPE = 'HP'
              and ct.VALID_FROM =
                  (select max(VALID_FROM)
                     from ifsapp.commission_agree_line_tab ch
                    where ch.AGREEMENT_ID = 'SP_SC_RTL'
                      and ch.CATALOG_NO = ct.CATALOG_NO
                      and ch.COMMISSION_SALES_TYPE = 'HP')),
           0) HP_COMISSION
  FROM ifsapp.SALES_PRICE_LIST_PART_TAB t, IFSAPP.statutory_fee_tab f
 where t.CASH_TAX_CODE = f.FEE_CODE
   and t.PRICE_LIST_NO = '&PRICE_LIST_NO'
   and t.VALID_FROM_DATE =
       (select max(s.VALID_FROM_DATE)
          from ifsapp.SALES_PRICE_LIST_PART_TAB s
         where s.CATALOG_NO = t.CATALOG_NO
           and t.valid_from_date <= to_date('2017/12/31', 'YYYY/MM/DD') --sysdate
           and s.PRICE_LIST_NO = '&PRICE_LIST_NO'
           and s.CATALOG_NO like '%&CATALOG_NO%')
 ORDER BY 1
