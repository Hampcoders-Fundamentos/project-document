# Capítulo III: Requirements Specification

En este capítulo se detallan los requisitos del proyecto, incluyendo los To-be Scenario Mappings, User Stories, Impact Map y el Product Backlog. Estos elementos son fundamentales para guiar el desarrollo del proyecto y asegurar que se cumplan las necesidades y expectativas de los usuarios finales.

## 3.1	To-Be Scenario Mapping

A continuación se presenta el To-Be Scenario Mapping para la aplicación de práctica de idiomas, que ilustra cómo los usuarios interactuarán con el sistema para practicar idiomas en espacios locales. Como tenemos dos segmentos objetivos (practicantes de idiomas y establecimientos aliados), se han desarrollado dos escenarios distintos para cada uno de ellos, con el fin de capturar sus respectivas experiencias y necesidades.

### Escenario 1: Experiencia del estudiante de idiomas
 
![to-be-scenario-1](assets/img/cap3/to-be-scenario1.jpg)

Este escenario describe el viaje de un usuario que busca practicar un idioma. Abarca desde la búsqueda inicial con filtros personalizados y la reserva de un cupo en una mesa temática, hasta la validación de asistencia mediante código QR en el establecimiento aliado y el seguimiento de su evolución a través de retroalimentación y recompensas por lealtad. El proceso está diseñado para generar una experiencia de aprendizaje flexible, segura y motivadora que fomente el sentido de comunidad.

### Escenario 2: Experiencia del establecimiento aliado
 
![to-be-scenario-2](assets/img/cap3/to-be-scenario2.jpg)

Este escenario detalla la interacción de los negocios asociados (cafeterías) con la plataforma. Inicia con la configuración del perfil y disponibilidad del local, seguido por la gestión y validación de reservas durante los encuentros. Adicionalmente, incluye el análisis de métricas mediante un panel de control (dashboard) y culmina con la optimización de la oferta a través de promociones basadas en datos. El objetivo principal es maximizar la ocupación en horas valle, incrementar la rentabilidad y fidelizar a una nueva clientela.


## 3.2	User Stories

## Tabla de User Stories de Landing Page

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-01 | Visitante de la página | 3 | Landing Page |
| **Título** | **Visualización de la Propuesta de Valor** |  |  |
| **Descripción** | **Como** visitante de la página **Quiero** ver una sección principal atractiva que resuma la idea del producto **Para** entender rápidamente de qué se trata el servicio. **Escenario \#1: Presentación del propósito de Glottia** \- Dado que un visitante accede a la landing page, Cuando la carga inicial se completa, Entonces se muestra un título claro que comunica el propósito: "Practica idiomas cara a cara", un subtítulo que resume el valor principal, y una llamada a la acción para registrarse. |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-02 | Visitante interesado en practicar idiomas | 2 | Landing Page |
| **Título** | **Ver Beneficios para Aprendices** |  |  |
| **Descripción** | **Como** visitante interesado en practicar idiomas **Quiero** ver claramente los beneficios específicos para aprendices **Para** entender cómo Glottia me puede ayudar a mejorar. **Escenario \#1: Visualización de beneficios para aprendices** \- Dado que un visitante explora la landing page, Cuando se desplaza a la sección de "Para Aprendices", Entonces identifica claramente beneficios como "Gana fluidez en conversaciones reales", "Conoce gente nueva" y "Acceso accesible sin academias", cada uno con una descripción breve. |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-03 | Dueño de un local | 2 | Landing Page |
| **Título** | **Ver Beneficios para Locales** |  |  |
| **Descripción** | **Como** dueño de un local **Quiero** ver claramente los beneficios que la plataforma ofrece a mi negocio **Para** comprender cómo puede aumentar mis clientes y visibilidad. **Escenario \#1: Visualización de beneficios para locales** \- Dado que un dueño de un local visita la landing page, Cuando navega a la sección de "Para Locales", Entonces ve beneficios destacados como "Atrae nuevos clientes", "Aumenta el consumo en horas valle" y "Publicidad gratuita para tu negocio". |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-04 | Visitante | 3 | Landing Page |
| **Título** | **Explicación de Cómo Funciona** |  |  |
| **Descripción** | **Como** visitante **Quiero** ver una explicación sencilla y visual de cómo funciona la plataforma **Para** entender los pasos necesarios para participar. **Escenario \#1: Pasos para el aprendiz** \- Dado que un visitante está en la sección "Cómo Funciona", Cuando revisa el flujo para aprendices, Entonces ve una secuencia de 3 o 4 pasos sencillos, como "1. Regístrate y completa tu perfil", "2. Busca un encuentro" y "3. ¡Asiste y practica\!". **Escenario \#2: Pasos para el local** \- Dado que un visitante está en la sección "Cómo Funciona", Cuando revisa el flujo para locales, Entonces ve los pasos correspondientes: "1. Registra tu local", "2. Ofrece tu espacio" y "3. Recibe a los practicantes". |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-05 | Visitante indeciso | 3 | Landing Page |
| **Título** | **Visualización de Testimonios** |  |  |
| **Descripción** | **Como** visitante indeciso **Quiero** ver testimonios de aprendices y dueños de locales reales **Para** aumentar mi confianza en el servicio. **Escenario \#1: Visualización de testimonios diversos** \- Dado que el visitante explora la landing page, Cuando accede a la sección de testimonios, Entonces debe ver al menos un testimonio de un aprendiz y uno de un dueño de local, mostrando su nombre, una foto, su rol y su comentario. |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-06 | Visitante | 2 | Landing Page |
| **Título** | **Llamadas a la Acción (CTA) Diferenciadas** |  |  |
| **Descripción** | **Como** visitante **Quiero** ver botones de llamada a la acción claros y separados, uno para aprendices y otro para locales **Para** poder registrarme fácilmente según mi interés. **Escenario \#1: Registro como aprendiz** \- Dado que un visitante está interesado en practicar idiomas, Cuando hace clic en el botón "Únete como Aprendiz", Entonces es redirigido a la página de registro para usuarios aprendices. **Escenario \#2: Registro como local** \- Dado que un visitante es dueño de un local, Cuando hace clic en el botón "Registra tu Local", Entonces es redirigido a la página de registro para partners. |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-07 | Visitante que accede desde diferentes dispositivos | 5 | Landing Page |
| **Título** | **Adaptabilidad a Diferentes Dispositivos (Responsive)** |  |  |
| **Descripción** | **Como** visitante que accede desde diferentes dispositivos **Quiero** que la landing page se adapte correctamente a mi pantalla **Para** tener una experiencia óptima independientemente del dispositivo que use. **Escenario \#1: Experiencia en dispositivo móvil** \- Dado que un visitante accede a la landing page desde un smartphone, Cuando la página se carga, Entonces todos los elementos se reorganizan en una sola columna, el texto es legible y los botones son fáciles de presionar, sin necesidad de hacer zoom o scroll horizontal. |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-08 | Visitante | 3 | Landing Page |
| **Título** | **Navegación mediante Encabezado Fijo** |  |  |
| **Descripción** | **Como** visitante **Quiero** un menú de navegación claro en el encabezado que permanezca visible mientras me desplazo **Para** acceder fácilmente a las diferentes secciones de la página. **Escenario \#1: Acceso a secciones desde el encabezado** \- Dado que un visitante explora la landing page, Cuando hace clic en una opción del menú de navegación (ej. "Beneficios"), Entonces la página se desplaza suavemente hasta esa sección, y el encabezado permanece fijo en la parte superior de la pantalla. |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-09 | Visitante con dudas | 2 | Landing Page |
| **Título** | **Visualización de una Sección de Preguntas Frecuentes (FAQ)** |  |  |
| **Descripción** | **Como** visitante con dudas **Quiero** encontrar una sección de preguntas frecuentes **Para** resolver rápidamente mis inquietudes más comunes. **Escenario \#1: Resolver una duda común** \- Dado que un visitante se pregunta si tiene que pagar para asistir, Cuando accede a la sección de FAQ y hace clic en la pregunta "¿Tiene algún costo?", Entonces se despliega una respuesta clara y concisa. |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-10 | Visitante | 1 | Landing Page |
| **Título** | **Visualización del Pie de Página (Footer)** |  |  |
| **Descripción** | **Como** visitante **Quiero** ver un pie de página organizado con enlaces de interés **Para** encontrar información adicional o contactar con la empresa. **Escenario \#1: Contenido completo del pie de página** \- Dado que un visitante se desplaza hasta el final de la landing page, Cuando llega al pie de página, Entonces debe ver enlaces a "Términos y Condiciones", "Política de Privacidad", y enlaces a las redes sociales del proyecto. |  |  |
## 3.3	Impact Map

## 3.4	Product Backlog   
