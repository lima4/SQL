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

--081 ������ ���� �� ����ϱ�

-- ��� ���̺� ��� ���̺� �Է��� �����Ͱ� �����ͺ��̽��� ����ǵ��� �ϱ�
INSERT INTO emp(empno, ename, sal, deptno)
    VALUES(1122, 'JACK', 3000, 20);
    
COMMIT; -- Ŀ��

-- ename�� SCOTT�� ȸ���� SAL�� 4000���� �����Ѵ�.
UPDATE emp SET sal = 4000
WHERE ename = 'SCOTT';

SELECT * from emp;

ROLLBACK;
-- ROLLBACK�� ������ COMMIT�ߴ� �����ͺ��̽��� ���ư���. 
-- UPDATE���� ��� �ȴ�. 
SELECT * from emp;

-- 082 ������ �Է�, ����, ���� �ѹ��� �ϱ�(MERGE)
-- ��� ���̺� �μ� ��ġ �÷��� �߰��ϰ�, �μ� ���̺��� �̿��Ͽ� �ش� ����� �μ� ��ġ�� ���� �����ϱ�
-- ���� �μ� ���̺��� �����ϴ� �μ��ε� ��� ���̺� ���� �μ���ȣ��� ���Ӱ� ��� ���̺� �Է�
ALTER TABLE emp
   ADD loc varchar2(10);
-- MERGE���� ������ �Է°� ����, ������ �� ���� ������ �� �ְ� ���ִ� ��ɾ��̴�. emp���̺� �μ� ��ġ(loc)�÷��� �ش� ����� �μ� ��ġ�� ���� ����
MERGE INTO emp e --MERGE ����� �Ǵ� TARGET ���̺���� �ۼ� 
USING dept d -- USING�� �������� SOURCE ���̺���� �ۼ�, SOURCE ���̺��� DEPT�κ��� �����͸� �о�� DEPT���̺��� �����ͷ� EMP ���̺� MERGE
ON (e.deptno = d.deptno)-- TARGET���̺�� SOURCE���̺��� �����ϴ� ����. ���ο� �����ϸ� MERGE UPDATE���� ����, �����ϸ� MERGE INSERT���� ����
WHEN MATCHED THEN  --���ο� ������ ����Ǵ� ��(���ο� �����ϸ� ��� ���̺��� �μ���ġ �÷��� �μ� ���̺��� �μ� ��ġ�� ����)
UPDATE set e.loc = d.loc 
WHEN NOT MATCHED THEN  --���ο� �����ϸ� ����Ǵ� ��, ���ο� �����ϸ� ������ �μ� ���̺��� �����͸� ��� ���̺� �Է�
INSERT (e.empno, e.deptno, e.loc) VALUES (1111,d.deptno, d.loc) ;

SELECT *
  FROM EMP;

ALTER TABLE emp
   DROP  COLUMN  loc;
   
DELETE FROM emp
  WHERE empno = 1111;

COMMIT;

SELECT *
  FROM EMP;

--083 ��(LOCK)�����ϱ�
--���� �����͸� ���ÿ� ������ �� ������ �ϴ� ��(LOCK)�� �����ϱ�
-- LOCK�� ���� �����͸� �����ϰ� �ٷ� �� ������ �� ����. ������ �Ϸ��� TCL������ ���ؼ� ������ �ϰ� �����ؾ� �Ѵ�.
-- LOCK�� �������� �ϰ����� �����ϱ� ���ؼ� �ʿ��ϴ�.

--084 SELECT FOR UPDATE�� �����ϱ� 

--JONES�� �̸��� ���ް� �μ� ��ȣ�� ��ȸ�ϴ� ���� �ٸ� ���ǿ��� JONES�� �����͸� �������� ���ϵ��� �غ���
-- SELECT... FOR UPDATE���� �˻��ϴ� �࿡ ��(LOCK)�� �Ŵ� SQL���̴�.
/*
SELECT ename, sal, deptno
FROM emp
WHERE ename = 'JONES'
FOR UPDATE; ����� JONES�� �࿡ �ڵ����� ���� �ɸ���. */

/*
UPDATE emp
SET sal = 9000
WHERE ename = 'JONES'; -- �������(������ �ȵ� ����)
*/
-- COMMIT; COMMIT ����� ó�� JONES�� ���� UPDATE�� COMMIT�� �Ϸ� �ǰ�
-- �� �ڿ� 2��° ������ ����ȴ�.

--085 ���� ������ ����Ͽ� ������ �Է��ϱ�
--EMP ���̺��� ������ �״�� ������ EMP2 ���̺� �μ� ��ȣ�� 10���� ������� ��� ��ȣ, �̸�, ����, �μ� ��ȣ�� �� ���� �Է��ϱ�
CREATE TABLE emp2
    as
       SELECT *
          FROM emp
          WHERE 1=2;

SELECT *
  FROM emp2;

--�⺻ INSERT���� �� ���� �ϳ��� �ุ �Էµȴ�. ���� ������ ����Ͽ� INSERT�� �����ϸ� ���� ���� ���� �� ���� ���̺� �Է°���
-- deptno�� 10�� �������� empno, ename, sal, deptno�� emp2���̺� �����ϴ� �����̴�.
INSERT INTO emp2(empno, ename, sal, deptno)
 SELECT empno, ename, sal, deptno
    FROM emp
    WHERE deptno = 10; 

SELECT *
  FROM emp2;

DROP  TABLE  emp2;

--086 ���� ������ ����Ͽ� ������ �����ϱ�
--������ SALESMAN�� ������� ������ ALLEN�� �������� �����غ���
-- UPDATE���� ��� ������ �������� ��밡���ϴ�.
UPDATE emp -- emp���̺��� �����ϴµ�
    SET sal = (SELECT sal --SET���� ���������� ����Ͽ� ������ SALESMAN�� ������� ������ ALLEN�� �������� �����Ѵ�.
                FROM emp
                WHERE ename = 'ALLEN')
WHERE job = 'SALESMAN';

--087 ���������� ����Ͽ� ������ �����ϱ�
--SCOTT���� �� ���� ������ �޴� ������� �����غ���
DELETE FROM emp --emp���̺��� DELETE�� �����ϴµ�
WHERE sal > (SELECT sal FROM emp --�̸��� SCOTT�� sal�����ͺ��� ���� ������� �����ȴ�.
             WHERE ename = 'SCOTT');

-- ������ �ش� ����� ���� �μ� ��ȣ�� ��� ���޺��� ũ�� �����ϴ� ��������
-- ���� ����� emp���̺��� ��Ī�� ����� m.deptno�� ���� ���� ������ ���ͼ� ����� ������ �ڱⰡ ���� �μ� ��ȣ�� ��� ���޺��� ũ�� �����ϰ� ������ �������� �ʴ´�.
DELETE FROM emp m
WHERE sal > (SELECT avg(sal) FROM emp s
             WHERE s.deptno = m.deptno);

-- 088 ���� ������ ����Ͽ� ������ ��ġ��
--�μ� ���̺� ���������� SUMSAL�÷��� �߰��Ѵ�. ��� ���̺��� �̿��Ͽ� SUMSAL �÷��� �����͸� �μ� ���̺��� �μ� ��ȣ�� ��Ż �������� ����

--DEPT ���̺� SUMSAL �÷� �߰��ϱ�
ALTER TABLE dept --dept TABLE�� �����ϴµ� 
   ADD sumsal number(10); -- sumsal�̶�� �÷��� �߰�

MERGE INTO dept d
USING ( SELECT deptno, sum(sal) sumsal --USING������ ���� ������ ����Ͽ� ����ϴ� �����ͷ� DEPT���̺��� MERGE�Ѵ�. ���� �������� ��ȯ�ϴ� �����ʹ� �μ� ��ȣ�� �μ� ��ȣ�� ��Ż �����̴�.
        FROM emp
        GROUP BY deptno) v
ON (d.deptno = v.deptno) -- ���� �������� ��ȯ�ϴ� ���������� �μ� ��ȣ�� ��� ���̺��� �μ� ��ȣ�� ���� ������ �ش�.
WHEN MATCHED THEN -- ���������̼� ��ȯ�ϴ� �μ� ��ȣ�� ��� ���̺��� �μ� ��ȣ�� ���� ��ġ�ϴ��� Ȯ���Ͽ� ��ġ�ϸ� �ش� �μ� ��ȣ�� ��Ż �������� ���� �����Ѵ�.
UPDATE set d.sumsal = v.sumsal;

--089 ������ ���ǹ����� ������ �ְ� ������ ����ϱ�
-- ������ ���ǹ��� �ÿ��Ͽ� ��� �̸�, ����, ������ ����ϴµ� ����� ���� ����(LEVEL)�� ���� ����ϱ�
-- ������ ���ǹ��� ����Ͽ� ��� ���̺��� ����� ���� ������ ����ϴ� ����. 
/* 
NODE ǥ�õ� �׸�
LEVEL Ʈ�� �������� ������ ����
ROOT Ʈ�� �������� �ֻ����� ���
PARENT Ʈ�� �������� ������ ���
CHILD Ʈ�� �������� ������ �ִ� ���
*/
SELECT rpad(' ', level*3)  || ename  as  employee , level, sal, job
  FROM emp
  START WITH ename='KING'
  CONNECT BY prior empno = mgr;
  
--090 ������ ���ǹ����� ������ �ְ� ������ ����ϱ�
--089�� ������� BLAKE�� BLAKE�� ���� ���ϵ��� ��µ��� �ʰ� �ϱ�
SELECT rpad(' ', level*3) || ename as employee, level, sal, job
FROM emp
START WITH ename = 'KING'
CONNECT BY prior empno = mgr AND ename !='BLAKE';