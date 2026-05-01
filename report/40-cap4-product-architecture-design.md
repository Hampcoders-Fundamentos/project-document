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
### 4.2.1 Design Purpose
### 4.2.2 Primary Functionality (Primary User Stories)
### 4.2.3 Quality Attribute Scenarios
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