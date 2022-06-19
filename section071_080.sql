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

--071 ���� ���� ����ϱ�(������ ��������)

--JONES���� �� ���� ������ �޴� ������� �̸��� ������ ����ϱ�
-- JONES���� �� ���� ������ �޴� ������� �˻��Ϸ��� ���� JONES�� ������ �������� �˾ƾ� �Ѵ�. JONES �� ���� �������� �ۼ�
SELECT ename, sal
  FROM emp
  WHERE sal > (SELECT sal
                        FROM EMP
                        WHERE ename='JONES');

--072 ���� ���� ����ϱ�(���� �� ��������)

--������ SALESMAN�� ������ ���� ������ �޴� ������� �̸��� ������ ���
-- ������ SALESMAN�� ������� �� ���� �ƴ϶� ���� ���̱� ������ =�� ����ϸ� ���� �߻�
-- �̷� ���� in�� ����ؾ� �Ѵ�.

SELECT ename, sal
  FROM emp
  WHERE sal in (SELECT sal
                       FROM emp
                       WHERE job='SALESMAN');

-- 073 ���� ���� ����ϱ�(NOT IN) 

-- �����ڰ� �ƴ� ������� �̸��� ���ް� ������ ���
-- �ڱ� �ؿ� ���� ���� ����� �� �� ���� ������� ����ϴ� ������ NOT IN�� ����Ѵ�.
SELECT ename, sal, job
  FROM emp
  WHERE empno not in (SELECT mgr
                                  FROM emp
                                  WHERE mgr is not null);
                        
-- 074 ���� ���� ����ϱ�(EXISTS�� NOT EXISTS) 

-- �μ� ���̺� �ִ� �μ� ��ȣ �߿��� ��� ���̺��� �����ϴ� �μ� ��ȣ�� �μ� ��ȣ, �μ� ��, �μ� ��ġ�� ���
SELECT *
  FROM dept d
  WHERE EXISTS (SELECT *
                   FROM emp e
                   WHERE e.deptno = d.deptno); 

-- 075 ���� ���� ����ϱ�(HAVING���� ���� ����)
-- ������ ������ ��Ż ������ ����ϴµ�, ������ SALESMAN�� ������� ��Ż ���޺��� �� ū ���鸸 ����ϱ�
SELECT job, sum(sal)
  FROM emp
  GROUP BY job
  HAVING sum(sal) > (SELECT sum(sal)
                       FROM emp
                       WHERE job='SALESMAN');
                       
-- 076 ���� ���� ����ϱ�(FROM ���� ���� ����)
-- �̸��� ���ް� ������ ����ϴµ� ������ 1���� ����� ���
SELECT v.ename, v.sal, v.����
  FROM ( SELECT ename, sal, rank() over (order by sal desc) ����
               FROM emp) v
  WHERE v.���� =1; 

-- 077 ���� ���� ����ϱ�(SELECT ���� ���� ����)
--������ SALESMAN�� ������� �̸��� ������ ����ϴµ� ������ SALESMAN�� ������� �ִ� ���ް� �ּ� ���޵� ���� ����غ���
SELECT ename, sal, (select max(sal) from emp where job='SALESMAN') as �ִ����,
                   (select min(sal) from emp where job='SALESMAN') as �ּҿ���
  FROM emp
  WHERE job='SALESMAN';
  
--078 ������ �Է��ϱ�(INSERT)
-- ��� ���̺� �����͸� �Է��ϴµ� ��� ��ȣ 2812, ��� �̸� JACK, ���� 3500, �Ի��� 2019�� 6�� 15��, ���� ANALYST�� �����ض�
INSERT INTO emp (empno, ename, sal, hiredate, job)
  VALUES(2812, 'JACK', 3500, TO_DATE('2019/06/05','RRRR/MM/DD'), 'ANALYST');
-- ��ü Ȯ���ϱ�
SELECT * 
  FROM  emp;
-- ������ COMMIT���� ���ư���
ROLLBACK;

SELECT * 
  FROM  emp;
  
--079 ������ �����ϱ�(UPDATE)
--SCOTT�� ������ 3200���� �����غ���
UPDATE emp
   SET sal = 3200
   WHERE ename = 'SCOTT';

-- 080 ������ �����ϱ�(DELETE, TRUNCATE, DROP)
-- ��� ���̺��� SCOTT�� �� �����͸� ������ ����
DELETE FROM emp
WHERE ename = 'SCOTT';
