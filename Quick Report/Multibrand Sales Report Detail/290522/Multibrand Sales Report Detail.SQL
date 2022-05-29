/* Formatted on 5/29/2022 8:57:44 AM (QP5 v5.381) */
SELECT *
  FROM ifsapp.SBL_VW_MULTI_BRAND_SALES m
 WHERE m.SALES_DATE BETWEEN TO_DATE ('&YEAR_I' || '/' || '&PERIOD' || '/1',
                                     'yyyy/mm/dd')
                        AND LAST_DAY (
                                TO_DATE (
                                    '&YEAR_I' || '/' || '&PERIOD' || '/1',
                                    'yyyy/mm/dd'))