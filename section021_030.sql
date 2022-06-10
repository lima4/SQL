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

-- 021 Ư�� ö�ڸ� N�� ��ŭ ä���

-- �̸��� ������ ����ϴµ� ���� �÷��� �ڸ����� 10�ڸ��� �ϰ� ������ ���, ���� �������� ��ǥ�� ä���
-- LPAD�� (�÷�, �ڸ���, ������)�Ƿ� ���ʿ� ��ġ��Ű�� ������ �ڸ����� *�� ä���. SALARY �÷��� 4�ڸ��� ���� 6�ڸ��� *�� ä������.
-- RPAD�� (�÷�, �ڸ���, ������)�Ƿ� �����ʿ� ��ġ��Ű�� ������ �ڸ����� *�� ä���. 
SELECT ename, LPAD(sal, 10, '*') as salary1, RPAD(sal, 10, '*') as salary2 FROM emp;

-- lpad�� ����ؼ� bar_chart�� �׸��µ� ó���� �� �÷��� *�� �����Ͽ� *�� ä������ �Ѵ�. 
SELECT ename, sal, lpad('*', round(sal/100), '*') as bar_chart From emp;

--021 Ư�� ö�� �߶󳻱�

-- ù ��° �÷��� ���� �ܾ� smith ö�ڸ� ���, �� ��° �÷��� ���� �ܾ� smith���� s�� �߶� ���, �� ��° �÷��� ���� �ܾ� smith���� h�� �߶� ���, �� ��° �÷��� ���� �ܾ� smiths�� ���� s�� �߶� ����Ѵ�
-- LTRIM�� ���� ö�� �ڸ���, RTRIM�� ������ ö�� �ڸ���, TRIM�� ���� ö�� �ڸ��� 
SELECT 'smith', LTRIM('smith', 's'), RTRIM('smith', 'h'), TRIM('s' from 'smiths') FROM dual;

-- INSERT �������� ���(EMP) ���̺��� JACK ����� ������ ���� �־ �Է��ϱ�
INSERT INTO emp(empno, ename, sal, job, deptno) values(8291, 'JACK ', 3000, 'SALESMAN', 30);

commit;

-- JACK�̶�� ����� �̸��� ���� ��ȸ�ϱ� JACK�� �����ʿ� �������� ���ؼ� ��ȸ �Ұ����ϴ�.
SELECT ename, sal FROM emp WHERE ename = 'JACK';

-- ���� �����Ͽ� �˻��ϱ� 
SELECT ename, sal FROM emp WHERE RTRIM(ename)='JACK';

-- JACK ������ �����ϱ�
DELETE FROM emp WHERE TRIM(ename) ='JACK';

commit;

-- 023 �ݿø��ؼ� ����ϱ�

--876.567�̶�� ���ڸ� ����ϴµ� �Ҽ��� �� ���� �ڸ��� 6���� �ݿø��ؼ� ����ϱ�
-- ROUND �Լ��� (��, �ڸ���) �� ����Ѵ�. �� 2���� �ڸ����� �ݿø� �ϱ�
SELECT '876.567' as ����, ROUND(876.567, 1) FROM dual;

--024 ���ڸ� ������ ����ϱ� 

-- 876.567���ڸ� ����ϴµ� �Ҽ��� �� ��° �ڸ��� 6�� �� ������ ���ڵ��� ��� ������
-- TRUNC(��, ���� �Ҽ��� �ڸ���) ���� �Ҽ��� �ڸ��� ���ϴ� ���� ������.
SELECT '876.567' as ����, TRUNC(876.567,1) FROM dual;

--025 ���� ������ �� ����ϱ�(MOD)

--���� 10�� 3���� ���� ������ ���� ��� �Ǵ��� ����ϱ�
SELECT MOD(10,3) FROM dual;

-- �����ȣ�� Ȧ���̸� 1, ¦���̸� 0�� ����ϴ� ���� 2�� �������� �� �������� 0�̸� ¦��, 1�̸� Ȧ���̴�.
SELECT empno, MOD(empno, 2) FROM emp;

-- ��� ��ȣ�� ¦���� ������ ��� ��ȣ�� �̸��� ���
SELECT empno, ename FROm emp WHERE MOD(empno,2) =0;

-- 10�� 3���� ���� ���� ����϶� FLOOR �Լ� ���� ���� 3.333333������ FLOOR�� 3�� 4���̿��� ���� �������� ����Ѵ�.
SELECT FLOOR(10/3) FROM DUAL; --3.3333333
-- 15/4 = 3.75
SELECT FLOOR(15/4) FROM DUAL; --3.75�̳� ���� ���� ���ڷμ� 3�� ��µȴ�.

-- 026 ��¥ �� ���� �� ����ϱ�

-- �̸��� ����ϰ� �Ի��� ��¥���� ���ñ��� �� ����� �ٹ��ߴ��� ����غ���
-- MONTHS_BETWEEN�� ��¥�� �ٷ�� �Լ��μ� (�ֽų�¥, ���� ��¥)�� �Է��Ѵ�. 
-- sysdate�� ������ �ǹ��Ѵ�. 
SELECT ename, MONTHS_BETWEEN(sysdate, hiredate) FROM emp;

-- 027 ���� �� ���� ��¥ ����ϱ� (ADD_MONTHS)

-- 2019�� 5�� 1�Ϸκ��� 100�� ���� ��¥�� ?
-- 100���� ���ϱ� ���ؼ� ADD_MONTHS ����ϱ� 
SELECT ADD_MONTHS(TO_DATE('2019-05-01', 'RRRR-MM-DD'), 100) FROM DUAL;

-- 100�� �ĸ� ����ϴ� ���� �ۼ��ϱ�
-- ���� �ƴ� ���� �Ǹ� ������ 30�Ϸ� ���� 31�Ϸ� �� �� ������ ��Ʊ� ������ ADD_MONTHS ����ϱ�
SELECT TO_DATE('2019-05-01', 'RRRR-MM-DD') + 100 FROM DUAL;

-- 028 Ư�� ��¥ �ڿ� ���� ���� ��¥ ����ϱ� (NEXT_DAY)

-- 2019�� 5�� 22�Ϸκ��� �ٷ� ���ƿ� �������� ��¥ ����ϱ�
-- NEXT_DAY(���� ��¥, ���ϴ� ����) �� ���ؼ� ���� ������ ��¥�� ����Ѵ�.
SELECT '2019/05/22' as ��¥, NEXT_DAY('2019/05/22', '������') FROM DUAL;

-- ���� ��¥�� ����ϱ�
SELECT SYSDATE as "���� ��¥" FROM DUAL;

-- ������ ���ƿ� ȭ������ ��¥ ���
SELECT NEXT_DAY(SYSDATE, 'ȭ����')as "������ ȭ����" FROM DUAL;

--029 Ư�� ��¥�� �ִ� ���� ������ ��¥ ����ϱ�(LAST_DAY)

--2019�� 5�� 22�� �ش� ���� ������ ��¥ ���
-- LAST_DAY(���س�¥)�� ���ؼ� ���� ��¥�� ���� ������ ��¥ ����Ѵ�.
SELECT '2019/05/22' as "��¥", LAST_DAY('2019/05/22') as "������ ��¥" FROM DUAL;

-- �̹��� ���ϱ��� ���� �� �� ���
SELECT LAST_DAY(SYSDATE) - SYSDATE as "���� ��¥" FROM DUAL;

--030 ���������� ������ ���� ��ȯ�ϱ�

--�̸��� SCOTT�� ����� �̸��� �Ի��� ������ ����ϰ� SCOTT�� ���޿� õ ������ ���� �� �ִ� ,�� �ٿ� ���
-- TO_CAHR(hiredate, 'DAY')�� �Ի����� ���Ϸ� ����Ѵ�. TO_CHAR(sal, '999,999')�� ������ ����� �� õ ������ ǥ���ؼ� ����Ѵ�. 
-- ������ ������ ������ ���ڷ� ��ȯ�ϰų� ��¥�� ������ ������ ���������� ��ȯ�� �� TO_DATE �Լ��� ����Ѵ�. 
SELECT ename, TO_CHAR(hiredate, 'DAY') as ����, TO_CHAR(sal, '999,999') as ���� FROM emp WHERE ename = 'SCOTT';

--��¥�� ���ڿ��� ��ȯ�ϸ� ��, ��, ��, ������ �����ؼ� ����� �� �ִ�.
SELECT hiredate, TO_CHAR(hiredate, 'RRRR') as ����, TO_CHAR(hiredate, 'MM') as ��, TO_CHAR(hiredate, 'DD') as ��, TO_CHAR(hiredate, 'DAY') as ���� FROM emp WHERE ename='KING';

/* ��¥ ����
���� RRRR YYYY RR YY
�� MM MON
�� DD
���� DAY DY
�� WW IW W
�ð� HH HH24
�� MI
�� SS */

-- 1981�⵵�� �Ի��� ����� �̸��� �Ի����� ���
SELECT ename, hiredate FROM emp WHERE TO_CHAR(hiredate, 'RRRR') = 1981;

-- ��¥ �÷����� ����/��/��/�ð�/��/�ʸ� �����ϱ� ���ؼ� EXTRACT �Լ��� ����ص� �ȴ�.
SELECT ename as �̸�, EXTRACT(year from hiredate) as ����, 
                     EXTRACT(MONTH from hiredate) as ��,
                     EXTRACT(day from hiredate) as �� FROM emp;

