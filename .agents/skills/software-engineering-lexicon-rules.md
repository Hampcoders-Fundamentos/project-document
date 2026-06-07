---
name: software-engineering-lexicon-rules
description: |
  Normaliza el estilo de redacción académica en documentos del proyecto, eliminando
  el spanglish coloquial y aplicando reglas explícitas sobre el uso de extranjerismos
  técnicos, formato y tono. Diseñada para uso en repositorios y flujos de revisión
  de contenido (scope: workspace).
scope: repository
version: 1.0.0
maintainer: equipo de redacción técnica
---

## Objetivo

Proveer un conjunto de reglas y pasos aplicables por agentes automatizados o revisores
humanos para transformar textos en español hacia un registro académico y coherente,
conservando términos técnicos en su forma original en inglés según la política definida.

## Resultado esperado

Un texto en español con tono académico y tercera persona, sin expresiones informales
colocales ni calques innecesarios; los términos técnicos nativos en software quedan en
inglés y siempre resaltados como *cursiva* o `código embebido` cuando aparecen
dentro del cuerpo de la oración. Los títulos de capítulos o secciones existentes
no se traducen ni modifican.

## Entrada

- Texto en español (puede contener spanglish, anglicismos y coloquialismos).
- Contexto: reporte o capítulo dentro del repositorio.

## Reglas Principales

1. **Preservación de Extranjerismos Técnicos**: Mantener en inglés los siguientes
   términos cuando corresponda por su uso en la industria: *Sprint Backlog*,
   *Product Backlog*, *User Stories*, *Bounded Context*, *Deployment*, *Pipeline*,
   *Framework*, *Backend*, *Frontend*, *Lean UX*. Esta lista es representativa: otros
   términos del dominio pueden añadirse siguiendo las mismas reglas.

2. **Formateo Estricto de Extranjerismos**: Todo extranjerismo técnico permitido en
   inglés que aparezca en el cuerpo de la oración debe presentarse en *cursivas* o
   como `código embebido` para denotar su naturaleza técnica. Ejemplos válidos dentro
   de una oración: "Se priorizó el *Sprint Backlog* durante la iteración" o
   "Se configuró el `Pipeline` de integración continua".

3. **Inmutabilidad de Títulos**: Está prohibido modificar, traducir o reordenar los
   títulos de capítulos o secciones existentes en el reporte. Cualquier corrección
   se realiza únicamente en el cuerpo del texto; la jerarquía y nomenclatura del índice
   original se mantienen inalteradas.

4. **Tono Académico**: Reemplazar expresiones informales por prosa técnica,
   directa y en tercera persona. Evitar el uso de primera persona, imperativos
   conversacionales y modismos. Ejemplo: sustituir "vamos a probar" por
   "se evaluó".

5. **Consistencia Terminológica**: Cuando exista una elección entre dos traducciones
   o formas, preferir la que mejor se ajuste al léxico académico en español; si el
   término técnico se preserva en inglés, usar siempre la misma forma y formato
   en todo el documento.

6. **No introducir neologismos innecesarios**: Evitar traducciones literales que
   generen ambigüedad; preferir reescritura por esclarecimiento en español.

## Proceso (pasos aplicables por un agente o revisor)

1. Preprocesamiento: detectar y extraer metadatos del documento (títulos, listas,
   figuras, referencias). Marcar títulos como inmutables.
2. Tokenización y análisis léxico: identificar palabras en español, palabras en
   inglés y posibles spanglish (mezcla dentro de la misma expresión).
3. Aplicar reglas de preservación: para cada token en la lista de extranjerismos
   técnicos permitidos, garantizar que el término quede en inglés y formateado como
   *cursiva* o `código embebido` según la preferencia del repositorio.
4. Reescritura de tono: detectar construcciones informales (p. ej., "vamos a",
   "checa", "probamos") y convertirlas a tercera persona y prosa académica
   (p. ej., "se verificó", "se evaluó").
5. Verificación de títulos: comprobar que no se hayan alterado los encabezados.
6. Control de calidad: ejecutar comprobaciones de consistencia terminológica,
   formato de extranjerismos y legibilidad mínima.

## Puntos de decisión

- Si un extranjerismo técnico no está en la lista predefinida, el agente debe:
  - a) Consultar la lista ampliada del repositorio (si existe), o
  - b) Mantener el término en inglés y formatearlo en *cursivas* si su significado
    es evidente en el contexto técnico; alternativamente, agregar una nota para
    revisión humana.
- Si la corrección de tono pudiera alterar el significado técnico, dejar la frase
  para revisión humana y añadir un comentario explicativo.

## Criterios de calidad / Checks de aceptación

- No aparecen expresiones coloquiales ni spanglish no justificado.
- Todos los términos técnicos en inglés encontrados en el cuerpo están en *cursiva*
  o como `código embebido` de forma consistente.
- Los títulos originales permanecen sin cambios (comprobado por checksum de
  encabezados antes/después).
- El texto revisado mantiene fluidez y coherencia sintáctica en español.

## Ejemplos (antes → después)

- Antes: "En el Sprint hicimos varios cambios al sprint backlog y checamos el
  pipeline." 
- Después: "Durante la iteración, se realizaron modificaciones al *Sprint Backlog*
  y se verificó el `Pipeline`."

- Antes: "El frontend y el backend están listos; vamos a deployar en staging."
- Después: "El *Frontend* y el *Backend* se encuentran preparados; se procedió al
  `Deployment` en el entorno de staging."

## Prompts de ejemplo para usar con el skill

- "Aplica `software-engineering-lexicon-rules` al archivo `cap4.md` y devuelve
  el texto corregido." 
- "Revisa el capítulo 2 y lista las ocurrencias de extranjerismos técnicos no
  formateados según esta política."

## Notas de implementación técnica

- Sugerir una lista centralizada de términos permitidos en `.github/skills/terms.json`
  para facilitar extensión y revisión.
- Implementar checks automáticos en CI que ejecuten este skill como paso de lint
  de contenido, fallando la ejecución si las reglas críticas no se cumplen.

## Iteración y mejoras

- Mantener la lista de extranjerismos actualizada según glosario del proyecto.
- Añadir reglas de estilo más finas (p. ej., normativa de abreviaturas,
  uso de siglas) según necesidades del repositorio.

## Contacto

Equipo de redacción técnica — responsable de revisar ampliaciones y excepciones.
