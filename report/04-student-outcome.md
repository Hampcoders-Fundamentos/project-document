\footnotesize

# Abstract

The project Glottia, involves the design, development, and validation of a software solution aimed at addressing the lack of safe environments for oral language practice by connecting users to public settings and virtual meeting points through the application of modern software architecture principles and agile methodologies. The proposal is primarily directed at learners requiring efficient, intuitive, and personalized tools to develop their communicative skills, integrating functionalities that address real needs identified through field research techniques and user experience mapping.

Glottia arises as a response to the scarcity of platforms that combine an optimized user experience with a solid, scalable architecture aligned with critical quality attributes such as performance, security, and availability. Within this context, the project demonstrates the rigorous application of approaches such as Lean UX, Domain-Driven Design (DDD), and Attribute-Driven Design (ADD), which effectively structure both product design and architectural decision-making based on technical drivers.

The scope of this document for the Partial Assignment (Trabajo Parcial - TP) focuses on the system's transition and evolution from a modular monolith approach to a decoupled topology of independent microservices (IAM, Profiles, and Encounters), governed by a perimeter API Gateway and backed by polyglot persistence. Furthermore, it details the quality assurance strategy through the implementation of integration and acceptance test suites under the Behavior-Driven Development (BDD) approach using the Gherkin language. These executable specifications automate the validation of business rules for the Web Services associated with critical Sprint 1 user stories, such as authentication flows, access control, and user profile management.

Finally, the auditable evidence from the version control system and execution reports corresponding to the Sprint Review are presented, consolidating Glottia not only as a functional technological solution but also as a comprehensive software engineering exercise focused on developing robust, maintainable, highly tested systems aligned with the demands of today's user.

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
- AV3: Actualicé conocimientos relacionados con arquitecturas distribuidas mediante la migración de bounded contexts a microservicios independientes, participando en la validación de integraciones entre servicios y en la documentación de APIs bajo el estándar OpenAPI. & 
\multirow[t]{5}{=}{Se evidencia una evolución significativa desde el entendimiento del problema hasta la estructuración y validación formal de una arquitectura de microservicios. El equipo logró aplicar conceptos avanzados de desarrollo ágil, automatización de pruebas y gestión de la configuración en un escenario de software real y distribuido.} \\ \cline{2-2}

& \textbf{Integrante 2: Cesar Augusto Arostegui Alzamora} \newline ────────────────────── \newline 
- AV1: Durante las fases iniciales, se elaboraron los diagramas To-Be Scenario Mapping, se estructuró el User Task Matrix y se ejecutó un análisis detallado y estadístico de las entrevistas. \newline 
- AV2: Se desarrollaron artefactos clave como los diagramas de base de datos relacional y no relacional, así como la identificación de drivers arquitectónicos y escenarios de atributos de calidad. \newline
- TP1: Amplié conocimientos prácticos sobre Software Configuration Management (SCM) gestionando los requerimientos mediante la integración de Jira y la documentación técnica distribuida en repositorios. \newline
- AV3: Profundicé en tecnologías de despliegue cloud y comunicación distribuida mediante la configuración de entornos para microservicios, el uso de RabbitMQ para integración basada en eventos y la preparación de servicios para su despliegue en Render. & \\ \cline{2-2}

& \textbf{Integrante 3: Italo Ludwing Sánchez Manrique} \newline ────────────────────── \newline 
- AV1: Investigué y apliqué herramientas como User Persona, Customer Journey Map, Impact Map y análisis de competidores. \newline 
- AV2: Apliqué el método ADD para estructurar iteraciones arquitectónicas, definiendo responsabilidades e interfaces, integrando tácticas de performance, seguridad y disponibilidad. \newline
- TP1: Investigué y ejecuté la automatización de Testing Suites mediante Behavior-Driven Development (BDD) y lenguaje Gherkin, estructurando escenarios ejecutables funcionales, de patrones y de librerías para microservicios. \newline
- AV3: Fortalecí conocimientos en aseguramiento de calidad para sistemas distribuidos mediante la ejecución y validación de pruebas de integración entre microservicios, verificando contratos de servicio y flujos de comunicación asíncrona. & \\ \cline{2-2}

& \textbf{Integrante 4: Leandro Saul Contreras} \newline ────────────────────── \newline 
- AV1: Se realizaron avances en la metodología Lean UX, entrevistas, empathy map e impact map. \newline 
- AV2: Participé en la definición de design patterns, constraints, architectural concerns, así como en la definición de user stories. \newline
- TP1: Actualicé conceptos técnicos orientados a la arquitectura de microservicios, participando activamente en la extracción, modularización y planificación del sprint backlog para el despliegue autónomo. \newline
- AV3: Actualicé conocimientos sobre Domain-Driven Design y microservicios participando en la separación de bounded contexts, la definición de fronteras de contexto y la preparación de componentes para despliegues independientes. & \\ \cline{2-2}

& \textbf{Integrante 5: Ivo Machado Bracamonte} \newline ───────────────────── \newline 
- AV1: Investigué sobre Lean UX para define hipótesis, user persona e historias de usuario. \newline 
- AV2: Desarrollé las vistas de los diagrama C4 y UML, además del propósito de diseño y backlog arquitectónico. \newline
- TP1: Profundicé en patrones de integración y despliegue continuo mediante herramientas PaaS como Render y entornos Docker para asegurar la disponibilidad controlada de los microservicios core.\newline
- AV3: Profundicé en el uso de herramientas de gestión ágil mediante la planificación y seguimiento del Sprint Backlog 2 en Jira, documentando el avance de la transición arquitectónica y la trazabilidad de los entregables asociados a microservicios. & \\ \hline

% ==================== CRITERIO 2 ====================
\multirow[t]{5}{=}{Reconoce la necesidad del aprendizaje permanente para el desempeño profesional y el desarrollo de proyectos en soluciones de software.} & 
\textbf{Integrante 1: Ethan Aliaga Aguirre} \newline ─────────────────────── \newline 
- AV1: Sentí la necesidad de investigar conceptos para mejorar el desarrollo de entrevistas. \newline 
- AV2: Fue necesario profundizar en arquitectura de software, especialmente en estilos arquitectónicos y tácticas. \newline
- TP1: Reconocí la importancia de auto-aprender estándares de gobierno de código modernos y convenciones de nomenclatura multiplataforma para flujos de trabajo colaborativos en el backend. \newline
- AV3: Reconocí la necesidad de aprender estrategias de integración y documentación de servicios distribuidos para garantizar la interoperabilidad y mantenibilidad de una arquitectura basada en microservicios. & 
\multirow[t]{5}{=}{Se demuestra una comprensión sólida de que el desarrollo de soluciones de software escalables y con microservicios requiere un aprendizaje autónomo, multidisciplinario y permanente. El equipo evidencia madurez técnica al asimilar herramientas modernas de testing y despliegue para garantizar la calidad del producto.} \\ \cline{2-2}

& \textbf{Integrante 2: Cesar Augusto Arostegui Alzamora} \newline ─────────────────────── \newline 
- AV1: Se investigaron temas fuera del ámbito técnico como modelos de negocio y comportamiento del usuario. \newline 
- AV2: Se requirió aprender sobre escenarios de atributos de calidad, drivers arquitectónicos y su impacto en el diseño estratégico. \newline
- TP1: Identifiqué la necesidad de dominar el funcionamiento de herramientas de gestión del ciclo de vida de software para mitigar el caos de configuración durante la integración ágil de ramas. \newline
- Comprendí la necesidad de mantenerme actualizado en plataformas cloud, despliegue continuo e infraestructura para soportar de forma eficiente el ciclo de vida completo de aplicaciones distribuidas. & \\ \cline{2-2}

& \textbf{Integrante 3: Italo Ludwing Sánchez Manrique} \newline ─────────────────────── \newline 
- AV1: Identifiqué la necesidad de adquirir conocimientos en metodologías UX y análisis de usuarios. \newline 
- AV2: Reconocí la importancia de dominar enfoques como ADD y diseño basado en atributos de calidad. \newline
- TP1: Comprendí la necesidad imperiosa de asimilar el framework de pruebas Cucumber.js, Supertest y la sintaxis Gherkin para asegurar la calidad continua del software mediante especificaciones vivas. \newline
- AV3: Identifiqué la necesidad de especializarme en pruebas de integración y observabilidad de sistemas distribuidos para asegurar la calidad y confiabilidad de aplicaciones basadas en microservicios. & \\ \cline{2-2}

& \textbf{Integrante 4: Leandro Saul Contreras López} \newline ──────────────────────── \newline 
- AV1: Apliqué Lean UX y herramientas estratégicas como empathy map e impact map. \newline 
- AV2: Comprendí la importancia de alinear requerimientos funcionales con decisiones arquitectónicas. \newline
- TP1: Asumí el reto de investigar sobre la deconstrucción de arquitecturas monolíticas hacia sistemas autónomos, entendiendo la necesidad de aprendizaje sobre persistencia políglota y fronteras de contexto. \newline
- AV3: Reconocí la importancia de profundizar continuamente en patrones arquitectónicos modernos y estrategias de deconstrucción de dominios para diseñar soluciones escalables y mantenibles. & \\ \cline{2-2}

& \textbf{Integrante 5: Ivo Machado Bracamonte} \newline ─────────────────────── \newline 
- AV1: Aprendí a identificar necesidades de usuarios para define requerimientos. \newline 
- AV2: Fue necesario investigar sobre patrones de diseño, restricciones arquitectónicas y representación mediante C4. \newline
- TP1: Reconocí la necesidad de actualizarme en tecnologías de orquestación perimetral, gateways y automatización de infraestructura en la nube para responder ágilmente a fallas de entrega de microservicios.\newline
- AV3: Comprendí la importancia de continuar aprendiendo herramientas de gestión ágil y seguimiento de proyectos para coordinar eficientemente equipos de desarrollo involucrados en arquitecturas desacopladas. & \\ \hline
\end{longtable}

\normalsize

\newpage