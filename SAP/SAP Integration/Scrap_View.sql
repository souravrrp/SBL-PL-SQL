CREATE OR REPLACE FORCE VIEW IFSAPP.SBL_SAP_INTG_SCRAP_SALES
(
    DOCUMENT_NUMBER,
    LINE_ITEM_NUMBER,
    DOCUMENT_DATE,
    SKU,
    QUANTITY,
    SITE_CODE,
    SCRAPPING_REASON
)
AS
    SELECT ii.c1             document_number,
           ii.item_id        line_item_number,
           i.invoice_date    document_date,
           ii.c5             item_number,
           (CASE
                WHEN ii.net_curr_amount != 0
                THEN
                    ii.n2 * (ii.net_curr_amount / ABS (ii.net_curr_amount))
                ELSE
                    ifsapp.get_sbl_free_item_sales_qtn (ii.invoice_id,
                                                        ii.item_id,
                                                        ii.n2)
            END)             quantity,
           ii.c10            site_code,
           ''                scrapping_reason
      FROM ifsapp.invoice_tab  i
           INNER JOIN ifsapp.invoice_item_tab ii
               ON i.invoice_id = ii.invoice_id
     WHERE     ii.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
           AND ii.rowstate = 'Posted'
           AND ii.c10 = 'SISM';