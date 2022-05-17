--customer product delivery mst

select ''DELIVERY_ID,
       cd.DELIV_NO,
       co.CUSTOMER_NO AS CUST_NO,
       co.DATE_ENTERED AS ORDER_DATE,
       cd.DATE_DELIVERED AS DELIVERY_DATE,
       ''TRANSPORT_DETAIL,
       ''CHALAN_NO,
       ''DEL_PERSON_NAME,
       ''DEL_PERSON_MOB,
       ''DEL_BUS_CAT_CODE,
       ''VDS_APPLICABLE,
       ''VDS_CERT_NO,
       ''VDS_CERT_DATE
FROM CUSTOMER_ORDER_TAB co
INNER JOIN CUSTOMER_ORDER_DELIVERY_TAB
ON co.order_no=cd.order_no

--CUSTOMER PRODUCT DELIVERY DTL


       
