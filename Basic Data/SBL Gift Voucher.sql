/* Formatted on 9/27/2022 12:50:58 PM (QP5 v5.381) */
SELECT * FROM HPNRET_HP_OTHER_PAY_DOC_TAB;

SELECT * FROM HPNRET_DOCUMENT_DTL_TAB;

SELECT book_types,substrb(Book_Types_API.Decode(book_types),1,200) new_book_types, hcrt.*
  FROM HPNRET_COM_REGISTER_TAB hcrt
 WHERE 1 = 1 AND substrb(Book_Types_API.Decode(book_types),1,200) = 'GV';