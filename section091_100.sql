alter session set nls_date_format='RR/MM/DD';

drop table emp;
drop table dept;

CREATE TABLE DEPT
       (DEPTNO number(10),
        DNAME VARCHAR2(14),
        LOC VARCHAR2(13) );

INSERT INTO DEPT VALUES (10, 'ACCOUNTING', 'NEW YORK');
INSERT INTO DEPT VALUES (20, 'RESEARCH',   'DALLAS');
INSERT INTO DEPT VALUES (30, 'SALES',      'CHICAGO');
INSERT INTO DEPT VALUES (40, 'OPERATIONS', 'BOSTON');

CREATE TABLE EMP (
 EMPNO               NUMBER(4) NOT NULL,
 ENAME               VARCHAR2(10),
 JOB                 VARCHAR2(9),
 MGR                 NUMBER(4) ,
 HIREDATE            DATE,
 SAL                 NUMBER(7,2),
 COMM                NUMBER(7,2),
 DEPTNO              NUMBER(2) );

INSERT INTO EMP VALUES (7839,'KING','PRESIDENT',NULL,'81-11-17',5000,NULL,10);
INSERT INTO EMP VALUES (7698,'BLAKE','MANAGER',7839,'81-05-01',2850,NULL,30);
INSERT INTO EMP VALUES (7782,'CLARK','MANAGER',7839,'81-05-09',2450,NULL,10);
INSERT INTO EMP VALUES (7566,'JONES','MANAGER',7839,'81-04-01',2975,NULL,20);
INSERT INTO EMP VALUES (7654,'MARTIN','SALESMAN',7698,'81-09-10',1250,1400,30);
INSERT INTO EMP VALUES (7499,'ALLEN','SALESMAN',7698,'81-02-11',1600,300,30);
INSERT INTO EMP VALUES (7844,'TURNER','SALESMAN',7698,'81-08-21',1500,0,30);
INSERT INTO EMP VALUES (7900,'JAMES','CLERK',7698,'81-12-11',950,NULL,30);
INSERT INTO EMP VALUES (7521,'WARD','SALESMAN',7698,'81-02-23',1250,500,30);
INSERT INTO EMP VALUES (7902,'FORD','ANALYST',7566,'81-12-11',3000,NULL,20);
INSERT INTO EMP VALUES (7369,'SMITH','CLERK',7902,'80-12-11',800,NULL,20);
INSERT INTO EMP VALUES (7788,'SCOTT','ANALYST',7566,'82-12-22',3000,NULL,20);
INSERT INTO EMP VALUES (7876,'ADAMS','CLERK',7788,'83-01-15',1100,NULL,20);
INSERT INTO EMP VALUES (7934,'MILLER','CLERK',7782,'82-01-11',1300,NULL,10);

commit;

--091 ������ ���ǹ����� ������ �ְ� ������ ����ϱ�

-- ������ ���ǹ��� �̿��Ͽ� ��� �̸�, ����, ������ ������ ���� ����ϴµ�, ���� ������ �����ϸ鼭 ������ ���� ������� ���
-- ORDER�� BY�� ���̿� SIBLINGS�� ����Ͽ� �����ϸ� ������ ���ǹ��� ���� ������ ��Ʈ���� �ʰ� ��� ����
--���� ������� �ʾҴٸ� ������ ���� ������θ� ��µǸ鼭 ���� ������ ���δ�.
SELECT rpad(' ', level*3) || ename as employee, level, sal, job
FROM emp
START WITH ename = 'KING'
CONNECT BY prior empno = mgr
ORDER SIBLINGS BY sal desc;

-- ORDER ���̿� SIBLING ������� �ʾ��� ��
SELECT rpad(' ', level*3) || ename as employee, level, sal, job
FROM emp
START WITH ename = 'KING'
CONNECT BY prior empno = mgr
ORDER BY sal desc;

--092 ������ ���ǹ����� ������ �ְ� ������ ����ϱ�
-- ������ ���ǹ��� SYS_CONNECT_BY �Լ��� �̿��Ͽ� ���� ������ ���η� ���
-- SYS_CONNECT_BY_PATH �Լ��� �� ��° ���ڰ����� /�� ����Ͽ� �̸��� �̸� ������ ������ /�� ����Ѵ�. 
SELECT ename, SYS_CONNECT_BY_PATH(ename, '/') as path
FROM emp
START WITH ename = 'KING'
CONNECT BY prior empno = mgr;

--LTRIM�� ����Ͽ� PATH �Ǿ��� / �����ϱ�
SELECT ename, LTRIM(SYS_CONNECT_BY_PATH(ename, '/'), '/') as path
FROM emp
START WITH ename = 'KING'
CONNECT BY prior empno = mgr;

--093 �Ϲ� ���̺� �����ϱ�(CREATE TABLE)

--��� ��ȣ, �̸�, ����, �Ի����� ������ �� �ִ� ���̺��� ����
/* ���̺�� �ۼ��� ��Ģ
�ݵ�� ���ڷ� �����ؾ� �Ѵ�.
�̸��� ���̴� 30�� ���Ͽ��� �Ѵ�.
�빮�� ���ĺ��� �ҹ��� ���ĺ��� ���ڸ� ������ �� �ִ�
Ư�����ڴ� $, _, #�� ������ �� �ִ�.
*/
/* ���̺� ������ ������ ����
CHAR ���� ���� ���� ������ ����, �ִ� ���̴� 2000
VARCHAR2 ���� ���� ���� ������ ���� �ִ� ���̴� 4000
LONG ���� ���� ���� ������ ����, �ִ� 2GB�� ���� ������ ���
BLOB ���̳ʸ� ������ �����̸� �ִ� 4GB�� ���� ������ ���
NUMBER ���� ������ �����̸� ���� ������ �ڸ����� �ִ� 38�ڸ�
DATE ��¥ ������ ���� 
*/

CREATE TABLE EMP01
(EMPNO  NUMBER(10), --EMPNO�� ���ڸ� ���� �÷��̹Ƿ� ������ ������ NUMBER�� ����, ������ �ڸ����� 1 ~ 38���� ����
 ENAME  VARCHAR(10), -- ENAME �÷��� ������ �����͸� ���� �÷����� ������ ������ VARCHAR2�� ����, ���̴� 10���� �����Ѵ�. ���� 10�� ���ĺ� ö�� 10�� �ִ�� 4000���̴�.
 SAL    NUMBER(10,2), -- SAL�� ������ �����͸� ���� �÷����� NUMBER������ ����, NUMBER(10,2)�� ���ڸ� ��ü 10�ڸ� ����ε� �Ҽ��� 2�ڸ��� ����Ѵ�. �� 8�ڸ� + �Ҽ��� 2�ڸ� 
 HIREDATE   DATE); -- ��¥�� �����͸� ���� �÷����� DATE�� �����Ѵ�. 

-- ���̺� Ȯ���ϱ�
SELECT * FROM EMP01;

--094 �ӽ� ���̺� �����ϱ� (CREATE TEMPORARY TABLE)
--��� ��ȣ, �̸�, ������ ������ �� �ִ� ���̺��� �����ϴµ� COMMIT�� �� ������ �����͸� ����
-- �ӽ� ���̺� �������� ��Ÿ���� ���� CREATE�� TABLE ���̿� GLOBAL TEMPORARY�� ����Ѵ�. �ӽ� ���̺��� �����͸� ������ ���������� �ʴ´�.
-- ON COMMIT DELETE ROWS : �ӽ� ���̺� �����͸� �Է��ϰ� COMMIT�� �� ������ �����͸� ����
-- ON COMMIT PRESERVE ROWS : �ӽ� ���̺� �����͸� �Է��ϰ� ������ ����� ������ �����͸� ����
CREATE GLOBAL TEMPORARY TABLE EMP37
(EMPNO NUMBER(10),
 ENAME VARCHAR2(10),
 SAL NUMBER(10))
 ON COMMIT DELETE ROWS;
 
SELECT * FROM EMP37;

INSERT INTO EMP37 values(1111, 'scott', 3000);
INSERT INTO EMP37 values(2222, 'smith', 4000);

SELECT * FROM EMP37;

COMMIT;

-- COMMIT�� �ϰ� �Ǹ� �����Ͱ� �������.
SELECT * FROM EMP37;

--095 ������ ������ �ܼ��ϰ� �ϱ�(VIEW)
--������ SALESMAN�� ������� ��� ��ȣ, �̸�, ����, ����, �μ� ��ȣ�� ����ϴ� VIEW�� �����ϱ�
-- CREATE VIEW �̸� ������ AS ���Ŀ� �並 ���ؼ� ������� �� ������ �����Ѵ�. 
CREATE VIEW EMP_VIEW
AS
SELECT empno, ename, sal, job, deptno
FROM emp
WHERE job = 'SALESMAN';

SELECT * FROM EMP_VIEW;

-- VIEW�� �����ϸ� ���� ���̺� ������ �ɱ�?
UPDATE EMP_VIEW SET sal=0 WHERE ename = 'MARTIN';

-- VIEW Ȯ���ϱ�
SELECT * FROM EMP_VIEW;
-- ���� ���̺� Ȯ���ϱ�
SELECT * FROM emp where job = 'SALESMAN';

--Ȯ���غ� ��� VIEW ���̺��� �����ߴµ� ���� ���̺� ������ �Ǿ���. 
-- VIEW�� �����͸� ������ ���� �ʰ� �ܼ��� ���̺��� �ٷ� ���� ��ü�̴�. 

--096 ������ ������ �ܼ��ϰ� �ϱ�(VIEW)
-- �μ� ��ȣ�� �μ� ��ȣ�� ��� ������ ����ϴ� VIEW�� ��������
-- view�� Ŀ������ �׷� �Լ��� ���� �ݵ�� �÷� ��Ī�� ����ؾ� �Ѵ�. 
-- �信 �Լ��� �׷� �Լ��� ���ԵǾ� ������ ���� �����Ѵ�. 
/* View�� ����
              �ܼ� VIEW     ���� VIEW
���̺��� ����    1��             2�� �̻�
�Լ� ���� ����   ���� ����        ����
������ ���� ���� ���� ����         ���� �Ұ��� �� �� ����
*/

CREATE VIEW EMP_VIEW2
AS
SELECT deptno, round(avg(sal)) ��տ���
FROM emp
GROUP BY deptno;

SELECT * FROM EMP_VIEW2;
-- EMP_VIEW2�� ��� ������ �� 30�� �μ� ��ȣ�� ��� ������ 1567���� 3000���� ������ �����ұ�?
-- �Ұ����ϴ�. ���� ������ �ȴٸ� ���� ���̺��� �����Ͱ� ������ �Ǵ°��ε� ��������ϴ� ���պ�� ���� �����͸� ��� ��ȯ���Ѿ� ���� �ָ��ϴ�.
UPDATE emp_view2
set ��տ��� = 3000
WHERE deptno = 30;

--097 ������ �˻� �ӵ��� ���̱�(INDEX)
--������ ��ȸ�� �� �˻� �ӵ��� ���̱� ���� ���޿� �ε����� ������ ����
-- INDEX�� ���̺��� �����͸� �˻��� �� �˻� �ӵ��� ���̱� ���� ���Ǵ� ������ ���̽� ��ü�̴�.
-- �ε��� �̸� ���� ����� ���̺� �̸��� �÷� �̸��� ��Ģ�� �����ϴ�. 
CREATE INDEX EMP_SAL
ON EMP(SAL);

-- ���������� ��ĵ ���
-- ������ ó������ ��ĵ�Ѵ�.
-- ��ĵ �߿� ������ 1600�� ã�´�.
-- ���ʿ� 1600�� �ִ��� ���� ��ü�� ��ĵ�Ѵ�.
-- BUT INDEX�� ���� ��ĵ�� FULL SCAN�� ���� �ʴ´�.
SELECT ename, sal
FROM emp
WHERE sal = 1600;

-- ����� �ߺ����� �ʴ� ��ȣ �����(SEQUENCE)
-- ���� 1������ 100������ ����ϴ� �������� �����ϱ�
CREATE SEQUENCE SEQ1 --SEQ1�� ������ ����
START WITH 1 -- ù ���� ���ڸ� 1�� ����
INCREMENT BY 1 -- ������ ����ġ�� 1�� ����
MAXVALUE 100 -- �ִ� ���ڸ� 100���� ����
NOCYCLE; -- 100���� ������ ���� �ٽ� 1������ �������� ����

-- �������� �Ϸù�ȣ ������ν� ���ο� ���� �Է��Ҷ� ���ŷο� �۾��� ���� �� �ִ�.
CREATE TABLE EMP02
(EMPNO NUMBER(10),
 ENAME VARCHAR2(10),
 SAL NUMBER(10));
 
-- �������� ����Ͽ� ������ �Է��ϱ� 
SELECT * FROM EMP02;

INSERT INTO EMP02 VALUES(SEQ1.NEXTVAL, 'JACK', 3500);
INSERT INTO EMP02 VALUES(SEQ1.NEXTVAL, 'JAMES', 4500);

SELECT * FROM EMP02;

--099 �Ǽ��� ���� ������ �����ϱ�(FLASHBACK QUERY) 
-- ��� ���̺��� 5�� �� KING �����͸� �˻�
-- AS OF TIMESTAMP���� ���� ������ �ۼ��Ѵ�. SYSTIMESTAMP�� ���� �ð��� ��Ÿ����.
-- SYSTIMESTAMP - INTERVAL '5' MINUTE�� ���� �ð����� 5���� �� �ð��̴�. 
SELECT * 
FROM EMP
AS OF TIMESTAMP( SYSTIMESTAMP - INTERVAL '5' MINUTE)
WHERE ENAME = 'KING';

-- KING�� ������ ��ȸ�Ѵ�,
SELECT * 
FROM EMP
WHERE ENAME = 'KING';

-- KING�� ������ 0���� �����ϱ�
UPDATE EMP
SET SAL = 0
WHERE ENAME = 'KING';

SELECT * FROM EMP
WHERE ENAME = 'KING';

COMMIT;
-- ���� sal�� 0���� �ٲٱ��� Ȯ���ϱ�
SELECT ename, sal
FROM EMP
AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '5' MINUTE)
WHERE ENAME = 'KING';

-- �����͸� �÷��� ���� �� �ִ� ��� Ÿ���� 15���̴�. 
-- �̴� ������ ���̽��� �Ķ������ UNDO_RETENTION���� Ȯ�� �����ϴ�. 
SELECT name, value
FROM V$PARAMETER
WHERE name = 'unod_retention';

-- �Ǽ��� ���� ������ �����ϱ�(FLASHBACK TABLE)
-- ��� ���̺��� 5�������� �ǵ��� ����
-- FLASH BACK �Ϸ��� ���� FLASHBACK�� ������ ���·� ������ ���ֱ�
-- ALTER ��ɾ�� ���̺��� �÷������� ������ ����� �����Ѵ�. 
ALTER TABLE emp ENABLE ROW MOVEMENT;

FLASHBACK TABLE EMP TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '5' MINUTE);

SELECT * FROM emp;