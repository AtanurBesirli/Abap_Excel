*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0042
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_0042.

CLASS lcl_reduce DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS: start.

ENDCLASS.

CLASS lcl_reduce IMPLEMENTATION.

  METHOD start.

    TYPES:
      BEGIN OF ty_s_collect,
        carrid     TYPE s_carr_id,
        connid     TYPE s_conn_id,
        paymentsum TYPE s_sum,
        seatsmax_b TYPE	s_smax_b,
        seatsocc_b TYPE	s_socc_b,
        seatsmax_f TYPE	s_smax_f,
        seatsocc_f TYPE	s_socc_f,
      END OF ty_s_collect.

  TYPES : ty_t_collect TYPE SORTED TABLE OF ty_s_collect
                   WITH NON-UNIQUE KEY carrid connid,

      BEGIN OF ty_s_sum,
        paymentsum TYPE s_sum,
        seatsmax_b TYPE	s_smax_b,
        seatsocc_b TYPE	s_socc_b,
        seatsmax_f TYPE	s_smax_f,
        seatsocc_f TYPE  s_socc_f,
      END OF ty_s_sum.


    DATA:
      tl_collect  TYPE ty_t_collect.

    SELECT * FROM sflight
             INTO TABLE @DATA(t_flights).

    LOOP AT t_flights ASSIGNING FIELD-SYMBOL(<fs_key>).
      DATA(wl_collect) = CORRESPONDING ty_s_collect( <fs_key> ).
      COLLECT wl_collect INTO tl_collect.
    ENDLOOP.

    cl_demo_output=>display( tl_collect ).
    FREE tl_collect.

endmethod.
ENDCLASS.

START-OF-SELECTION.
  NEW lcl_reduce( )->start( ).
