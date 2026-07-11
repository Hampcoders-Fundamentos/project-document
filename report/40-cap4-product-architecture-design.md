# Capítulo IV: Product Architecture Design

En este capítulo el equipo presentará el diseño de la arquitectura de la solución Glottia, detallando los conceptos y puntos de vista en diferentes entornos que definirán la construcción del sistema. El objetivo de este capítulo será ilustrar las decisiones arquitectónicas con respecto al alcance de la solución y los requerimientos funcionales y no funcionales para garantizar una solución robusta y escalable. 

## 4.1 Design Concepts, ViewPoints & ER Diagrams

En la presente sección se desarrollaran puntos de vista, principios de diseño y diagramas que permitirán presentar la arquitectura de nuestra solución.

### 4.1.1 Principles Statements

Partiendo de nuestra visión de negocio y arquitectura, el equipo de Hampcoders definirán los principios que permitirán garantizar sostenibilidad a largo plazo para la solución Glottia.

| Principio | Descripción |
| --------- | ----------- |
| Arquitectura de Monolito Modular como etapa inicial | El sistema se estructuró inicialmente mediante Bounded Contexts (BC) estrictos dentro de un monolito modular. Esta arquitectura permitió validar los límites de cada contexto con bajo costo operativo. La evolución hacia microservicios se realizó aplicando la estrategia Strangler Fig, extrayendo cada BC como servicio independiente en sprints sucesivos (Sprint 1: IAM, Profiles, Encounters; Sprint 2: Venues, Promotions, Learning Feedback, Engagement; Sprint 3: Notifications, Verification). Al cierre del proyecto, la arquitectura actual es 100% microservicios distribuidos. |
| Coordinación Asíncrona basada en Eventos               | Con el fin de evitar el acoplamiento directo y mejorar el rendimiento de la experiencia de usuario, la comunicación de flujos no críticos entre servicios se realizará mediante publicación y suscripción de eventos a través de RabbitMQ.                             |
| Consistencia Eventual sobre Consistencia Inmediata     | No se forzarán transacciones distribuidas entre diferentes Bounded Contexts. Cada microservicio garantizará su consistencia interna inmediata, pero la sincronización de datos entre distintos BCs operará bajo el principio de consistencia eventual. |
| Aislamiento de Datos e Interfaces Explícitas           | Toda comunicación e intercambio de información entre servicios se realizará mediante interfaces explícitas y transferencia de objetos de datos bien definidos y versionados.                                                                      |
| Encapsulamiento Estricto de Integraciones Externas     | Todo servicio o dependencia externa deberá estar aislado detrás de su propio adaptador evitando que la lógica de negocio dependa directamente de bibliotecas de terceros.                                                                       |
| Seguridad en Profundidad por Defecto                   | La solución aplicará una autenticación centralizada stateless mediante tokens JWT auto-emitidos (JJWT) para la gestión de acceso, con cifrado de datos sensibles (contraseñas y códigos OTP mediante BCrypt) en cumplimiento con la Ley N.° 29733 de Protección de Datos Personales. |

### 4.1.2 Approaches Statements Architectural Styles & Patterns

Estos son los estilos y patrones arquitectónicos que se ha seleccionado para guiar el diseño de la arquitectura de Glottia, asegurando que se alineen con los principios definidos y los drivers seleccionados para esta iteración. Cada enfoque se ha elegido por su capacidad para abordar aspectos clave como la modularidad, escalabilidad, mantenibilidad y seguridad del sistema.

| Enfoque | Descripción |
| ------- | ----------- |
| Domain Driven Design (DDD) | Definir sub dominios con delimitaciones y alcances claros como bounded contexts. |
| Arquitectura de Microservicios | Desglosar el sistema en servicios independientes y escalables. La migración desde el monolito modular inicial se realizó mediante la estrategia Strangler Fig, donde cada bounded context fue extraído incrementalmente en sprints sucesivos sin afectar la operación del sistema. |
| Organización N Capas | Dividir responsabilidades en 4 capas: interfaces, aplicación, dominio e infraestructura (Clean Architecture). |
| Documentación OpenAPI | Documentar las APIs siguiendo el estándar OpenAPI con SpringDoc. |
| Seguridad y Protección de información sensible | Gestión de acceso y autorización centralizada con JWT (JJWT) + RBAC, cifrado BCrypt de datos sensibles y cumplimiento con la Ley N.° 29733. |

### 4.1.3 Software Architecture Context Diagram

Aquí se presenta el diagrama de contexto de Glottia, que ilustra los principales actores, sistemas externos y los límites del sistema. Este diagrama ayuda a visualizar cómo Glottia interactúa con su entorno y define claramente las interfaces entre el sistema y sus usuarios o servicios externos. El software principal se conectará con servicios externos de Gemini AI y Stripe para generación de contenido y procesamiento de pagos, respectivamente.
\
![Diagrama de Contexto para Glottia](assets/img/cap4/context.png)

### 4.1.4 Approach driven ViewPoints Diagrams

A continuación, se desglosa la arquitectura de Glottia descendiendo de manera progresiva a través de los siguientes niveles del enfoque C4, permitiendo mapear desde la distribución lógica de contenedores en infraestructura hasta la organización de responsabilidades por componentes de código.

**Software Architecture Container Diagram**

El Diagrama de Contenedores representa el nivel 2 del Modelo C4 e ilustra la estructura de alto nivel de la arquitectura de software, detallando la distribución de responsabilidades tecnológicas ejecutables dentro del sistema de Glottia. Este diagrama expone cómo se descompone la aplicación en aplicaciones web, servicios backend autónomos y almacenes de datos persistentes, especificando los protocolos de comunicación de red (HTTP/REST, JSON) que permiten la interoperabilidad del ecosistema distribuido.

\
![Container-Diagram](assets/img/cap4/c4-container.png)


**Software Architecture Component Diagram**

El Diagrama de Componentes corresponde al nivel 3 del Modelo C4 y realiza una deconstrucción profunda e interna de un contenedor específico de la aplicación. Su objetivo es mapear cómo se estructuran las clases, controladores, casos de uso y adaptadores de infraestructura para dar soporte a la lógica de negocio, definiendo las interfaces y dependencias internas bajo los lineamientos de **Clean Architecture** y los patrones de diseño adoptados por el equipo.

#### Identity And Access Management

- Este bounded context se encarga de la Gestión de Acceso e Identidad dentro de la plataforma Glottia.

![IAM](assets/img/cap4/diagramas/components/iam.png){ width=80% }

#### Profiles Management

- Este bounded context se encarga de la Gestión de Perfiles dentro de la plataforma Glottia.

![Profiles](assets/img/cap4/diagramas/components/profiles.png){ width=80% }

#### Venues Management

- Este bounded context se encarga de la Gestión de Locales dentro de la plataforma Glottia.

![Venues](assets/img/cap4/diagramas/components/venues.png){ width=80% }

#### Promotions Management

- Este bounded context se encarga de la gestión de Promociones dentro de la plataforma Glottia.

![Promotions](assets/img/cap4/diagramas/components/promotions.png){ width=80% }

#### Encounters Management

- Este bounded context se encarga de la gestión de encuentros de idiomas dentro de la plataforma Glottia.

![Encounters](assets/img/cap4/diagramas/components/encounters.png){ width=80% }

#### Learning & Feedback

- Este bounded context se encarga de la generación de Quizzes y Feedback para un Aprendiz dentro de la plataforma Glottia.

![Learning](assets/img/cap4/diagramas/components/learning.png){ width=80% }

#### Loyalty & Engagement Management

- Este bounded context se encarga de la gestión de cuentas de lealtad dentro de la plataforma Glottia.

![Loyalty](assets/img/cap4/diagramas/components/encounters.png){ width=80% }

#### Dashboard & Analytics

- Este bounded context se encarga de gestionar las métricas dentro de la plataforma Glottia.

![Analytics](assets/img/cap4/diagramas/components/analytics.png){ width=80% }

#### Class Diagram

- Diagramas de Estados
\

Diagrama de estado sobre el ciclo de vida de Asistencia
\
![Ciclo de vida de Asistencia](assets/img/cap4/diagramas/estados/Ciclovidaasistencia.png)

Diagrama de estado sobre el ciclo de vida de Fidelidad
\
![Ciclo de vida de Cuenta de Fidelidad](assets/img/cap4/diagramas/estados/CicloVidaLoyalty.png)
\
Diagrama de estado sobre el ciclo de vida de Venues
\
![Ciclo de vida de Venues](assets/img/cap4/diagramas/estados/CicloVidaVenues.png)
\
Diagrama de estado sobre el ciclo de vida de Encuentro
\
![Ciclo de vida de un Encuentro](assets/img/cap4/diagramas/estados/CicloVidaEncuentro.png)
\
Diagrama de estado sobre el ciclo de vida de Promoción
\
![Ciclo de vida de una Promoción](assets/img/cap4/diagramas/estados/CicloVidaPromotions.png)


#### Identity And Access Management

- Este bounded context se encarga de la Gestión de Acceso e Identidad dentro de la plataforma Glottia.

![IAM](assets/img/cap4/diagramas/classes/iam.png){ width=80% }

#### Profiles Management

- Este bounded context se encarga de la Gestión de Perfiles dentro de la plataforma Glottia.

![Profiles](assets/img/cap4/diagramas/classes/profiles.png){ width=80% }

#### Venues Management

- Este bounded context se encarga de la Gestión de Locales dentro de la plataforma Glottia.

![Venues](assets/img/cap4/diagramas/classes/venues.png){ width=80% }

#### Promotions Management

- Este bounded context se encarga de la gestión de Promociones dentro de la plataforma Glottia.

![Promotions](assets/img/cap4/diagramas/classes/promotions.png){ width=80% }

#### Encounters Management

- Este bounded context se encarga de la gestión de encuentros de idiomas dentro de la plataforma Glottia.

![Encounters](assets/img/cap4/diagramas/classes/encounters.png){ width=80% }

#### Learning & Feedback

- Este bounded context se encarga de la generación de Quizzes y Feedback para un Aprendiz dentro de la plataforma Glottia.

![Learning](assets/img/cap4/diagramas/classes/learning.png){ width=80% }

#### Loyalty & Engagement Management

- Este bounded context se encarga de la gestión de cuentas de lealtad dentro de la plataforma Glottia.

![Loyalty](assets/img/cap4/diagramas/classes/encounters.png){ width=80% }

#### Dashboard & Analytics

- Este bounded context se encarga de gestionar las métricas dentro de la plataforma Glottia.

![Analytics](assets/img/cap4/diagramas/classes/analytics.png){ width=80% }

#### Diagrama de clases vista general

- Vista general del diagrama de clases de la plataforma Glottia

![Diagrama de Clases](assets/img/cap4/class_diagram.png){ width=90% }

### 4.1.5 Relational/Non Relational Database Diagram

Diagrama de base de datos que representa el modelamiento entidad relación de la plataforma Glottia.
\
![Diagrama de Clases](assets/img/cap4/database.png)

### 4.1.6 Design Patterns

En esta sección, el equipo de Hampcoders describe los principales patrones de diseño utilizados en el sistema. Estos patrones permiten mejorar la calidad de código desacoplando y modularizando.

#### 4.1.6.2 Patrones de Comportamiento
\
Los patrones de comportamiento definen el cómo interactúan los objetos y cómo se distribuyen las responsabilidades dentro del sistema.

##### Command
- Cuándo: Se necesita representar acciones del sistema.
- Beneficio: Desacoplar la invocación de la lógica de ejecución.
- Aplicación: Clases o Records como SignUpCommand, SignInCommand.

![Command](assets/img/cap4/diagramas/design/command.png){ width=80% }

##### Strategy
- Cuándo: Se necesitan múltiples algoritmos intercambiables.
- Beneficio: Cambiar implementación sin afectar lógica de negocio.
- Aplicación: Clases que representan servicios como HashingService, TokenService.

![Strategy](assets/img/cap4/diagramas/design/strategy.png){ width=80% }

##### Observer
- Cuándo: Se necesita comunicación desacoplada entre componentes.
- Beneficio: Permitir reaccionar a eventos sin dependencias directas.
- Aplicación: Eventos con @EventListener.

![Observer](assets/img/cap4/diagramas/design/observer.png){ width=80% }


#### 4.1.6.3 Patrones de Estructura
\
Los patrones estructurales se centran en la organización de objetos, facilitando la composición de componentes complejos.

##### Facade
- Cuándo: Se necesita simplificar el acceso a subsistemas complejos.
- Beneficio: Reducir acoplamiento entre bounded contexts.
- Aplicación: Clases como IamContextFacade.

![Facade](assets/img/cap4/diagramas/design/facade.png){ width=80% }


#### 4.1.6.4 Patrones Empresariales
\
Los patrones empresariales están orientados a resolver problemas comunes en aplicaciones empresariales, específicamente en el manejo de lógica, persistencia y comunicación entre capas.

##### Service Layer
- Cuándo: Se necesita centralizar lógica de aplicación.
- Beneficio: Separar dominio de infraestructura.
- Aplicación: Clases como UserCommandService.

![Service Layer](assets/img/cap4/diagramas/design/servicelayer.png){ width=80% }

##### Repository Pattern
- Cuándo: Se necesita acceso a persistencia.
- Beneficio: Desacoplar base de datos del dominio.
- Aplicación: Clases como UserRepository.

![Repository](assets/img/cap4/diagramas/design/repository.png){ width=80% }

##### Data Transfer Object (DTO)
- Cuándo: Se necesita transferencia de datos entre capas.
- Beneficio: Evitar exponer el dominio directamente.
- Aplicación: Clases como UserResource, SignInResource.

![DTO](assets/img/cap4/diagramas/design/dtos.png){ width=80% }

##### Mapper / Assembler
- Cuándo: Se necesita transformar entre DTO y entidades.
- Beneficio: Mantener separación entre capas.
- Aplicación: Clases como UserResourceFromEntityAssembler.

![Mapper](assets/img/cap4/diagramas/design/mapper.png){ width=80% }

##### Unit of Work
- Cuándo: Se necesita manejo de transacciones.
- Beneficio: Garantizar consistencia de datos.
- Aplicación: Clases gestionadas por JPA/Hibernate.

![Unit Of Work](assets/img/cap4/diagramas/design/uow.png){ width=80% }

##### Gateway
- Cuándo: Se necesita integración con otros contextos o servicios.
- Beneficio: Encapsular dependencias externas.
- Aplicación: Clases como ProfilesContextFacade.

![Gateway](assets/img/cap4/diagramas/design/gateway.png){ width=80% }


#### 4.1.6.5 Patrones Arquitectónicos
\
Los patrones arquitectónicos definen la estructura desde un punto de vista de alto nivel del sistema, permitiendo organizar los components en capas o con responsabilidades definidas.

##### CQRS
- Cuándo: Se necesita separar lectura y escritura.
- Beneficio: Mejorar claridad y escalabilidad.
- Aplicación: Clases CommandService vs QueryService.

![CQRS](assets/img/cap4/diagramas/design/cqrs.png){ width=80% }

##### Layered Architecture
- Cuándo: Se necesita organizar el sistema por capas.
- Beneficio: Separar responsabilidades.
- Aplicación: Domain, Application, Infrastructure, Interfaces.

![Layered Architecture](assets/img/cap4/diagramas/design/factorymethod.png){ width=80% }

##### MVC
- Cuándo: Se necesita estructurar la capa de presentación.
- Beneficio: Separar entre vista, lógica y datos.
- Aplicación: Controllers + Resources.

![MVC](assets/img/cap4/diagramas/design/mvc.png){ width=80% }


### 4.1.7 Tactics

Las tácticas arquitectónicas de Glottia han sido definidas considerando su enfoque basado en Domain-Driven Design (DDD), arquitectura de monolito modular y comunicación asíncrona por eventos. Estas tácticas buscan reforzar los principales atributos de calidad del sistema: disponibilidad, modificabilidad, rendimiento, seguridad, usabilidad y escalabilidad, garantizando una experiencia fluida tanto para usuarios como para establecimientos aliados.

| Táctica | Objetivo de Calidad | Aplicación en Glottia |
|:---|:---|:---|
| **Confiabilidad** | Garantizar confianza en la organización de encuentros y la información mostrada | Validación de eventos y sesiones conversacionales antes de su publicación. Confirmación de asistencia de usuarios y verificación de disponibilidad de locales aliados para evitar inconsistencias. Manejo de errores controlado entre Bounded Contexts mediante eventos de compensación. |
| **Confiabilidad** | Garantizar la consistencia y correcto procesamiento de las operaciones ante escenarios de concurrencia o fallo parcial | Publicación condicional de domain events solo post-commit exitoso (@TransactionalEventListener(AFTER_COMMIT)). Consistencia transaccional ACID por Bounded Context. Rate Limiter en operaciones sensibles (generación OTP: 3 solicitudes/minuto). Consistencia eventual entre BCs mediante eventos de dominio con handlers asíncronos. |
| **Modificabilidad** | Facilitar la evolución del sistema y adaptación a nuevos requerimientos | Uso de Bounded Contexts bien definidos (Usuarios, Sesiones, Locales, Matching, Notificaciones). Cada módulo encapsula su lógica y datos, permitiendo cambios independientes. Interfaces explícitas y contratos versionados para evitar impacto en otros módulos. |
| **Performance** | Optimizar tiempos de respuesta en búsquedas y match de usuarios | Implementación de mecanismos de caché para consultas frecuentes (búsqueda de eventos, locales disponibles). Procesamiento asíncrono para recomendaciones de matches entre usuarios según idioma, nivel y preferencias. Optimización de consultas en base de datos para geolocalización y disponibilidad de espacios. |
| **Seguridad** | Proteger datos personales y accesos a la plataforma | Implementación de autenticación centralizada con JWT. Cifrado de datos sensibles (credenciales, información personal). Control de acceso basado en roles. Validación de permisos en cada módulo del sistema. |
| **Usabilidad** | Garantizar una experiencia intuitiva y atractiva | Interfaces simples para reservar y unirse a sesiones conversacionales. Flujo claro de descubrimiento de eventos (explorar → seleccionar → unirse). Notificaciones en tiempo real sobre cambios en eventos o confirmaciones. Feedback visual inmediato en acciones del usuario. |
| **Escalabilidad** | Permitir el crecimiento del sistema sin afectar su rendimiento | Diseño basado en eventos que permite escalar módulos específicos (por ejemplo, notificaciones o feedback). Posibilidad futura de migrar Bounded Contexts a microservicios sin rediseñar toda la arquitectura. Uso de bases de datos optimizadas para lectura y escritura según el contexto. |


## 4.2 Architectural Drivers

Los drivers arquitectónicos constituyen los factores determinantes que orientan las decisiones de diseño y construcción de la arquitectura de Glottia. Estos elementos definen tanto las prioridades estratégicas como las restricciones técnicas y operacionales que el equipo de desarrollo debe incorporar para garantizar el cumplimiento de los objetivos de negocio, sin comprometer los atributos de calidad esenciales: escalabilidad, mantenibilidad, confiabilidad y rendimiento.

En este contexto, los drivers arquitectónicos se articulan en torno a cuatro dimensiones fundamentales: el propósito del diseño y los objetivos comerciales; las funcionalidades prioritarias derivadas de los requerimientos funcionales; los escenarios de atributos de calidad que definen comportamientos esperados bajo condiciones específicas; y las restricciones y concernimientos arquitectónicos que limitan el espacio de soluciones viables. La integración coherente de estos elementos permitirá construir una arquitectura sostenible que evolucione conforme las necesidades del negocio y del mercado lo requieran.

### 4.2.1 Design Purpose

El propósito del diseño arquitectónico de Glottia es construir una estructura modular, escalable y segura basada en Bounded Contexts que conecte de manera confiable a aprendices de idiomas con establecimientos aliados, garantizando consistencia operacional, rendimiento óptimo en operaciones críticas y la capacidad de evolucionar hacia microservicios conforme las necesidades del negocio y mercado lo requieran.

### 4.2.2 Primary Functionality (Primary User Stories)

Se identifican aquí los requisitos funcionales de alta prioridad que impactan directamente en las decisiones de diseño de la arquitectura. A través de estas historias de usuario clave, se establecen los módulos base y las relaciones de datos de Glottia, asegurando que la estructura soporte tanto la lógica operativa como los atributos de calidad esperados.

|ID|Título|Descripción|Impacto estructural|
|:---|:---|:---|:---|
|US001–US003| Registro, autenticación y gestión de sesión de usuario| Permite al Learner y al Partner registrarse con email/contraseña, iniciar sesión y obtener tokens JWT para acceder al sistema.| BC IAM genera `UserRegistered` -> dispara creación de perfil en Profiles. Punto de entrada de toda la arquitectura; todos los BCs consumen el JWT para autorización. | 
|US004–US007| Creación y configuración del perfil de aprendiz | El Learner completa su perfil indicando idioma nativo, idiomas meta, nivel CEFR y disponibilidad horaria. El perfil es prerrequisito para reservar encuentros. | BC Profiles publica `ProfileCompleted` -> Encounters lo consume para habilitar la funcionalidad de reserva. Relación directa con los BCs Engagement (nivel CEFR para leaderboard) y Analytics (segmentación de KPIs)|
|US008–US011|Registro de local aliado y publicación de venues|El Partner da de alta su establecimiento (cafetería, bar, coworking), registra mesas y configura la disponibilidad horaria de los espacios.|BC Venues publica `VenueActivated` -> consumido por Encounters (para asociar encuentros a locales) y Promotions (para validar la existencia del venue al crear links promocionales).|
|US012–US016|Creación, búsqueda y reserva de encuentros presenciales|El Learner busca encuentros por idioma, fecha y ubicación; reserva un cupo disponible y recibe confirmación. Incluye gestión de cupo lleno con estado de espera.|BC Encounters es el Core operativo central; consume `ProfileCompleted` y `VenueActivated`. Su evento `UserCheckedIn` dispara puntos en Engagement y métricas en Analytics.|
|US017–US019|Check-in por OTP y cierre de encuentro|El Learner realiza check-in escaneando un código OTP en el local. El sistema valida la asistencia, actualiza el estado del encuentro a `COMPLETED` y desencadena el loop post-encuentro.|BC Encounters publica `UserCheckedIn` -> Engagement (+10 pts) y `EncounterCompleted` -> Learning Feedback (genera quiz) y Analytics (registra asistencia). Evento pivote del sistema.|
|US020–US024|Self-assessment y peer feedback post-encuentro|Tras el encuentro, el Learner evalúa su desempeño en 5 dimensiones (expresión, comprensión, vocabulario, fluidez, confianza) y recibe feedback anónimo de sus pares.|BC Learning Feedback publica `AssessmentCompleted` y `FeedbackSubmitted` -> Engagement acumula puntos. Actualiza `FluencyScore` en su propio esquema, sin acoplarse a otros BCs.|
|US025–US027|Generación y resolución de quiz LLM post-encuentro| El sistema genera automáticamente un quiz de 5 preguntas usando LLM (Claude/GPT-4) basado en el tema e idioma del encuentro completado. El Learner lo responde y obtiene retroalimentación inmediata.|BC Learning Feedback es el único con dependencia externa (LLM API). Consume `EncounterCompleted` de Encounters y publica `QuizPassed` -> Engagement (+10 pts). Dependencia externa completamente aislada en este BC.|
|US028–US032|Acumulación de puntos, badges y leaderboard|El sistema acredita puntos automáticamente por cada acción validada (check-in, quiz aprobado, self-assessment, peer feedback). El Learner visualiza su posición en el leaderboard segmentado por nivel CEFR.|BC Engagement consume `UserCheckedIn`, `AssessmentCompleted`, `QuizPassed`, `FeedbackSubmitted`. Publica `PointsAwarded` y `BadgeUnlocked`-> Analytics. Coordinación directa con Promotions para el flujo de canje.|
|US033–US036| Creación de promociones y asociación a venues|El Partner crea promociones (descuentos, cortesías, 2×1), define vigencia y stock, y las asocia a uno o múltiples venues.|BC Promotions consume `VenueActivated` para validar la existencia del venue. Publica `PromotionRedeemed` -> Analytics. Relación many-to-many con Venues mediante VenuePromotionLink.|
|US037–US039|Canje de puntos por promociones en venues aliados|El Learner consulta el catálogo de recompensas disponibles y canjea sus puntos acumulados por una promoción en el venue donde realizó el encuentro.|Engagement orquesta el canje llamando directamente a Promotions (Partnership pattern). Promotions descuenta stock y emite `RedemptionCode`. Cierre del loop motivacional del segmento Learner.|
|US040–US043| Dashboard de KPIs para Partner y Admin|El Partner visualiza métricas mensuales de su venue: reservas, tasa de asistencia, rating promedio y tasa de canje de promociones. El Admin accede a KPIs globales del sistema.|BC Analytics es consumidor puro de eventos de todos los BCs Core (`UserCheckedIn`, `EncounterCompleted`, `PointsAwarded`, `PromotionRedeemed`, `VenueCreated`). No publica eventos; no tiene lógica de negocio propia.|

### 4.2.3 Quality Attribute Scenarios

Los atributos de calidad definen el comportamiento esperado del sistema Glottia bajo condiciones operacionales reales. Los escenarios siguientes describen estímulos concretos, los componentes afectados y las respuestas esperadas, con medidas cuantificables para validar la arquitectura basada en contextos de dominio (Usuarios, Sesiones, Locales, Matching, Notificaciones) e infraestructura (pasarela API, caché, bus de eventos).

#### QAS-01: Seguridad - Control de acceso basado en roles

| Atributo      | Fuente de Estímulo                     | Estímulo                                                                            | Entorno          | Artefacto                        | Respuesta                                                                                                      | Medida                                                                                             |
|:---|:---|:---|:---|:---|:---|:---|
| **Seguridad** | Usuario autenticado con rol incorrecto | Solicitud \seqsplit{`POST /api/v1/encounters/{id}/join`} con JWT válido pero rol no autorizado | Operación normal | IAM Service (Spring Security filter chain) + RBAC | El sistema rechaza la solicitud con HTTP 403 antes de llegar al microservicio. Se registra el intento en logs. | 100% de accesos no autorizados rechazados. Tiempo de respuesta < 200 ms. Logs retenidos ≥ 90 días. |

#### QAS-02: Confiabilidad - Publicación confiable de eventos post-check-in

| Atributo           | Fuente de Estímulo | Estímulo                                                                             | Entorno                   | Artefacto                                            | Respuesta                                                                                                 | Medida                                                                                          |
|:---|:---|:---|:---|:---|:---|:---|
| **Confiabilidad** | Usuario aprendiz   | Solicitud \seqsplit{`POST /api/v1/encounters/{id}/check-in`} con OTP válido | Operación normal con concurrencia | Encounters BC + @TransactionalEventListener(AFTER_COMMIT) | El check-in se registra en BD. El evento LearnerCheckedIn se publica solo después del commit exitoso. Engagement y Analytics lo procesan asíncronamente. | 100% de eventos publicados post-commit exitoso. 0 eventos huérfanos en caso de rollback de transacción. |

#### QAS-03: Mantenibilidad - Despliegue independiente de Bounded Contexts

| Atributo           | Fuente de Estímulo   | Estímulo                                                | Entorno           | Artefacto                                                  | Respuesta                                                                               | Medida                                                                |
|:---|:---|:---|:---|:---|:---|:---|
| **Mantenibilidad** | Equipo de desarrollo | Cambio en lógica de acumulación de puntos en Engagement | Desarrollo activo | Engagement BC + API versionada + esquema de base de datos aislado por BC | El cambio se implementa sin afectar otros servicios. No requiere redeploy de otros BCs. | Cambio desplegado < 4h. 0 cambios en otros servicios. CI/CD < 10 min. |

#### QAS-04: Mantenibilidad - Extensibilidad del sistema de recompensas

| Atributo           | Fuente de Estímulo   | Estímulo                                                                 | Entorno           | Artefacto                                                             | Respuesta                                                                                                                                      | Medida                                                                                                         |
|:---|:---|:---|:---|:---|:---|:---|
| **Mantenibilidad** | Equipo de desarrollo | Incorporación de un nuevo tipo de recompensa en el sistema de Engagement | Desarrollo activo | Engagement BC + arquitectura modular + contratos API versionados | El nuevo tipo de recompensa se implementa extendiendo la lógica existente sin modificar otros servicios. No afecta a Encounters ni Promotions. | Implementación < 6 horas. 0 cambios en otros microservicios. Cobertura de tests ≥ 80% en el módulo modificado. |

### 4.2.4 Constraints 

En arquitectura de software, las  **constraints (restricciones)**  son básicamente  **límites o condiciones que el sistema debe respetar sí o sí**  al momento de diseñar y construir una aplicación.

En Glottia hemos definido restricciones por categoría para adaptarnos a ellas y poder manejar una arquitectura escalable y sostenible.

|Categoría|Detalles de restricción|
|:---|:---|
|**Plataforma y Entorno**| Despliegue obligatorio en  **Android (mínimo API 24)**  e  **iOS (mínimo v15)**  mediante base de código única en  **Flutter/Kotlin Multiplatform**.|
|**Infraestructura Cloud**|Uso de  **Firebase**  como BaaS (Backend as a Service) para autenticación y base de datos en tiempo real.|
|**Persistencia de Datos**|La base de datos local debe implementarse con  **Room (Android)**  o  **SQLite**  para soporte offline.|
|**Cumplimiento Legal**|Obligatoriedad de cumplir con la  **Ley N.º 29733**  (Ley de Protección de Datos Personales en Perú), especialmente en el cifrado de correos y nombres de usuarios.|
|**Integraciones Externas**|Las llamadas a APIs de terceros (ej. Google Translate API o DeepL) deben estar limitadas por cuotas de consumo para evitar sobrecostos.|
|**Metodología de Trabajo**|El desarrollo debe seguir un flujo de  **GitFlow**  y documentación de arquitectura basada en el modelo **C4**.|

### 4.2.5 Architectural Concerns 

Estas son las metas de alto nivel que nuestra arquitectura debe "solucionar" para que el proyecto sea exitoso.

#### 1. Desacoplamiento de Lógica de Negocio (DDD)
\
Dado que Glottia busca ser una solución escalable, una preocupación principal es evitar que la lógica del lenguaje o servicios se mezcle con el código de la interfaz (UI).

- **Solución:** Implementar una arquitectura de capas (Dominio, Aplicación, Infraestructura).
    

#### 2. Sincronización y Estado Offline
\
Siendo una aplicación móvil, la conectividad intermitente es un riesgo crítico.

- **Preocupación:** ¿Cómo garantizamos que el progreso del usuario no se pierda sin conexión?
    
- **Meta:** Estrategia de  _Offline-first_  con sincronización en segundo plano cuando se recupere el aliento de red.
    

#### 3. Rendimiento y Latencia de Interfaz
\
En una app de aprendizaje o servicios, la percepción de fluidez es vital.

- **Preocupación:** El procesamiento de datos pesados no debe bloquear el hilo principal (UI Thread).
    
- **Meta:** Uso intensivo de programación asíncrona y manejo eficiente de memoria en el dispositivo móvil.
    

#### 4. Seguridad en el Transporte de Datos
\
Protección de la integridad de los datos entre el dispositivo y Firebase.

- **Preocupación:** Evitar ataques de Man-in-the-Middle y asegurar que solo usuarios autenticados accedan a sus propios recursos.
    
- **Meta:** Implementación de  **Firebase Security Rules**  y comunicación exclusiva vía HTTPS con TLS 1.3.
    

#### 5. Extensibilidad del Sistema
\
Glottia debe permitir añadir nuevos idiomas o tipos de servicios sin reescribir el núcleo.

- **Preocupación:** El "Gran Lodo" (Big Ball of Mud) donde todo depende de todo.
    
- **Meta:** Definición clara de  **Bounded Contexts**  para que el módulo de "Usuarios" sea independiente del módulo de "Contenido Académico/Servicios".

## 4.3 ADD Iterations

En esta sección se describen las iteraciones de diseño arquitectónico que el equipo llevará a cabo para construir la solución Glottia, partiendo desde un monolito modular hacia una arquitectura de microservicios alineada a los 10 Bounded Contexts definidos. Cada iteración se enfocará en aspectos específicos de la arquitectura, abordando los drivers seleccionados y refinando elementos clave del sistema.

### 4.3.1 Iteration 1: Definition of Glottia's Architectural Core

Primera iteración enfocada en establecer las bases arquitectónicas de Glottia, definiendo los elementos clave que garantizarán la seguridad, confiabilidad y mantenibilidad del sistema. Se priorizarán los drivers relacionados con la protección de datos, la consistencia operacional y la capacidad de evolución independiente por dominio funcional.

#### 4.3.1.1 Architectural Design Backlog 1

En este backlog se definirán las características arquitectónicas clave para garantizar el correcto funcionamiento de Glottia. Se priorizarán tres atributos de calidad: Seguridad, para proteger los datos personales de los aprendices y establecimientos bajo la Ley N.° 29733; Confiabilidad, para garantizar la consistencia de las operaciones ante escenarios de concurrencia; y Mantenibilidad, para permitir que el sistema evolucione de forma independiente por dominio funcional.

#### Seguridad

| User Stories | Tareas | Criterios de Aceptación |
|:---|:---|:---|
| Como aprendiz, quiero registrarme con mis datos personales para acceder a la plataforma. | Implementar autenticación centralizada con JWT (JJWT) en el BC IAM. Configurar RBAC con roles USER, ADMIN, SUPERADMIN, SUPPORT. Cifrar contraseñas con BCrypt y códigos OTP con BCrypt conforme Ley N.° 29733. | Solo usuarios autenticados acceden a reservas y encuentros. Las contraseñas se almacenan con hashing BCrypt. El sistema bloquea accesos no autorizados a perfiles ajenos. |
| Como administrador de establecimiento, quiero que solo yo pueda gestionar mi local para proteger mi información. | Implementar validación de propiedad por rol en cada endpoint mediante @PreAuthorize. El filtro BearerAuthorizationRequestFilter valida el token JWT en cada request. | Un aprendiz no puede modificar datos de un establecimiento. El 100% de operaciones sensibles queda registrado en el log de auditoría. | 

#### Confiabilidad

| User Stories | Tareas | Criterios de Aceptación |
|:---|:---|:---|
| Como aprendiz, quiero que mi check-in y acumulación de puntos se procesen de forma consistente aunque haya operaciones simultáneas. | Implementar publicación de domain events solo post-commit (@TransactionalEventListener(AFTER_COMMIT)). Garantizar consistencia transaccional ACID por Bounded Context. Aplicar Rate Limiter en generación de OTP (3 solicitudes/minuto). | El 100% de eventos se publican solo si la transacción del aggregate raíz fue exitosa. 0 eventos huérfanos en caso de rollback. Operaciones multi-BC operan bajo consistencia eventual. |


#### Mantenibilidad

| User Stories | Tareas | Criterios de Aceptación |
|:---|:---|:---|
| Como desarrollador de HampCoders, quiero modificar la lógica de reservas sin afectar el módulo de establecimientos para desplegar más rápido.  | Diseñar la arquitectura con Bounded Contexts independientes (IAM, Event, Reservas, Establecimientos, Notificaciones). Implementar Database per Service. Definir contratos OpenAPI versionados entre servicios. | Un cambio en la lógica de reservas se puede desplegar en menos de 4 horas sin afectar otros servicios. Cada microservicio tiene su propia base de datos sin acoplamiento compartido. |
| Como desarrollador, quiero que las dependencias a sistemas externos queden completamente aisladas. | Encapsular la dependencia de Claude/GPT-4 exclusivamente en el microservicio Learning Feedback. Ningún otro BC importa ni conoce la librería del LLM. | Si el LLM API falla, solo Learning Feedback se ve afectado. El resto del sistema opera con normalidad |

#### 4.3.1.2 Establish Iteration Goal by Selecting Drivers
\
En esta iteración el equipo de Hampcoders seleccionará los drivers de Seguridad, Confiabilidad y Mantenibilidad como base del diseño de Glottia.

##### Meta de Seguridad

- Objetivo: Establecer autenticación stateless centralizada con JWT auto-emitido (JJWT) en el BC IAM, control de acceso RBAC vía @PreAuthorize, y cifrado de datos sensibles (contraseñas, códigos OTP) con BCrypt en cumplimiento con la Ley N.° 29733.
- Acciones clave: Implementar token JWT con claims embebidos (userId, accessRole, role, profileId). Configurar @EnableMethodSecurity con @PreAuthorize por endpoint. Aplicar BCrypt para hashing de contraseñas y OTPs. Implementar filtro BearerAuthorizationRequestFilter para validación centralizada de tokens.

##### Meta de Mantenibilidad

- Objetivo: Convertir los 10 Bounded Contexts del monolito modular en microservicios Java 21 + Spring Boot independientes, cada uno con su propio esquema PostgreSQL, repositorio Git y pipeline de despliegue.

- Acciones clave: Migrar cada paquete Maven a un proyecto Spring Boot independiente. Aplicar Database per Service con esquemas PostgreSQL exclusivos. Definir contratos OpenAPI por servicio. Aislar la dependencia LLM exclusivamente en Learning Feedback.

##### Meta de Confiabilidad
- Objetivo: Garantizar la consistencia y correcto procesamiento de las operaciones del sistema ante escenarios de concurrencia o fallo parcial, asegurando que los eventos de dominio solo se propaguen después de transacciones exitosas.
- Acciones clave: Publicación condicional de domain events con @TransactionalEventListener(AFTER_COMMIT). Aislamiento transaccional ACID por Bounded Context. Rate Limiter con Resilience4j en operaciones sensibles (generación OTP: 3 solicitudes/minuto). Consistencia eventual entre BCs mediante eventos de dominio con handlers asíncronos.

##### Objetivo de la Iteración

- Seguridad: Establecer la base de autenticación centralizada stateless con JWT (JJWT) + RBAC + cifrado BCrypt de datos sensibles (contraseñas, OTPs), en cumplimiento con la Ley N.° 29733 de Protección de Datos Personales, con validación centralizada de tokens mediante el filtro BearerAuthorizationRequestFilter de Spring Security.
- Confiabilidad: Asegurar que las operaciones core (reserva, check-in, acumulación de puntos) se procesen de forma consistente, publicando eventos de dominio solo después del commit exitoso de la transacción del aggregate raíz (@TransactionalEventListener AFTER_COMMIT), y aplicando Rate Limiter en operaciones sensibles como la generación de OTP (3 solicitudes/minuto).
- Mantenibilidad: Definir la arquitectura en 10 Bounded Contexts independientes con interfaces explícitas (ACL Facades + Domain Events), contratos OpenAPI versionados (v1.0.0), y visión de evolución hacia microservicios independientes con Database per Service, aislando dependencias externas (LLM, notificaciones multicanal) en sus respectivos BCs.

#### 4.3.1.3 Choose One or More Elements of the System to Refine
\
Aquí se presentan los elementos clave del sistema que se refinarán en esta iteración, junto con las razones para su selección y lo que se espera lograr con cada uno de ellos. Estos elementos son fundamentales para alcanzar los objetivos de seguridad, disponibilidad y mantenibilidad definidos previamente.

| Elemento a Refinar | Razón | Esperado |
|:---|:---|:---|
| Monolito modular completo | Es el sistema de partida. Debe descomponerse en 10 Bounded Contexts modulares. | Autenticación centralizada con JWT, RBAC por rol y protección de endpoints sensibles. | 10 Bounded Contexts como unidades modulares: IAM, Profiles, Venues, Promotions, Encounters, Engagement, Learning Feedback, Analytics, Notifications, Verification. Visión futura de migración a microservicios independientes. |
| Comunicación entre Bounded Contexts (asíncrona) | Los ApplicationEvents funcionan dentro del mismo proceso JVM. En el monolito modular, la comunicación asíncrona se maneja mediante Spring ApplicationEventPublisher con @TransactionalEventListener(AFTER_COMMIT). | Domain events publicados in-process solo post-commit transaccional, con handlers asíncronos (@Async) en executors dedicados para notificaciones y generación de quizzes. Visión futura: migrar a Message Broker al separar en microservicios. |
| Validación centralizada de tokens JWT | Todos los endpoints deben validar el token JWT de forma consistente sin depender de un gateway externo. | Filtro BearerAuthorizationRequestFilter en Spring Security como punto único de validación de tokens JWT en todos los requests. | 
| Dependencia LLM | En el monolito, esta dependencia podría haberse filtrado a otros módulos. En microservicios debe quedar encapsulada. | Learning Feedback es el único servicio que importa la librería del LLM. Ningún otro BC la conoce. |

#### 4.3.1.4 Choose One or More Design Concepts That Satisfy the Selected Drivers
\
Se eligen los siguientes conceptos de diseño para abordar los drivers seleccionados en esta iteración, garantizando que la arquitectura de Glottia sea segura, disponible y mantenible:

##### Seguridad

- Autenticación y Autorización Centralizada (JWT + RBAC)
    - Descripción: El BC IAM gestiona registro, login y emisión de tokens JWT (JJWT) con claims embebidos (userId, accessRole, role, profileId, learnerId/partnerId). El token es validado en cada request por el filtro BearerAuthorizationRequestFilter de Spring Security. El control de acceso se realiza mediante @PreAuthorize con roles USER, ADMIN, SUPERADMIN y SUPPORT.
    - Justificación: Centraliza la fuente de verdad de autenticación y autorización sin depender de proveedores OAuth2 externos. El cifrado BCrypt de contraseñas y OTPs cumple con la Ley N.° 29733 de Perú.

- Filtro BearerAuthorizationRequestFilter como punto único de validación
    - Descripción: Todo request entrante pasa por el filtro BearerAuthorizationRequestFilter, que extrae el token JWT del header Authorization, lo valida (firma, expiración) y establece el contexto de seguridad antes de llegar al controlador.
    - Justificación: Proporciona una capa de seguridad centralizada sin necesidad de API Gateway externo, manteniendo la arquitectura de monolito modular.

##### Confiabilidad

- Publicación Confiable de Domain Events (TransactionalEventListener)
    - Descripción: Los domain events se publican mediante Spring ApplicationEventPublisher, pero solo se propagan a los event handlers después de que la transacción de la base de datos ha sido commiteada exitosamente (@TransactionalEventListener con fase AFTER_COMMIT). Los handlers de notificaciones se ejecutan de forma asíncrona mediante @Async("notificationTaskExecutor").
    - Justificación: Garantiza que no se generen eventos huérfanos si la operación de negocio falla a mitad del proceso. Si el commit falla, el evento nunca se publica. Esto asegura consistencia entre el estado persistido y los eventos consumidos por otros BCs.

- Rate Limiter en Operaciones Sensibles
    - Descripción: Resilience4j Rate Limiter configurado para limitar la generación de códigos OTP a 3 solicitudes por minuto por usuario, evitando abusos en el servicio de verificación.
    - Justificación: Previene ataques de fuerza bruta y garantiza disponibilidad equitativa del servicio de verificación OTP sin necesidad de infraestructura adicional.

- Consistencia Transaccional ACID por Bounded Context
    - Descripción: Cada BC opera con @Transactional en sus CommandServices, garantizando que todas las operaciones dentro de un aggregate sean atómicas. La comunicación entre BCs opera bajo consistencia eventual mediante domain events.
    - Justificación: Elimina la necesidad de transacciones distribuidas. Cada BC es dueño absoluto de sus datos y garantiza su consistencia interna de forma aislada.

##### Mantenibilidad
- Arquitectura Modular alineada a Bounded Contexts DDD
    - Descripción: Cada uno de los 10 Bounded Contexts de Glottia (IAM, Profiles, Venues, Promotions, Encounters, Engagement, Learning Feedback, Analytics, Notifications, Verification) se organiza como un módulo independiente dentro del monolito modular, siguiendo una plantilla estricta (Presentation → Application → Domain → Infrastructure). Visión de evolución hacia microservicios independientes con Database per Service.
    - Justificación: Permite que equipos distintos desarrollen, prueben y desplieguen su BC sin afectar a los demás. Un cambio en Engagement no requiere redesplegar Encounters ni IAM.

- Database per Service
    - Descripción: Cada microservicio es dueño exclusivo de su esquema PostgreSQL. Ningún servicio accede directamente a la base de datos de otro.
    - Justificación: Garantiza bajo acoplamiento a nivel de datos. El esquema de Promotions puede evolucionar sin afectar a Engagement ni a Venues.

- Patrón Adapter para dependencias externas
    - Descripción: Cada dependencia externa se encapsula detrás de una interfaz interna: LLM API en Learning Feedback, SendGrid/FCM/Twilio en Notifications, BCrypt en IAM, JJWT en IAM. Si cambia un proveedor, solo se reemplaza el adaptador correspondiente sin tocar la lógica de negocio.
    - Justificación: Aísla los puntos de variabilidad técnica del sistema. Ningún BC importa directamente bibliotecas de terceros; solo los adaptadores en la capa de infraestructura conocen las dependencias externas.

#### 4.3.1.5 Instantiate Architectural Elements, Allocate Responsibilities, and Define Interfaces
\
Se definen los elementos arquitectónicos clave de Glottia, asignando responsabilidades específicas a cada uno y detallando las interfaces que expondrán para interactuar con otros componentes del sistema. Esta definición es fundamental para garantizar que cada microservicio cumpla con su rol dentro de la arquitectura general, facilitando la comunicación entre ellos y asegurando que se respeten los principios de diseño establecidos.

| **Elemento**                           | **Responsabilidad**                                                                        | **Interfaces**                                                                                                                                                                                                  |
|:---|:---|:---|
| **IAM BC**                        | Registro, login, emisión y validación de JWT. Gestión de roles USER/ADMIN/SUPERADMIN/SUPPORT.         | `POST /api/v1/authentication/sign-in`\newline `POST /api/v1/authentication/sign-up`\newline Publica evento `UserRegistered`.                                                                                                         |
| **Profiles BC**                   | Perfil de usuario, idiomas, nivel CEFR y disponibilidad. Roles de negocio LEARNER/PARTNER.                                   | `GET /api/v1/profiles`\newline `POST /api/v1/profiles`\newline `PUT /api/v1/profiles`\newline Consume `UserRegistered`. Publica `ProfileCompleted`.                                                                                                 |
| **Venues BC**                     | Alta de partners, gestión de venues, mesas y disponibilidad horaria.                       | `GET /api/v1/venues`\newline `POST /api/v1/venues`\newline `PUT /api/v1/venues`\newline Publica `VenueActivated`, `VenueCreated`.                                                                                                    |
| **Promotions BC**                 | Catálogo de promociones, vigencia, stock y canje.                                          | `GET /api/v1/promotions`\newline `POST /api/v1/promotions`\newline Consume `VenueActivated`. Publica `PromotionRedeemed`.                                                                             |
| **Encounters BC**                 | Búsqueda de encuentros, reserva de cupos, check-in OTP y gestión de estados.                | `GET /api/v1/encounters/search`\newline `POST /api/v1/encounters/{id}/join`\newline `POST /api/v1/encounters/{id}/check-in`\newline Publica `LearnerCheckedIn`, `EncounterCompleted`.                                                                  |
| **Engagement BC**                 | Acumulación de puntos, badges, leaderboard y canje de puntos.                              | `GET /api/v1/engagement/rewards/catalog`\newline `POST /api/v1/engagement/rewards/redeem`\newline Consume `LearnerCheckedIn`, `AssessmentCompleted`, `QuizPassed`, `FeedbackSubmitted`. |
| **Learning Feedback BC**          | Self-assessment, peer feedback, quiz LLM y FluencyScore. Único con dependencia al LLM API. | `POST /api/v1/learning-feedback/self-assessment`\newline `POST /api/v1/learning-feedback/peer`\newline `POST /api/v1/learning-feedback/quiz/{id}/answer`\newline Consume `EncounterCompleted`.\newline Publica `AssessmentCompleted`, `QuizPassed`, `FeedbackSubmitted`.            |
| **Analytics BC**                  | KPIs y métricas para partners y admin. Consumidor puro de eventos.                         | `GET /api/v1/analytics/monthly`\newline Consume todos los eventos del sistema. No publica eventos.                                                                                                                          |
| **Notifications BC**                  | Notificaciones multicanal: email (SendGrid), push (FCM), SMS (Twilio). | Consume eventos de dominio. Sin endpoints REST públicos. |
| **Verification BC**                  | Generación y verificación de códigos OTP con Rate Limiter (3 req/min). | `POST /api/v1/verification/generate`\newline `POST /api/v1/verification/verify`\newline Publica `OtpGenerated`, `OtpVerified`. |
| **Base de datos PostgreSQL**          | Esquema único compartido con prefijos por BC (identity_, member_, venue_, etc.). Visión futura: Database per Service.                                      | Repositorios JPA internos de cada BC. Sin acceso cruzado entre esquemas de distintos BCs.                                                                                                                                      |

#### 4.3.1.6 Sketch Views (C4 & UML) and Record Design Decisions
\
Las decisiones de diseño arquitectónico tomadas durante esta iteración se documentan a continuación, detallando el ID de la decisión, la descripción, el estado actual y la justificación que respalda cada elección. Estas decisiones reflejan las elecciones estratégicas realizadas para cumplir con los objetivos de seguridad, disponibilidad y mantenibilidad definidos para Glottia.

| ID | Decisión | Estado | Justificación |
|:---|:---|:---|:---|
| DD-001 | 10 Bounded Contexts como unidades modulares con visión de evolución a microservicios | Aceptada | Permite desarrollo independiente por BC y sienta las bases para una futura migración a microservicios. |
| DD-002 | Autenticación centralizada con JWT (JJWT) + RBAC + cifrado BCrypt | Aceptada | Centraliza la seguridad y cumple con Ley N.° 29733. Sin dependencia de proveedores OAuth2 externos. |
| DD-003 | Publicación confiable de domain events con @TransactionalEventListener(AFTER_COMMIT) | Aceptada | Garantiza consistencia entre el estado persistido y los eventos publicados. 0 eventos huérfanos en caso de rollback. |
| DD-004 | Base de datos PostgreSQL única con prefijos por BC; visión futura de Database per Service | Aceptada | Permite evolución independiente del esquema por BC sin acoplamiento físico. La separación lógica facilita la migración futura. |
| DD-005 | Filtro BearerAuthorizationRequestFilter como punto único de validación JWT en Spring Security | Aceptada | Centraliza la autenticación sin necesidad de API Gateway externo, manteniendo la arquitectura de monolito modular. |

#### 4.3.1.7 Analysis of Current Design and Review Iteration Goal (Kanban Board)
\
Tras completar la primera iteración, la arquitectura base de Glottia establece los cimientos necesarios para soportar los dos segmentos de usuarios.

- Fortalezas del diseño:
    - La separación por Bounded Contexts garantiza que el equipo pueda trabajar en paralelo sobre IAM, Encounters y Learning Feedback sin interferencias. 
    - El aislamiento del LLM en un único servicio protege al resto del sistema ante latencias o fallos del proveedor externo. 
    - La publicación confiable de domain events con @TransactionalEventListener(AFTER_COMMIT) garantiza que Analytics y Engagement procesen eventos solo cuando los datos han sido persistidos correctamente, eliminando el riesgo de eventos huérfanos.

- Áreas de mejora identificadas: 
    - La consistencia eventual entre BCs requiere que el equipo diseñe con cuidado las sagas de datos, especialmente en el flujo de canje

 - Kanban Board:

| **To Do** | **In Progress** | **Done** |
|:---|:---|:---|
| Implementar Rate Limiter en generación OTP (✅ implementado) | Implementación de IAM BC con Spring Security 6 + JWT | Definición de los 10 BCs como unidades modulares                         |
| Diseñar contratos OpenAPI por BC (✅ implementado) | Definición de ACL Facades y Domain Events por BC | Definición del Context Map y reglas de dependencia |
| Migrar a Database per Service (visión futura) | Implementación de @TransactionalEventListener(AFTER_COMMIT) en todos los BCs | Decisiones de diseño DD-001 a DD-005 documentadas |

Finalmente, con esta primera iteración se sientan las bases arquitectónicas de Glottia, estableciendo un marco sólido para las siguientes iteraciones que se enfocarán en la implementación de funcionalidades específicas, optimización de rendimiento y refinamiento de la experiencia de usuario.

\newpage