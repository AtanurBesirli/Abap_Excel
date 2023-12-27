*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0047
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zab_edu_0047.

*DATA : f1 TYPE c VALUE 'A',
*f2 TYPE c VALUE 'B'.
*END-OF-SELECTION.
*PERFORM output. "Calling a subroutine
**&--------------------------------------------------------------*
**& Form OUTPUT
**&--------------------------------------------------------------*
*FORM output.
*DATA f3 TYPE c VALUE 'C'.
*DO 3 TIMES.
*WRITE f1.
*WRITE f2.
*EXIT.
*ENDDO.
*WRITE f3.
*ENDFORM.
*
*DATA : f1 TYPE c VALUE 'A',
*f2 TYPE c VALUE 'B'.
*END-OF-SELECTION.
*PERFORM output. "Calling a subroutine
**&--------------------------------------------------------------*
**& Form OUTPUT
**&--------------------------------------------------------------*
*FORM output.
*DATA f3 TYPE c VALUE 'B'.
*WRITE f1.
*WRITE f2.
*CHECK f2 <> f3.
*WRITE f3.
*ENDFORM.

*DATA : f1 TYPE c VALUE 'A',
*f2 TYPE c VALUE 'B'.
*END-OF-SELECTION.
*PERFORM output. "Calling a subroutine
**&--------------------------------------------------------------*
**& Form OUTPUT
**&--------------------------------------------------------------*
*FORM output.
*DATA f3 TYPE c VALUE 'B'.
*DO 3 TIMES.
*WRITE f1.
*CHECK f1 = f2.
*WRITE f2.
*WRITE f2.
*WRITE f1.
*ENDDO.
*WRITE f3.
*ENDFORM.

*DATA : f1 TYPE c VALUE 'A',
*f2 TYPE c VALUE 'B'.
*END-OF-SELECTION.
*PERFORM output. "Calling a subroutine
**&--------------------------------------------------------------*
**& Form OUTPUT
**&--------------------------------------------------------------*
*FORM output.
*DATA f3 TYPE c VALUE 'B'.
*DO 3 TIMES.
*WRITE f1.
*RETURN.
*WRITE f2.
*ENDDO.
*WRITE f3.
*ENDFORM.

*TYPES: BEGIN OF ty_vbrp,
*vbeln TYPE vbeln_vf, "Document Number
*posnr TYPE posnr, "Item Number
*fkimg TYPE fkimg, "Quantity
*vrkme TYPE vrkme, "UoM
*netwr TYPE netwr, "Net Value
*matnr TYPE matnr, "Material Number
*arktx TYPE arktx, "Description
*mwsbp TYPE mwsbp, "Tax Amount
*END OF ty_vbrp.
*DATA : it_vbrp TYPE STANDARD TABLE OF ty_vbrp,
*wa_vbrp LIKE LINE OF it_vbrp,
*v_vbeln TYPE vbeln_vf.
*PARAMETERS p_vbeln TYPE vbeln_vf.
*INITIALIZATION. "Event Block
*AUTHORITY-CHECK OBJECT 'V_VBRK_FKA'
*ID 'FKART' FIELD 'F2'
*ID 'ACTVT' FIELD '03'.
*IF sy-subrc <> 0.
** Implement a suitable exception handling here
*MESSAGE 'Authorization check failed' TYPE 'E'.
*ENDIF.
*AT SELECTION-SCREEN. "Event Block
*SELECT SINGLE vbeln FROM vbrk
*INTO v_vbeln
*WHERE vbeln EQ p_vbeln.
*IF sy-subrc IS NOT INITIAL.
*MESSAGE 'Invalid Document Number' TYPE 'E'.
*ENDIF.
*START-OF-SELECTION. "Event Block
*PERFORM get_data. "Calls procedure
*PERFORM show_output. "Calls procedure
**&--------------------------------------------------------------*
**& Form GET_DATA
**&--------------------------------------------------------------*
*FORM get_data . "Subroutine
*SELECT vbeln
*posnr
*fkimg
*vrkme
*netwr
*matnr
*arktx
*mwsbp
*FROM vbrp
*INTO TABLE it_vbrp
*WHERE vbeln EQ p_vbeln.
*ENDFORM. " GET_DATA
**&--------------------------------------------------------------*
**& Form show-output
**&--------------------------------------------------------------*
*FORM show_output . "Subroutine
*FORMAT COLOR COL_HEADING.
*WRITE : / 'Item',
*10 'Description',
*33 'Billed Qty',
*48 'UoM',
*57 'Netvalue',
*70 'Material',
*80 'Taxamount'.
*FORMAT COLOR OFF.
*
*LOOP AT it_vbrp INTO wa_vbrp.
*WRITE :/ wa_vbrp-posnr,
*10 wa_vbrp-arktx,
*33 wa_vbrp-fkimg LEFT-JUSTIFIED,
*48 wa_vbrp-vrkme,
*57 wa_vbrp-netwr LEFT-JUSTIFIED,
*70 wa_vbrp-matnr,
*80 wa_vbrp-mwsbp LEFT-JUSTIFIED.
*ENDLOOP.
*ENDFORM.

*DATA: lv_a1 TYPE string,
*lv_a2 TYPE string.
*oref->meth( IMPORTING fp1 = lv_a1
*fp2 = lv_a1 )

*CLASS CL_VEHICLE DEFINITION.
*PUBLIC SECTION.
*TYPES ty_speed TYPE i.
*METHODS inc_speed IMPORTING im_speed TYPE ty_speed.
*METHODS dec_speed IMPORTING im_speed TYPE ty_speed.
*METHODS stop.
*METHODS get_speed RETURNING VALUE(r_speed) TYPE ty_speed.
*PRIVATE SECTION.
*DATA : speed TYPE i.
*ENDCLASS.
*CLASS CL_VEHICLE IMPLEMENTATION.
*METHOD inc_speed.
*ADD im_speed TO speed.
*ENDMETHOD.
*METHOD dec_speed.
*SUBTRACT im_speed FROM speed.
*ENDMETHOD.
*METHOD stop.
*speed = 0.
*ENDMETHOD.
*METHOD get_speed.
*r_speed = speed.
*ENDMETHOD.
*ENDCLASS.

*CLASS CL_VEHICLE DEFINITION.
* PUBLIC SECTION.
* CLASS-METHODS add_vehicles IMPORTING count TYPE i.
* METHODS get_vehicles RETURNING VALUE(count) TYPE i.
* PRIVATE SECTION.
* CLASS-DATA no_of_vehicles TYPE i.
*ENDCLASS.
*CLASS CL_VEHICLE IMPLEMENTATION.
* METHOD add_vehicles.
* ADD count TO no_of_vehicles.
* ENDMETHOD.
* METHOD get_vehicles.
* count = no_of_vehicles.
* ENDMETHOD.
*ENDCLASS.
***End of class definition.
*DATA o_vehicle TYPE REF TO cl_vehicle.
*DATA v_vehicles TYPE i.
*START-OF-SELECTION.
*CL_VEHICLE=>add_vehicles( 10 ).
**The above statement can also be written as
**CALL METHOD CL_VEHICLE=>add_
**vehicles( 10 ).
*CREATE OBJECT o_vehicle.
*v_vehicles = o_vehicle->get_vehicles( ).

*CLASS cl_notification_api DEFINITION.
*PUBLIC SECTION.
*METHODS set_message IMPORTING im_message TYPE string.
*METHODS display_notification.
*PRIVATE SECTION.
*DATA MESSAGE TYPE string.
*METHODS filter_message RETURNING VALUE(boolean) TYPE boolean.
*METHODS check_count RETURNING VALUE(boolean) TYPE boolean.
*METHODS check_status RETURNING VALUE(boolean) TYPE boolean.
*ENDCLASS.
*CLASS cl_notification_api IMPLEMENTATION.
*METHOD set_message.
*MESSAGE = im_message.
*ENDMETHOD.
*METHOD display_notification.
*IF me->filter_message( ) EQ abap_true OR
*me->check_count( ) EQ abap_true OR
*me->check_status( ) EQ abap_true.
*WRITE MESSAGE.
*ELSE.
*CLEAR message.
*ENDIF.
*ENDMETHOD.
*METHOD filter_message.
**Filtering logic goes here and the parameter "Boolean" is set to
**abap_true or abap_false accordingly.
*ENDMETHOD.
*METHOD check_count.
**Logic to check number of messages goes here and the parameter
**"Boolean" is set to abap_true or abap_false accordingly.
*ENDMETHOD.
*METHOD check_status.
**Logic to check user personal setting goes here and the parameter
**"Boolean" is set to abap_true or abap_false accordingly.
*ENDMETHOD.
*ENDCLASS.
**Code in the calling program.
*DATA notify TYPE REF TO cl_notification_api.
*CREATE OBJECT notify.
*notify->set_message( im_message = 'My App notification' ).
*Notify->display_notification( ).

*CLASS cl_parent DEFINITION.
*PUBLIC SECTION.
*METHODS meth1.
*METHODS meth2.
*ENDCLASS.
*CLASS cl_parent IMPLEMENTATION.
*METHOD meth1.
*WRITE 'In method1 of parent'.
*ENDMETHOD.
*METHOD meth2.
*WRITE 'In method2 of parent'.
*ENDMETHOD.
*ENDCLASS.
*CLASS cl_child DEFINITION INHERITING FROM cl_parent.
*PUBLIC SECTION.
*METHODS meth2 REDEFINITION.
*METHODS meth3.
*ENDCLASS.
*CLASS cl_child IMPLEMENTATION.
*METHOD meth2.
*WRITE 'In method2 of child'.
*ENDMETHOD.
*METHOD meth3.
*WRITE 'In method3 of child'.
*ENDMETHOD.
*ENDCLASS.
*DATA parent TYPE REF TO cl_parent.
*
*DATA child TYPE REF TO cl_child.
*START-OF-SELECTION.
*CREATE OBJECT parent.
*CREATE OBJECT child.
*Parent->meth2( ).
*parent = child.
*parent->meth2( ).
*parent->meth1( ).
*child->meth1( ).

*CLASS cl_student DEFINITION ABSTRACT.
*PUBLIC SECTION.
*METHODS tuition_fee ABSTRACT.
*METHODS get_fee ABSTRACT RETURNING VALUE(fee_paid) TYPE boolean.
*PROTECTED SECTION.
*DATA fee_paid TYPE boolean.
*ENDCLASS.
*CLASS cl_commerce_student DEFINITION INHERITING FROM cl_student.
*PUBLIC SECTION.
*METHODS tuition_fee REDEFINITION.
*METHODS get_fee REDEFINITION.
*ENDCLASS.
*CLASS cl_commerce_student IMPLEMENTATION.
*METHOD tuition_fee.
*"logic to calculate tuition fee for commerce students goes here
*"IF fee paid.
*fee_paid = abap_true.
*ENDMETHOD.
*METHOD get_fee.
*fee_paid = me->fee_paid.
*ENDMETHOD.
*ENDCLASS.
*CLASS cl_science_student DEFINITION INHERITING FROM cl_student.
*PUBLIC SECTION.
*METHODS tuition_fee REDEFINITION.
*METHODS get_fee REDEFINITION.
*ENDCLASS.
*CLASS cl_science_student IMPLEMENTATION.
*METHOD tuition_fee.
*"logic to calculate tuition fee for science students goes here
*"IF fee paid.
*fee_paid = abap_true.
*ENDMETHOD.
*METHOD get_fee.
*fee_paid = me->fee_paid.
*ENDMETHOD.
*ENDCLASS.
*CLASS cl_admission DEFINITION.
*PUBLIC SECTION.
*METHODS set_student IMPORTING im_student TYPE REF TO cl_student.
*METHODS enroll.
*PRIVATE SECTION.
*DATA admit TYPE boolean.
*ENDCLASS.
*CLASS cl_admission IMPLEMENTATION.
*METHOD set_student.
*IF im_student->get_fee( ) EQ abap_true.
*admit = abap_true.
*ENDIF.
*ENDMETHOD.
*METHOD enroll.
*IF admit EQ abap_true.
**Perform the steps to enroll
*ENDIF.
*ENDMETHOD.
*ENDCLASS.
*DATA : commerce_student TYPE REF TO cl_commerce_student,
*science_student TYPE REF TO cl_science_student,
*admission TYPE REF TO cl_admission.
*START-OF-SELECTION.
*CREATE OBJECT: commerce_student,
*science_student,
*admission.
*CALL METHOD commerce_student->tuition_fee.
*CALL METHOD admission->set_student( EXPORTING im_student = commerce_student ).
*CALL METHOD admission->enroll.
*CALL METHOD science_student->tuition_fee.
*CALL METHOD admission->set_student( EXPORTING im_student = science_student ).
*CALL METHOD admission->enroll.

DATA : input_value TYPE matnr,
       output_value TYPE matnr.

input_value = '45'.
DATA : lv_data TYPE char40.
lv_data = input_value.

*IF MSEG-BWART = '101'.
*
*  CALL FUNCTION 'CONVERSION_EXIT_MATN1_OUTPUT'
*    EXPORTING
*      INPUT  = ZBJSTOCK-ZMAT10
*    IMPORTING
*      OUTPUT = WA2-MATNR.
*
*  SELECT MAX( BUDAT_MKPF )
*  FROM MSEG
*  INTO GRDT
*  WHERE MATNR = WA2-MATNR.
*
*ENDIF.

*IF MSEG-BWART = '101'.


  CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
    EXPORTING
      INPUT  = input_value
    IMPORTING
      OUTPUT = output_value.

*  SELECT MAX( BUDAT_MKPF )
*  FROM MSEG
*  INTO GRDT
*  WHERE MATNR = WA2-MATNR.

*ENDIF.

*CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*  EXPORTING
*    input  = input_value
*  IMPORTING
*    output = output_value.
*BREAK-POINT.

select COUNT(*) FROM mara INTO @data(lt_data) WHERE matnr = @output_value.
  BREAK-POINT.

*CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*  EXPORTING
*    input  =  input_value                " Any ABAP field
*  IMPORTING
*    output = output_value                 " External INPUT display, C field
*  .
*BREAK-POINT.
