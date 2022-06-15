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

--051 ������ �м� �Լ��� ���� ����ϱ� (RATIO_TO_REPORT)

--�μ���ȣ�� 20���� ������� �����ȣ, �̸�, ������ ����ϰ� 20�� �μ� ������ �ڽ��� ���� ���� ���
--RATIO_TO_REPORT�� �ڽ��� ���� / 20���� ������� �� ���� �հ� �� ������ ��Ÿ����.
SELECT deptno, ename, sal, RATIO_TO_REPORT(sal) OVER () as ����
FROM emp
WHERE deptno = 20;

--052 �����ͺм� �Լ��� ���� ��� ����ϱ�(ROLLUP)

--������ ������ ��Ż ������ ����ϴµ�, �� ������ �࿡ ��Ż ������ ���
-- ROLLUP�� �̿��Ͽ� ������ ������ ��Ż������ ����ϰ� �� ������ �࿡ ��ü �հ踦 �߰��� ����Ѵ�.
SELECT job, sum(sal)
FROM emp
GROUP BY ROLLUP(job);

-- ROLLUP�÷��� 2���� ����ϸ� 2���� �°Բ� �հ踦 ���ش�.
SELECT deptno, job, sum(sal)
FROM emp
GROUP BY ROLLUP(deptno, job);


--053 �����ͺм� �Լ��� ���� ��� ����ϱ�(CUBE)

--����, ������ ��Ż ������ ����ϴµ�, ù ���� �࿡ ��Ż ������ ���
SELECT job, sum(sal)
FROM emp
GROUP BY CUBE(job);

-- CUBE�� �÷� 2���� ����� ����
--��ü ��Ż ����, ������ ��Ż����, �μ� ��ȣ�� ��Ż����, �μ� ��ȣ�� ������ ��Ż������ 4���� ����
SELECT deptno, job, sum(sal)
FROM emp
GROUP BY CUBE(deptno, job);

--054 ������ �м� �Լ��� ���� ��� ����ϱ�(GROUPING SETS)

--�μ���ȣ�� ����, �μ� ��ȣ�� ��Ż ���ް� ������ ��Ż ����, ��ü ��Ż ������ ���
/*
GROUPING SETS((deptno), (job), ()) �μ� ��ȣ�� ����, ������ ����, ��ü ����
GROUPING SETS((deptno), (job)) �μ� ��ȣ�� ����, ������ ����
GROUPING SETS((deptno, job) ()) �μ� ��ȣ�� ������ ����, ��ü ����
GROUPING SETS((deptno, job)) �μ� ��ȣ�� ������ ����
*/
SELECT deptno, job, sum(sal)
FROM emp
GROUP BY GROUPING SETS((deptno), (job), ());

-- 055 ������ �м� �Լ��� ��� ��� �ѹ��� �ϱ�(ROW_NUMBER)
-- ROW_NUMBER()�� ��µǴ� �� �࿡ ������ ���� ���� �ο��ϴ� ������ �м� �Լ�.
-- ROW_NUMBER() �ڿ��� �ݵ�� OVER()�ȿ� ORDER BY ���� �־��־�� �Ѵ�.
SELECT empno, ename, sal, RANK() OVER (ORDER BY sal DESC) RANK,
                        DENSE_RANK() OVER(ORDER BY sal DESC) DENSE_RANK,
                        ROW_NUMBER() OVER (ORDER BY sal DESC) ��ȣ
   FROM emp
   WHERE deptno = 20;

-- �μ� ��ȣ�� ���޿� ���� ���� ���
SELECT deptno, ename, sal, ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal DESC) ��ȣ
   FROM emp
   WHERE deptno in (10, 20);
   
-- 056 ��µǴ� �� �����ϱ�(ROWNUM)

-- ��� ���̺��� ��� ��ȣ, �̸�, ����, ������ ��� 5�� �ุ ���
-- ROWNUM�� ��¥�� �÷����� WHERE���� ���ؼ� ��µǴ� ���� ������ �� �ִ�.
SELECT ROWNUM, empno, ename, job, sal
FROM emp
WHERE ROWNUM <=5;

--057 ��µǴ� �� �����ϱ�(SIMPLE TOP-n Queries)

-- ������ ���� ��� ������ �����ȣ, �̸�, ����, ������ 4���� ������ �����ؼ� ���
-- TOP-N QUERY�� ���ĵ� ����κ��� ���� �Ǵ� �Ʒ����� N���� ���� ��ȯ�ϴ� ����
-- ������ ROWNUM�� ����ϸ� FROM���� ���������� ����� �� SQL�� ����������. �׷���
-- FETCH FIRST ROWS ONLY�� ����ϸ� ���ϴ�.
SELECT empno, ename, job, sal
FROM emp
ORDER BY sal DESC FETCH FIRST 4 ROWS ONLY;

-- ������ ���� ����� �߿��� 20%�� �ش��ϴ� ����鸸 ���
SELECT empno, ename, job, sal 
FROM emp
ORDER BY sal desc FETCH FIRST 20 PERCENT ROWS ONLY;

-- WHIT TIES �ɼ��� �̿��ϸ� ���� ���� N���� ���� ���� �����ϴٸ� ���� ���
SELECT empno, ename, job, sal
FROM emp
ORDER BY sal DESC FETCH FIRST 2 ROWS WITH TIES;

-- OFFSET �ɼ��� ����ϸ� ����� �����ϴ� ���� ��ġ�� �����Ѵ�.
-- (9+1)���� ����� ����Ѵ�. 
SELECT empno, ename, job, sal
FROM emp
ORDER BY sal DESC OFFSET 9 ROWS;

-- OFFSET�� FETCH�� ����ؼ� ����ϱ�
SELECT empno, ename, job, sal
FROM emp
ORDER BY sal DESC OFFSET 9 ROWS
FETCH FIRST 2 ROWS ONLY;

--058 ���� ���̺��� �����͸� �����ؼ� ����ϱ�

-- ��� ���̺�� �μ� ���̺��� �����Ͽ� �̸��� �μ� ��ġ�� ���
-- ���� �ٸ� ���̺� �ִ� �÷����� �ϳ��� ����� ����Ϸ��� JOIN�� ����ؾ� �Ѵ�.
-- ename�� emp���̺�, loc�� dept ���̺� �����ϹǷ� ename�� loc�� �ϳ��� ����� ����ϱ� ���ؼ��� 
-- from���� emp�� dept�� �Ѵ� ����ϰ� �����ϱ� ���� �÷��� deptno�� where�� ���ٴ� ������ �ش�.
-- ���� ���ǹ��� ���� �ʾҴٸ� 14 *4�� 56���� ���� ������ �Ǿ� ��µȴ�.
SELECT ename, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--������ ANALYST�� ����鸸 ����Ѵ�.
SELECT ename, loc, job
FROM emp, dept
WHERE emp.deptno = dept.deptno and emp.job = 'ANALYST';

-- ���� join�� ���� �÷��� deptno�� ����ϰ� �ʹٸ� 
-- SELECT ename, loc, job, deptno�� �ϸ� ������ �߻��Ѵ�.
-- deptno�� emp���� dept���� �����ϴ� �÷����� ��� ���̺��� �� ������ ����� �Ѵ�.
SELECT ename, loc, job, emp.deptno
FROM emp, dept
WHERE emp.deptno = dept.deptno and emp.job = 'ANALYST';

-- ���̺��� �տ� �ٿ��� ����� �ϸ� ������ ����� �̸� �����ϱ� ���� ��Ī�� ����Ѵ�.
SELECT e.ename, d.loc, e.job
FROM emp e, dept d
WHERE e.deptno = d.deptno and e.job = 'ANALYST';

--059 ���� ���̺��� �����͸� �����ؼ� ����ϱ� (NON EQUI JOIN)
-- ���(EMP) ���̺�� �޿� ���(SALGRADE) ���̺��� �����Ͽ� �̸�, ����, �޿� ����� ���
-- emp���̺�� salgrade ���̺��� �����ؼ� ename�� grade�� �ϳ��� ����� ����ϰ��� �Ѵ�.
-- �׷��� emp, dept�� ���� ������ �÷��� ����. �׷��� ����� �� �ִ� non euio join�̴�.
-- �� ���̺� ���̿� ������ �÷��� ������ ����� �÷��� �ִ�. �ٷ� emp���̺��� sal �÷��� salgrade ���̺��� hisal �÷�
-- emp ���̺��� ������ salgrade ���̺��� losal�� hisal ���̿� �ִ�. 
SELECT e.ename, e.sal, s.grade
FROM emp e, salgrade s
WHERE e.sal between s.losal and s.hisal;

--060 ���� ���̺��� �����͸� �����ؼ� ����ϱ�(OUTER JOIN)
-- ���(EMP) ���̺�� �μ�(DEPT) ���̺��� �����ؼ� �̸��� �μ� ��ġ�� ����ϴµ� BOSTON�� ���� ��µǰ� �ϱ�
-- OUTER JOIN�� (+) = �� ����ؼ� �Ѵ�. (+) ������ ���̺� �� ����� �� �������ʿ� �ٿ��ش�.
/*
EQUI JOIN = ������
RIGHTER OUTER JOIN = ������ ��ü
LEFT OUTER JOIN = ���� ��ü
*/
SELECT e.ename, d.loc
FROM emp e, dept d
WHERE e.deptno (+) = d.deptno;