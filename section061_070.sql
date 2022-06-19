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

--061 ���� ���̺��� �����͸� �����ؼ� ����ϱ� (SELF JOIN)

--��� ���̺� �ڱ� �ڽ��� ���̺�� �����Ͽ� �̸�, ����, �ش� ����� ������ �̸��� ������ ������ ���
-- ������ �δ� �÷��� MGR�÷��̴�.
SELECT e.ename as ���, e.job as ����, m.ename as ������, m.job as ����
FROM emp e, emp m
WHERE e.mgr = m.empno and e.job = 'SALESMAN';

--062 ���� ���̺��� �����͸� �����ؼ� ����ϱ� (ON��)

-- ON���� ����� ���� ������� �̸��� ����, ����, �μ� ��ġ�� ���
SELECT e.ename as �̸�, e.job as ����, e.sal as ����, d.loc as �μ���ġ
  FROM emp e JOIN dept d
  ON (e.deptno = d.deptno)
  WHERE e.job='SALESMAN';

--063 ���� ���̺��� �����͸� �����ؼ� ����ϱ�(USING��)

-- USING ���� ����� ���� ������� �̸�, ����, ����, �μ� ��ġ�� ���
SELECT e.ename as �̸�, e.job as ����, e.sal as ����, d.loc as �μ���ġ
  FROM emp e join dept d
  USING (deptno)
  WHERE e.job='SALESMAN';
  
--064 ���� ���̺��� �����͸� �����ؼ� ����ϱ�(NATURAL JOIN)

--NATURAL ���� ������� �̸�, ����, ���ް� �μ� ��ġ�� ���
SELECT e.ename as �̸�, e.job as ����, e.sal as ����, d.loc as �μ���ġ
  FROM emp e natural join dept d
  WHERE e.job='SALESMAN';
  
--065 ���� ���̺��� �����͸� �����ؼ� ����ϱ�(LEFT/RIGHT OUTER JOIN)

--RIGHT OUTER ���� ������� �̸�, ����, ����, �μ� ��ġ�� ���
SELECT e.ename as �̸�, e.job as ����, e.sal as ����, d.loc as �μ���ġ
  FROM emp e RIGHT OUTER JOIN dept d
  ON (e.deptno = d.deptno);

INSERT INTO emp(empno, ename, sal, job, deptno)
       VALUES(8282, 'JACK', 3000, 'ANALYST', 50) ;

COMMIT;

-- LEFT OUTER ���� ������� ����ϱ� 
SELECT e.ename as �̸�, e.job as ����, e.sal as ����, d.loc as �μ���ġ
  FROM emp e LEFT OUTER JOIN dept d
  ON (e.deptno = d.deptno);
  
--066 ���� ���̺��� �����͸� �����ؼ� ����ϱ�(FULL OUTER JOIN)

--FULL OUTER JOIN ������� �̸�, ����, ����, �μ� ��ġ�� ���
SELECT e.ename as �̸�, e.job as ����, e.sal as ����, d.loc as �μ���ġ
  FROM emp e FULL OUTER JOIN dept d
  ON (e.deptno = d.deptno);
  
-- ���� �����ڷ� �����͸� ���Ʒ��� �����ϱ�(UNION ALL)

-- �μ� ��ȣ�� �μ� ��ȣ�� ��Ż ������ ����ϴµ� �� �Ʒ��� �࿡ ��Ż ������ ���
delete  from  emp
 where ename='JACK';

commit;

SELECT deptno, sum(sal)
  FROM emp
  GROUP BY deptno
UNION ALL
SELECT TO_NUMBER(null) as deptno, sum(sal)
  FROM emp;

-- 068 ���� �����ڷ� �����͸� ���Ʒ��� �����ϱ�(UNION)

-- �μ� ��ȣ�� �μ� ��ȣ�� ��Ż ������ ����ϴµ�, �� �Ʒ��࿡ ��Ż ������ ���
SELECT deptno, sum(sal)
  FROM emp
  GROUP BY deptno
UNION 
SELECT null as deptno, sum(sal)
  FROM emp;
  
-- ���� �����ڷ� �������� �������� ����ϱ�(INTERSECT)

-- �μ� ��ȣ 10��, 20���� ������� ����ϴ� ������ ����� �μ� ��ȣ 20��, 30���� ����ϴ� ���� ����� ������ ���
SELECT ename, sal, job, deptno
  FROM emp
  WHERE deptno in (10,20)
INTERSECT
SELECT ename, sal, job, deptno
  FROM emp
  WHERE deptno in (20,30);
  
-- 070 ���� �����ڷ� �������� ���̸� ����ϱ�(MINUS)

-- �μ���ȣ 10��, 20���� ����ϴ� ������ ������� �μ� ��ȣ 20��, 30���� ����ϴ� ������ ��� ���� ���
SELECT ename, sal, job, deptno
  FROM emp
  WHERE deptno in (10,20)
MINUS
SELECT ename, sal, job, deptno
  FROM emp
  WHERE deptno in (20,30);
  
  
