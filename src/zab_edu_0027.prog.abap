*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0027
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0027.

DATA : gv_mult TYPE int4.
CLASS lcl_main DEFINITION DEFERRED.
DATA : go_main TYPE REF TO lcl_main.

PARAMETERS : p_num1 TYPE int4,
             p_num2 TYPE int4.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS : sum_numbers,
      sub_numbers,
      mul_numbers IMPORTING iv_num1 TYPE int4
                            iv_num2 TYPE int4
                  EXPORTING ev_mult TYPE int4,
      div_numbers IMPORTING iv_num3 TYPE int4
                            iv_num4 TYPE int4
                  EXPORTING ev_div  TYPE int4.

    DATA : lv_sum TYPE int4,
           lv_sub TYPE int4.
ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  METHOD sum_numbers.

    lv_sum = p_num1 + p_num2.

  ENDMETHOD.

  METHOD sub_numbers.

    lv_sub = p_num1 - p_num2.
  ENDMETHOD.

  METHOD mul_numbers.
    ev_mult = iv_num1 * iv_num2.
  ENDMETHOD.

  METHOD div_numbers.
    ev_div = iv_num3 / iv_num4.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  CREATE OBJECT go_main.

*  go_main->mul_numbers(
*    EXPORTING
*      iv_num1 = p_num1
*      iv_num2 = p_num2
*    IMPORTING
*      ev_mult = gv_mult
*  ).
*  WRITE : gv_mult.

  go_main->div_numbers(
    EXPORTING
      iv_num3 = p_num1
      iv_num4 = p_num2
    IMPORTING
      ev_div  = gv_mult
  ).
  WRITE : gv_mult.
