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

--031

--81�� 11�� 17�Ͽ� �Ի��� ����� �̸��� �Ի����� ����ϱ�
SELECT ename, hiredate FROm emp 
WHERE hiredate = TO_DATE('81/11/17', 'RR/MM/DD');

-- �׻� ��¥�� ��ȸ�ϱ� ���ؼ��� ������ ������ ��¥ ������ Ȯ���ϱ� 
-- ��¥ ���� Ȯ���ϴ� ����
SELECT * FROM NLS_SESSION_PARAMETERS 
WHERE parameter = 'NLS_DATE_FORMAT';

--���� ��¥���� �����ϱ� 
ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/RR';

-- ���ǿ� �°Բ� 81�� 11�� 17�ϻ� ��ȸ�ϱ�
SELECT ename, hiredate FROM emp 
WHERE hiredate = '17/11/81';

-- ���Ǻ����� ������� �ʰ� ������ ����ؼ� �˻��غ���
-- �׷� ������ �����ߴ� ��¥ �������˰� ������� ��ȸ �����ϴ�.
SELECT ename, hiredate FROM emp
WHERE hiredate = TO_DATE('81/11/17', 'RR/MM/DD');

-- �ٽ� ��¥ ������ RR/MM/DD�� �����ϱ�
ALTER SESSION SET NLS_DATE_FORMAT = 'RR/MM/DD';


-- 032

--�ӽ��� ����ȯ �����ϱ� 

SELECT ename, sal FROM emp
WHERE sal = '3000';
-- ���� ������ sal�� ������ ������ �÷������� ������ '3000'�� ����Ͽ� ���ϰ� �ִ�.
-- �̴� ����Ŭ�� �˾Ƽ� ������ = ������ �� ������ = ���������� �Ͻ������� �� ��ȯ�� �ϱ� �����̴�. 

-- ������ ���̺� �����
CREATE TABLE EMP32
(ENAME VARCHAR2(10),
SAL VARCHAR2(10));

INSERT INTO EMP32 VALUES('SCOTT', '3000');
INSERT INTO EMP32 VALUES('SMITH', '1200');
COMMIT;

SELECT * FROM EMP32;

-- ���ڿ��� ������ SAL�� ���ڿ��� �˻��غ���
SELECT ename, sal FROM emp32 
WHERE sal ='3000';

-- ���ڿ��� ������ sal�� ���ڷ� �˻��ϱ�
SELECT ename, sal FROM emp32
WHERE sal = 3000;

--033 NULL �� ��� �ٸ� ������ ����ϱ�

--�̸��� Ŀ�̼��� ����ϴµ�, Ŀ�̼��� NULL�� ������� 0���� ����ϱ�
-- NVL(�÷��̸�, ��� ����ϴ� ����) �� ���ؼ� NULL���� �����ؼ� ����Ѵ�.
SELECT ename, comm, NVL(comm,0) FROM emp;

-- NULL�� + ���� = NULL
SELECT ename, sal, comm, sal+comm FROM emp
WHERE job IN('SALESMAN', 'ANALYST');

--NULL�� 0���� ����Ͽ� ���ϱ�
SELECT ename, sal, comm, NVL(comm, 0), sal+NVL(comm,0) FROM emp
WHERE job IN ('SALESMAN', 'ANALYST');'

/*
NVL2 �Լ��� ����ؼ� SAL + COMM ����ϱ�
NVL2 �Լ��� ('��' NOTNULL, NULL) �� �����ϸ� �ȴ�.
ó�� ���� NOTNULL�̸� NOTNULL�� ���� NULL�̸� NULL�� ���� ����Ѵ�.
*/

SELECT ename, sal, comm, NVL2(comm, sal+comm, sal) FROM emp 
WHERE job IN ('SALESMAN', 'ANALYST');

--034 IF���� SQL�� �����ϱ�

-- �μ���ȣ�� 10���̸� 300, 20���̸� 400, 10,20���� �ƴ϶�� 0�� ����Ѵ�. 
SELECT ename, deptno, DECODE(deptno, 10, 300, 20, 400, 0) as "���ʽ�" FROM emp;

-- �����ȣ�� �����ȣ�� ¦������ Ȧ�������� ����ϴ� ����
-- MOD�Լ��� �������� ��ȯ�ϴ� �Լ��� ���̽����� %�̴�.
-- DECODE(�÷�, IF, ��, ELIF, ��, ELSE) ELSE�� ������ �����ϴ�. 
SELECT empno, mod(empno,2), DECODE(mod(empno,2),0, '¦��',1,'Ȧ��') as "���ʽ�" 
FROM emp;

-- �̸��� ������ ���ʽ��� ����ϴµ� ������ SALESMAN�̸� ���ʽ� 5000, ������ ������ ���ʽ� 2000�� ���
-- elseif ������ �����ϰ� �ٷ� else�������� ��밡���ϴ�.
SELECT ename, job, DECODE(job, 'SALESMAN', 5000, 2000) FROM emp;




