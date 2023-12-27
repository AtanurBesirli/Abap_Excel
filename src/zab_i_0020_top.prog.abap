*&---------------------------------------------------------------------*
*& Include          ZAB_I_0020_TOP
*&---------------------------------------------------------------------*

TABLES : zab_t_0020 , zab_T_0021.

CLASS cl_event_receiver DEFINITION DEFERRED.
DATA : go_event_receiver TYPE REF TO cl_event_receiver.

DATA : go_alv  TYPE REF TO cl_gui_alv_grid,
       go_cust TYPE REF TO cl_gui_custom_container.

DATA : gt_data   TYPE TABLE OF zab_s_0020,
       gt_data1  TYPE TABLE OF zab_s_0020,
       gs_data   TYPE zab_s_0020,
       gt_fcat   TYPE lvc_t_fcat,
       gs_fcat   TYPE lvc_s_fcat,
       gs_layout TYPE lvc_s_layo.

 DATA : gt_rows TYPE lvc_t_row,
        gs_row TYPE lvc_s_row,
        gv_row type int4.

FIELD-SYMBOLS : <gfs_fcat> TYPE lvc_s_fcat.

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS :  so_marka FOR zab_t_0021-marka,
                    so_model FOR zab_t_0021-model,
                    so_vites FOR zab_t_0021-vites,
                    so_yakit FOR zab_t_0021-yakit,
                    so_tarih FOR zab_t_0020-tarih,
                    so_km    FOR zab_t_0020-kilometre,
                    so_fiyat FOR zab_t_0020-fiyat,
                    so_renk  FOR zab_t_0021-renk,
                    so_satis FOR zab_t_0021-satis_tarihi,
                    so_yil   FOR zab_t_0020-yil.

  PARAMETERS : p_rad1 RADIOBUTTON GROUP gr1 DEFAULT 'X',
               p_rad2 RADIOBUTTON GROUP gr1.

  SELECTION-SCREEN END OF BLOCK bl1.
