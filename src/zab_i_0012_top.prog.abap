*&---------------------------------------------------------------------*
*& Include          ZAB_I_0012_TOP
*&---------------------------------------------------------------------*

TABLES : mara, zab_t_0006, sscrfields.

DATA : go_alv  TYPE REF TO cl_gui_alv_grid,
       go_cust TYPE REF TO cl_gui_custom_container.

CLASS : cl_event_receiver DEFINITION DEFERRED.
DATA  : go_event_receiver TYPE REF TO cl_event_receiver.

DATA : gt_data   TYPE TABLE OF zab_s_0012,
       gs_data   TYPE zab_s_0012,
       gt_fcat   TYPE lvc_t_fcat,
       gs_fcat   TYPE lvc_s_fcat,
       gs_layout TYPE lvc_s_layo.

DATA : gt_rows TYPE lvc_t_row,
       gs_row  TYPE lvc_s_row,
       gv_row TYPE i.

DATA : gt_excluding TYPE ui_functions,
       gv_excluding TYPE ui_func.

DATA : go_gbt       TYPE REF TO cl_gbt_multirelated_service,
       go_bcs       TYPE REF TO cl_bcs,
       go_doc_bcs   TYPE REF TO cl_document_bcs,
       go_recipient TYPE REF TO if_recipient_bcs,
       gt_soli      TYPE TABLE OF soli,
       gs_soli      TYPE soli,
       gv_status    TYPE bcs_rqst,
       gv_content   TYPE string.

DATA : gv_attachment_size TYPE sood-objlen,
       gt_att_content_hex TYPE solix_tab,
       gv_att_content     TYPE string,
       gv_att_line        TYPE string.

DATA : gv_filename TYPE string,
       gv_del_matnr TYPE matnr.

FIELD-SYMBOLS : <gfs_fcat> TYPE lvc_s_fcat.

"ZAB_T_0006 malzeme ek bilgiler tablosu
"ZAB_T_0007 Malzeme Ek Bilgiler Log Tablosu

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.

  PARAMETERS : p_rad1 RADIOBUTTON GROUP rgr1  DEFAULT 'X' USER-COMMAND s1,
               p_rad2 RADIOBUTTON GROUP rgr1.

  SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-002.

    SELECT-OPTIONS : so_matnr FOR mara-matnr MODIF ID gr1,
                     so_count FOR zab_t_0006-zcountry MODIF ID gr1.
    PARAMETERS : p_chkbox AS CHECKBOX DEFAULT '' MODIF ID gr1,
                 p_excel TYPE string MODIF ID gr2 OBLIGATORY DEFAULT 'C:'.
    SELECTION-SCREEN : PUSHBUTTON /31(20) text-003 USER-COMMAND but1 MODIF ID gr2,
                       PUSHBUTTON  56(20) text-017 USER-COMMAND but2 MODIF ID gr2.

  SELECTION-SCREEN END OF BLOCK bl2.

SELECTION-SCREEN END OF BLOCK bl1.
