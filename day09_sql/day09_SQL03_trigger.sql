
                            ---- TRIGGER ----
/* 
    Ʈ����(Trigger)�� Ư�� ���̺� INSERT, DELETE, UPDATE ���� DML ���� ����Ǿ��� ��,
    �����ͺ��̽����� �ڵ����� �����ϵ��� �ۼ��� ���α׷��Դϴ�.
                                                                            */
CREATE OR REPLACE TRIGGER TRIGGER_TEST1
    BEFORE  -- �� AFTER
    UPDATE ON DEPT      -- DEPT ���̺��� ������Ʈ �ɶ�
    FOR EACH ROW        -- TRIGGER �� ����Ǵ� �ñ�
BEGIN
    DBMS_OUTPUT.PUT_LINE('���� �� �÷� �� : ' || :OLD.DNAME );   -- ������Ʈ�� ���� ��
    DBMS_OUTPUT.PUT_LINE('���� �� �÷� �� : ' || :NEW.DNAME );   -- ������Ʈ�� ��
    
END;
/

UPDATE DEPT
SET DNAME = 'ACCOUTNING'
WHERE DEPTNO = 10
;

--------------------------------------------------------------------------------

                            ---- ����Ǯ��1 ----
                            
    -- ���� INSERT �ɶ����� ��հ��� ����϶� 

CREATE OR REPLACE TRIGGER SUM_TRIGGER
    BEFORE 
    INSERT ON EMP  
    FOR EACH ROW
DECLARE
   AVG_SAL EMP.SAL%TYPE;      -- ��հ� ���� ����
BEGIN
    SELECT ROUND(AVG(SAL),2)
    INTO AVG_SAL
    FROM EMP
    ;
    DBMS_OUTPUT.PUT_LINE('�޿���� : ' || AVG_SAL); 
END;
/

INSERT INTO EMP(EMPNO , ENAME, JOB, HIREDATE , SAL)
    VALUES (1000, 'TEST', 'SALES', SYSDATE, 1234);
    
--------------------------------------------------------------------------------

                            ---- ����Ǯ��2 ----
    -- ���� INSERT �Ҷ����� BOOK_LOG �� �����
    --DB����� ���̵� ã�¹�� -> SYS_CONTEXT('USERENV' , 'SESSION_USER')
    
CREATE OR REPLACE TRIGGER TRIGGER_TEST2
    AFTER  -- �� AFTER
    INSERT ON BOOK      -- BOOK ���̺��� INSERT �ɶ�
    FOR EACH ROW        -- TRIGGER �� ����Ǵ� �ñ�
BEGIN
    INSERT INTO BOOK_LOG
        VALUES (:NEW.BOOKID , :NEW.BOOKNAME , :NEW.PUBLISHER , 
        :NEW.PRICE , SYSDATE , SYS_CONTEXT('USERENV' , 'SESSION_USER'));
END;
/

INSERT INTO BOOK VALUES (51, '������ ����' , '�̻�̵��' , 25000);

--------------------------------------------------------------------------------

                            ---- ����Ǯ��3 ----
                            
    -- 1. STUDENT Ʈ���� �����
    -- 2. STUDENT_LOG ���̺� �����
        --> L_STUNO(�й�) , L_STUNAME (�̸�) , L_STUDEPT (�а�) , L_DATE (��¥), L_ID (���̵�)
    -- 3. �����Ͱ� INSERT �Ǹ�

CREATE OR REPLACE TRIGGER TRIGGER_TEST3
    AFTER  -- �� AFTER
    UPDATE OR INSERT ON STUDENT     
    FOR EACH ROW        -- TRIGGER �� ����Ǵ� �ñ�
BEGIN

    IF INSERTING THEN           -- INSERT �� �ؿ� ����
        INSERT INTO STUDENT_LOG
        VALUES (:NEW.STU_NO , :NEW.STU_NAME , :NEW.STU_DEPT , 
        SYSDATE , SYS_CONTEXT('USERENV' , 'SESSION_USER') , 'I');
    ELSIF UPDATING  THEN       -- UPDATE �� �ؿ� ����
        INSERT INTO STUDENT_LOG
        VALUES (:NEW.STU_NO , :NEW.STU_NAME , :NEW.STU_DEPT , 
        SYSDATE , SYS_CONTEXT('USERENV' , 'SESSION_USER') , 'U');
    END IF;
END;
/

UPDATE STUDENT
SET STU_HEIGHT = STU_HEIGHT + 1
WHERE STU_NO = '20153075';

INSERT INTO STUDENT (STU_NO , STU_NAME , STU_DEPT)
VALUES ('20155678', '�浿��' , '��ǻ������');

SELECT * FROM STUDENT_LOG ;

--------------------------------------------------------------------------------

                            ---- ����Ǯ��4 ----
                            
    -- 1. EMP
    -- 2. EMP_LOG ���̺� ����
        --> L_EMPNO , MGR , L_SAL , L_COMM , L_DATE , L_ID , EVENT
    -- 3. INSERT , UPDATE , DELETE => I , U , D �� ó��

CREATE OR REPLACE TRIGGER TRIGGER_TEST4
    AFTER 
    UPDATE OR INSERT OR DELETE ON EMP   
    FOR EACH ROW        -- TRIGGER �� ����Ǵ� �ñ�
BEGIN

    IF INSERTING THEN           -- INSERT �� �ؿ� ����
        INSERT INTO EMP_LOG
        VALUES (:NEW.EMPNO , :NEW.MGR , :NEW.SAL , :NEW.COMM ,
        SYSDATE , SYS_CONTEXT('USERENV' , 'SESSION_USER') , 'I');
    ELSIF UPDATING  THEN       -- UPDATE �� �ؿ� ����
        INSERT INTO EMP_LOG
        VALUES (:NEW.EMPNO , :NEW.MGR , :NEW.SAL , :NEW.COMM , 
        SYSDATE , SYS_CONTEXT('USERENV' , 'SESSION_USER') , 'U');
    ELSIF DELETING THEN
        INSERT INTO EMP_LOG
        VALUES (:OLD.EMPNO , :OLD.MGR , :OLD.SAL , :OLD.COMM ,
        SYSDATE , SYS_CONTEXT('USERENV' , 'SESSION_USER') , 'D');
    END IF;
END;
/    

INSERT INTO EMP (EMPNO, MGR , SAL , COMM) 
    VALUES ('1234' , '6789' , '9999' , '555');
    
UPDATE EMP
SET SAL = '6666'
WHERE EMPNO = '1234'
;

DELETE 
FROM EMP
WHERE EMPNO = '1234'
;

SELECT * FROM EMP;
SELECT * FROM EMP_LOG;

--------------------------------------------------------------------------------

                            ---- ����Ǯ��5 ----
                            
    -- ��,��,�� ���� EMP���̺� ���� �Ұ��ϵ��� ������
                            
CREATE OR REPLACE TRIGGER TRIGGER_TEST5
    BEFORE 
    UPDATE OR INSERT OR DELETE ON EMP   
    FOR EACH ROW        -- TRIGGER �� ����Ǵ� �ñ�
BEGIN
    IF TO_CHAR(SYSDATE , 'DAY') IN ('�ݿ���','�����','�Ͽ���') THEN
        IF INSERTING THEN           -- INSERT �� �ؿ� ����
            RAISE_APPLICATION_ERROR(-20000, '������ ���� ���� �Ұ���');      -- ERROR �����
        ELSIF UPDATING  THEN       -- UPDATE �� �ؿ� ����
            RAISE_APPLICATION_ERROR(-20000, '������ ���� ���� �Ұ���');      -- ERROR �����
        ELSIF DELETING THEN
             RAISE_APPLICATION_ERROR(-20000, '������ ���� ���� �Ұ���');      -- ERROR �����
        END IF;
    END IF;
END;
/
