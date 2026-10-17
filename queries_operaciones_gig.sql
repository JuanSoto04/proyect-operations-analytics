# Evaluación de Riesgo
# Selecciona conductores candidatos a crédito con buen perfil técnico y operativo
SELECT 
	id_conductor,
    plataforma,
    rating_app,
    ingreso_semanal_prom,
    viajes_semanales
FROM gig_operaciones
WHERE ingreso_semanal_prom > 250000 AND viajes_semanales > 60 AND rating_app > 4.7
ORDER BY rating_app DESC;

# Control de Cobranzas
# Identifica cuentas con pagos pendientes y muestra su nivel de atraso
SELECT 
	id_conductor,
    plataforma,
    dias_mora,
    monto_cuota_semanal,
    # Calculo de cuantas semanas debe segun los dias de mora
    CEIL(dias_mora / 7) AS 'Semanas Adeudadas',
    # Multiplica las semanas adeudadas por el valor de cuota semanal
    (CEIL(dias_mora / 7) * monto_cuota_semanal) AS 'Total Adeudado'
FROM gig_operaciones
WHERE dias_mora > 0;

# Métricas Performance
# Evalúa el rendimiento comercial e ingresos promedio por cada app
SELECT 
	plataforma,
    ROUND(AVG(ingreso_semanal_prom),2) AS 'Ingresos Promedio',
    ROUND(AVG(CASE WHEN estado_credito = 'Aprobado' THEN 1 ELSE 0 END) * 100,2) as 'Tasa de Aprobacion',
    ROUND(AVG(viajes_semanales),2) AS 'Viajes Promedio'
FROM gig_operaciones
GROUP BY plataforma;

# Clasificacion Riesgo Operativo
# Categoriza la cartera según el nivel de mora registrado
SELECT 
	id_conductor,
    plataforma,
    dias_mora,
    CASE 
		WHEN dias_mora = 0 THEN 'Riesgo Bajo' 
        WHEN dias_mora <= 15 THEN 'Riesgo Medio' 
        ELSE 'Riesgo Alto' END as 'Riesgo'
    FROM gig_operaciones
    ORDER BY dias_mora DESC;

