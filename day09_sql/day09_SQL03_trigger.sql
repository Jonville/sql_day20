
                            ---- TRIGGER ----
/* 
    트리거(Trigger)는 특정 테이블에 INSERT, DELETE, UPDATE 같은 DML 문이 수행되었을 때,
    데이터베이스에서 자동으로 동작하도록 작성된 프로그램입니다.
                                                                            */
CREATE OR REPLACE TRIGGER TRIGGER_TEST1
    BEFORE  -- 나 AFTER
    UPDATE ON DEPT      -- DEPT 테이블이 업데이트 될때
    FOR EACH ROW        -- TRIGGER 가 실행되는 시기
BEGIN
    DBMS_OUTPUT.PUT_LINE('변경 전 컬럼 값 : ' || :OLD.DNAME );   -- 업데이트전 값이 들어감
    DBMS_OUTPUT.PUT_LINE('변경 후 컬럼 값 : ' || :NEW.DNAME );   -- 업데이트후 값
    
END;
/

UPDATE DEPT
SET DNAME = 'ACCOUTNING'
WHERE DEPTNO = 10
;

--------------------------------------------------------------------------------

                            ---- 문제풀이1 ----
                            
    -- 값이 INSERT 될때마다 평균값을 출력하라 

CREATE OR REPLACE TRIGGER SUM_TRIGGER
    BEFORE 
    INSERT ON EMP  
    FOR EACH ROW
DECLARE
   AVG_SAL EMP.SAL%TYPE;      -- 평균값 넣을 변수
BEGIN
    SELECT ROUND(AVG(SAL),2)
    INTO AVG_SAL
    FROM EMP
    ;
    DBMS_OUTPUT.PUT_LINE('급여평균 : ' || AVG_SAL); 
END;
/

INSERT INTO EMP(EMPNO , ENAME, JOB, HIREDATE , SAL)
    VALUES (1000, 'TEST', 'SALES', SYSDATE, 1234);
    
--------------------------------------------------------------------------------

                            ---- 문제풀이2 ----
    -- 값을 INSERT 할때마다 BOOK_LOG 에 남기기
    --DB사용자 아이디 찾는방법 -> SYS_CONTEXT('USERENV' , 'SESSION_USER')
    
CREATE OR REPLACE TRIGGER TRIGGER_TEST2
    AFTER  -- 나 AFTER
    INSERT ON BOOK      -- BOOK 테이블이 INSERT 될때
    FOR EACH ROW        -- TRIGGER 가 실행되는 시기
BEGIN
    INSERT INTO BOOK_LOG
        VALUES (:NEW.BOOKID , :NEW.BOOKNAME , :NEW.PUBLISHER , 
        :NEW.PRICE , SYSDATE , SYS_CONTEXT('USERENV' , 'SESSION_USER'));
END;
/

INSERT INTO BOOK VALUES (51, '스포츠 과학' , '이상미디어' , 25000);

--------------------------------------------------------------------------------

                            ---- 문제풀이3 ----
                            
    -- 1. STUDENT 트리거 만들기
    -- 2. STUDENT_LOG 테이블 만들기
        --> L_STUNO(학번) , L_STUNAME (이름) , L_STUDEPT (학과) , L_DATE (날짜), L_ID (아이디)
    -- 3. 데이터가 INSERT 되면

CREATE OR REPLACE TRIGGER TRIGGER_TEST3
    AFTER  -- 나 AFTER
    UPDATE OR INSERT ON STUDENT     
    FOR EACH ROW        -- TRIGGER 가 실행되는 시기
BEGIN

    IF INSERTING THEN           -- INSERT 면 밑에 실행
        INSERT INTO STUDENT_LOG
        VALUES (:NEW.STU_NO , :NEW.STU_NAME , :NEW.STU_DEPT , 
        SYSDATE , SYS_CONTEXT('USERENV' , 'SESSION_USER') , 'I');
    ELSIF UPDATING  THEN       -- UPDATE 면 밑에 실행
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
VALUES ('20155678', '길동이' , '컴퓨터정보');

SELECT * FROM STUDENT_LOG ;

--------------------------------------------------------------------------------

                            ---- 문제풀이4 ----
                            
    -- 1. EMP
    -- 2. EMP_LOG 테이블 생성
        --> L_EMPNO , MGR , L_SAL , L_COMM , L_DATE , L_ID , EVENT
    -- 3. INSERT , UPDATE , DELETE => I , U , D 로 처리

CREATE OR REPLACE TRIGGER TRIGGER_TEST4
    AFTER 
    UPDATE OR INSERT OR DELETE ON EMP   
    FOR EACH ROW        -- TRIGGER 가 실행되는 시기
BEGIN

    IF INSERTING THEN           -- INSERT 면 밑에 실행
        INSERT INTO EMP_LOG
        VALUES (:NEW.EMPNO , :NEW.MGR , :NEW.SAL , :NEW.COMM ,
        SYSDATE , SYS_CONTEXT('USERENV' , 'SESSION_USER') , 'I');
    ELSIF UPDATING  THEN       -- UPDATE 면 밑에 실행
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

                            ---- 문제풀이5 ----
                            
    -- 금,토,일 에는 EMP테이블 수정 불가하도록 만들어라
                            
CREATE OR REPLACE TRIGGER TRIGGER_TEST5
    BEFORE 
    UPDATE OR INSERT OR DELETE ON EMP   
    FOR EACH ROW        -- TRIGGER 가 실행되는 시기
BEGIN
    IF TO_CHAR(SYSDATE , 'DAY') IN ('금요일','토요일','일요일') THEN
        IF INSERTING THEN           -- INSERT 면 밑에 실행
            RAISE_APPLICATION_ERROR(-20000, '금토일 에는 수정 불가함');      -- ERROR 띄워줌
        ELSIF UPDATING  THEN       -- UPDATE 면 밑에 실행
            RAISE_APPLICATION_ERROR(-20000, '금토일 에는 수정 불가함');      -- ERROR 띄워줌
        ELSIF DELETING THEN
             RAISE_APPLICATION_ERROR(-20000, '금토일 에는 수정 불가함');      -- ERROR 띄워줌
        END IF;
    END IF;
END;
/
