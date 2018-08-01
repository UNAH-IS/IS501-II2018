SELECT A.FIRST_NAME||' '|| A.LAST_NAME AS NAME, SALARY, JOB_ID, B.DEPARTMENT_NAME
FROM EMPLOYEES A
LEFT JOIN DEPARTMENTS B
ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID);


SELECT B.DEPARTMENT_NAME, 
        SUM(SALARY) AS SALARIO_TOTAL, 
        COUNT(*) AS CANTIDAD_EMPLEADOS,
        AVG(SALARY) AS PROMEDIO,
        MAX(SALARY) AS SALARIO_MAXIMO,
        MIN(SALARY) AS SALARIO_MINIMO
FROM EMPLOYEES A
LEFT JOIN DEPARTMENTS B 
ON (A.DEPARTMENT_ID = B.DEPARTMENT_ID)
GROUP BY B.DEPARTMENT_NAME;

SELECT * FROM EMPLOYEES;