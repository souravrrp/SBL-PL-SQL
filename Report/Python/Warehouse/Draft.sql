 
                    sql_dis_int = f"""
                                SELECT distinct
                                t1.ORDER_NO,
                                t1.CONTRACT TR_PLACE,
                                t2.INTERNAL_PO_NO DOC_REF1,
                                TRUNC(T3.ROWVERSION) TR_DATE,
                                t1.CATALOG_NO PART_CODE,
                                t3.ACTUAL_QTY_RESERVED  QTY_OUT,
                                NVL(TO_CHAR(t3.DEBIT_NOTE_NO), '-') DEBIT_NOTE_NO,
                                NVL(TO_CHAR(t3.DEBIT_NOTE_NO), '-') DOC_REF2,
                                t2.CUSTOMER_NO DEST_SOURCE,
                                t3.DEBIT_NOTE_NO Debit_note
                                FROM ifsapp.customer_order_line_tab t1,
                                ifsapp.external_customer_order_tab t2,
                                ifsapp.trn_trip_plan_co_line_tab t3,
                                ifsapp.purchase_order_line_tab o 
                                WHERE t1.order_no = t2.order_no
                                AND t1.order_no = t3.order_no
                                and t3.LINE_NO=t1.LINE_NO
                                and t3.REL_NO=t1.REL_NO
                                and t2.INTERNAL_PO_NO=o.ORDER_NO
                                AND t1.contract IN {final_site_codes}
                                AND t1.rowstate IN ('Invoiced','Delivered','PartiallyDelivered')
                                and to_date(to_char( TRUNC(T3.ROWVERSION),'dd-MON-yy')) between TO_DATE('{from_date}', 'yyyy-mm-dd') and TO_DATE('{to_date}', 'yyyy-mm-dd')
                                AND ifsapp.cust_ord_customer_api.get_cust_grp(Customer_Order_API.Get_Customer_No(o.DEMAND_ORDER_NO)) is null
                                order by t3.DEBIT_NOTE_NO
                    """

                    sql_dis_ext = f"""
                        SELECT distinct
                        t1.ORDER_NO,
                        t1.CONTRACT TR_PLACE,
                        o.DEMAND_ORDER_NO,
                        NVL(t2.INTERNAL_PO_NO, '-') DOC_REF1,
                        t1.REAL_SHIP_DATE TR_DATE,
                        t1.CATALOG_NO PART_CODE,
                        t1.QTY_SHIPPED QTY_OUT,
                        NVL(TO_CHAR(t3.DEBIT_NOTE_NO), '-') DEBIT_NOTE_NO,
                        NVL(t3.VAT_RECEIPT_NO, '-') DOC_REF2,
                        customer_info_api.get_name(customer_order_api.Get_Customer_No(o.DEMAND_ORDER_NO)) DEST_SOURCE,
                        t3.DEBIT_NOTE_NO Debit_note
                        FROM ifsapp.customer_order_line_tab t1,
                        ifsapp.external_customer_order_tab t2,
                        ifsapp.trn_trip_plan_co_line_tab t3,
                        ifsapp.purchase_order_line_tab o 
                        WHERE t1.order_no = t2.order_no
                        AND t1.order_no = t3.order_no
                        and t2.INTERNAL_PO_NO=o.ORDER_NO
                        AND t1.contract IN {final_site_codes}
                        AND t1.rowstate IN ('Invoiced','Delivered','PartiallyDelivered')
                        and to_date(to_char( t1.real_ship_date,'dd-MON-yy')) between TO_DATE('{from_date}', 'yyyy-mm-dd') and TO_DATE('{to_date}', 'yyyy-mm-dd')
                        AND ifsapp.cust_ord_customer_api.get_cust_grp(Customer_Order_API.Get_Customer_No(o.DEMAND_ORDER_NO)) = '003'
                        and vat_receipt_no is not null
                        order by t3.DEBIT_NOTE_NO,t1.REAL_SHIP_DATE                    
                    """

                    sql_rcv_int = f"""
                                                select
                        N.CONTRACT TR_PLACE,
                        'IN' TR_TYPE,
                        N.VENDOR_NO DEST_SOURCE,
                        N.PART_NO PART_CODE,
                        N.ARRIVAL_DATE TR_DATE,
                        N.QTY_ARRIVED QTY_IN,
                        0 QTY_OUT,
                        NVL (N.GRN_NO, '-') DOC_REF2,
                        NVL (N.ORDER_NO, '-') ORDER_NO,
                        decode(substr(N.ORDER_NO,1,1),'A','Internal','External') Remark
                        from
                        IFSAPP.PURCHASE_RECEIPT_NEW N
                        where 
                        N.CONTRACT IN {final_site_codes}
                        and N.STATE in ('Received')
                        and to_date(to_char(N.ARRIVAL_DATE)) between TO_DATE('{from_date}', 'yyyy-mm-dd') and TO_DATE('{to_date}', 'yyyy-mm-dd')
                        AND SUBSTR (N.ORDER_NO, 1, 1) = 'A'
                    """

                    sql_rcv_ext = f"""
                        select distinct
                        wd.CONTRACT TR_PLACE,
                        'IN' TR_TYPE,
                        wd.VENDOR_NO||'--'|| wd.VENDOR_NAME DEST_SOURCE,
                        wd.PART_NO PART_CODE , 
                        wd.REAL_ARRIVAL_DATE TR_DATE, 
                        wd.QTY_IN_STORE QTY_IN, 
                        0 QTY_OUT,
                        wd.ORDER_NO DOC_REF1,
                        NVL (lc_no, '-') DOC_REF2,
                        NVL (WD.GRN_NO, '-') GRN_NO,
                        decode(substr(wd.ORDER_NO,1,1),'A','Internal','External') Remark
                        from ifsapp.SBL_PURCHASE_RECEIPT_STAT wd ,ifsapp.sbl_lc LC
                        where  wd.order_no=lc.po_no(+) 
                        aND wd.QTY_IN_STORE>0
                        and to_date(to_char( wd.REAL_ARRIVAL_DATE)) between TO_DATE('{from_date}', 'yyyy-mm-dd') and TO_DATE('{to_date}', 'yyyy-mm-dd')
                        and wd.CONTRACT IN {final_site_codes}
                        AND SUBSTR (wd.ORDER_NO, 1, 1) <> 'A'
                        order by TR_DATE,PART_CODE
                    """