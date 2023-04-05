*&---------------------------------------------------------------------*
*& Include          ZAB_I_0004_FRM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form f_get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_data .

  SELECT vbak~vbeln  ,
         vbak~auart  ,
         vbak~vbtyp  ,
         vbak~erdat  ,
         vbak~kunnr  ,
         vbak~trvog  ,
         vbap~matnr  ,
         vbap~werks  ,
         vbap~lgort  ,
         kna1~name1  ,
         mara~mtart  ,
         makt~maktx  ,
         vbap~posnr  ,
         vbap~kwmeng ,
         vbap~meins UP TO 33 ROWS
    FROM vbak
    INNER JOIN vbap ON vbap~vbeln EQ vbak~vbeln
    INNER JOIN kna1 ON kna1~kunnr EQ vbak~kunnr
    INNER JOIN mara ON mara~matnr EQ vbap~matnr
    LEFT  JOIN makt ON makt~matnr EQ mara~matnr
    INTO TABLE @gt_data
    WHERE vbak~auart = @p_auart
    AND  vbak~vbeln IN @so_vbeln
    AND  vbak~vbtyp IN @so_vbtyp
    AND  vbak~erdat IN @so_erdat
    AND  vbak~kunnr IN @so_kunnr
    AND  vbak~trvog IN @so_trvog
    AND  vbap~matnr IN @so_matnr
    AND  vbap~werks IN @so_werks
    AND  vbap~lgort IN @so_lgort
    AND  makt~spras = @sy-langu
    .

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
      i_structure_name       = 'ZAB_S_0005'
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1                " Call parameter combination error
      program_error          = 2                " Program Errors
      OTHERS                 = 3.

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
  gs_layout-sel_mode  = 'A'.
  gs_layout-cwidth_opt = 'X'.

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
              go_event_receiver->handle_user_command FOR go_alv.

  CALL METHOD go_alv->set_table_for_first_display
    EXPORTING
      is_layout       = gs_layout
    CHANGING
      it_outtab       = gt_data
      it_fieldcatalog = gt_fcat.

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
  CALL SCREEN '100'.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_print
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_smartform_print .

  DATA : lv_fname          TYPE rs38l_fnam.
  DATA : lv_devtype        TYPE rspoptype.
  DATA : ls_control_param  TYPE ssfctrlop.
  DATA : ls_composer_param TYPE ssfcompop.

  DATA : lv_ttl TYPE i.

  LOOP AT gt_data INTO gs_data.
    lv_ttl += gs_data-posnr.
  ENDLOOP.

  ls_control_param-device     = 'PRINTER'.
  ls_control_param-no_dialog  = 'X'.
  ls_control_param-preview    = 'X'.
  ls_composer_param-tdnewid   = 'X'.
  ls_composer_param-tdimmed   = 'X'.
  ls_composer_param-tddest    = 'LP01'.


  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZSF_AB_0002'
    IMPORTING
      fm_name            = lv_fname
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.

  CALL FUNCTION lv_fname
    EXPORTING
      control_parameters = ls_control_param
      output_options     = ls_composer_param
      user_settings      = ' '
      it_data            = gt_data
      gv_ttl             = lv_ttl
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_adobe_print
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_adobe_print .

  DATA: lt_itab TYPE TABLE OF zab_s_0002.

  MOVE-CORRESPONDING gt_data TO lt_itab.

  DATA: fm_name         TYPE rs38l_fnam,
        fp_docparams    TYPE sfpdocparams,
        fp_outputparams TYPE sfpoutputparams.

  fp_outputparams-nodialog = 'X'.
  fp_outputparams-preview = 'X'.
  fp_outputparams-dest = 'LP01'.

  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = fp_outputparams
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = 'ZAB_AF_0002'
    IMPORTING
      e_funcname = fm_name.

  CALL FUNCTION fm_name
    EXPORTING
      it_data        = lt_itab
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.

  CALL FUNCTION 'FP_JOB_CLOSE'
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_add_toolbar_button
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> E_OBJECT
*&---------------------------------------------------------------------*
FORM f_add_toolbar_button  USING    p_e_object TYPE REF TO cl_alv_event_toolbar_set.

  DATA : ls_toolbar TYPE stb_button.

  CLEAR : ls_toolbar.
  ls_toolbar-function = '&PRI'.
  ls_toolbar-text     = TEXT-005.
  ls_toolbar-icon     = '@0X@'.
  ls_toolbar-quickinfo = TEXT-003.
  APPEND ls_toolbar TO p_e_object->mt_toolbar.

  CLEAR : ls_toolbar.
  ls_toolbar-function = '&PRIN'.
  ls_toolbar-text     = TEXT-005.
  ls_toolbar-icon     = '@0X@'.
  ls_toolbar-quickinfo = TEXT-004.
  APPEND ls_toolbar TO p_e_object->mt_toolbar.

ENDFORM.
