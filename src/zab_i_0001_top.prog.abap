*&---------------------------------------------------------------------*
*& Include          ZLIB_P_AB_0001_TOP
*&---------------------------------------------------------------------*

TABLES : zlib_ab_t_0001, zlib_ab_t_0002, zlib_ab_t_0003, zlib_ab_t_0004.

TYPE-POOLS: slis, icon, vrm.

DATA : go_dock       TYPE REF TO cl_gui_custom_container,
       go_cont       TYPE REF TO cl_gui_container,
       go_html       TYPE REF TO cl_gui_html_viewer,
       go_alv        TYPE REF TO cl_gui_alv_grid,
       go_member_alv TYPE REF TO cl_gui_alv_grid,
       go_borrow_alv TYPE REF TO cl_gui_alv_grid,
       go_picture    TYPE REF TO cl_gui_picture,
       go_cust       TYPE REF TO cl_gui_custom_container,
       go_mem        TYPE REF TO cl_gui_custom_container,
       go_borr       TYPE REF TO cl_gui_custom_container,
       go_pict       TYPE REF TO cl_gui_custom_container.

CLASS : cl_event_receiver DEFINITION DEFERRED.
DATA :  go_event_receiver TYPE REF TO cl_event_receiver.

DATA : go_report TYPE REF TO cl_event_receiver.

DATA : gv_bookname   TYPE zlib_ab_de_bn,
       gv_author     TYPE zlib_ab_de_au,
       gv_isbn       TYPE zlib_ab_de_isbn,
       gv_book_edate TYPE zlib_ab_de_edate,
       gv_category   TYPE zlib_ab_de_cat,
       gv_shelfid    TYPE zlib_ab_de_sid,
       gv_bookid     TYPE zlib_ab_de_bid.

DATA : gv_id      TYPE zlib_ab_de_mid,
       gv_fname   TYPE zlib_ab_de_fn,
       gv_lname   TYPE zlib_ab_de_ln,
       gv_age     TYPE zlib_ab_de_age,
       gv_address TYPE zlib_ab_de_adr,
       gv_memdate	TYPE zlib_ab_de_mdate.

DATA : gt_book   TYPE TABLE OF zlib_ab_t_0001,
       gt_bookl  TYPE TABLE OF zlib_ab_t_0001,
       gs_book   TYPE zlib_ab_t_0001,
       gs_list1  TYPE zlib_ab_t_0001,
       gt_fcat   TYPE lvc_t_fcat,
       gs_fcat   TYPE lvc_s_fcat,
       gs_layout TYPE lvc_s_layo.


DATA : gt_member        TYPE TABLE OF zlib_ab_t_0002,
       gs_member        TYPE zlib_ab_t_0002,
       gt_mem_fcat      TYPE lvc_t_fcat,
       gs_mem_fcat      TYPE lvc_s_fcat,
       gs_member_layout TYPE lvc_s_layo.

DATA : gv_cat    TYPE vrm_id,
       gt_values TYPE vrm_values,
       gs_value  TYPE vrm_value.

DATA : gv_kno   TYPE zlib_ab_de_kn,
       gv_rno   TYPE zlib_ab_de_rn,
       gv_rkat  TYPE zlib_ab_de_rk,
       gv_rsira	TYPE zlib_ab_de_rs,
       gt_shelf TYPE TABLE OF zlib_ab_t_0004,
       gs_shelf TYPE zlib_ab_t_0004.

DATA : gt_borrow        TYPE TABLE OF zlib_ab_t_0003,
       gs_borrow        TYPE zlib_ab_t_0003,
       gt_borr_fcat     TYPE lvc_t_fcat,
       gs_borr_fcat     TYPE lvc_s_fcat,
       gs_borrow_layout TYPE lvc_s_layo.

DATA : gv_bookid_bo TYPE zlib_ab_t_0003-book_id_bo,
       gv_bname_bo  TYPE zlib_ab_t_0003-book_name_bo,
       gv_fname_bo  TYPE zlib_ab_t_0003-firstname_bo,
       gv_lname_bo  TYPE zlib_ab_t_0003-lastname_bo,
       gv_addr_bo   TYPE zlib_ab_t_0003-address_bo,
       gv_bdate     TYPE zlib_ab_de_bdate,
       gv_ddate	    TYPE zlib_ab_de_ddate,
       gv_dtbdel    TYPE datum.

DATA : gv_result TYPE i.
DATA : gt_itab     TYPE TABLE OF zlib_ab_t_0001,
       gs_itab     TYPE zlib_ab_t_0001,
       gt_raw_data TYPE truxs_t_text_data.

DATA : p_file TYPE rlgrap-filename.

DATA : gt_rows TYPE lvc_t_row,
       gs_row  TYPE lvc_s_row,
       gv_row  TYPE i.

FIELD-SYMBOLS : <gfs_fcat> TYPE lvc_s_fcat.
