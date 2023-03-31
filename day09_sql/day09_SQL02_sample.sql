--[예제 5-1] Book 테이블에 한 개의 투플을 삽입하는 프로시저를 작성하시오

CREATE OR REPLACE PROCEDURE InsertBook
    (P_BNO BOOK.BOOKID%TYPE,
    P_BNAME BOOK.BOOKNAME%TYPE,
    P_BPUB BOOK.PUBLISHER%TYPE,
    P_BPRICE BOOK.PRICE%TYPE)
IS
BEGIN
    INSERT INTO BOOK(BOOKID, BOOKNAME, PUBLISHER, PRICE)
    VALUES(P_BNO, P_BNAME, P_BPUB, P_BPRICE);
END;
/

EXEC InsertBook(13, '스포츠과학', '마당과학서적', 25000);
SELECT * FROM Book;


--[예제 5-2] 동일한 도서가 있는지 점검한 후 삽입하는 프로시저를 작성하시오
CREATE OR REPLACE PROCEDURE BookInsertOrUpdate
    (P_BID BOOK.BOOKID%TYPE,
    P_BNAME BOOK.BOOKNAME%TYPE,
    P_BPUB BOOK.PUBLISHER%TYPE,
    P_BPRICE BOOK.PRICE%TYPE)
IS
    V_POINT NUMBER;
BEGIN

    SELECT BOOKID INTO V_POINT
    FROM BOOK
    WHERE BOOKID = P_BID;
    
        DBMS_OUTPUT.PUT_LINE('UPDATE BOOK');
        UPDATE BOOK
        SET PRICE = P_BPRICE
        WHERE BOOKID = V_POINT;
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('INSERT BOOK');
        INSERT INTO BOOK(BOOKID, BOOKNAME, PUBLISHER, PRICE)
        VALUES(P_BID, P_BNAME, P_BPUB, P_BPRICE);
    
END;
/

EXEC BookInsertOrUpdate(15, '스포츠 즐거움', '마당과학서적', 25000);
SELECT * FROM Book; /* 15번 투플 삽입 결과 확인 */

/* BookInsertOrUpdate 프로시저를 실행하여 테스트하는 부분 */
EXEC BookInsertOrUpdate(15, '스포츠 즐거움', '마당과학서적', 20000);
SELECT * FROM Book; /* 15번 투플 가격 변경 확인 */

--[예제 5-3] Book 테이블에 저장된 도서의 평균가격을 반환하는 프로시저를 작성하시오.
CREATE OR REPLACE PROCEDURE BPRICEAVG
IS
    V_AVGP BOOK.PRICE%TYPE;
BEGIN
    SELECT AVG(PRICE) INTO V_AVGP
    FROM BOOK;
    DBMS_OUTPUT.PUT_LINE('Average Price : ' || V_AVGP);
END;
/

EXEC BPRICEAVG;

--[예제 5-4] Orders 테이블의 판매 도서에 대한 이익을 계산하는 프로시저를 작성하시오.
-- SALEPRICE 기준 20000원 이상이면 10% 수익, 20000원 미만이면 5% 수익
CREATE OR REPLACE PROCEDURE BSALEMARGIN
IS
    CURSOR SMARGIN IS
        SELECT ORDERID, CASE WHEN SALEPRICE >= 20000 THEN SALEPRICE * 0.1
                           ELSE SALEPRICE * 0.05
                           END AS marg
    FROM ORDERS;
    
BEGIN
    FOR A_LIST IN SMARGIN LOOP
    DBMS_OUTPUT.PUT_LINE('OrderID : ' || A_LIST.ORDERID ||', Margin : ' || A_LIST.marg);
    END LOOP;
    
END;
/

EXEC BSALEMARGIN;

-- Q1. 명시적 커서를 사용하여 EMP테이블으 전체 데이터를 조회한 후 커서 안의 데이터가 다음과 같이 출력되도록 PL/SQL문을 작성해 보세요