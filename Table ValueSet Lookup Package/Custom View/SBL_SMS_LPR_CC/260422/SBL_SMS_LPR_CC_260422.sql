/* Formatted on 4/26/2022 3:00:45 PM (QP5 v5.381) */
SELECT ifsapp.hpnret_co_pay_head_api.get_receipt_no (l.pay_no, 'SBL')
           lp_receipt,
       l.rowversion
           receipt_date,
       l.dom_amount
           lpr_amt,
       l.identity
           customer_no,
       ifsapp.customer_info_api.get_name (l.identity)
           customer_name,
       ifsapp.customer_info_comm_method_api.get_any_phone_no (l.identity)
           phone_no,
       (SELECT MAX (d.account_no)
          FROM ifsapp.hpnret_hp_dtl_tab d
         WHERE d.reference_co = l.order_no)
           account_no,
       l.order_no,
       l.contract
           site_code,
       l.pay_no,
       ifsapp.hpnret_co_pay_head_api.get_receipt_no (l.pay_no, 'SBL')
           receipt_no,
       ifsapp.hpnret_co_pay_head_api.get_vat_receipt (l.pay_no, 'SBL')
           vat_receipt,
       l.rowversion,
       l.rowstate,
       'LPR'
           event_name
  FROM ifsapp.hpnret_co_pay_dtl_tab l
 WHERE     EXISTS
               (SELECT 1
                  FROM ifsapp.hpnret_co_pay_head_tab h
                 WHERE h.pay_no = l.pay_no AND h.lpr_printed = 'TRUE')
       AND l.rowstate != 'Cancelled'
       AND EXISTS
               (SELECT 1
                  FROM ifsapp.hpnret_co_pay_head_tab h
                 WHERE     h.pay_no = l.pay_no
                       AND TRUNC (h.receipt_date) >=
                           TO_DATE ('2022/2/7', 'YYYY/MM/DD'));