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

drop  table  salgrade;

create table salgrade
( grade   number(10),
  losal   number(10),
  hisal   number(10) );

insert into salgrade  values(1,700,1200);
insert into salgrade  values(2,1201,1400);
insert into salgrade  values(3,1401,2000);
insert into salgrade  values(4,2001,3000);
insert into salgrade  values(5,3001,9999);

commit;
-- ��� ���̺� ����ϱ�
select * from emp;
-- 003

-- �÷� ��Ī�� �־� �÷��� �����Ͽ� ����ϱ� (as)
SELECT empno as "��� ��ȣ", ename as "��� �̸�", sal as "Salary" FROM emp;

-- �÷� ��Ī�� ������� �ʴ´ٸ� ENAME, SAL*(12+3000)�� �÷�2���� ��µȴ�.
SELECT ename, sal * (12 + 3000) FROM emp;
-- �̸� �����ϱ� ���ؼ� ��Ī ����ϱ� 
SELECT ename, sal * (12+3000) as ���� FROM emp;

-- 004

-- ���� �÷����� ������ �ٿ��� ����ϰ� �ʹٸ� ||�� ����Ѵ�.
SELECT ename || sal FROM emp; 

-- �����ϱ�
SELECT ename || '�� ������' || sal || '�Դϴ�' as "��������" FROM emp;


-- 005

-- �ߺ��� �����͸� �����ؼ� ����ϱ� UNIQUE�� ����ص� �ȴ�.
SELECT DISTINCT job FROM emp;

--006

-- �����ؼ� ����ϱ� asc�� ����ϸ� �������� desc�� ����ϸ� ���������̴�. 
SELECT ename, sal FROM emp
ORDER BY sal asc;

-- �������� ORDER BY �� ����ϱ� ó���� deptno�� ���� �������� ���� �� ���� sal�� �������� �����Ѵ�.
SELECT ename, deptno, sal FROM emp
    ORDER BY deptno asc, sal desc ;

-- SELECT �� �÷��� ���ڸ� ��� ORDER BY�� ����� �����ϴ�.
SELECT ename, deptno, sal FROM emp
ORDER BY 2 asc, 3 desc;

-- 007
-- ������ ���ؼ� �̱� ���ؼ��� WHERE �� ����ϸ� �ȴ�.
SELECT ename, sal, job FROM emp
WHERE sal = 3000;

/*
> ũ��
< �۴�
>= ũ�ų� ����
<= �۰ų� ����
!= ���� �ʴ�
^= ���� �ʴ�
<> ���� �ʴ�
IS NULL NULL������ ����
IN �� ����Ʈ �� ��ġ�ϴ� �� �˻�
BETWEEN AND ~ ���̿� �ִ�
LIKE ��ġ�ϴ� ���� ���� �˻�
*/

--008

-- ename�� SCOTT�� ename, sal, job, hiredate, deptno ���
SELECT ename, sal, job, hiredate, deptno FROM emp
WHERE ename = 'SCOTT';

-- hiredate�� 81/11/17�� �������� ename, hiredate ���
SELECT ename, hiredate FROM emp
WHERE hiredate = '81/11/17';

-- ������ ������ ��¥ ������ NSL_SESSION_PARAMETERS�� ���ؼ� ��ȸ�Ѵ�.
-- RR�� �⵵, MM�� ��, DD�� ��
SELECT * 
FROM NLS_SESSION_PARAMETERS
WHERE PARAMETER = 'NLS_DATE_FORMAT';

-- 009

-- ������ 3600�̻��� ������� �̸��� ������ ����Ѵ�.
SELECT ename, sal*12 as ���� FROM emp
WHERE sal*12 >=3600;

-- NULL�� �������� ���� NULL�� �����ȴ�.
-- ���� ���� �÷��� comm �� salary �÷��� ���� �÷� ����ϱ� 
SELECT ename, sal, comm, sal+comm FROM emp
WHERE deptno = 10;

/* NVL�Լ��� ����ϸ� NULL���� ó���� �� �ִ�.
NULL ���� 0���� ����Ͽ� ��������� �����ϰ� �Ѵ�.
*/
SELECT sal + NVL(comm, 0) FROM emp 
WHERE ename = 'KING';

--010

--������ 1200 ������ ������� �̸��� ����, ����, �μ� ��ȣ�� ���
SELECT ename, sal, job, deptno FROM emp
WHERE sal <=1200;