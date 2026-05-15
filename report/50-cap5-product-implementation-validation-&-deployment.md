# Capítulo V: Product Implementation, Validation & Deployment

## 5.1 Testing Suites & General Patterns

### 5.1.1 Backend Application Core Testing Suite

### 5.1.2 Pattern Based Backend Application(s)

### 5.1.3 Pattern Based Custom Software Library

### 5.1.4 Framework Pattern Driven Refactoring Report

## 5.2 Software Configuration Management

Software Configuration Management (SCM) —o Gestión de la Configuración de Software— es una disciplina de la ingeniería de software que se encarga de rastrear, controlar y organizar todos los cambios que ocurren en el ciclo de vida de un proyecto.

Su objetivo principal es asegurar que, sin importar cuántas personas estén trabajando en el proyecto o cuántas funciones nuevas se agreguen, el software se mantenga estable, consistente y libre de caos. (GeeksforGeeks, 2025)
---
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

---

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
#### 5.2.1.3 Testing Suite Evidence for Sprint Review
#### 5.2.1.4 Execution Evidence for Sprint Review

El Sprint 1 del proyecto Glottia, ejecutado durante dos semanas por el equipo Hampcoders, tuvo como objetivo principal iniciar la migración del backend de una arquitectura monolito modular hacia microservicios independientes, abarcando los bounded contexts de IAM, Profiles y Encounters, al mismo tiempo que se implementaban las funcionalidades base de la plataforma y se atendían mejoras y correcciones en la aplicación móvil Flutter. En cuanto a la migración, se logró extraer y dockerizar el servicio de IAM con su propia base de datos, se avanzó en la separación del servicio de Encounters con la configuración de su schema independiente y sus integraciones hacia Venues y Profiles, y se inició la configuración del API Gateway como punto de entrada único para todos los microservicios. En el frente funcional, se completaron las historias de usuario correspondientes al ciclo de autenticación completo (registro de aprendiz y partner, inicio y cierre de sesión), el perfil base del aprendiz, y el flujo de check-in en encuentros. En paralelo, el equipo de mobile resolvió los bugs críticos de crash en el registro y persistencia de sesión, además de entregar el rediseño de la pantalla home. Como trabajo pendiente para el siguiente sprint quedan la separación completa de Profiles y Encounters como microservicios autónomos, la historia US05 recuperación de contraseña y un bugfix en el cierre de sesión.

### Web UI Evidence
![Dashboard](assets/img/cap5/Web-UI-Execution-Evidence1.png)

\

![Promotions](assets/img/cap5/Web-UI-Evidence-2.png)

\

![Analytics](assets/img/cap5/Web-UI-Evidence-3.png)

### Mobile UI Fixes Evidence
![Learner Homepage](assets/img/cap5/Learner-Homepage.jpeg)

\

![Partners Section Update](assets/img/cap5/Partners-Section-Update.jpeg)

### Endpoints Execution Evidence

![](assets/img/cap5/Postman1.jpeg)
\
![](assets/img/cap5/Postman2.jpeg)
\
![](assets/img/cap5/Postman3.jpeg)
\
![](assets/img/cap5/Postman4.jpeg)
\
![](assets/img/cap5/Postman5.jpeg)
\
![](assets/img/cap5/Postman6.jpeg)
\
![](assets/img/cap5/Postman7.jpeg)

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
| `/api/v1/auth/register` | POST | Registro de nuevos usuarios |
| `/api/v1/auth/login` | POST | Inicio de sesión |
| `/api/v1/auth/refresh-token` | POST | Renovación de token JWT |
| `/api/v1/auth/logout` | POST | Cierre de sesión |

#### Swagger Evidence — IAM

La imagenes a continuacion muestran la documentación Swagger/OpenAPI correspondiente a los endpoints del microservicio IAM.


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
| `/api/v1/encounters` | POST | Crear encounter |
| `/api/v1/encounters/search` | GET | Buscar encounters |
| `/api/v1/encounters/search-simple` | GET | Búsqueda simplificada |
| `/api/v1/encounters/{encounterId}` | GET | Obtener encounter |
| `/api/v1/encounters/{encounterId}/start` | POST | Iniciar encounter |
| `/api/v1/encounters/{encounterId}/complete` | POST | Completar encounter |
| `/api/v1/encounters/{encounterId}/attendances` | POST | Registrar asistencia |
| `/api/v1/encounters/{encounterId}/attendances/check-in` | POST | Realizar check-in |
| `/api/v1/encounters/{encounterId}/attendances/me` | DELETE | Cancelar asistencia |
| `/api/v1/encounters/{encounterId}` | DELETE | Cancelar encounter |

#### Swagger Evidence — Encounters

La imagenes a continuacion muestran la documentación Swagger/OpenAPI correspondiente a los endpoints del microservicio Encounters.

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
| `/api/v1/profiles` | GET | Obtener todos los perfiles |
| `/api/v1/profiles/{id}` | GET | Obtener perfil por ID |
| `/api/v1/profiles` | POST | Crear nuevo perfil |
| `/api/v1/profiles/{id}` | PUT | Actualizar perfil |
| `/api/v1/profiles/{id}` | DELETE | Eliminar perfil |
| `/api/v1/profiles/search` | GET | Buscar perfil por email |
| `/api/v1/profiles/{profileId}/learner/languages` | POST | Agregar idioma |
| `/api/v1/profiles/{profileId}/learner/languages/{languageId}` | PUT | Actualizar idioma |
| `/api/v1/profiles/{id}/learner/languages/{languageId}` | DELETE | Eliminar idioma |


#### Swagger Evidence — Profiles

La imagenes a continuacion muestran la documentación Swagger/OpenAPI correspondiente a los endpoints del microservicio Profiles.

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