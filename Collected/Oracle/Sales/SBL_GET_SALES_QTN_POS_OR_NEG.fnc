create or replace function SBL_GET_SALES_QTN_POS_OR_NEG(
       acct_no_             in varchar2,
       /*line_no_             in varchar2,
       rel_no_              in varchar2,
       catalog_no_          in varchar2,*/
       quantity_            in number,
       sales_price_         in number,
       sales_date_          in date) return number

is

cursor get_oth_sales_price(acct_no_ in varchar2, sales_date_ in date) is
select t.net_curr_amount SALES_PRICE
from ifsapp.invoice_item_tab t
 inner join ifsapp.INVOICE_TAB i
    on t.invoice_id = i.invoice_id
 where t.creator = 'CUSTOMER_ORDER_INV_ITEM_API'
   and t.rowstate = 'Posted'
   and IFSAPP.SALES_PART_API.Get_Catalog_Type(T.C5) in ('INV', 'PKG')
   and t.c1 = acct_no_
   and i.invoice_date = sales_date_
   /*and t.c2 != line_no_
   and t.c3 != rel_no_*/
   and t.net_curr_amount != 0
   and rownum <= 1;

oth_sales_price_ number;
sales_qty_ number;

begin

    if sales_price_ != 0 then
      sales_qty_ := quantity_ * (sales_price_ / abs(sales_price_));
      return sales_qty_;
    else
      open get_oth_sales_price(acct_no_, sales_date_);
      fetch get_oth_sales_price into oth_sales_price_;
      close get_oth_sales_price;
      sales_qty_ := quantity_ * (oth_sales_price_ / abs(oth_sales_price_));
      return sales_qty_;
      end if;
end SBL_GET_SALES_QTN_POS_OR_NEG;
/
