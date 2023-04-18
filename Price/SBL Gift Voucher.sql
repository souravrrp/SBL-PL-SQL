/* Formatted on 4/3/2023 10:26:58 AM (QP5 v5.381) */
SELECT * FROM HPNRET_HP_OTHER_PAY_DOC_TAB;

SELECT * FROM HPNRET_DOCUMENT_DTL_TAB;

SELECT book_types,
       SUBSTRB (Book_Types_API.DECODE (book_types), 1, 200)
           new_book_types,
       hcrt.*
  FROM HPNRET_COM_REGISTER_TAB hcrt
 WHERE 1 = 1 AND SUBSTRB (Book_Types_API.DECODE (book_types), 1, 200) = 'GV';