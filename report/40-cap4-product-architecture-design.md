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

| Enfoque | Descripción | Aplicación dentro de Glottia |
| ------- | ----------- | ---------------------------- |
| Domain Driven Design (DDD) | Definir sub dominios con delimitaciones y alcances claros como bounded contexts. |                              |
| Arquitectura de Microservicios | Desglozar el sistema en servicios independientes y escalables. |                              |
| Organización N Capas | Dividir responsabilidades en 3 capas: presentación, logica de negoci y acceso a datos |                              |
| Documentación OpenAPI | Documentar las APIs siguiendo el estandar OpenAPI |                              |
| Seguridad y Protección de información sencible | Gestión de acceso y autorización centralizada para garantizar el correcto tratamiento y protección de información sencible. |                              |

### 4.1.3 Context Diagram

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

## 4.1.7 Tactics

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
### 4.2.3 Quality Attribute Scenarios

Los atributos de calidad definen el comportamiento esperado del sistema Glottia bajo condiciones operacionales reales. Los escenarios siguientes describen estímulos concretos, los componentes afectados y las respuestas esperadas, con medidas cuantificables para validar la arquitectura basada en contextos de dominio (Usuarios, Sesiones, Locales, Matching, Notificaciones) e infraestructura (pasarela API, caché, bus de eventos).

| Atributo | Fuente de Estímulo | Estímulo | Entorno | Componentes / Artefactos | Respuesta esperada | Medida |
|----------|--------------------|---------:|---------|-------------------------|-------------------|--------|
| **Disponibilidad** | Aprendices y propietarios | Operaciones concurrentes (búsqueda, reserva, registro de asistencia) | Horas punta con alta concurrencia | Pasarela API (API Gateway), contexto de Sesiones, réplicas de base de datos, bus de eventos, caché distribuida | El servicio permanece disponible; las funcionalidades no críticas pueden degradarse; conmutación por error automática | Disponibilidad ≥ 99,5% anual; conmutación por error < 30 s |
| **Confiabilidad** | Sistema de reservas / local | Conflictos de reserva simultáneos o cancelaciones masivas | Procesamiento en tiempo real de sesiones y reservas | Contextos de Sesiones y Locales con mensajería asíncrona (bus de eventos) y manejo de compensaciones | No debe ocurrir corrupción de datos; inconsistencias resueltas por procesos automáticos de reconciliación | 0 pérdida de reservas críticas; reconciliación automática < 60 s |
| **Rendimiento** | Usuario final (aprendiz/propietario) | Búsqueda con filtros, geolocalización y emparejado de usuarios con alta concurrencia | Pico de consultas (95% solicitudes objetivo) | Contexto de Matching, caché distribuida (ej. Redis), índices geoespaciales | Resultados entregados rápidamente y ordenados por relevancia; operaciones de emparejado procesadas eficientemente | 95% de búsquedas ≤ 1,5 s; 95% de emparejados ≤ 0,8 s; degradación controlada para el resto |
| **Seguridad** | Pasarela API / servicio de identidad | Validación de tokens JWT y control de acceso por roles | Durante autenticación y acceso a funciones sensibles | Pasarela API, servicio de Identidad y Acceso, sistema de auditoría, cifrado en tránsito y en reposo | Solo identidades válidas acceden a recursos; se registra trazabilidad de accesos y acciones administrativas | 100% validación de tokens; registros de auditoría retenidos 90 días; TLS en tránsito y cifrado en reposo |
| **Escalabilidad** | Equipo de operaciones | Incremento temporal del 200% de usuarios concurrentes por campaña | Período de crecimiento acelerado o promoción | Orquestador de contenedores (Kubernetes), autoescalado, bus de eventos, diseño desacoplado por contexto | Escalado horizontal de componentes críticos; degradación controlada de servicios no esenciales | Escalado horizontal < 3 min; soportar hasta 10× la carga base sin pérdida de funciones críticas |
| **Modificabilidad (operacional)** | Host de reunión (usuario) | Cancelación o modificación de reunión desde la app móvil hasta 24 h antes | Uso normal de la aplicación móvil | Contexto de Sesiones con reglas de ventana temporal, notificaciones y lógica de compensación | La modificación se procesa, se notifica a inscritos, se libera capacidad en el local y se calculan reembolsos si aplica | Procesamiento < 2 s; notificaciones < 5 s; estado consistente visible en < 5 s |
| **Modificabilidad (evolutivo)** | Equipo de desarrollo | Despliegue de nueva versión o cambio en algoritmo de emparejado | Producción durante ciclo de entrega | Contextos desacoplados, pipeline de integración y entrega continua (CI/CD), flags de funcionalidad | Despliegue con impacto acotado y posibilidad de reversión; compatibilidad hacia atrás mantenida | Despliegue canario < 15 min; rollback automático si falla |
| **Usabilidad** | Aprendiz / propietario | Flujo de reserva, confirmación y notificaciones en móviles y web | Uso típico en dispositivos móviles y navegadores | Interfaz de usuario, API de aplicación y sistema de notificaciones en tiempo real | Retroalimentación inmediata en las interacciones; notificaciones claras y sincronizadas entre participantes | Retroalimentación < 0,5 s; tasa de error de usuario < 2%; tareas clave ≤ 3 pasos |

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
### 4.2.X Iteration N: <Iteration Name>
#### 4.2.X.1 Architectural Design Backlog N
#### 4.2.X.2 Establish Iteration Goal by Selecting Drivers
#### 4.2.X.3 Choose One or More Elements of the System to Refine
#### 4.2.X.4 Choose One or More Design Concepts That Satisfy the Selected Drivers
#### 4.2.X.5 Instantiate Architectural Elements, Allocate Responsibilities, and Define Interfaces
#### 4.2.X.6 Sketch Views (C4 & UML) and Record Design Decisions 
#### 4.2.X.7 Analysis of Current Design and Review Iteration Goal (Kanban Board)