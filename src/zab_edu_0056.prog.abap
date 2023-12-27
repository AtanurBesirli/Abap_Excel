*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0056
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0056.

*TYPES : BEGIN OF gty_data,
*          no   TYPE i,
*          name TYPE char10,
*          desc TYPE char20,
*        END OF gty_data.
*
*DATA : gt_data TYPE TABLE OF gty_data,
*       gs_data TYPE gty_data.
*
*gs_data-no      = 1.
*gs_data-name    = 'samsung'.
*gs_data-desc    = 'tel'.
*APPEND gs_data TO gt_data.
*
*gs_data-no      = 2.
*gs_data-name    = 'zamsung'.
*gs_data-desc    = 'ztel'.
*APPEND gs_data TO gt_data.
*
**LOOP AT gt_data INTO gs_data WHERE no eq 3.
**  gs_data-no      = 5.
**  gs_data-name    = 'zfamsung'.
**  gs_data-desc    = 'ftel'.
**  MODIFY gt_data FROM gs_data .
**ENDLOOP.
*
*gs_data-no      = 5.
*gs_data-name    = 'zfamsung'.
*gs_data-desc    = 'ftel'.
*READ TABLE gt_data INTO gs_data WITH KEY no = gs_data-no.
*IF sy-subrc EQ 0.
*  MODIFY gt_data FROM gs_data TRANSPORTING no.
*ELSE.
*  APPEND gs_data TO gt_data.
*ENDIF.
*
*BREAK-POINT.

*DATA: t0    TYPE i,
*      t5    TYPE i,
*      no    TYPE i VALUE 100,
*      ni    TYPE i VALUE 1000.
*
*TYPES : BEGIN OF lty_data,
*          matnr TYPE matnr,
*          ernam TYPE ernam,
*          mtart TYPE mtart,
*        END OF lty_data.
*
*DATA : lt_data TYPE TABLE OF lty_data,
*       ls_data TYPE lty_data..
*
*GET RUN TIME FIELD DATA(t1).
*
*  SELECT matnr ernam mtart
*    FROM mara INTO TABLE lt_data.
**  ENDSELECT.
*
* GET RUN TIME FIELD DATA(t2).
*
*
*GET RUN TIME FIELD DATA(t3).
*
*  SELECT * FROM mara INTO CORRESPONDING FIELDS OF TABLE lt_data.
**    ENDSELECT.
*
*GET RUN TIME FIELD DATA(t4).
*
* t0 = t2 - t1.
* t5 = t4 - t3 .
*
*DATA(tm) = CONV decfloat34( t0 / ni / no ).
*DATA(tm1) = CONV decfloat34( t5 / ni / no ).
*
*  BREAK-POINT.

*data(lv) = '1234567890123456'.
*data(lv_1) = lv+6(10).
*WRITE lv_1.

*data : lv TYPE char16.
*data : lv1 TYPE char10.
*data(lv) = '1110000000000001'.
*lv1 = lv+6(10).
*write lv1.

data(lv) = sy-datum+0(4).
write lv.
