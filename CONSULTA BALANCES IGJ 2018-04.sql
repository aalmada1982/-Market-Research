-- CONSULTA BALANCES IGJ EN STOCK
-- ABRIL 2018

-- Fuente de Información primaria: Ministerio de Justicia y Derechos Humanos - Subsecretaría de Asuntos Registrales - Inspección General de Justicia
-- Nombre del Dataset: Entidades constituidas en la Inspección General de Justicia
-- URL: https://datos.gob.ar/sv/dataset/justicia-entidades-constituidas-inspeccion-general-justicia

-- CONSULTA T-SQL DE BALANCES IGJ (AGOSTO 2018)
SELECT 
[numero_correlativo],
[tipo_societario],
[descripcion_tipo_societario],
[fecha_balance],
LEFT([fecha_balance],4) AS Año_Balance,
[fecha_presentacion],
LEFT([fecha_presentacion],4) AS Año_Presentacion,
[capital_informado] 
FROM [BALANCES_IGJ].[dbo].[igj-balances-2018-08]
WHERE LEFT([fecha_balance],4) > 2013

-- CONSULTA T-SQL BALANCES POR CUIT Y RAZÓN SOCIAL
SELECT 
B.[numero_correlativo] AS NUMERO_CORRELATIVO_IGJ,
B.cuit AS CUIT,
B.razon_social as RAZON_SOCIAL,
B.descripcion_tipo_societario AS TIPO_SOCIETARIO,
A.[fecha_balance],
LEFT(A.[fecha_balance],4) AS Año_Balance,
A.[fecha_presentacion],
LEFT(A.[fecha_presentacion],4) AS Año_Presentacion,
A.[capital_informado] 
INTO BALANCES_IGJ_2018_08
FROM [BALANCES_IGJ].[dbo].[igj-balances-2018-08] AS A
INNER JOIN [BALANCES_IGJ].[dbo].[igj-entidades-2018-08] AS B
ON B.[numero_correlativo] = A.[numero_correlativo]
WHERE LEFT(A.[fecha_balance],4) > 2013
AND B.dada_de_baja NOT LIKE 'S'
ORDER BY A.fecha_presentacion DESC
-- (101691 row(s) affected)


SELECT TOP 10 * FROM [BALANCES_IGJ].[dbo].[igj-entidades-2018-08]
WHERE dada_de_baja LIKE 'S'

-- CONSULTA T-SQL DE BALANCES DE EMPRESAS LÍDERES 2018

SELECT
A.CUITEMP,
A.DENOMINACION,
A.CANT_EMPLEADOS,
A.DESC_ACTIVIDAD AS ACTIVIDAD_ECONOMICA,
B.fecha_balance,
B.Año_Balance 
FROM [EMPRESAS_LIDERES_2018].[dbo].[EMPRESAS_LIDERES_2018] AS A
INNER JOIN [dbo].[BALANCES_IGJ_2018_08] AS B
ON A.CUITEMP = B.CUIT 
INNER JOIN [ICBC_FACT_APROX].[dbo].[CLAE_AFIP_F883_MULTINIVEL] AS C
ON A.COD_ACTIVIDAD = C.ClaeAfip14_6digitos
WHERE C.ClaeAfip14_6digitos IN 
(466310, 
 466320,
 466330,
 466340,
 466350,
 466360,
 466370,
 466391,
 466399,
 475210, 
 475220,
 475230,
 475240,
 475250, 
 475260, 
 475270, 
 475290 
 )
 AND B.Año_Balance IN (2015,2016,2017)
ORDER BY A.CANT_EMPLEADOS DESC