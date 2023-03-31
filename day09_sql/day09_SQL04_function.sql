
                            ---- FUNCTION ----

    -- 자바의 함수랑 같은거임

    -- 해당 부서의 가장 높은 급여 값                            
CREATE OR REPLACE FUNCTION MAX_TEST
    (P_DEPTNO IN EMP.DEPTNO%TYPE)
    RETURN NUMBER       -- RETURN 타입을 정해줘야한다 . 자바처럼
IS
    MAX_SAL EMP.SAL%TYPE;
BEGIN
    SELECT MAX(SAL)
    INTO MAX_SAL    -- MAX(SAL) 값을 MAX_SAL 에 넣어준다는 의미
    FROM EMP
    WHERE DEPTNO = P_DEPTNO
    ;
    RETURN MAX_SAL      -- MAX_SAL 을 다시 리턴 해준다
    ;
    
END;
/

SELECT MAX_TEST(10)
FROM EMP
;

--------------------------------------------------------------------------------

                            ---- 문제풀이1 ----         --!현업에서 많이씀!--
                            
    -- DATE_TEST1 함수
    -- DATE_TEST1(날짜데이터, 데이터변환종류)
    -- 데이터변환종류 => 'DATETIME' -> YYYY-MM-DD HH24:MI:SS
    -- 데이터변환종류 => 'DATE' -> YYYY-MM-DD
    -- 데이터변환종류 => 'TIME' -> HH24:MI:SS

SELECT TO_CHAR(SYSDATE , 'YYYY-MM-DD HH24:MI:SS')
FROM EMP;

SELECT * FROM EMP;

CREATE OR REPLACE FUNCTION DATE_TEST1
    (P_DATE IN DATE
    , P_KIND IN VARCHAR2)
    RETURN VARCHAR2      -- RETURN 타입을 정해줘야한다 . 자바처럼
IS
    V_DATE VARCHAR2(50);
BEGIN
    IF P_KIND = 'DATETIME' THEN
        V_DATE := TO_CHAR(P_DATE, 'YYYY-MM-DD HH24:MI:SS');
    ELSIF P_KIND = 'DATE' THEN
        V_DATE := TO_CHAR(P_DATE, 'YYYY-MM-DD');
    ELSIF P_KIND = 'TIME' THEN
        V_DATE := TO_CHAR(P_DATE, 'HH24:MI:SS');
    END IF;
    
    RETURN V_DATE;
END;
/

SELECT DATE_TEST1(HIREDATE , 'DATETIME')
FROM EMP;