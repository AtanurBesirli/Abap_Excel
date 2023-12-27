*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0029
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0029.

CLASS : lcl_customer DEFINITION DEFERRED,
        lcl_employee DEFINITION DEFERRED.

DATA : go_cust TYPE REF TO lcl_customer,
       go_emp TYPE REF TO lcl_employee.

INTERFACE lif_person.
  METHODS :
*    get_list RETURNING VALUE(rt_list) TYPE scarr,
    get_pers_count RETURNING VALUE(rv_pers_count) TYPE i.

  DATA : lv_pers_count TYPE i.

ENDINTERFACE.

CLASS lcl_customer DEFINITION.
  PUBLIC SECTION.
    METHODS :
      constructor.
    INTERFACES lif_person.
ENDCLASS.

CLASS lcl_customer IMPLEMENTATION.
  METHOD constructor.
    lif_person~lv_pers_count = 5.
  ENDMETHOD.

  METHOD lif_person~get_pers_count.
    rv_pers_count = lif_person~lv_pers_count.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_employee DEFINITION.
  PUBLIC SECTION.
    METHODS :
      constructor.
    INTERFACES lif_person.
ENDCLASS.

CLASS lcl_employee IMPLEMENTATION.
  METHOD constructor.
    lif_person~lv_pers_count = 10.
  ENDMETHOD.

  METHOD lif_person~get_pers_count.
    rv_pers_count = lif_person~lv_pers_count.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

CREATE OBJECT go_cust.
CREATE OBJECT go_emp.

WRITE : go_cust->lif_person~get_pers_count( ).
WRITE : go_emp->lif_person~get_pers_count( ).
