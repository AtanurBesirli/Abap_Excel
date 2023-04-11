*&---------------------------------------------------------------------*
*& Include          ZAB_I_0008_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f_screen
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_screen .

  CALL SCREEN '100'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_data .

  SELECT mara~matnr ,
         makt~maktx ,
         marc~werks ,
         t001w~name1,
         mara~meins ,
         mara~mstae ,
         mara~brgew ,
         mara~gewei
    FROM mara
    INNER JOIN marc ON marc~matnr EQ mara~matnr
    INNER JOIN t001w ON t001w~werks EQ marc~werks
    LEFT JOIN makt ON makt~matnr EQ mara~matnr
    INTO CORRESPONDING FIELDS OF TABLE @gt_data
    WHERE mara~matnr IN @s_matnr
      AND marc~werks IN @s_werks
      AND makt~spras = @sy-langu.

  LOOP AT gt_data ASSIGNING FIELD-SYMBOL(<gfs_data>).
    <gfs_data>-status = '@09@'.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_fcat .

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'ZAB_S_0008'
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1                " Call parameter combination error
      program_error          = 2                " Program Errors
      OTHERS                 = 3.

  LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'MAKT1'.
        <gfs_fcat>-outputlen ='26'.
        <gfs_fcat>-edit ='X'.
      WHEN 'MEINS'.
        <gfs_fcat>-no_out = 'X'.
      WHEN 'BRGEW'.
        <gfs_fcat>-no_out = 'X'.
      WHEN 'MSTAE'.
        <gfs_fcat>-no_out = 'X'.
      WHEN 'GEWEI'.
        <gfs_fcat>-no_out = 'X'.
    ENDCASE.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_set_layout
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_set_layout .

  CLEAR : gs_layout.
  gs_layout-zebra = 'X'.
*  gs_layout-sel_mode  = 'A'.
*  gs_layout-cwidth_opt = 'X'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_display_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_display_alv .

  CREATE OBJECT go_cust
    EXPORTING
      container_name = 'CC_ALV'.

  CREATE OBJECT go_alv
    EXPORTING
      i_parent = go_cust.

  CREATE OBJECT go_event_receiver.

  SET HANDLER go_event_receiver->handle_toolbar
              go_event_receiver->handle_data_changed FOR go_alv.

  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
      is_layout       = gs_layout
    CHANGING
      it_outtab       = gt_data
      it_fieldcatalog = gt_fcat.

  CALL METHOD go_alv->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_enter.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_refresh_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_refresh_alv .

  DATA: ls_stable TYPE lvc_s_stbl.
  CLEAR:ls_stable.

  ls_stable-row = 'X'.
  ls_stable-col = 'X'.

  CALL METHOD go_alv->refresh_table_display
    EXPORTING
      is_stable      = ls_stable
      i_soft_refresh = 'X'
    EXCEPTIONS
      finished       = 1
      OTHERS         = 2.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_send_email
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_send_email USING p_er_data_changed TYPE REF TO cl_alv_changed_data_protocol.

  DATA : lv_context     TYPE string,
         lv_context_all TYPE string.
  DATA : lt_receiver TYPE TABLE OF somlreci1,
         ls_receiver TYPE somlreci1.

  DATA : lt_contents TYPE TABLE OF  solisti1,
         ls_contents TYPE solisti1.

  DATA : lt_itab TYPE TABLE OF zab_s_0009,
         ls_itab TYPE  zab_s_0009.

  DATA : lv_add TYPE spop-varvalue1.

  CLEAR : ls_receiver, ls_contents, ls_itab.

  CALL FUNCTION 'POPUP_TO_GET_ONE_VALUE'
    EXPORTING
      textline1      = TEXT-002
*     TEXTLINE2      = ' '
*     TEXTLINE3      = ' '
      titel          = TEXT-003
      valuelength    = 35
    IMPORTING
*     ANSWER         =
      value1         = lv_add
    EXCEPTIONS
      titel_too_long = 1
      OTHERS         = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  TRANSLATE lv_add TO LOWER CASE.

  ls_receiver-receiver = lv_add.
  APPEND ls_receiver TO lt_receiver.

  LOOP AT gt_ind INTO gs_ind.

    READ TABLE gt_data INTO gs_data INDEX gs_ind-gv_ind.

    ls_itab-matnr        = gs_data-matnr.
    ls_itab-maktx        = gs_data-maktx.
    ls_itab-werks        = gs_data-werks.
    ls_itab-name1        = gs_data-name1.

    APPEND ls_itab TO lt_itab.

    CONCATENATE lv_context gs_data-matnr ',' INTO lv_context SEPARATED BY space.
  ENDLOOP.
  CONCATENATE lv_context TEXT-004
  INTO lv_context_all SEPARATED BY space.

  ls_contents-line = lv_context_all.
  APPEND ls_contents TO lt_contents.

  CALL FUNCTION 'ZIMP_GLOBAL_F_0002'
    EXPORTING
      iv_subject        = TEXT-005
      iv_sender         = 'ab@improva.com.tr'
      it_contents       = lt_contents
      iv_table_type     = 'ZAB_S_0009'
      iv_commit_work    = 'X'
    TABLES
      it_internal_table = lt_itab
      it_receivers      = lt_receiver
    EXCEPTIONS
      err_sendmail      = 1
      OTHERS            = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_batch_input
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_batch_input USING p_er_data_changed TYPE REF TO cl_alv_changed_data_protocol.

  DATA : ls_modi TYPE lvc_s_modi.
  CLEAR : ls_modi.

  LOOP AT p_er_data_changed->mt_good_cells INTO ls_modi.

    READ TABLE gt_data INTO gs_data INDEX ls_modi-row_id.
    CLEAR : gt_bdcdata , gt_messtab.

    PERFORM bdc_dynpro      USING 'SAPLMGMM' '0060'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RMMG1-MATNR'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=ENTR'.
    PERFORM bdc_field       USING 'RMMG1-MATNR'
                                  gs_data-matnr.
    PERFORM bdc_dynpro      USING 'SAPLMGMM' '0070'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'MSICHTAUSW-DYTXT(01)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=ENTR'.
    PERFORM bdc_field       USING 'MSICHTAUSW-KZSEL(01)'
                                  'X'.
    PERFORM bdc_dynpro      USING 'SAPLMGMM' '4004'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=BU'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'MAKT-MAKTX'.
    PERFORM bdc_field       USING 'MAKT-MAKTX'
                                  ls_modi-value.
    PERFORM bdc_field       USING 'MARA-MEINS'
                                  gs_data-meins.
    PERFORM bdc_field       USING 'MARA-MSTAE'
                                  gs_data-mstae.
    PERFORM bdc_field       USING 'MARA-BRGEW'
                                  gs_data-brgew.
    PERFORM bdc_field       USING 'MARA-GEWEI'
                                  gs_data-gewei.

    CALL TRANSACTION 'MM02' WITH AUTHORITY-CHECK USING gt_bdcdata
                         MODE 'A'
                         MESSAGES INTO gt_messtab.

    LOOP AT gt_messtab INTO DATA(ls_messtab) WHERE ( msgtyp EQ 'E'
                                                  OR msgtyp EQ 'A'
                                                  OR msgtyp EQ 'X').
      EXIT.
    ENDLOOP.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      gs_data-status = '@0A@'.
    ELSE.
      COMMIT WORK.
      gs_data-status = '@08@'.
      gs_data-maktx = ls_modi-value.
      gs_ind-gv_ind = ls_modi-row_id.
      APPEND gs_ind TO gt_ind.
    ENDIF.
    MODIFY gt_data FROM gs_data INDEX ls_modi-row_id.
  ENDLOOP.
  gv_index = ls_modi-row_id.
  CLEAR : ls_modi.
  PERFORM f_refresh_alv.

ENDFORM.

FORM bdc_dynpro USING program dynpro.
  CLEAR gs_bdcdata.
  gs_bdcdata-program  = program.
  gs_bdcdata-dynpro   = dynpro.
  gs_bdcdata-dynbegin = 'X'.
  APPEND gs_bdcdata TO gt_bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
  CLEAR gs_bdcdata.
  gs_bdcdata-fnam = fnam.
  gs_bdcdata-fval = fval.
  APPEND gs_bdcdata TO gt_bdcdata.
ENDFORM.
