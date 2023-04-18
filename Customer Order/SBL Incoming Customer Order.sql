/* Formatted on 4/5/2023 9:15:24 AM (QP5 v5.381) */
SELECT *
  FROM ifsapp.external_customer_order_tab ecot
 WHERE     1 = 1
       AND ( :p_order_no IS NULL OR (ecot.order_no = :p_order_no))
       AND (   :p_po_no IS NULL
            OR (UPPER (ecot.customer_po_no) LIKE
                    UPPER ('%' || :p_po_no || '%')))
       AND ( :p_customer_no IS NULL OR (ecot.customer_no = :p_customer_no))
       AND TRUNC (ecot.DELIVERY_DATE) BETWEEN NVL (
                                                  :p_date_from,
                                                  TRUNC (ecot.DELIVERY_DATE))
                                          AND NVL (
                                                  :p_date_to,
                                                  TRUNC (ecot.DELIVERY_DATE));

--------------------------------------------------------------------------------

SELECT *
  FROM ifsapp.external_customer_order_tab ecot;


SELECT *
  FROM ifsapp.external_customer_order eco;