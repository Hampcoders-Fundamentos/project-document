# Capítulo V: Product Implementation, Validation & Deployment

## 5.1 Testing Suites & General Patterns

Para el desarrollo de Glottia, la fase de validación se fundamenta en la automatización de pruebas de integración y aceptación utilizando la metodología **Behavior-Driven Development (BDD)**. El propósito principal de este enfoque es cerrar la brecha de comunicación entre las definiciones de negocio (User Stories) y la implementación técnica del software, garantizando que cada incremento entregable funcione exactamente como se especificó.

Las pruebas se redactan en lenguaje **Gherkin**, un lenguaje específico de dominio estructurado mediante la semántica intuitiva *Given-When-Then* (Dado-Cuando-Entonces). Esta estructura permite documentar de forma viva los requisitos del sistema y convertirlos en scripts ejecutables que auditan los contratos de las APIs (códigos de estado HTTP, payloads de respuesta, persistencia en base de datos y flujos excepcionales de seguridad) de manera continua en nuestro pipeline de Integración Continua (CI).

***

### 5.1.1 Backend Application Core Testing Suite

Esta suite de pruebas agrupa los escenarios de prueba funcionales, unitarios y de integración automatizados destinados a validar la lógica de negocio pura y las operaciones fundamentales del núcleo de la aplicación (*Core Application*) de Glottia. Estas pruebas garantizan que los servicios e hilos transaccionales principales funcionen de manera óptima bajo los criterios de aceptación técnicos antes de su empaquetado y despliegue en los entornos de Staging y Producción.

* **Frameworks y Herramientas Utilizadas:** Se utiliza **Cucumber.js** como motor de ejecución BDD para interpretar los archivos `.feature`, **Supertest** para la orquestación de peticiones HTTP dirigidas a los endpoints sin levantar el servidor de forma física, y **Chai / Jest Expect** como biblioteca de aserciones para validar las estructuras de las respuestas JSON.
* **Cobertura e Impacto de las Pruebas Core:**
    * **Gestión de Identidad y Acceso (IAM):** Validación de flujos de registro de usuarios bajo el rol de estudiantes (*Learners*) y negocios asociados (*Partners*), control de unicidad de correos electrónicos y robustez de credenciales.
    * **Autenticación y Ciclo de Sesión:** Verificación de inicio de sesión (*Sign-In*), persistencia de estados de usuario, y revocación segura de tokens en el proceso de cierre de sesión (*Sign-Out*).
    * **Gestión de Perfiles (*Profiles*):** Pruebas de integración sobre el proceso de *Onboarding* de nuevos usuarios, actualización dinámica de niveles de fluidez en idiomas y persistencia de preferencias de práctica oral.

#### Relación de Tests Diseñados por User Story

| Código del Test | Nombre del Archivo .feature | Componente / Microservicio | User Story Relacionada (ID) |
| :--- | :--- | :--- | :--- |
| **TS-IAM-01** | \seqsplit{`auth_register_learner.feature`} | IAM Microservice | US01: Registro de nuevo aprendiz |
| **TS-IAM-02** | \seqsplit{`auth_register_partner.feature`} | IAM Microservice | US02: Registro de nuevo local |
| **TS-IAM-03** | \seqsplit{`auth_login.feature`} | IAM Microservice | US03: Inicio de sesión general |
| **TS-IAM-04** | \seqsplit{`auth_logout.feature`} | IAM Microservice | US04: Cierre de sesión |
| **TS-IAM-05** | \seqsplit{`auth_password_recovery.feature`} | IAM Microservice | US05: Recuperación de contraseña |
| **TS-PRF-06** | \seqsplit{`profile_onboarding.feature`} | Profiles Microservice | US06: Completar perfil de aprendiz |
| **TS-PRF-07** | \seqsplit{`profile_edition.feature`} | Profiles Microservice | US07: Editar perfil de aprendiz |
| **TS-PRF-08** | \seqsplit{`profile_discovery.feature`} | Profiles Microservice | US08: Ver perfil de otro usuario |
| **TS-PRF-09** | \seqsplit{`profile_avatar.feature`} | Profiles Microservice | US09: Subir foto de perfil |

***

### 5.1.2 Pattern Based Backend Application(s)

El backend modular y la subsiguiente arquitectura de microservicios de Glottia han sido desarrollados aplicando patrones de diseño de software y patrones arquitectónicos avanzados basados en **Domain-Driven Design (DDD)** y **Clean Architecture**. La validación mediante pruebas automatizadas en esta sección se estructura bajo estos patrones para garantizar la escalabilidad, la mantenibilidad y el aislamiento de fallas en el ecosistema:

* **Repository Pattern (Patrón Repositorio):** Se implementa para encapsular por completo la lógica de acceso, consulta y persistencia de datos (utilizando ORMs como TypeORM / Prisma) en clases especializadas. Esto desacopla la base de datos relacional de la lógica de negocio pura de los casos de uso. Las pruebas de integración aseguran que las consultas se ejecuten correctamente sin comprometer la integridad referencial.
* **Data Transfer Object - DTO (Objeto de Transferencia de Datos):** Patrón utilizado de manera obligatoria en las capas de entrada para moldear, filtrar y estandarizar los payloads que viajan a través de la red de microservicios. Evita la exposición directa de las entidades de la base de datos hacia los clientes de la API, y las suites de pruebas auditan que los validadores de los DTOs rechacen estructuras maliciosas o incompletas con códigos HTTP 400.
* **Dependency Injection (Inyección de Dependencias):** Utilizado de forma nativa para desacoplar las clases de la capa de infraestructura de las capas de aplicación y dominio. Permite que, durante la ejecución de los Testing Suites, se puedan inyectar dobles de prueba (*Mocks* o *Stubs*) de componentes de infraestructura complejos, permitiendo probar la lógica de las historias de usuario de forma aislada.
* **API Gateway Pattern:** Actúa como punto único de entrada para el cliente móvil (Flutter). Las pruebas orientadas a este patrón validan el correcto enrutamiento perimetral, la agregación de solicitudes hacia los microservicios internos de IAM y Profiles, y el manejo centralizado de políticas de Cross-Origin Resource Sharing (CORS).

***

### 5.1.3 Pattern Based Custom Software Library

Para resolver necesidades transversales dentro del ecosistema de Glottia (*Cross-Cutting Concerns*) y evitar la duplicidad de código (*Don't Repeat Yourself - DRY*), el equipo diseñó y aisló librerías de software personalizadas internas. Estas librerías se rigen estrictamente por los principios **SOLID** y cuentan con especificaciones de prueba aisladas para garantizar su reutilización segura:

* **Custom JWT Authentication Security Library:** Módulo personalizado encargado de la generación, firma asimétrica y validación criptográfica de tokens JSON Web Tokens (JWT). Las pruebas en esta librería aseguran la correcta decodificación de *claims* de usuario (tales como ID y roles) y la detección inmediata de firmas expiradas o alteradas.
* **Crypto Guard Engine (BCrypt Wrapper):** Componente dedicado a la seguridad adaptativa de datos sensibles mediante algoritmos de hash unidireccionales de alto costo computacional. Se utiliza para el cifrado seguro (*salting* y *hashing*) de contraseñas durante el registro e inicio de sesión, impidiendo el almacenamiento de texto plano en la base de datos.
* **Custom Cloud Storage & Media Curation Library:** Utilizada de manera transversal por el microservicio de perfiles para interactuar de forma segura con APIs de almacenamiento de objetos en la nube (ej. Amazon S3 o Cloudinary). Esta librería procesa flujos de datos *multipart/form-data*, valida las restricciones de peso (máximo 5MB) y dimensiones, y realiza la curación de imágenes de los avatares de usuario. Sus pruebas de aceptación validan el rechazo de extensiones de archivos no permitidas (ej. ejecutables maliciosos).

***

### 5.1.4 Framework Pattern Driven Refactoring Report

## 5.2 Software Configuration Management

Software Configuration Management (SCM) —o Gestión de la Configuración de Software— es una disciplina de la ingeniería de software que se encarga de rastrear, controlar y organizar todos los cambios que ocurren en el ciclo de vida de un proyecto. 
Su objetivo principal es asegurar que, sin importar cuántas personas estén trabajando en el proyecto o cuántas funciones nuevas se agreguen, el software se mantenga estable, consistente y libre de caos. (GeeksforGeeks, 2025)

***
### 5.2.1 Software Development Environment Configuration

#### **Project Requirements Management**
 
**Jira:** 
Herramienta de gestión de proyectos, diseñada principalmente para que equipos de software ágiles.. Fundamental para planificación, seguimientos , gestión de tareas y supervisar el flujo de trabajo en tiempo real para el sprint a desarrollar.

**Link de referencia:**
[Acceder a Jira](https://www.atlassian.com/es/software/jira)

#### **Product UX/UI Design**

**Figma:**
Herramienta de diseño gráfico y de edición de vectores basada en la nube, utilizada principalmente para crear y prototipar interfaces de usuario (UI) y experiencias de usuario (UX) para sitios web y aplicaciones móviles. Principal herramienta para nuestros diseños y prototipos Mobiles y Web.

**Link de referencia**
[Acceder a Figma](https://www.figma.com)

**PLantUML:**
Herramienta de código abierto que permite crear diagramas UML y otros esquemas técnicos mediante la escritura de texto plano y sencillo. Vital para el desarrollo de los diagrama de clase de nuestro proyecto.

**Link de referencia**
[Acceder a PlantUML](https://plantuml.com)

#### **Software Development**

**Visual Studio Code:**
Editor de código fuente gratuito, de código abierto y multiplataforma. Es una de las herramientas más populares entre programadores a nivel mundial gracias a su velocidad, flexibilidad y amplio soporte para múltiples lenguajes de programación. Este IDE permitió integrar de manera efectiva la colaboración de nuestro equipo para desarrollar las aplicaciones 

**Link de referencia:**
[Acceder a VS Code](https://code.visualstudio.com)

#### **Software Deployment**

**Postman:**
Plataforma de software utilizada por desarrolladores y evaluadores de software (QA) para construir, probar, documentar y modificar APIs. Esencial para validar los endpoints de nuestro proyecto Backend.

**Link de referencia**
[Acceder a Postman](https://www.postman.com)

**Render:**
Render actúa como una plataforma como servicio (PaaS) que toma el código desde repositorios (GitHub/GitLab), lo compila y lo pone en línea, facilitando la gestión de servidores y la configuración compleja. Util para publicar aplicaciones web, sitios estáticos o bases de datos en la nube de forma automatizada. 

**Link de referencia**
[Acceder a Render](https://render.com)

**Git:**
Sistema de control de versiones distribuido, de código abierto, diseñado para rastrear cambios en el código fuente durante el desarrollo de software. Facilita el registro de versiones sobre el código y documentación de nuestro proyecto para un seguimiento más ágil.

**Link de referencia**
[Acceder a Git](https://git-scm.com/)

#### **Software Documentation and Project Management**

**Github:**
Plataforma en la nube diseñada para el desarrollo colaborativo de software, permitiendo alojar, gestionar y compartir repositorios de código utilizando el sistema de control de versiones Git. Plataforma principal donde se alojará nuestro proyecto (código y documentación) y permitir la colaboración en tiempo real.

**Link de referencia**
[Acceder a Github](https://github.com/)

***

### 5.2.2 Source Code Management

### Repositorio de GitHub:

- Enlace para acceder al [Repositorio del Documento](https://github.com/Hampcoders-Fundamentos/project-document)
- Enlace para acceder al [Repositorio del Backend Monolito](https://github.com/Hampcoders-Fundamentos/glottia-backend-monolith)
- Enlace para acceder al [Repositorio del Backend Monolito](https://github.com/Hampcoders-Fundamentos/glottia-backend-microservices)

![Gitflow Graphic](assets/img/cap5/Gitflow-Graphic.jpeg)

**Gitflow** es un modelo de ramificación para Git que se centra en la organización de las ramas de un proyecto de software, definiendo una serie de ramas estándar y reglas para su uso que facilitan la colaboración y la gestión del código en un equipo de desarrollo. En Glottia, utilizamos el modelo de Gitflow para organizar y gestionar las ramas de nuestros repositorios de microservicios, lo que nos permite trabajar de forma eficiente y colaborativa en el desarrollo y migración de la plataforma.

La rama **main** es la rama principal de nuestro proyecto, que contiene las versiones estables, operativas y listas para desplegar de cada microservicio de Glottia. Estas versiones han sido previamente evaluadas y se ha verificado su total funcionalidad antes de ser integradas. Empleamos etiquetas para identificar cada versión estable desplegada, lo que nos permite tener un seguimiento preciso del historial de releases y simplificar la administración de futuras actualizaciones en producción.

La rama **develop** es la rama de desarrollo de nuestro proyecto, que contiene la versión en desarrollo de cada servicio de Glottia con todas las características completadas hasta ese momento del sprint, aunque aún pendientes de pruebas finales. Este canal se emplea para integrar el trabajo de los distintos miembros del equipo y llevar a cabo validaciones antes de la publicación en la rama main.

La rama **feature** agrupa las ramas de características de nuestro proyecto, cada una dedicada a una funcionalidad o tarea específica del sprint. Cada nueva historia de usuario o tarea técnica se desarrolla en una rama feature/ separada siguiendo la convención feature/nombre-descriptivo, lo que permite a los miembros del equipo trabajar de forma independiente en diferentes bounded contexts y facilita la integración progresiva del trabajo en la rama develop mediante Pull Requests.

### 5.2.3 Source Code Style Guide & Conventions

#### Frontend Code Style Guide

#### Backend Code Style Guide (Monolith)

#### 1. Arquitectura del Sistema
El repositorio sigue un patrón de **Monolito Modular** basado en los principios de **Clean Architecture** y **Domain-Driven Design (DDD)**.

#### Organización de Carpetas
La estructura se organiza por **Bounded Contexts** (Contextos Delimitados) dentro de `src/`:

* **`src/api/`**: Capa de entrada. Contiene los controladores, rutas de Express y middlewares de validación de HTTP.
* **`src/[contexto]/`**: Cada módulo funcional (ej. `users`, `courses`) se divide en:
    * **`domain/`**: El corazón del negocio. Contiene Entidades, Value Objects e interfaces de Repositorios (Ports). **No tiene dependencias externas**.
    * **`application/`**: Casos de uso que orquestan la lógica de negocio.
    * **`infrastructure/`**: Implementaciones técnicas (TypeORM, adaptadores de terceros, persistencia).
* **`src/shared/`**: Lógica transversal, utilitarios y clases base reutilizables por múltiples contextos.

#### 2. Convenciones de Nomenclatura

#### Clases y Tipos
* **Clases**: Se utiliza `PascalCase`. Deben incluir un sufijo descriptivo según su capa.
    * *Controladores:* `UserGetController`
    * *Casos de Uso:* `CreateCourseUseCase`
    * *Repositorios:* `SqliteUserRepository`
* **Interfaces**: Se utiliza `PascalCase`. **No se utiliza el prefijo `I`**. El nombre debe describir el contrato de forma natural (ej. `UserRepository` en lugar de `IUserRepository`).

#### 3. Archivos
* **Formato**: Se utiliza `kebab-case`.
* **Sufijos de archivo**: El nombre del archivo debe reflejar su propósito:
    * `user.entity.java`
    * `user-repository.java`
    * `create-user-use-case.java`
    * `user-post-controller.java`

#### 4. Variables y Funciones
* **Formato**: Se utiliza `camelCase`.
* **Claridad**: Los nombres deben ser descriptivos. Evitar abreviaturas crípticas (usar `userRepository` en lugar de `uRepo`).

#### 5. Estándares de Codificación

- Se rige el código por los principios SOLID, promoviendo la separación de responsabilidades, la inversión de dependencias y el diseño orientado a interfaces. Se favorece la composición sobre la herencia y se evita el acoplamiento entre capas. El código debe ser legible, mantenible y fácil de probar, siguiendo las mejores prácticas de desarrollo de software.

#### 6. Lógica de Negocio
* **Inyección de Dependencias**: Se favorece el uso de inyección por constructor para facilitar el desacoplamiento y las pruebas unitarias.
* **Regla de Dependencia**: Las capas internas (Domain) nunca deben depender de las capas externas (Infrastructure).
* **Manejo de Errores**: Se utilizan excepciones de dominio específicas que luego son transformadas en códigos HTTP en la capa de API.

#### Backend Code Style Guide (Microservices)

#### 1. Arquitectura de Microservicios
El sistema se descompone en servicios autónomos que se comunican de forma asíncrona (vía eventos) o síncrona (vía API REST/gRPC).

#### Estructura de la Solución
Cada microservicio dentro de la carpeta `services/` (o repositorios independientes) mantiene su propia autonomía técnica:

* **`src/`**: Raíz del código fuente del microservicio.
    * **`infrastructure/`**: Implementaciones de frameworks, bases de datos y clientes de mensajería (ej. RabbitMQ, Kafka).
    * **`application/`**: Casos de uso específicos del dominio del microservicio.
    * **`domain/`**: Lógica de negocio pura y entidades del subdominio.
* **`events/` o `messages/`**: Definiciones de eventos de integración para comunicación entre servicios.
* **`api-gateway/`**: Punto de entrada único que orquestas las peticiones hacia los microservicios internos.

#### 2. Convenciones de Nomenclatura

#### Naming de Microservicios
* **Repositorios/Carpetas**: Se utiliza `kebab-case` con el sufijo `-service`.
    * Ejemplo: `identity-service`, `catalog-service`, `ordering-service`.

#### Clases y Archivos

- Se mantienen las convenciones de Clean Architecture del monolito, pero con énfasis en la comunicación externa:

* **Event Handlers**: Clases que procesan mensajes entrantes. Nombradas como `[EventName]Handler` (ej. `UserCreatedHandler`).
* **Publishers**: Interfaces para enviar mensajes. Nombradas como `[Entity]Publisher` (ej. `OrderEventPublisher`).
* **Suffixes**:
    * `*.controller.java`: Entrada HTTP.
    * `*.subscriber.java`: Suscriptor a eventos de bus.
    * `*.dto.java`: Objetos de transferencia de datos para la red.

#### 3. Estándares de Comunicación

#### Event-Driven Design

* **Eventos**: Se deben definir en `PascalCase` y representar hechos pasados (ej. `UserRegistered`, `PaymentProcessed`).
* **Idempotencia**: Todos los servicios que consumen eventos deben implementar lógica de idempotencia para evitar duplicados.

#### API & DTOs

* **Contratos**: Los DTOs son obligatorios para la comunicación entre servicios. No se comparten entidades de dominio a través de la red.
* **Versionamiento**: Las rutas de API deben incluir la versión (ej. `/api/v1/identity/...`).

#### 4. Diferencias Clave con el Monolito
1.  **Shared Kernel**: Se evita el código compartido pesado. Si se necesita compartir lógica, se hace mediante librerías privadas o duplicación controlada para mantener el desacoplamiento.
2.  **Persistencia Políglota**: Cada microservicio puede (y suele) tener su propia base de datos, prohibiendo el acceso directo a la base de datos de otro servicio.

### 5.2.4 Software Deployment Configuration

## 5.3 Microservices Implementation

### 5.2.1 Sprint 1

El Sprint 1 tiene una duración de 2 semanas y abarca tres frentes de trabajo: la migración del backend de monolito modular a microservicios independientes (IAM, Profiles y Encounters, cada uno con su propia base de datos y dockerizado), la implementación de las funcionalidades base de la plataforma que incluyen el registro y autenticación de usuarios, la gestión del perfil del aprendiz y el flujo completo de un encuentro desde la búsqueda hasta el check-in, y en paralelo la corrección de bugs existentes en la app junto con mejoras de UI en la pantalla home y el perfil de aprendiz, todo con el objetivo de tener los tres microservicios desplegados de forma autónoma y el ciclo de vida completo de un encuentro funcionando de punta a punta al cierre del sprint.

### Sprint Goal

"Nuestro enfoque está en migrar IAM, Profiles y Encounters a microservicios independientes y habilitar los flujos base de autenticación, gestión de perfil y check-in en encuentros.
Creemos que entrega una arquitectura desacoplada y escalable, y una experiencia funcional de punta a punta al equipo de desarrollo y a los primeros aprendices.
Esto se confirmará cuando un usuario pueda registrarse, completar su perfil y hacer check-in exitosamente en un encuentro utilizando la nueva infraestructura de microservicios."

#### 5.2.1.1 Sprint Backlog 1

\
![Sprint Backlog 1](assets/img/cap5/Glottia-SprintBacklog-1.jpeg)
\
[Ver Sprint Backlog 1 en Jira](https://fundamentos.atlassian.net/jira/software/projects/HGS1/boards/34/backlog?atlOrigin=eyJpIjoiOGU3YWU0ZDBkN2NjNGQ2MDkxMGQxZjk4ZjUwYWFmNTAiLCJwIjoiaiJ9)


#### 5.2.1.2 Development Evidence for Sprint Review

Durante el Sprint 1, se logró un avance parcial en el despliegue de la landing page.
[Link del landing Page](https://glottia-landing-page-master.vercel.app/) 
Actualmente, el sitio ya cuenta con diversas secciones operativas que ofrecen información clave sobre los servicios y el equipo de Glottia. Las evidencias de este progreso se detallan a continuación:

 - **Sección Hero (Inicio):** El usuario visualiza la propuesta de valor principal centrada en la práctica de idiomas cara a cara. La sección destaca beneficios clave como conversaciones   reales, la posibilidad de conocer gente nueva y el acceso a espacios seguros.
 (assets/img/cap5/hero-section.png)

 - **Sección ¿Cómo funciona?:** El usuario puede visualizar el proceso de funcionamiento de la plataforma dividido en dos perfiles: Aprendices y Locales. Para los aprendices, se detallan tres pasos que incluyen el registro de perfil, la búsqueda de encuentros temáticos y la asistencia a las sesiones. Para los locales, se explica el flujo para convertir su negocio en un "hub cultural" mediante el registro del establecimiento, la definición de horarios disponibles y la recepción de los practicantes de idiomas.
 (assets/img/cap5/how-it-works.png)

 - **Sección Nuestra Solución:** El usuario obtiene una visión detallada del ecosistema de la plataforma, destacando pilares como conversaciones reales, una comunidad activa, soporte para múltiples idiomas y un enfoque en el progreso garantizado.
 (assets/img/cap5/our-solution.png)

 - **Sección Ve Glottia en Acción:** El usuario puede visualizar una demostración práctica de la plataforma a través de un video interactivo que muestra la interfaz de la aplicación en funcionamiento.
 (assets/img/cap5/glottia-in-action.png)

 - **Sección Beneficios para todos:** El usuario puede explorar las ventajas competitivas de la plataforma segmentadas para Aprendices y Locales. Para los estudiantes, se resaltan beneficios como la ganancia de fluidez en situaciones reales, el networking cultural, el ahorro frente a academias tradicionales y la flexibilidad de horarios. 
 (assets/img/cap5/benefits.png)

 - **Sección Sobre Nosotros:** El usuario puede conocer la identidad corporativa de la plataforma a través de su Misión, enfocada en facilitar la práctica oral mediante experiencias reales y seguras, y su Visión, que aspira a convertir a Glottia en la comunidad global de referencia para el intercambio cultural.. 
 (assets/img/cap5/about-us.png)
***

#### 5.2.1.3 Testing Suite Evidence for Sprint Review

En esta sección se detalla el conjunto de pruebas de integración y aceptación automatizadas que validan la lógica de negocio de la plataforma Glottia. Para el diseño de estas suites, el equipo ha adoptado el enfoque de **Behavior-Driven Development (BDD)**, utilizando el lenguaje **Gherkin**. 

Esta metodología permite definir el comportamiento del sistema desde la perspectiva del usuario mediante escenarios estructurados (*Given-When-Then*), facilitando la verificación técnica de los Web Services y asegurando que cada microservicio cumpla estrictamente con las reglas del negocio digital antes de su despliegue.

***

### IAM Microservice Testing Suite

A continuación, se presentan las especificaciones en código Gherkin encargadas de validar los procesos de soporte críticos de autenticación, autorización y registro en el contexto de IAM.

#### `auth_register_learner.feature` (Relacionado con US01)

\
```gherkin
Feature: Learner Registration Management
  As a person interested in practicing languages
  I want to register an account in Glottia using my email and password
  So that I can access the community and language encounters

  Background:
    Given the registration API endpoint "/api/v1/auth/register" is available

  Scenario: Successful Learner Registration (Escenario #1)
    When I send a POST request with a valid "email" as "italo@upc.edu.pe", a strong "password" as "Glottia2026!", and accept terms
    Then the system should return a status code 201
    And the response body should contain a success message, a unique user "id", and status "PENDING_CONFIRMATION"

  Scenario: Registration Failed due to Duplicate Email (Escenario #2)
    Given a user with email "italo@upc.edu.pe" already exists in the system
    When I send a POST request with email "italo@upc.edu.pe" and password "Glottia2026!"
    Then the system should return a status code 400
    And the response body should contain the error message "Este correo ya está registrado"

  Scenario: Registration Failed due to Weak Password (Escenario #3)
    When I send a POST request with email "newuser@upc.edu.pe" and a weak "password" as "123"
    Then the system should return a status code 400
    And the response body should detail the missing security requirements

  Scenario: Email Activation Validation Link Expiration (Escenario #4)
    Given a user completed registration more than 24 hours ago
    And the user has not clicked the confirmation link
    When the automatic validation routine executes
    Then the user account status should be set to "DEACTIVATED".
```


#### `auth_register_partner.feature` (Relacionado con US02)

\
```gherkin
Feature: Partner and Business Registration
  As a business owner
  I want to register my business in the platform
  So that I can offer my space for encounters and gain visibility

  Background:
    Given the partner registration gateway is active

  Scenario: Successful Partner and Venue Registration (Escenario #1)
    When I submit account details with email "partner@cafe.com", password "CafePass2026!" and business details name "Glottia Cafe", address "Av. Salaverry 123"
    Then the system should return a status code 201
    And the account type should be "Partner"
    And the venue status should be set to "PENDING_APPROVAL"

  Scenario: Address Validation via Google Maps API (Escenario #2)
    When a partner submits an address as "Calle Falsa 123456789, Lima"
    Then the system should validate the location with the Maps Service
    And return a suggestion or prompt for manual correction

  Scenario: Missing Critical Business Information (Escenario #3)
    When I try to register a business omitting the "capacity" or "operatingHours"
    Then the system should return a status code 400
    And the response should block registration indicating the mandatory missing fields

  Scenario: Manual Administrative Approval (Escenario #4)
    Given a partner registration is complete with status "PENDING_APPROVAL"
    When an administrator reviews and approves the business data
    Then the venue status should transition to "ACTIVE"
    And it should become visible on the public platform
```

***

#### `auth_login.feature` (Relacionado con US03)

\
```gherkin
Feature: General User Authentication
  As a registered user (learner or partner)
  I want to sign in with my credentials
  So that I can access my personalized dashboard and features

  Background:
    Given the authentication endpoint "/api/v1/auth/login" is active

  Scenario: Successful Login and Token Generation (Escenario #1)
    Given a registered user with email "italo@upc.edu.pe" and password "Glottia2026!" exists
    When I send a POST request with the correct email and password
    Then the system should return a status code 200
    And the response must include a secure JWT token, user "id", and role "LEARNER"

  Scenario: Login Failed due to Invalid Credentials (Escenario #2)
    When I send a POST request with an invalid email or wrong password
    Then the system should return a status code 401
    And the response message must be generically "Email o contraseña inválidos" for security tracking

  Scenario: Login Blocked due to Unconfirmed Email (Escenario #3)
    Given a user account with status "PENDING_CONFIRMATION"
    When I attempt to log in with valid credentials
    Then the system should return a status code 403
    And provide an option to resend the confirmation email

  Scenario: Login Blocked due to Suspended Account (Escenario #4)
    Given a user account with status "SUSPENDED"
    When I attempt to log in
    Then the system should return a status code 403
    And the message should state "Tu cuenta ha sido suspendida. Contacta con soporte"

  Scenario: Account Lockout after Multiple Failed Attempts (Escenario #5)
    Given a user has failed their login attempt 5 consecutive times
    When they execute a 6th login attempt
    Then the system should temporarily lock the account for 30 minutes

  Scenario: Token Expiration forcing Re-authentication (Escenario #6)
    Given a user session token was issued more than 30 days ago
    When the user executes any secure API request
    Then the server should return a status code 401 Unauthorized
    And redirect the client application to the login prompt
```

***

#### `auth_logout.feature` (Relacionado con US04)

\
```gherkin
Feature: User Session Invalidation
  As an authenticated user
  I want to log out of my session
  So that I can protect my account privacy on shared devices

  Scenario: Successful Logout (Escenario #1)
    Given a user is authenticated with a valid JWT token
    When they send a POST request to "/api/v1/auth/logout"
    Then the system should return a status code 200
    And the token should be added to the blacklist
    And local session cookies must be cleared

  Scenario: Automatic Inactivity Logout (Escenario #2)
    Given a user has been completely inactive for more than 30 minutes
    When they attempt to perform any state-changing action
    Then the system should automatically invalidate the session and respond with 401

  Scenario: Global Device Logout (Escenario #3)
    Given a user has multiple active sessions across different devices
    When they trigger the "Cerrar sesión en todos los dispositivos" command
    Then the system should revoke all active tokens associated with that user ID
```

***


#### `auth_password_recovery.feature` (Relacionado con US05)

\
```gherkin
Feature: Password Recovery Protocol
  As a registered user
  I want to request a password reset link
  So that I can regain access to my account if forgotten

  Scenario: Successful Recovery Request Trigger (Escenario #1)
    Given a user with email "italo@upc.edu.pe" exists
    When I request a reset link for this email
    Then the system should return a status code 200
    And an email containing a token valid for 1 hour must be sent

  Scenario: Non-existent Email Handling (Escenario #2)
    When I request a reset link for an email not registered in the database
    Then the system should return a status code 200
    And the response message must say "Si esta cuenta existe, recibirá un email" to prevent user enumeration

  Scenario: Expired Reset Link Usage (Escenario #3)
    Given a reset token was generated more than 1 hour ago
    When I attempt to access the reset form using that token
    Then the system should reject it with the message "Este link ha expirado"

  Scenario: Persisting New Password (Escenario #4)
    Given a valid and active password reset token
    When I submit a new compliant password
    Then the system should update the credentials in the database
    And return a status code 200 success

  Scenario: Rate Limiting on Recovery Generation (Escenario #5)
    Given a user has requested 3 reset links within the last 10 minutes
    When they attempt to request a 4th link
    Then the system should rate limit the request and enforce a 10-minute cooldown
```

---

#### Profiles Microservice Testing Suite

A continuación, se detallan las especificaciones Gherkin enfocadas en validar las reglas de la gestión de perfiles e idiomas dentro del microservicio Profiles.

#### `profile_onboarding.feature` (Relacionado con US06)

\
```gherkin
Feature: Learner Profile Onboarding
  As a newly registered learner
  I want to complete my profile with my native language and target languages
  So that other users can know me and the system can recommend relevant encounters

  Background:
    Given a registered user has an uncompleted profile entity at "/api/v1/profiles"

  Scenario: Successful First-Time Profile Onboarding (Escenario #1)
    When I send a POST request specifying nativeLanguage "Spanish", practiceLanguages "[English]", and level "B2"
    Then the profile status should be updated to "COMPLETED"
    And the recommendations engine should trigger matching events for the dashboard

  Scenario: Missing Target Practice Languages (Escenario #2)
    When I attempt to save a profile with an empty list of practice languages
    Then the server should return a status code 400
    And the response JSON should indicate "Selecciona al menos 1 idioma para practicar"

  Scenario: Handling Multiple Native Languages and Distinct Levels (Escenario #3)
    When I submit a profile with nativeLanguages "['Spanish', 'Quechua']" and practiceLanguages "[{'languageId': 'English', 'level': 'C1'}]"
    Then the database should store all mapped language entities correctly

  Scenario: Dynamic Filtering Validation (Escenario #4)
    Given a learner has "English B2" configured as their primary interest
    When they load their dashboard recommendations
    Then the response array should only stream encounters tagged with English language parameters
```

---

#### `profile_edition.feature` (Relacionado con US07)

\
```gherkin
Feature: Learner Profile Edition
  As an active learner
  I want to edit my profile details at any time
  So that my information remains updated across the ecosystem

  Scenario: Update Language Fluency Level (Escenario #1)
    Given a profile with ID 500 has "English B1"
    When I send a PUT request to "/api/v1/profiles/500" changing level to "B2"
    Then the database should update the row immediately
    And future recommendation queries should adapt to the B2 threshold

  Scenario: Archiving Encounters on Language Removal (Escenario #2)
    Given a learner is registered to future English encounters
    When the learner removes "English" from their practice language collection
    Then those specific active reservations should be safely flagged as "archived" but not dropped completely

  Scenario: Real-Time Cache Invalidation for Other Users (Escenario #3)
    When a learner modifies their public display name
    Then any other user fetching encounter details where this learner is an attendee must instantly see the updated name
```

---

#### `profile_discovery.feature` (Relacionado con US08)

\
```gherkin
Feature: Public Profile Discovery
  As a learner
  I want to view the public profile of other attendees
  So that I can learn about their language interests and connect with them

  Scenario: Standard Public Profile View (Escenario #1)
    Given I am inspecting the attendees list of an encounter
    When I execute a GET request to "/api/v1/profiles/750"
    Then the response should mask sensitive fields and return "firstName", "avatarUrl", "nativeLanguages", and "practiceLanguages"

  Scenario: Contact Request Action Trigger (Escenario #2)
    When I click "Enviar solicitud de contacto" on user 750's public card
    Then a networking record should be initialized in the database with status "PENDING"

  Scenario: Privacy Restrictions Enforcement (Escenario #3)
    Given user 750 has configured their profile privacy settings to "HIGH"
    When another user requests their profile data
    Then the server must hide their email and exact fluency metrics, exposing only name and photo placeholder
```

---

#### `profile_avatar.feature` (Relacionado con US09)

\
```gherkin
Feature: Profile Avatar Management
  As a platform user
  I want to upload a profile picture
  So that my account is personalized and recognizable

  Scenario: Successful Image Curation and Upload (Escenario #1)
    Given a valid image asset "me.png" of size 2MB
    When I dispatch a multipart/form-data POST request to the storage endpoint
    Then the asset should be processed, cropped to square proportions, and the public CDN URL bound to the profile row

  Scenario: Image Rejection due to Large File Size (Escenario #2)
    Given a heavy image file of size 10MB
    When I attempt to upload it as my avatar
    Then the system must reject the payload with status code 413
    And return the localized message "Archivo demasiado grande. Máximo 5MB"

  Scenario: Automatic Avatar Replacement (Escenario #3)
    Given a user already has an active avatar URL in their profile database record
    When they upload a new valid image file
    Then the system should overwrite or delete the older object reference and map the new CDN location

  Scenario: Resetting to Default Avatar (Escenario #4)
    When I issue a DELETE command on my profile photo path
    Then the image path field in the database should revert to the default system placeholder avatar string
```

#### 5.2.1.4 Execution Evidence for Sprint Review

El Sprint 1 del proyecto Glottia, ejecutado durante dos semanas por el equipo Hampcoders, tuvo como objetivo principal iniciar la migración del backend de una arquitectura monolito modular hacia microservicios independientes, abarcando los bounded contexts de IAM, Profiles y Encounters, al mismo tiempo que se implementaban las funcionalidades base de la plataforma y se atendían mejoras y correcciones en la aplicación móvil Flutter. En cuanto a la migración, se logró extraer y dockerizar el servicio de IAM con su propia base de datos, se avanzó en la separación del servicio de Encounters con la configuración de su schema independiente y sus integraciones hacia Venues y Profiles, y se inició la configuración del API Gateway como punto de entrada único para todos los microservicios. En el frente funcional, se completaron las historias de usuario correspondientes al ciclo de autenticación completo (registro de aprendiz y partner, inicio y cierre de sesión), el perfil base del aprendiz, y el flujo de check-in en encuentros. En paralelo, el equipo de mobile resolvió los bugs críticos de crash en el registro y persistencia de sesión, además de entregar el rediseño de la pantalla home. Como trabajo pendiente para el siguiente sprint quedan la separación completa de Profiles y Encounters como microservicios autónomos, la historia US05 recuperación de contraseña y un bugfix en el cierre de sesión.

### Web UI Evidence

![Dashboard](assets/img/cap5/Web-UI-Execution-Evidence1.png){width=70%}

![Promotions](assets/img/cap5/Web-UI-Evidence-2.png){width=70%}


![Analytics](assets/img/cap5/Web-UI-Evidence-3.png){width=70%}

### Mobile UI Fixes Evidence

![Learner Homepage](assets/img/cap5/Learner-Homepage.jpeg){width=70%}

![Partners Section Update](assets/img/cap5/Partners-Section-Update.jpeg){width=70%}

### Endpoints Execution Evidence

![Captura 1 de la ejecución de Postman](assets/img/cap5/Postman1.jpeg){width=50%}

![Captura 2 de la ejecución de Postman](assets/img/cap5/Postman2.jpeg){width=50%}

![Captura 3 de la ejecución de Postman](assets/img/cap5/Postman3.jpeg){width=50%}

![Captura 4 de la ejecución de Postman](assets/img/cap5/Postman4.jpeg){width=50%}

![Captura 5 de la ejecución de Postman](assets/img/cap5/Postman5.jpeg){width=50%}

![Captura 6 de la ejecución de Postman](assets/img/cap5/Postman6.jpeg){width=50%}

![Captura 7 de la ejecución de Postman](assets/img/cap5/Postman7.jpeg){width=50%}

#### 5.2.1.5 Microservices Documentation Evidence for Sprint Review

En este Sprint se implementó y documentó la primera versión de los microservicios correspondientes a los Bounded Contexts de IAM, Profiles y Encounters de la plataforma Glottia.

Durante el Sprint 1 del proyecto Glottia se implementaron y documentaron los primeros microservicios correspondientes a los Bounded Contexts de IAM, Profiles y Encounters.  
El objetivo principal de este Sprint fue establecer la arquitectura base orientada a microservicios, habilitando la autenticación de usuarios, la gestión de perfiles de aprendizaje y la administración de encuentros conversacionales.

La documentación de los Web Services fue desarrollada utilizando OpenAPI/Swagger, permitiendo definir formalmente los endpoints REST, parámetros de entrada, estructuras de request/response y códigos HTTP soportados.

Entre los principales logros alcanzados en este Sprint destacan:

- Separación de los Bounded Contexts como microservicios independientes.
- Implementación de autenticación y gestión de sesión mediante JWT.
- Implementación de APIs para perfiles de learners.
- Implementación de APIs para creación y gestión de encounters.
- Configuración inicial del API Gateway.
- Documentación interactiva mediante Swagger/OpenAPI.
- Validación de endpoints utilizando datos de prueba.

---

### IAM Microservice Documentation

El microservicio IAM (Identity and Access Management) es responsable de la autenticación, autorización y gestión de sesiones de los usuarios de Glottia.

#### Implemented Endpoints

| Endpoint | HTTP Method | Description |
|---|---|---|
| \seqsplit{`/api/v1/auth/register`} | POST | Registro de nuevos usuarios |
| \seqsplit{`/api/v1/auth/login`} | POST | Inicio de sesión |
| \seqsplit{`/api/v1/auth/refresh-token`} | POST | Renovación de token JWT |
| \seqsplit{`/api/v1/auth/logout`} | POST | Cierre de sesión |

#### Swagger Evidence — IAM

La imágenes a continuación muestran la documentación Swagger/OpenAPI correspondiente a los endpoints del microservicio IAM.


![](assets/img/cap5/iam.jpeg)

*Figura 18. Vista general de la especificación de los endpoints del módulo de users bajo el estándar OpenAPI.*

![](assets/img/cap5/Authentication.jpeg)

*Figura 19. Vista general de la especificación de los endpoints del módulo de Autenticación bajo el estándar OpenAPI.*

---

#### Swagger Documentation — IAM Microservice.

---

![](assets/img/cap5/Documentacion-iam.png)

*Figura 20. Interfaz de Swagger UI para el endpoint de registro de usuarios, detallando el esquema del Request Body requerido del sing-up.*

![IAM-Documentation-sing-in](assets/img/cap5/IAM-sing-in.png)

*Figura 21. Evidencia de interacción con el endpoint `/api/v1/auth/login` utilizando datos de muestra (`username: "test_user"`). Se observa la respuesta exitosa con código HTTP 200 (OK) y la generación del respectivo token de autenticación (JWT).*

--- 

### Encounters Microservice Documentation

El microservicio Encounters administra la creación, búsqueda, reserva y seguimiento de encuentros conversacionales dentro de Glottia.

#### Implemented Endpoints

| Endpoint | HTTP Method | Description |
|---|---|---|
| \seqsplit{`/api/v1/encounters`} | POST | Crear encounter |
| \seqsplit{`/api/v1/encounters/search`} | GET | Buscar encounters |
| \seqsplit{`/api/v1/encounters/search-simple`} | GET | Búsqueda simplificada |
| \seqsplit{`/api/v1/encounters/{encounterId}`} | GET | Obtener encounter |
| \seqsplit{`/api/v1/encounters/{encounterId}/start`} | POST | Iniciar encounter |
| \seqsplit{`/api/v1/encounters/{encounterId}/complete`} | POST | Completar encounter |
| \seqsplit{`/api/v1/encounters/{encounterId}/attendances`} | POST | Registrar asistencia |
| \seqsplit{`/api/v1/encounters/{encounterId}/attendances/check-in`} | POST | Realizar check-in |
| \seqsplit{`/api/v1/encounters/{encounterId}/attendances/me`} | DELETE | Cancelar asistencia |
| \seqsplit{`/api/v1/encounters/{encounterId}`} | DELETE | Cancelar encounter |

#### Swagger Evidence — Encounters

La imágenes a continuación muestran la documentación Swagger/OpenAPI correspondiente a los endpoints del microservicio Encounters.

![](assets/img/cap5/Encounters.png)

*Figura 21. Panel general de Swagger UI para el microservicio de Encounters, listando los controladores REST encargados de la gestión del ciclo de vida de las sesiones conversacionales.*

--- 

#### Swagger Documentation — Encounters Microservice.

---

![](assets/img/cap5/post-encounters.png)

*Figura 22. Interfaz interactiva para el endpoint POST /api/v1/encounters. Se observa la estructura requerida del Request Body para dar de alta un nuevo encuentro de práctica lingüística y los esquemas de validación de datos.*

![](assets/img/cap5/Encounters-id.png)

*Figura 23. Prueba de ejecución con datos de muestra para el endpoint GET /api/v1/encounters/{encounterId} e inicio del flujo. La documentación detalla la inyección*

![](assets/img/cap5/EncounterId-complete.png)

*Figura 24. Evidencia del endpoint de finalización del ciclo conversacional (POST /.../complete). Muestra la estructura de respuesta exitosa del servidor tras procesar el cambio de estado de la sesión utilizando una ID de muestra.*

---

### Profiles Microservice Documentation

El microservicio Profiles gestiona la información pública y académica de los learners y partners dentro de Glottia.

#### Implemented Endpoints

| Endpoint | HTTP Method | Description |
|---|---|---|
| \seqsplit{`/api/v1/profiles`} | GET | Obtener todos los perfiles |
| \seqsplit{`/api/v1/profiles/{id}`} | GET | Obtener perfil por ID |
| \seqsplit{`/api/v1/profiles`} | POST | Crear nuevo perfil |
| \seqsplit{`/api/v1/profiles/{id}`} | PUT | Actualizar perfil |
| \seqsplit{`/api/v1/profiles/{id}`} | DELETE | Eliminar perfil |
| \seqsplit{`/api/v1/profiles/search`} | GET | Buscar perfil por email |
| \seqsplit{`/api/v1/profiles/{profileId}/learner/languages`} | POST | Agregar idioma |
| \seqsplit{`/api/v1/profiles/{profileId}/learner/languages/{languageId}`} | PUT | Actualizar idioma |
| \seqsplit{`/api/v1/profiles/{id}/learner/languages/{languageId}`} | DELETE | Eliminar idioma |


#### Swagger Evidence — Profiles

La imágenes a continuación muestran la documentación Swagger/OpenAPI correspondiente a los endpoints del microservicio Profiles.

![](assets/img/cap5/Profiles.png)

*Figura 25. Interfaz principal de Swagger UI para el microservicio de Profiles, exhibiendo los endpoints necesarios para la administración de datos personales y configuración de idiomas.*

--- 

#### Swagger Documentation — Profiles Microservice.

---

![](assets/img/cap5/ProfilesId-put.png)

*Figura 26. Detalle de especificación para el endpoint PUT /api/v1/profiles/{id}. La interfaz muestra los parámetros requeridos en la ruta y el esquema JSON necesario para la actualización parcial o total del perfil.*

![](assets/img/cap5/Post-Profiles-id.jpeg)

*Figura 27. Interacción simulada con el endpoint POST /api/v1/profiles utilizando datos de muestra. Se valida la respuesta exitosa del servidor junto con los códigos de estado HTTP ante el envío de estructuras de perfil correctas.*

![](assets/img/cap5/Get-Profiles.png)

*Figura 28. Ejecución exitosa de una consulta masiva mediante el endpoint GET /api/v1/profiles. Swagger UI despliega la respuesta simulada con código 200 (OK) exponiendo la estructura en formato de arreglo JSON de los perfiles guardados en el sistema.*

#### 5.2.1.6 Software Deployment Evidence for Sprint Review

**Software Deployment Evidence for Sprint Review**
Durante el Sprint 1 se llevaron a cabo las actividades iniciales de despliegue de la plataforma Glottia en la nube, marcando el primer hito en la transición de la arquitectura monolito modular hacia microservicios independientes. Las actividades de despliegue abarcaron la creación de cuenta en Render como proveedor cloud, la configuración de los proyectos de despliegue para los primeros servicios extraídos del monolito, y el despliegue manual de dos Web Services: el monolito existente y el microservicio de IAM.

**Creación de cuenta en Render**
Se creó una cuenta en Render (render.com) como proveedor cloud principal para el alojamiento de los Web Services de la plataforma. Render fue seleccionado por su soporte nativo a contenedores Docker, su facilidad de configuración para proyectos Spring Boot y su plan gratuito adecuado para entornos de desarrollo y validación de sprint.

![Account](assets/img/cap5/Render-Account.jpeg)

**Configuración y despliegue del monolito**
Se configuró el proyecto del monolito modular existente en Render como Web Service, utilizando Docker como mecanismo de empaquetado y despliegue. Se definieron las variables de entorno correspondientes a la conexión de base de datos y configuración de seguridad. Este servicio representa la versión base del sistema previo al proceso de migración a microservicios.
Configuración y despliegue del microservicio IAM
Se configuró el microservicio de IAM como un Web Service independiente en Render. El servicio fue contenerizado mediante Docker con su propio Dockerfile, separado completamente del monolito, con su propia base de datos MySQL y sus variables de entorno de configuración definidas de forma autónoma. El despliegue fue realizado de forma manual conectando el repositorio correspondiente al proyecto en Render.

![Monolith Deployment](assets/img/cap5/Monolith-Deployment.jpeg)

**Pendiente**
Las URLs públicas de los tres servicios desplegados estarán disponibles para la siguiente iteración del informe una vez que los servicios completen su proceso de inicialización en Render. Se adjuntarán capturas de pantalla del dashboard de Render, la configuración de cada Web Service y las evidencias de los despliegues exitosos en cuanto estén disponibles.

#### 5.2.1.7 Team Collaboration Insights during Sprint

Durante el Sprint 1, el equipo Hampcoders gestionó la colaboración y el control de versiones mediante GitHub, adoptando GitFlow como estrategia de branching. Esto implicó el uso de ramas main y develop como ramas base, y la creación de ramas de tipo feature/ para cada tarea del sprint, asegurando que ningún cambio fuera integrado directamente a las ramas principales sin pasar por un proceso de Pull Request y revisión de código por parte de otro miembro del equipo. Las capturas de los analíticos de commits y la participación de cada integrante en los repositorios de los Web Services se presentan a continuación.

\
![Gitflow](assets/img/cap5/Gitflow.jpeg)
\
![Contributors](assets/img/cap5/Contributors.jpeg)

#### 5.2.1.8 Kanban Board --> TP1

\
![Sprint 1 Kanban Board](assets/img/cap5/Glottia-Sprint1-KanbanBoard.jpeg)
\
[Ver Sprint 1 Kanban Board en Jira](https://fundamentos.atlassian.net/jira/software/projects/HGS1/boards/34?atlOrigin=eyJpIjoiMDFiMTg2M2NkNTA3NDJjZDllZTQ3ZTlhNDU5MmNjMjUiLCJwIjoiaiJ9)

### 5.2.2 Sprint 2
#### 5.2.2.1 Sprint Backlog 2
\
![Sprint Backlog 2](assets/img/cap5/SprintBacklog2-part1.png)
\
![Sprint Backlog 2](assets/img/cap5/SprintBacklog2-part2.png)
\
[Ver Sprint Backlog 2 en Jira](https://fundamentos.atlassian.net/jira/software/projects/HGS1/boards/34/backlog?atlOrigin=eyJpIjoiY2E3Mzk2N2MyN2U4NGYwZGExZGRkM2U2ZGE5MGYyN2QiLCJwIjoiaiJ9)

#### 5.2.2.2 Development Evidence for Sprint Review
#### 5.2.2.3 Testing Suite Evidence for Sprint Review

En esta sección se detalla el conjunto de pruebas de integración y aceptación automatizadas que validan la lógica de negocio de la plataforma Glottia correspondiente al Sprint 2. Para el diseño de estas suites, el equipo ha adoptado el enfoque de **Behavior-Driven Development (BDD)**, utilizando el lenguaje **Gherkin**.

Esta metodología permite definir el comportamiento del sistema desde la perspectiva del usuario mediante escenarios estructurados (*Given-When-Then*), facilitando la verificación técnica de los Web Services y asegurando que cada microservicio —Venues, Promotions, Learning Feedback y Engagement— cumpla estrictamente con las reglas del negocio digital antes de su despliegue.

Durante el Sprint 2 se implementaron los Bounded Contexts de Venues, Promotions, Learning Feedback y Engagement, cubriendo las funcionalidades de gestión de locales comerciales, promociones y ofertas por lealtad, retroalimentación de encuentros mediante autoevaluación y quizzes, y el sistema de gamificación con puntos, insignias, leaderboard y rachas de asistencia.

***

### Venues Microservice Testing Suite

A continuación, se presentan las especificaciones en código Gherkin encargadas de validar los procesos de gestión de locales comerciales (venues), sus mesas, disponibilidad, galería de fotos y registro de partners en el contexto de Venues.

#### `venue_management.feature` (Relacionado con US10)

\
```gherkin
Feature: Venue Registration and Management
  As a business owner (Partner)
  I want to register my venue in the platform
  So that I can offer my space for language encounters and gain visibility

  Background:
    Given the venues API endpoint "/api/v1/venues" is available

  Scenario: Successful Venue Registration (Escenario #1)
    When I send a POST request with valid "name" as "Glottia Cafe", "address" as "Av. Salaverry 123, Lima", validated via Google Maps, "capacity" as 30, and "operatingHours" specifying different schedules per day
    Then the system should return a status code 201
    And the venue should be created with status "PENDING_APPROVAL"
    And the partner should be associated as the owner

  Scenario: Address Validation via Google Maps API (Escenario #2)
    When a partner submits an address as "Calle Falsa 123456789, Lima"
    Then the system should validate the location with the Maps Service
    And return a suggestion for manual correction

  Scenario: Registration with Missing Critical Information (Escenario #3)
    When I try to register a venue omitting the "capacity" or "operatingHours"
    Then the system should return a status code 400
    And the response should block registration indicating the mandatory missing fields

  Scenario: Administrative Approval (Escenario #4)
    Given a venue registration is complete with status "PENDING_APPROVAL"
    When an administrator reviews and approves the business data
    Then the venue status should transition to "ACTIVE"
    And it should become visible on the public platform

  Scenario: Duplicate Venue Name for Same Partner (Escenario #5)
    Given a partner already has a venue named "Glottia Cafe"
    When they attempt to register another venue with the same name
    Then the system should return a status code 409
    And the response should contain the error message "Ya tienes un local registrado con este nombre"
```

#### `venue_edition.feature` (Relacionado con US11)

\
```gherkin
Feature: Venue Information Edition
  As a Partner
  I want to edit the details of my registered venue
  So that I can keep the information up to date

  Background:
    Given a venue with ID "venue-123" exists and is in "ACTIVE" status

  Scenario: Successful Operating Hours Update (Escenario #1)
    When I send a PUT request to "/api/v1/venues/venue-123" updating the operating hours to "Mon-Fri 8AM-10PM, Sat 9AM-11PM"
    Then the system should return a status code 200
    And the new hours should be reflected immediately in the platform

  Scenario: Capacity Increase (Escenario #2)
    Given the venue expanded its physical space
    When I update the capacity from 30 to 50
    Then the system should return a status code 200
    And the new capacity applies to upcoming encounters without affecting already confirmed reservations

  Scenario: Address Change Requiring Revalidation (Escenario #3)
    When I attempt to change the venue address
    Then the system should return a status code 200
    And the venue status should revert to "PENDING_APPROVAL"
    And an administrator must revalidate the new address

  Scenario: Audit Trail on Edition (Escenario #4)
    Given a venue was edited by a partner
    When an administrator reviews the audit log
    Then they can see who changed what field and when
```

#### `venue_photos.feature` (Relacionado con US12)

\
```gherkin
Feature: Venue Photo Gallery Management
  As a Partner
  I want to upload multiple photos of my venue
  So that I can make it more attractive to learners

  Background:
    Given a venue with ID "venue-123" exists and is active

  Scenario: Successful Photo Gallery Upload (Escenario #1)
    When I send a multipart/form-data POST request to "/api/v1/venues/venue-123/photos" with a set of valid JPG/PNG images (max 10 files, 5MB each)
    Then the system should return a status code 201
    And the photos should be associated to the venue
    And they should be displayed in a carousel on the venue detail page

  Scenario: Photo Reorder and Cover Selection (Escenario #2)
    Given the venue already has uploaded photos
    When I send a PUT request to "/api/v1/venues/venue-123/photos/order" specifying the photo order
    Then the first photo in the list should be set as the cover image

  Scenario: Photo Deletion (Escenario #3)
    When I send a DELETE request to "/api/v1/venues/venue-123/photos/photo-456"
    Then the system should return a status code 200
    And the photo should be removed from the gallery

  Scenario: Oversized File Rejection (Escenario #4)
    When I attempt to upload an image of size 10MB
    Then the system should reject the payload with status code 413
    And return the localized message "Archivo demasiado grande. Máximo 5MB"
```

#### `venue_minimum_consumption.feature` (Relacionado con US13)

\
```gherkin
Feature: Minimum Consumption Configuration
  As a Partner
  I want to optionally define a suggested minimum consumption for attendees
  So that I can ensure economic return from encounters held at my venue

  Background:
    Given a venue with ID "venue-123" exists and is active

  Scenario: Set Minimum Consumption Successfully (Escenario #1)
    When I send a PATCH request to "/api/v1/venues/venue-123" with "minimumConsumption" as 10.00
    Then the system should return a status code 200
    And the minimum consumption amount should appear on all encounter details for this venue

  Scenario: Learner Visibility of Minimum Consumption (Escenario #2)
    Given a venue has a minimum consumption of $10
    When a learner views an encounter scheduled at this venue
    Then the encounter detail page should display "Consumo mínimo sugerido: $10.00"

  Scenario: Update Minimum Consumption (Escenario #3)
    When the partner changes the minimum consumption from $10 to $15
    Then all upcoming encounters should reflect the new value

  Scenario: Disable Minimum Consumption (Escenario #4)
    When the partner sets "minimumConsumption" to 0 or null
    Then the encounters at this venue should no longer display a minimum consumption notice
```

#### `partner_venue_registry.feature` (Relacionado con US10 — Registro de Partner)

\
```gherkin
Feature: Partner Venue Registry Management
  As a Partner
  I want to manage the association between my account and my venues
  So that I can control which venues are active on the platform

  Background:
    Given a registered partner with ID "partner-123"

  Scenario: Register Venue Under Partner (Escenario #1)
    When I send a POST request to "/api/v1/partner-venue-registries/partner-123/venues" with valid venue data
    Then the system should return a status code 200
    And the venue should be linked to the partner's registry

  Scenario: List Partner Venues (Escenario #2)
    When I send a GET request to "/api/v1/partner-venue-registries/partner-123/venues?active=true"
    Then the system should return a status code 200
    And the response should contain a list of active venues for that partner

  Scenario: Deactivate Venue from Partner Registry (Escenario #3)
    When I send a DELETE request to "/api/v1/partner-venue-registries/partner-123/venues/venue-123" with deactivation details
    Then the system should return a status code 200
    And the venue should be removed from the partner's active venues list

  Scenario: Reactivate Venue in Partner Registry (Escenario #4)
    Given a venue was previously deactivated
    When I send a POST request to "/api/v1/partner-venue-registries/partner-123/venues/venue-123/activations"
    Then the system should return a status code 200
    And the venue should become active again in the partner's registry
```

#### `venue_dashboard.feature` (Relacionado con US14)

\
```gherkin
Feature: Partner Venue Dashboard
  As a Partner
  I want to access a summary of my venue activity
  So that I can quickly understand how many encounters have taken place and how many people attended

  Background:
    Given a partner with ID "partner-123" and an active venue "venue-123"

  Scenario: Key Metrics Visualization (Escenario #1)
    When I send a GET request to "/api/v1/venues/venue-123/encounter-statistics"
    Then the system should return a status code 200
    And the response should contain total encounters, total attendees, and average rating

  Scenario: Trend Analysis (Escenario #2)
    When I request detailed statistics with parameters "month" as 5, "year" as 2026, and "lastDays" as 30
    Then the system should return a status code 200
    And the response should include encounter frequency trends and attendance patterns

  Scenario: Dashboard with No Recent Activity (Escenario #3)
    Given the venue has no encounters in the requested period
    When I request encounter statistics
    Then the response should indicate zero activity with appropriate empty state
```

***

### Promotions Microservice Testing Suite

A continuación, se detallan las especificaciones Gherkin enfocadas en validar la gestión de promociones y ofertas especiales para aprendices según su nivel de lealtad dentro del microservicio Promotions.

#### `promotion_management.feature` (Relacionado con US34)

\
```gherkin
Feature: Promotion Management
  As a platform administrator
  I want to create and manage promotions
  So that partners can offer special deals to loyal learners

  Background:
    Given the promotions API endpoint "/api/v1/promotions" is available

  Scenario: Create Promotion Successfully (Escenario #1)
    When I send a POST request with valid promotion data including "title" as "15% Off Drinks", "description", "discountPercentage" as 15, "validFrom" and "validUntil" dates
    Then the system should return a status code 201
    And the promotion should be created with status "ACTIVE"

  Scenario: List Active Promotions (Escenario #2)
    When I send a GET request to "/api/v1/promotions?active=true"
    Then the system should return a status code 200
    And the response should contain only currently active promotions

  Scenario: Get Promotion by ID (Escenario #3)
    When I send a GET request to "/api/v1/promotions/promo-123"
    Then the system should return a status code 200
    And the response should contain the full promotion details

  Scenario: Update Promotion Details (Escenario #4)
    When I send a PATCH request to "/api/v1/promotions/promo-123" updating the "discountPercentage" to 20
    Then the system should return a status code 200
    And the promotion should reflect the new discount value

  Scenario: Deactivate Promotion (Escenario #5)
    When I send a PATCH request to "/api/v1/promotions/promo-123/deactivation"
    Then the system should return a status code 204
    And the promotion should no longer be available for redemption
```

#### `promotion_redemption.feature` (Relacionado con US34)

\
```gherkin
Feature: Promotion Redemption
  As a loyal learner
  I want to redeem promotions at partner venues
  So that I can receive rewards for my participation

  Background:
    Given a learner with ID "learner-123" has reached loyalty level "ORO"
    And a promotion "promo-123" exists and is active

  Scenario: Successful Promotion Redemption (Escenario #1)
    When I send a POST request to "/api/v1/promotions/promo-123/redeem?venueId=venue-123"
    Then the system should return a status code 200
    And the response should contain a unique redemption code
    And the redemption should be logged in the promotion history

  Scenario: Redemption of Expired Promotion (Escenario #2)
    Given the promotion "promo-123" has passed its "validUntil" date
    When I attempt to redeem it
    Then the system should return a status code 400
    And the response should indicate that the promotion has expired

  Scenario: Redemption at Non-Associated Venue (Escenario #3)
    Given the promotion "promo-123" is only associated with "venue-123"
    When I attempt to redeem it at "venue-456"
    Then the system should return a status code 400
    And the response should indicate that the promotion is not valid at that venue
```

#### `venue_promotion_link.feature` (Relacionado con US34)

\
```gherkin
Feature: Venue Promotion Association
  As a platform administrator
  I want to associate promotions to specific venues
  So that learners can redeem offers at participating locations

  Background:
    Given a venue with ID "venue-123" exists and is active
    And a promotion with ID "promo-123" exists and is active

  Scenario: Associate Promotion to Venue (Escenario #1)
    When I send a POST request to "/api/v1/venues/venue-123/promotions" with valid association data
    Then the system should return a status code 201
    And the promotion should be linked to the venue

  Scenario: List Venue Promotions (Escenario #2)
    When I send a GET request to "/api/v1/venues/venue-123/promotions?active=true&expired=false"
    Then the system should return a status code 200
    And the response should contain promotions associated with that venue

  Scenario: List Redeemable Promotions for Venue (Escenario #3)
    When I send a GET request to "/api/v1/venues/venue-123/promotions/redeemable"
    Then the system should return a status code 200
    And the response should contain promotions currently available for redemption at that venue

  Scenario: Disassociate Promotion from Venue (Escenario #4)
    When I send a DELETE request to "/api/v1/venues/venue-123/promotions/vpromo-456"
    Then the system should return a status code 204
    And the promotion should no longer be available at that venue

  Scenario: Toggle Promotion Activation at Venue (Escenario #5)
    When I send a PATCH request to "/api/v1/venues/venue-123/promotions/vpromo-456" with toggle data
    Then the system should return a status code 200
    And the promotion activation status at that venue should be toggled
```

***

### Learning Feedback Microservice Testing Suite

A continuación, se presentan las especificaciones Gherkin orientadas a validar el flujo de feedback de encuentros, incluyendo autoevaluación, coevaluación y quizzes generados por IA dentro del microservicio Learning Feedback.

#### `self_assessment.feature` (Relacionado con US25)

\
```gherkin
Feature: Self-Assessment Submission
  As a learner who attended an encounter
  I want to submit a self-assessment of my fluency
  So that I can track my language progress over time

  Background:
    Given the feedback API endpoint "/api/v1/feedback/self-assessment" is available
    And a learner with ID "learner-123" exists

  Scenario: Successful Self-Assessment Submission (Escenario #1)
    When I send a POST request with valid self-assessment data including "encounterId", "learnerId", and "fluencyScore" dimensions
    Then the system should return a status code 201
    And the response should contain the updated fluency score for the learner

  Scenario: Get Fluency Score (Escenario #2)
    When I send a GET request to "/api/v1/feedback/fluency-score/learner-123"
    Then the system should return a status code 200
    And the response should contain the learner's current fluency score and historical progression

  Scenario: List Self-Assessments by Learner (Escenario #3)
    When I send a GET request to "/api/v1/feedback/self-assessments/learner-123"
    Then the system should return a status code 200
    And the response should contain a list of all self-assessments submitted by that learner
```

#### `peer_feedback.feature` (Relacionado con US25)

\
```gherkin
Feature: Peer Feedback Submission
  As a learner who attended an encounter
  I want to submit feedback about my conversation partner
  So that the community can maintain quality interactions

  Background:
    Given the feedback API endpoint "/api/v1/feedback/peer" is available

  Scenario: Successful Peer Feedback Submission (Escenario #1)
    When I send a POST request with valid peer feedback data including "encounterId", "reviewerId", "targetLearnerId", and rating
    Then the system should return a status code 201
    And the feedback should be recorded for the target learner

  Scenario: Duplicate Peer Feedback Prevention (Escenario #2)
    Given I have already submitted feedback for learner "learner-456" on encounter "encounter-789"
    When I attempt to submit another feedback for the same learner and encounter
    Then the system should return a status code 409
    And the response should indicate that feedback was already submitted

  Scenario: Self-Feedback Prevention (Escenario #3)
    When I attempt to submit feedback targeting myself
    Then the system should return a status code 400
    And the response should indicate that self-feedback is not allowed via this endpoint
```

#### `quiz_management.feature` (Relacionado con US25 — Engagement Quiz)

\
```gherkin
Feature: Quiz Generation and Answering
  As a learner
  I want to receive and answer engagement quizzes after encounters
  So that I can reinforce my language learning

  Background:
    Given the quiz endpoint "/api/v1/feedback/quiz" is available

  Scenario: Get Quiz by ID (Escenario #1)
    When I send a GET request to "/api/v1/feedback/quiz/quiz-123"
    Then the system should return a status code 200
    And the response should contain the quiz questions and options

  Scenario: Get Quiz for Encounter and Learner (Escenario #2)
    When I send a GET request to "/api/v1/feedback/encounters/encounter-789/learners/learner-123/quiz"
    Then the system should return a status code 200
    And the response should contain a quiz generated specifically for that encounter and learner

  Scenario: Submit Quiz Answers Successfully (Escenario #3)
    When I send a POST request to "/api/v1/feedback/quiz/quiz-123/answer" with my selected answers
    Then the system should return a status code 200
    And the response should contain the quiz result including score and correct answers

  Scenario: Get Pending Quizzes for Learner (Escenario #4)
    When I send a GET request to "/api/v1/feedback/quiz/pending/learner-123"
    Then the system should return a status code 200
    And the response should contain a list of quizzes pending completion for that learner

  Scenario: Re-answering Prevention (Escenario #5)
    Given I have already answered quiz "quiz-123"
    When I attempt to submit answers again
    Then the system should return a status code 409
    And the response should indicate that the quiz was already completed
```

***

### Engagement Microservice Testing Suite

A continuación, se detallan las especificaciones Gherkin diseñadas para validar el sistema de gamificación y lealtad del microservicio Engagement, incluyendo puntos, insignias, leaderboard y rachas.

#### `loyalty_points.feature` (Relacionado con US29 y US30)

\
```gherkin
Feature: Loyalty Points Accumulation and Tracking
  As a learner
  I want to earn loyalty points for attending encounters and track my balance
  So that I can be rewarded for my active participation

  Background:
    Given the loyalty API endpoint "/api/v1/loyalty-accounts" is available
    And a learner with ID "learner-123" exists

  Scenario: Automatic Points Accumulation on Check-in (Escenario #1)
    Given a learner completed check-in for an encounter
    When the system processes the attendance
    Then the learner's loyalty account should be credited with +10 base points
    And the transaction should be recorded in the points history

  Scenario: View Points Balance and Level (Escenario #2)
    When I send a GET request to "/api/v1/loyalty-accounts/learner-123"
    Then the system should return a status code 200
    And the response should contain the total points, current level (e.g., "ORO"), and progress to next level

  Scenario: View Points History (Escenario #3)
    When I send a GET request to "/api/v1/loyalty-accounts/learner-123/history?page=0&size=20"
    Then the system should return a status code 200
    And the response should contain a paginated list of all point transactions

  Scenario: Bonus Points for First Encounter in New Language (Escenario #4)
    Given a learner attends their first French encounter
    When the check-in is processed
    Then the learner should receive base points +5 bonus points for exploring a new language

  Scenario: Referral Points (Escenario #5)
    Given a new learner registered using referral code of learner "learner-123"
    When the referred learner completes their first encounter
    Then both the referrer and the referred learner should receive +15 referral bonus points
```

#### `badges_unlock.feature` (Relacionado con US31 y US32)

\
```gherkin
Feature: Badge Unlocking and Display
  As a learner
  I want to unlock badges when I reach certain milestones
  So that I can feel a sense of achievement and display my progress

  Background:
    Given the badges endpoint "/api/v1/badges" is available
    And a learner with ID "learner-123" exists

  Scenario: Automatic Badge Unlock on Milestone (Escenario #1)
    Given a learner has attended 5 French encounters
    When the 5th encounter check-in is processed
    Then the system should detect the milestone
    And unlock the "Francófilo" badge for the learner
    And send a celebratory notification

  Scenario: View Unlocked Badges (Escenario #2)
    When I send a GET request to "/api/v1/badges/learner/learner-123"
    Then the system should return a status code 200
    And the response should contain a list of all unlocked badges with name, description, and unlock date

  Scenario: Badges Visible on Public Profile (Escenario #3)
    Given another learner views the public profile of learner-123
    When the profile loads
    Then the unlocked badges section should be visible with tooltip on hover showing description

  Scenario: Monthly Challenge Badge (Escenario #4)
    Given a new month starts with a challenge "Attend 10 encounters this month"
    When the learner completes the challenge
    Then the system should award the monthly badge "Viajero del Mes"
    And the badge should appear in the learner's collection
```

#### `leaderboard.feature` (Relacionado con US33)

\
```gherkin
Feature: Learner Leaderboard
  As a learner
  I want to see my ranking compared to other learners
  So that I can engage in friendly competition within the community

  Background:
    Given the leaderboard endpoint "/api/v1/leaderboard" is available

  Scenario: View Global Leaderboard (Escenario #1)
    When I send a GET request to "/api/v1/leaderboard?limit=10"
    Then the system should return a status code 200
    And the response should contain the top 10 learners ranked by total points
    And my own position should be highlighted if I am in the top 100

  Scenario: Filter Leaderboard by Period (Escenario #2)
    When I apply a filter for "last month" points
    Then the leaderboard should recalculate showing only points earned in that period
    And the ranking should reflect recent activity

  Scenario: Friends-Only Leaderboard (Escenario #3)
    Given I have contacts in the platform
    When I activate the "My Contacts" filter
    Then the leaderboard should display only my connections ranked by points

  Scenario: Top 10 Ranking Badge (Escenario #4)
    Given a learner reaches the Top 10 position
    When the leaderboard is updated
    Then the learner should be awarded the special badge "Top 10 Del Mes"
```

#### `loyalty_streak.feature` (Relacionado con US35)

\
```gherkin
Feature: Attendance Streak Management
  As a learner
  I want the system to track my weekly attendance streak
  So that I stay motivated to participate consistently

  Background:
    Given a learner with ID "learner-123" has a loyalty account

  Scenario: Streak Counter Visible on Profile (Escenario #1)
    When I send a GET request to "/api/v1/loyalty-accounts/learner-123"
    Then the response should include a "streak" field showing "8 encuentros en 8 semanas" with a visual fire indicator

  Scenario: Streak Reset After Missed Week (Escenario #2)
    Given a learner had an active streak
    When a full week passes without attending any encounter
    Then the streak counter should reset to 0

  Scenario: Motivational Notification at Risk (Escenario #3)
    Given a learner has an active streak of 7 weeks
    When there are 2 days left in the current week without attendance
    Then the system should send a push notification: "Tienes racha de 7 semanas - ¡No la rompas! Hay 5 encuentros disponibles"

  Scenario: Streak Milestone Reward (Escenario #4)
    Given a learner reaches 12 consecutive weeks of attendance
    When the milestone is detected
    Then the system should award the badge "Adicto al Aprendizaje"
    And grant +50 bonus points
```

#### 5.2.2.4 Execution Evidence for Sprint Review



#### 5.2.2.5 Microservices Documentation Evidence for Sprint Review
### Swagger/OpenAPI Documentation Evidence

La documentación de los Web Services para los microservicios del Sprint 2 fue desarrollada utilizando **OpenAPI/Swagger** mediante **SpringDoc**, permitiendo definir formalmente los endpoints REST, parámetros de entrada, estructuras de request/response y códigos HTTP soportados.

A continuación, se presentan las capturas de la interfaz Swagger UI correspondientes a cada microservicio desplegado.

---

#### Swagger Evidence — Venues Microservice

La documentación Swagger/OpenAI para el microservicio Venues expone los controladores responsables de la gestión de locales, mesas, disponibilidad y registros de partner.

![](assets/img/cap5/venues-swagger.png)

*Figura X. Vista general de la especificación OpenAPI del microservicio Venues, mostrando los endpoints para gestión de locales, mesas y registro de partners.*

---

#### Swagger Evidence — Promotions Microservice

La documentación Swagger/OpenAPI para el microservicio Promotions cubre la creación, asociación a venues y canje de promociones.

![](assets/img/cap5/promotions-swagger.png)

*Figura Y. Interfaz Swagger UI del microservicio Promotions, detallando los endpoints para administración de promociones y su vinculación con locales.*

---

#### Swagger Evidence — Learning Feedback Microservice

La documentación Swagger/OpenAPI para el microservicio Learning Feedback expone los endpoints de autoevaluación, coevaluación y quizzes generados por IA.

![](assets/img/cap5/feedback-swagger.png)

*Figura Z. Panel Swagger UI del microservicio Learning Feedback, listando los controladores para gestión de feedback y quizzes.*

---

#### Swagger Evidence — Engagement Microservice

La documentación Swagger/OpenAPI para el microservicio Engagement expone los endpoints de cuentas de lealtad, insignias y leaderboard.

![](assets/img/cap5/engagement-swagger.png)

*Figura W. Interfaz Swagger UI del microservicio Engagement, mostrando los endpoints para el sistema de gamificación y lealtad.*

---


#### 5.2.2.6 Software Deployment Evidence for Sprint Review
#### 5.2.2.7 Team Collaboration Insights during Sprint
#### 5.2.2.8 Kanban Board --> (Avance 3)
\
![Sprint 2 Kanban Board](assets/img/cap5/Sprint2KanbanBoard-part1.png)
\
![Sprint 2 Kanban Board](assets/img/cap5/Sprint2KanbanBoard-part2.png)
\
![Sprint 2 Kanban Board](assets/img/cap5/Sprint2KanbanBoard-part3.png)
\
![Sprint 2 Kanban Board](assets/img/cap5/Sprint2KanbanBoard-part4.png)
\
[Ver Sprint 2 Kanban Board en Jira](https://fundamentos.atlassian.net/jira/software/projects/HGS1/boards/34?atlOrigin=eyJpIjoiZmQ3NjkyODgyMzNkNDA1OTk1N2RlZjU5MDYyOWQyMWYiLCJwIjoiaiJ9)