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

-- 011 

--������ 1000���� 3000������ ������� �̸��� ������ ��� (BETWEEN ���Ѱ� AND ���Ѱ�) ������ ����� �Ѵ�. ���� BETWEEN AND �� >= AND <=�� ����.
SELECT ename, sal FROM emp WHERE sal BETWEEN 1000 AND 3000;

-- ������ 1000���� 3000���̰� �ƴ� ������� �̸��� ������ ��ȸ
SELECT ename, sal FROM emp 
WHERE sal NOT BETWEEN 1000 AND 3000;

--012

-- ù���ڰ� S�� �����ϴ� ������� �̸��� ������ ��� %�� ���ϵ� ī���� �ϸ� ù ���ڰ� S�� �����ϸ� ��� �˻�����̴�. 
SELECT ename, sal FROM emp WHERE ename LIKE 'S%';

-- �ι�° ���ڰ� M���� �����ϴ� ����� �̸� ��� (�� ������ ���߱� ���ؼ� �տ� _�� �ִ´�.)
SELECT ename FROM emp WHERE ename LIKE '_M%';

-- �� ���ڰ� T�� ������ ������� �̸��� ���
SELECT ename FROM emp WHERE ename LIKE '%T';

-- �̸��� A�� ���Ե� ��� ������� �˻��϶�
SELECT ename FROM emp WHERE ename LIKE '%A%';

--013

-- NULL�� ������� �̸��� Ŀ�̼� ����ϱ� (NULL�� �����Ͱ� �Ҵ���� ���� ���¶�� �ϰ� �� �� ���� ���̴�.) �� = �δ� �� �Ұ��� 
SELECT ename, comm FROM emp WHERE comm is null;

--014

-- ������ SALESMAN, ANALYST, MANAGER�� ������� �̸�, ����, ������ ���
-- in�� ����Ͽ� in���� ���ڿ� ��ġ�ϴ� ������ ����
SELECT ename, sal, job FROM emp WHERE job in ('SALESMAN', 'ANALYST','MANAGER');

-- SALESMAN, ANALYST, MANAGER�� �ƴ� ������� �̸�, ����, ���� ���
SELECT ename, sal, job FROM emp WHERE job NOT in ('SALESMAN', 'ANALYST', 'MANAGER');

-- 015 ( ��������)

-- ������ SALESMAN�̰� ������ 1200�̻��� ������� �̸�, ����, ������ ����غ���
SELECT ename, sal, job FROM emp 
WHERE job='SALESMAN' AND sal >=1200;

/*
TRUE AND TRUE = TRUE
TRUE AND FALSE = FALSE
TURE AND NULL = NULL

TRUE OR TRUE = TRUE
TRUE OR FALSE = TRUE
TRUE OR NULL = TRUE
*/

--016 ��ҹ��� ��ȯ

--��� ���̺��� �̸��� ����ϴµ� ù ��° �÷��� �̸��� �빮��, �� ��° �÷��� �̸��� �ҹ���, �� ��° �÷��� �̸��� ù ��° ö�ڴ� �빮��, �������� �ҹ��ڷ� ����ϱ�
-- UPPER �빮�� ��ȯ, LOWER �ҹ��� ��ȯ, INITCAP ù ��° ö�ڸ� �빮��
SELECT UPPER(ename), LOWER(ename), INITCAP(ename) FROM emp;

--017 Ư�� ���� �����ϱ�

--���� �ܾ� SMITH���� SMI�� �߶󳻾� ����ϱ�
-- SQL�� ù��°�� 1�� �����ϹǷ� S 1 M 2 I 3 T 4 H 5�̴� 
SELECT SUBSTR('SMITH', 1, 3) FROM DUAL;

-- ���� �ܾ� SMITH���� TH�� �߶� ����
-- -2�ڸ��� T���� 2���� �ܾ� ����
SELECT SUBSTR('SMITH', -2, 2) FROM DUAL;

--MITH �����ϱ�
-- �ι�° �ڸ����� ���� �����Ϸ��� 2��� ���´�. 
SELECT SUBSTR('SMITH', 2) FROM DUAL;

-- 018 ���ڿ��� ���̸� ����ϱ�

-- �̸��� ����ϰ� �� ���� �̸��� ö�� ������ ���
-- LENGTH�� ���ڿ��� ���̸� ����ϴ� �Լ��̴�. �ѱ۵� ���������� ���̰� ��µȴ�.
SELECT ename, LENGTH(ename) FROM emp;

--019 ���ڿ��� Ư�� ö���� ��ġ ����ϱ�
-- ��� �̸� SMITH���� ���ĺ� ö�� M�� �� ��° �ڸ��� �ִ��� ���
-- INSTR �Լ��� ���ڿ��� Ư�� ö���� ��ġ�� ����ϴ� �Լ��̴�. 
SELECT INSTR('SMITH', 'M') FROM dual;

-- ���� abcdefgh@naver.com���� naver.com�� ����ϰ� �ʹٸ� 
-- 1. @�� ��ġ �ľ��ϱ�
SELECT INSTR('abcdefg@naver.com', '@') FROM DUAL; --8��° �ڸ��� ��ġ

-- 2. 8+1 ��° �ڸ����� ������ ����ϸ� �ȴ�
SELECT SUBSTR('abcdefg@naver.com', INSTR('abcdefg@naver.com' ,'@')+1) FROM DUAL;

--020 Ư�� ö�ڸ� �ٸ� ö�ڷ� �����ϱ�

-- �̸��� ������ ����ϴµ�, ������ ����� �� ���� 0�� *�� ����϶�
-- REPLACE�� Ư�� ö�ڸ� �ٸ� ö�ڷ� �����ϴ� ���� �Լ�
SELECT ename, REPLACE(sal, 0, '*') FROM emp;

-- ������ 0, 1, 2, 3�� *�� ����ϱ�
-- REGEXP_REPLACE�� ���Խ� �Լ��̴�. ���Խ� �Լ��� �Ϲ� �Լ����� �� ������ ������ �˻� �������� �����͸� ��ȸ�� �� �ִ�.
SELECT ename, REGEXP_REPLACE(sal, '[0-3]', '*') FROM emp;



