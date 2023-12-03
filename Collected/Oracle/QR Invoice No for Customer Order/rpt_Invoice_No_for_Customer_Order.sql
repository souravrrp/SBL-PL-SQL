SELECT distinct (d.delnote_no) invoice_no,
                r.orig_co_no order_no,
                d.order_no internal_co_no
  FROM ifsapp.customer_order_delivery_tab d
 inner join ifsapp.hpnret_customer_order_tab r
    on d.order_no = r.order_no
 WHERE r.orig_co_no = '&ORDER_NO'
 order by d.delnote_no
