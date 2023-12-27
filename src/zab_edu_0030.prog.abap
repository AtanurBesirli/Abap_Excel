*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0030
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0030.

CLASS : lcl_auto_credit DEFINITION DEFERRED,
        lcl_mortgage_credit DEFINITION DEFERRED,
        lcl_main DEFINITION DEFERRED.

DATA : go_auto     TYPE REF TO lcl_auto_credit,
       go_mortgage TYPE REF TO lcl_mortgage_credit,
       go_main     TYPE REF TO lcl_main.

CLASS lcl_credit DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS:
      credit_type ABSTRACT,
      credit_lim ABSTRACT.
ENDCLASS.

CLASS lcl_auto_credit DEFINITION INHERITING FROM lcl_credit.
  PUBLIC SECTION.
    METHODS:
      credit_type REDEFINITION,
      credit_lim REDEFINITION.

ENDCLASS.

CLASS lcl_auto_credit IMPLEMENTATION.
  METHOD credit_type.
    WRITE : 'Auto loan'.
  ENDMETHOD.

  METHOD credit_lim.
    WRITE : '1 million'.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_mortgage_credit DEFINITION INHERITING FROM lcl_credit.
  PUBLIC SECTION.
    METHODS:
      credit_type REDEFINITION,
      credit_lim REDEFINITION.

ENDCLASS.

CLASS lcl_mortgage_credit IMPLEMENTATION.
  METHOD credit_type.
    WRITE : 'Mortgage'.
  ENDMETHOD.

  METHOD credit_lim.
    WRITE : '20 million'.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS :
      get_credit IMPORTING io_credit TYPE REF TO lcl_credit.

ENDCLASS.

CLASS lcl_main IMPLEMENTATION.
  METHOD get_credit.
    WRITE : 'The upper limit of the'.
    io_credit->credit_type( ).
    WRITE : 'is'.
    io_credit->credit_lim( ).
    WRITE : 'dollars'.
    NEW-LINE.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.

  CREATE OBJECT : go_main,
                  go_auto,
                  go_mortgage.

  go_main->get_credit( io_credit = go_auto ).
  go_main->get_credit( io_credit = go_mortgage ).
