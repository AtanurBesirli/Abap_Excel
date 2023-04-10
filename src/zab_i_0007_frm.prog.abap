*&---------------------------------------------------------------------*
*& Include          ZMM_P_AB01_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_display_alv .

  IF go_alv2 IS INITIAL.

    PERFORM f_create_grid.

    PERFORM f_register_f4.

    CREATE OBJECT go_event_receiver.

    SET HANDLER go_event_receiver->handle_toolbar
                go_event_receiver->handle_user_command FOR go_alv.
    SET HANDLER go_event_receiver->handle_data_changed
                go_event_receiver->handle_onf4 FOR go_alv2.

    CALL METHOD go_alv->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout
      CHANGING
        it_outtab       = gt_list
        it_fieldcatalog = gt_fcat.

    CALL METHOD go_alv2->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout2
      CHANGING
        it_outtab       = gt_list2
        it_fieldcatalog = gt_fcat2.

    CALL METHOD go_alv2->register_edit_event
      EXPORTING
        i_event_id = cl_gui_alv_grid=>mc_evt_modified.

  ELSE.
    CALL METHOD go_alv2->refresh_table_display.
*    CALL METHOD go_alv->refresh_table_display.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_data.

  SELECT  mara~matnr,
          makt~maktx,
          mara~mtart,
          t134t~mtbez,
          mard~lgort,
*          t001l~lgobe,
          mard~labst,
          mard~werks,
          mara~meins
*          mard~lgort AS lgort1,
*          mard~labst AS labst1
    FROM mara
    INNER JOIN marc  ON mara~matnr EQ marc~matnr
    LEFT  JOIN mard  ON mara~matnr EQ mard~matnr
    LEFT  JOIN makt  ON mara~matnr EQ makt~matnr
    LEFT JOIN t134t ON mara~mtart EQ t134t~mtart
*    left  join t001l on mard~lgort eq t001l~lgort
    INTO  CORRESPONDING FIELDS OF TABLE @gt_list2
    WHERE mara~matnr IN @so_matnr
    AND   mara~mtart IN @so_mtart
    AND   marc~werks IN @so_werks
    AND   marc~werks IN @so_werk1
    AND   mard~lgort IN @so_lgort
    AND   makt~spras = @sy-langu
    AND   t134t~spras = @sy-langu
    AND   mard~labst > 0.

  SELECT  werks, lgort, lgobe
    FROM t001l
    INTO TABLE @DATA(lt_t001l)
    FOR ALL ENTRIES IN @gt_list2
    WHERE werks = @gt_list2-werks
      AND lgort = @gt_list2-lgort.

  LOOP AT gt_list2 INTO DATA(ls_list01).
    READ TABLE lt_t001l INTO DATA(ls_list02) WITH KEY werks = ls_list01-werks
                                                      lgort = ls_list01-lgort.

    ls_list01-lgobe = ls_list02-lgobe.
    MODIFY gt_list2 FROM ls_list01.
  ENDLOOP.

  SORT gt_list2.
  DELETE ADJACENT DUPLICATES FROM gt_list2.
  LOOP AT gt_list2 ASSIGNING <gfs_list>.
    <gfs_list>-status = '@08@'.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_fcat .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZAB_S_HW_0003'
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1                " Call parameter combination error
      program_error          = 2                " Program Errors
      OTHERS                 = 3.


  LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'SELKZ'.
        <gfs_fcat>-edit = 'X'.
        <gfs_fcat>-no_out = 'X'.
      WHEN 'MATNR'.
        <gfs_fcat>-outputlen = 14.
      WHEN 'LGORT'.
        <gfs_fcat>-outputlen = 15.
      WHEN 'LGORT1'.
        <gfs_fcat>-outputlen = 8.
      WHEN 'LABST1'.
        <gfs_fcat>-outputlen = 22.
      WHEN 'MEINS'.
        <gfs_fcat>-no_out = 'X'.
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_fcat2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_fcat2 .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZAB_S_HW_0004'
    CHANGING
      ct_fieldcat            = gt_fcat2
    EXCEPTIONS
      inconsistent_interface = 1                " Call parameter combination error
      program_error          = 2                " Program Errors
      OTHERS                 = 3.

  LOOP AT gt_fcat2 ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'MATNR'.
        <gfs_fcat>-outputlen = 14.
      WHEN 'MAKTX'.
        <gfs_fcat>-outputlen = 15.
      WHEN 'MTART'.
        <gfs_fcat>-outputlen = 12.
      WHEN 'MTBEZ'.
        <gfs_fcat>-outputlen = 15.
      WHEN 'LGORT'.
        <gfs_fcat>-outputlen = 8.
      WHEN 'LGOBE'.
        <gfs_fcat>-outputlen = 12.
      WHEN 'LABST'.
        <gfs_fcat>-outputlen = 8.
      WHEN 'MEINS'.
        <gfs_fcat>-outputlen = 8.
      WHEN 'LGORT1'.
        <gfs_fcat>-outputlen  = 11.
        <gfs_fcat>-edit       = 'X'.
        <gfs_fcat>-f4availabl = 'X'.
      WHEN 'LABST1'.
        <gfs_fcat>-outputlen = 8.
        <gfs_fcat>-edit      = 'X'.
      WHEN 'STATUS'.
        <gfs_fcat>-outputlen = 4.
    ENDCASE.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_layout .
  CLEAR : gs_layout.
*  gs_layout-cwidth_opt = 'X'.
  gs_layout-zebra = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_layout2
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_layout2 .
  CLEAR : gs_layout2.
*  gs_layout2-cwidth_opt = 'X'.
  gs_layout2-zebra = 'X'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form bapi_fonk
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_bapi_fonk .

  DATA: lt_item       TYPE TABLE OF  bapi2017_gm_item_create,
        ls_item       LIKE LINE OF lt_item,
        ls_code       TYPE bapi2017_gm_code,
        ls_header     TYPE bapi2017_gm_head_01,
        lt_return     TYPE bapiret2_t,
        lv_matdoc     TYPE mblnr,
        lv_mjahr      TYPE mjahr,
        lt_extensiont TYPE TABLE OF bapiparex,
        ls_return     TYPE bapiret2.

  FIELD-SYMBOLS : <fs_item> LIKE LINE OF lt_item.
*                  <fs_ext>  LIKE LINE OF lt_extensiont.
*
  APPEND INITIAL LINE TO lt_item ASSIGNING <fs_item>.

  SELECT SINGLE werks
    FROM mard
    INTO @DATA(lv_werks)
    WHERE matnr = @gs_list-matnr.

  ls_header-pstng_date = sy-datum.
  ls_header-doc_date   = sy-datum.
  ls_header-pr_uname   = sy-uname.

  ls_code-gm_code = '04'.

  <fs_item>-material = gs_list-matnr.
  <fs_item>-plant    = lv_werks.       "gs_list-lgort.
  <fs_item>-stge_loc = gs_list-lgort.

  <fs_item>-move_type  = '301'.
  <fs_item>-spec_stock = 'Q'.
  <fs_item>-entry_qnt  = gs_list-labst1.
  <fs_item>-entry_uom  = gs_list-meins.
  <fs_item>-move_mat   = gs_list-matnr.
  <fs_item>-move_plant = lv_werks.
  <fs_item>-move_stloc = gs_list-lgort1.

*    <fs_item>-val_wbs_elem = '1'.

*A - Başarı durumu.
*E - Hata durumu.
*X - Uyarı durumu.

  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      goodsmvt_header  = ls_header
      goodsmvt_code    = ls_code
    IMPORTING
      materialdocument = lv_matdoc
      matdocumentyear  = lv_mjahr
    TABLES
      goodsmvt_item    = lt_item
      return           = lt_return
      extensionin      = lt_extensiont.

  LOOP AT lt_return INTO ls_return WHERE type ='A' OR type ='E'
    OR type ='X'.
    MESSAGE ls_return-message TYPE 'S' DISPLAY LIKE 'E'.
*    message e025(ziimp).
    EXIT.
  ENDLOOP.

  IF sy-subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form register_f4
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_register_f4 .

  DATA : lt_f4 TYPE lvc_t_f4,
         ls_f4 TYPE lvc_s_f4.

  CLEAR : ls_f4.
  ls_f4-fieldname = 'LGORT1'.
  ls_f4-register = 'X'.
  APPEND ls_f4 TO lt_f4.

  CALL METHOD go_alv2->register_f4_for_fields
    EXPORTING
      it_f4 = lt_f4.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_create_grid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_create_grid .

  CREATE OBJECT go_cust
    EXPORTING
      container_name = 'CC_ALV'.

  CREATE OBJECT go_splitter
    EXPORTING
      parent  = go_cust
      rows    = 2
      columns = 1.

  CALL METHOD go_splitter->get_container
    EXPORTING
      row       = 1
      column    = 1
    RECEIVING
      container = go_gui1.

  CALL METHOD go_splitter->get_container
    EXPORTING
      row       = 2
      column    = 1
    RECEIVING
      container = go_gui2.

  CREATE OBJECT go_alv
    EXPORTING
      i_parent = go_gui1.

  CREATE OBJECT go_alv2
    EXPORTING
      i_parent = go_gui2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_call_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_call_screen .
  CALL SCREEN 0100.
ENDFORM.
