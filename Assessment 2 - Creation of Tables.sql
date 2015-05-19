SELECT * 
FROM fss_transactions;

SELECT *
FROM fss_terminal;

SELECT *
FROM fss_merchant;

SELECT *
FROM fss_organisation;

CREATE TABLE fss_daily_transactions
(
  transactionNr NUMBER DEFAULT 1
  , downloadDate DATE
  , terminalId VARCHAR2(10)
  , cardId VARCHAR2(17)
  , transactionDate DATE
  , cardOldValue NUMBER
  , transactionAmount NUMBER
  , cardNewValue NUMBER
  , transactionStatus VARCHAR2(1)
  , errorCode VARCHAR2(25)
  , merchantId VARCHAR2(10)
  , settlementStatus VARCHAR2(50)
);

DROP TABLE fss_daily_transactions;

SELECT * FROM fss_daily_transactions;

TRUNCATE TABLE fss_daily_transactions;

CREATE TABLE error_table
(
  error_message VARCHAR(500)
  , error_timestamp TIMESTAMP
  , location VARCHAR(50)
);

DROP TABLE error_table;

SELECT * FROM error_table ORDER BY error_timestamp DESC;

CREATE TABlE fss_daily_settlement
(
  record VARCHAR2(1) DEFAULT 1
  , merchantBsb VARCHAR2(8)
  , merchantAccNum VARCHAR2(9)
  --, blank1 VARCHAR2(1) DEFAULT LPAD(' ',1,' ')
  , tranCode VARCHAR2(2)
  , transaction NUMBER
  , merchantTitle VARCHAR2(32)
  , bankingFlag VARCHAR2(1)
  --, blank3 VARCHAR2(1) DEFAULT LPAD(' ',1,' ')
  , lodgementRef VARCHAR2(15) PRIMARY KEY
  , trace VARCHAR2(20) DEFAULT '032-797 001006'
  , remitter VARCHAR(16) DEFAULT 'SMARTCARD TRANS'
  , gstTax VARCHAR2(8) DEFAULT '00000000'
  --, deskBankStatus VARCHAR2(1) DEFAULT NULL
);

DROP TABLE fss_daily_settlement;

SELECT * FROM fss_daily_settlement;

TRUNCATE TABLE fss_daily_settlement;

CREATE SEQUENCE seq_lodgement_reference
MINVALUE 1
MAXVALUE 9999999999
START WITH 1
INCREMENT BY 1
CACHE 20;

DROP SEQUENCE seq_lodgement_reference;

CREATE OR REPLACE TRIGGER trig_create_lodgement_ref
BEFORE INSERT
ON fss_daily_settlement
FOR EACH ROW
BEGIN
  :new.lodgementRef := to_char(sysdate, 'YYYYMMDD')||to_char(seq_lodgement_reference.nextval, 'FM0000000');
END;
/

CREATE SEQUENCE seq_run_id
MINVALUE 1
MAXVALUE 9999999999
START WITH 1
INCREMENT BY 1
CACHE 20;

DROP SEQUENCE seq_run_id;

CREATE TABLE fss_run_table
(
  runId NUMBER PRIMARY KEY
  , runStart TIMESTAMP
  , runEnd TIMESTAMP
  , runOutcome VARCHAR2(15)
  , remarks VARCHAR2(255)
);

DROP TABLE fss_run_table;

SELECT * FROM fss_run_table
ORDER BY runId desc;

CREATE OR REPLACE TRIGGER trig_create_run_id
BEFORE INSERT
ON fss_run_table
FOR EACH ROW
BEGIN
  :new.runId := seq_run_id.nextval;
END;
/