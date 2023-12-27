*&---------------------------------------------------------------------*
*& Include          ZAB_EDU_0031_CLS
*&---------------------------------------------------------------------*

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS : sum_numbers IMPORTING iv_num1 TYPE i
                                    iv_num2 TYPE i
                          EXPORTING ev_sum  TYPE i.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  iv_num1 = p_num1.
  iv_num2 = p_num2.
  METHOD sum_numbers.

    ev_sum = iv_num1 + iv_num2.
WRITE ev_sum.
  ENDMETHOD.

ENDCLASS.
