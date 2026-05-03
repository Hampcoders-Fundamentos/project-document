# Capítulo IV: Product Architecture Design

En este capítulo el equipo presentará el diseño de la arquitectura de la solución Glottia, detallando los conceptos y puntos de vista en diferentes entornos que definiran la construcción del sistema. El objetivo de este capítulo será ilustrar las decisiones arquitectónicas con respecto al alcande de la solución y los requerimientos funcionales y no funcionales para garantizar una solución robusta y escalable. 

## 4.1 Desing Concepts, ViewPoints & ER Diagrams

En la presente sección se desarrollaran puntos de vista, principios de diseño y diagramas que permitiran presentar la arquitectura de nuestra solución.

### 4.1.1 Principles Statements

Partiendo de nuestra visión de negocio y arquitectura, el equipo de Hampcoders definiran los principios que permitiran garantizar sostenibilidad a largo plazo para la solución Glottia.

| Principio | Descripción |
| --------- | ----------- |
| Arquitectura de Monolito Modular guiada por el Dominio | El sistema se estructurará internamente mediante Bounded Contexts (BC) estrictos. Cada BC es dueño absoluto de su modelo, lógica de negocio y datos.                                                                                            |
| Coordinación Asíncrona basada en Eventos               | Con el fin de evitar el acoplamienta directo y mejorar el rendimiento de la experiencia de usuario, la comunicación de flujos no críticos entre módulos se realizará mediante publicación y suscripción de eventos.                             |
| Consistencia Eventual sobre Consistencia Inmediata     | No se forzarán transacciones distribuidas entre diferentes Bounded Contexts. Cada módulo garantizará su consistencia interna inmediata, pero la sincronización de datos entre distintos BCs operará bajo el principio de consistencia eventual. |
| Aislamiento de Datos e Interfaces Explícitas           | Toda comunicación e intercambio de información entre módulos se realizará mediante interfaces explícitas y transferencia de objetos de datos bien definidos y versionados.                                                                      |
| Encapsulamiento Estricto de Integraciones Externas     | Todo servicio o dependencia externa deberá estar aislado detrás de su propio adaptador evitando que la logica de negocio dependa directamente de bibliotecas de terceros.                                                                       |
| Seguridad en Profundidad por Defecto                   | La solución aplicará una autenticación centralizada bajo el estandar OAuth2 manejando JWT y sesiones para la gestión de acceso y la protección de datos sensibles mediante cifrado y encriptación.                                              |

### 4.1.2 Approaches Statements Architectural Styles & Patterns

Estos son los estilos y patrones arquitectónicos que se ha seleccionado para guiar el diseño de la arquitectura de Glottia, asegurando que se alineen con los principios definidos y los drivers seleccionados para esta iteración. Cada enfoque se ha elegido por su capacidad para abordar aspectos clave como la modularidad, escalabilidad, mantenibilidad y seguridad del sistema.

| Enfoque | Descripción | Aplicación dentro de Glottia |
| ------- | ----------- | ---------------------------- |
| Domain Driven Design (DDD) | Definir sub dominios con delimitaciones y alcances claros como bounded contexts. |                              |
| Arquitectura de Microservicios | Desglozar el sistema en servicios independientes y escalables. |                              |
| Organización N Capas | Dividir responsabilidades en 3 capas: presentación, logica de negoci y acceso a datos |                              |
| Documentación OpenAPI | Documentar las APIs siguiendo el estandar OpenAPI |                              |
| Seguridad y Protección de información sencible | Gestión de acceso y autorización centralizada para garantizar el correcto tratamiento y protección de información sencible. |                              |

### 4.1.3 Context Diagram

Aquí se presenta el diagrama de contexto de Glottia, que ilustra los principales actores, sistemas externos y los límites del sistema. Este diagrama ayuda a visualizar cómo Glottia interactúa con su entorno y define claramente las interfaces entre el sistema y sus usuarios o servicios externos. El software principal se conectará con servicios externos de Gemini AI y Stripe para generación de contenido y procesamiento de pagos, respectivamente.

![Diagrama de Contexto para Glottia](assets/img/cap4/context.png)

### 4.1.4 Approach driven ViewPoints Diagrams
### 4.1.5 Relational/Non Relational Database Diagram

### 4.1.6 Design Patterns

En esta sección, el equipo de Hampcoders describe los principales patrones de diseño utilizados en el sistema. Estos patrones permiten mejorar la calidad de código desacoplando y modularizando.

#### 4.1.6.1 Patrones de Creación

Aqui se definiran los patrones de creación, aquellos que se enfocan en la forma de instanciar los objetos dentro de sistema. Su objetivo es encapsular la lógica de construcción.

##### Factory Method
- Cuándo: Se necesita crear entidades de dominio controlando las invariantes.
- Beneficio: Encapsular la lógica de creación y evita estados inválidos.
- Aplicación: Métodos estaticos como User.create(...) para construir agregados de forma segura.


#### 4.1.6.2 Patrones de Comportamiento

Los patrones de comportamiento definen el cómo interactuán los objetos y cómo se distribuyen las responsabilidades dentro del sistema.

##### Command
- Cuándo: Se necesita representar acciones del sistema.
- Beneficio: Desacoplar la invocación de la lógica de ejecución.
- Aplicación: Clases o Records como SignUpCommand, SignInCommand.

##### Strategy
- Cuándo: Se neceseitan múltiples algoritmas intercambiables.
- Beneficio: Cambiar implementación sin afectar lógica de negocio
- Aplicación: Clases que representan servicios como HashingService, TokenService



##### Observer
- Cuándo: Se necesita desacoplada entre componentes.
- Beneficio: Permitir reaccionar a eventos sin dependencias directas.
- Aplicación: Eventos con @EventListener.


#### 4.1.6.3 Patrones de Estructura

Los patrones estructurales se centran en la organización de objetos, facilitando la composición de componentes complejos.

##### Facade
- Cuándo: Se necesita simplificar el acceso a subsistemas complejos.
- Beneficio: Reducir acoplamiento entre bounded contexts.
- Aplicación: Clases como IamContextFacade.

#### 4.1.6.4 Patrones Empresariales

Los patrones empresariales están orientados a resolver problemas comunes en aplicaciones empresariales, específicamente en el manejo de lógica, persistencia y comunicación entre capas.

##### Service Layer
- Cuándo: Se necesita centralizar lógica de aplicación.
- Beneficio: Separar dominio de infraestructura.
- Aplicación: Clases como UserCommandService.

##### Repository Pattern
- Cuándo: Se necesita acceso a persistencia
- Beneficio: Desacoplar base de datos del dominio.
- Aplicación: Clases como UserRepository.

##### Data Transfer Object (DTO)
- Cuándo: Se necesita transferencia de datos entre capas.
- Beneficio: Evitar exponer el dominio directamente.
- Aplicación: Clases como UserResource, SignInResource.

##### Mapper / Assembler
- Cuándo: Se necesita transformar entre DTO y entidades.
- Beneficio: Mantener separación entre capas.
- Aplicación: Clases como UserResourceFromEntityAssembler.

##### Unit of Work
- Cuándo: Se necesita manejar de transacciones.
- Beneficio: Garantizar consistencia de datos.
- Aplicación: Clases gestionadas por JPA/Hibernate.

##### Gateway
- Cuándo: Se necesita integración con otros contextos o servicios.
- Beneficio: Encapsular dependencias externas.
- Aplicación: Clases ProfilesContextFacade.

#### 4.1.6.5 Patrones Arquitectonicos

Los patrones arquitectónicos definen la estructura desde un punto de vista de alto nivel del sistema, permitiendo organizar los components en capas o con responsabilidades definidas.vv

##### CQRS
- Cuándo: Se necesita separar lectura y escritura.
- Beneficio: Mejorar claridad y escalabilidad.
- Aplicación: Clases CommandService vs QueryService.

##### Layered Architecture
- Cuándo: Se necesita organizar el sistema por capas.
- Beneficio: Separar responsabilidades.
- Aplicación: Domain, Application, Infrastructure, Interfaces.

##### MVC
- Cuándo: Se necesita estructurar la capa de presentación.
- Beneficio: Separar entre vista, lógica y datos.
- Aplicación: Controllers + Resources.


### 4.1.7 Tactics

Las tácticas arquitectónicas de Glottia han sido definidas considerando su enfoque basado en Domain-Driven Design (DDD), arquitectura de monolito modular y comunicación asíncrona por eventos. Estas tácticas buscan reforzar los principales atributos de calidad del sistema: disponibilidad, modificabilidad, rendimiento, seguridad, usabilidad y escalabilidad, garantizando una experiencia fluida tanto para usuarios como para establecimientos aliados.

| Táctica | Objetivo de Calidad | Aplicación en Glottia |
|--------|---------------------|------------------------|
| **Confiabilidad** | Garantizar confianza en la organización de encuentros y la información mostrada | Validación de eventos y sesiones conversacionales antes de su publicación. Confirmación de asistencia de usuarios y verificación de disponibilidad de locales aliados para evitar inconsistencias. Manejo de errores controlado entre Bounded Contexts mediante eventos de compensación. |
| **Disponibilidad** | Asegurar que la plataforma esté operativa en todo momento | Despliegue en infraestructura cloud con alta disponibilidad. Separación de módulos críticos (gestión de sesiones, autenticación) dentro del monolito modular. Uso de comunicación asíncrona para evitar bloqueos en funcionalidades no críticas como notificaciones o recomendaciones. |
| **Modificabilidad** | Facilitar la evolución del sistema y adaptación a nuevos requerimientos | Uso de Bounded Contexts bien definidos (Usuarios, Sesiones, Locales, Matching, Notificaciones). Cada módulo encapsula su lógica y datos, permitiendo cambios independientes. Interfaces explícitas y contratos versionados para evitar impacto en otros módulos. |
| **Performance** | Optimizar tiempos de respuesta en búsquedas y match de usuarios | Implementación de mecanismos de caché para consultas frecuentes (búsqueda de eventos, locales disponibles). Procesamiento asíncrono para recomendaciones de matches entre usuarios según idioma, nivel y preferencias. Optimización de consultas en base de datos para geolocalización y disponibilidad de espacios. |
| **Seguridad** | Proteger datos personales y accesos a la plataforma | Implementación de autenticación centralizada con OAuth2 y JWT. Cifrado de datos sensibles (credenciales, información personal). Control de acceso basado en roles (usuarios, administradores, locales aliados). Validación de permisos en cada módulo del sistema. |
| **Usabilidad** | Garantizar una experiencia intuitiva y atractiva | Interfaces simples para reservar y unirse a sesiones conversacionales. Flujo claro de descubrimiento de eventos (explorar → seleccionar → unirse). Notificaciones en tiempo real sobre cambios en eventos o confirmaciones. Feedback visual inmediato en acciones del usuario. |
| **Escalabilidad** | Permitir el crecimiento del sistema sin afectar su rendimiento | Diseño basado en eventos que permite escalar módulos específicos (por ejemplo, notificaciones o matching). Posibilidad futura de migrar Bounded Contexts a microservicios sin rediseñar toda la arquitectura. Uso de bases de datos optimizadas para lectura y escritura según el contexto. |



## 4.2 Architectural Drivers

Los drivers arquitectónicos constituyen los factores determinantes que orientan las decisiones de diseño y construcción de la arquitectura de Glottia. Estos elementos definen tanto las prioridades estratégicas como las restricciones técnicas y operacionales que el equipo de desarrollo debe incorporar para garantizar el cumplimiento de los objetivos de negocio, sin comprometer los atributos de calidad esenciales: escalabilidad, mantenibilidad, confiabilidad y rendimiento.

En este contexto, los drivers arquitectónicos se articulan en torno a cuatro dimensiones fundamentales: el propósito del diseño y los objetivos comerciales; las funcionalidades prioritarias derivadas de los requerimientos funcionales; los escenarios de atributos de calidad que definen comportamientos esperados bajo condiciones específicas; y las restricciones y concernimientos arquitectónicos que limitan el espacio de soluciones viables. La integración coherente de estos elementos permitirá construir una arquitectura sostenible que evolucione conforme las necesidades del negocio y del mercado lo requieran.

### 4.2.1 Design Purpose

El propósito del diseño arquitectónico de Glottia es construir una estructura modular, escalable y segura basada en Bounded Contexts que conecte de manera confiable a aprendices de idiomas con establecimientos aliados, garantizando consistencia operacional, rendimiento óptimo en operaciones críticas y la capacidad de evolucionar hacia microservicios conforme las necesidades del negocio y mercado lo requieran.

### 4.2.2 Primary Functionality (Primary User Stories)

Se identifican aquí los requisitos funcionales de alta prioridad que impactan directamente en las decisiones de diseño de la arquitectura. A través de estas historias de usuario clave, se establecen los módulos base y las relaciones de datos de Glottia, asegurando que la estructura soporte tanto la lógica operativa como los atributos de calidad esperados.

|ID|Título|Descripción|Impacto estructural|
|--|------|---------------|--------------|
|US001–US003| Registro, autenticación y gestión de sesión de usuario| Permite al Learner y al Partner registrarse con email/contraseña, iniciar sesión y obtener tokens JWT para acceder al sistema.| BC IAM genera `UserRegistered` -> dispara creación de perfil en Profiles. Punto de entrada de toda la arquitectura; todos los BCs consumen el JWT para autorización. | 
|US004–US007| Creación y configuración del perfil de aprendiz | El Learner completa su perfil indicando idioma nativo, idiomas meta, nivel CEFR y disponibilidad horaria. El perfil es prerequisito para reservar encuentros. | BC Profiles publica `ProfileCompleted` -> Encounters lo consume para habilitar la funcionalidad de reserva. Relación directa con los BCs Engagement (nivel CEFR para leaderboard) y Analytics (segmentación de KPIs)|
|US008–US011|Registro de local aliado y publicación de venues|El Partner da de alta su establecimiento (cafetería, bar, coworking), registra mesas y configura la disponibilidad horaria de los espacios.|BC Venues publica `VenueActivated` -> consumido por Encounters (para asociar encuentros a locales) y Promotions (para validar la existencia del venue al crear links promocionales).|
|US012–US016|Creación, búsqueda y reserva de encuentros presenciales|El Learner busca encuentros por idioma, fecha y ubicación; reserva un cupo disponible y recibe confirmación. Incluye gestión de cupo lleno con estado de espera.|BC Encounters es el Core operativo central; consume `ProfileCompleted` y `VenueActivated`. Su evento `UserCheckedIn` dispara puntos en Engagement y métricas en Analytics.|

### 4.2.3 Quality Attribute Scenarios

Los atributos de calidad definen el comportamiento esperado del sistema Glottia bajo condiciones operacionales reales. Los escenarios siguientes describen estímulos concretos, los componentes afectados y las respuestas esperadas, con medidas cuantificables para validar la arquitectura basada en contextos de dominio (Usuarios, Sesiones, Locales, Matching, Notificaciones) e infraestructura (pasarela API, caché, bus de eventos).

#### QAS-01: Seguridad - Control de acceso basado en roles

| Atributo      | Fuente de Estímulo                     | Estímulo                                                                            | Entorno          | Artefacto                        | Respuesta                                                                                                      | Medida                                                                                             |
| ------------- | -------------------------------------- | ----------------------------------------------------------------------------------- | ---------------- | -------------------------------- | -------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| **Seguridad** | Usuario autenticado con rol incorrecto | Solicitud `POST /api/v1/encounters/{id}/join` con JWT válido pero rol no autorizado | Operación normal | API Gateway + IAM Service + RBAC | El sistema rechaza la solicitud con HTTP 403 antes de llegar al microservicio. Se registra el intento en logs. | 100% de accesos no autorizados rechazados. Tiempo de respuesta < 200 ms. Logs retenidos ≥ 90 días. |

#### QAS-02: Disponibilidad - Procesamiento de reservas ante fallo de servicios no críticos

| Atributo           | Fuente de Estímulo | Estímulo                                                                             | Entorno                   | Artefacto                                            | Respuesta                                                                                                 | Medida                                                                                          |
| ------------------ | ------------------ | ------------------------------------------------------------------------------------ | ------------------------- | ---------------------------------------------------- | --------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| **Disponibilidad** | Usuario aprendiz   | Solicitud `POST /api/v1/encounters/{id}/join` durante caída del Notification Service | Fallo parcial del sistema | Encounters Service + RabbitMQ + Notification Service | La reserva se procesa correctamente. La notificación se encola y se envía cuando el servicio se recupera. | Disponibilidad ≥ 99.5%. 0 pérdida de reservas. Mensajes persistidos en cola hasta recuperación. |

#### QAS-03: Mantenibilidad - Despliegue independiente de Bounded Contexts

| Atributo           | Fuente de Estímulo   | Estímulo                                                | Entorno           | Artefacto                                                  | Respuesta                                                                               | Medida                                                                |
| ------------------ | -------------------- | ------------------------------------------------------- | ----------------- | ---------------------------------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| **Mantenibilidad** | Equipo de desarrollo | Cambio en lógica de acumulación de puntos en Engagement | Desarrollo activo | Engagement Service + API versionada + Database per Service | El cambio se implementa sin afectar otros servicios. No requiere redeploy de otros BCs. | Cambio desplegado < 4h. 0 cambios en otros servicios. CI/CD < 10 min. |

#### QAS-04: Mantenibilidad - Extensibilidad del sistema de recompensas

| Atributo           | Fuente de Estímulo   | Estímulo                                                                 | Entorno           | Artefacto                                                             | Respuesta                                                                                                                                      | Medida                                                                                                         |
| ------------------ | -------------------- | ------------------------------------------------------------------------ | ----------------- | --------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| **Mantenibilidad** | Equipo de desarrollo | Incorporación de un nuevo tipo de recompensa en el sistema de Engagement | Desarrollo activo | Engagement Service + arquitectura modular + contratos API versionados | El nuevo tipo de recompensa se implementa extendiendo la lógica existente sin modificar otros servicios. No afecta a Encounters ni Promotions. | Implementación < 6 horas. 0 cambios en otros microservicios. Cobertura de tests ≥ 80% en el módulo modificado. |

### 4.2.4 Constraints 

En arquitectura de software, las  **constraints (restricciones)**  son básicamente  **límites o condiciones que el sistema debe respetar sí o sí**  al momento de diseñar y construir una aplicación.

En Glottia hemos definido restricciones por categoría para adaptarnos a ellas y poder manejar una arquitectura escalable y sostenible.

|Categoría|Detalles de restricción|
|-----------|---------------------|
|**Plataforma y Entorno**| Despliegue obligatorio en  **Android (mínimo API 24)**  e  **iOS (mínimo v15)**  mediante base de código única en  **Flutter/Kotlin Multiplatform**.|
|**Infraestructura Cloud**|Uso de  **Firebase**  como BaaS (Backend as a Service) para autenticación y base de datos en tiempo real.|
|**Persistencia de Datos**|La base de datos local debe implementarse con  **Room (Android)**  o  **SQLite**  para soporte offline.|
|**Cumplimiento Legal**|Obligatoriedad de cumplir con la  **Ley N.º 29733**  (Ley de Protección de Datos Personales en Perú), especialmente en el cifrado de correos y nombres de usuarios.|
|**Integraciones Externas**|Las llamadas a APIs de terceros (ej. Google Translate API o DeepL) deben estar limitadas por cuotas de consumo para evitar sobrecostos.|
|**Metodología de Trabajo**|El desarrollo debe seguir un flujo de  **GitFlow**  y documentación de arquitectura basada en el modelo **C4**.|

### 4.2.5 Architectural Concerns 

Estas son las metas de alto nivel que nuestra arquitectura debe "solucionar" para que el proyecto sea exitoso.

#### 1. Desacoplamiento de Lógica de Negocio (DDD)

Dado que Glottia busca ser una solución escalable, una preocupación principal es evitar que la lógica del lenguaje o servicios se mezcle con el código de la interfaz (UI).

- **Solución:** Implementar una arquitectura de capas (Dominio, Aplicación, Infraestructura).
    

#### 2. Sincronización y Estado Offline

Siendo una aplicación móvil, la conectividad intermitente es un riesgo crítico.

- **Preocupación:** ¿Cómo garantizamos que el progreso del usuario no se pierda sin conexión?
    
- **Meta:** Estrategia de  _Offline-first_  con sincronización en segundo plano cuando se recupere el aliento de red.
    

#### 3. Rendimiento y Latencia de Interfaz

En una app de aprendizaje o servicios, la percepción de fluidez es vital.

- **Preocupación:** El procesamiento de datos pesados no debe bloquear el hilo principal (UI Thread).
    
- **Meta:** Uso intensivo de programación asíncrona y manejo eficiente de memoria en el dispositivo móvil.
    

#### 4. Seguridad en el Transporte de Datos

Protección de la integridad de los datos entre el dispositivo y Firebase.

- **Preocupación:** Evitar ataques de Man-in-the-Middle y asegurar que solo usuarios autenticados accedan a sus propios recursos.
    
- **Meta:** Implementación de  **Firebase Security Rules**  y comunicación exclusiva vía HTTPS con TLS 1.3.
    

#### 5. Extensibilidad del Sistema

Glottia debe permitir añadir nuevos idiomas o tipos de servicios sin reescribir el núcleo.

- **Preocupación:** El "Gran Lodo" (Big Ball of Mud) donde todo depende de todo.
    
- **Meta:** Definición clara de  **Bounded Contexts**  para que el módulo de "Usuarios" sea independiente del módulo de "Contenido Académico/Servicios".

## 4.3 ADD Iterations

En esta sección se describen las iteraciones de diseño arquitectónico que el equipo llevará a cabo para construir la solución Glottia, partiendo desde un monolito modular hasta una arquitectura de microservicios alineada a los Bounded Contexts definidos. Cada iteración se enfocará en aspectos específicos de la arquitectura, abordando los drivers seleccionados y refinando elementos clave del sistema.

### 4.3.1 Iteration 1: Definición del Core Arquitectónico de Glottia

Primera iteración enfocada en establecer las bases arquitectónicas de Glottia, definiendo los elementos clave que garantizarán la seguridad, disponibilidad y mantenibilidad del sistema. Se priorizarán los drivers relacionados con la protección de datos, la resiliencia ante fallos y la capacidad de evolución independiente por dominio funcional.

#### 4.3.1.1 Architectural Design Backlog 1

En este backlog se definiran las características arquitectónicas clave para garantizar el correcto funcionamiento de Glottia. Se priorizaran tres atributos de calidad: : Seguridad, para proteger los datos personales de los aprendices y establecimientos; Disponibilidad, para garantizar que las reservas y encuentros funcionen sin interrupciones; y Mantenibilidad, para permitir que el sistema evolucione de forma independiente por dominio funcional.

#### Seguridad

| User Stories | Tareas | Criterios de Aceptación |
|--------------|--------|------------------------:|
| US-01: Como aprendiz, quiero registrarme con mis datos personales para acceder a la plataforma. | Implementar autenticación centralizada con JWT y OAuth2. Configurar RBAC con roles ROLE_APRENDIZ y ROLE_ESTABLECIMIENTO. Cifrar datos sensibles en reposo. | Solo usuarios autenticados acceden a reservas y encuentros. Las contraseñas se almacenan con hashing BCrypt. El sistema bloquea accesos no autorizados a perfiles ajenos. |
| US-02: Como administrador de establecimiento, quiero que solo yo pueda gestionar mi local para proteger mi información. | Implementar validación de propiedad por rol en cada endpoint. Configurar API Gateway para validar tokens JWT antes de enrutar peticiones. | Un aprendiz no puede modificar datos de un establecimiento. El 100% de operaciones sensibles queda registrado en el log de auditoría. | 

#### Disponibilidad

| User Stories | Tareas | Criterios de Aceptación |
|--------------|--------|------------------------:|
| US-17: Como aprendiz, quiero reservar mi cupo en un encuentro para asegurar mi asistencia. | Implementar replicación del servicio de reservas en múltiples instancias. Aplicar Circuit Breaker en llamadas entre el servicio de reservas y el de notificaciones. Usar comunicación asíncrona para el envío de confirmaciones. | El sistema mantiene disponibilidad del 99.5% mensual. Si el servicio de notificaciones falla, la reserva igual se procesa. El sistema se recupera automáticamente ante caídas dentro de 2 horas. |


#### Mantenibilidad

| User Stories | Tareas | Criterios de Aceptación |
|--------------|--------|------------------------:|
| TS-: Como desarrollador de HampCoders, quiero modificar la lógica de reservas sin afectar el módulo de establecimientos para desplegar más rápido.  | Diseñar la arquitectura con Bounded Contexts independientes (IAM, Event, Reservas, Establecimientos, Notificaciones). Implementar Database per Service. Definir contratos OpenAPI versionados entre servicios. | Un cambio en la lógica de reservas se puede desplegar en menos de 4 horas sin afectar otros servicios. Cada microservicio tiene su propia base de datos sin acoplamiento compartido. |
| TS-: Como desarrollador, quiero que las dependencias a sistemas externos queden completamente aisladas. | Encapsular la dependencia de Claude/GPT-4 exclusivamente en el microservicio Learning Feedback. Ningún otro BC importa ni conoce la librería del LLM. | Si el LLM API falla, solo Learning Feedback se ve afectado. El resto del sistema opera con normalidad |

#### 4.3.1.2 Establish Iteration Goal by Selecting Drivers

En esta iteración el equipo de Hampcoders seleccionará los drivers de Seguridad, Disponibilidad y Mantenibilidad como base del diseño de Glottia.

##### Meta de Seguridad

- Objetivo: Garantizar que el flujo de reservas y encuentros funcione de forma continua, especialmente durante picos de uso.
- Acciones clave: Implementar replicación de servicios críticos. Aplicar el patrón Circuit Breaker entre servicios. Usar comunicación asíncrona para notificaciones con un Message Broker.

##### Meta de Mantenibilidad

- Objetivo: Convertir los 8 Bounded Contexts del monolito modular en 8 microservicios Java 21 + Spring Boot independientes, cada uno con su propio esquema PostgreSQL, repositorio Git y pipeline de despliegue.

- Acciones clave: Migrar cada paquete Maven a un proyecto Spring Boot independiente. Aplicar Database per Service con esquemas PostgreSQL exclusivos. Definir contratos OpenAPI por servicio. Aislar la dependencia LLM exclusivamente en Learning Feedback.

##### Meta de Disponibilidad
- Objetivo: Garantizar que la caída de un microservicio no crítico no afecte los flujos core de negocio.
- Acciones clave: Reemplazar Spring ApplicationEvents por RabbitMQ como Message Broker entre microservicios. Aplicar Circuit Breaker en las llamadas síncronas entre servicios. Establecer health checks por microservicio.

##### Objetivo de la Iteración

- Seguridad: Establecer la base de autenticación centralizada y protección de datos de usuarios aprendices y establecimientos bajo los estándares de la Ley N.° 29733 de Perú.
- Disponibilidad: Asegurar que el servicio de reservas sea resiliente ante fallos de componentes no críticos como las notificaciones.
- Mantenibilidad: Definir la descomposición en microservicios alineada a los Bounded Contexts del negocio de Glottia.

#### 4.3.1.3 Choose One or More Elements of the System to Refine

Aquí se presentan los elementos clave del sistema que se refinarán en esta iteración, junto con las razones para su selección y lo que se espera lograr con cada uno de ellos. Estos elementos son fundamentales para alcanzar los objetivos de seguridad, disponibilidad y mantenibilidad definidos previamente.

| Elemento a Refinar | Razón | Esperado |
|--------------------|-------|---------:|
| Monolito modular completo | Es el sistema de partida. Debe descomponerse en 8 microservicios independientes alineados a los BCs de DDD. | Autenticación centralizada con JWT, RBAC por rol y protección de endpoints sensibles. | 8 proyectos Spring Boot independientes: IAM, Profiles, Venues, Promotions, Encounters, Engagement, Learning Feedback, Analytics. |
| Comunicación entre Bounded Contexts | Los ApplicationEvents funcionan dentro del mismo proceso JVM. Al separar en microservicios distintos, se necesita un mecanismo de mensajería externo. | RabbitMQ como Message Broker. Cada microservicio publica y consume eventos mediante colas. |
| API Gateway | Al tener múltiples servicios expuestos, se necesita un punto único de entrada que centralice autenticación, enrutamiento y rate limiting. | Spring Cloud Gateway como API Gateway. Valida JWT y enruta hacia el microservicio correspondiente. | 
| Dependencia LLM | En el monolito, esta dependencia podría haberse filtrado a otros módulos. En microservicios debe quedar encapsulada. | Learning Feedback es el único servicio que importa la librería del LLM. Ningún otro BC la conoce. |

#### 4.3.1.4 Choose One or More Design Concepts That Satisfy the Selected Drivers

Se eligen los siguientes conceptos de diseño para abordar los drivers seleccionados en esta iteración, garantizando que la arquitectura de Glottia sea segura, disponible y mantenible:

##### Seguridad

- Autenticación y Autorización Centralizada (OAuth2 + JWT + RBAC)
    - Descripción: El microservicio IAM gestiona registro, login y emisión de tokens JWT con roles USER, PARTNER y ADMIN. Los demás servicios confían en el token ya validado por el Gateway.
    - Justificación: Centraliza la fuente de verdad de autenticación y autorización. Cumple con los estándares OAuth2 y con la Ley N.° 29733 de Perú.

- API Gateway como punto único de entrada
    - Descripción: Todo el tráfico externo pasa por el API Gateway, que valida los tokens JWT antes de enrutar las peticiones a los microservicios internos.
    - Justificación: Proporciona una capa de seguridad centralizada y simplifica la gestión de autenticación y rate limiting.

##### Disponibilidad

- Comunicación Asíncrona con Message Broker
    - Descripción: Reemplaza los Spring ApplicationEvents del monolito por RabbitMQ. Los microservicios publican eventos en colas, y los consumidores (ej. Engagement, Analytics) los procesan de forma independiente.
    - Justificación: Desacopla los microservicios productores de los consumidores. Si Analytics cae, Encounters sigue funcionando; los eventos se acumulan en la cola hasta que Analytics se recupere.

- Patrón Circuit Breaker
    - Descripción: Aplicar Circuit Breaker en la única llamada síncrona entre servicios.
    - Justificación: Si Promotions está lento o caído, el Circuit Breaker evita que Engagement quede bloqueado esperando respuesta, degradando el servicio de forma controlada.

##### Mantenibilidad
- Arquitectura de Microservicios alineada a Bounded Contexts DDD
    - Descripción: Cada uno de los 8 Bounded Contexts de Glottia se convierte en un microservicio Spring Boot independiente, con su propio repositorio Git, pipeline CI/CD y esquema PostgreSQL.
    - Justificación: Permite que equipos distintos desarrollen, prueben y desplieguen su BC sin afectar a los demás. Un cambio en Engagement no requiere redesplegar Encounters ni IAM.

- Database per Service
    - Descripción: Cada microservicio es dueño exclusivo de su esquema PostgreSQL. Ningún servicio accede directamente a la base de datos de otro.
    - Justificación: Garantiza bajo acoplamiento a nivel de datos. El esquema de Promotions puede evolucionar sin afectar a Engagement ni a Venues.

- Patrón Adapter para dependencias externas
    - Descripción: La dependencia del LLM API en Learning Feedback se encapsula detrás de una interfaz interna, de modo que si cambia el proveedor, solo se reemplaza el adaptador, sin tocar la lógica de negocio.
    - Justificación: Aisla el único punto de variabilidad técnica alta del sistema. Ningún otro microservicio importa ni conoce el LLM.

#### 4.3.1.5 Instantiate Architectural Elements, Allocate Responsibilities, and Define Interfaces

Se definen los elementos arquitectónicos clave de Glottia, asignando responsabilidades específicas a cada uno y detallando las interfaces que expondrán para interactuar con otros componentes del sistema. Esta definición es fundamental para garantizar que cada microservicio cumpla con su rol dentro de la arquitectura general, facilitando la comunicación entre ellos y asegurando que se respeten los principios de diseño establecidos.

| **Elemento**                           | **Responsabilidad**                                                                        | **Interfaces**                                                                                                                                                                                                  |
| -------------------------------------- | ------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **API Gateway** | Punto único de entrada. Valida JWT, enruta peticiones, aplica rate limiting.               | Expone `/api/v1/*` hacia clientes Flutter y Kotlin. Enruta internamente a cada microservicio.                                                                                                                   |
| **IAM Service**                        | Registro, login, emisión y renovación de JWT. Gestión de roles USER/PARTNER/ADMIN.         | `POST /auth/register`<br>`POST /auth/login`<br>`POST /auth/refresh`<br>Publica evento `UserRegistered`.                                                                                                         |
| **Profiles Service**                   | Perfil de usuario, idiomas, nivel CEFR y disponibilidad.                                   | `GET /profiles`<br>`POST /profiles`<br>`PUT /profiles`<br>Consume `UserRegistered`. Publica `ProfileCompleted`.                                                                                                 |
| **Venues Service**                     | Alta de partners, gestión de venues, mesas y disponibilidad horaria.                       | `GET /venues`<br>`POST /venues`<br>`PUT /venues`<br>`/partners`<br>Publica `VenueActivated`, `VenueCreated`.                                                                                                    |
| **Promotions Service**                 | Catálogo de promociones, vigencia, stock y canje.                                          | `GET /promotions`<br>`POST /promotions`<br>`POST /promotions/{id}/redeem`<br>Consume `VenueActivated`. Publica `PromotionRedeemed`.                                                                             |
| **Encounters Service**                 | Búsqueda de encuentros, reserva de cupos, check-in QR y gestión de estados.                | `GET /encounters/search`<br>`POST /encounters/{id}/join`<br>`POST /encounters/{id}/check-in`<br>Publica `UserCheckedIn`, `EncounterCompleted`.                                                                  |
| **Engagement Service**                 | Acumulación de puntos, badges, leaderboard y canje de puntos.                              | `GET /engagement/rewards/catalog`<br>`POST /engagement/rewards/redeem`<br>Consume `UserCheckedIn`, `AssessmentCompleted`, `QuizPassed`, `FeedbackSubmitted`.<br>Llama síncronamente a Promotions para el canje. |
| **Learning Feedback Service**          | Self-assessment, peer feedback, quiz LLM y FluencyScore. Único con dependencia al LLM API. | `POST /feedback/self-assessment`<br>`POST /feedback/peer`<br>`POST /feedback/quiz/{id}/answer`<br>Consume `EncounterCompleted`.<br>Publica `AssessmentCompleted`, `QuizPassed`, `FeedbackSubmitted`.            |
| **Analytics Service**                  | KPIs y métricas para partners y admin. Consumidor puro de eventos.                         | `GET /analytics/monthly`<br>Consume todos los eventos del sistema. No publica eventos.                                                                                                                          |
| **RabbitMQ**                           | Message Broker central para comunicación asíncrona entre todos los microservicios.         | Queues/Topics por evento: `encounter.completed`, `user.checked-in`, `assessment.completed`, etc.                                                                                                                |
| **PostgreSQL**          | Cada microservicio tiene su propio esquema exclusivo.                                      | Repositorios internos de cada servicio. Sin acceso cruzado entre esquemas.                                                                                                                                      |

#### 4.3.1.6 Sketch Views (C4 & UML) and Record Design Decisions

Las decisiones de diseño arquitectónico tomadas durante esta iteración se documentan a continuación, detallando el ID de la decisión, la descripción, el estado actual y la justificación que respalda cada elección. Estas decisiones reflejan las elecciones estratégicas realizadas para cumplir con los objetivos de seguridad, disponibilidad y mantenibilidad definidos para Glottia.

| ID | Decisión | Estado | Justificación |
| -------- | --------- | ---------- | ---------- |
| DD-001 | Migración de monolito modular a microservicios por BC | Aceptada | Permite despliegues independientes por Bounded Context y escala según dominio. |
| DD-002 | Autenticación centralizada con JWT + RBAC | Aceptada | Centraliza la seguridad y cumple con Ley N.° 29733. |
| DD-003 | Comunicación asíncrona con RabbitMQ para notificaciones | Aceptada | Desacopla el flujo crítico (reserva) del no crítico (notificación), mejorando disponibilidad. |
| DD-004 | Database per Service con PostgreSQL | Aceptada | Garantiza bajo acoplamiento entre servicios y permite evolución independiente del esquema. |
| DD-005 | API Gateway como punto único de entrada | Aceptada | Centraliza seguridad, enrutamiento y políticas transversales como rate limiting. |

#### 4.3.1.7 Analysis of Current Design and Review Iteration Goal (Kanban Board)

Tras completar la primera iteración, la arquitectura base de Glottia establece los cimientos necesarios para soportar los dos segmentos de usuarios.

- Fortalezas del diseño:
    - La separación por Bounded Contexts garantiza que el equipo pueda trabajar en paralelo sobre IAM, Encounters y Learning Feedback sin interferencias. 
    - El aislamiento del LLM en un único servicio protege al resto del sistema ante latencias o fallos del proveedor externo. 
    - La comunicación asíncrona con RabbitMQ garantiza que Analytics y Engagement puedan procesar eventos aunque exista lag temporal.

- Áreas de mejora identificadas: 
    - La consistencia eventual entre BCs requiere que el equipo diseñe con cuidado las sagas de datos, especialmente en el flujo de canje

 - Kanban Board:

| **To Do** | **In Progress** | **Done** |
| ------------ | ---------- | -------- |
| Configurar RabbitMQ con queues por evento | Implementación de IAM Service con Spring Security 6 + JWT | Definición de los 8 BCs como microservicios independientes                         |
| Implementar Circuit Breaker en Engagement - Promotions | Configuración de Spring Cloud Gateway | Definición del Context Map y reglas de dependencia |
| Diseñar contratos OpenAPI por microservicio | Migración de esquemas PostgreSQL a Database per Service | Decisiones de diseño DD-001 a DD-005 documentadas |

Finalmente, con esta primera iteración se sientan las bases arquitectónicas de Glottia, estableciendo un marco sólido para las siguientes iteraciones que se enfocarán en la implementación de funcionalidades específicas, optimización de rendimiento y refinamiento de la experiencia de usuario.