*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0038
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_0038.

*DATA flights TYPE TABLE OF spfli WITH EMPTY KEY.
*DATA : lv_data TYPE i.
*
*SELECT * FROM  spfli
*         WHERE carrid = 'UA'
*         INTO TABLE @flights.
*
*DATA members LIKE flights.
*LOOP AT flights INTO DATA(flight)
*     GROUP BY ( carrier = flight-carrid cityfr = flight-cityfrom )
*              ASCENDING
*              ASSIGNING FIELD-SYMBOL(<group>).
*  CLEAR members.
**  LOOP AT GROUP <group> ASSIGNING FIELD-SYMBOL(<flight>).
**    members = VALUE #( BASE members ( <flight> ) ).
**  ENDLOOP.
*
*   LOOP AT GROUP <group> ASSIGNING FIELD-SYMBOL(<flight>).
*    lv_data += <flight>-distance.
*    flight-distance = lv_data.
*  ENDLOOP.
*  APPEND flight to flights.
*
*
**  LOOP AT GROUP <group> ASSIGNING FIELD-SYMBOL(<flight>).
**    <flight>-distance += <flight>-distance.
**    members = VALUE #( BASE members ( <flight> ) ).
**  ENDLOOP.
***   APPEND <flight> TO flights.
**  cl_demo_output=>write( members ).
*
**  LOOP AT GROUP <group> INTO flight .
**    lv_data += flight-distance.
**  ENDLOOP.
**  flight-distance = lv_data.
**  APPEND flight TO flights .
*ENDLOOP.
*cl_demo_output=>display( ).

*SELECT * FROM sflight INTO TABLE @data(t_flights).
*    TYPES:
*      BEGIN OF ty_s_collect,
*        carrid     TYPE s_carr_id,
*        paymentsum TYPE s_sum,
*        seatsmax_b TYPE  s_smax_b,
*        seatsocc_b TYPE  s_socc_b,
*        seatsmax_f TYPE  s_smax_f,
*        seatsocc_f TYPE  s_socc_f,
*      END OF ty_s_collect,
*
*      ty_t_collect TYPE SORTED TABLE OF ty_s_collect
*                   WITH NON-UNIQUE KEY carrid,
*
*      BEGIN OF ty_s_sum,
*        paymentsum TYPE s_sum,
*        seatsmax_b TYPE  s_smax_b,
*        seatsocc_b TYPE  s_socc_b,
*        seatsmax_f TYPE  s_smax_f,
*        seatsocc_f TYPE  s_socc_f,
*      END OF ty_s_sum.
*
*    DATA:
*      tl_collect  TYPE ty_t_collect.
*
*    LOOP AT t_flights ASSIGNING FIELD-SYMBOL(<fs_key>).
*      DATA(wl_collect) = CORRESPONDING ty_s_collect( <fs_key> ).
*      COLLECT wl_collect INTO tl_collect.
*    ENDLOOP.
*
********************************************************************
*    tl_collect = VALUE ty_t_collect(
*                   FOR GROUPS carrier  OF  <fs_flight> IN t_flights
*                       INDEX INTO l_tabix
*                       GROUP BY ( carrid = <fs_flight>-carrid )
*                         LET wl_sum = REDUCE ty_s_sum(
*                                        INIT calc TYPE ty_s_sum
*                                         FOR r IN GROUP carrier
*                                        NEXT calc-paymentsum = calc-paymentsum + r-paymentsum
*                                             calc-seatsmax_b = calc-seatsmax_b + r-seatsmax_b
*                                             calc-seatsocc_b = calc-seatsocc_b + r-seatsocc_b
*                                             calc-seatsmax_f = calc-seatsmax_f + r-seatsmax_f
*                                             calc-seatsocc_f = calc-seatsocc_f + r-seatsocc_f )
*                         IN
*                    ( carrid = carrier-carrid
*                      paymentsum = wl_sum-paymentsum
*                      seatsmax_b = wl_sum-seatsmax_b
*                      seatsocc_b = wl_sum-seatsocc_b
*                      seatsmax_f = wl_sum-seatsmax_f
*                      seatsocc_f = wl_sum-seatsocc_f ) ).
*
*    BREAK-POINT.

*data : begin of wa occurs 0,
*        bukrs type bsak-bukrs,
*        lifnr type bsak-lifnr,
*        land1 type lfa1-land1,
*        name1 like lfa1-name1,
*        dmbtr like bsak-dmbtr,
*        count type i value 0,
*        tot_vend  type i,
*        vend type i.
*data :end of wa.
*
*data : itab like table of wa.
*
*  select distinct bukrs lifnr waers from bsak into
*corresponding fields of wa.
*          where bukrs in s_bukrs
*          and   lifnr in s_lifnr
*          and   bschl in s_bschl.

*i want the total amount paid according to vendor i am  using this way but i am not getting


*  loop at itab into wa.
*
*wa-dmbtr = bsak-dmbtr.
*collect wa-dmbtr into itab.
*
*modify itab from wa transporting dmbtr.

*TYPES: BEGIN OF ty_sap,
*
*gl_acct LIKE zcs_sap_fields-gl_acct,
*
*wbs_element LIKE zcs_sap_fields-wbs_element,
*
*cost_center LIKE zcs_sap_fields-cost_center,
*
*status LIKE zcs_sap_fields-status,
*
*count TYPE z_counter,
*
*amount LIKE zcs_sap_fields-amount,
*
*user LIKE zcs_variant-sap_user,
*
*manager LIKE zcs_variant-mf_group,
*
*END OF ty_sap.
*
*i_sap TYPE STANDARD TABLE OF ty_sap,
*
*w_sap_collect TYPE ty_sap,
*
*LOOP AT i_sap INTO w_sap.
*
*CLEAR w_total.
*
*w_total-key1 = c_sap.
*
*w_total-key2 = w_sap-gl_acct.
*
*w_total-key3 = w_sap-wbs_element.
*
*w_total-key4 = w_sap-cost_center.
*
*w_total-count = w_sap-count.
*
*w_total-amount = w_sap-amount.
*
*COLLECT w_total INTO i_total.
*
*ENDLOOP.

*CLASS lcl_reduce DEFINITION CREATE PUBLIC.
*
*  PUBLIC SECTION.
*
*    METHODS: start.
*
*ENDCLASS.
*
*CLASS lcl_reduce IMPLEMENTATION.
*
*  METHOD start.
*
*    TYPES:
*      BEGIN OF ty_s_collect,
*        carrid     TYPE s_carr_id,
*        connid     TYPE S_CONN_ID,
*        paymentsum TYPE s_sum,
*        seatsmax_b TYPE  s_smax_b,
*        seatsocc_b TYPE  s_socc_b,
*        seatsmax_f TYPE  s_smax_f,
*        seatsocc_f TYPE  s_socc_f,
*      END OF ty_s_collect,
*
*      ty_t_collect TYPE SORTED TABLE OF ty_s_collect
*                   WITH NON-UNIQUE KEY carrid connid,
*
*      BEGIN OF ty_s_sum,
*        paymentsum TYPE s_sum,
*        seatsmax_b TYPE  s_smax_b,
*        seatsocc_b TYPE  s_socc_b,
*        seatsmax_f TYPE  s_smax_f,
*        seatsocc_f TYPE  s_socc_f,
*      END OF ty_s_sum.
*
*
*    DATA:
*      tl_collect  TYPE ty_t_collect.
*
*    SELECT * FROM sflight
*             INTO TABLE @DATA(t_flights).
**             ORDER BY PRIMARY KEY.
*
*    LOOP AT t_flights ASSIGNING FIELD-SYMBOL(<fs_key>).
*      DATA(wl_collect) = CORRESPONDING ty_s_collect( <fs_key> ).
*      COLLECT wl_collect INTO tl_collect.
*    ENDLOOP.
*
*    cl_demo_output=>display( tl_collect ).
*    FREE tl_collect.
*
*  ENDMETHOD.
*
*ENDCLASS.
*
*START-OF-SELECTION.
*  NEW lcl_reduce( )->start( ).

DATA : gt_sflight TYPE TABLE of sflight,
       gs_sflight TYPE sflight.

SELECT * FROM sflight INTO TABLE gt_sflight.

  DATA : lv_data TYPE price,
         lv_data1 TYPE i.

  LOOP AT gt_sflight INTO gs_sflight
       GROUP BY  ( carrid = gs_sflight-carrid
                   connid = gs_sflight-connid )
        ASCENDING.
  CLEAR : lv_data, lv_data1.
  LOOP AT GROUP gs_sflight ASSIGNING FIELD-SYMBOL(<lfs_sflight>).
    lv_data += <lfs_sflight>-price.
    lv_data1 += <lfs_sflight>-seatsmax.

  ENDLOOP.
  READ TABLE gt_sflight ASSIGNING  <lfs_sflight> WITH KEY carrid = gs_sflight-carrid
                                                          connid = gs_sflight-connid.
  <lfs_sflight>-price = lv_data.
  <lfs_sflight>-seatsmax = lv_data1.

  ENDLOOP.

*  DELETE ADJACENT DUPLICATES FROM gt_sflight COMPARING carrid connid.

BREAK-POINT.
