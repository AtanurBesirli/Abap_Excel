*&---------------------------------------------------------------------*
*& Include          ZSF_P_AB_0001_TOP
*&---------------------------------------------------------------------*

TABLES : bseg, bkpf, t001.

TYPE-POOLS ole2.

DATA : go_alv         TYPE REF TO cl_gui_alv_grid,
       go_cust        TYPE REF TO cl_gui_custom_container,
       go_detail_alv  TYPE REF TO cl_gui_alv_grid,
       go_detail_cust TYPE REF TO cl_gui_custom_container,
       go_log_alv     TYPE REF TO cl_gui_alv_grid,
       go_log_cust    TYPE REF TO cl_gui_custom_container..

CLASS : cl_event_receiver DEFINITION DEFERRED.
DATA :  go_event_receiver TYPE REF TO cl_event_receiver.

DATA : gt_list   TYPE TABLE OF zsf_ab_s_0001,
       gs_list   TYPE zsf_ab_s_0001,
       gt_fcat   TYPE lvc_t_fcat,
       gs_fcat   TYPE lvc_s_fcat,
       gs_layout TYPE lvc_s_layo.

DATA : gt_detail        TYPE TABLE OF zsf_ab_s_0002,
       gs_detail        TYPE zsf_ab_s_0002,
       gt_detail_fcat   TYPE lvc_t_fcat,
       gs_detail_fcat   TYPE lvc_s_fcat,
       gs_detail_layout TYPE lvc_s_layo.

DATA : gt_log        TYPE TABLE OF zsf_ab_t_0002,
       gs_log        TYPE zsf_ab_t_0002,
       gt_log_fcat   TYPE lvc_t_fcat,
       gs_log_fcat   TYPE lvc_s_fcat,
       gs_log_layout TYPE lvc_s_layo.

DATA : gt_excluding TYPE ui_functions,
       gv_excluding TYPE ui_func.

DATA : gs_cell_color TYPE lvc_s_scol.

DATA : gt_rows TYPE lvc_t_row,
       gs_row  TYPE lvc_s_row,
       gv_row  TYPE int4.

DATA : gv_fm_name    TYPE rs38l_fnam,
       gs_controls   TYPE ssfctrlop,
       gs_output     TYPE ssfcompop,
       gs_job_output TYPE ssfcrescl.

FIELD-SYMBOLS : <gfs_fcat>   TYPE lvc_s_fcat,
                <gfs_detail> TYPE zsf_ab_s_0002,
                <fs>.

TYPES : BEGIN OF gty_address,
          name1  TYPE name1_gp,
          adrnr  TYPE adrnr,
          street TYPE ad_street,
          city1  TYPE ad_city1,
          city2  TYPE ad_city2,
        END OF gty_address.

DATA : gt_address TYPE TABLE OF gty_address,
       gs_address TYPE gty_address.

DATA : gv_deli(1)  TYPE c,
       gv_action   TYPE i,
       gv_file     TYPE string,
       gv_path     TYPE string,
       gv_fullpath TYPE string,
       gv_filename TYPE string.

TYPES : BEGIN OF gty_header,
          line TYPE char30,
        END OF gty_header.

DATA : gt_header TYPE TABLE OF gty_header,
       gs_header TYPE gty_header.

TYPES : BEGIN OF gty_excel,
          bukrs TYPE bukrs,
          butxt TYPE butxt,
          belnr TYPE belnr_d,
          gjahr TYPE gjahr,
          blart TYPE blart,
          bldat TYPE bldat,
          kunnr TYPE kunnr,
          name1 TYPE name1_gp,
          wrbtr TYPE wrbtr,
          waers TYPE waers,
          sgtxt TYPE sgtxt,
          stcd1 TYPE stcd1,
          stcd2 TYPE stcd2,
        END OF gty_excel.

DATA : gt_excel  TYPE TABLE OF gty_excel,
       gs_excel  TYPE gty_excel,
       gt_excel1 TYPE truxs_t_text_data.

DATA : gt_form TYPE TABLE OF zsf_ab_s_0003,
       gs_form TYPE zsf_ab_s_0003.

DATA : gt_otf         TYPE itcoo OCCURS 0 WITH HEADER LINE,
       gt_pdf         TYPE tline OCCURS 0 WITH HEADER LINE,
       gv_file_filter TYPE string.

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

DATA: i_otf       TYPE itcoo OCCURS 0 WITH HEADER LINE,
      i_tline     TYPE TABLE OF tline WITH HEADER LINE,
      i_receivers TYPE TABLE OF somlreci1 WITH HEADER LINE,
      i_record    LIKE solisti1 OCCURS 0 WITH HEADER LINE,
* Objects to send mail.
      i_objpack   LIKE sopcklsti1 OCCURS 0 WITH HEADER LINE,
      i_objtxt    LIKE solisti1 OCCURS 0 WITH HEADER LINE,
      i_objbin    LIKE solisti1 OCCURS 0 WITH HEADER LINE,
      i_reclist   LIKE somlreci1 OCCURS 0 WITH HEADER LINE.

DATA : w_objhead  TYPE soli_tab,
       w_doc_chng TYPE sodocchgi1,
       w_data     TYPE sodocchgi1,
       w_buffer   TYPE string. "To convert from 132 to 255

DATA: gv_len_in    TYPE sood-objlen,
      gv_len_out   TYPE sood-objlen,
      gv_len_outn  TYPE i,
      gv_lines_txt TYPE i,
      gv_lines_bin TYPE i.

DATA : gv_add TYPE spop-varvalue1.


SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.

  SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-002.

    PARAMETERS : p_bukrs TYPE bkpf-bukrs DEFAULT 3500 MODIF ID fl1,
                 p_blart TYPE bkpf-blart DEFAULT 'SA' MODIF ID fl1.
  SELECTION-SCREEN END OF BLOCK bl2.

  SELECTION-SCREEN BEGIN OF BLOCK bl3 WITH FRAME TITLE TEXT-002.

    PARAMETERS : p_kunnr RADIOBUTTON GROUP rgr1  DEFAULT 'X' USER-COMMAND s1,
                 p_lifnr RADIOBUTTON GROUP rgr1.

    SELECT-OPTIONS : so_belnr FOR bkpf-belnr,
                     so_kunnr FOR bseg-kunnr MODIF ID gr1,
                     so_lifnr FOR bseg-lifnr MODIF ID gr2,
                     so_gjahr FOR bkpf-gjahr,
                     so_bldat FOR bkpf-bldat.

  SELECTION-SCREEN END OF BLOCK bl3.

SELECTION-SCREEN END OF BLOCK bl1.
