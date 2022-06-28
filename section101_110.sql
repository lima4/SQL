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

--101 �Ǽ��� ���� ������ �����ϱ�(FLASHBACK DROP)
-- DROP�� ��� ���̺��� �����뿡�� �����غ���
-- EMP���̺��� DROP�Ͽ� �����뿡 �ִٸ� �����뿡�� �ٽ� �����Ѵ�. 
FLASHBACK TABLE emp TO BEFORE DROP;

-- ���̺� DROP �� ������ Ȯ���ϱ�
-- ���̺� �����ϱ�
DROP TABLE emp;
-- ������ Ȯ���ϱ�
SELECT original_name, droptime
  FROM user_recyclebin;
  
-- �����ϱ�
FLASHBACK TABLE emp TO BEFORE DROP;

-- ���̺� Ȯ���ϱ�
SELECT * FROM emp;

--102 �Ǽ��� ���� ������ �����ϱ�
--��� �׺����� �����Ͱ� ���� Ư�� �������� ���ݱ��� ��� ����Ǿ� �Դ��� �̷� ���� ���

-- ���� �ð� Ȯ���ϱ�
SELECT SYSTIMESTAMP FROM DUAL;

-- KING�� ������ Ȯ���ϱ�
SELECT ename, sal 
    FROM emp
    WHERE ename = 'KING';
    
-- KING�� ������ 8000���� �����ϱ�
UPDATE emp
    SET sal = 8000
    WHERE ename = 'KING';
    
-- KING�� �μ� ��ȣ�� 20������ ����
UPDATE emp
    SET deptno = 20
    WHERE ename = 'KING';

COMMIT;

SELECT * FROM emp
WHERE ename = 'KING';

-- ����� �̷����� Ȯ���ϱ� 
SELECT ename, sal, deptno, versions_starttime, versions_endtime, versions_operation
  FROM emp
  VERSIONS BETWEEN TIMESTAMP TO_TIMESTAMP('2022-06-27 08:20:00','RRRR-MM-DD HH24:MI:SS')
                AND MAXVALUE
  WHERE ename='KING'
  ORDER BY versions_starttime;

-- 104 ������ ǰ�� ���̱�(PRIMARY KEY)
-- DEPTNO �÷��� PRIMARY KEY ������ �ɸ鼭 ���̺��� �����ϴ� ����
-- PRIMARY KEY ������ �ɸ� �÷����� �ߺ��� �����Ϳ� NULL ���� �Է��� �� ����. ���� ��� ��� ��ȣ, �ֹ� ��Ϲ�ȣ 
CREATE TABLE DEPT2
(DEPTNO NUMBER(10) CONSTRAINT DPET2_DEPTNO_PK PRIMARY KEY, -- CONSTRAINT Ű���� ���� (���̺��_ �÷���_�����������)���� ������ش�. 
 DNAME VARCHAR2(14),
 LOC VARCHAR2(10));
 
SELECT * FROM DEPT2;

-- ���̺� ���� �Ŀ��� ������ �ɱ�
CREATE TABLE DEPT2
(DEPTNO NUMBER(10),
 DNAME VARCHAR2(13),
 LOC VARCHAR2(10));
-- ���� �߰��ϱ� 
ALTER TABLE DEPT2
ADD CONSTRAINT DEPT2_DEPTNO_PK PRIMARY KEY(DEPTNO);

-- 105 �������� ǰ�� ���̱�(UNIQUE)
-- ���̺��� �÷� �߿��� �ߺ��� �����Ͱ� �־�� �� �Ǵ� �÷��� �ִ�. 
-- �̋��� UNIQUE ������ ����Ͽ� ���̺��� Ư�� �÷��� �ߺ��� �����Ͱ� �Էµ��� �ʰ� ������ �Ǵ�.
-- PRIMARY KEY ������� �޸� UNIQUE ������ �ɸ� �÷����� NULL���� �Է� �����ϴ�.
CREATE TABLE DEPT3
(DEPTNO NUMBER(10),
 DNAME VARCHAR2(14) CONSTRAINT DEPT3_DNAME_UN UNIQUE,
 LOC VARCHAR2(10));
 
-- ���̺��� ������ �Ŀ� ������ �ɱ�
CREATE TABLE DEPT4 
(DEPTNO NUMBER(10),
 DNAME VARCHAR2(13),
 LOC VARCHAR2(10));
 
ALTER TABLE DEPT4
ADD CONSTRAINT DEPT4_DNAME_UN UNIQUE(DNAME);

--106 �������� ǰ�� ���̱� (NOT NULL)
-- NOT NULL ������ Ư�� �÷��� NOT NULL �� �Է��� ������� �ʰ� �Ѵ�.
CREATE TABLE DEPT5
(DEPTNO NUMBER(10),
 DNAME VARCHAR2(14),
 LOC VARCHAR2(10) CONSTRAINT DEPT5_LOC_NN NOT NULL);
 
-- ���� ���� ���� �ɱ� (BUT ���� ���̺��� ������ �߿� NULL���� �������� �ʾƾ߸� ���� ����)
CREATE TABLE DEPT6
(DEPTNO NUMBER(10),
 DNAME VARCHAR2(13),
 LOC VARCHAR2(10));

-- �ٸ� ����� �ٸ��� NOT NULL ������ ADD�� �ƴ϶� MODIFY�� �����Ѵ�. 
-- ���� NOT NULL �������� ��ȣ�� ���� �÷����� ������� �ʴ´�. 
ALTER TABLE DEPT6
    MODIFY LOC CONSTRAINT DEPT6_LOC_NN NOT NULL;

--107 �������� ǰ�� ���̱�(CHECK)
-- ��� ���̺��� �����ϴµ� ������ 0���� 6000������ �����͸� �Էµǰų� ������ �� �ֵ��� �����ϱ�
-- CHECK ������ Ư�� �÷��� Ư�� ������ �����͸� �Էµǰų� �����ǵ��� ������ �Ŵ� �����̴�. 
-- ���� ��� ������ ��� ����, ���ڸ� �Էµǵ��� �Ѵ�.
CREATE TABLE EMP6
(EMPNO NUMBER(10),
 ENAME VARCHAR2(20),
 SAL NUMBER(10) CONSTRAINT EMP6_SAL_CK
 CHECK (SAL BETWEEN 0 AND 6000));
 
SELECT * FROM EMP6;

-- ���� SAL�÷��� 9000���� �����Ű�� �ʹٸ� �Ұ����ϴ�.
UPDATE EMP6
SET sal = 9000
WHERE ename = 'CLARK';

-- CHECK ���࿡ ����Ǿ��ٰ� ���´�. 
INSERT INTO emp6 VALUES(7566, 'ADAMS', 9000);

-- ���� �����ϰų� �Է��Ϸ��� üũ ������ �����ؾ� �Ѵ�. 
ALTER TABLE EMP6
DROP CONSTRAINT emp6_sal_ck;

INSERT INTO emp6 VALUES(7566, 'ADAMS', 9000);

--108 �������� ǰ�� ���̱� (FOREIGN KEY)
-- ��� ���̺��� �μ� ��ȣ�� �����͸� �Է��� �� �μ� ���̺� �����ϴ� �μ� ��ȣ�� �Էµ� �� �ֵ��� ���� ����
-- DEPTNO �÷��� PRIMARY KEY ������ �ɾ DEPT7 ���̺��� �����Ѵ�.
CREATE TABLE DEPT7
(DEPTNO NUMBER(10) CONSTRAINT DEPT7_DEPTNO_PK PRIMARY KEY,
 DNAME VARCHAR2(14),
 LOC VARCHAR2(10));

-- EMP7 ���̺��� �����ϴµ� DEPTNO�� �ڽ�Ű(FOREIGN KEY)�� �ɾ �����Ѵ�. 
-- REFERENCES�� ���ؼ� �����ϰڴٰ� ����Ѵ�. �� DEPT7���̺��� �θ� ���̺�, EMP7���̺��� �ڽ� ���̺��̵ȴ�. 
CREATE TABLE EMP7
(EMPNO NUMBER(10),
 ENAME VARCHAR2(20),
 SAL NUMBER(10),
 DEPTNO NUMBER(10)
 CONSTRAINT EMP7_DEPTNO_FK REFERENCES DEPT7(DEPTNO));
 
 SELECT * FROM EMP7;
/*
EMP7 ���̺��� DEPTNO�� DEPT7 ���̺��� DEPTNO�� �����ϰ� �־ EMP7 ���̺��� DEPTNO�� �����͸� �Է� �Ǵ� ������ �� 
DEPT7���̺��� DEPTNO�� �����ϴ� �μ� ��ȣ�� ���ؼ��� �Է�, ������ �����ϴ�. 
���� ������ �ɸ� ��Ȳ���� DEP7 ���̺��� PRIMARY KEY�� �����Ϸ��� ���� ���� �ʴ´�. �ڽ� ���̺��� EMP7 ���̺��� �θ� ���̺��� DEPT7 ���̺��� �����ϰ��ִ�.
CASCADE �ɼ��� �ٿ��� ���� �����ϴ�. �̋��� EMP7 ���̺��� FOREIGN KEY ���൵ ���� �����ȴ�. 
*/
 
 --109 WITH �� ����ϱ�(WITH ~ AS)
 -- WITH ���� �̿��Ͽ� ������ ������ ��Ż ������ ����ϴµ� ������ ��Ż ���޵��� ��հ����� �� ū ����� ���
 -- SQL�� �˻��ð��� ���� �ɸ��� ���� ���ؼ� ������ ���̱� ���� ������� WITH���� ����Ѵ�
 -- SQL�� �� �� �ݺ��Ǵ� ���� WITH���� ������ �����̴�. 

 WITH JOB_SUMSAL AS (SELECT JOB, SUM(SAL) as ��Ż -- ������ ������ ��Ż ������ ����Ͽ� �ӽ� ���� ������ ���̺� ���� JOB_SUMSAL�� ������� �����Ѵ�. 
                     FROM EMP
                     GROUP BY JOB)
SELECT JOB, ��Ż -- �� �� JOB_SUMSAL�� ����� �����͵��� �ҷ��ͼ� ������ ��Ż ���޵��� ��հ����� �� ū ������ ��Ż ������ ����Ѵ�. 
    FROM JOB_SUMSAL
    WHERE ��Ż > (SELECT AVG(��Ż)
                  FROM JOB_SUMSAL);
                  
-- ���� WITH���� �������� �ʰ� SUB QUERY���ô� ������ ����.
SELECT job, sum(sal) as ��Ż
    FROM emp
    GROUP BY JOB
    HAVING SUM(SAL) > (SELECT AVG(SUM(SAL))
                       FROM EMP
                       GROUP BY JOB);
                       
-- 110 WITH�� ����ϱ�(SUQBUERY FACTORING)
WITH JOB_SUMSAL AS (SELECT JOB, SUM(SAL) ��Ż
                    FROM EMP
                    GROUP BY JOB),
    DEPTNO_SUMSAL AS (SELECT DEPTNO, SUM(SAL) ��Ż
                      FROM EMP
                      GROUP BY DEPTNO
                      HAVING SUM(SAL) > (SELECT AVG(��Ż) + 3000
                                         FROM JOB_SUMSAL)
                    )
    SELECT DEPTNO, ��Ż
    FROM DEPTNO_SUMSAL;
