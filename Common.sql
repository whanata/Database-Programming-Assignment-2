CREATE OR REPLACE PACKAGE common
AS
  PROCEDURE upd_error_table(p_err_msg VARCHAR2, p_location VARCHAR2); 
  PROCEDURE ins_run_table(p_run_start TIMESTAMP, p_outcome VARCHAR2, p_err_message VARCHAR2 := NULL);
  FUNCTION get_string_parameter(p_kind VARCHAR2, p_code VARCHAR2)
    RETURN VARCHAR2;
END;
/

CREATE OR REPLACE PACKAGE BODY common
AS
  PROCEDURE upd_error_table(p_err_msg VARCHAR2, p_location VARCHAR2) 
  IS
  BEGIN
    INSERT INTO fss_error_table
    VALUES
      (
        p_err_msg
        , SYSTIMESTAMP
        , p_location
      );
    COMMIT; 
  END upd_error_table; 
  
  PROCEDURE ins_run_table(p_run_start TIMESTAMP, p_outcome VARCHAR2, p_err_message VARCHAR2 := NULL)
  IS
  BEGIN
    INSERT INTO fss_run_table
      (
        runId
        , runStart
        , runEnd
        , runOutcome
        , remarks
      )
    VALUES
      (
        seq_run_id.nextval
        , p_run_start
        , SYSTIMESTAMP
        , p_outcome
        , p_err_message
      );
  EXCEPTION
    WHEN OTHERS 
    THEN
      common.upd_error_table(SQLERRM, 'ins_run_table');
  END ins_run_table;
  
  FUNCTION get_string_parameter(p_kind VARCHAR2, p_code VARCHAR2)
  RETURN VARCHAR2
  IS
    l_parameter VARCHAR2(100);
  BEGIN
    SELECT value
    INTO l_parameter
    FROM parameter
    WHERE kind = p_kind
    AND code = p_code
    AND active = 'Y';
    RETURN l_parameter;
  END get_string_parameter;
  
END common;
/


exec common.ins_run_table(systimestamp, 'Failed');