-- M4: CONSULTAS SQL DE NEGOCIO
-- Base de datos: Ventas_Tech_DB
-- Tabla utilizada: ventas

USE ventas_tech_db
GO

--Consulta 1: RESUMEN EJECUTIVO MENSUAL
--Total facturado, cantidad de pedidos, ticket promedio por mes

SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- CONSULTA 2: RANKING DE PRODUCTOS
-- Top 5 productos por total facturado
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- CONSULTA 3: CLIENTES RECURRENTES
-- Clientes con más de un pedido
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC;

-- CONSULTA 4: PRODUCTOS POR ENCIMA / DEBAJO DEL PROMEDIO
-- Comparación del total facturado por producto
WITH FacturacionPorProducto AS (
    SELECT
        id_producto,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY id_producto
)

SELECT
    id_producto,
    total_facturado,
    CASE
        WHEN total_facturado > (
            SELECT AVG(total_facturado)
            FROM FacturacionPorProducto
        )
        THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM FacturacionPorProducto
ORDER BY total_facturado DESC;

-- HALLAZGOS DEL ANÁLISIS
-- =====================================================

-- 1. En marzo de 2024 se facturaron $6.444 en 10 pedidos,
-- con un ticket promedio de $644,40 por pedido.

-- 2. El producto 1 fue el de mayor facturación, generando
-- $3.600 con 3 unidades vendidas. Representa aproximadamente
-- el 55,9% de la facturación total.

-- 3. Los productos 1 y 3 facturaron por encima del promedio
-- por producto. El producto 1 generó $3.600 y el producto 3
-- $1.350, mientras que los demás productos quedaron por debajo.