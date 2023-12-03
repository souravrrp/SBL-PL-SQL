--*** Components of a PKG
select P.parent_part, P.line_item_no, P.catalog_no, P.qty_per_assembly
  from IFSAPP.SALES_PART_PACKAGE P
 WHERE P.contract = 'SCOM'
   AND P.parent_part = 'PK-SRFUR-JOVANA-TABSC-SET'
 ORDER BY 2

--*** Cost of a Component of a PKG Part
select */*ROUND(SUM(C.COST), 2)*/
  from IFSAPP.COST_PER_PART_TAB C
 WHERE C.YEAR = 2016
   AND C.PERIOD = 12
      --AND T.PART_NO IN ('SHCOM-SINGTECHSTANDARD-02', 'SGCOM-LED-18.5', 'SHCOM-KEYBOARD', 'SHCOM-MOUSE')
   AND C.PART_NO IN
       (select P.catalog_no
          from IFSAPP.SALES_PART_PACKAGE P
         WHERE P.contract = 'SCOM'
           AND P.parent_part = 'PK-SRFUR-JOVANA-TABSC-SET')
