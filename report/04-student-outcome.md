\footnotesize

# Abstract

El proyecto Glottia consiste en el diseño, desarrollo y validación de una solución de software orientada a abordar la falta de entornos seguros y accesibles para la práctica del lenguaje oral. La propuesta busca conectar a los usuarios con espacios públicos y puntos de encuentro virtuales, facilitando la interacción comunicativa mediante el uso de tecnologías modernas y principios sólidos de ingeniería de software. Está dirigida principalmente a estudiantes y usuarios que requieren herramientas eficientes, intuitivas y personalizadas para fortalecer sus habilidades comunicativas, integrando funcionalidades alineadas a necesidades reales identificadas a través de técnicas de investigación de campo y mapeo de experiencia de usuario.

Glottia surge como respuesta a la limitada disponibilidad de plataformas que logren combinar una experiencia de usuario optimizada con una arquitectura robusta, escalable y alineada con atributos de calidad críticos como rendimiento, seguridad, disponibilidad y mantenibilidad. En este contexto, el proyecto evidencia la aplicación rigurosa de enfoques como \textit{Lean UX}, \textit{Domain-Driven Design (DDD)} y \textit{Attribute-Driven Design (ADD)}, los cuales permiten estructurar tanto el diseño del producto como la toma de decisiones arquitectónicas basadas en drivers técnicos y de negocio.

El alcance del presente documento abarca la evolución del sistema desde una arquitectura monolítica modular hacia una arquitectura distribuida basada en microservicios independientes, específicamente en los dominios de \textit{Identity and Access Management (IAM)}, \textit{Profiles} y \textit{Encounters}. Estos servicios son orquestados mediante un \textit{API Gateway} que actúa como perímetro de acceso, y soportados por un enfoque de persistencia políglota que optimiza el manejo de datos según las necesidades de cada dominio. Asimismo, se incorpora el diseño de la arquitectura en la nube y su despliegue en plataformas cloud, garantizando escalabilidad, alta disponibilidad y tolerancia a fallos.

Adicionalmente, se detalla la estrategia de aseguramiento de calidad implementada, la cual incluye pruebas de integración y pruebas de aceptación automatizadas bajo el enfoque de \textit{Behavior-Driven Development (BDD)} utilizando el lenguaje \textit{Gherkin}. Estas especificaciones ejecutables permiten validar de manera continua las reglas de negocio asociadas a funcionalidades críticas como autenticación, control de acceso, gestión de perfiles y comunicación entre microservicios.

Finalmente, se presentan evidencias auditables provenientes del sistema de control de versiones, pipelines de integración continua y reportes de ejecución correspondientes a los distintos Sprints, consolidando a Glottia no solo como una solución tecnológica funcional, sino también como un ejercicio integral de ingeniería de software orientado al desarrollo de sistemas distribuidos robustos, mantenibles, altamente probados y alineados con las exigencias del entorno tecnológico actual.


\newpage

# Student Outcome

\nopagebreak
\begin{longtable}{|p{0.22\textwidth}|p{0.53\textwidth}|p{0.20\textwidth}|}
\hline
\rowcolor[HTML]{EFEFEF} 
\textbf{Criterio específico} & \textbf{Acciones realizadas} & \textbf{Conclusiones} \\ \hline
\endhead

% ==================== CRITERIO 1 ====================
\multirow[t]{5}{=}{Actualiza conceptos y conocimientos necesarios para su desarrollo profesional y en especial para su proyecto en soluciones de software.} & 
\textbf{Integrante 1: Ethan Aliaga Aguirre} \newline ────────────────────── \newline 
- AV1: En esta entrega pude actualizar conceptos relacionados a la metodología Lean UX para realizar la definición del Problem Statement, alcances y límites de nuestro proyecto. \newline 
- AV2: Profundicé en conceptos de arquitectura de software mediante la definición de principios arquitectónicos, estilos y patrones, así como la elaboración de diagramas de contexto y vistas basadas en viewpoints. \newline
- TP1: Actualicé conocimientos de ingeniería de software mediante el diseño e implementación del entorno de Gitflow y la estructuración de guías de estilo para la estandarización del código del proyecto. \newline
- AV3: Actualicé conocimientos relacionados con arquitecturas distribuidas mediante la migración de bounded contexts a microservicios independientes, participando en la validación de integraciones entre servicios y en la documentación de APIs bajo el estándar OpenAPI. \newline
- AV4: Actualicé conceptos de desarrollo frontend mediante la maquetación y consumo de APIs de microservicios desde la Web App, además de finalizar el desacoplamiento total del backend y centralizar las peticiones a través de la configuración del perímetro en el API Gateway.\newline
- TF: Actualicé conocimientos en arquitectura cloud mediante la elaboración del Cloud Architecture Diagram, definiendo la interacción entre servicios, API Gateway y componentes distribuidos, así como la validación del despliegue en la nube asegurando la correcta comunicación entre microservicios. & 
\multirow[t]{5}{=}{Se evidencia una evolución completa y significativa desde la concepción del problema hasta el despliegue e integración final de un ecosistema distribuido. El equipo logró consolidar el desarrollo de la Web App consumiendo una arquitectura madura de microservicios independientes, aplicando con rigor prácticas de ingeniería web, orquestación perimetral y automatización en la nube.} \\ \cline{2-2}

& \textbf{Integrante 2: Cesar Augusto Arostegui Alzamora} \newline ────────────────────── \newline 
- AV1: Durante las fases iniciales, se elaboraron los diagramas To-Be Scenario Mapping, se estructuró el User Task Matrix y se ejecutó un análisis detallado y estadístico de las entrevistas. \newline 
- AV2: Se desarrollaron artefactos clave como los diagramas de base de datos relacional y no relacional, así como la identificación de drivers arquitectónicos y escenarios de atributos de calidad. \newline
- TP1: Amplié conocimientos prácticos sobre Software Configuration Management (SCM) gestionando los requerimientos mediante la integración de Jira y la documentación técnica distribuida en repositorios. \newline
- AV3: Profundicé en tecnologías de despliegue cloud y comunicación distribuida mediante la configuración de entornos para microservicios, el uso de RabbitMQ para integración basada en eventos y la preparación de servicios para su despliegue en Render. \newline
- AV4: Consolidé conocimientos en persistencia políglota y despliegue continuo cloud al finalizar la migración y puesta en producción de las bases de datos independientes por microservicio, optimizando las colas de mensajería asíncrona para asegurar la consistencia del sistema en el entorno de producción. \newline
- TF: Consolidé conocimientos en infraestructura cloud mediante el diseño del Cloud Architecture Diagram y la implementación del despliegue en la nube, definiendo redes, subredes y configuraciones de seguridad para garantizar la disponibilidad y escalabilidad del sistema. & \\ \cline{2-2}

& \textbf{Integrante 3: Italo Ludwing Sánchez Manrique} \newline ────────────────────── \newline 
- AV1: Investigué y apliqué herramientas como User Persona, Customer Journey Map, Impact Map y análisis de competidores. \newline 
- AV2: Apliqué el método ADD para estructurar iteraciones arquitectónicas, definiendo responsabilidades e interfaces, integrando tácticas de performance, seguridad y disponibilidad. \newline
- TP1: Investigué y ejecuté la automatización de Testing Suites mediante Behavior-Driven Development (BDD) y lenguaje Gherkin, estructurando escenarios ejecutables funcionales, de patrones y de librerías para microservicios. \newline
- AV3: Fortalecí conocimientos en aseguramiento de calidad para sistemas distribuidos mediante la ejecución y validación de pruebas de integración entre microservicios, verificando contratos de servicio y flujos de comunicación asíncrona. \newline
- AV4: Actualicé conocimientos de testing en sistemas extremo a extremo (E2E) al validar la integración funcional de la interfaz de la Web App con los servicios de backend desplegados, automatizando las pruebas de aceptación finales para los flujos críticos de usuario. \newline
-TF: Fortalecí conocimientos en aseguramiento de calidad en entornos cloud al validar la arquitectura desplegada, ejecutando pruebas de integración y verificando la disponibilidad, rendimiento y comunicación entre servicios distribuidos. & \\ \cline{2-2}

& \textbf{Integrante 4: Leandro Saul Contreras López} \newline ────────────────────── \newline 
- AV1: Se realizaron avances en la metodología Lean UX, entrevistas, empathy map e impact map. \newline 
- AV2: Participé en la definición de design patterns, constraints, architectural concerns, así como en la definición de user stories. \newline
- TP1: Actualicé conceptos técnicos orientados a la arquitectura de microservicios, participando activamente en la extracción, modularización y planificación del sprint backlog para el despliegue autónomo. \newline
- AV3: Actualicé conocimientos sobre Domain-Driven Design y microservicios participando en la separación de bounded contexts, la definición de fronteras de contexto y la preparación de componentes para despliegues independientes. \newline
- AV4: Profundicé en patrones de diseño para interfaces web y en Domain-Driven Design, logrando materializar la lógica de negocio de los bounded contexts (IAM, Profiles y Encounters) en módulos web responsivos, completando la transición total del monolito original. \newline
- TF: Actualicé conocimientos en diseño de arquitecturas distribuidas mediante la elaboración del Cloud Architecture Diagram, asegurando la correcta representación de bounded contexts en la nube y su despliegue desacoplado. & \\ \cline{2-2}

& \textbf{Integrante 5: Ivo Machado Bracamonte} \newline ───────────────────── \newline 
- AV1: Investigué sobre Lean UX para definir hipótesis, user persona e historias de usuario. \newline 
- AV2: Desarrollé las vistas de los diagramas C4 y UML, además del propósito de diseño y backlog arquitectónico. \newline
- TP1: Profundicé en patrones de integración y despliegue continuo mediante herramientas PaaS como Render y entornos Docker para asegurar la disponibilidad controlada de los microservicios core.\newline
- AV3: Profundicé en el uso de herramientas de gestión ágil mediante la planificación y seguimiento del Sprint Backlog 2 en Jira, documentando el avance de la transición arquitectónica y la trazabilidad de los entregables asociados a microservicios. \newline
- AV4: Amplié conocimientos en DevOps e infraestructura como código al coordinar el despliegue integrado y automatizado de la Web App y la red de microservicios (PaaS/Docker), gestionando el monitoreo de endpoints y controlando la trazabilidad de las tareas finales en Jira. \newline
- TF: Amplié conocimientos en DevOps e infraestructura cloud al implementar el Cloud Architecture Deployment, automatizando el despliegue mediante pipelines CI/CD y gestionando la configuración de servicios en plataformas cloud.& \\ \hline

% ==================== CRITERIO 2 ====================
\multirow[t]{5}{=}{Reconoce la necesidad del aprendizaje permanente para el desempeño profesional y el desarrollo de proyectos en soluciones de software.} & 
\textbf{Integrante 1: Ethan Aliaga Aguirre} \newline ─────────────────────── \newline 
- AV1: Sentí la necesidad de investigar conceptos para mejorar el desarrollo de entrevistas. \newline 
- AV2: Fue necesario profundizar en arquitectura de software, especially en estilos arquitectónicos y tácticas. \newline
- TP1: Reconocí la importancia de auto-aprender estándares de gobierno de código modernos y convenciones de nomenclatura multiplataforma para flujos de trabajo colaborativos en el backend. \newline
- AV3: Reconocí la necesidad de aprender estrategias de integración y documentación de servicios distribuidos para garantizar la interoperabilidad y mantenibilidad de una arquitectura basada en microservicios. \newline
- AV4: Identifiqué la necesidad de aprender sobre frameworks de desarrollo web modernos para construir interfaces SPA ágiles, seguras y optimizadas para el consumo de pasarelas perimetrales (API Gateways). \newline
- TF: Reconocí la necesidad de aprender sobre arquitecturas cloud y herramientas de despliegue para garantizar la correcta implementación de soluciones distribuidas escalables. & 
\multirow[t]{5}{=}{Se demuestra que el equipo asimiló el aprendizaje continuo como un pilar indispensable para afrontar la complejidad técnica. Los integrantes asumieron de manera autónoma el estudio de tecnologías frontend, orquestación en la nube, pruebas E2E y seguridad perimetral, logrando conectar con éxito el diseño UX con una arquitectura física real.} \\ \cline{2-2}

& \textbf{Integrante 2: Cesar Augusto Arostegui Alzamora} \newline ─────────────────────── \newline 
- AV1: Se investigaron temas fuera del ámbito técnico como modelos de negocio y comportamiento del usuario. \newline 
- AV2: Se requirió aprender sobre escenarios de atributos de calidad, drivers arquitectónicos y su impacto en el diseño estratégico. \newline
- TP1: Identifiqué la necesidad de dominar el funcionamiento de herramientas de gestión del ciclo de vida de software para mitigar el caos de configuración durante la integración ágil de ramas. \newline
- AV3: Comprendí la necesidad de mantenerme actualizado en plataformas cloud, despliegue continuo e infraestructura para soportar de forma eficiente el ciclo de vida completo de aplicaciones distribuidas. \newline
- AV4: Reconocí la importancia de auto-aprender sobre optimización de bases de datos políglotas en entornos productivos cloud, mitigando problemas de latencia y sincronización asíncrona bajo alta carga simulada. \newline
- TF: Identifiqué la necesidad de profundizar en herramientas de automatización y CI/CD para optimizar el despliegue continuo en entornos cloud. & \\ \cline{2-2}

& \textbf{Integrante 3: Italo Ludwing Sánchez Manrique} \newline ─────────────────────── \newline 
- AV1: Identifiqué la necesidad de adquirir conocimientos en metodologías UX y análisis de usuarios. \newline 
- AV2: Reconocí la importancia de dominar enfoques como ADD y diseño basado en atributos de calidad. \newline
- TP1: Comprendí la necesidad imperiosa de asimilar el framework de pruebas Cucumber.js, Supertest y la sintaxis Gherkin para asegurar la calidad continua del software mediante especificaciones vivas. \newline
- AV3: Identifiqué la necesidad de especializarme en pruebas de integración y observabilidad de sistemas distribuidos para asegurar la calidad y confiabilidad de aplicaciones basadas en microservicios. \newline
- AV4: Comprendí la necesidad de dominar metodologías de pruebas End-to-End (E2E) y herramientas de automatización UI para asegurar que los flujos interactivos de la Web App no rompan los contratos establecidos del backend. \newline
- TF: Identifiqué la importancia de profundizar en servicios cloud, redes y seguridad para asegurar un despliegue robusto y confiable en entornos productivos. & \\ \cline{2-2}

& \textbf{Integrante 4: Leandro Saul Contreras López} \newline ──────────────────────── \newline 
- AV1: Apliqué Lean UX y herramientas estratégicas como empathy map e impact map. \newline 
- AV2: Comprendí la importancia de alinear requerimientos funcionales con decisiones arquitectónicas. \newline
- TP1: Asumí el reto de investigar sobre la deconstrucción de arquitecturas monolíticas hacia sistemas autónomos, entendiendo la necesidad de aprendizaje sobre persistencia políglota y fronteras de contexto. \newline
- AV3: Reconocí la importancia de profundizar continuamente en patrones arquitectónicos modernos y estrategias de deconstrucción de dominios para diseñar soluciones escalables y mantenibles. \newline
- AV4: Identifiqué la necesidad de profundizar en el diseño e implementación de sistemas de diseño (Design Systems) y patrones de consumo asíncrono desde el cliente web para acoplar la interfaz de forma limpia a las fronteras del dominio. \newline
- TF: Comprendí la necesidad de especializarme en pruebas y monitoreo de sistemas cloud para garantizar la calidad y disponibilidad de aplicaciones distribuidas. & \\ \cline{2-2}

& \textbf{Integrante 5: Ivo Machado Bracamonte} \newline ─────────────────────── \newline 
- AV1: Aprendí a identificar necesidades de usuarios para definir requerimientos. \newline 
- AV2: Fue necesario investigar sobre patrones de diseño, restricciones arquitectónicas y representation mediante C4. \newline
- TP1: Reconocí la necesidad de actualizarme en tecnologías de orquestación perimetral, gateways y automatización de infraestructura en la nube para responder ágilmente a fallas de entrega de microservicios.\newline
- AV3: Comprendí la importancia de continuar aprendiendo herramientas de gestión ágil y seguimiento de proyectos para coordinar eficientemente equipos de desarrollo involucrados en arquitecturas desacopladas. \newline
- AV4: Reconocí la necesidad urgente de actualizarme en flujos avanzados de CI/CD para multi-repositorios, asimilando conceptos de variables de entorno seguras y balanceo de carga en plataformas cloud para entornos de producción. \newline
- TF: Reconocí la necesidad de seguir aprendiendo sobre diseño de arquitecturas cloud y patrones de despliegue para construir sistemas escalables y mantenibles. & \\ \hline
\end{longtable}

\normalsize

\newpage
