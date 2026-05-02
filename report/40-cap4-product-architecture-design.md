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
### 4.1.4 Approach driven ViewPoints Diagrams
### 4.1.5 Relational/Non Relational Database Diagram
### 4.1.6 Design Patterns 
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

Los atributos de calidad definen el comportamiento esperado del sistema Glottia bajo condiciones operacionales reales. Estos escenarios validan cómo los Bounded Contexts (Usuarios, Sesiones, Locales, Matching, Notificaciones) y la infraestructura subyacente soportan los objetivos de confiabilidad, rendimiento, seguridad y escalabilidad en entornos de carga típicos del negocio.

| Atributo | Fuente de Estímulo | Estímulo | Entorno | Artefacto | Respuesta | Medida |
|----------|-------------------|----------|---------|-----------|-----------|--------|
| **Disponibilidad** | Aprendices y propietarios de locales | Acceso simultáneo a búsqueda de encuentros, gestión de reservas y validación de asistencia | Sistema en horas pico con concurrencia alta | Bounded Contexts de Sesiones, Locales y Matching | La plataforma permanece operativa con balanceo de carga y tolerancia a fallos en módulos no críticos | 99.5% uptime anual |
| **Confiabilidad** | Sistema de reservas | Confirmación de asistencia y sincronización de estado entre Bounded Contexts de Sesiones y Locales | Procesamiento de encuentros simultáneos | Bounded Contexts de Sesiones y Locales con comunicación asíncrona | No hay inconsistencias entre estado de reservas y disponibilidad de espacios; eventos de compensación resuelven conflictos | 100% consistencia en transacciones críticas |
| **Rendimiento** | Usuario final (aprendiz o propietario) | Búsqueda de encuentros filtrados, geolocalización y matching de usuarios | Consultas concurrentes en horario de pico | Bounded Context de Matching y búsqueda con caché distribuido | Sistema responde con resultados relevantes y optimizados | Latencia < 1500ms en búsquedas; < 800ms en matching |
| **Seguridad** | Sistema de autenticación centralizado | Validación de tokens JWT y control de acceso basado en roles | Durante autenticación de usuarios y acceso a funcionalidades específicas | API Gateway y Bounded Context de Identidad y Acceso | Solo usuarios verificados acceden a sus datos y funcionalidades; tokens expirados son rechazados | 100% cumplimiento de autenticación; cifrado de credenciales en tránsito y en reposo |
| **Escalabilidad** | Administrador o equipo de operaciones | Incremento del 200% en usuarios concurrentes o establecimientos aliados | Período de crecimiento acelerado o campaña de marketing | Monolito modular con capacidad para escalar módulos específicos | Se agregan instancias de Bounded Contexts críticos sin rediseño arquitectónico; la migración a microservicios es viable | Escalamiento horizontal < 5 minutos; capacidad para 10x usuarios actuales |
| **Modificabilidad** | Host de reunión (usuario aprendiz) | Cancela o modifica una reunión hosteada hasta 24 horas antes de la hora acordada desde la app móvil | Aplicación móvil en horario de operación normal | Bounded Context de Sesiones con lógica de ventanas temporales y notificaciones | La aplicación procesa la solicitud, actualiza el estado de la sesión, notifica a todos los participantes inscritos, libera el espacio en el local aliado y procesa compensaciones (reembolsos si aplica) | Procesamiento de cancelación < 2s; notificaciones a participantes enviadas < 5s; impacto cero en otros módulos |
| **Usabilidad** | Aprendiz o propietario | Interacción con flujo de reserva, confirmación de asistencia o gestión de promociones | Uso normal de la aplicación en dispositivos móviles | Interfaz de usuario y API de aplicación | Feedback visual inmediato (< 500ms) en cada acción; notificaciones en tiempo real sobre cambios en encuentros | Tasa de error de usuario < 2%; tiempo de tareas críticas < 3 pasos |

### 4.2.4 Constraints
### 4.2.5 Architectural Concerns

## 4.3 ADD Iterations
### 4.2.X Iteration N: <Iteration Name>
#### 4.2.X.1 Architectural Design Backlog N
#### 4.2.X.2 Establish Iteration Goal by Selecting Drivers
#### 4.2.X.3 Choose One or More Elements of the System to Refine
#### 4.2.X.4 Choose One or More Design Concepts That Satisfy the Selected Drivers
#### 4.2.X.5 Instantiate Architectural Elements, Allocate Responsibilities, and Define Interfaces
#### 4.2.X.6 Sketch Views (C4 & UML) and Record Design Decisions 
#### 4.2.X.7 Analysis of Current Design and Review Iteration Goal (Kanban Board)