# Capítulo V: Product Implementation, Validation & Deployment

## 5.1 Testing Suites & General Patterns

### 5.1.1 Backend Application Core Testing Suite

### 5.1.2 Pattern Based Backend Application(s)

### 5.1.3 Pattern Based Custom Software Library

### 5.1.4 Framework Pattern Driven Refactoring Report

## 5.2 Software Configuration Management

### 5.2.1 Software Development Environment Configuration

### 5.2.2 Source Code Management

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

#### 5.2.1.5 Microservices Documentation Evidence for Sprint Review
#### 5.2.1.6 Software Deployment Evidence for Sprint Review
#### 5.2.1.7 Team Collaboration Insights during Sprint
#### 5.2.1.8 Kanban Board --> TP1

\
![Sprint 1 Kanban Board](assets/img/cap5/Glottia-Sprint1-KanbanBoard.jpeg)
\
[Ver Sprint 1 Kanban Board en Jira](https://fundamentos.atlassian.net/jira/software/projects/HGS1/boards/34?atlOrigin=eyJpIjoiMDFiMTg2M2NkNTA3NDJjZDllZTQ3ZTlhNDU5MmNjMjUiLCJwIjoiaiJ9)