DROP VIEW IFSAPP.SBL_SMS_LPR_CC;

CREATE OR REPLACE FORCE VIEW IFSAPP.SBL_SMS_LPR_CC
(LP_RECEIPT, RECEIPT_DATE, LPR_AMT, CUSTOMER_NO, CUSTOMER_NAME, 
 PHONE_NO, ACCOUNT_NO, ORDER_NO, SITE_CODE, PAY_NO, 
 RECEIPT_NO, VAT_RECEIPT, ROWVERSION, ROWSTATE, EVENT_NAME)
AS 
SELECT ifsapp.hpnret_co_pay_head_api.get_receipt_no(l.pay_no, 'SBL') lp_receipt,
       l.rowversion receipt_date,
       l.dom_amount lpr_amt,
       l.identity customer_no,
       ifsapp.customer_info_api.get_name(l.identity) customer_name,
       ifsapp.customer_info_comm_method_api.get_any_phone_no(l.identity) phone_no,
       (SELECT MAX(d.account_no)
          FROM ifsapp.hpnret_hp_dtl_tab d
         WHERE d.reference_co = l.order_no) account_no,
       l.order_no,
       l.contract site_code,
       l.pay_no,
       ifsapp.hpnret_co_pay_head_api.get_receipt_no(l.pay_no, 'SBL') receipt_no,
       ifsapp.hpnret_co_pay_head_api.get_vat_receipt(l.pay_no, 'SBL') vat_receipt,
       l.rowversion,
       l.rowstate,
       'LPR' event_name
  FROM ifsapp.hpnret_co_pay_dtl_tab l
 WHERE (SELECT h.lpr_printed
          FROM ifsapp.hpnret_co_pay_head_tab h
         WHERE h.pay_no = l.pay_no) = 'TRUE'
   AND l.rowstate != 'Cancelled'
   AND (SELECT TRUNC(h.receipt_date)
               FROM ifsapp.hpnret_co_pay_head_tab h
              WHERE h.pay_no = l.pay_no) >=
       TO_DATE('2022/2/7', 'YYYY/MM/DD');


GRANT SELECT ON IFSAPP.SBL_SMS_LPR_CC TO SMS;
