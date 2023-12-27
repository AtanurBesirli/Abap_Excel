*&---------------------------------------------------------------------*
*& Include          ZAB_EDU_0028_CLS1
*&---------------------------------------------------------------------*

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS : sum_numbers IMPORTING iv_num1 TYPE i
                                    iv_num2 TYPE i
                          EXPORTING ev_sum  TYPE i.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.

  METHOD sum_numbers.

    ev_sum = iv_num1 + iv_num2.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_local DEFINITION INHERITING FROM lcl_main.
  PUBLIC SECTION.
    METHODS : div_numbers IMPORTING iv_num3 TYPE i
                                    iv_num4 TYPE i
                          EXPORTING ev_sum1 TYPE i.

ENDCLASS.

CLASS lcl_local IMPLEMENTATION.
  METHOD div_numbers.
    ev_sum1 = iv_num3 / iv_num4.
  ENDMETHOD.
ENDCLASS.


*DATA(lo_local) = NEW lcl_local( ). = class tanımlama ve create object birleşimi local olarak.
