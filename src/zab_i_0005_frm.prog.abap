*&---------------------------------------------------------------------*
*& Include          ZSD_P_AB01_FRM
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

  IF go_alv IS INITIAL.

    PERFORM f_create_grid.

    CREATE OBJECT go_event_receiver.

    SET HANDLER go_event_receiver->handle_hotspot_click FOR go_alv.
    SET HANDLER go_event_receiver->handle_button_click FOR go_alv2.

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
  ELSE.
    CALL METHOD go_alv->refresh_table_display.

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
FORM f_get_data .

  DATA: lv_vbtyp_n TYPE vbtyp_n.
  lv_vbtyp_n = 'J'.

  SELECT  likp~vbeln,
          lips~posnr,
          likp~kunnr,
          kna1~name1,
          likp~kunag,
          vbap~matnr,
          lips~lfimg,
          lips~meins,
          vbak~vbeln AS vbeln2,
          vbap~posnr AS posnr1,
          vbak~erdat,
          vbap~kwmeng,
          vbap~vrkme,
          vbfa~vbeln AS vbeln3
    FROM likp
    INNER JOIN lips ON likp~vbeln EQ lips~vbeln
    LEFT  JOIN vbak ON likp~vbeln EQ vbak~vbeln
    LEFT  JOIN vbfa ON likp~vbeln EQ vbfa~vbeln
    LEFT  JOIN vbap ON vbfa~vbelv EQ vbap~vbeln AND vbfa~posnv EQ vbap~posnr
    LEFT  JOIN kna1 ON likp~kunnr EQ kna1~kunnr
    INTO  CORRESPONDING FIELDS OF TABLE @gt_list
    WHERE likp~vbeln IN @so_vbeln
    AND   likp~wadat IN @so_wadat
    AND   vbap~matnr IN @so_matnr
    AND   vbak~vbeln IN @so_vbel2
*    AND   vbfa~vbtyp_n = lv_vbtyp_n        ""'J'
*    AND   vbfa~vbtyp_v = 'C'
    .

  IF gt_list IS NOT INITIAL.

    SELECT kunnr, name1 FROM kna1
    INTO TABLE @DATA(lt_name2)
    FOR ALL ENTRIES IN @gt_list
    WHERE kunnr = @gt_list-kunag.

    SORT lt_name2 BY kunnr.
  ENDIF.

  LOOP AT gt_list INTO DATA(ls_list).
    READ TABLE lt_name2 INTO DATA(ls_name2) WITH KEY kunnr = ls_list-kunnr.
    ls_list-name2 = ls_name2-name1.
    MODIFY gt_list FROM ls_list.
  ENDLOOP.

  LOOP AT gt_list ASSIGNING <gfs_list>.
    <gfs_list>-delete = '@11@'.

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
      i_structure_name       = 'ZAB_S_HW_0001'
*     I_INTERNAL_TABNAME     = 'GT_LIST'
    CHANGING
      ct_fieldcat            = gt_fcat
    EXCEPTIONS
      inconsistent_interface = 1                " Call parameter combination error
      program_error          = 2                " Program Errors
      OTHERS                 = 3.

  LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'VBELN'.
        <gfs_fcat>-hotspot   = 'X'.
        <gfs_fcat>-outputlen = 8.
      WHEN 'POSNR'.
        <gfs_fcat>-outputlen = 5.
      WHEN 'KUNNR'.
        <gfs_fcat>-outputlen = 9.
      WHEN 'NAME1'.
        <gfs_fcat>-outputlen = 10.
      WHEN 'KUNAG'.
        <gfs_fcat>-outputlen = 10.
      WHEN 'NAME2'.
        <gfs_fcat>-outputlen = 10.
      WHEN 'WADAT'.
        <gfs_fcat>-outputlen = 10.
      WHEN 'LFIMG'.
        <gfs_fcat>-outputlen = 10.
      WHEN 'MEINS'.
        <gfs_fcat>-outputlen = 5.
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
      i_structure_name       = 'ZAB_S_HW_0002'
*     I_INTERNAL_TABNAME     =
    CHANGING
      ct_fieldcat            = gt_fcat2
    EXCEPTIONS
      inconsistent_interface = 1                " Call parameter combination error
      program_error          = 2                " Program Errors
      OTHERS                 = 3.

  CLEAR : gs_fcat.
  gs_fcat-fieldname = 'DELETE'.
  gs_fcat-scrtext_s = 'SİL'.
  gs_fcat-style     = cl_gui_alv_grid=>mc_style_button.
  gs_fcat-icon      = 'X'.
  APPEND gs_fcat TO gt_fcat2.

  LOOP AT gt_fcat2 ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'DELETE'.
        <gfs_fcat>-outputlen = 2.
      WHEN 'VBELN'.
        <gfs_fcat>-outputlen = 15.
      WHEN 'POSNR'.
        <gfs_fcat>-outputlen = 10.
      WHEN 'MATNR'.
        <gfs_fcat>-outputlen = 15.
      WHEN 'ERDAT'.
        <gfs_fcat>-outputlen = 10.
      WHEN 'KWMENG'.
        <gfs_fcat>-outputlen = 10.
      WHEN 'VRKME'.
        <gfs_fcat>-outputlen = 10.
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
  gs_layout-cwidth_opt = 'X'.
  gs_layout-zebra = 'X'.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form f_init_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
*FORM f_init_alv .
*  perform f_create_grid.
*  perform set_fcat.
*  perform f_display_alv.
*
*ENDFORM.
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
  gs_layout2-zebra      = 'X'.
  gs_layout2-no_toolbar = 'X'.
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
        rows    = 1
        columns = 2.

    CALL METHOD go_splitter->get_container
      EXPORTING
        row       = 1
        column    = 1
      RECEIVING
        container = go_gui1.

    CALL METHOD go_splitter->get_container
      EXPORTING
        row       = 1
        column    = 2
      RECEIVING
        container = go_gui2.

    CREATE OBJECT go_alv
      EXPORTING
        i_parent = go_gui1.

    CREATE OBJECT go_alv2
      EXPORTING
        i_parent = go_gui2.

ENDFORM.
