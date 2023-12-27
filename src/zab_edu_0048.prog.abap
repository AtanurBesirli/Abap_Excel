*&---------------------------------------------------------------------*
*& Report ZAB_EDU_0048
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZAB_EDU_0048.
SELECTION-SCREEN BEGIN OF BLOCK part1 WITH FRAME TITLE text-001.
PARAMETERS: time RADIOBUTTON GROUP grp,
waiting TYPE i DEFAULT 10,
use_list RADIOBUTTON GROUP grp.
SELECTION-SCREEN END OF BLOCK part1.
DATA: lv_application_id TYPE amc_application_id VALUE 'ZDEMOAMC',
lv_channel_id TYPE amc_channel_id VALUE '/ping',
lv_extension_id TYPE amc_channel_extension_id.
DATA: lo_consumer TYPE REF TO if_amc_message_consumer.
DATA: gv_message TYPE string.
DATA: gv_message_received TYPE abap_bool.
DATA: lx_amc_error TYPE REF TO cx_amc_error.
DATA: gt_message_list TYPE TABLE OF string.
DATA: lv_text TYPE string.
* Implemenation of receiver class for text message type
CLASS lcl_amc_test_text DEFINITION
FINAL
CREATE PUBLIC .
PUBLIC SECTION.
CLASS-DATA cv_message TYPE string .
* Interface for AMC messages of type TEXT
INTERFACES if_amc_message_receiver_text .
PROTECTED SECTION.
PRIVATE SECTION.
ENDCLASS.

CLASS lcl_amc_test_text IMPLEMENTATION.
METHOD if_amc_message_receiver_text~receive.
*
*Message handling take place here
*Remark: In this method, hold the message to *be received and the
*main actions should be processed in the main program,
*usually after WAIT statement.
*Any kind of communication, e.g., RFCs, HTTP, and message handlin*g(e.g., error
*message) is not supported and will lead to ABAP *dump.
gv_message = i_message.
* For list processing, queue the messages
APPEND i_message TO gt_message_list.
gv_message_received = abap_true.
ENDMETHOD.
ENDCLASS.
START-OF-SELECTION.
DATA: lo_receiver_text TYPE REF TO lcl_amc_test_text.
TRY.
lo_consumer =
cl_amc_channel_manager=>create_message_consumer(
i_application_id = lv_application_id
i_channel_id = lv_channel_id
i_channel_extension_id = lv_extension_id
).
CREATE OBJECT lo_receiver_text.
lo_consumer->start_message_delivery(
i_receiver = lo_receiver_text
).
CATCH cx_amc_error INTO lx_amc_error.
MESSAGE lx_amc_error->get_text( ) TYPE 'E'.
ENDTRY.
IF use_list IS INITIAL.
* Wait until the boolean variable gv_message_received is set to
* true but not longer than waiting time in seconds
WAIT FOR MESSAGING CHANNELS UNTIL gv_message_received =
abap_true UP TO waiting SECONDS.

IF sy-subrc = 8 OR gv_message_received = abap_false.
gv_message = ')-: Time out occured and no message received'.
ENDIF.
* Print out the AMC message as popup screen
CALL FUNCTION 'POPUP_TO_CONFIRM'
EXPORTING
titlebar = 'AMC message'
text_question = gv_message.
ELSE.
NEW-PAGE LINE-SIZE 120 NO-TITLE.
lv_text = |>>><<<| ##NO_TEXT.
WRITE: /15 lv_text COLOR 1.
lv_text = |>>> Double click here to check for arrived messages !<<<| ##NO_TEXT.
WRITE: /15 lv_text COLOR 7 INTENSIFIED.
lv_text = |>>><<<| ##NO_TEXT.
WRITE: /15 lv_text COLOR 1.
ENDIF.
AT LINE-SELECTION.
IF gv_message_received = abap_true.
LOOP AT gt_message_list INTO gv_message.
CALL FUNCTION 'POPUP_TO_CONFIRM'
EXPORTING
titlebar = 'AMC message'
text_question = gv_message ##NO_TEXT.
gv_message_received = abap_false.
ENDLOOP.
CLEAR: gt_message_list, gv_message.
ENDIF.
