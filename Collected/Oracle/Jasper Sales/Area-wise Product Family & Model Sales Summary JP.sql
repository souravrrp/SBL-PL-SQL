--***** Area-wise Product Family Sales Summary
select s.AREA_CODE,
       p.product_family,
       sum(s.SALES_QUANTITY) SALES_QUANTITY,
       sum(s.SALES_PRICE) SALES_PRICE
  from IFSAPP.SBL_JR_SALES_INV_COMP_VIEW s
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.PRODUCT_CODE = p.product_code
 where s.SALES_PRICE != 0
   and s.sales_date between $P{FROM_DATE} and $P{TO_DATE}
   and $X{IN, s.AREA_CODE, AREA}
   and $X{IN, p.product_family, PRODUCT_FAMILY}
 group by s.AREA_CODE, p.product_family
 order by s.AREA_CODE, p.product_family

--***** Area-wise Product Model Sales Summary
select s.AREA_CODE,
       p.product_family,
       s.PRODUCT_CODE,
       sum(s.SALES_QUANTITY) SALES_QUANTITY,
       sum(s.SALES_PRICE) SALES_PRICE
  from IFSAPP.SBL_JR_SALES_INV_COMP_VIEW s
 inner join IFSAPP.SBL_JR_PRODUCT_DTL_INFO p
    on s.PRODUCT_CODE = p.product_code
 where s.SALES_PRICE != 0
   and s.sales_date between $P{FROM_DATE} and $P{TO_DATE}
   and $X{IN, s.AREA_CODE, AREA}
   and $X{IN, p.product_family, PRODUCT_FAMILY}
   and $X{IN, s.PRODUCT_CODE, PART_NO}
 group by s.AREA_CODE, p.product_family, s.PRODUCT_CODE
 order by s.AREA_CODE, p.product_family, s.PRODUCT_CODE
