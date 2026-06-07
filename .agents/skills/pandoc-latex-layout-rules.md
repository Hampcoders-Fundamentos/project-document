---
name: pandoc-latex-layout-rules
description: |
  Establece reglas obligatorias para estandarizar Markdown destinado a compilación
  por Tectonic (Pandoc → LaTeX → PDF). Valida y transforma referencias de imágenes
  y tablas concretas, emite observaciones para tablas complejas y fuerza esquemas
  analíticos para tablas cualitativas de entrevistas.
scope: repository
version: 1.0.0
maintainer: equipo de documentación técnica
---

## Objetivo

Garantizar que los archivos Markdown del repositorio cumplan una estructura
compatible y reproducible para compilación a PDF mediante Tectonic, evitando fallos
por sintaxis inválida de imágenes o tablas y aplicando transformaciones controladas
cuando corresponda.

## Resultado esperado

- Todas las imágenes referenciadas con sintaxis Pandoc `![Descripción](ruta){width=X%}`
  y con pies de figura generados automáticamente a partir de la ruta de la imagen.
- Las tablas de control de cambios convertidas a un bloque LaTeX estandarizado
  que usa macros definidas en `config/header.tex` y tipografía en `\footnotesize`.
- Otras tablas complejas no se modifican automáticamente; se emite una nota técnica
  indicando la necesidad de optimización manual.
- Las tablas cualitativas de entrevistas se normalizan a un esquema analítico fijo.

## Entrada

- Archivo Markdown perteneciente al repositorio.

## Reglas obligatorias

1. Control de Imágenes por Ruta
   - Validar que toda referencia de imagen use la sintaxis Pandoc: `![Descripción](ruta){width=X%}`.
   - Prohibir el uso de etiquetas HTML `<img ...>`; cualquier encuentro debe reportarse
     como error y sugerir la conversión a la sintaxis Pandoc.
   - Leer la ruta de la imagen (por ejemplo `assets/img/cap1/diagramas/flow.png`) para
     deducir el contexto del diagrama: capítulo, sección y tipo (ej.: `cap1` → Capítulo 1,
     `diagramas` → Diagrama técnico). Generar un pie de figura formal y técnico que incluya:
     - Breve descripción funcional (1 oración).
     - Contexto técnico (capítulo/sección y propósito del diagrama).
     Ejemplo de pie generado: "Figura: Diagrama de flujo del módulo de autorización (Capítulo 1)."
   - Si la imagen no existe en la ruta indicada, marcar como error crítico para revisión.

2. Estandarización Obligatoria de Tablas de Control de Cambios
   - Detectar tablas cuya primera fila (encabezado) sea exactamente:
     `| Versión | Fecha | Autor(es) | Descripción de modificación |` (ignorar espacios visibles).
   - Transformar esta tabla automáticamente a un bloque LaTeX que:
     - Use las macros definidas en `config/header.tex` (por ejemplo `\begin{changetable} ... \end{changetable}`).
     - Aplique alineación por tuberías limpia y forzada (p. ej., `|l|c|l|p{6cm}|`).
     - Envolva el contenido en `\footnotesize` para la tipografía solicitada.
     - Eliminar saltos de línea inestables en celdas (consolidar en una sola línea por celda).
   - Registrar en el archivo una nota HTML comentada (`<!-- -->`) indicando que la
     transformación fue aplicada por el skill y la ubicación original.

3. Excepciones y Notas para Tablas Generales
   - Para cualquier otra tabla compleja que no siga esquemas analíticos predefinidos,
     el sistema NO debe alterar su contenido ni estructura automáticamente.
   - En su lugar, emitir una observación técnica (comentario HTML) junto a la tabla
     describiendo por qué no se transformó y recomendando optimizaciones concretas
     para revisión manual (p. ej., colapsar celdas, especificar anchos, convertir
     a tabla LaTeX usando `p{}` para columnas largas).

4. Esquema Analítico de Datos (Tablas Cualitativas de Entrevistas)
   - Detectar tablas que representen resultados cualitativos y forzar el siguiente
     orden de columnas (y formato):

     | ID | Tipo (Abierta/Cerrada) | Enunciado | Justificacion Tecnica |
     |:---|:---|:---|:---|

   - Si la tabla no presenta ese orden, reordenar columnas y mantener el contenido
     asociado a cada campo; si la reordenación produce ambigüedad, marcar para
     revisión humana en lugar de hacer cambios destructivos.

## Proceso sugerido (implementación del agente)

1. Parsear el Markdown conservando la estructura de bloques (encabezados, párrafos,
   listas, bloques de código, tablas, imágenes).
2. Para cada imagen: validar sintaxis Pandoc, comprobar existencia del archivo,
   extraer metadatos desde la ruta y generar pie de figura técnico; reemplazar o
   insertar pie si falta.
3. Para cada tabla: identificar si coincide exactamente con la cabecera de control
   de cambios; si coincide, transformar a bloque LaTeX estandarizado usando macros;
   si no coincide y es compleja, añadir comentario técnico y no modificar.
4. Para tablas cualitativas: detectar intención (por heurística de encabezados) y
   aplicar reordenación al esquema analítico; en caso de conflicto, anotar para
   revisión humana.
5. Ejecutar validaciones finales: asegurar que no quedan etiquetas `<img>`, que todas
   las referencias de imágenes apuntan a archivos existentes y que las transformaciones
   añaden comentarios de trazabilidad.

## Puntos de decisión

- Si una imagen usa sintaxis Pandoc pero carece de `width=X%`, añadir `{width=80%}`
  por defecto y anotar la intervención.
- Si la tabla de control de cambios contiene celdas multilinea con formato complejo,
  normalizar conservando el contenido y unificando en una sola línea por celda.
- Si la reordenación de una tabla cualitativa destruye la asociación entre celdas,
  abortar la reordenación y marcarla para revisión humana.

## Criterios de calidad / Checks de aceptación

- Todas las imágenes usan `![Descripción](ruta){width=X%}` y sus archivos existen.
- No aparecen etiquetas `<img>` en el Markdown final.
- Las tablas de control de cambios han sido convertidas a LaTeX con `\footnotesize`.
- Otras tablas complejas conservan su estructura original y llevan un comentario
  técnico que explica la necesidad de optimización manual.
- Las tablas cualitativas cumplen el esquema analítico indicado o están marcadas
  para revisión si la operación no fue segura.

## Ejemplos (antes → después)

- Imagen antes: `<img src="assets/img/cap1/flow.png">`
- Imagen después: `![Diagrama de flujo](assets/img/cap1/flow.png){width=75%}`
  <!-- Pie generado: Diagrama de flujo del módulo de autorización (Capítulo 1). -->

- Tabla de control de cambios antes: Markdown simple con encabezado `| Versión | Fecha | Autor(es) | Descripción de modificación |`
- Tabla después: Bloque LaTeX usando macro `\begin{changetable}` con `\footnotesize`.

## Prompts de ejemplo para usar con el skill

- "Aplica `pandoc-latex-layout-rules` al archivo `report/40-cap4-product-architecture-design.md`."
- "Lista imágenes sin sintaxis Pandoc válida en `report/` y sugiere pies generados."

## Notas de implementación técnica

- Recomendar implementar como paso de CI (pre-commit o job de lint) que falle
  la compilación si se detectan errores críticos (imágenes inexistentes, etiquetas
  `<img>`, tablas de control de cambios mal formadas).
- Mantener una pequeña plantilla de macro LaTeX en `config/header.tex` con el
  entorno `changetable` que el skill pueda invocar.

## Iteración y mejoras

- Añadir heurísticas más sofisticadas para detección automática de tablas complejas.
- Permitir una lista blanca de excepciones para imágenes cuyo pie de figura deba
  ser manual.

## Contacto

Equipo de documentación técnica — responsable de revisar transformaciones automáticas.
