SELECT account_no,
       sales_date,
       catalog_no,
       reference_co,
       lpr_no,
       lpr_date,
       lpr_date - sales_date no_of_days,
       (CASE
            WHEN lpr_date - sales_date <= 60
            THEN
                1000
            WHEN lpr_date - sales_date >= 61 AND lpr_date - sales_date <= 150
            THEN
                500
            ELSE
                0
        END)    dis_vchr_amnt
  FROM (SELECT c.account_no                                AS account_no,
               c.sales_date                                sales_date,
               c.catalog_no                                AS catalog_no,
               c.reference_co                              AS reference_co,
               (SELECT REPLACE (h.receipt_no, '-C', '-LP')
                  FROM ifsapp.hpnret_co_pay_head_tab  h,
                       (SELECT *
                          FROM ifsapp.hpnret_co_pay_dtl n1
                         WHERE n1.dom_amount <> 0) n
                 WHERE     h.pay_no = n.pay_no
                       AND h.rowstate = 'Printed'
                       AND n.state = 'Paid'
                       AND n.order_no = c.reference_co)    AS "LPR_NO",
               p.lump_sum_trans_date                       lpr_date
          FROM ifsapp.hpnret_hp_dtl_tab  c,
               (SELECT *
                  FROM ifsapp.hpnret_co_pay_dtl N1
                 WHERE     n1.dom_amount <> 0
                       AND n1.state IN ('Paid', 'PartiallyPaid')) p
         WHERE     p.order_no = c.reference_co
               AND c.rowstate IN ('CashConverted')
               AND (substr(c.CATALOG_NO,1,5) NOT IN ('SRFAN','SSFAN','SRPAN','SRSWM') and substr(c.CATALOG_NO,1,4) NOT in ('SRGR','SRBL','VGVS','SRVS','SRRC','SRPC','SRHD','SRFP','SREK','SREI','SRBL','PIBL')))
 WHERE TRUNC (lpr_date) BETWEEN TO_DATE ('&p_date_from', 'YYYY/MM/DD')
                                AND TO_DATE ('&p_date_to', 'YYYY/MM/DD')