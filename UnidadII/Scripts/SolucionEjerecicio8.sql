
/*
1. Mostrar todos los usuarios que no han creado ning�n tablero, para dichos usuarios mostrar el
nombre completo y correo, utilizar producto cartesiano con el operador (+).
*/

--51 REGISTRO
SELECT A.NOMBRE || ' ' ||A.APELLIDO AS NOMBRE_COMPLETO, 
        A.CORREO
FROM TBL_USUARIOS A,
    TBL_TABLERO B
WHERE A.CODIGO_USUARIO = B.CODIGO_USUARIO_CREA (+)
AND B.CODIGO_USUARIO_CREA IS NULL;


/*
Mostrar la cantidad de usuarios que se han registrado por cada red social, mostrar inclusive la
cantidad de usuarios que no est�n registrados con redes sociales.
*/


SELECT *
FROM TBL_USUARIOS;

SELECT * 
FROM TBL_REDES_SOCIALES;
--119 EN FACEBOOK
SELECT NVL(B.NOMBRE_RED_SOCIAL,'SIN RED SOCIAL') AS RED_SOCIAL, 
        COUNT(*) AS CANTIDAD_USUARIOS
FROM TBL_USUARIOS A
LEFT JOIN TBL_REDES_SOCIALES B
ON (A.CODIGO_RED_SOCIAL = B.CODIGO_RED_SOCIAL)
GROUP BY NVL(B.NOMBRE_RED_SOCIAL,'SIN RED SOCIAL');

/*
3. Consultar el usuario que ha hecho m�s comentarios sobre una tarjeta (El m�s prepotente), para
este usuario mostrar el nombre completo, correo, cantidad de comentarios y cantidad de
tarjetas a las que ha comentado (pista: una posible soluci�n para este �ltimo campo es utilizar
count(distinct campo))

*/

SELECT A.CODIGO_USUARIO, A.NOMBRE, A.APELLIDO, COUNT(*) cantidad_comentarios
FROM TBL_USUARIOS  A
INNER JOIN TBL_COMENTARIOS B
ON A.CODIGO_USUARIO = B.CODIGO_USUARIO
GROUP BY A.CODIGO_USUARIO, A.NOMBRE, A.APELLIDO
having count(*) = (
                    SELECT max(cantidad_comentarios)
                    FROM (
                        SELECT codigo_usuario,count(*) as cantidad_comentarios
                        FROM TBL_COMENTARIOS
                        group by codigo_usuario
                    )
                )
ORDER BY CODIGO_USUARIO;

/*
Mostrar TODOS los usuarios con plan FREE, de dichos usuarios mostrar la siguiente informaci�n:
� Nombre completo
� Correo
� Red social (En caso de estar registrado con una)
� Cantidad de organizaciones que ha creado, mostrar 0 si no ha creado ninguna.
*/

SELECT A.CODIGO_USUARIO, nombre || ' '|| apellido as nombre_completo,
        correo,
        NVL(b.NOMBRE_RED_SOCIAL, 'Ninguna') NOMBRE_RED_SOCIAL,
        --C.CODIGO_ORGANIZACION
        COUNT(C.CODIGO_ORGANIZACION) CANTIDAD_ORGANIZACIONES
FROM TBL_USUARIOS a
LEFT JOIN TBL_REDES_SOCIALES b
ON (a.CODIGO_RED_SOCIAL = b.CODIGO_RED_SOCIAL)
LEFT JOIN TBL_ORGANIZACIONES C
ON (a.CODIGO_USUARIO = C.CODIGO_ADMINISTRADOR)
WHERE codigo_plan = 1
GROUP BY A.CODIGO_USUARIO,nombre || ' '|| apellido,
        correo,
        NVL(b.NOMBRE_RED_SOCIAL, 'Ninguna')
ORDER BY A.CODIGO_USUARIO;

SELECT CODIGO_ADMINISTRADOR, COUNT(*) CANTIDAD_ORGANIZACIONES
FROM TBL_ORGANIZACIONES
GROUP BY CODIGO_ADMINISTRADOR
ORDER BY CODIGO_ADMINISTRADOR;


/*
Mostrar los usuarios que han creado m�s de 5 tarjetas, para estos usuarios mostrar:
Nombre completo, correo, cantidad de tarjetas creadas
*/


SELECT  B.CODIGO_USUARIO,B.NOMBRE||' '||B.APELLIDO AS NOMBRE_COMPLETO,
        B.CORREO,
        COUNT(*) CANTIDAD_TARJETAS
FROM TBL_TARJETAS A
INNER JOIN TBL_USUARIOS B
ON (A.CODIGO_USUARIO = B.CODIGO_USUARIO)
GROUP BY B.CODIGO_USUARIO,B.NOMBRE||' '||B.APELLIDO,
        B.CORREO
HAVING COUNT(*)>5
ORDER BY B.CODIGO_USUARIO;


/*
6. Un usuario puede estar suscrito a tableros, listas y tarjetas, de tal forma que si hay alg�n cambio
se le notifica en su tel�fono o por tel�fono, sabiendo esto, se necesita mostrar los nombres de
todos los usuarios con la cantidad de suscripciones de cada tipo, en la consulta se debe mostrar:
� Nombre completo del usuario
� Cantidad de tableros a los cuales est� suscrito
� Cantidad de listas a las cuales est� suscrito
� Cantidad de tarjetas a las cuales est� suscrito



*/

SELECT *
FROM TBL_SUSCRIPCIONES;

SELECT  B.codigo_usuario, 
        B.NOMBRE ||' '||B.APELLIDO AS NOMBRE,
        count(codigo_lista) as cantidad_listas, 
        count(codigo_tablero) as cantidad_tableros, 
        count(codigo_tarjeta) as cantidad_tarjetas
FROM TBL_SUSCRIPCIONES A
INNER JOIN TBL_USUARIOS B
ON (A.CODIGO_USUARIO = B.CODIGO_USUARIO)
group by B.codigo_usuario,
        B.NOMBRE ||' '||B.APELLIDO;
        
/*
Consultar todas las organizaciones con los siguientes datos:
� Nombre de la organizaci�n
� Cantidad de usuarios registrados en cada organizaci�n
� Cantidad de Tableros por cada organizaci�n
� Cantidad de Listas asociadas a cada organizaci�n
� Cantidad de Tarjetas asociadas a cada organizaci�n 
*/
--ong: 4	uSUARIOS: 2
--Cantidad de usuarios por organizacion
SELECT  CODIGO_ORGANIZACION, 
        COUNT(*) CANTIDAD_USUARIOS
FROM TBL_USUARIOS_X_ORGANIZACION
 GROUP BY CODIGO_ORGANIZACION
 ORDER BY CODIGO_ORGANIZACION;
 
--ong:4 tABLEROS:2
--Cantidad de tableros por organizacion
SELECT CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_TABLEROS
FROM TBL_TABLERO
GROUP BY CODIGO_ORGANIZACION
ORDER BY CODIGO_ORGANIZACION;

--Cantidad de listas por organizacion
SELECT B.CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_LISTAS
FROM TBL_LISTAS A
INNER JOIN TBL_TABLERO B
ON A.CODIGO_tABLERO = B.CODIGO_TABLERO
GROUP BY B.CODIGO_ORGANIZACION;


--Cantidad de TARJETAS por organizacion
SELECT C.CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_TARJETAS
FROM TBL_TARJETAS A
INNER JOIN TBL_LISTAS B
ON (A.CODIGO_LISTA = B.CODIGO_LISTA)
INNER JOIN TBL_TABLERO C
ON (B.CODIGO_tABLERO = C.CODIGO_TABLERO)
GROUP BY C.CODIGO_ORGANIZACION
ORDER BY C.CODIGO_ORGANIZACION;

--Consulta final.
SELECT A.CODIGO_ORGANIZACION, NOMBRE_ORGANIZACION,
        NVL(B.CANTIDAD_USUARIOS, 0) CANTIDAD_USUARIOS,
        NVL(C.CANTIDAD_TABLEROS,0) CANTIDAD_TABLEROS,
        NVL(D.CANTIDAD_LISTAS, 0) CANTIDAD_LISTAS,
        NVL(E.CANTIDAD_TARJETAS,0) CANTIDAD_TARJETAS
FROM TBL_ORGANIZACIONES A
LEFT JOIN (
    SELECT  CODIGO_ORGANIZACION, 
            COUNT(*) CANTIDAD_USUARIOS
    FROM TBL_USUARIOS_X_ORGANIZACION
    GROUP BY CODIGO_ORGANIZACION
) B
ON (A.CODIGO_ORGANIZACION = B.CODIGO_ORGANIZACION)
LEFT JOIN (
    SELECT CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_TABLEROS
    FROM TBL_TABLERO
    GROUP BY CODIGO_ORGANIZACION
) C
ON (A.CODIGO_ORGANIZACION = C.CODIGO_ORGANIZACION)
LEFT JOIN (
    SELECT B.CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_LISTAS
    FROM TBL_LISTAS A
    INNER JOIN TBL_TABLERO B
    ON A.CODIGO_tABLERO = B.CODIGO_TABLERO
    GROUP BY B.CODIGO_ORGANIZACION
) D
ON (A.CODIGO_ORGANIZACION = D.CODIGO_ORGANIZACION)
LEFT JOIN (
    SELECT C.CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_TARJETAS
    FROM TBL_TARJETAS A
    INNER JOIN TBL_LISTAS B
    ON (A.CODIGO_LISTA = B.CODIGO_LISTA)
    INNER JOIN TBL_TABLERO C
    ON (B.CODIGO_tABLERO = C.CODIGO_TABLERO)
    GROUP BY C.CODIGO_ORGANIZACION
) E
ON (A.CODIGO_ORGANIZACION = E.CODIGO_ORGANIZACION);


---------------------------------------------------------------------------
---Misma consulta anterior utilizando WITH
--------------------------------------------------------------------------
WITH USUARIOS_X_ORGANIZACION AS (
    SELECT  CODIGO_ORGANIZACION, 
            COUNT(*) CANTIDAD_USUARIOS
    FROM TBL_USUARIOS_X_ORGANIZACION
    GROUP BY CODIGO_ORGANIZACION
),
TABLEROS_X_ORGANIZACION AS (
    SELECT CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_TABLEROS
    FROM TBL_TABLERO
    GROUP BY CODIGO_ORGANIZACION
),
LISTAS_X_ORGANIZACION AS (
    SELECT B.CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_LISTAS
    FROM TBL_LISTAS A
    INNER JOIN TBL_TABLERO B
    ON A.CODIGO_tABLERO = B.CODIGO_TABLERO
    GROUP BY B.CODIGO_ORGANIZACION
),
TARJETAS_X_ORGANIZACION AS (
    SELECT C.CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_TARJETAS
    FROM TBL_TARJETAS A
    INNER JOIN TBL_LISTAS B
    ON (A.CODIGO_LISTA = B.CODIGO_LISTA)
    INNER JOIN TBL_TABLERO C
    ON (B.CODIGO_tABLERO = C.CODIGO_TABLERO)
    GROUP BY C.CODIGO_ORGANIZACION
)
SELECT A.CODIGO_ORGANIZACION, NOMBRE_ORGANIZACION,
        NVL(B.CANTIDAD_USUARIOS, 0) CANTIDAD_USUARIOS,
        NVL(C.CANTIDAD_TABLEROS,0) CANTIDAD_TABLEROS,
        NVL(D.CANTIDAD_LISTAS, 0) CANTIDAD_LISTAS,
        NVL(E.CANTIDAD_TARJETAS,0) CANTIDAD_TARJETAS
FROM TBL_ORGANIZACIONES A
LEFT JOIN USUARIOS_X_ORGANIZACION B
ON (A.CODIGO_ORGANIZACION = B.CODIGO_ORGANIZACION)
LEFT JOIN TABLEROS_X_ORGANIZACION C
ON (A.CODIGO_ORGANIZACION = C.CODIGO_ORGANIZACION)
LEFT JOIN LISTAS_X_ORGANIZACION D
ON (A.CODIGO_ORGANIZACION = D.CODIGO_ORGANIZACION)
LEFT JOIN TARJETAS_X_ORGANIZACION E
ON (A.CODIGO_ORGANIZACION = E.CODIGO_ORGANIZACION);


--------------------------------------------------------------------------------
---
-------------------------------------------------------------------------------
WITH USUARIOS_X_ORGANIZACION AS (
    SELECT  CODIGO_ORGANIZACION,
            COUNT(*) CANTIDAD_USUARIOS
    FROM TBL_USUARIOS_X_ORGANIZACION
    GROUP BY CODIGO_ORGANIZACION
),
TABLEROS_X_ORGANIZACION AS (
    SELECT CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_TABLEROS
    FROM TBL_TABLERO
    GROUP BY CODIGO_ORGANIZACION
),
LISTAS_X_ORGANIZACION AS (
    SELECT B.CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_LISTAS
    FROM TBL_LISTAS A
    INNER JOIN TBL_TABLERO B
    ON A.CODIGO_tABLERO = B.CODIGO_TABLERO
    GROUP BY B.CODIGO_ORGANIZACION
),
TARJETAS_X_ORGANIZACION AS (
    SELECT C.CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_TARJETAS
    FROM TBL_TARJETAS A
    INNER JOIN TBL_LISTAS B
    ON (A.CODIGO_LISTA = B.CODIGO_LISTA)
    INNER JOIN TBL_TABLERO C
    ON (B.CODIGO_tABLERO = C.CODIGO_TABLERO)
    GROUP BY C.CODIGO_ORGANIZACION
)
SELECT A.CODIGO_ORGANIZACION, NOMBRE_ORGANIZACION,
        NVL(B.CANTIDAD_USUARIOS, 0) CANTIDAD_USUARIOS,
        NVL(C.CANTIDAD_TABLEROS,0) CANTIDAD_TABLEROS,
        NVL(D.CANTIDAD_LISTAS, 0) CANTIDAD_LISTAS,
        NVL(E.CANTIDAD_TARJETAS,0) CANTIDAD_TARJETAS
FROM TBL_ORGANIZACIONES A
LEFT JOIN USUARIOS_X_ORGANIZACION B
ON (A.CODIGO_ORGANIZACION = B.CODIGO_ORGANIZACION)
LEFT JOIN TABLEROS_X_ORGANIZACION C
ON (A.CODIGO_ORGANIZACION = C.CODIGO_ORGANIZACION)
LEFT JOIN LISTAS_X_ORGANIZACION D
ON (A.CODIGO_ORGANIZACION = D.CODIGO_ORGANIZACION)
LEFT JOIN TARJETAS_X_ORGANIZACION E
ON (A.CODIGO_ORGANIZACION = E.CODIGO_ORGANIZACION);

----------------------------------------------------------
-------------mISMA CONSULTA CON WITH Y PRODUCTOS CARTESIANOS Y (+)---------------------------------------------
----------------------------------------------------------


WITH USUARIOS_X_ORGANIZACION AS (
    SELECT  CODIGO_ORGANIZACION,
            COUNT(*) CANTIDAD_USUARIOS
    FROM TBL_USUARIOS_X_ORGANIZACION
    GROUP BY CODIGO_ORGANIZACION
),
TABLEROS_X_ORGANIZACION AS (
    SELECT CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_TABLEROS
    FROM TBL_TABLERO
    GROUP BY CODIGO_ORGANIZACION
),
LISTAS_X_ORGANIZACION AS (
    SELECT B.CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_LISTAS
    FROM TBL_LISTAS A
    INNER JOIN TBL_TABLERO B
    ON A.CODIGO_tABLERO = B.CODIGO_TABLERO
    GROUP BY B.CODIGO_ORGANIZACION
),
TARJETAS_X_ORGANIZACION AS (
    SELECT C.CODIGO_ORGANIZACION, COUNT(*) CANTIDAD_TARJETAS
    FROM TBL_TARJETAS A
    INNER JOIN TBL_LISTAS B
    ON (A.CODIGO_LISTA = B.CODIGO_LISTA)
    INNER JOIN TBL_TABLERO C
    ON (B.CODIGO_tABLERO = C.CODIGO_TABLERO)
    GROUP BY C.CODIGO_ORGANIZACION
)
SELECT A.CODIGO_ORGANIZACION, NOMBRE_ORGANIZACION,
        NVL(B.CANTIDAD_USUARIOS, 0) CANTIDAD_USUARIOS,
        NVL(C.CANTIDAD_TABLEROS,0) CANTIDAD_TABLEROS,
        NVL(D.CANTIDAD_LISTAS, 0) CANTIDAD_LISTAS,
        NVL(E.CANTIDAD_TARJETAS,0) CANTIDAD_TARJETAS
FROM  TBL_ORGANIZACIONES A,
      USUARIOS_X_ORGANIZACION B,
      TABLEROS_X_ORGANIZACION C,
      LISTAS_X_ORGANIZACION D,
      TARJETAS_X_ORGANIZACION E
WHERE A.CODIGO_ORGANIZACION = B.CODIGO_ORGANIZACION(+)
AND A.CODIGO_ORGANIZACION = C.CODIGO_ORGANIZACION(+)
AND A.CODIGO_ORGANIZACION = D.CODIGO_ORGANIZACION(+)
AND A.CODIGO_ORGANIZACION = E.CODIGO_ORGANIZACION(+);

/*
8. Crear una vista materializada con la informaci�n de facturaci�n, los campos a incluir son los
siguientes:
� C�digo factura
� Nombre del plan a facturar
� Nombre completo del usuario
� Fecha de pago (Utilizar fecha inicio, mostrarla en formato D�a-Mes-A�o)
� A�o y Mes de pago (basado en la fecha inicio)
� Monto de la factura
� Descuento
� Total neto

*/
CREATE VIEW VW_FACTURAS AS
SELECT A.CODIGO_FACTURA, B.NOMBRE_PLAN,
        C.NOMBRE || ' '||C.APELLIDO AS NOMBRE,
        TO_CHAR(A.FECHA_INICIO, 'DD-mm-YYYY') FECHA_PAGO,
        TO_CHAR(A.FECHA_INICIO,'MM-YYYY') MES_ANIO_PAGO,
        MONTO,
        DESCUENTO,
        MONTO-NVL(DESCUENTO,0) AS TOTAL_NETO
FROM TBL_FACTURACION_PAGOS A
INNER JOIN TBL_PLANES B
ON (A.CODIGO_PLAN = B.CODIGO_PLAN)
INNER JOIN TBL_USUARIOS C
ON (A.CODIGO_USUARIO = C.CODIGO_USUARIO);
--WHERE TO_CHAR(A.FECHA_INICIO,'MM-YYYY') = '08-2015';

CREATE materialized VIEW MVW_FACTURAS AS
SELECT A.CODIGO_FACTURA, B.NOMBRE_PLAN,
        C.NOMBRE || ' '||C.APELLIDO AS NOMBRE,
        TO_CHAR(A.FECHA_INICIO, 'DD-mm-YYYY') FECHA_PAGO,
        TO_CHAR(A.FECHA_INICIO,'MM-YYYY') MES_ANIO_PAGO,
        MONTO,
        DESCUENTO,
        MONTO-NVL(DESCUENTO,0) AS TOTAL_NETO
FROM TBL_FACTURACION_PAGOS A
INNER JOIN TBL_PLANES B
ON (A.CODIGO_PLAN = B.CODIGO_PLAN)
INNER JOIN TBL_USUARIOS C
ON (A.CODIGO_USUARIO = C.CODIGO_USUARIO);

SELECT *
FROM VW_FACTURAS;


BEGIN
    DBMS_MVIEW.REFRESH ('MVW_FACTURAS');
END;