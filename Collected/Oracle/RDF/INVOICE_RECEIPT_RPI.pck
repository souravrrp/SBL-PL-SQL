CREATE OR REPLACE PACKAGE INVOICE_RECEIPT_RPI AS

module_ CONSTANT VARCHAR2(6) := 'INVOIC';
lu_name_ CONSTANT VARCHAR2(25) := 'Invoice';
l_desc_   VARCHAR2(320);


PROCEDURE Report_Overview (
   report_attr_    IN VARCHAR2,
   parameter_attr_ IN VARCHAR2 );

--(+) 120510  SANPLK C_G1136662-1 (START)
FUNCTION AMOUNT_IN_WORDS(amount_ IN NUMBER) RETURN VARCHAR2;
--(+) 120510  SANPLK C_G1136662-1 (END)
END INVOICE_RECEIPT_RPI;
/
CREATE OR REPLACE PACKAGE BODY INVOICE_RECEIPT_RPI AS

PROCEDURE Generate_Amount_Words (amount_ NUMBER,currency_ VARCHAR2) IS

l_amount_      NUMBER(38,2);
l_len_         SMALLINT;
l_start_       NUMBER(38,2);
l_second_      NUMBER(38,2);
l_string2_     VARCHAR2(2000);
l_string_      VARCHAR2(2000);
l_text_        VARCHAR2(2000);
l_stringcent_  VARCHAR2(2000);
l_cents_       VARCHAR2(2000);
l_cents2_      NUMBER(38,2);
l_second1_     NUMBER(38,2);
l_third_       NUMBER(38,2);
l_string3_     VARCHAR2(2000);

BEGIN

l_amount_ := amount_;


IF l_amount_ IS NULL OR l_amount_ <=0 THEN
    l_desc_:=('(ZERO)');
ELSIF TRUNC(l_amount_)=0 THEN
    l_cents_:= (l_amount_*100);
    IF l_cents_<>0 THEN
    SELECT TO_CHAR(TO_DATE(l_cents_,'J'),'JSP') INTO l_stringcent_ FROM DUAL;
    l_desc_:=(l_stringcent_||' '||'CENTS ONLY.');
    ELSE
    l_desc_:=('" NULL "');
    END IF;
ELSE
   BEGIN
     l_start_:= TRUNC(l_amount_/1000000);
     l_second_:=TRUNC(MOD(l_amount_,1000000));
     l_cents2_:= ((l_amount_-TRUNC(l_amount_))*100);

   IF l_start_ <>0 AND  l_second_<>0  THEN

    SELECT TO_CHAR(TO_DATE(l_start_,'J'),'JSP') INTO l_string_ FROM DUAL;
    SELECT TO_CHAR(TO_DATE(l_second_,'J'),'JSP') INTO l_string2_ FROM DUAL;

    IF l_cents2_<>0 THEN
       SELECT TO_CHAR(TO_DATE(l_cents2_,'J'),'JSP') INTO l_stringcent_ FROM DUAL;
       l_desc_:=(l_string_||' MILLION AND '||l_string2_||' '||Currency_||' AND '||l_stringcent_||' CENTS ONLY.');
    ELSE
       l_desc_:=(l_string_||' MILLION AND '||l_string2_||' '||Currency_||' ONLY.');
    END IF;

   ELSIF l_start_ <>0 AND  l_second_=0  THEN

    SELECT TO_CHAR(TO_DATE(l_start_,'J'),'JSP') INTO l_string_ FROM DUAL;

    IF l_cents2_<>0 THEN
       SELECT TO_CHAR(TO_DATE(l_cents2_,'J'),'JSP') INTO l_stringcent_ FROM DUAL;
       l_desc_:=(l_string_||' '||'MILLION '||Currency_||' AND '||l_stringcent_||' CENTS ONLY.');
    ELSE
       l_desc_:=(l_string_||' '||'MILLION '||Currency_||' ONLY.');
    END IF;

  ELSIF l_start_=0 AND  l_second_<>0  THEN

     l_second1_:= TRUNC(l_second_/1000);
     l_third_:= TRUNC(MOD(l_second_,1000));

     IF l_second1_<>0 AND l_third_=0 THEN

       SELECT TO_CHAR(TO_DATE(l_second1_,'J'),'JSP') INTO l_string2_ FROM DUAL;

        IF l_cents2_<>0 THEN
            SELECT TO_CHAR(TO_DATE(l_cents2_,'J'),'JSP') INTO l_stringcent_ FROM DUAL;
            l_desc_:=(l_string2_||' THOUSAND '||Currency_||' AND '||l_stringcent_||' CENTS ONLY.');
        ELSE
            l_desc_:=(l_string2_||' THOUSAND '||Currency_||' ONLY.');
        END IF;

     ELSIF l_second1_<>0 AND l_third_<>0 THEN

      SELECT TO_CHAR(TO_DATE(l_second1_,'J'),'JSP') INTO l_string2_ FROM DUAL;
      SELECT TO_CHAR(TO_DATE(l_third_,'J'),'JSP') INTO l_string3_ FROM DUAL;

        IF l_cents2_<>0 THEN
            SELECT TO_CHAR(TO_DATE(l_cents2_,'J'),'JSP') INTO l_stringcent_ FROM DUAL;
            l_desc_:=(l_string2_||' THOUSAND '||l_string3_||' '||Currency_||' AND '||l_stringcent_||' CENTS ONLY.');
        ELSE
            l_desc_:=(l_string2_||' THOUSAND '||l_string3_||' '||Currency_||' ONLY.');
        END IF;

     ELSIF l_second1_=0 AND l_third_<>0 THEN

      SELECT TO_CHAR(TO_DATE(l_third_,'J'),'JSP') INTO l_string3_ FROM DUAL;

        IF l_cents2_<>0 THEN
            SELECT TO_CHAR(TO_DATE(l_cents2_,'J'),'JSP') INTO l_stringcent_ FROM DUAL;
            l_desc_:=(l_string3_||' '||Currency_||' AND '||l_stringcent_||' CENTS ONLY.');
        ELSE
            l_desc_:=(l_string3_||' '||Currency_||' ONLY.');
        END IF;
    END IF;
  END IF;
END;
END IF;

l_desc_ := LOWER(l_desc_);
l_desc_ := INITCAP(l_desc_);


END Generate_Amount_Words;


PROCEDURE Report_Overview (
   report_attr_    IN VARCHAR2,
   parameter_attr_ IN VARCHAR2 )
IS
   result_key_ NUMBER;
   row_no_     NUMBER := 1;
   address_       VARCHAR2(100);
   del_addr_      VARCHAR2(1500);
   order_no_      VARCHAR2(12);
   --line_no_       VARCHAR2(4);
   --rel_no_        VARCHAR2(4);
   --line_item_no_  NUMBER;
   receipt_no_    VARCHAR2(500);
   co_po_no_      VARCHAR2(60);
   oem_no_        VARCHAR2(2000);
   delnote_no_    VARCHAR2(2000);
   total_amount_  NUMBER:=0;

   discount_      NUMBER:=0;
   unit_amount_   NUMBER:=0;
   tax_amount_    NUMBER:=0;
   unit_price_    NUMBER:=0;
   part_price_    NUMBER:=0;
   currency_      VARCHAR2(20);
   company_       VARCHAR2(30);
   contract_      VARCHAR2(15);
   part_no_       VARCHAR2(45);
   org_co_no_     VARCHAR2(500);

   buy_qty_       NUMBER;
   inv_qty_       NUMBER;


   CURSOR get_delnote_no(order_no_ IN VARCHAR2) IS
      SELECT t.delnote_no
      FROM customer_order_delivery_tab t
      WHERE t.order_no = order_no_
      AND t.delnote_no = (SELECT MAX(t1.delnote_no)
                          FROM customer_order_delivery_tab t1
                          WHERE t1.order_no = order_no_);

   CURSOR get_cust_order_info(ord_no_ IN VARCHAR2) IS
      SELECT  t.order_no,trunc(t.date_entered) sales_date,contract
      FROM  hpnret_customer_order t
      WHERE  order_no LIKE ord_no_;

   CURSOR get_receipt_no(ord_no_ IN VARCHAR2) IS
      SELECT DISTINCT(t.vat_receipt_no) receipt_no
      FROM  Trn_Trip_Plan_Co_Line_Tab t
      WHERE t.order_no = ord_no_
      AND t.trip_no = (SELECT MAX(t1.trip_no)
                       FROM  Trn_Trip_Plan_Co_Line_Tab t1
                       WHERE t1.order_no = order_no_
                       AND Trn_Trip_plan_API.Get_Status(t1.trip_no,t1.release_no) = 'Delivered')
      UNION
      SELECT (t1.vat_receipt) receipt_no
      FROM Hpnret_Customer_Order_Tab t1
      WHERE t1.order_no = ord_no_;

  CURSOR get_oem_info(deliv_no_ IN NUMBER) IS
      SELECT Serial_Oem_Conn_API.Get_Oem_No(t.part_no,t.serial_no) oem_no
      FROM   customer_order_reservation  t
      WHERE  t.order_no  = order_no_
      AND  t.part_no = part_no_
      AND  t.deliv_no IN (SELECT t1.deliv_no
                          FROM customer_order_delivery_tab t1
                          WHERE t1.order_no = order_no_
                          AND t1.delnote_no = deliv_no_);

   CURSOR get_line_info(deliv_no_ IN NUMBER) IS
      SELECT t.deliv_no,
       Customer_Order_Line_API.Get_Catalog_No(t.order_no,t.line_no,t.rel_no,t.line_item_no) part_no,
       Part_Catalog_API.Get_Description(Customer_Order_Line_API.Get_Catalog_No(t.order_no,t.line_no,t.rel_no,t.line_item_no)) catalog_desc,
       t.line_no,
       t.rel_no,
       t.line_item_no,
       NVL(t.qty_shipped,t.qty_invoiced) invoiced_qty,
       Sales_Part_API.Get_Sales_Unit_Meas(Customer_Order_API.Get_Contract(t.order_no),
                                          Customer_Order_Line_API.Get_Catalog_No(t.order_no,t.line_no,t.rel_no,t.line_item_no)) um
      FROM  customer_order_delivery_tab t
      WHERE t.delnote_no = deliv_no_;

  CURSOR get_qty_by_part(deliv_no_ IN NUMBER) IS
      SELECT SUM(Customer_Order_Line_API.Get_Buy_Qty_Due(t.order_no,t.line_no,t.rel_no,t.line_item_no)),
             SUM(NVL(t.qty_shipped,t.qty_invoiced))
      FROM  customer_order_delivery_tab t
      WHERE t.delnote_no = deliv_no_
      AND Customer_Order_Line_API.Get_Catalog_No(t.order_no,t.line_no,t.rel_no,t.line_item_no) = part_no_;

  CURSOR get_buy_unit_price IS
      SELECT DISTINCT t.sale_unit_price
      FROM customer_order_line t
      WHERE t.order_no = org_co_no_
      AND t.part_no = part_no_;

  CURSOR get_tax_amount IS
        SELECT SUM(t.tax_amount) tax_amt
        FROM cust_order_line_tax_lines t
        WHERE t.order_no = org_co_no_
        AND   Customer_Order_Line_API.Get_Catalog_No(t.order_no,t.line_no,t.rel_no,t.line_item_no) = part_no_;

 CURSOR get_discount_amount IS
      SELECT SUM(ROUND((buy_qty_due * price_conv_factor * sale_unit_price) -
                       ((buy_qty_due * price_conv_factor * sale_unit_price) * ((1 - discount / 100) * (1 - (order_discount + additional_discount ) / 100))), 0)) discount_amount
      FROM  customer_order_line_tab
      WHERE order_no = org_co_no_
      AND   rowstate != 'Cancelled'
      AND   line_item_no <= 0
      AND   Customer_Order_Line_API.Get_Catalog_No(order_no,line_no,rel_no,line_item_no) = part_no_;


 CURSOR get_address_info(order_no_ IN VARCHAR2) IS
      SELECT t.address
      FROM customer_info_address t
      WHERE t.customer_id = Customer_Order_API.Get_Customer_No(order_no_)
      AND t.address_id = '1';

 CURSOR get_del_addr(ord_no_ VARCHAR2) IS
     SELECT v.address
     FROM Customer_Info_Address v
     WHERE v.customer_id = Customer_Order_API.Get_Customer_No(ord_no_)
     AND v.address_id = Customer_Order_API.Get_Ship_Addr_No(ord_no_);


 CURSOR get_co_no (ord_no_ IN VARCHAR2) IS
      SELECT r.order_no
      FROM hpnret_customer_order_tab r
      WHERE r.orig_co_no = ord_no_;

 CURSOR get_tp_no IS
   SELECT t.trip_no,t.release_no
   FROM trn_trip_plan_co_line_tab t
   WHERE t.trip_no = (SELECT MAX(t1.trip_no)
                      FROM trn_trip_plan_co_line_tab t1
                      WHERE t1.order_no = order_no_
                      AND Trn_Trip_plan_API.Get_Status(t1.trip_no,t1.release_no) = 'Delivered')
   AND t.order_no = order_no_;

 CURSOR get_total_sum IS
   SELECT SUM(t.n3)
   FROM  info_services_rpt t
   WHERE t.result_key = result_key_;

BEGIN
   result_key_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('RESULT_KEY', report_attr_));
   org_co_no_  := Client_SYS.Get_Item_Value('CO_NO', parameter_attr_);

   OPEN get_co_no(org_co_no_);
   FETCH get_co_no INTO order_no_;
   CLOSE get_co_no;

   contract_ := Customer_Order_API.Get_Contract(org_co_no_);

   User_Finance_API.Get_Default_Company(company_);

   FOR rec_info IN get_cust_order_info(org_co_no_) LOOP

     OPEN get_receipt_no(order_no_);
       FETCH get_receipt_no INTO receipt_no_;
     CLOSE get_receipt_no;

      OPEN get_address_info(rec_info.order_no);
      FETCH get_address_info INTO address_;
      CLOSE get_address_info;

      OPEN get_del_addr(org_co_no_);
       FETCH get_del_addr INTO del_addr_;
      CLOSE get_del_addr;

     FOR del_rec IN get_delnote_no(order_no_) LOOP
        delnote_no_  := del_rec.delnote_no;
     END LOOP;

     FOR rec_line_info IN get_line_info(delnote_no_) LOOP
        --line_no_       :=  rec_line_info.line_no;
        --rel_no_        :=  rec_line_info.rel_no;
        --line_item_no_  :=  rec_line_info.line_item_no;
        part_no_       :=  rec_line_info.part_no;

        oem_no_ := NULL;

        FOR oem_rec IN get_oem_info(delnote_no_) LOOP
          oem_no_ := oem_no_||'-'||oem_rec.oem_no;
        END LOOP;
         receipt_no_ := NULL;
       
        FOR vat_rec IN get_receipt_no(order_no_) LOOP
          receipt_no_ := receipt_no_||'/'||vat_rec.receipt_no; 
         END LOOP;
           receipt_no_ :=SUBSTR(receipt_no_, 2, length(receipt_no_)-2);
           
        FOR tax_rec_ IN get_tax_amount LOOP
          OPEN get_qty_by_part(delnote_no_);
            FETCH get_qty_by_part INTO buy_qty_,inv_qty_;
          CLOSE get_qty_by_part;
          tax_amount_  := tax_amount_ + (tax_rec_.tax_amt/buy_qty_);
          tax_amount_  := ROUND(tax_amount_,2);
        END LOOP;

        FOR disc_rec_ IN get_discount_amount LOOP
          OPEN get_qty_by_part(delnote_no_);
            FETCH get_qty_by_part INTO buy_qty_,inv_qty_;
          CLOSE get_qty_by_part;
          discount_       := discount_ + (disc_rec_.discount_amount/buy_qty_)*inv_qty_;
        END LOOP;

        OPEN get_buy_unit_price;
          FETCH get_buy_unit_price INTO part_price_;
        CLOSE get_buy_unit_price;

        unit_price_  := part_price_ + ROUND(tax_amount_,2);
        unit_amount_ := ROUND(unit_price_,2)*inv_qty_;

            INSERT INTO INFO_SERVICES_RPT(result_key,
                                                   row_no,
                                                   parent_row_no,
                                                    s1,                                     -- NAME,
                                                    s2,                                     -- ADDRESS,
                                                    s3,                                     -- CONTRACT,
                                                    s4,                                     -- CO_NO,
                                                    s12,                                    -- INVOICE_NO,
                                                    s5,                                     -- SALES_DATE,
                                                    s6,                                     -- VAT_CHALLAN,
                                                    s7,                                     -- LINE_NO,
                                                    s13,                                    -- SYSTEM_DATE,
                                                    s8,                                     -- PARTICULARS,
                                                    n1,                                     -- QUANTITY,
                                                    n2,                                     -- UNIT_PRICE,
                                                    s9,                                     -- PER,
                                                    n3,                                     --TOTAL_BASE,
                                                    s11,
                                                    n5,                                    -- SALES_CENTER
                                                    n4,
                                                    s14,
                                                    s15)
                                           VALUES(result_key_,
                                                 row_no_,
                                                 0,
                                                 Customer_Info_API.Get_Name(Customer_Order_API.Get_Customer_No(org_co_no_)),
                                                 address_,
                                                 contract_ || ' - '||Site_api.Get_Description(contract_),
                                                 org_co_no_,
                                                 delnote_no_,
                                                 to_char(trunc(rec_info.sales_date),'yyyy-mm-dd'),
                                                 receipt_no_,
                                                 row_no_,
                                                 to_char(trunc(SYSDATE),'yyyy-mm-dd'),
                                                 rec_line_info.part_no||' '||rec_line_info.catalog_desc, --||' SL No '||oem_no_,
                                                 rec_line_info.invoiced_qty,
                                                 ROUND(unit_price_,2),
                                                 rec_line_info.um,
                                                 unit_amount_,
                                                 rec_info.contract,
                                                 1,
                                                 NVL(discount_,2),
                                                 Customer_Order_API.Get_Customer_No(org_co_no_),
                                                 del_addr_);

                                                 row_no_ := row_no_ + 1;
                                                 unit_amount_    := 0;
                                                 tax_amount_     := 0;

     END LOOP;

       OPEN get_total_sum;
         FETCH get_total_sum INTO total_amount_;
       CLOSE get_total_sum;

       UPDATE INFO_SERVICES_RPT
       SET s10 = AMOUNT_IN_WORDS(total_amount_ - discount_),
       n4 = discount_
       WHERE result_key = result_key_
       AND s4 = org_co_no_;

       discount_       := 0;
       l_desc_         := 0;
       delnote_no_     := NULL;
   END LOOP;

   /*UPDATE info_services_rpt t
   SET    t.n5 = 0
   WHERE  t.result_key    = result_key_
   AND    t.row_no        = row_no_ - 1
   AND    t.parent_row_no = 0;*/
END Report_Overview;

FUNCTION AMOUNT_IN_WORDS(amount_ IN NUMBER) RETURN VARCHAR2 IS
l_amount    NUMBER(12,2);
l_len       SMALLINT;
l_start      NUMBER(12,2);
l_second      NUMBER(12,2);


L_string2   VARCHAR2(2000);
l_string      VARCHAR2(2000);
l_text      VARCHAR2(2000);
L_stringcent   VARCHAR2(2000);

L_PAISA      VARCHAR2(2000);

L_PAISA2      NUMBER(12,2);
l_second1   NUMBER(12,2);
l_third      NUMBER(12,2);

L_string3   VARCHAR2(2000);
l_desc      VARCHAR2(2000);

l_third1   NUMBER(12,2);
l_fourth      NUMBER(12,2);

L_string4   VARCHAR2(2000);


BEGIN
   l_amount := amount_;

   IF l_AMOUNT IS NULL OR L_AMOUNT <=0 THEN
       l_desc:=('(ZERO)');
   ELSIF TRUNC(L_AMOUNT)=0 THEN

       L_PAISA:= (L_AMOUNT*100);
       IF L_PAISA<>0 THEN
       SELECT TO_CHAR(TO_DATE(L_PAISA,'J'),'JSP') INTO L_STRINGCENT FROM DUAL;
       l_desc:=(L_STRINGCENT||' '||'PAISA ONLY.');
       ELSE
       l_desc:=('" NULL "');
       END IF;
   ELSE
      BEGIN
        L_START:= TRUNC(L_AMOUNT/1000000);
        L_SECOND:=TRUNC(MOD(L_AMOUNT,1000000));
        L_PAISA2:= ((L_AMOUNT-TRUNC(L_AMOUNT))*100);

      IF L_START <>0 AND  L_SECOND<>0  THEN
       L_second1:= TRUNC(L_SECOND/100000);
       L_Third:= TRUNC(MOD(L_SECOND,100000));

       IF L_START <> 0 THEN
       SELECT TO_CHAR(TO_DATE(L_START,'J'),'JSP') INTO L_STRING FROM DUAL;
       END IF;
       --SELECT TO_CHAR(TO_DATE(L_SECOND,'J'),'JSP') INTO L_STRING2 FROM DUAL;
       IF L_SECOND1 <> 0 THEN
       SELECT TO_CHAR(TO_DATE(L_SECOND1,'J'),'JSP') INTO L_STRING2 FROM DUAL;
       END IF;

       --IF L_SECOND1 <> 0 THEN
       IF L_THIRD <> 0 THEN

       SELECT TO_CHAR(TO_DATE(L_THIRD,'J'),'JSP') INTO L_STRING3 FROM DUAL;
       END IF;

       IF L_PAISA2<>0 THEN
          SELECT TO_CHAR(TO_DATE(L_PAISA2,'J'),'JSP') INTO L_STRINGCENT FROM DUAL;
          --l_desc:=(L_STRING||' MILLION AND '||L_STRING2||' TAKA AND '||L_STRINGCENT||' PAISA ONLY.');
          IF L_second1 = 1 THEN
          l_desc:=(L_STRING||' MILLION '||L_STRING2||' LAKH '|| L_STRING3 ||' TAKA AND '||L_STRINGCENT||' PAISA ONLY.');
          END IF;
          IF L_second1 > 1 THEN
          l_desc:=(L_STRING||' MILLION '||L_STRING2||' LAKHS '|| L_STRING3 ||' TAKA AND '||L_STRINGCENT||' PAISA ONLY.');
          END IF;

       ELSE

          --l_desc:=(L_STRING||' MILLION AND '||L_STRING2||' ONLY.');
          IF L_second1 = 1 THEN
          l_desc:=(L_STRING||' MILLION '||L_STRING2||' LAKH '|| L_STRING3 ||' ONLY.');
          END IF;
          IF L_second1 > 1 THEN
          l_desc:=(L_STRING||' MILLION '||L_STRING2||' LAKHS '|| L_STRING3 ||' ONLY.');
          END IF;
       END IF;
      ELSIF L_START <>0 AND  L_SECOND=0  THEN

       SELECT TO_CHAR(TO_DATE(L_START,'J'),'JSP') INTO L_STRING FROM DUAL;

       IF L_PAISA2<>0 THEN

          SELECT TO_CHAR(TO_DATE(L_PAISA2,'J'),'JSP') INTO L_STRINGCENT FROM DUAL;
          l_desc:=(L_STRING||' '||'MILLION TAKA AND '||L_STRINGCENT||' PAISA ONLY.');
       ELSE
          l_desc:=(L_STRING||' '||'MILLION ONLY.');
       END IF;
     ELSIF L_START=0 AND  L_SECOND<>0  THEN


        --L_second1:= TRUNC(L_SECOND/1000);
        --L_Third:= TRUNC(MOD(L_SECOND,1000));
        L_second1:= TRUNC(L_SECOND/100000);
        L_Third:= TRUNC(MOD(L_SECOND,100000));

        if L_second1<>0 and L_Third=0 THEN

          SELECT TO_CHAR(TO_DATE(L_second1,'J'),'JSP') INTO L_STRING2 FROM DUAL;

           IF L_PAISA2<>0 THEN

               SELECT TO_CHAR(TO_DATE(L_PAISA2,'J'),'JSP') INTO L_STRINGCENT FROM DUAL;

               --l_desc:=(L_STRING2||' THOUSAND TAKA AND '||L_STRINGCENT||' PAISA ONLY.');
               l_desc:=(L_STRING2||' LAKH TAKA AND '||L_STRINGCENT||' PAISA ONLY.');
           ELSE

               --l_desc:=(L_STRING2||' THOUSAND ONLY.');
               IF L_second1 = 1 THEN
               l_desc:=(L_STRING2||' LAKH ONLY.');
               END IF;
               IF L_second1 > 1 THEN
               l_desc:=(L_STRING2||' LAKHS ONLY.');
               END IF;

           END IF;

        elsif L_second1<>0 and L_Third<>0 then


         L_Third1:= TRUNC(L_THIRD/1000);
         L_Fourth:= TRUNC(MOD(L_THIRD,1000));


         SELECT TO_CHAR(TO_DATE(L_second1,'J'),'JSP') INTO L_STRING2 FROM DUAL;
         --SELECT TO_CHAR(TO_DATE(L_Third,'J'),'JSP') INTO L_STRING3 FROM DUAL;
         IF L_Third1 <> 0 THEN
         SELECT TO_CHAR(TO_DATE(L_Third1,'J'),'JSP') INTO L_STRING3 FROM DUAL;
         END IF;
         IF L_Fourth <> 0 THEN
         SELECT TO_CHAR(TO_DATE(L_Fourth,'J'),'JSP') INTO L_STRING4 FROM DUAL;
         END IF;

           IF L_PAISA2<>0 THEN
               SELECT TO_CHAR(TO_DATE(L_PAISA2,'J'),'JSP') INTO L_STRINGCENT FROM DUAL;
               --l_desc:=(L_STRING2||' THOUSAND '||L_STRING3||' TAKA AND '||L_STRINGCENT||' PAISA ONLY.');
               IF L_second1 = 1 THEN
               l_desc:=(L_STRING2||' LAKH '||L_STRING3||' THOUSAND '||L_STRING4||' TAKA AND '||L_STRINGCENT||' PAISA ONLY.');
               END IF;
               IF L_second1 > 1 THEN
               l_desc:=(L_STRING2||' LAKHS '||L_STRING3||' THOUSAND '||L_STRING4||' TAKA AND '||L_STRINGCENT||' PAISA ONLY.');
               END IF;
           ELSE

               --l_desc:=(L_STRING2||' THOUSAND '||L_STRING3||' ONLY.');
               IF L_second1 = 1 THEN
               l_desc:=(L_STRING2||' LAKH '||L_STRING3||' THOUSAND '||L_STRING4||' ONLY.');
               END IF;
               IF L_second1 > 1 THEN
               l_desc:=(L_STRING2||' LAKHS '||L_STRING3||' THOUSAND '||L_STRING4||' ONLY.');
               END IF;
           END IF;

        elsif L_second1=0 and L_Third<>0 then

         SELECT TO_CHAR(TO_DATE(L_Third,'J'),'JSP') INTO L_STRING3 FROM DUAL;

           IF L_PAISA2<>0 THEN

               SELECT TO_CHAR(TO_DATE(L_PAISA2,'J'),'JSP') INTO L_STRINGCENT FROM DUAL;

               l_desc:=(L_STRING3||' TAKA AND '||L_STRINGCENT||' PAISA ONLY.');
           ELSE

               l_desc:=(L_STRING3||' ONLY.');
           END IF;
       end if;
     END IF;
   END;
   END IF;
   l_desc := LOWER(l_desc);
   l_desc := INITCAP(l_desc);
   RETURN l_desc;

END AMOUNT_IN_WORDS;

END INVOICE_RECEIPT_RPI;
/
