*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0049
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0049.

DATA : lv_data TYPE char16,
       lv_data1 TYPE char16.
*DATA(lv_hide) = '********'.
*DATA : gt_scarr TYPE TABLE OF scarr.

*lv_data = '1234567890123456'.

SELECT * FROM scarr INTO TABLE @data(gt_scarr).
*SELECT mandt,
*       CARRID,
*       RIGHT( carrname, 5 ),
*       currcode FROM scarr INTO TABLE @gt_scarr.

*DATA(lv_top4) = lv_data+0(4).
*DATA(lv_last4) = lv_data+12(4).
*CONCATENATE lv_top4 lv_hide lv_last4 INTO lv_data1.
LOOP AT gt_scarr INTO DATA(gs_scarr).
read TABLE gt_scarr INTO DATA(ls_scarr) WITH KEY currcode+2(1) = 'D'.
IF sy-subrc eq 0.
  lv_data = ls_scarr-currcode.
ENDIF.
ENDLOOP.

BREAK-POINT.
