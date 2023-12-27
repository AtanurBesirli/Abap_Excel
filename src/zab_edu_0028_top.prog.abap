*&---------------------------------------------------------------------*
*& Include          ZAB_EDU_0028_TOP
*&---------------------------------------------------------------------*

DATA : go_alv  TYPE REF TO cl_gui_alv_grid,
       go_cust TYPE REF TO cl_gui_custom_container.

CLASS : cl_event_receiver DEFINITION DEFERRED,
        lcl_main DEFINITION DEFERRED.
DATA : go_event_receiver TYPE REF TO cl_event_receiver,
       go_main TYPE REF TO lcl_main.

TYPES : BEGIN OF gty_list,
          carrid   TYPE s_carr_id,
          carrname TYPE s_carrname,
          currcode TYPE s_currcode,
          url      TYPE s_carrurl,
        END OF gty_list.

DATA : gt_list   TYPE TABLE OF gty_list,
       gs_list   TYPE gty_list,
       gt_fcat   TYPE lvc_t_fcat,
       gs_fcat   TYPE lvc_s_fcat,
       gs_layout TYPE lvc_s_layo.

FIELD-SYMBOLS : <gfs_fcat> TYPE lvc_s_fcat.

PARAMETERS : p_num1 TYPE i,
             p_num2 TYPE i.
