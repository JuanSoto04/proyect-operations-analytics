# 🚗 Operations & Credit Risk Analytics — Gig Economy Financing

## 📌 Contexto del Proyecto
Este proyecto simula el análisis operativo y la evaluación de riesgo crediticio para una fintech enfocada en el financiamiento de vehículos para trabajadores de la *gig-economy* (Uber, Rappi, Cabify, DiDi). 

A diferencia del crédito tradicional, el modelo de evaluación se basa en el **rendimiento operativo y comportamiento real del trabajador** (ingresos semanales, nivel de actividad, rating en app y frecuencia de viajes) para respaldar la toma de decisiones comerciales y el seguimiento de cartera en mora.

---

## 🎯 Objetivos de Análisis
1. **Evaluación de Riesgo / Underwriting:** Identificar conductores con perfil óptimo para la aprobación de créditos basados en métricas de rendimiento operativo.
2. **Control de Cobranzas y Mora Activa:** Detectar cuentas con atrasos en sus pagos semanales y calcular la deuda total acumulada según días de mora.
3. **Métricas de Performance por Plataforma:** Evaluar el volumen de viajes, ingresos promedio semanales y la tasa de aprobación de solicitudes según la plataforma utilizada.
4. **Segmentación de Cartera:** Categorizar a los conductores por nivel de riesgo operativo (`Bajo`, `Medio`, `Alto`) para priorizar la gestión de retención y cobranzas.

---

## 🛠️ Herramientas y Tecnologías
* **SQL (MySQL):** Consultas avanzadas, agregación condicional (`CASE WHEN`), funciones matemáticas (`CEIL`), agrupamientos y filtrado de cartera.
* **Power BI:** Dashboard interactivo para la visualización de KPIs operativos, tasa de morosidad y distribución por plataforma.
* **Excel / CSV:** Estructuración y preparación del conjunto de datos.

---

## 📊 Estructura de Consultas SQL (`queries_operaciones_gurpi.sql`)

### 1. Evaluación de Candidatos a Crédito (Underwriting)
Filtra conductores con ingresos semanales superiores a $250.000, más de 60 viajes y rating alto para acelerar el proceso de aprobación.

```sql
SELECT 
    id_conductor, 
    plataforma, 
    ingreso_semanal_prom, 
    viajes_semanales, 
    rating_app
FROM gig_operaciones
WHERE ingreso_semanal_prom > 250000 
  AND viajes_semanales > 60 
  AND rating_app >= 4.7
ORDER BY rating_app DESC;
```
### 2. Control de Cobranzas y Deuda Total Acumulada)
dentifica cuentas en mora y calcula la cantidad de semanas adeudadas y el saldo total pendiente mediante la función `CEIL()`

```sql
SELECT 
    id_conductor, 
    plataforma, 
    dias_mora,
    monto_cuota_semanal,
    CEIL(dias_mora / 7.0) AS semanas_adeudadas,
    (CEIL(dias_mora / 7.0) * monto_cuota_semanal) AS total_adeudado
FROM gig_operaciones
WHERE dias_mora > 0
ORDER BY dias_mora DESC;
```
### 3. Rendimiento y Tasa de Aprobación por Plataforma
Aplica agregación condicional para calcular el porcentaje de créditos aprobados y el volumen operativo por app.

```sql
SELECT 
    plataforma,
    ROUND(AVG(ingreso_semanal_prom), 2) AS ingreso_promedio,
    ROUND(AVG(CASE WHEN estado_credito = 'Aprobado' THEN 1 ELSE 0 END) * 100, 2) AS tasa_aprobacion_pct,
    ROUND(AVG(viajes_semanales), 2) AS viajes_promedio
FROM gig_operaciones
GROUP BY plataforma;
```
### 4. Clasificación de Riesgo Operativo
Clasifica la cartera según los días de mora registrados para la toma de acciones preventivas.

SQL

```sql
SELECT 
    id_conductor,
    plataforma,
    dias_mora,
    CASE 
        WHEN dias_mora = 0 THEN 'Riesgo Bajo' 
        WHEN dias_mora <= 15 THEN 'Riesgo Medio' 
        ELSE 'Riesgo Alto' 
    END AS categoria_riesgo
FROM gig_operaciones
ORDER BY dias_mora DESC;
```
## 📈 Dashboard de Power BI
* **KPIs clave:** Tasa de aprobación %, cartera total en mora ($), promedio de ingresos semanales.
* **Visualizaciones:** Distribución de clientes por nivel de riesgo, volumen operativo por plataforma y seguimiento de pagos.
* **Excel / CSV:** Estructuración y preparación del conjunto de datos.

## 👤 Autor

* Juan Pablo Soto — [LinkedIn](https://www.linkedin.com/in/juan-pablo-soto-/) | [Portfolio](https://www.datascienceportfol.io/sotojuanpablo04)
