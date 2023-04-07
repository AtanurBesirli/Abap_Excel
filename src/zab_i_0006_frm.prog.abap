*&---------------------------------------------------------------------*
*& Include          ZAB_I_0006_FRM
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

  DATA : lt_mard TYPE TABLE OF gty_mard,
         ls_mard TYPE gty_mard.

  DATA : lt_mchb TYPE TABLE OF gty_mchb,
         ls_mchb TYPE gty_mchb.

  IF so_matkl IS NOT INITIAL.

    SELECT mara~matnr,
           mara~matkl
     FROM  mara INTO TABLE @DATA(lt_data)
     WHERE mara~matkl IN @so_matkl
     AND   mara~matnr IN @so_matnr
     AND   mara~xchpf = ' '.

    SELECT mara~matnr,
           mara~matkl
     FROM  mara INTO TABLE @DATA(lt_data1)
     WHERE mara~matkl IN @so_matkl
     AND   mara~matnr IN @so_matnr
     AND   mara~xchpf = 'X'.

  ELSEIF so_mtart IS NOT INITIAL.

    SELECT mara~matnr,
           mara~mtart
     FROM  mara INTO TABLE @lt_data
     WHERE mara~mtart IN @so_mtart
     AND   mara~matnr IN @so_matnr
     AND   mara~xchpf = ' '.

    SELECT mara~matnr,
           mara~mtart
     FROM  mara INTO TABLE @lt_data1
     WHERE mara~mtart IN @so_mtart
     AND   mara~matnr IN @so_matnr
     AND   mara~xchpf = 'X'.
  ELSE.
    MESSAGE TEXT-002 TYPE 'S' DISPLAY LIKE 'W'.
  ENDIF.

  IF lt_data IS NOT INITIAL.

    SELECT mard~werks ,
           mard~lgort ,
           mara~matnr ,
           mara~matkl ,
           mara~mtart ,
           makt~maktx ,
           mard~labst ,
           mard~insme ,
          t023t~wgbez ,
           mara~meins
    FROM mard
    INNER JOIN mara ON mara~matnr EQ mard~matnr
    LEFT  JOIN makt ON makt~matnr EQ mard~matnr
    LEFT  JOIN t023t ON t023t~matkl EQ mara~matkl
    INTO TABLE @lt_mard
    FOR ALL ENTRIES IN @lt_data
    WHERE mara~matnr EQ @lt_data-matnr .

    DATA : lt_mard_collect LIKE lt_mard,
           ls_mard_collect LIKE LINE OF lt_mard_collect.

    LOOP AT lt_mard INTO ls_mard.
      ls_mard_collect-matnr = ls_mard-matnr.
      ls_mard_collect-werks = ls_mard-werks.
      ls_mard_collect-labst = ls_mard-labst.
      ls_mard_collect-insme = ls_mard-insme.
      COLLECT ls_mard_collect INTO lt_mard_collect.

    ENDLOOP.
    SORT lt_mard BY werks matnr.
    SORT lt_mard_collect BY werks matnr.
    DELETE ADJACENT DUPLICATES FROM lt_mard COMPARING werks matnr.
    LOOP AT lt_mard INTO ls_mard.
      LOOP AT lt_mard_collect INTO ls_mard_collect WHERE matnr = ls_mard-matnr
                                                     AND werks = ls_mard-werks.
        ls_mard-labst = ls_mard_collect-labst.
        ls_mard-insme = ls_mard_collect-insme.
        MODIFY lt_mard FROM ls_mard.
      ENDLOOP.
    ENDLOOP.
  ENDIF.

  IF lt_data1 IS NOT INITIAL.

    SELECT mchb~werks ,
       mchb~lgort ,
       mara~matnr ,
       mara~matkl ,
       mara~mtart ,
       makt~maktx ,
       mchb~charg ,
       mchb~clabs ,
       mchb~cinsm ,
      t023t~wgbez ,
       mara~meins
FROM mchb
INNER JOIN mara ON mara~matnr EQ mchb~matnr
LEFT  JOIN makt ON makt~matnr EQ mchb~matnr
LEFT JOIN t023t ON t023t~matkl EQ mara~matkl
INTO TABLE @lt_mchb
FOR ALL ENTRIES IN @lt_data1
WHERE mara~matnr EQ @lt_data1-matnr .

    DATA : lt_mchb_collect LIKE lt_mchb,
           ls_mchb_collect LIKE LINE OF lt_mchb_collect.

    LOOP AT lt_mchb INTO ls_mchb.
      ls_mchb_collect-matnr = ls_mchb-matnr.
      ls_mchb_collect-werks = ls_mchb-werks.
      ls_mchb_collect-charg = ls_mchb-charg.
      ls_mchb_collect-clabs = ls_mchb-clabs.
      ls_mchb_collect-cinsm = ls_mchb-cinsm.
      COLLECT ls_mchb_collect INTO lt_mchb_collect.

    ENDLOOP.
    SORT lt_mchb BY werks matnr charg.
    SORT lt_mchb_collect BY werks matnr charg.
    DELETE ADJACENT DUPLICATES FROM lt_mchb COMPARING werks matnr charg.
    LOOP AT lt_mchb INTO ls_mchb.
      LOOP AT lt_mchb_collect INTO ls_mchb_collect WHERE matnr = ls_mchb-matnr
                                                     AND werks = ls_mchb-werks
                                                     AND charg = ls_mchb-charg.
        ls_mchb-clabs = ls_mchb_collect-clabs.
        ls_mchb-cinsm = ls_mchb_collect-cinsm.
        MODIFY lt_mchb FROM ls_mchb.
      ENDLOOP.
    ENDLOOP.

  ENDIF.

  MOVE-CORRESPONDING lt_mard TO gt_data.
  LOOP AT lt_mchb INTO ls_mchb.
    gs_data-matnr = ls_mchb-matnr.
    gs_data-werks = ls_mchb-werks.
    gs_data-maktx = ls_mchb-maktx.
    gs_data-insme = ls_mchb-cinsm.
    gs_data-labst = ls_mchb-clabs.
    gs_data-matkl = ls_mchb-matkl.
    gs_data-meins = ls_mchb-meins.
    gs_data-mtart = ls_mchb-mtart.
    gs_data-wgbez = ls_mchb-wgbez.
    APPEND gs_data TO gt_data.
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
      i_structure_name = 'ZAB_S_0006'
    CHANGING
      ct_fieldcat      = gt_fcat.

  LOOP AT gt_fcat ASSIGNING <gfs_fcat>.
    CASE <gfs_fcat>-fieldname.
      WHEN 'WERKS'.
        <gfs_fcat>-outputlen = 14.
      WHEN 'MATNR'      .
        <gfs_fcat>-outputlen = 18.
      WHEN 'MAKTX'      .
        <gfs_fcat>-outputlen = 27.
      WHEN 'MTART'      .
        <gfs_fcat>-outputlen = 14.
      WHEN 'MATKL'      .
        <gfs_fcat>-outputlen = 14.
      WHEN 'WGBEZ'      .
        <gfs_fcat>-outputlen = 14.
      WHEN 'LABST'      .
        <gfs_fcat>-outputlen = 14.
      WHEN 'INSME'      .
        <gfs_fcat>-outputlen = 14.
      WHEN 'MEINS'.
        <gfs_fcat>-outputlen = 14.
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
  gs_layout-sel_mode  = 'A'.
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

  CREATE OBJECT go_alv
    EXPORTING
      i_parent = cl_gui_container=>screen0.


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

  CALL SCREEN '0100'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form f_get_data1
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM f_get_data1 .

*  SELECT mard~werks ,
*         mard~lgort ,
*         mara~matnr ,
*         makt~maktx ,
*         mara~mtart ,
*         mara~matkl ,
*         t023t~wgbez,
*         mard~labst ,
*         mard~insme ,
*         mara~meins ,
*         mara~xchpf
*  FROM mara
*  INNER JOIN mard ON mard~matnr EQ mara~matnr
*  INNER JOIN makt ON makt~matnr EQ mard~matnr
*  LEFT JOIN t023t ON t023t~matkl EQ mara~matkl
*  INTO CORRESPONDING FIELDS OF TABLE @gt_data
*  WHERE mard~werks = @p_werks
*  AND mara~matnr IN @so_matnr
*  AND mara~mtart IN @so_mtart
*  AND mara~matkl IN @so_matkl
*  AND t023t~spras = @sy-langu.
*
*  DATA : lv_data  TYPE labst,
*         lv_data1 TYPE i.
*
*  LOOP AT gt_data INTO gs_data
*       GROUP BY  ( matnr = gs_data-matnr
*                   werks = gs_data-werks )
*        ASCENDING.
*    CLEAR : lv_data, lv_data1.
*    LOOP AT GROUP gs_data ASSIGNING FIELD-SYMBOL(<lfs_data>).
*      lv_data += <lfs_data>-labst.
*      lv_data1 += <lfs_data>-insme.
*
*    ENDLOOP.
*    READ TABLE gt_data ASSIGNING <lfs_data> WITH KEY matnr = gs_data-matnr
*                                                     werks = gs_data-werks.
*    <lfs_data>-labst = lv_data.
*    <lfs_data>-insme = lv_data1.
*
*  ENDLOOP.
*
*  IF gt_data IS NOT INITIAL.
*    SELECT matnr, werks, charg, clabs, cinsm FROM mchb
*      FOR ALL ENTRIES IN @gt_data
*      WHERE matnr EQ @gt_data-matnr
*      INTO TABLE @DATA(lt_data).
*  ENDIF.
*
*  DATA : lv_data2 TYPE i,
*         lv_data3 TYPE i.
*
*  LOOP AT lt_data INTO DATA(ls_data)
*       GROUP BY  ( matnr = ls_data-matnr
*                   werks = ls_data-werks )
*        ASCENDING.
*    CLEAR : lv_data2, lv_data3.
*    LOOP AT GROUP ls_data ASSIGNING FIELD-SYMBOL(<lfs_dat>).
*      lv_data2 += <lfs_dat>-clabs.
*      lv_data3 += <lfs_dat>-cinsm.
*
*    ENDLOOP.
*
*    READ TABLE lt_data ASSIGNING <lfs_dat> WITH KEY matnr = gs_data-matnr
*                                                    werks = gs_data-werks.
*    <lfs_dat>-clabs = lv_data2.
*    <lfs_dat>-cinsm = lv_data3.
*
*    LOOP AT gt_data INTO gs_data WHERE "matnr = <lfs_dat>-matnr
*                                    xchpf = 'X'.
*      LOOP AT  lt_data INTO ls_data WHERE matnr = gs_data-matnr.
*
*        gs_data-labst = ls_data-clabs.
*        gs_data-insme = ls_data-cinsm.
*        MODIFY gt_data FROM gs_data.
*
*      ENDLOOP.
**    READ TABLE lt_data INTO ls_data WITH KEY matnr = gs_data-matnr
**                                                 werks = gs_data-werks.
**        gs_data-labst = ls_data-clabs.
**        gs_data-insme = ls_data-cinsm.
**        MODIFY gt_data FROM gs_data.
*
*    ENDLOOP.
*  ENDLOOP.
*
*  DELETE ADJACENT DUPLICATES FROM gt_data COMPARING werks matnr.
ENDFORM.
