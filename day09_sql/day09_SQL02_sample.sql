--[���� 5-1] Book ���̺� �� ���� ������ �����ϴ� ���ν����� �ۼ��Ͻÿ�

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

EXEC InsertBook(13, '����������', '������м���', 25000);
SELECT * FROM Book;


--[���� 5-2] ������ ������ �ִ��� ������ �� �����ϴ� ���ν����� �ۼ��Ͻÿ�
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

EXEC BookInsertOrUpdate(15, '������ ��ſ�', '������м���', 25000);
SELECT * FROM Book; /* 15�� ���� ���� ��� Ȯ�� */

/* BookInsertOrUpdate ���ν����� �����Ͽ� �׽�Ʈ�ϴ� �κ� */
EXEC BookInsertOrUpdate(15, '������ ��ſ�', '������м���', 20000);
SELECT * FROM Book; /* 15�� ���� ���� ���� Ȯ�� */

--[���� 5-3] Book ���̺� ����� ������ ��հ����� ��ȯ�ϴ� ���ν����� �ۼ��Ͻÿ�.
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

--[���� 5-4] Orders ���̺��� �Ǹ� ������ ���� ������ ����ϴ� ���ν����� �ۼ��Ͻÿ�.
-- SALEPRICE ���� 20000�� �̻��̸� 10% ����, 20000�� �̸��̸� 5% ����
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

-- Q1. ����� Ŀ���� ����Ͽ� EMP���̺��� ��ü �����͸� ��ȸ�� �� Ŀ�� ���� �����Ͱ� ������ ���� ��µǵ��� PL/SQL���� �ۼ��� ������