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

--041 ������ �м� �Լ��� ���� ��� (RANK)

-- ������ ANALYST, MANGER�� ������� �̸�, ����, ����, ������ ������ ���
-- RANK�� ������ ����ϴ� ������ �м� �Լ�, RANK() OVER ������ ������ ��ȣ �ȿ� ����ϰ� ���� �����͸� �����ϴ� SQL������ �ֱ�
-- 1���� 2���̾ 2���� ��µ��� �ʰ� 3������ �ٷ� ��µȴ�. 
-- 2���� ����ϰ� �ʹٸ� DENSE_RANK����ϱ�
SELECT ename, job, sal, RANK() over (ORDER BY sal DESC) ����
  FROM emp 
  WHERE job in ('ANALYST','MANAGER');

-- �������� ������ ���� ������� ������ �ο��ؼ� ���
-- �������� ��� ������ ���ϱ� ���� ORDER BY �տ� PARTITION BY�� ����Ѵ�.
SELECT ename, sal, RANK() over (PARTITION BY job ORDER BY sal DESC) as ����
FROM emp;

--042 ������ �м� �Լ��� ���� ����ϱ� (DENSE_RANK)
-- �ռ� RANK() over ����� �� ������ ������ 2���� ������� �ʰ� 3������ �Ѿ��.
-- DENSE_RANK�Լ��� 1���� 2���̶� 2���� 1������ ����ϰ� ���� ����� 2������ ���

-- ������ ANALYST, MANAGER�� ������� �̸�, ����, ������ ������ ���
SELECT ename, job, DENSE_RANK() over (ORDER BY sal DESC) ����
FROM emp
WHERE job in ('ANALYST', 'MANAGER');

-- 81�⵵�� �Ի��� ������� ����, �̸�, ����, ������ ��� (�������� ������ ���� ����)
SELECT job, ename, sal, DENSE_RANK() over (PARTITION BY job ORDER BY sal DESC) as ����
FROM emp
WHERE hiredate BETWEEN to_date('1981/01/01', 'RRRR/MM/DD')
                       AND to_date('1981/12/31', 'RRRR/MM/DD');
                    

-- DENSE RANK �ٷ� ������ ������ ��ȣ���� ������ ���� �����͸� �ְ� ����ϱ�
-- DENSE_RANK���� ��ȣ�� ���ڸ� ������ sal�� ���� �´� ���� ���
-- ������ 2975�� ����� ��� ���̺��� ������ ������ ��� �Ǵ��� ��� WITHIN�� ~�̳���� ��
-- ��� �׷� �̳����� 2975�� ������ ��� �Ǵ��� ���ڴ�.
SELECT DENSE_RANK(2975) within group (ORDER BY sal DESC) ����
FROM emp;

-- 81�� 11�� 17���� ����� ���̺��� �� ������ �Ի��� ������ ���
SELECT DENSE_RANK('81/11/17') within group (ORDER BY hiredate ASC) ����
FROM emp;

--043 ������ �м� �Լ��� ��� ����ϱ� (NTILE)

--�̸��� ����, ����, ������ ����� ��� 
-- ������ ����� 4������� ����� 1����� 25%, 2����� 25 ~ 50%, 3����� 50 ~ 75% 4����� 75% ~ 100%
-- NTILE�� ����ϰ� �Ǹ� %�� �����µ� ���ڿ� �°Բ� ����������. 
-- �̋� NULLS last�� ����ϸ� NULL�� �������� ����ϰڴٴ� �ǹ��̴�
-- ��������� NULL�� ���� ���� ���´�. �׵ڿ� ���� ���� ���ȴ�.
SELECT ename, job, sal, NTILE(4) over (order by sal desc nulls last) ���
FROM emp
WHERE job in ('ANALYST', 'MANAGER', 'CLERK');

--044 ������ �м� �Լ��� ������ ���� ���(CUME_DIST)

-- �̸��� ����, ������ ����, ������ ���� ������ ���
-- CUME_DIST�� ����� ���� ���� ������ ����Ѵ�.
-- ����� 14������ 1��� 1���� ������ 0.7�� �����Ѵ�.
SELECT ename, sal, RANK() over (order by sal desc) as RANK,
                   DENSE_RANK() over (order by sal desc) as DENSE_RANK,
                   CUME_DIST() over (order by sal desc) as CUM_DIST
FROM emp;

-- PARTITION BY JOB�� ����� �������� CUME_DIST�� ���
SELECT job, ename, sal, RANK() over (partition by job order by sal desc) as RANK,
                        CUME_DIST() over (partition by job order by sal desc) as CUM_DIST
FROM emp;

--045 ������ �м� �Լ��� �����͸� ���η� ����ϱ�(LISTAGG)

--�μ���ȣ�� ����ϰ� �μ� ��ȣ ���� �ش� �μ��� ���ϴ� ������� �̸��� ���η� ����ϱ�
-- LISTAGG �Լ��� �����͸� ���η� ����ϴ� �Լ� ,�� ����ؼ� ,�� ���еǾ� ��Ÿ����.
-- WHITIN GROUP�� ~�̳���� ������ group �Լ� �ڿ� ������ ��ȣ�� ���� �׷��� �����͸� ����ϰڴ�.
-- GROUP BY�� LISTAGG �Լ��� ����Ϸ��� �ʼ��� ����ؾ� �Ѵ�.
SELECT deptno, LISTAGG(ename, ',') within group (order by ename) as EMPLOYEE
FROM emp
GROUP BY deptno;

--������ �� ������ ���� ������� �̸��� ���η� ���
SELECT job, LISTAGG(ename, ',') within group (ORDER BY ename asc) as employee
FROM emp
GROUP BY job;

--���� ���޵� ���� ����Ϸ��� ������ ����� ���� ������ || ����ϱ�
SELECT job, LISTAGG(ename||'('||sal||')',',') within group(ORDER BY ename ASC) as employee
FROM emp
GROUP BY job;

--046 ������ �м� �Լ��� �ٷ� �� ��� ���� �� ����ϱ�

--��� ��ȣ, �̸�, ������ ����ϰ� �� ���� �ٷ� �� ���� ������ ����ϰ� �� ���� ���� ���� ���� ����ϱ�
-- LAG �Լ��� �ٷ� ������ �����͸� ����ϴ� �Լ�, ���� 1�� ����ϸ� �ٷ� �� ���� ��µȴ�.
-- LEAD �Լ��� �ٷ� �������� �����͸� ����ϴ� �Լ�. ���� 1�� ����ϸ� �ٷ� ���� ���� ��µȴ�.
SELECT empno, ename, sal, LAG(sal,1) over (order by sal asc) "�� ��", 
                          LEAD(sal, 1) over (order by sal asc) "���� ��"
FROM emp
WHERE job in ('ANALYST', 'MANAGER');

-- ������ ANALYST, MANAGER�� ������� ��� ��ȣ, �̸�, �Ի���, �ٷ� ���� �Ի��� ����� �Ի���, �ٷ� ������ �Ի��� ����� �Ի����� ��� & �μ���ȣ ���� �����ؼ� ����ϱ�!
SELECT empno, ename, hiredate, LAG(hiredate,1) over (PARTITION BY deptno order by  hiredate asc) "�� �Ի���",
                               LEAD(hiredate,1) over (PARTITION BY deptno order by  hiredate asc) "���� �Ի���"
FROM emp
WHERE job in ('ANALYST', 'MANAGER');

--047 COLUMN�� ROW�� ����ϱ� (SUM+DECODE)

--�μ���ȣ, �μ� ��ȣ�� ��Ż ������ ����ϴµ� ���η� ����ϱ�
SELECT SUM(DECODE(deptno, 10, sal)) as "10", -- �μ���ȣ�� 10���̸� SUM���� ���� sal ����ϱ�
       SUM(DECODE(deptno, 20, sal)) as "20",
       SUM(DECODE(deptno, 30, sal)) as "30"
FROM emp;

-- ����, ������ ��Ż ���� ���(���η�)   
SELECT SUM(DECODE(job,'ANALYST',sal)) as "ANALYST",
          SUM(DECODE(job,'CLERK',sal))  as "CLERK",
          SUM(DECODE(job,'MANAGER',sal)) as "MANAGER",
          SUM(DECODE(job,'SALESMAN',sal)) as "SALESMAN"
  FROM emp;

--048 COLUMNS�� ROW�� ����ϱ� (PIVOT)
--�μ���ȣ, �μ� ��ȣ�� ��Ż ������ PIVOT���� ����ؼ� ���η� ����ϱ�
-- �ռ� DECODE�� ����� ��� ����� PIVOT�� ����ϸ� �� �� ������ ��� �����ϴ�.
SELECT *
FROM (SELECT deptno, sal from emp)
PIVOT(sum(sal) for deptno in (10,20,30));

-- ������ �����͸� �ٷﺸ��, PIVOT���� ����Ͽ� ������ ������ ��Ż ������ ���η� ����ϱ�
SELECT * 
FROM (SELECT job, sal from emp)
PIVOT(sum(sal) for job in ('ANALYST', 'CLERK', 'MANAGER', 'SALESMAN'));

--049 ROW�� COLUMN���� ����ϱ�(UNPIVOT)

--UNPIVOT�� ����ؼ� �÷��� �ο�� ����ϱ�
SELECT *
drop  table order2;

create table order2
( ename  varchar2(10),
  bicycle  number(10),
  camera   number(10),
  notebook  number(10) );

insert  into  order2  values('SMITH', 2,3,1);
insert  into  order2  values('ALLEN',1,2,3 );
insert  into  order2  values('KING',3,2,2 );

commit;

-- UNPIVOT�� ���η� ����Ǿ� �ִ� �����͸� ���η� UNPIVOT��ų ��� �� �̸��̴�. for ������ '������'�� ���η� �Ǿ� �ִ� order2 ���̺� �÷����� unpivt���� ���η� ����� �� �̸��̴�.
SELECT *
 FROM order2
 UNPIVOT (�Ǽ� for ������ in (BICYCLE, CAMERA, NOTEBOOK));
 
SELECT * 
FROM order2
UNPIVOT(�Ǽ� for ������ in (BICYCLE as 'B', CAMERA as 'C', NOTEBOOK as 'N'));

-- ���� order2 ���̺� NULL�� ���ԵǾ� ������ UNPIVOT�� ������� ����� ���� �ʴ´�.
UPDATE ORDER2 SET NOTEBOOK = NULL WHERE ENAME = 'SMITH';
SELECT * 
FROM order2
UNPIVOT(�Ǽ� for ������ in (BICYCLE as 'B', CAMERA as 'C', NOTEBOOK as 'N'));

-- ���� NULL���� �൵ �����Ϸ��� INCLUDE NULLS�� ����ϱ�
SELECT *
FROM order2
UNPIVOT INCLUDE NULLS (�Ǽ� for ������ in (BICYCLE as 'B', CAMERA as 'C', NOTEBOOK as 'N'));

--050 ������ �м� �Լ��� ���� ������ ����ϱ� (SUM OVER)
-- ������ ANALYST, MANAGER�� ������� ��� ��ȣ, �̸�, ����, ������ ����ġ�� ����ϴ� �����Դϴ�.
-- OVER ������ ��ȣ �ȿ��� ���� ������ �����츦 ������ �� �ִ�. 
-- ORDER BY empno�� ���� ��� ��ȣ�� ������������ ������ �ϰ� ���ĵ� ���� �������� ������ ����ġ�� ���
-- UNBOUNDED PRECENDING�� ���� ù ���� ���� ����Ų��. ���� ù ���� ���� ���� 2975�̴�.
-- BETWEEN UNBOUNDED AND CURRENT ROW�� ���� ù ��° ����� ���� ������� ���� ���Ѵ�.
SELECT empno, ename, sal, SUM(SAL) OVER(ORDER BY empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) ����ġ
FROM emp
WHERE job in ('ANALYST', 'MANAGER');

