SELECT A.EMPLOYEE_ID, A.FIRST_NAME, A.LAST_NAME, B.DEPARTMENT_NAME
FROM EMPLOYEES A
INNER JOIN DEPARTMENTS B
ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID);

SELECT A.EMPLOYEE_ID, A.FIRST_NAME, A.LAST_NAME, B.DEPARTMENT_NAME
FROM EMPLOYEES A
NATURAL JOIN DEPARTMENTS B;

SELECT A.EMPLOYEE_ID, A.FIRST_NAME, A.LAST_NAME, B.DEPARTMENT_NAME
FROM EMPLOYEES A, DEPARTMENTS B
WHERE A.DEPARTMENT_ID = B.DEPARTMENT_ID;



---Todos los empleados inclusive los que no tienen departamento:
SELECT A.EMPLOYEE_ID, A.FIRST_NAME, A.LAST_NAME, B.*
FROM EMPLOYEES A
LEFT JOIN DEPARTMENTS B
ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID);

--Lista de empleados con departamento y departamentos que no tienen empleados.
SELECT A.EMPLOYEE_ID, A.FIRST_NAME, A.LAST_NAME, B.*
FROM EMPLOYEES A
RIGHT JOIN DEPARTMENTS B
ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID);

--Listar empleados que no tienen departamento:
SELECT A.EMPLOYEE_ID, A.FIRST_NAME, A.LAST_NAME, B.*
FROM EMPLOYEES A
LEFT JOIN DEPARTMENTS B
ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
WHERE B.DEPARTMENT_ID IS NULL;

--Listar todos los departamentos que no tienen empleados:
SELECT A.EMPLOYEE_ID, A.FIRST_NAME, A.LAST_NAME, B.*
FROM EMPLOYEES A
RIGHT JOIN DEPARTMENTS B
ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
WHERE A.DEPARTMENT_ID IS NULL;


--Empleados con departamento, empleados sin departamento y departamentos sin empleados:
SELECT A.EMPLOYEE_ID, A.FIRST_NAME, A.LAST_NAME, B.*
FROM EMPLOYEES A
FULL OUTER JOIN DEPARTMENTS B
ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID);

--Empleados sin departamento y departamentos sin empleados:
SELECT A.EMPLOYEE_ID, A.FIRST_NAME, A.LAST_NAME, B.*
FROM EMPLOYEES A
FULL OUTER JOIN DEPARTMENTS B
ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
WHERE A.DEPARTMENT_ID IS NULL 
OR  B.DEPARTMENT_ID IS NULL;