SELECT x.account_no,SUM(x.paid_amount)
FROM (SELECT t1.account_no,(t2.install_amount-t2.due_amount) paid_amount
      FROM hpnret_hp_dtl_tab t1,hpnret_pay_dtl_tab t2
      WHERE t1.account_no = t2.account_no
      AND t1.account_rev = t2.account_rev
      AND t1.line_no = t2.line_no
      AND t1.variated_date  <= to_date('31/12/2013','dd/mm/yyyy')
      AND t1.rowstate IN ('Returned','CashConverted','ExchangedIn')) x
GROUP BY x.account_no;
