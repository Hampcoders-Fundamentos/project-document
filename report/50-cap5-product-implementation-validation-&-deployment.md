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
\

El backend modular y la subsiguiente arquitectura de microservicios de Glottia han sido desarrollados aplicando patrones de diseño de software y patrones arquitectónicos avanzados basados en **Domain-Driven Design (DDD)** y **Clean Architecture**. La validación mediante pruebas automatizadas en esta sección se estructura bajo estos patrones para garantizar la escalabilidad, la mantenibilidad y el aislamiento de fallas en el ecosistema:

#### 5.1.2.1 Arquitectura General
\

La arquitectura general sigue el patrón **Hexagonal (Ports & Adapters)** y **Clean Architecture** combinado con **CQRS (Command Query Responsibility Segregation)**. Cada microservicio organiza su código en cuatro capas bien definidas:
- **Capa de Interfaces** : constituye los adaptadores de entrada, incluyendo controladores REST (expuestos al mundo exterior) y las interfaces ACL (Anti-Corruption Layer) que publica cada contexto para que otros bounded contexts puedan consumirlo de manera controlada.
- **Capa de Aplicación** : orquesta los casos de uso. Contiene los servicios de comando (escritura), servicios de consulta (lectura), manejadores de eventos, e implementaciones de las fachadas ACL. Es responsable de las transacciones y la coordinación entre el dominio y la infraestructura.
- **Capa de Dominio** : el núcleo del negocio. Contiene los aggregates raíz, entidades owned, objetos de valor, comandos, consultas, eventos de dominio e interfaces de servicio. Esta capa no tiene dependencias con frameworks externos.
- **Capa de Infraestructura** : adaptadores de salida. Incluye repositorios JPA, clientes Feign para comunicación entre servicios, configuración de seguridad con OAuth2 Resource Server, configuración de RabbitMQ, e implementaciones del patrón Transactional Outbox para mensajería confiable.

Tres servicios transversales complementan la arquitectura: un **API Gateway** (Spring Cloud Gateway) que actúa como punto único de entrada, un **Service Registry** (Netflix Eureka) para descubrimiento de servicios, y un **Config Service** para configuración compartida. La comunicación asíncrona entre bounded contexts se realiza mediante **RabbitMQ**, utilizando el patrón Transactional Outbox para garantizar la entrega confiable de eventos.


#### 5.1.2.2 Mapa de Microservicios
\


La plataforma se compone de los siguientes microservicios, clasificados según su rol dentro de la estrategia DDD:

##### Servicios de Infraestructura

| Microservicio | Puerto | Propósito |
|---|---|---|
| **glottia-gateway-service** | 8081 | Punto único de entrada basado en Spring Cloud Gateway. Valida tokens JWT en las peticiones entrantes, extrae los claims de seguridad y los reenvía como encabezados HTTP a los microservicios internos, y agrega las rutas de documentación OpenAPI de todos los servicios. |
| **glottia-discovery-service** | 8761 | Servicio de registro y descubrimiento basado en Netflix Eureka Server. Todos los microservicios se registran en este servicio al iniciar, permitiendo la comunicación mediante nombres lógicos en lugar de direcciones físicas. |
| **glottia-config-service** | 8082 | Servicio de configuración centralizada que proporciona beans compartidos de OpenAPI, CORS, Jackson y Caffeine cache a todos los microservicios. |

##### Bounded Contexts de Tipo Genérico

| Microservicio | Puerto | Propósito |
|---|---|---|
| **glottia-iam-service** | 8083 | Gestiona la autenticación, registro de usuarios, generación y validación de tokens JWT, y roles de acceso (USER, ADMIN, SUPERADMIN, SUPPORT). Es el contexto del que dependen todos los demás para la seguridad. |

##### Bounded Contexts de Tipo Soporte

| Microservicio | Puerto | Propósito |
|---|---|---|
| **glottia-profiles-service** | 8084 | Administra los perfiles de usuarios (Learner y Partner), incluyendo idiomas nativos y meta, niveles CEFR, disponibilidad, y roles de negocio (LEARNER/PARTNER). |
| **glottia-feedback-service** | 8089 | Proporciona mecanismos de evaluación post-encuentro: autoevaluación del aprendiz, retroalimentación anónima entre pares, y quizzes generados por inteligencia artificial (LLM) para reforzar el aprendizaje. |
| **glottia-analytics-service** | 8090 | Pendiente de implementación completa. Proveerá KPIs y reportes mensuales para partners y administradores. |
| **glottia-verification-service** | 8091 | Genera y verifica códigos OTP (One-Time Password) para procesos como verificación de email, reseteo de contraseña y confirmación de check-in. |
| **glottia-notification-service** | 8092 | Orquesta el envío de notificaciones multicanal: email mediante SendGrid, notificaciones push mediante Firebase Cloud Messaging, SMS mediante Twilio, y notificaciones in-app. |

##### Bounded Contexts de Tipo Core

| Microservicio | Puerto | Propósito |
|---|---|---|
| **glottia-venues-service** | 8085 | Gestiona el ciclo de vida completo de los locales aliados (venues), incluyendo su registro, mesas, disponibilidad horaria, y la vinculación con los partners propietarios. |
| **glottia-promotions-service** | 8086 | Administra el catálogo de promociones (descuentos porcentuales, cortesías, 2x1), su vigencia, stock disponible para canje, y la asociación a uno o múltiples venues. |
| **glottia-encounters-service** | 8087 | Corazón operativo de la plataforma. Gestiona la creación de encuentros, matchmaking entre aprendices, reserva de cupo, check-in mediante QR, y la máquina de estados del encuentro (borrador, publicado, listo, en progreso, completado, cancelado). |
| **glottia-engagement-service** | 8088 | Sistema de gamificación que gestiona la acumulación de puntos, el desbloqueo de insignias (badges), el leaderboard por niveles CEFR, y el canje de puntos por promociones. |


#### 5.1.2.3 Patrones Arquitectónicos
\


##### Hexagonal Architecture (Ports & Adapters)
\


Todos los microservicios implementan el patrón de Arquitectura Hexagonal, donde el núcleo de dominio permanece aislado de los detalles técnicos. Los puertos de entrada son las interfaces de servicio definidas en la capa de dominio (`domain/services/`), mientras que los adaptadores de entrada son los controladores REST y los listeners de RabbitMQ en la capa de interfaces. Los puertos de salida son las interfaces de repositorio y servicios externos definidos en la capa de aplicación, mientras que los adaptadores de salida son las implementaciones JPA, Feign, y de mensajería en la capa de infraestructura.

##### Domain-Driven Design (DDD) Táctico
\


Cada bounded context implementa los patrones tácticos de DDD de manera consistente: *aggregates* raíz que encapsulan invariantes de negocio y publican eventos de dominio, *entidades* owned con identidad propia dentro del aggregate, *objetos de valor* inmutables representados como *records* de Java, y *eventos de dominio* que notifican ocurrencias significativas del negocio.

##### Command Query Responsibility Segregation (CQRS)
\


La separación entre operaciones de comando (escritura) y consulta (lectura) es explícita en todos los microservicios. Los comandos y consultas son objetos inmutables (*records* de Java) ubicados en paquetes separados (`commands/` y `queries/`). Los servicios de comando están anotados con `@Transactional` para garantizar la integridad de las escrituras, mientras que los servicios de consulta usan `@Transactional(readOnly = true)` para optimizar el rendimiento de las lecturas.

##### Event-Driven Architecture
\


La comunicación asíncrona entre bounded contexts se realiza mediante eventos de dominio. Los aggregates registran eventos mediante el mecanismo provisto por Spring Data (`AbstractAggregateRoot.registerEvent()`), que son capturados por el **Transactional Outbox Bridge** y persistidos en la base de datos dentro de la misma transacción. Un proceso scheduleado (Outbox Relay) publica estos eventos en RabbitMQ, garantizando entrega confiable. Los microservicios consumidores escuchan estos eventos mediante `@RabbitListener`.

##### Microservices Architecture
\


Cada bounded context es un microservicio independiente con su propio proceso JVM, su propio esquema de base de datos PostgreSQL, y su propio pipeline de despliegue. La comunicación síncrona entre servicios se realiza mediante clientes Feign (HTTP) protegidos por un interceptor que añade un encabezado de autenticación interna. La comunicación asíncrona se realiza mediante RabbitMQ.


##### 5.1.3 Pattern Based Custom Software Library
\


Para resolver necesidades transversales dentro del ecosistema de Glottia (*Cross-Cutting Concerns*) y evitar la duplicidad de código (*Don't Repeat Yourself - DRY*), el equipo diseñó y aisló librerías de software personalizadas internas. Estas librerías se rigen estrictamente por los principios **SOLID** y cuentan con especificaciones de prueba aisladas para garantizar su reutilización segura:

* **Custom JWT Authentication Security Library:** Módulo personalizado encargado de la generación, firma asimétrica y validación criptográfica de tokens JSON Web Tokens (JWT). Las pruebas en esta librería aseguran la correcta decodificación de *claims* de usuario (tales como ID y roles) y la detección inmediata de firmas expiradas o alteradas.
* **Crypto Guard Engine (BCrypt Wrapper):** Componente dedicado a la seguridad adaptativa de datos sensibles mediante algoritmos de hash unidireccionales de alto costo computacional. Se utiliza para el cifrado seguro (*salting* y *hashing*) de contraseñas durante el registro e inicio de sesión, impidiendo el almacenamiento de texto plano en la base de datos.
* **Custom Cloud Storage & Media Curation Library:** Utilizada de manera transversal por el microservicio de perfiles para interactuar de forma segura con APIs de almacenamiento de objetos en la nube (ej. Amazon S3 o Cloudinary). Esta librería procesa flujos de datos *multipart/form-data*, valida las restricciones de peso (máximo 5MB) y dimensiones, y realiza la curación de imágenes de los avatares de usuario. Sus pruebas de aceptación validan el rechazo de extensiones de archivos no permitidas (ej. ejecutables maliciosos).


#### 5.1.2.4 Patrones Creacionales
\


##### Factory Method
\


El patrón **Factory Method** se utiliza extensivamente en los objetos de valor y aggregates para encapsular la lógica de creación. Cada identificador tipado (como `UserId`, `EncounterId`, `VenueId`, `ProfileId`, `EngagementId`) proporciona un método estático `newInstance()` o `newId()` que genera identificadores únicos basados en UUID con prefijos semánticos (ej. `us-` para usuarios, `en-` para encuentros, `vn-` para venues). Los aggregates raíz también implementan métodos de fábrica estáticos, como `User.create()`, que validan los invariantes de creación antes de instanciar el aggregate.

##### Static Factory
\


Además de los Factory Methods, los objetos de valor proporcionan métodos `of()` y `fromValue()` para crear instancias a partir de valores existentes, con validación incorporada en los constructores *compactos* de los *records* de Java. Las entidades de catálogo (como `PromotionType`, `Language`, `CEFRLevel`) proporcionan métodos estáticos `toEntityFromName()` para realizar búsquedas y conversiones.

##### Singleton
\


Todos los componentes gestionados por Spring (`@Service`, `@Repository`, `@Component`, `@Controller`) son *singletons* por defecto, garantizando una única instancia por contenedor de Spring. El contenedor gestiona el ciclo de vida completo de estos objetos.


#### 5.1.2.5 Patrones Estructurales
\


##### Adapter (Ports & Adapters)
\


El patrón **Adapter** es fundamental en la arquitectura. Las interfaces definidas en la capa de aplicación (`application/internal/outboundservices/`) actúan como puertos de salida, mientras que las implementaciones concretas en la capa de infraestructura (`infrastructure/`) actúan como adaptadores. Ejemplos: la interfaz `TokenService` (puerto) es implementada por `TokenServiceImpl` que utiliza la librería JJWT (adaptador); la interfaz `HashingService` es implementada por `HashingServiceImpl` que utiliza BCrypt.

##### Facade (ACL)
\


Cada bounded context publica una interfaz **Facade** en `interfaces/acl/` que proporciona una API simplificada para que otros contextos consuman sus servicios sin conocer los detalles internos. Por ejemplo, `VenuesContextFacade` expone operaciones como `isVenueActive()` y `findAvailableTableAtTime()` que encapsulan toda la lógica de negocio del contexto Venues. La implementación reside en `application/acl/`, manteniendo el aislamiento entre bounded contexts.

##### Bridge
\


El patrón **Bridge** se observa en la implementación del Transactional Outbox. Cada microservicio extiende clases abstractas definidas en `glottia-commons`: `DomainEventToOutboxBridge<E>` y `OutboxRelay<E>`. La abstracción (el "puente") separa la lógica de persistencia de eventos de su publicación en RabbitMQ, permitiendo que cada servicio concrete los detalles específicos (como la resolución de routing keys y la entidad de outbox) sin modificar el algoritmo general.

##### Proxy (Feign Clients)
\


Los clientes **Feign** actúan como proxies declarativos para la comunicación HTTP entre microservicios. Interfaces como `ProfilesIntegrationClient`, `EncountersIntegrationClient`, y `VenuesIntegrationClient` definen los endpoints remotos mediante anotaciones, y Spring Cloud genera dinámicamente la implementación del proxy que realiza las peticiones HTTP reales.


#### 5.1.2.6 Patrones de Comportamiento
\


##### Strategy
\


El patrón **Strategy** se implementa en dos áreas clave:

1. **Proveedores de LLM** en el servicio de Feedback: una interfaz `LlmService` define el contrato para generar quizzes, con tres implementaciones intercambiables mediante configuración: `AnthropicLlmServiceImpl` (Claude), `GeminiLlmServiceImpl` (Gemini), y `OpenAiLlmServiceImpl` (GPT-4). La estrategia activa se selecciona mediante una propiedad de configuración (`glottia.llm.provider`) usando `@ConditionalOnProperty`.

2. **Canales de notificación** en el servicio de Notifications: un `NotificationDispatcher` selecciona dinámicamente entre `EmailNotificationService` (SendGrid), `PushNotificationService` (Firebase), y `SmsNotificationService` (Twilio) según el canal de notificación solicitado.

3. **Resolución de routing keys**: la interfaz funcional `RoutingKeyResolver` permite que cada servicio implemente su propia estrategia para determinar el routing key de RabbitMQ según el tipo de evento.

##### Observer / Event Listener
\


El patrón **Observer** se manifiesta en dos niveles:

- **Eventos de dominio intra-servicio**: los aggregates registran eventos mediante `registerEvent()`, que son capturados por `@TransactionalEventListener` en el mismo proceso para persistirlos en el outbox.
- **Eventos de integración entre servicios**: los eventos se publican en RabbitMQ y son consumidos por `@RabbitListener` en otros servicios. Por ejemplo, el servicio Encounters publica `LearnerCheckedInEvent` que es consumido por Engagement para acreditar puntos.

##### Template Method
\


El patrón **Template Method** se utiliza en la implementación del Transactional Outbox. `DomainEventToOutboxBridge<E>` define el esqueleto del algoritmo (escuchar eventos, serializar, persistir), mientras que las subclases concretas (como `IamDomainEventToOutboxBridge`) implementan los detalles específicos (extraer aggregate ID, crear la entrada de outbox). De manera similar, `OutboxRelay<E>` define el algoritmo de polling y publicación, delegando a las subclases la obtención de entradas pendientes y el envío a RabbitMQ.

##### State
\


El patrón **State** se implementa en el servicio Encounters mediante una máquina de estados explícita en la entidad `EncounterStatus`. El aggregate `Encounter` verifica transiciones de estado válidas mediante el método `canTransitionTo()`, que define la matriz de transiciones: los encuentros inician como borrador (DRAFT), pasan a publicado (PUBLISHED), luego a listo (READY), después a en progreso (IN_PROGRESS), y finalmente a completado (COMPLETED). Desde varios estados es posible la cancelación (CANCELLED). La entidad `Attendance` también posee su propia máquina de estados: RESERVED puede transicionar a CHECKED_IN, NO_SHOW, o CANCELLED.

##### Chain of Responsibility
\


El pipeline de seguridad de Spring Security constituye una implementación del patrón **Chain of Responsibility**. El filtro `BearerAuthorizationRequestFilter` extrae y valida el token JWT de cada petición entrante. Si la autenticación falla, el `UnauthorizedRequestHandlerEntryPoint` maneja el error y retorna un código HTTP 401. Esta cadena de filtros es configurada en `WebSecurityConfiguration`.


#### 5.1.2.7 Patrones Backend
\


##### Repository
\


Cada aggregate raíz tiene un repositorio Spring Data JPA dedicado en `infrastructure/persistence/jpa/repositories/`. Estos repositorios extienden `JpaRepository<T, ID>` y heredan automáticamente operaciones CRUD, paginación, y ordenamiento. Los métodos de búsqueda personalizados se declaran mediante convenciones de nomenclatura (ej. `findByEmail()`, `existsByUserId()`). No existe una capa de abstracción adicional sobre JpaRepository, siguiendo el principio YAGNI.

##### Unit of Work
\


Spring Data JPA implementa el patrón **Unit of Work** de manera transparente. El `EntityManager` de JPA rastrea todos los cambios realizados a las entidades dentro de una transacción y los sincroniza con la base de datos al hacer *flush*. La anotación `@Transactional` en los servicios de comando delimita explícitamente las unidades de trabajo.

##### Service Layer
\


La capa de servicio está dividida en dos niveles: las interfaces de servicio de dominio (`domain/services/`) definen los contratos, mientras que las implementaciones en la capa de aplicación (`application/internal/commandservices/`, `application/internal/queryservices/`) orquestan la lógica de negocio. Los servicios de aplicación son responsables de cargar aggregates del repositorio, invocar métodos de dominio, y persistir los cambios.

##### Data Transfer Object (DTO)
\


Los DTOs de entrada y salida se definen como *records* de Java en `interfaces/rest/resources/`. Los DTOs de entrada incluyen validación mediante anotaciones de Bean Validation (`@NotBlank`, `@NotNull`, `@Size`). Los DTOs de salida exponen únicamente la información necesaria para la API, sin filtrar detalles internos del modelo de dominio. Existen también DTOs específicos para la comunicación ACL entre servicios, ubicados en `infrastructure/acl/*/services/resources/`.

##### Assembler
\


Los **Assemblers** son clases con métodos estáticos que convierten entre DTOs de recurso y comandos/entidades de dominio. Se ubican en `interfaces/rest/transform/` y siguen una convención de nomenclatura clara: `XXXCommandFromResourceAssembler` para conversión de recurso a comando, y `XXXResourceFromEntityAssembler` para conversión de entidad a recurso. Esta separación mantiene la capa de interfaces independiente de los cambios en el modelo de dominio.

##### Transactional Outbox
\


El patrón **Transactional Outbox** garantiza la entrega confiable de eventos de dominio a RabbitMQ. El flujo es el siguiente:

1. El aggregate registra un evento de dominio mediante `registerEvent()`.
2. El `DomainEventToOutboxBridge` (escucha con `@TransactionalEventListener(phase = BEFORE_COMMIT)`) captura el evento, lo serializa a JSON, y lo persiste en la tabla de outbox dentro de la misma transacción de base de datos.
3. El `OutboxRelay` (ejecutado cada 500ms mediante `@Scheduled`) consulta las entradas de outbox no publicadas, las envía a RabbitMQ con el routing key correspondiente, y marca la entrada como publicada.

Este patrón asegura que ningún evento se pierda incluso si RabbitMQ no está disponible temporalmente, ya que los eventos se recuperan de la base de datos en el próximo ciclo de polling.

##### Anti-Corruption Layer (ACL)
\


Cada bounded context define una o más interfaces **ACL Facade** que actúan como fronteras explícitas entre contextos. La interfaz reside en `interfaces/acl/` y su implementación en `application/acl/`. Por ejemplo, el contexto Encounters expone `EncountersContextFacade` con el método `fetchLearnerIdsByEncounterId()`, y el contexto IAM expone `IamContextFacade` con métodos como `fetchUserIdByEmail()` y `existsByEmail()`. Otros contextos consumen estas fachadas sin acceder nunca a los repositorios o aggregates internos.

##### API Gateway
\


El **API Gateway** (Spring Cloud Gateway) actúa como punto único de entrada para todas las peticiones externas. Define 17 rutas que redirigen el tráfico a los microservicios correspondientes utilizando el descubrimiento de servicios de Eureka (`lb://service-name`). El gateway valida los tokens JWT en las peticiones, extrae los claims de seguridad, y los reenvía como encabezados `X-User-*` a los microservicios internos.

##### Service Registry
\


El **Service Registry** (Netflix Eureka) proporciona descubrimiento de servicios. Cada microservicio se registra con su nombre lógico al iniciar, y el gateway y los clientes Feign utilizan estos nombres lógicos en lugar de direcciones IP y puertos fijos.

##### Marker Interface (para Dependency Injection)
\


Para resolver ambigüedades en la inyección de dependencias de Spring, se utilizan **marker interfaces**. Por ejemplo, `BCryptHashingService` extiende tanto la interfaz del dominio (`HashingService`) como la interfaz de Spring Security (`PasswordEncoder`), permitiendo que el mismo bean sea inyectado en ambos contextos sin necesidad de `@Qualifier` o `@Primary`.

##### Rate Limiting
\


El servicio Verification implementa **Rate Limiting** mediante Resilience4j (`@RateLimiter(name = "otpGenerator")`) para limitar la frecuencia de generación de códigos OTP y prevenir abusos.

##### Optimistic Locking
\


El aggregate `Verification` utiliza **Optimistic Locking** mediante `@Version` de JPA para manejar concurrencia en la verificación de códigos OTP, lanzando `OptimisticLockingFailureException` cuando dos procesos intentan verificar el mismo código simultáneamente.

##### Idempotency
\


El aggregate `Notification` incorpora soporte para **idempotencia**, permitiendo que el envío de una notificación con la misma clave de idempotencia sea seguro de reintentar sin duplicar el envío.

##### Interceptor
\


Los microservicios que realizan llamadas Feign a otros servicios implementan un **Feign RequestInterceptor** (`InternalServiceAuthInterceptor`) que añade automáticamente un encabezado `X-Internal-Request` con un secreto compartido a todas las peticiones salientes, proporcionando un mecanismo de autenticación entre servicios.

---

# 5.1.3 Pattern Based Custom Software Library
\


## 5.1.3.1 Introducción
\


El proyecto Glottia incluye un módulo compartido denominado **glottia-commons** que funciona como un **Shared Kernel** minimalista según la terminología de Domain-Driven Design. Este módulo no es una librería de utilidades genérica, sino un conjunto cuidadosamente seleccionado de clases base, interfaces y configuraciones que todos los bounded contexts comparten por necesidad. La filosofía detrás de su diseño es que solo debe contener aquello que todos los contextos genuinamente necesitan, evitando la tentación de convertirlo en un repositorio de código genérico sin propósito claro.


## 5.1.3.2 Arquitectura de glottia-commons
\


La estructura de `glottia-commons` refleja la misma organización en capas que los microservicios, pero a nivel de infraestructura compartida:

```
glottia-commons/
├── domain/model/
│   ├── aggregates/          → Clase base para todos los aggregates
│   ├── entities/            → Clase base para entidades owned
│   ├── events/              → Interface de evento de dominio + eventos de integración
│   └── security/            → DTO de seguridad compartido
├── infrastructure/
│   ├── persistence/         → Configuración de JPA Auditing
│   └── persistence/jpa/     → Estrategia de naming de tablas
├── shared/
│   ├── messaging/outbox/    → Implementación completa del patrón Transactional Outbox
│   ├── messaging/rabbitmq/  → Publisher de eventos para RabbitMQ
│   └── interfaces/rest/     → Helper de seguridad para obtener el usuario autenticado
└── interfaces/rest/         → DTO genérico de respuesta
```

El módulo utiliza **Spring Boot Auto-Configuration** para que la configuración de JPA Auditing se active automáticamente cuando `glottia-commons` está en el classpath, sin necesidad de anotaciones explícitas en cada microservicio.


#### 5.1.3.3 Componentes Compartidos
\


##### AuditableAbstractAggregateRoot (Clase Base para Aggregates)
\


Es la clase fundamental del Shared Kernel. Extiende `AbstractAggregateRoot<T>` de Spring Data, lo que proporciona el mecanismo de registro y publicación de eventos de dominio. Además, incorpora campos de auditoría temporal (`createdAt`, `updatedAt`) que se pueblan automáticamente mediante `@CreatedDate` y `@LastModifiedDate` de Spring Data JPA.

Todos los aggregates de la plataforma extienden esta clase, heredando:
- Capacidad de registrar eventos de dominio mediante `registerEvent(T event)`.
- Recolección automática de eventos por parte de Spring Data para su publicación.
- Marcas de tiempo automáticas sin intervención del desarrollador.
- Método `validateInvariants()` que las subclases pueden sobrescribir para validar reglas de negocio antes de la persistencia.

##### AuditableModel (Clase Base para Entidades Owned)
\


Una versión más ligera de la clase anterior, destinada a entidades owned que no son aggregates raíz. Proporciona únicamente los campos de auditoría temporal sin el soporte de eventos de dominio.

##### DomainEvent (Interface)
\


Define el contrato que todos los eventos de dominio deben cumplir. Especifica dos métodos:
- `eventId()`: identificador único del evento (típicamente un UUID).
- `occurredOn()`: marca de tiempo de cuando ocurrió el evento.

Diez eventos de integración concretos implementan esta interfaz, definiendo los contratos de comunicación entre bounded contexts:

| Evento | Propósito |
|---|---|
| `LearnerCheckedInIntegrationEvent` | Notifica que un aprendiz realizó check-in a un encuentro |
| `EncounterCompletedIntegrationEvent` | Notifica que un encuentro fue completado |
| `EncounterCancelledIntegrationEvent` | Notifica que un encuentro fue cancelado |
| `PointsAwardedIntegrationEvent` | Notifica que se otorgaron puntos a un aprendiz |
| `BadgeUnlockedIntegrationEvent` | Notifica que un aprendiz desbloqueó una insignia |
| `PromotionRedeemedIntegrationEvent` | Notifica que una promoción fue canjeada |
| `AssessmentCompletedIntegrationEvent` | Notifica que una autoevaluación fue completada |
| `QuizPassedIntegrationEvent` | Notifica que un quiz fue aprobado |
| `OtpGeneratedIntegrationEvent` | Notifica que se generó un código OTP |
| `OtpVerifiedIntegrationEvent` | Notifica que un código OTP fue verificado |

##### AuthenticatedUser (DTO de Seguridad)
\


Un *record* de Java que representa al usuario autenticado en el sistema. Contiene `userId`, `subjectId`, `role`, `profileId`, y `authorities`. Es utilizado por los controladores REST y servicios de aplicación para conocer la identidad del usuario que realiza la petición, sin depender directamente de los detalles de implementación de Spring Security.

##### Transactional Outbox (Infraestructura de Mensajería Confiable)
\


El componente más complejo del Shared Kernel. Proporciona las clases base para implementar el patrón Transactional Outbox en cualquier microservicio. Incluye:

- **BaseOutboxEntry**: clase abstracta `@MappedSuperclass` que define la estructura de la tabla de outbox: `id`, `aggregateId`, `eventType`, `routingKey`, `payload` (JSON), `occurredOn`, `publishedAt`, `createdAt`.
- **DomainEventToOutboxBridge<E>**: clase abstracta que implementa el listener transaccional para capturar eventos de dominio y persistirlos en la tabla de outbox.
- **OutboxRelay<E>**: clase abstracta que implementa el proceso scheduleado de polling y publicación a RabbitMQ.
- **RoutingKeyResolver**: interfaz funcional (`@FunctionalInterface`) para determinar el routing key de RabbitMQ según el tipo de evento.
- **RabbitMqDomainEventPublisher**: clase abstracta que implementa la publicación directa de eventos a RabbitMQ.

##### SnakeCaseWithPluralizedTablePhysicalNamingStrategy (Estrategia de Naming JPA)
\

Una estrategia de naming físico personalizada para Hibernate que convierte automáticamente los nombres de entidades CamelCase a snake_case y pluraliza el nombre de la tabla. Por ejemplo, la entidad `UserProfile` se mapea automáticamente a la tabla `user_profiles`, y `EncounterStatus` a `encounter_statuses`. Esto garantiza consistencia en la nomenclatura de tablas en toda la plataforma.

##### CurrentUserProvider (Helper de Seguridad)
\


Un utilitario que extrae el `AuthenticatedUser` del `SecurityContextHolder` de Spring Security, proporcionando un acceso limpio y tipado a la identidad del usuario autenticado desde cualquier punto del código.

##### MessageResource (DTO Genérico)
\


Un *record* simple que encapsula un mensaje de texto para respuestas API que no requieren un DTO específico, como confirmaciones de operación (`"Check-in successful"`) o mensajes de error simples.


#### 5.1.3.4 Patrones Implementados
\


##### Template Method
\


El patrón **Template Method** es el más utilizado en `glottia-commons`. Tanto `DomainEventToOutboxBridge<E>` como `OutboxRelay<E>` definen el esqueleto de un algoritmo mientras delegan detalles específicos a las subclases. En `DomainEventToOutboxBridge`, el algoritmo general es: recibir evento, resolver routing key, serializar a JSON, crear entrada de outbox, persistir. Los métodos abstractos que las subclases deben implementar incluyen `extractAggregateId()` y `createEntry()`. En `OutboxRelay`, el algoritmo es: consultar entradas pendientes, publicar a RabbitMQ, marcar como publicadas. Las subclases proporcionan el exchange y el repositorio.

##### Domain Event
\


La interfaz `DomainEvent` establece el contrato para todos los eventos de dominio. Los diez eventos de integración concretos implementan este contrato como *records* inmutables de Java, garantizando que los eventos sean intercambiables y polimórficos.

##### Mapped Superclass (JPA Inheritance)
\


Tanto `AuditableAbstractAggregateRoot` como `AuditableModel` y `BaseOutboxEntry` están anotados con `@MappedSuperclass`, lo que permite que las subclases hereden el mapeo JPA sin que la superclase sea una entidad por sí misma. Este es un uso correcto del patrón de herencia de JPA.

##### Auto-Configuration (Spring Boot)
\


`JpaAuditingConfiguration` está registrada como una **auto-configuración** de Spring Boot mediante el archivo `META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`. Esto significa que cuando `glottia-commons` está en el classpath de cualquier microservicio, la configuración de JPA Auditing se activa automáticamente sin necesidad de `@EnableJpaAuditing` en cada servicio.

##### Naming Strategy
\


`SnakeCaseWithPluralizedTablePhysicalNamingStrategy` es una implementación del patrón **Strategy** para la nomenclatura de tablas de Hibernate, haciendo que la estrategia de naming sea intercambiable mediante configuración de propiedades.

##### Value Object
\


`AuthenticatedUser` es un *record* de Java inmutable que funciona como objeto de valor, identificando de manera única al usuario autenticado dentro del contexto de seguridad de la aplicación.

##### Functional Interface
\


`RoutingKeyResolver` está anotada con `@FunctionalInterface`, permitiendo que se utilice como lambda o method reference en lugar de requerir una clase anónima, simplificando su implementación en cada microservicio.

##### Static Helper
\


`CurrentUserProvider` es una clase utilitaria con un método estático que encapsula la lógica de acceso al `SecurityContextHolder`, proporcionando una API limpia y testeable.


***

#### 5.1.4 Framework Pattern Driven Refactoring Report
\


##### 5.1.4.1 Introducción
\


El framework **Spring Boot 3.5** (en conjunto con **Spring Cloud 2025.0.0**) ha sido el motor principal de refactorización en la plataforma Glottia. A diferencia de una adopción pasiva donde el framework simplemente proporciona infraestructura, Spring Boot ha *forzado* activamente una serie de transformaciones arquitectónicas que han moldeado la estructura final del código. Este reporte documenta diez refactorizaciones clave que el framework ha inducido, explicando para cada una cuál era el problema original, cómo quedó la solución, qué patrón se utilizó, y cuál fue el beneficio obtenido.

La evidencia de estas refactorizaciones no proviene de un historial de commits específico (el repositorio fue construido siguiendo estas prácticas desde el inicio), sino del análisis estructural del código actual, que revela las huellas de las decisiones arquitectónicas tomadas.

##### 5.1.4.2 Refactorización 1: Separación Controller → Service → Repository
\


**Problema original (ANTES):** En una arquitectura plana sin framework, los controladores HTTP tienden a mezclar responsabilidades: reciben la petición, validan datos, ejecutan lógica de negocio, acceden a la base de datos, y formatean la respuesta. Esto genera controladores con cientos de líneas, difícilmente testeables y con acoplamiento rígido a la tecnología de persistencia.

**Solución implementada (DESPUÉS):** Spring Boot impone una separación natural en tres capas que se refleja en la estructura de paquetes de cada microservicio:

- **Controller** (`interfaces/rest/controllers/`): responsable únicamente de recibir peticiones HTTP, delegar en servicios, y retornar respuestas. Sin lógica de negocio.
- **Service** (`application/internal/commandservices/`, `application/internal/queryservices/`): orquesta la lógica de negocio, gestiona transacciones, y coordina repositorios.
- **Repository** (`infrastructure/persistence/jpa/repositories/`): abstrae el acceso a datos mediante Spring Data JPA.

**Patrón utilizado:** Service Layer + Repository.

**Beneficio:** cada capa tiene una responsabilidad única y es testeable de forma aislada. Los controladores se prueban con `@WebMvcTest`, los servicios con Mockito, y los repositorios con `@DataJpaTest`.

**Evidencia estructural:** en `glottia-encounters-service`, el controlador `EncountersController` tiene 16 endpoints pero ninguna línea de lógica de negocio; toda la lógica reside en `EncounterCommandServiceImpl` y `EncounterQueryServiceImpl`, y el acceso a datos en `EncounterRepository` y `AttendanceRepository`.

##### 5.1.4.3 Refactorización 2: Extracción de Shared Kernel (glottia-commons)
\


**Problema original (ANTES):** Sin un Shared Kernel, cada microservicio definía su propia clase base para aggregates auditables, su propia implementación del outbox pattern, y su propia estrategia de naming de tablas. Esto resultaba en duplicación sustancial de código y, peor aún, en inconsistencias sutiles entre implementaciones.

**Solución implementada (DESPUÉS):** Se extrajo un módulo Maven independiente (`glottia-commons`) que centraliza:

- `AuditableAbstractAggregateRoot<T>`: base para todos los aggregates.
- `AuditableModel`: base para entidades owned.
- `DomainEvent` + 10 eventos de integración: contratos compartidos.
- `BaseOutboxEntry` + `DomainEventToOutboxBridge` + `OutboxRelay`: outbox reutilizable.
- `SnakeCaseWithPluralizedTablePhysicalNamingStrategy`: estrategia de naming consistente.
- `CurrentUserProvider` + `AuthenticatedUser`: seguridad transversal.

**Patrón utilizado:** Shared Kernel (DDD) + Template Method + Abstract Class.

**Beneficio:** eliminación de duplicación, consistencia en todos los servicios, evolución centralizada.

**Evidencia:** los 11 microservicios del proyecto declaran `<dependency><groupId>com.hampcoders</groupId><artifactId>glottia-commons</artifactId></dependency>` en sus `pom.xml`, y todos los aggregates extienden `AuditableAbstractAggregateRoot<T>`.

##### 5.1.4.4 Refactorización 3: Dependency Injection Generalizada
\


**Problema original (ANTES):** Sin un contenedor de inversión de control, los servicios creaban sus dependencias manualmente con `new Repository()`, generando acoplamiento rígido a implementaciones concretas y haciendo imposible el mockeo en pruebas unitarias.

**Solución implementada (DESPUÉS):** Spring Boot gestiona todas las dependencias mediante **constructor injection**. Todos los servicios, repositorios, controladores, y componentes reciben sus dependencias a través del constructor, que Spring resuelve automáticamente.

**Patrón utilizado:** Dependency Injection (contenedor Spring IoC).

**Beneficio:** testabilidad (las dependencias pueden ser mockeadas con Mockito), desacoplamiento (los componentes solo conocen interfaces, no implementaciones), y configuración centralizada (los beans se configuran en un solo lugar).

**Evidencia:** todas las clases `@Service`, `@Controller`, y `@Component` utilizan constructor injection sin excepción. Por ejemplo, `EncounterCommandServiceImpl` recibe `EncounterRepository`, `EncounterStatusRepository`, y `ExternalVenueService` a través de su constructor.

##### 5.1.4.5 Refactorización 4: Anti-Corruption Layer (ACL) para Aislamiento de Bounded Contexts
\


**Problema original (ANTES):** En una arquitectura sin fronteras explícitas, los servicios de un contexto accedían directamente a los repositorios y agregados de otros contextos. Esto generaba acoplamiento fuerte: un cambio en el modelo interno de un contexto podía romper funcionalidad en contextos no relacionados.

**Solución implementada (DESPUÉS):** Cada bounded context expone **fachadas ACL** que definen contratos explícitos para el consumo externo. Un contexto nunca accede a los repositorios o agregados de otro contexto; solo interactúa a través de estas fachadas. La estructura es:

```
Contexto A expone: interfaces/acl/ContextoAFacade.java → application/acl/ContextoAFacadeImpl.java
Contexto B inyecta: ContextoAFacade (depende de la interfaz, no de la implementación)
```

**Patrón utilizado:** Facade (ACL / Anti-Corruption Layer).

**Beneficio:** aislamiento total entre bounded contexts. El modelo interno de un contexto puede cambiar sin afectar a los consumidores, siempre que la interfaz ACL permanezca estable. Las fachadas también proporcionan un punto ideal para aplicar transformaciones entre modelos (traducción de objetos de valor, adaptación de tipos).

**Evidencia:** existen fachadas ACL en IAM (`IamContextFacade`), Profiles (`ProfilesContextFacade`), Venues (`VenuesContextFacade`), Encounters (`EncountersContextFacade`), Feedback (`LearningFeedbackContextFacade`), Notification (`NotificationsContextFacade`), y Verification (`VerificationContextFacade`).


##### 5.1.4.6 Refactorización 5: Patrón Transactional Outbox para Mensajería Confiable
\


**Problema original (ANTES):** Sin outbox, los eventos de dominio se publicaban directamente a RabbitMQ en el mismo hilo que la transacción de negocio. Si RabbitMQ no estaba disponible en ese momento (fallo de red, reinicio, sobrecarga), el evento se perdía irreversiblemente, resultando en estados inconsistentes entre servicios.

**Solución implementada (DESPUÉS):** Implementación completa del patrón Transactional Outbox con tres componentes:

1. **Bridge**: captura eventos de dominio con `@TransactionalEventListener(phase = BEFORE_COMMIT)` y los persiste en la tabla de outbox en la misma transacción de base de datos.
2. **Entrada de Outbox**: entidad JPA que almacena el evento serializado como JSON.
3. **Relay**: proceso scheduleado (cada 500ms) que consulta entradas no publicadas, las envía a RabbitMQ, y las marca como publicadas.

**Patrón utilizado:** Transactional Outbox + Polling Publisher.

**Beneficio:** garantía **at-least-once delivery**. Incluso si RabbitMQ falla, los eventos permanecen en la base de datos y serán publicados cuando el servicio se recupere. Se elimina el riesgo de pérdida de eventos.

**Evidencia:** seis microservicios implementan el patrón: IAM, Profiles, Venues, Encounters, Engagement, y Feedback. Cada uno tiene su propia `*OutboxEntry`, `*DomainEventToOutboxBridge`, y `*OutboxRelay`, que extienden las clases base de `glottia-commons`.


##### 5.1.4.7 Refactorización 6: Estandarización de DTOs y Assemblers
\


**Problema original (ANTES):** Los agregados de dominio se serializaban directamente a JSON para las respuestas API, exponiendo detalles internos del modelo (como IDs técnicos, campos de auditoría, o relaciones internas) y acoplando la API pública al modelo de persistencia.

**Solución implementada (DESPUÉS):** Se introdujo una capa explícita de **Resources (DTOs)** y **Assemblers**:

- Los **DTOs de entrada** (`*Resource.java` en `interfaces/rest/resources/`) definen la estructura esperada de las peticiones, con validaciones mediante Bean Validation.
- Los **DTOs de salida** definen la estructura de las respuestas, exponiendo solo la información relevante.
- Los **Assemblers** (`*FromResourceAssembler.java` y `*FromEntityAssembler.java` en `interfaces/rest/transform/`) convierten entre DTOs y objetos de dominio mediante métodos estáticos.

**Patrón utilizado:** DTO + Assembler.

**Beneficio:** desacoplamiento total entre la API pública y el modelo interno. La API puede evolucionar independientemente del dominio. Las validaciones están centralizadas en los DTOs de entrada.

**Evidencia:** cada microservicio tiene su propio paquete `interfaces/rest/transform/` con múltiples assemblers. Por ejemplo, `glottia-venues-service` tiene 24 assemblers y 27 DTOs.


##### 5.1.4.8 Refactorización 7: CQRS (Command Query Responsibility Segregation)
\


**Problema original (ANTES):** Un único servicio manejaba tanto operaciones de lectura como de escritura. Las consultas podían desencadenar accidentalmente efectos secundarios, y no era posible optimizar las lecturas (con caché o transacciones de solo lectura) sin afectar las escrituras.

**Solución implementada (DESPUÉS):** Separación explícita de responsabilidades:

- **Command Services**: manejan operaciones de escritura (comandos), anotados con `@Transactional`.
- **Query Services**: manejan operaciones de lectura (consultas), anotados con `@Transactional(readOnly = true)`.
- **Comandos**: objetos inmutables en `domain/model/commands/`.
- **Consultas**: objetos inmutables en `domain/model/queries/`.

**Patrón utilizado:** CQRS.

**Beneficio:** las consultas pueden optimizarse con `readOnly = true` (Hibernate deshabilita el dirty checking). Los comandos y consultas tienen ciclos de vida independientes. Se reduce el riesgo de efectos secundarios en operaciones de solo lectura.

**Evidencia:** ocho microservicios implementan CQRS completo: IAM, Profiles, Venues, Promotions, Encounters, Engagement, Feedback, y Verification. Cada uno tiene interfaces de servicio separadas (`*CommandService` vs `*QueryService`) y paquetes separados para comandos y consultas.


##### 5.1.4.9 Refactorización 8: Manejo Centralizado de Excepciones
\


**Problema original (ANTES):** Cada controlador manejaba sus propias excepciones con bloques `try-catch`, resultando en:

- Código repetitivo en todos los endpoints.
- Respuestas de error inconsistentes (diferentes formatos JSON, diferentes códigos HTTP para el mismo tipo de error).
- Dificultad para mantener y evolucionar el manejo de errores.

**Solución implementada (DESPUÉS):** Se implementaron manejadores globales de excepciones utilizando `@RestControllerAdvice` que capturan excepciones específicas y las convierten en respuestas HTTP estandarizadas siguiendo el formato `ProblemDetail` de RFC 9457.

**Patrón utilizado:** Global Exception Handler + Problem Details (RFC 9457).

**Beneficio:** respuestas de error consistentes en formato `ProblemDetail` (estándar RFC 9457), lógica de error centralizada en un solo lugar, controladores más limpios sin manejo disperso de excepciones.

**Evidencia:** existen manejadores globales en cuatro microservicios: `ProfilesExceptionHandler`, `EncountersExceptionHandler`, `EngagementExceptionHandler`, y `LearningFeedbackExceptionHandler`.


##### 5.1.4.10 Refactorización 9: Interceptor para Autenticación Interna entre Servicios
\


**Problema original (ANTES):** Las llamadas Feign entre microservicios no tenían un mecanismo de autenticación. Cualquier proceso que conociera la URL de un servicio podía invocar sus endpoints internos sin autorización.

**Solución implementada (DESPUÉS):** Se implementó un `Feign RequestInterceptor` que añade automáticamente un encabezado `X-Internal-Request` con un secreto compartido a todas las peticiones salientes. Los microservicios receptores pueden verificar este encabezado para distinguir entre peticiones externas (autenticadas con JWT) y peticiones internas de servicio a servicio.

**Patrón utilizado:** Interceptor (Feign `RequestInterceptor`).

**Beneficio:** autenticación entre microservicios sin exponer tokens JWT de usuarios en la comunicación interna. El secreto compartido se configura externamente y puede rotarse sin afectar el código.

**Evidencia:** tres microservicios implementan este interceptor: IAM, Notification, y Verification.


##### 5.2 Software Configuration Management

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

**Repositorios de GitHub:**

- Enlace para acceder al [Repositorio del Documento](https://github.com/Hampcoders-Fundamentos/project-document)
- Enlace para acceder al [Repositorio del Backend como Monolito](https://github.com/Hampcoders-Fundamentos/glottia-backend-monolith)
- Enlace para acceder al [Repositorio del Backend como Microservicios](https://github.com/Hampcoders-Fundamentos/glottia-backend-microservices)

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

#### Organización de Paquetes
La estructura se organiza por **Bounded Contexts** dentro de `src/main/java/com/hampcoders/glottia/platform/api/`:

* **`[contexto]/domain/`**: El corazón del negocio. No tiene dependencias externas. Contiene:
    * `model/aggregates/`: Raíces de agregados.
    * `model/entities/`: Entidades del dominio.
    * `model/valueobjects/`: Objetos de valor.
    * `model/commands/` y `model/queries/`: Comandos y consultas específicos.
    * `model/events/`: Eventos de dominio.
    * `services/`: Interfaces de servicios de dominio.
* **`[contexto]/application/`**: Capa de aplicación que orquesta la lógica de negocio:
    * `internal/commandservices/` e `internal/queryservices/`: Implementaciones de servicios de comandos y consultas.
    * `internal/eventhandlers/`: Manejadores de eventos de dominio e integración.
    * `acl/`: Capa de anticorrupción (Anti-Corruption Layer) para interactuar con otros contextos.
* **`[contexto]/infrastructure/`**: Implementaciones técnicas, persistencia de datos (JPA/Hibernate), configuraciones de infraestructura y adaptadores de servicios externos (LLM, notificaciones).
* **`[contexto]/interfaces/`**: Capa de entrada del contexto. Contiene `rest/` con controladores (`Controllers`), recursos de transferencia de datos (`Resources`) y ensambladores (`Transform/Assemblers`).
* **`shared/`**: Lógica transversal, excepciones globales, utilitarios y clases base reutilizables (como raíces de agregados auditales).

#### 2. Convenciones de Nomenclatura

#### Clases e Interfaces
* **Clases**: Se utiliza `PascalCase`. Deben incluir un sufijo descriptivo según su rol arquitectónico.
    * *Controladores:* `AnalyticsController`
    * *Servicios de Aplicación:* `EncounterCommandServiceImpl`
    * *Repositorios JPA:* `EncounterRepository`
    * *Manejadores de Eventos:* `AssessmentCompletedEventHandler`
* **Interfaces**: Se utiliza `PascalCase`. **No se utiliza el prefijo `I`**. El nombre debe describir el contrato de forma natural (ej. `EncounterCommandService` en lugar de `IEncounterCommandService`).

#### 3. Archivos
* **Formato**: Se utiliza `PascalCase` obligatorio para todos los archivos fuente de Java (`.java`), coincidiendo exactamente con el nombre de la clase o interfaz contenida.
    * `Encounter.java`
    * `EncounterRepository.java`
    * `CreateEncounterCommand.java`
    * `EncountersController.java`

#### 4. Variables y Funciones
* **Formato**: Se utiliza `camelCase` para variables locales, atributos de clase y nombres de métodos.
* **Claridad**: Los nombres deben ser descriptivos en inglés. Evitar abreviaturas crípticas (usar `encounterRepository` en lugar de `encRepo`).

#### 5. Estándares de Codificación
* El código se rige por los principios SOLID, promoviendo la separación de responsabilidades, la inversión de dependencias mediante Spring Framework (`@Service`, `@Repository`, `@RestController`) y el diseño orientado a interfaces. Se favorece la composición sobre la herencia y se evita el acoplamiento directo entre contextos bounded independientes, utilizando el `DomainEventPublisher` de Spring para comunicación asíncrona desacoplada o fachadas ACL.

#### 6. Lógica de Negocio y Persistencia
* **Inyección de Dependencias**: Se utiliza inyección por constructor implícita de Spring para garantizar la inmutabilidad y facilitar las pruebas unitarias.
* **Regla de Dependencia**: Las capas internas (`Domain`) nunca deben depender de las capas externas (`Infrastructure`, `Interfaces`).
* **Manejo de Errores**: Se manejan excepciones de dominio específicas o infraestructura que son interceptadas de manera centralizada por un `GlobalExceptionHandler` (`@ControllerAdvice`) para transformarlas en respuestas HTTP estandarizadas.

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

La plataforma Glottia adopta una estrategia de despliegue basada en contenedores Docker, utilizando **docker-compose** para la orquestación local y **Terraform** como Infrastructure as Code (IaC) para el aprovisionamiento automatizado de la infraestructura en **AWS**. Cada microservicio se empaqueta como una imagen Docker independiente, permitiendo despliegues aislados, escalables y reproducibles.

#### Docker y Contenerización

Cada microservicio (IAM, Profiles, Encounters, Venues, Promotions, Learning Feedback, Engagement) cuenta con su propio `Dockerfile` que define el entorno de ejecución basado en OpenJDK 21 para los servicios Spring Boot. Las imágenes se almacenan en **Amazon Elastic Container Registry (ECR)** y se despliegan en instancias EC2 o servicios administrados de AWS.

#### Orquestación con Docker Compose

Para el entorno de desarrollo y validación local, se utiliza `docker-compose.yml` que orquesta los servicios auxiliares necesarios para la comunicación entre microservicios:

```yaml
services:
  rabbitmq:
    image: rabbitmq:3-management
    container_name: glottia-rabbitmq
    ports:
      - "5672:5672"
      - "15672:15672"
    environment:
      RABBITMQ_DEFAULT_USER: guest
      RABBITMQ_DEFAULT_PASS: guest
```

RabbitMQ actúa como bus de mensajería asíncrona, permitiendo la comunicación desacoplada entre microservicios para eventos como notificaciones de encuentros, actualización de puntos de lealtad y procesamiento de badges.

#### Infraestructura como Código con Terraform

La infraestructura en AWS se define y gestiona mediante scripts de Terraform, garantizando que el entorno de producción sea reproducible, versionable y auditable. Los recursos aprovisionados incluyen:

- **AWS VPC** con subredes públicas y privadas, tablas de enrutamiento, grupos de seguridad y balanceador de carga para el acceso seguro a los microservicios.
- **AWS ECR** para el almacenamiento de imágenes Docker de cada microservicio.
- **AWS RDS PostgreSQL** como base de datos relacional compartida para los microservicios.
- **AWS EC2** como plataforma de ejecución para los contenedores de cada servicio.

#### Variables de Entorno

Cada microservicio se configura mediante variables de entorno inyectadas en tiempo de ejecución:

| Variable | Descripción | Ejemplo |
|---|---|---|
| `SPRING_DATASOURCE_URL` | URL de conexión a base de datos | `jdbc:postgresql://glottia-db...:5432/glottia` |
| `SPRING_DATASOURCE_USERNAME` | Usuario de base de datos | `glottia_user` |
| `SPRING_DATASOURCE_PASSWORD` | Contraseña de base de datos | `****` |
| `JWT_SECRET` | Clave secreta para firma de tokens JWT | `****` |
| `RABBITMQ_HOST` | Host del servidor RabbitMQ | `glottia-rabbitmq` |
| `RABBITMQ_PORT` | Puerto de conexión RabbitMQ | `5672` |

#### Evidencia de Despliegue

Las evidencias de la ejecución de Terraform, los repositorios ECR, la base de datos RDS, la configuración de VPC y los servicios corriendo se presentan en la sección de despliegue correspondiente a cada sprint (secciones 5.3.1.6 y 5.3.2.6).

## 5.3 Microservices Implementation

### 5.3.1 Sprint 1

El Sprint 1 tiene una duración de 2 semanas y abarca tres frentes de trabajo: la migración del backend de monolito modular a microservicios independientes (IAM, Profiles y Encounters, cada uno con su propia base de datos y dockerizado), la implementación de las funcionalidades base de la plataforma que incluyen el registro y autenticación de usuarios, la gestión del perfil del aprendiz y el flujo completo de un encuentro desde la búsqueda hasta el check-in, y en paralelo la corrección de bugs existentes en la app junto con mejoras de UI en la pantalla home y el perfil de aprendiz, todo con el objetivo de tener los tres microservicios desplegados de forma autónoma y el ciclo de vida completo de un encuentro funcionando de punta a punta al cierre del sprint.

### Sprint Goal

"Nuestro enfoque está en migrar IAM, Profiles y Encounters a microservicios independientes y habilitar los flujos base de autenticación, gestión de perfil y check-in en encuentros.
Creemos que entrega una arquitectura desacoplada y escalable, y una experiencia funcional de punta a punta al equipo de desarrollo y a los primeros aprendices.
Esto se confirmará cuando un usuario pueda registrarse, completar su perfil y hacer check-in exitosamente en un encuentro utilizando la nueva infraestructura de microservicios."

#### 5.3.1.1 Sprint Backlog 1

\
![Sprint Backlog 1](assets/img/cap5/Glottia-SprintBacklog-1.jpeg)
\
[Ver Sprint Backlog 1 en Jira](https://fundamentos.atlassian.net/jira/software/projects/HGS1/boards/34/backlog?atlOrigin=eyJpIjoiOGU3YWU0ZDBkN2NjNGQ2MDkxMGQxZjk4ZjUwYWFmNTAiLCJwIjoiaiJ9)


#### 5.3.1.2 Development Evidence for Sprint Review

Durante el Sprint 1, el equipo Hampcoders desarrolló e implementó los microservicios correspondientes a los Bounded Contexts de **IAM**, **Profiles** y **Encounters**, dando inicio a la migración desde la arquitectura monolito modular hacia microservicios independientes. A continuación se detalla el desarrollo realizado por cada microservicio, incluyendo los endpoints implementados, las decisiones arquitectónicas adoptadas y las evidencias de código.

##### IAM Microservice

El microservicio IAM (Identity and Access Management) fue desarrollado como el primer módulo extraído del monolito, con los siguientes entregables:

- **Repositorio y configuración inicial:** Se creó un repositorio independiente para el microservicio IAM con Spring Boot 3.x, configuración de conexión a base de datos MySQL propia y empaquetado Docker.
- **Módulo de Autenticación:** Implementación de flujo completo de registro (`POST /api/v1/auth/register`) e inicio de sesión (`POST /api/v1/auth/login`) con generación de tokens JWT.
- **Módulo de Usuarios:** Endpoints CRUD para gestión de usuarios (`GET /api/v1/users`, `GET /api/v1/users/{id}`).
- **Seguridad:** Integración de Spring Security con BCrypt para hashing de contraseñas y filtro JWT para validación de tokens en cada request.
- **Pruebas de integración:** Se implementaron escenarios BDD para registro de aprendiz, registro de partner, inicio y cierre de sesión (Archivos: `auth_register_learner.feature`, `auth_register_partner.feature`, `auth_login.feature`, `auth_logout.feature`).

La documentación Swagger/OpenAPI del microservicio IAM se detalla en la sección 5.3.1.5.

##### Profiles Microservice

El microservicio Profiles fue desarrollado para gestionar la información de perfiles de learners y partners, con los siguientes entregables:

- **Repositorio y configuración inicial:** Se configuró el proyecto con Spring Boot, base de datos independiente y esquema de datos propio.
- **API de Perfiles:** Endpoints para creación, consulta, actualización y eliminación de perfiles (`GET/POST/PUT/DELETE /api/v1/profiles/{id}`).
- **Gestión de Idiomas:** Endpoints para que los learners puedan agregar, actualizar y eliminar idiomas de su perfil (`POST/PUT/DELETE /api/v1/profiles/{id}/learner/languages/{languageId}`).
- **Búsqueda:** Endpoint de búsqueda de perfiles por email (`GET /api/v1/profiles/search`).
- **Avatar:** Integración con el servicio de almacenamiento en la nube para subida y gestión de fotos de perfil.
- **Pruebas de integración:** Escenarios BDD para onboarding, edición de perfil, visualización de perfil de otros usuarios y subida de avatar (Archivos: `profile_*.feature`).

La documentación Swagger/OpenAPI del microservicio Profiles se detalla en la sección 5.3.1.5.

##### Encounters Microservice

El microservicio Encounters fue desarrollado para administrar el ciclo de vida completo de los encuentros conversacionales, con los siguientes entregables:

- **Repositorio y configuración inicial:** Separación del schema de Encounters con su propia base de datos y configuración de integraciones hacia Venues y Profiles.
- **API de Encuentros:** Endpoints para creación (`POST /api/v1/encounters`), búsqueda (`GET /api/v1/encounters/search`), consulta por ID (`GET /api/v1/encounters/{encounterId}`) y cancelación (`DELETE /api/v1/encounters/{encounterId}`).
- **Flujo de Ciclo de Vida:** Endpoints para iniciar (`POST .../start`), completar (`POST .../complete`) encuentros, y gestionar asistencias (`POST .../attendances`, `POST .../check-in`).
- **Integraciones:** Conexión con el microservicio de Profiles para datos de participantes y con Venues para disponibilidad de locales.
- **Pruebas de integración:** Escenarios BDD para el flujo completo de búsqueda, registro de asistencia y check-in.

La documentación Swagger/OpenAPI del microservicio Encounters se detalla en la sección 5.3.1.5.

##### API Gateway

Se inició la configuración del API Gateway como punto de entrada único para todos los microservicios, implementando enrutamiento perimetral hacia IAM, Profiles y Encounters, con políticas centralizadas de CORS y seguridad.

##### Control de Versiones y Colaboración

Todo el desarrollo fue gestionado mediante GitHub siguiendo la estrategia GitFlow, con ramas `main` y `develop` como base, y ramas `feature/` para cada tarea del sprint. Cada integración fue realizada mediante Pull Requests con revisión de código por pares. Las evidencias de commits, contribuciones y flujo de trabajo colaborativo se presentan en la sección 5.3.1.7.

---

#### 5.3.1.3 Testing Suite Evidence for Sprint Review

En esta sección se detalla el conjunto de pruebas de integración y aceptación automatizadas que validan la lógica de negocio de la plataforma Glottia. Para el diseño de estas suites, el equipo ha adoptado el enfoque de **Behavior-Driven Development (BDD)**, utilizando el lenguaje **Gherkin**. 

Esta metodología permite definir el comportamiento del sistema desde la perspectiva del usuario mediante escenarios estructurados (*Given-When-Then*), facilitando la verificación técnica de los Web Services y asegurando que cada microservicio cumpla estrictamente con las reglas del negocio digital antes de su despliegue.

***

##### 5.3.1.3.1 IAM Microservice — BDD Testing Suite

A continuación, se presentan las especificaciones en código Gherkin encargadas de validar los procesos de soporte críticos de autenticación, autorización y registro en el contexto de IAM.

#### `auth_register_learner.feature` — Relacionado con US-01

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


#### `auth_register_partner.feature` — Relacionado con US-02

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

#### `auth_login.feature` — Relacionado con US-03

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

#### `auth_logout.feature` — Relacionado con US-04

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


#### `auth_password_recovery.feature` — Relacionado con US-05

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

##### 5.3.1.3.2 Profiles Microservice — BDD Testing Suite

A continuación, se detallan las especificaciones Gherkin enfocadas en validar las reglas de la gestión de perfiles e idiomas dentro del microservicio Profiles.

#### `profile_onboarding.feature` — Relacionado con US-06

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

#### `profile_edition.feature` — Relacionado con US-07

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

#### `profile_discovery.feature` — Relacionado con US-08

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

#### `profile_avatar.feature` — Relacionado con US-09

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

#### 5.3.1.4 Execution Evidence for Sprint Review

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

#### 5.3.1.5 Microservices Documentation Evidence for Sprint Review

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

\
![Vista general de la especificación de los endpoints del módulo de users bajo el estándar OpenAPI](assets/img/cap5/iam.jpeg)

\
![Vista general de la especificación de los endpoints del módulo de Autenticación bajo el estándar OpenAPI](assets/img/cap5/Authentication.jpeg)


---

#### Swagger Documentation — IAM Microservice.

---

\
![Interfaz de Swagger UI para el endpoint de registro de usuarios, detallando el esquema del Request Body requerido del sing-up](assets/img/cap5/Documentacion-iam.png)

\
![Evidencia de interacción con el endpoint `/api/v1/auth/login` utilizando datos de muestra (`username: "test_user"`). Se observa la respuesta exitosa con código HTTP 200 (OK) y la generación del respectivo token de autenticación (JWT)](assets/img/cap5/IAM-sing-in.png)

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

![Panel general de Swagger UI para el microservicio de Encounters, listando los controladores REST encargados de la gestión del ciclo de vida de las sesiones conversacionales.](assets/img/cap5/Encounters.png)

--- 

#### Swagger Documentation — Encounters Microservice.

---

\
![Interfaz interactiva para el endpoint POST /api/v1/encounters. Se observa la estructura requerida del Request Body para dar de alta un nuevo encuentro de práctica lingüística y los esquemas de validación de datos](assets/img/cap5/post-encounters.png)

\
![Prueba de ejecución con datos de muestra para el endpoint GET /api/v1/encounters/{encounterId} e inicio del flujo. La documentación detalla la inyección](assets/img/cap5/Encounters-id.png)

\
![Evidencia del endpoint de finalización del ciclo conversacional (POST /.../complete). Muestra la estructura de respuesta exitosa del servidor tras procesar el cambio de estado de la sesión utilizando una ID de muestra](assets/img/cap5/EncounterId-complete.png)


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

![Interfaz principal de Swagger UI para el microservicio de Profiles, exhibiendo los endpoints necesarios para la administración de datos personales y configuración de idiomas](assets/img/cap5/Profiles.png)

*Figura 25. .*

--- 

#### Swagger Documentation — Profiles Microservice.

---

\
![Detalle de especificación para el endpoint PUT /api/v1/profiles/{id}. La interfaz muestra los parámetros requeridos en la ruta y el esquema JSON necesario para la actualización parcial o total del perfil](assets/img/cap5/ProfilesId-put.png)

\
![Interacción simulada con el endpoint POST /api/v1/profiles utilizando datos de muestra. Se valida la respuesta exitosa del servidor junto con los códigos de estado HTTP ante el envío de estructuras de perfil correctas](assets/img/cap5/Post-Profiles-id.jpeg)

\
![Ejecución exitosa de una consulta masiva mediante el endpoint GET /api/v1/profiles. Swagger UI despliega la respuesta simulada con código 200 (OK) exponiendo la estructura en formato de arreglo JSON de los perfiles guardados en el sistema](assets/img/cap5/Get-Profiles.png)


#### 5.3.1.6 Software Deployment Evidence for Sprint Review

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

#### 5.3.1.7 Team Collaboration Insights during Sprint

Durante el Sprint 1, el equipo Hampcoders gestionó la colaboración y el control de versiones mediante GitHub, adoptando GitFlow como estrategia de branching. Esto implicó el uso de ramas main y develop como ramas base, y la creación de ramas de tipo feature/ para cada tarea del sprint, asegurando que ningún cambio fuera integrado directamente a las ramas principales sin pasar por un proceso de Pull Request y revisión de código por parte de otro miembro del equipo. Las capturas de los analíticos de commits y la participación de cada integrante en los repositorios de los Web Services se presentan a continuación.

\
![Gitflow](assets/img/cap5/Gitflow.jpeg)
\
![Contributors](assets/img/cap5/Contributors.jpeg)

#### 5.3.1.8 Kanban Board --> TP1

\
![Sprint 1 Kanban Board](assets/img/cap5/Glottia-Sprint1-KanbanBoard.jpeg)
\
[Ver Sprint 1 Kanban Board en Jira](https://fundamentos.atlassian.net/jira/software/projects/HGS1/boards/34?atlOrigin=eyJpIjoiMDFiMTg2M2NkNTA3NDJjZDllZTQ3ZTlhNDU5MmNjMjUiLCJwIjoiaiJ9)

### 5.2.2 Sprint 2
#### 5.2.2.1 Sprint Backlog 2
El Sprint 1 tiene una duración de 2 semanas y abarca tres frentes de trabajo: la migración del backend de monolito modular a microservicios independientes (Engagement, Venues, Promotions y Learning Feedback, cada uno con su propia base de datos y dockerizado), la implementación de las funcionalidades base de la plataforma que incluyen el registro y autenticación de usuarios, la gestión del perfil del aprendiz y el flujo completo de un encuentro desde la búsqueda hasta el check-in, y en paralelo la corrección de bugs existentes en la app junto con mejoras de UI en la pantalla home y el perfil de aprendiz, todo con el objetivo de tener los tres microservicios desplegados de forma autónoma y el ciclo de vida completo de un encuentro funcionando de punta a punta al cierre del sprint.

### Sprint Goal

"Nuestro enfoque está en migrar Engagement, Venues, Promotions y Learning Feedback a microservicios independientes y habilitar los flujos base de autenticación, gestión de perfil y check-in en encuentros.
Creemos que entrega una arquitectura desacoplada y escalable, y una experiencia funcional de punta a punta al equipo de desarrollo y a los primeros aprendices.
Esto se confirmará cuando un usuario pueda registrarse, completar su perfil y hacer check-in exitosamente en un encuentro utilizando la nueva infraestructura de microservicios."

#### 5.2.2.2 Development Evidence for Sprint Review

\
![Sprint Backlog 2](assets/img/cap5/SprintBacklog2-part2.png)
\
[Ver Sprint Backlog 2 en Jira](https://fundamentos.atlassian.net/jira/software/projects/HGS1/boards/34/backlog?atlOrigin=eyJpIjoiY2E3Mzk2N2MyN2U4NGYwZGExZGRkM2U2ZGE5MGYyN2QiLCJwIjoiaiJ9)


#### 5.2.2.3 Testing Suite Evidence for Sprint Review

En esta sección se detalla el conjunto de pruebas de integración y aceptación automatizadas que validan la lógica de negocio de la plataforma Glottia correspondiente al Sprint 2. Para el diseño de estas suites, el equipo ha adoptado el enfoque de **Behavior-Driven Development (BDD)**, utilizando el lenguaje **Gherkin**.

Esta metodología permite definir el comportamiento del sistema desde la perspectiva del usuario mediante escenarios estructurados (*Given-When-Then*), facilitando la verificación técnica de los Web Services y asegurando que cada microservicio —Venues, Promotions, Learning Feedback y Engagement— cumpla estrictamente con las reglas del negocio digital antes de su despliegue.

Durante el Sprint 2 se implementaron los Bounded Contexts de Venues, Promotions, Learning Feedback y Engagement, cubriendo las funcionalidades de gestión de locales comerciales, promociones y ofertas por lealtad, retroalimentación de encuentros mediante autoevaluación y quizzes, y el sistema de gamificación con puntos, insignias, leaderboard y rachas de asistencia.

> **Nota sobre convención de idiomas:** Los archivos Gherkin se escriben en inglés siguiendo la convención del equipo de desarrollo para mantener consistencia con las herramientas de ejecución (Cucumber.js); los mensajes de respuesta al usuario final se mantienen en español según los requisitos de localización del producto.

***

##### 5.3.2.3.1 Venues Microservice — BDD Testing Suite

A continuación, se presentan las especificaciones en código Gherkin encargadas de validar los procesos de gestión de locales comerciales (venues), sus mesas, disponibilidad, galería de fotos y registro de partners en el contexto de Venues.

#### `venue_management.feature` — Relacionado con US-10

\
```gherkin
Feature: Venue Registration and Management
  As a business owner (Partner)
  I want to register my venue in the platform
  So that I can offer my space for language encounters and gain visibility

  Background:
    Given I am authenticated as a partner with ID "partner-123"
    And the venues API endpoint "/api/v1/venues" is available

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

  Scenario: Unauthorized Venue Creation (Escenario #6)
    Given I am not authenticated
    When I send a POST request to "/api/v1/venues" with valid data
    Then the system should return a status code 401

  Scenario: Invalid Capacity Value (Escenario #7)
    Given I am authenticated as a partner with ID "partner-123"
    When I send a POST request to "/api/v1/venues" with "capacity" as -5
    Then the system should return a status code 400
    And the response should indicate "La capacidad debe ser un número positivo"

  Scenario: Invalid Operating Hours Format (Escenario #8)
    Given I am authenticated as a partner with ID "partner-123"
    When I send a POST request to "/api/v1/venues" with "operatingHours" as "invalid-time"
    Then the system should return a status code 400
    And the response should indicate "El formato de horario es inválido"
```

#### `venue_edition.feature` — Relacionado con US-11

\
```gherkin
Feature: Venue Information Edition
  As a Partner
  I want to edit the details of my registered venue
  So that I can keep the information up to date

  Background:
    Given I am authenticated as a partner with ID "partner-123"
    And a venue with ID "venue-123" exists and is in "ACTIVE" status

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
    Given I am authenticated as a partner with ID "partner-123"
    When I attempt to change the venue address
    Then the system should return a status code 200
    And the venue status should revert to "PENDING_APPROVAL"
    And an administrator must revalidate the new address

  Scenario: Audit Trail on Edition (Escenario #4)
    Given a venue was edited by a partner
    When an administrator sends a GET request to "/api/v1/venues/venue-123/audit-log"
    Then the system should return a status code 200
    And the response should contain entries with "changedBy", "field", "oldValue", "newValue", and "timestamp"

  Scenario: Unauthorized Venue Edition (Escenario #5)
    Given I am not authenticated
    When I send a PUT request to "/api/v1/venues/venue-123" with valid data
    Then the system should return a status code 401
```

#### `venue_photos.feature` — Relacionado con US-12

\
```gherkin
Feature: Venue Photo Gallery Management
  As a Partner
  I want to upload multiple photos of my venue
  So that I can make it more attractive to learners

  Background:
    Given I am authenticated as a partner with ID "partner-123"
    And a venue with ID "venue-123" exists and is active

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

  Scenario: Unauthorized Photo Upload (Escenario #5)
    Given I am not authenticated
    When I send a POST request to "/api/v1/venues/venue-123/photos" with a valid image
    Then the system should return a status code 401
```

#### `venue_minimum_consumption.feature` — Relacionado con US-13

\
```gherkin
Feature: Minimum Consumption Configuration
  As a Partner
  I want to optionally define a suggested minimum consumption for attendees
  So that I can ensure economic return from encounters held at my venue

  Background:
    Given I am authenticated as a partner with ID "partner-123"
    And a venue with ID "venue-123" exists and is active

  Scenario: Set Minimum Consumption Successfully (Escenario #1)
    When I send a PATCH request to "/api/v1/venues/venue-123" with "minimumConsumption" as 10.00
    Then the system should return a status code 200
    And the minimum consumption amount should appear on all encounter details for this venue

  Scenario: Learner Visibility of Minimum Consumption (Escenario #2)
    Given a venue has a minimum consumption of $10
    When a learner views an encounter scheduled at this venue
    Then the encounter detail page should display "Consumo mínimo sugerido: $10.00"

  Scenario: Update Minimum Consumption (Escenario #3)
    Given I am authenticated as a partner with ID "partner-123"
    When I change the minimum consumption from $10 to $15
    Then all upcoming encounters should reflect the new value

  Scenario: Disable Minimum Consumption (Escenario #4)
    Given I am authenticated as a partner with ID "partner-123"
    When I set "minimumConsumption" to 0 or null
    Then the encounters at this venue should no longer display a minimum consumption notice

  Scenario: Unauthorized Minimum Consumption Update (Escenario #5)
    Given I am not authenticated
    When I send a PATCH request to "/api/v1/venues/venue-123" with "minimumConsumption" as 10.00
    Then the system should return a status code 401

  Scenario: Negative Minimum Consumption (Escenario #6)
    Given I am authenticated as a partner with ID "partner-123"
    When I send a PATCH request to "/api/v1/venues/venue-123" with "minimumConsumption" as -5.00
    Then the system should return a status code 400
    And the response should indicate "El consumo mínimo debe ser un valor positivo o cero"
```

#### `partner_venue_registry.feature` — Relacionado con US-10 (Registro de Partner)

\
```gherkin
Feature: Partner Venue Registry Management
  As a Partner
  I want to manage the association between my account and my venues
  So that I can control which venues are active on the platform

  Background:
    Given I am authenticated as a partner with ID "partner-123"
    And a registered partner with ID "partner-123"

  Scenario: Register Venue Under Partner (Escenario #1)
    When I send a POST request to "/api/v1/partner-venue-registries/partner-123/venues" with valid venue data
    Then the system should return a status code 201
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

  Scenario: Unauthorized Venue Registration (Escenario #5)
    Given I am not authenticated
    When I send a POST request to "/api/v1/partner-venue-registries/partner-123/venues" with valid data
    Then the system should return a status code 401
```

#### `venue_dashboard.feature` — Relacionado con US-14

\
```gherkin
Feature: Partner Venue Dashboard
  As a Partner
  I want to access a summary of my venue activity
  So that I can quickly understand how many encounters have taken place and how many people attended

  Background:
    Given I am authenticated as a partner with ID "partner-123"
    And a partner with ID "partner-123" and an active venue "venue-123"

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

  Scenario: Unauthorized Dashboard Access (Escenario #4)
    Given I am not authenticated
    When I send a GET request to "/api/v1/venues/venue-123/encounter-statistics"
    Then the system should return a status code 401

  Scenario: Unauthorized Access to Another Partner's Dashboard (Escenario #5)
    Given I am authenticated as a partner with ID "partner-999"
    When I send a GET request to "/api/v1/venues/venue-123/encounter-statistics"
    Then the system should return a status code 403
    And the response should indicate "No tienes acceso a las estadísticas de este local"
```

***

##### 5.3.2.3.2 Promotions Microservice — BDD Testing Suite

A continuación, se detallan las especificaciones Gherkin enfocadas en validar la gestión de promociones y ofertas especiales para aprendices según su nivel de lealtad dentro del microservicio Promotions.

#### `promotion_management.feature` — Relacionado con US-34

\
```gherkin
Feature: Promotion Management
  As a platform administrator
  I want to create and manage promotions
  So that partners can offer special deals to loyal learners

  Background:
    Given I am authenticated as an administrator with ID "admin-001"
    And the promotions API endpoint "/api/v1/promotions" is available

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
    When I send a PATCH request to "/api/v1/promotions/promo-123" with body {"status": "INACTIVE"}
    Then the system should return a status code 200
    And the promotion should no longer be available for redemption

  Scenario: Unauthorized Promotion Creation (Escenario #6)
    Given I am not authenticated
    When I send a POST request to "/api/v1/promotions" with valid promotion data
    Then the system should return a status code 401

  Scenario: Invalid Discount Percentage (Escenario #7)
    Given I am authenticated as an administrator with ID "admin-001"
    When I send a POST request to "/api/v1/promotions" with "discountPercentage" as 150
    Then the system should return a status code 400
    And the response should indicate "El porcentaje de descuento no puede exceder 100"
```

#### `promotion_redemption.feature` — Relacionado con US-34

\
```gherkin
Feature: Promotion Redemption
  As a loyal learner
  I want to redeem promotions at partner venues
  So that I can receive rewards for my participation

  Background:
    Given I am authenticated as a learner with ID "learner-123"
    And a learner with ID "learner-123" has reached loyalty level "ORO"
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

  Scenario: Unauthorized Redemption (Escenario #4)
    Given I am not authenticated
    When I send a POST request to "/api/v1/promotions/promo-123/redeem?venueId=venue-123"
    Then the system should return a status code 401

  Scenario: Redemption Blocked by Insufficient Loyalty Level (Escenario #5)
    Given I am authenticated as a learner with ID "learner-456"
    And a learner with ID "learner-456" has loyalty level "BRONCE"
    And a promotion "promo-123" exists with required loyalty level "ORO"
    When I send a POST request to "/api/v1/promotions/promo-123/redeem?venueId=venue-123"
    Then the system should return a status code 403
    And the response should indicate "No cumples el nivel de lealtad requerido para esta promoción"
```

#### `venue_promotion_link.feature` — Relacionado con US-34

\
```gherkin
Feature: Venue Promotion Association
  As a platform administrator
  I want to associate promotions to specific venues
  So that learners can redeem offers at participating locations

  Background:
    Given I am authenticated as an administrator with ID "admin-001"
    And a venue with ID "venue-123" exists and is active
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

##### 5.3.2.3.3 Learning Feedback Microservice — BDD Testing Suite

A continuación, se presentan las especificaciones Gherkin orientadas a validar el flujo de feedback de encuentros, incluyendo autoevaluación, coevaluación y quizzes generados por IA dentro del microservicio Learning Feedback.

#### `self_assessment.feature` — Relacionado con US-25

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

#### `peer_feedback.feature` — Relacionado con US-25

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

#### `quiz_management.feature` — Relacionado con US-25 (Engagement Quiz)

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

##### 5.3.2.3.4 Engagement Microservice — BDD Testing Suite

A continuación, se detallan las especificaciones Gherkin diseñadas para validar el sistema de gamificación y lealtad del microservicio Engagement, incluyendo puntos, insignias, leaderboard y rachas.

#### `loyalty_points.feature` — Relacionado con US-29 y US-30

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

#### `badges_unlock.feature` — Relacionado con US-31 y US-32

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

#### `leaderboard.feature` — Relacionado con US-33

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

#### `loyalty_streak.feature` — Relacionado con US-35

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

#### 5.3.2.4 Execution Evidence for Sprint Review

En esta sección el equipo presenta la evidencia de ejecución de la aplicación móvil.

#### Home

![Sección principal](assets/img/cap5/spb2/home.png)

#### Social

![Redes sociales](assets/img/cap5/spb2/social.png)

#### Practise

![Práctica](assets/img/cap5/spb2/practise.png)

#### Profiles

![Perfiles de usuario](assets/img/cap5/spb2/profiles.png)

#### 5.2.2.5 Microservices Documentation Evidence for Sprint Review
### Swagger/OpenAPI Documentation Evidence

La documentación de los Web Services para los microservicios del Sprint 2 fue desarrollada utilizando **OpenAPI/Swagger** mediante **SpringDoc**, permitiendo definir formalmente los endpoints REST, parámetros de entrada, estructuras de request/response y códigos HTTP soportados.

A continuación, se presentan las capturas de la interfaz Swagger UI correspondientes a cada microservicio desplegado.

---

#### Swagger Evidence — Venues Microservice

La documentación Swagger/OpenAI para el microservicio Venues expone los controladores responsables de la gestión de locales, mesas, disponibilidad y registros de partner.

![Vista general de la especificación OpenAPI del microservicio Venues, mostrando los endpoints para gestión de locales, mesas y registro de partners](assets/img/cap5/venues-swagger.png)

---

#### Swagger Evidence — Promotions Microservice

La documentación Swagger/OpenAPI para el microservicio Promotions cubre la creación, asociación a venues y canje de promociones.

![Interfaz Swagger UI del microservicio Promotions, detallando los endpoints para administración de promociones y su vinculación con locales.](assets/img/cap5/promotions-swagger.png)

---

#### Swagger Evidence — Learning Feedback Microservice

La documentación Swagger/OpenAPI para el microservicio Learning Feedback expone los endpoints de autoevaluación, coevaluación y quizzes generados por IA.

![Panel Swagger UI del microservicio Learning Feedback, listando los controladores para gestión de feedback y quizzes](assets/img/cap5/feedback-swagger.png)

---

#### Swagger Evidence — Engagement Microservice

La documentación Swagger/OpenAPI para el microservicio Engagement expone los endpoints de cuentas de lealtad, insignias y leaderboard.

![Interfaz Swagger UI del microservicio Engagement, mostrando los endpoints para el sistema de gamificación y lealtad](assets/img/cap5/engagement-swagger.png)


---

#### 5.3.2.6 Software Deployment Evidence for Sprint Review

En el Deployment de los microservicios del Sprint 2, se utilizó AWS en la region us-east-2 como plataforma de hosting para garantizar escalabilidad y alta disponibilidad. También se utilizo terraform para la infraestructura como código, permitiendo definir y gestionar los recursos de AWS de forma automatizada y reproducible. Cada microservicio fue desplegado como una aplicación independiente utilizando RabbitMQ como sistema de mensajería para la comunicación entre servicios, y PostgresSQL como base de datos relacional para el almacenamiento de datos persistentes.

Aquí las capturas de ejecución de la consola ejecutando los scripts de Terraform para el despliegue de la infraestructura en AWS, evidenciando la creación de recursos como instancias EC2, RDS para PostgreSQL y configuración de RabbitMQ.

![Terraform Deployment Captura 1](assets/img/cap5/sprint2/deploy-evidences/terraform-evidence-1.png)

![Terraform Deployment Captura 2](assets/img/cap5/sprint2/deploy-evidences/terraform-evidence-2.png)

![Terraform Deployment Captura 3](assets/img/cap5/sprint2/deploy-evidences/terraform-evidence-3.png)

Ahora las capturas de evidencia de despliegue exitoso de cada microservicio en AWS.

Repositorios en Amazon Elastic Container Registry (ECR) con las imágenes Docker de cada microservicio:

![ECR Repositories](assets/img/cap5/sprint2/deploy-evidences/ecr-repositories.png)

Base de datos compartida en Amazon RDS para PostgreSQL, que van a usar por el momento los microservicios:

![RDS PostgreSQL](assets/img/cap5/sprint2/deploy-evidences/rds-postgresql.png)

VPC configurada con subredes públicas y privadas, grupos de seguridad y balanceador de carga para el acceso a los microservicios:

![VPC Configuration](assets/img/cap5/sprint2/deploy-evidences/vpc-configuration.png)


#### 5.3.2.7 Team Collaboration Insights during Sprint

Durante el Sprint 2, el equipo de desarrollo de Glottia enfocó sus esfuerzos en la migración de la arquitectura del sistema desde un monolito modular hacia una arquitectura basada en microservicios. Esta transición tuvo como objetivo mejorar la escalabilidad, mantenibilidad y flexibilidad de la plataforma.

Las principales actividades incluyeron la separación de los dominios de negocio en microservicios independientes, la contenerización de los servicios mediante Docker, la implementación de mecanismos de autenticación y autorización con JWT, y la integración de RabbitMQ para la comunicación asíncrona entre servicios. Asimismo, se realizaron ajustes de integración, corrección de errores derivados de la migración y tareas de despliegue e infraestructura.

\
![Sprint 2-Commits-IAM](assets/img/cap5/feat-iam.PNG)
\
![Sprint 2-Commits-feedback](assets/img/cap5/feat-feedback.PNG)
\
![Sprint 2-Commits-promotions](assets/img/cap5/feat-promotions.PNG)
\
![Sprint 2-Commits-venues](assets/img/cap5/feat-venues.PNG)

#### 5.3.2.8 Kanban Board --> (Avance 3)
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

#### 5.2.3.1 Sprint Backlog 3

El Sprint 3 tiene una duración de 2 semanas y se enfoca en la consolidación de la arquitectura basada en microservicios mediante la migración de los módulos de Notifications y Verification desde el monolito hacia servicios independientes, cada uno dockerizado y con su propia lógica de negocio desacoplada.

Este sprint abarca tres frentes principales de trabajo: en primer lugar, la implementación de los microservicios de notificaciones y verificación, incluyendo el envío de mensajes (email/push) y la validación de usuarios mediante códigos OTP; en segundo lugar, la integración de estos servicios con el ecosistema existente de microservicios utilizando RabbitMQ para la comunicación asíncrona basada en eventos; y en tercer lugar, la corrección de errores derivados de la migración, así como la validación del flujo completo de registro, autenticación y verificación de usuarios dentro de la plataforma.

Sprint Goal

“Nuestro enfoque está en migrar los microservicios de Notifications y Verification a servicios independientes e integrarlos mediante mensajería asíncrona con RabbitMQ. Creemos que esto entrega una arquitectura más desacoplada, segura y escalable, y mejora la comunicación del sistema con los usuarios. Esto se confirmará cuando un usuario pueda registrarse, recibir una notificación y completar exitosamente su proceso de verificación utilizando la nueva infraestructura de microservicios.”

#### 5.2.3.2 Development Evidence for Sprint Review

\
![Sprint 3 Backlog](assets/img/cap5/sprint3/BacklogSP3-1.png)
\
![Sprint 3 Backlog](assets/img/cap5/sprint3/BacklogSP3-2.png)
\

#### 5.2.3.3 Testing Suite Evidence for Sprint Review

A continuación, se presentan las especificaciones en formato Gherkin para validar el correcto funcionamiento de los microservicios de Verification y Notifications, asegurando la cobertura de los escenarios definidos en las historias de usuario del Sprint 3.


### **Verification Microservice Testing Suite**

A continuación, se presentan las especificaciones Gherkin para validar el microservicio de **Verification (IAM)**, incluyendo registro, autenticación, seguridad y recuperación de cuentas.

---

#### `registration.feature` (Relacionado con US01)

```gherkin
Feature: User Registration and Email Verification
  As a new user
  I want to register and verify my account
  So that I can access the platform securely

  Background:
    Given the IAM endpoint "/api/v1/auth/register" is available

  Scenario: Successful Registration (Escenario #1)
    When I send a POST request with valid email and strong password
    Then the system should return status code 201
    And the account should be created
    And a verification email should be sent

  Scenario: Duplicate Email (Escenario #2)
    Given an email already exists in the system
    When I attempt to register with that email
    Then the system should return status code 400
    And show "Este correo ya está registrado"

  Scenario: Weak Password Validation (Escenario #3)
    When I submit a password that does not meet requirements
    Then the system should reject the request
    And return validation errors

  Scenario: Email Verification Expiration (Escenario #4)
    Given a user has not verified their email within 24 hours
    When the verification period expires
    Then the account should be automatically deactivated
```

---

#### `authentication.feature` (Relacionado con US03 y US04)

```gherkin
Feature: User Authentication and Session Management
  As a registered user
  I want to securely login and logout
  So that my session is properly managed

  Background:
    Given the IAM endpoint "/api/v1/auth" is available

  Scenario: Successful Login (US03 - Escenario #1)
    Given a verified user exists
    When I send valid credentials to "/login"
    Then the system should return status code 200
    And generate a valid JWT token

  Scenario: Invalid Credentials (US03 - Escenario #2)
    When I login with incorrect credentials
    Then the system should return status code 401
    And show "Email o contraseña inválidos"

  Scenario: Unverified Email Login (US03 - Escenario #3)
    Given a user has not verified their email
    When they try to login
    Then access should be denied
    And offer resend verification email

  Scenario: Account Lock After Failed Attempts (US03 - Escenario #5)
    Given 5 consecutive failed attempts
    When I try again
    Then the account should be locked for 30 minutes

  Scenario: Successful Logout (US04 - Escenario #1)
    Given an authenticated user
    When I request logout
    Then the system should invalidate the token
    And clear session data

  Scenario: Automatic Session Expiration (US04 - Escenario #2)
    Given a user is inactive for 30 minutes
    When they perform an action
    Then the system should force reauthentication
```

---

#### `password_recovery.feature` (Relacionado con US05)

```gherkin
Feature: Password Recovery and Reset
  As a user
  I want to recover my password securely
  So that I can regain access to my account

  Background:
    Given the endpoint "/api/v1/auth/recover-password" is available

  Scenario: Password Recovery Request (Escenario #1)
    When I submit my email
    Then the system should send a reset link valid for 1 hour

  Scenario: Email Not Found (Escenario #2)
    When I submit an unregistered email
    Then the system should respond with generic message
    And not reveal if the account exists

  Scenario: Expired Reset Link (Escenario #3)
    Given a reset link older than 1 hour
    When I try to use it
    Then the system should reject it
    And require a new request

  Scenario: Successful Password Reset (Escenario #4)
    Given a valid reset link
    When I submit a new valid password
    Then the password should be updated
    And login should be enabled

  Scenario: Abuse Prevention (Escenario #5)
    Given multiple reset requests in short time
    When exceeding 3 attempts in 10 minutes
    Then the system should temporarily block new requests
```

---

### **Notifications Microservice Testing Suite**

A continuación, se detallan las especificaciones Gherkin para validar el microservicio de **Notifications**, incluyendo recordatorios, eventos en tiempo real y mensajería.

---

#### `event_reminders.feature` (Relacionado con US22)

```gherkin
Feature: Event Reminder Notifications
  As a learner
  I want reminders for my upcoming events
  So that I do not miss them

  Background:
    Given the notifications endpoint "/api/v1/notifications" is available

  Scenario: 24-Hour Reminder (Escenario #1)
    Given a user has a reservation
    When there are 24 hours remaining
    Then the system should send email and push notification

  Scenario: 2-Hour Reminder (Escenario #2)
    Given an event is approaching
    When 2 hours remain
    Then the system should send push notification

  Scenario: Disable Reminders (Escenario #3)
    Given a user disabled reminders
    When the reminder time arrives
    Then no notification should be sent

  Scenario: Cancelled Event (Escenario #4)
    Given an event was cancelled
    When reminder time arrives
    Then no notification should be triggered
```

---

#### `waitlist_notifications.feature` (Relacionado con US24)

```gherkin
Feature: Waitlist Notification System
  As a learner in waitlist
  I want to be notified when a spot is available
  So that I can reserve it quickly

  Background:
    Given the waitlist notification service is active

  Scenario: Spot Available Notification (Escenario #1)
    Given a user is in waitlist
    When a spot is released
    Then the system should notify immediately
    And include confirmation link

  Scenario: Confirmation Timeout (Escenario #2)
    Given user receives notification
    When 15 minutes pass without confirmation
    Then the spot should be reassigned

  Scenario: Successful Reservation from Waitlist (Escenario #3)
    When user confirms quickly
    Then the reservation should be secured

  Scenario: Multiple Waitlists (Escenario #4)
    Given a user is in multiple waitlists
    When spots open
    Then notifications should be sent independently
```

---

#### `social_notifications.feature` (Relacionado con US42)

```gherkin
Feature: Social Interaction Notifications
  As a learner
  I want to receive contact request notifications
  So that I can manage my connections

  Background:
    Given the social notifications system is active

  Scenario: New Contact Request Notification (Escenario #1)
    Given a user receives a contact request
    When the request is created
    Then the system should notify the user

  Scenario: Manage Requests (Escenario #2)
    Given pending requests exist
    When user views them
    Then they can accept or reject each request
```

---

#### `message_notifications.feature` (Relacionado con US45)

```gherkin
Feature: Messaging Notifications
  As a user
  I want to receive notifications for new messages
  So that I can respond on time

  Background:
    Given the messaging notification system is active

  Scenario: In-App Notification (Escenario #1)
    Given user is active in app
    When a message arrives
    Then an in-app notification should be shown

  Scenario: Push Notification (Escenario #2)
    Given app is in background
    When a message arrives
    Then a push notification should be sent

  Scenario: Silent Conversation (Escenario #3)
    Given a conversation is muted
    When messages arrive
    Then notifications should not be sent

  Scenario: Do Not Disturb Mode (Escenario #4)
    Given DND is active
    When a message arrives
    Then it should be stored silently without alert
```

#### 5.2.3.4 Execution Evidence for Sprint Review

Durante el Sprint 3 se logró implementar y validar el flujo principal del sistema desde la perspectiva del usuario Partner, cubriendo desde el registro hasta la gestión operativa de locales y encuentros. A continuación, se presenta la evidencia visual que respalda el cumplimiento del Sprint Goal.

---

#### 1. Registro de Usuario 

Se implementó la interfaz de creación de cuenta, permitiendo a nuevos usuarios registrarse en la plataforma mediante correo electrónico y contraseña.
\
![Registro de Usuario](assets/img/cap5/sprint3/Registro-Usuario.PNG)
\
**Resultado:**
El sistema permite la creación de nuevas cuentas, validando datos de entrada y estableciendo el punto de acceso al sistema.

---

#### 2. Completar Perfil del Partner

Luego del registro, el usuario debe completar su perfil con información personal, datos del negocio y datos de contacto.
\
![Completar Perfil](assets/img/cap5/sprint3/Completar-Perfil.PNG)
\
**Resultado:**
Se valida la persistencia de datos del usuario y la correcta estructuración del perfil del partner dentro del sistema.

---

#### 3. Dashboard Principal

Se desarrolló el dashboard principal donde el usuario visualiza métricas clave como encuentros, reservas activas, tasa de asistencia y promociones.
\
![Dashboard Principal](assets/img/cap5/sprint3/Dashboard-Principal.PNG)
\
**Resultado:**
El usuario puede visualizar información resumida y relevante de sus operaciones, confirmando la integración de datos desde múltiples servicios.

---

#### 4. Gestión de Locales

El sistema permite la visualización y edición de locales registrados, incluyendo información como dirección, capacidad y tipo de establecimiento.
\
![Gestión de Locales](assets/img/cap5/sprint3/Gestion-Locales.PNG)
\
**Resultado:**
Se valida la funcionalidad CRUD de locales, asegurando la correcta gestión de recursos del partner.

---

#### 5. Historial de Encuentros

Se implementó la vista de historial de encuentros, donde el usuario puede consultar eventos pasados, estado, asistencia y detalles asociados.

\
![Historial de Encuentros](assets/img/cap5/sprint3/Historial-Encuentros.PNG)
\
**Resultado:**
El sistema permite la trazabilidad de eventos, mostrando información clave para la toma de decisiones del usuario.

---


#### 5.2.3.5 Microservices Documentation Evidence for Sprint Review

Durante el Sprint 3, la documentación de los microservicios fue actualizada utilizando SpringDoc OpenAPI, permitiendo visualizar y validar los endpoints implementados.


### Swagger Evidence — Notifications Microservice

La documentación expone los endpoints relacionados con el envío de notificaciones y procesamiento de eventos.

\
![Interfaz Swagger UI del microservicio Notifications](assets/img/cap5/sprint3/Microservice-Verifications.jpeg)

\
![Interfaz Swagger UI del microservicio Notifications-Preferences](assets/img/cap5/sprint3/Micro-notifications-pref.jpeg)

---

### Swagger Evidence — Verification Microservice

La documentación expone los endpoints para generación y validación de códigos de verificación.

\
![Interfaz Swagger UI del microservicio Verification](assets/img/cap5/sprint3/Microservice-Notidications.jpeg)

--- 

#### 5.2.3.6 Software Deployment Evidence for Sprint Review

En el Deployment de los microservicios del Sprint 3, se utilizó AWS en la region us-east-2 como plataforma de hosting para garantizar escalabilidad y alta disponibilidad. También se utilizo terraform para la infraestructura como código, permitiendo definir y gestionar los recursos de AWS de forma automatizada y reproducible. Cada microservicio fue desplegado como una aplicación independiente utilizando RabbitMQ como sistema de mensajería para la comunicación entre servicios, y PostgresSQL como base de datos relacional para el almacenamiento de datos persistentes.

Aquí las capturas de ejecución de la consola ejecutando los scripts de Terraform para el despliegue de la infraestructura en AWS, evidenciando la creación de recursos como instancias EC2, RDS para PostgreSQL y configuración de RabbitMQ.

![Terraform Deployment Captura 1](assets/img/cap5/sprint2/deploy-evidences/terraform-evidence-1.png)

![Terraform Deployment Captura 2](assets/img/cap5/sprint2/deploy-evidences/terraform-evidence-2.png)

![Terraform Deployment Captura 3](assets/img/cap5/sprint2/deploy-evidences/terraform-evidence-3.png)

Ahora las capturas de evidencia de despliegue exitoso de cada microservicio en AWS.

Repositorios en Amazon Elastic Container Registry (ECR) con las imágenes Docker de cada microservicio:

![ECR Repositories](assets/img/cap5/sprint2/deploy-evidences/ecr-repositories.png)

Base de datos compartida en Amazon RDS para PostgreSQL, que van a usar por el momento los microservicios:

![RDS PostgreSQL](assets/img/cap5/sprint2/deploy-evidences/rds-postgresql.png)

VPC configurada con subredes públicas y privadas, grupos de seguridad y balanceador de carga para el acceso a los microservicios:

![VPC Configuration](assets/img/cap5/sprint2/deploy-evidences/vpc-configuration.png)

#### 5.2.3.7 Team Collaboration Insights during Sprint


Durante el Sprint 3, el equipo de desarrollo de Glottia centró sus esfuerzos en la implementación de funcionalidades end-to-end desde la perspectiva del usuario Partner, asegurando la correcta interacción entre la interfaz web y la arquitectura de microservicios previamente establecida.

Las principales actividades incluyeron el desarrollo de las interfaces de usuario para el registro e inicio de sesión, la implementación del flujo de onboarding mediante el completado del perfil del partner, y la construcción del dashboard principal con métricas relevantes como encuentros, reservas activas y promociones. Asimismo, se desarrollaron las funcionalidades de gestión de locales (creación, edición y visualización) y la visualización del historial de encuentros, permitiendo al usuario administrar sus operaciones dentro de la plataforma.

En paralelo, se realizaron tareas de integración entre frontend y backend, validación de endpoints mediante pruebas basadas en escenarios Gherkin, así como la corrección de errores y mejoras en la experiencia de usuario. Estas actividades permitieron consolidar un flujo funcional completo desde el registro hasta la gestión operativa, alineado con los objetivos del sprint.

\
![Sprint 3 - Registro](assets/img/cap5/sprint3/commits-notifications.PNG)
\
![Sprint 3 - Registro](assets/img/cap5/sprint3/commits-verifications.PNG)
\
![Sprint 3 - Registro](assets/img/cap5/sprint3/commits-web.PNG)
\


#### 5.2.3.8 Kanban Board --> (Avance 4)
\
![Sprint 3 Kanban Board](assets/img/cap5/sprint3/KanbanSP3.png)
\