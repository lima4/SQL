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

--035 IF���� SQL�� �����ϱ�
-- �̸�, ����, ����, ���ʽ��� ����ϴ� �����̴�. 
-- ���� ������ 3000�̻��̸� ���ʽ��� 500, 2000�̻��̸� ���ʽ��� 300, 1000�̻��̸� ���ʽ��� 200 �������� 0���� ����Ѵ�.
-- CASE���� DECODE�� �ٸ� ���� DECODE�� ��ȣ(=)�� �� ���������� CASE�� �ε�ȣ, ��ȣ ��� �����ϴ�.
SELECT ename, job,sal , CASE WHEN sal >= 3000 THEN 500
                             WHEN sal >= 2000 THEN 300
                             WHEN sal >= 1000 THEN 200
                             ELSE  0 END AS BONUS
   FROM emp
   WHERE job IN ('SALESMAN', 'ANALYST');

-- �̸�, ����, Ŀ�̼�, ���ʽ��� ����Ѵ�. ���ʽ��� Ŀ�̼��� NULL�̸� 500�� ����ϰ� NULL�� �ƴϸ� 0�� ����Ѵ�.
SELECT ename, job, comm, CASE WHEN comm is null THEN 500
                              ELSE 0 END  BONUS
   FROM emp
   WHERE job in ('SALESMAN', 'ANALYST');
   
-- ���ʽ��� ����� �� ������ SALESMAN, ANALYST�̸� 500�� ����ϰ� ������ CLERK, MANAGER�̸� 400�� ����ϰ� ������ ������ 0�� ����Ѵ�.
SELECT ename, job, CASE WHEN job in ('SALESMAN', 'ANALYST') THEN 500
                        WHEN job in ('CLERK', 'MANAGER') THEN 400
                        ELSE 0 END AS BONUS
   FROM emp;
   
--036 �ִ밪 ����ϱ�

-- ��� ���̺��� �ִ� ������ ����Ѵ٤�
SELECT MAX(sal) FROM emp;

-- ������ SALESMAN�� ����� �� �ִ� ������ ���
SELECT MAX(sal) FROM emp 
WHERE job='SALESMAN';

-- ������ SALESMAN�� ����� �߿��� �ִ� ������ ������ ���� ���
-- ERROR�� ���´�. �̴� job�÷��� �������� ���� ����Ϸ��� �ϳ�, MAX(SAL)�� �ϳ��� �ุ�� ����ϱ� �����̴�.
SELECT job, MAX(sal) FROM emp
WHERE job='SALESMAN';

-- GROUPBY���� ����ϱ�(���� ���� ��Ȳ �߻��� ����) 
SELECT job, MAX(SAL) 
   FROM emp
   WHERE job = 'SALESMAN'
   GROUP BY job;

--037 �ּҰ� ����ϱ�

-- ������ SALESMAN�� ����� �� �ּ� ������ ����� ���ڽ��ϴ�
SELECT MIN(sal)
   FROM emp
   WHERE job = 'SALESMAN';
   
-- ������ ������ �ּ� ������ ����ϴµ� ORDER BY���� ����Ͽ� �ּ� ������ ���� �ͺ��� ���
SELECT job, MIN(sal) as �ּҰ�
   FROM emp
   GROUP BY job
   ORDER BY �ּҰ� DESC;

-- �Լ��� ����ϰ� �Ǹ� WHERE���� ������ �����̾ ����� �׻� ��µȴ�.
-- ������ WHERE�� ���� null ���
SELECT MIN(sal)
   FROM emp
   WHERE 1 = 2;

-- ����, ������ �ּ� ����, �������� SALESMAN�� �����ϰ� ���, ������ �ּ� ������ ���� ������ ���
SELECT job, MIN(sal)
   FROM emp
   WHERE job != 'SALESMAN'
   GROUP BY job
   ORDER BY MIN(sal) DESC;
   
-- 038 ��հ� ����ϱ�

-- ��� ���̺��� ��� ������ ���
-- �����ؾ��� ���� ���� comm �÷��� NULL���� 6�� Null�� �ƴ� �� 4����� 
-- NULL ���� ������ 4���� �÷��� ����̴�. ��ü�� ����� �ƴϴ�.
SELECT AVG(comm)
   FROM emp;

-- NULL ���� 0 ���� ġȯ�Ͽ� ��հ� ���ϱ� �ݿø����ֱ�
SELECT ROUND(AVG(NVL(comm, 0)))
   FROM emp;
   
-- 039 TOTAL �� ����ϱ�

-- �μ� ��ȣ�� �μ� ��ȣ�� ��Ż ������ ���
SELECT deptno, SUM(sal)
   FROM emp
   GROUP by deptno;
   
-- ������ ������ ��Ż ������ ����ϴµ� ������ ��Ż ������ ���������� ���
SELECT job, SUM(sal) as "��Ż ����"
   FROM emp
   GROUP BY job
   ORDER BY "��Ż ����" DESC;

-- ������ ������ ��Ż ������ ����ϴµ� ������ ��Ż ������ 4000 �̻��� �͸� ���
-- WHERE���� �׷� �Լ��� ����ϸ� ������ �߻��Ѵ�. 
SELECT job, SUM(sal)
  FROM emp
  WHERE sum(sal) >= 4000
  GROUP BY job; 

-- �׷��Լ��� ������ �� ���� HAVING���� ����ؾ� �Ѵ�.
SELECT job, SUM(sal)
   FROM emp
   GROUP BY job
   HAVING sum(sal) >=4000;

-- 040 �Ǽ� ����ϱ�

-- ��� ���̺� ��ü ����� ����ϱ�
SELECT COUNT(empno)
   FROM emp;
   
-- �׷��Լ��� NULL���� �����Ѵ�.
SELECT COUNT(comm)
FROM emp;


