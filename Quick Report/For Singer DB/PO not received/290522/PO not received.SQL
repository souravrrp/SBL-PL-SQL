/* Formatted on 5/29/2022 9:34:00 AM (QP5 v5.381) */
  SELECT PO_CREATOR,
         SUPPLIER,
         ORDER_NO,
         TO_CHAR (MIN (DELIVERY_DT), 'DD-MON-YY')     DELIVERY_DT
    FROM (SELECT V.PURCHASE_SITE             PO_CREATOR,
                 V.VENDOR_NO                 SUPPLIER,
                 V.ORDER_NO,
                 V.PART_NO,
                 V.DESCRIPTION,
                 V.DUE_AT_DOCK               QTY_SEND,
                 V.PLANNED_DELIVERY_DATE     DELIVERY_DT
            FROM ifsapp.PURCHASE_ORDER_LINE_NEW v
           WHERE V.PURCHASE_SITE IN
                     (SELECT d.CONTRACT
                        FROM IFSAPP.USER_ALLOWED_SITE d
                       WHERE d.USERID IN
                                 (SELECT ifsapp.fnd_session_api.Get_Fnd_User
                                    FROM DUAL)))
GROUP BY PO_CREATOR, SUPPLIER, ORDER_NO;