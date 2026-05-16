# Capítulo III: Requirements Specification

En este capítulo se detallan los requisitos del proyecto, incluyendo los To-be Scenario Mappings, User Stories, Impact Map y el Product Backlog. Estos elementos son fundamentales para guiar el desarrollo del proyecto y asegurar que se cumplan las necesidades y expectativas de los usuarios finales.

La especificación parte de los hallazgos obtenidos en el Capítulo II, donde las entrevistas y el needfinding permitieron identificar una necesidad clara de práctica oral estructurada para aprendices, así como control operativo, gestión de cupos y valor comercial para los locales aliados. Con base en esa evidencia, los requisitos de este capítulo traducen los dolores, motivaciones y restricciones de ambos segmentos en escenarios y funcionalidades priorizadas.

## 3.1	To-Be Scenario Mapping

A continuación se presenta el To-Be Scenario Mapping para la aplicación de práctica de idiomas, que ilustra cómo los usuarios interactuarán con el sistema para practicar idiomas en espacios locales. Como tenemos dos segmentos objetivos (practicantes de idiomas y establecimientos aliados), se han desarrollado dos escenarios distintos para cada uno de ellos, con el fin de capturar sus respectivas experiencias y necesidades.

### Escenario 1: Experiencia del estudiante de idiomas
 
![to-be-scenario-1](assets/img/cap3/to-be-scenario1.jpg)

Este escenario describe el viaje de un usuario que busca practicar un idioma. Abarca desde la búsqueda inicial con filtros personalizados y la reserva de un cupo en una mesa temática, hasta la validación de asistencia mediante código QR en el establecimiento aliado y el seguimiento de su evolución a través de retroalimentación y recompensas por lealtad. El proceso está diseñado para generar una experiencia de aprendizaje flexible, segura y motivadora que fomente el sentido de comunidad.

### Escenario 2: Experiencia del establecimiento aliado
 
![to-be-scenario-2](assets/img/cap3/to-be-scenario2.jpg)

Este escenario detalla la interacción de los negocios asociados (cafeterías) con la plataforma. Inicia con la configuración del perfil y disponibilidad del local, seguido por la gestión y validación de reservas durante los encuentros. Adicionalmente, incluye el análisis de métricas mediante un panel de control (dashboard) y culmina con la optimización de la oferta a través de promociones basadas en datos. El objetivo principal es maximizar la ocupación en horas valle, incrementar la rentabilidad y fidelizar a una nueva clientela.


## 3.2	User Stories

A continuación se presentan las User Stories detalladas para cada Epic del proyecto, organizadas en tablas para facilitar su lectura y seguimiento. Cada User Story incluye un título, una descripción clara del requisito, y escenarios específicos que ilustran cómo se espera que los usuarios interactúen con la aplicación para cumplir con sus necesidades.

**Escala de Story Points y su Interpretación:**

| Story Points | Descripción Técnica | Riesgo e Incertidumbre | Complejidad de Dominio (DDD) |
| :--- | :--- | :--- | :--- |
| **1** | **Trivial:** Cambios en UI estática o ajustes menores en lógica pura sin efectos secundarios. | Casi nulo. | Entidad aislada sin lógica de negocio. |
| **2** | **Simple:** CRUD estándar dentro de un solo dominio. Validaciones básicas y persistencia directa. | Bajo. Conocimiento total de la tarea. | Operación básica en un solo *Aggregate*. |
| **3** | **Moderada:** Lógica de negocio específica, validaciones de dominio y coordinación entre capas. | Controlado. Requiere análisis de impacto. | Lógica interna del *Domain Service* o *Value Objects*. |
| **5** | **Compleja:** Integración con servicios externos (APIs, Storage, Maps) o múltiples componentes internos. | Moderado. Dependencias externas o técnicas. | Acoplamiento entre dos o más *Bounded Contexts*. |
| **8** | **Crítica:** Lógica de estados compleja, alta concurrencia, reportes agregados o flujos críticos de seguridad. | Alto. Riesgo de deuda técnica o bloqueos. | Operaciones atómicas que afectan la consistencia global del sistema. |

Con esta escala, se asignan Story Points a cada User Story para reflejar su complejidad técnica, el riesgo asociado y la complejidad del dominio, lo que facilita la planificación y priorización en el desarrollo del proyecto.

## Tabla de User Stories de Landing Page

| Story ID | User | Story Points | Epic |
| :--- | :--- | :--- | :--- |
| US-LP-01 | Visitante de la página | 3 | Landing Page |
| **Título** | **Visualización de la Propuesta de Valor** |  |  |
| **Descripción** | **Como** visitante de la página **Quiero** ver una sección principal atractiva que resuma la idea del producto **para** entender rápidamente de qué se trata el servicio. **Escenario \#1: Carga exitosa del hero section** \- Dado que un visitante accede a la landing page, Cuando la página termina de cargar, Entonces aparece un hero section con el título "Practica idiomas cara a cara", un subtítulo descriptivo, y dos botones CTA diferenciados ("Únete como Aprendiz" y "Registra tu Local"). **Escenario \#2: Página cargada desde cache** \- Dado que un visitante ya ha visitado la landing page anteriormente, Cuando accede nuevamente, Entonces el hero section se carga desde la cache local del navegador reduciendo el tiempo de renderizado. **Escenario \#3: Dispositivo móvil con conexión lenta** \- Dado que un visitante accede desde un smartphone con conexión 3G, Cuando la página está cargando, Entonces se muestra un skeleton loader en el hero section hasta que los elementos visuales se hayan renderizado completamente. |  |  |

| Story ID | User | Story Points | Epic |
| :--- | :--- | :--- | :--- |
| US-LP-02 | Visitante interesado en practicar idiomas | 2 | Landing Page |
| **Título** | **Ver Beneficios para Aprendices** |  |  |
| **Descripción** | **Como** visitante interesado en practicar idiomas **Quiero** ver claramente los beneficios específicos para aprendices **para** entender cómo Glottia me puede ayudar a mejorar. **Escenario \#1: Visualización exitosa de beneficios** \- Dado que un visitante explora la landing page, Cuando se desplaza a la sección de "Para Aprendices", Entonces identifica claramente 3-4 beneficios ("Gana fluidez en conversaciones reales", "Conoce gente nueva", "Acceso accesible sin academias", "Aprende a tu ritmo"), cada uno con descripción breve e icono. **Escenario \#2: Visualización de beneficios con iconografía clara** \- Dado que un visitante accede desde un dispositivo mobile, Cuando visualiza la sección de beneficios, Entonces cada beneficio muestra un icono visual destacado seguido de título y descripción en formato card. **Escenario \#3: Beneficios con testimonios embebidos** \- Dado que un visitante continúa explorando, Cuando desplaza hacia beneficios avanzados, Entonces ve citas breves de aprendices reales sobre cómo Glottia impactó su aprendizaje. |  |  |

| Story ID | User | Story Points | Epic |
| :--- | :--- | :--- | :--- |
| US-LP-03 | Dueño de un local | 2 | Landing Page |
| **Título** | **Ver Beneficios para Locales** |  |  |
| **Descripción** | **Como** dueño de un local **Quiero** ver claramente los beneficios que la plataforma ofrece a mi negocio **para** comprender cómo puede aumentar mis clientes y visibilidad. **Escenario \#1: Visualización exitosa de beneficios empresariales** \- Dado que un dueño de un local visita la landing page, Cuando navega a la sección de "Para Locales", Entonces ve 3-4 beneficios claros ("Atrae nuevos clientes", "Aumenta el consumo en horas valle", "Publicidad gratuita para tu negocio", "Analytics en tiempo real"), cada uno con descripción orientada al ROI. **Escenario \#2: Beneficios con comparación de impacto** \- Dado que un partner observa los beneficios, Cuando desplaza la sección, Entonces ve métricas estimadas (ej: "Promedio 15-20 nuevos clientes por mes", "Aumento de 30% en consumo en horarios bajos"). **Escenario \#3: Call-to-action orientado al negocio** \- Dado que un dueño está convencido, Cuando llega al final de la sección de beneficios, Entonces ve un botón prominente "Registra tu Local Ahora" y un enlace secundario "Ver casos de éxito". |  |  |

| Story ID | User | Story Points | Epic |
| :--- | :--- | :--- | :--- |
| US-LP-04 | Visitante | 3 | Landing Page |
| **Título** | **Explicación de Cómo Funciona** |  |  |
| **Descripción** | **Como** visitante **Quiero** ver una explicación sencilla y visual de cómo funciona la plataforma **para** entender los pasos necesarios para participar. **Escenario \#1: Flujo para aprendices con visualización interactiva** \- Dado que un visitante está en la sección "Cómo Funciona", Cuando hace clic en la pestaña "Aprendices", Entonces ve 4 pasos numerados con íconos: "1. Regístrate", "2. Completa tu perfil", "3. Busca encuentros", "4. ¡Practica y gana puntos\!", cada uno con descripción breve. **Escenario \#2: Flujo para locales con visión empresarial** \- Dado que un visitante está en la sección "Cómo Funciona", Cuando hace clic en la pestaña "Locales", Entonces ve 4 pasos: "1. Registra tu local", "2. Sube fotos y detalles", "3. Recibe reservas", "4. Analiza el impacto", con énfasis en beneficios comerciales. **Escenario \#3: Animación progresiva de pasos** \- Dado que un visitante observa los pasos, Cuando hace desplazamiento hacia abajo, Entonces cada paso se anima progresivamente con efecto fade-in para mantener atención. |  |  |

| Story ID | User | Story Points | Epic |
| :--- | :--- | :--- | :--- |
| US-LP-05 | Visitante indeciso | 3 | Landing Page |
| **Título** | **Visualización de Testimonios** |  |  |
| **Descripción** | **Como** visitante indeciso **Quiero** ver testimonios de aprendices y dueños de locales reales **para** aumentar mi confianza en el servicio. **Escenario \#1: Visualización de testimonios equilibrados** \- Dado que el visitante explora la landing page, Cuando accede a la sección de testimonios, Entonces ve mínimo 2 testimonios de aprendices y 2 de dueños de locales, cada uno mostrando nombre, foto, rol, calificación y comentario. **Escenario \#2: Carrusel interactivo de testimonios** \- Dado que un visitante está en la sección de testimonios, Cuando hace clic en los botones de navegación, Entonces ve diferentes testimonios rotados automáticamente cada 5 segundos o manualmente via flechas. **Escenario \#3: Validación mediante datos cuantitativos** \- Dado que un visitante quiere datos objetivos, Cuando observa la sección de testimonios, Entonces ve también métricas como "4.8/5 estrellas de 250+ reviews" o "+500 encuentros realizados". |  |  |

| Story ID | User | Story Points | Epic |
| :--- | :--- | :--- | :--- |
| US-LP-06 | Visitante | 2 | Landing Page |
| **Título** | **Llamadas a la Acción (CTA) Diferenciadas** |  |  |
| **Descripción** | **Como** visitante **Quiero** ver botones de llamada a la acción claros y separados, uno para aprendices y otro para locales **para** poder registrarme fácilmente según mi interés. **Escenario \#1: CTAs diferenciadas visibles** \- Dado que un visitante accede a la landing page, Cuando observa el hero section, Entonces ve dos botones CTA lado a lado ("Únete como Aprendiz" en color primario y "Registra tu Local" en color secundario). **Escenario \#2: CTAs responsivas en mobile** \- Dado que un visitante accede desde un dispositivo móvil, Cuando visualiza el hero section, Entonces los botones se apilan verticalmente manteniendo su claridad y accesibilidad. **Escenario \#3: Navegación hacia registros correctos** \- Dado que un visitante hace clic en "Únete como Aprendiz", Cuando se redirige, Entonces llega a un formulario de registro específico para aprendices con campos predefinidos (idioma nativo, idiomas de práctica, nivel). |  |  |

| Story ID | User | Story Points | Epic |
| :--- | :--- | :--- | :--- |
| US-LP-07 | Visitante que accede desde diferentes dispositivos | 5 | Landing Page |
| **Título** | **Adaptabilidad a Diferentes Dispositivos (Responsive)** |  |  |
| **Descripción** | **Como** visitante que accede desde diferentes dispositivos **Quiero** que la landing page se adapte correctamente a mi pantalla **para** tener una experiencia óptima independientemente del dispositivo que use. **Escenario \#1: Experiencia en dispositivo móvil** \- Dado que un visitante accede a la landing page desde un smartphone, Cuando la página se carga, Entonces todos los elementos se reorganizan en una sola columna, el texto es legible y los botones son fáciles de presionar, sin necesidad de hacer zoom o scroll horizontal. **Escenario \#2: Experiencia en tablet** \- Dado que un visitante accede desde una tablet, Cuando se carga la página, Entonces se usa un layout de 2 columnas equilibrado optimizado para pantallas de 768-1024px. **Escenario \#3: Experiencia en desktop (2560px)** \- Dado que un visitante accede desde un monitor  ultra ancho, Cuando se carga la página, Entonces el contenido tiene un ancho máximo de 1400px centrado para evitar líneas demasiado largas. |  |  |

| Story ID | User | Story Points | Epic |
| :--- | :--- | :--- | :--- |
| US-LP-08 | Visitante | 3 | Landing Page |
| **Título** | **Navegación mediante Encabezado Fijo** |  |  |
| **Descripción** | **Como** visitante **Quiero** un menú de navegación claro en el encabezado que permanezca visible mientras me desplazo **para** acceder fácilmente a las diferentes secciones de la página. **Escenario \#1: Menú fijo funcional** \- Dado que un visitante explora la landing page, Cuando hace clic en una opción del menú (ej. "Beneficios", "Cómo Funciona", "Testimonios"), Entonces la página se desplaza suavemente hasta esa sección y el encabezado permanece fijo. **Escenario \#2: Indicador visual de sección actual** \- Dado que un visitante se desplaza por la página, Cuando entra en una nueva sección, Entonces el item del menú correspondiente se resalta indicando dónde se encuentra. **Escenario \#3: Menú colapsable en mobile** \- Dado que un visitante accede desde un smartphone, Cuando carga la página, Entonces el menú se convierte en un hamburger menu que se expande/colapsa sin afectar el contenido. **Escenario \#4: Navegación mediante logo** \- Dado que un visitante hace clic en el logo, Cuando lo presiona, Entonces regresa suavemente al hero section (top de la página). |  |  |

| Story ID | User | Story Points | Epic |
| :--- | :--- | :--- | :--- |
| US-LP-09 | Visitante con dudas | 2 | Landing Page |
| **Título** | **Visualización de una Sección de Preguntas Frecuentes (FAQ)** |  |  |
| **Descripción** | **Como** visitante con dudas **Quiero** encontrar una sección de preguntas frecuentes **para** resolver rápidamente mis inquietudes más comunes. **Escenario \#1: Despliegue de FAQ** \- Dado que un visitante se pregunta si tiene que pagar para asistir, Cuando accede a la sección de FAQ y hace clic en la pregunta "¿Tiene algún costo?", Entonces se despliega una respuesta clara indicando que es "100% gratuito para aprendices". **Escenario \#2: Búsqueda dentro de FAQ** \- Dado que un visitante busca rapidez, Cuando utiliza la barra de búsqueda en la sección FAQ, Entonces el sistema filtra las preguntas relevantes en tiempo real. **Escenario \#3: FAQ separadas por segmento** \- Dado que un visitante desea preguntas específicas, Cuando hace clic en "Ver FAQ para Locales", Entonces ve preguntas relevantes al negocio (comisiones, cómo recibir reservas, etc.). **Escenario \#4: Respuestas con links adicionales** \- Dado que una respuesta requiere más información, Cuando lee una respuesta en FAQ, Entonces hay links a secciones relacionadas o a la documentación completa. |  |  |

| Story ID | User | Story Points | Epic |
| :--- | :--- | :--- | :--- |
| US-LP-10 | Visitante | 1 | Landing Page |
| **Título** | **Visualización del Pie de Página (Footer)** |  |  |
| **Descripción** | **Como** visitante **Quiero** ver un pie de página organizado con enlaces de interés **para** encontrar información adicional o contactar con la empresa. **Escenario \#1: Footer completo con enlaces legales** \- Dado que un visitante se desplaza hasta el final de la landing page, Cuando llega al pie de página, Entonces ve enlaces a "Términos y Condiciones", "Política de Privacidad", "Contacto" y enlaces a redes sociales (LinkedIn, Instagram, Twitter). **Escenario \#2: Información de contacto directa** \- Dado que un visitante desea contactar, Cuando ve el footer, Entonces encuentra un email de contacto y un formulario rápido de contacto. **Escenario \#3: Links secundarios útiles** \- Dado que un visitante busca más información, Cuando observa el footer, Entonces ve links a "Blog", "Documentación", "Reportar un problema". **Escenario \#4: Footer responsive** \- Dado que un visitante accede desde mobile, Cuando visualiza el footer, Entonces los enlaces se distribuyen en columnas apilables sin perder legibilidad. |  |  |

## Tabla de User Stories por Epic

| Story ID | User | Story Points | Epic |
| :--- | :--- | :--- | :--- |
| US01 | Persona interesada en practicar idiomas | 3 | Gestión de Identidad y Acceso (IAM) |
| **Title** | **Registro de nuevo aprendiz** |
| **Description** | **Como** una persona interesada en practicar idiomas **Quiero** registrarme en la plataforma con mi correo y contraseña **para** poder acceder a la comunidad y a los encuentros. **Escenario \#1: Registro exitoso** \- Dado que un nuevo usuario desea unirse a la plataforma, Cuando proporciona email válido, contraseña fuerte (mínimo 8 caracteres, 1 mayúscula, 1 número) y acepta los términos, Entonces el sistema crea su cuenta, envía email de confirmación y lo guía para completar su perfil. **Escenario \#2: Email duplicado** \- Dado que un usuario intenta registrarse con un email ya usado, Cuando envía el formulario, Entonces el sistema muestra error "Este correo ya está registrado" e ofrece opción de recuperar contraseña. **Escenario \#3: Contraseña débil** \- Dado que un usuario ingresa una contraseña débil (menos de 8 caracteres o sin caracteres especiales), Cuando intenta registrarse, Entonces el sistema valida en tiempo real mostrando los requisitos faltantes. **Escenario \#4: Validación de email** \- Dado que un usuario completa el registro, Cuando recibe el email de confirmación, Entonces tiene 24 horas para confirmar su email haciendo clic en el link. Si no confirma, su cuenta se desactiva automáticamente. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US02 | Dueño de un local | 5 | Gestión de Identidad y Acceso (IAM) |
| **Title** | **Registro de nuevo local** |
| **Description** | **Como** dueño de un local **Quiero** registrar mi negocio en la plataforma **para** ofrecer mi espacio para los encuentros y ganar visibilidad. **Escenario \#1: Registro de Partner exitoso** \- Dado que el dueño de un local desea unirse a la plataforma, Cuando proporciona información de cuenta (email, contraseña) e información del negocio (nombre, dirección, teléfono), Entonces el sistema crea una cuenta de tipo "Partner", la asocia al local y otorga acceso al panel de gestión pendiente de aprobación. **Escenario \#2: Validación de dirección** \- Dado que un partner ingresa una dirección, Cuando el sistema valida la ubicación con Google Maps, Entonces confirma que es una dirección válida o sugiere correcciones. **Escenario \#3: Rechazo por validación** \- Dado que un partner intenta registrarse con información incompleta, Cuando falta información crítica (nombre local, dirección, horario), Entonces el sistema bloquea el registro indicando los campos obligatorios. **Escenario \#4: Aprobación manual** \- Dado que el registro se completó correctamente, Cuando un administrador valida los datos del local, Entonces el local se activa y se hace visible en la plataforma.  |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US03 | Usuario registrado (aprendiz o dueño de local) | 3 | Gestión de Identidad y Acceso (IAM) |
| **Title** | **Inicio de sesión general** |
| **Description** | **Como** usuario registrado (aprendiz o dueño de local) **Quiero** iniciar sesión con mi correo y contraseña **para** acceder a mis funcionalidades personalizadas. **Escenario \#1: Inicio de sesión exitoso** \- Dado que un usuario registrado desea acceder a su cuenta, Cuando proporciona sus credenciales de acceso correctas, Entonces el sistema lo autentica, crea sesión segura (JWT/Token) y lo presenta su dashboard personalizado (aprendiz o partner). **Escenario \#2: Credenciales incorrectas** \- Dado que un usuario registrado desea acceder a su cuenta, Cuando proporciona credenciales incorrectas, Entonces el sistema le informa "Email o contraseña inválidos" sin especificar cuál es incorrecto (por seguridad). **Escenario \#3: Email no confirmado** \- Dado que un usuario intenta iniciar sesión pero no confirmó su email, Cuando envía el formulario, Entonces el sistema bloquea el acceso y ofrece reenviar email de confirmación. **Escenario \#4: Cuenta suspendida** \- Dado que un usuario tiene su cuenta suspendida por violación de términos, Cuando intenta iniciar sesión, Entonces ve mensaje "Tu cuenta ha sido suspendida. Contacta con soporte". **Escenario \#5: Múltiples intentos fallidos** \- Dado que un usuario falla 5 veces consecutivas, Cuando intenta nuevamente, Entonces el sistema bloquea la cuenta temporalmente por 30 minutos por seguridad. **Escenario \#6: Sesión expirada** \- Dado que un usuario tiene una sesión abierta hace más de 30 días, Cuando intenta hacer una acción, Entonces se redirige a login pidiendo reautenticación. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US04 | Usuario autenticado | 1 | Gestión de Identidad y Acceso (IAM) |
| **Title** | **Cierre de sesión** |
| **Description** | **Como** usuario autenticado **Quiero** poder cerrar mi sesión **para** proteger la privacidad de mi cuenta en dispositivos compartidos. **Escenario \#1: Cierre de sesión exitoso** \- Dado que un usuario ha iniciado sesión en la plataforma, Cuando solicita finalizar su sesión (botón "Cerrar sesión"), Entonces el sistema invalida el token, limpia cookies locales y lo devuelve a la página de inicio pública. **Escenario \#2: Cierre de sesión automático** \- Dado que un usuario está inactivo por más de 30 minutos, Cuando intenta hacer una acción, Entonces el sistema cierra automáticamente su sesión por seguridad. **Escenario \#3: Cierre de sesión en todos los dispositivos** \- Dado que un usuario sospecha que su cuenta fue comprometida, Cuando selecciona "Cerrar sesión en todos los dispositivos", Entonces todas sus sesiones activas se cierran. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US05 | Usuario registrado | 2 | Gestión de Identidad y Acceso (IAM) |
| **Title** | **Recuperación de contraseña** |
| **Description** | **Como** usuario registrado **Quiero** solicitar un enlace para restablecer mi contraseña si la he olvidado **para** poder recuperar el acceso a mi cuenta. **Escenario \#1: Solicitud de recuperación exitosa** \- Dado que un usuario olvidó su contraseña, Cuando proporciona el correo electrónico de su cuenta en la página de recuperación, Entonces el sistema envía un correo con link de restablecimiento válido por 1 hora. **Escenario \#2: Email no encontrado** \- Dado que un usuario ingresa un email no registrado, Cuando envía la solicitud, Entonces el sistema muestra "Si esta cuenta existe, recibirá un email" (por seguridad, no confirma si existe o no). **Escenario \#3: Link expirado** \- Dado que un usuario intenta usar un link de recuperación después de 1 hora, Cuando accede al link, Entonces ve "Este link ha expirado" y opción de solicitar uno nuevo. **Escenario \#4: Establecer nueva contraseña** \- Dado que un usuario accede con un link válido, Cuando ingresa una nueva contraseña (con validaciones de seguridad), Entonces se restablece exitosamente y puede iniciar sesión. **Escenario \#5: Cambio de contraseña múltiple** \- Dado que un usuario genera 3 links de restablecimiento en menos de 10 minutos, Cuando solicita uno nuevo, Entonces el sistema le pide esperar 10 minutos (prevención de abuso). |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US06 | Nuevo aprendiz | 3 | Perfiles de Usuario (Profiles) |
| **Title** | **Completar perfil de aprendiz** |
| **Description** | **Como** nuevo aprendiz **Quiero** completar mi perfil con mi idioma nativo, los idiomas que quiero practicar y mi nivel **para** que otros usuarios me conozcan y el sistema me recomiende encuentros relevantes. **Escenario \#1: Primer llenado de perfil** \- Dado que un aprendiz se ha registrado, Cuando especifica su idioma nativo, idiomas para practicar (mínimo 1), nivel de fluidez y guarda, Entonces su perfil se actualiza y el sistema recomienza a sugerir encuentros en su dashboard. **Escenario \#2: Validación de idiomas** \- Dado que un aprendiz intenta guardar sin seleccionar ningún idioma a practicar, Cuando envía el formulario, Entonces ve error "Selecciona al menos 1 idioma para practicar". **Escenario \#3: Múltiples idiomas y niveles** \- Dado que un aprendiz habla 3 idiomas natales, Cuando completa el formulario, Entonces puede seleccionar múltiples idiomas natales y establecer nivel diferente para cada idioma de práctica. **Escenario \#4: Recomendaciones dinámicas** \- Dado que aprendiz completó su perfil, Cuando va al dashboard, Entonces ve encuentros filtrados por sus idiomas e intereses seleccionados. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US07 | Aprendiz | 2 | Perfiles de Usuario (Profiles) |
| **Title** | **Editar perfil de aprendiz** |
| **Description** | **Como** aprendiz **Quiero** poder editar la información de mi perfil en cualquier momento **para** mantenerla actualizada. **Escenario \#1: Actualización de nivel** \- Dado que un aprendiz ha mejorado su nivel de inglés, Cuando actualiza su nivel de fluidez en su perfil y guarda, Entonces el sistema actualiza su perfil y recomendaciones de encuentros se ajustan al nuevo nivel. **Escenario \#2: Cambio de idiomas** \- Dado que un aprendiz desea cambiar sus idiomas de práctica, Cuando elimina un idioma, Entonces los encuentros ya reservados en ese idioma se marcan como "archivados" pero no se cancelan. **Escenario \#3: Historial de cambios** \- Dado que un aprendiz modifica su perfil, Cuando entra a un encuentro, Entonces otros usuarios ven la información más reciente del perfil (no versiones antiguas). |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US08 | Aprendiz | 2 | Perfiles de Usuario (Profiles) |
| **Title** | **Ver perfil de otro usuario** |
| **Description** | **Como** aprendiz **Quiero** ver el perfil de otros asistentes a un encuentro **para** conocer sus idiomas de interés y conectar con ellos. **Escenario \#1: Visualización de perfil público** \- Dado que estoy viendo los detalles de un encuentro, Cuando solicito ver el perfil de otro asistente, Entonces se muestra su información pública (foto, nombre, idioma nativo, idiomas que practica, nivel). **Escenario \#2: Acción desde perfil público** \- Dado que veo un perfil de otro usuario, Cuando hago clic en "Enviar solicitud de contacto", Entonces puedo comunicarme después del encuentro. **Escenario \#3: Ocultar información sensible** \- Dado que un usuario no quiere mostrar cierta información, Cuando configura privacidad en su perfil, Entonces otros solo ven nombre y foto, no email ni nivel exacto. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US09 | Usuario | 2 | Perfiles de Usuario (Profiles) |
| **Title** | **Subir foto de perfil** |
| **Description** | **Como** usuario **Quiero** subir una foto de perfil **para** personalizar mi cuenta y que otros me reconozcan más fácilmente. **Escenario \#1: Carga de imagen exitosa** \- Dado que estoy gestionando mi perfil, Cuando proporciono una imagen JPG/PNG (máximo 5MB), Entonces la foto se sube, se corta automáticamente a formato cuadrado y se muestra en toda la plataforma en tiempo real. **Escenario \#2: Validación de tamaño de archivo** \- Dado que intento subir una imagen de 10MB, Cuando envío el archivo, Entonces veo error "Archivo demasiado grande. Máximo 5MB". **Escenario \#3: Cambio de foto** \- Dado que tengo una foto de perfil, Cuando subo una nueva, Entonces la anterior se reemplaza automáticamente. **Escenario \#4: Eliminación de foto** \- Dado que deseo eliminar mi foto, Cuando hago clic en "Eliminar foto", Entonces se restaura el avatar por defecto. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US10 | Dueño de negocio (Partner) | 5 | Gestión de Locales (Partner) |
| **Title** | **Dar de alta un nuevo local** |
| **Description** | **Como** dueño de negocio (Partner) **Quiero** añadir los detalles de mi local, incluyendo nombre, dirección, aforo y horario **para** que aparezca en la plataforma como un lugar disponible para encuentros. **Escenario \#1: Registro de local exitoso** \- Dado que un Partner desea añadir un nuevo local, Cuando proporciona nombre, dirección validada en mapa, capacidad de personas, horarios operativos y acepta términos, Entonces el local se añade a su perfil en estado "Pendiente de Aprobación" y aparece en admin panel. **Escenario \#2: Dirección inválida** \- Dado que un Partner ingresa una dirección que no existe, Cuando intenta guardar, Entonces el sistema sugiere direcciones cercanas o pide confirmación manual con Google Maps. **Escenario \#3: Múltiples horarios** \- Dado que un local tiene horarios diferentes por día, Cuando configura el local, Entonces puede especificar horarios diferentes para cada día de la semana. **Escenario \#4: Aprobación por administrador** \- Dado que el local fue registrado correctamente, Cuando un administrador lo valida (verificando dirección real), Entonces el local cambia a estado "Activo" y es visible públicamente. **Escenario \#5: Datos incompletos** \- Dado que falta información crítica (ej: aforo), Cuando intenta guardar, Entonces ve alertas indicando campos obligatorios. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US11 | Partner | 3 | Gestión de Locales (Partner) |
| **Title** | **Editar información de un local** |
| **Description** | **Como** Partner **Quiero** poder editar los detalles de mi local registrado **para** mantener la información actualizada (ej. cambio de horario). **Escenario \#1: Actualizar horario exitosamente** \- Dado que un Partner necesita cambiar el horario de su cafetería, Cuando modifica los horarios en los detalles del local y guarda, Entonces la nueva información se refleja inmediatamente en la plataforma y aprendices ven los nuevos horarios. **Escenario \#2: Cambio de capacidad** \- Dado que un Partner amplía su local, Cuando aumenta la capacidad de personas, Entonces los encuentros programados se actualizan pero sin afectar reservas ya confirmadas. **Escenario \#3: Cambio de dirección** \- Dado que un Partner cambia de ubicación, Cuando intenta cambiar la dirección, Entonces el sistema requiere revalidación por administrador antes de hacerlo público. **Escenario \#4: Auditoría de cambios** \- Dado que se editó un local, Cuando un administrador revisa el historial, Entonces puede ver quién cambió qué y cuándo. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US12 | Partner | 3 | Gestión de Locales (Partner) |
| **Title** | **Añadir fotos del local** |
| **Description** | **Como** Partner **Quiero** subir varias fotos de mi local **para** hacerlo más atractivo y mostrar el ambiente a los aprendices. **Escenario \#1: Cargar galería exitosa** \- Dado que un Partner está gestionando el perfil de su local, Cuando proporciona un conjunto de imágenes (máximo 10 fotos de 5MB cada una), Entonces las fotos se asocian al local y se muestran en carrusel en la página del local. **Escenario \#2: Ordenar fotos** \- Dado que un Partner subió fotos, Cuando arrastra las imágenes en el panel, Entonces puede reordenarlas y la primera foto se establece como "portada". **Escenario \#3: Eliminar fotos** \- Dado que una foto no es adecuada, Cuando hace clic en eliminar, Entonces la foto se remueve de la galería. **Escenario \#4: Validación de contenido** \- Dado que un Partner intenta subir una foto inapropiada, Cuando el sistema detecta problemas, Entonces rechaza la imagen y sugiere mejoras. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US13 | Partner | 2 | Gestión de Locales (Partner) |
| **Title** | **Definir consumo mínimo (Opcional)** |
| **Description** | **Como** Partner **Quiero** tener la opción de definir un consumo mínimo sugerido para los asistentes a encuentros en mi local **para** asegurar un retorno económico. **Escenario \#1: Establecer consumo mínimo exitosamente** \- Dado que un Partner desea incentivar el consumo, Cuando especifica un monto mínimo (ej: $10 USD) y lo guarda, Entonces esta información aparece en los detalles de todos los encuentros en ese local. **Escenario \#2: Visualización para aprendices** \- Dado que un aprendiz ve un encuentro, Cuando consulta los detalles, Entonces aparece "Consumo mínimo sugerido: $10" en forma clara pero no restrictiva. **Escenario \#3: Cambio de consumo mínimo** \- Dado que un Partner cambia su política, Cuando actualiza el monto, Entonces los encuentros programados usan el nuevo valor. **Escenario \#4: Desactivar consumo mínimo** \- Dado que un Partner decide que no es necesario, Cuando desactiva esta opción, Entonces los encuentros ya no muestran consumo mínimo. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US14 | Partner | 5 | Gestión de Locales (Partner) |
| **Title** | **Ver dashboard de mi local** |
| **Description** | **Como** Partner **Quiero** acceder a un resumen de la actividad de mi local **para** entender rápidamente cuántos encuentros se han realizado y cuántas personas han asistido. **Escenario \#1: Visualización de métricas clave** \- Dado que un Partner accede a su panel, Cuando solicita ver el resumen de actividad, Entonces se le presentan las métricas clave de sus locales (encuentros, asistentes, calificación). **Escenario \#2: Análisis de tendencias** \- Dado que un Partner quiere entender el comportamiento de sus aprendices, Cuando accede al dashboard, Entonces puede ver gráficos y estadísticas sobre la participación en encuentros. **Escenario \#3: Panel sin actividad** \- Dado que un Partner no tiene actividad reciente, Cuando accede al dashboard, Entonces ve un mensaje indicando que no hay datos disponibles. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US15 | Aprendiz | 3 | Gestión de Encuentros (Event) |
| **Title** | **Buscar encuentros disponibles** |
| **Description** | **Como** aprendiz **Quiero** buscar encuentros usando filtros por idioma, ciudad y fecha **para** encontrar fácilmente una sesión de práctica que me interese. **Escenario \#1: Búsqueda con filtros** \- Dado que un aprendiz quiere encontrar un encuentro, Cuando aplica filtros de búsqueda por idioma, ciudad y fecha, Entonces el sistema le muestra una lista de resultados que coinciden con sus criterios. **Escenario \#2: Búsqueda sin resultados** \- Dado que un aprendiz no encuentra encuentros que coincidan con sus criterios, Cuando termina la búsqueda, Entonces ve un mensaje indicando que no hay resultados. **Escenario \#3: Resetear filtros** \- Dado que un aprendiz quiere ver todos los encuentros, Cuando hace clic en "Resetear Filtros", Entonces el sistema muestra todos los encuentros disponibles. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US16 | Aprendiz | 2 | Gestión de Encuentros (Event) |
| **Title** | **Ver detalles de un encuentro** |
| **Description** | **Como** aprendiz **Quiero** ver los detalles completos de un encuentro **para** saber el idioma, el tema, el lugar, la hora y quiénes más asistirán. **Escenario \#1: Visualización completa** \- Dado que un aprendiz ha encontrado un encuentro de su interés, Cuando selecciona ese encuentro de la lista, Entonces ve todos los detalles: título, descripción, idioma, nivel, fecha/hora, local (con mapa), capacidad, asistentes confirmados, organizador, consumo sugerido. **Escenario \#2: Ver asistentes** \- Dado que un aprendiz quiere conocer a otros participantes, Cuando hace clic en "Ver Asistentes", Entonces ve avatares/nombres de otros registrados (solo información pública). **Escenario \#3: Revisar comentarios previos** \- Dado que hay encuentros anteriores del mismo organizador, Cuando abre detalles, Entonces puede ver calificación promedio y comentarios de otros aprendices. **Escenario \#4: Compartir encuentro** \- Dado que le gusta el encuentro, Cuando hace clic en "Compartir", Entonces puede enviar link a contactos via WhatsApp, email o redes. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US17 | Aprendiz | 5 | Gestión de Encuentros (Event) |
| **Title** | **Reservar un cupo en un encuentro** |
| **Description** | **Como** aprendiz **Quiero** reservar mi cupo en un encuentro que tenga plazas disponibles **para** asegurar mi asistencia. **Escenario \#1: Reserva exitosa** \- Dado que un aprendiz está viendo un encuentro con cupos disponibles, Cuando hace clic en "Reservar" y confirma, Entonces el sistema actualiza cupos disponibles (ej: 3 → 2), le envía confirmación por email con detalles, y aparece en su lista "Mis Reservas". **Escenario \#2: Sin cupos disponibles** \- Dado que un encuentro está lleno, Cuando un aprendiz intenta reservar, Entonces ve botón "Unirse a Lista de Espera" en lugar de "Reservar". **Escenario \#3: Duplicación de reserva** \- Dado que un aprendiz ya tiene reserva confirmada, Cuando intenta reservar de nuevo, Entonces el sistema lo detecta y muestra "Ya tienes una reserva en este encuentro". **Escenario \#4: Validación de perfil incompleto** \- Dado que un aprendiz no ha completado su perfil, Cuando intenta reservar, Entonces el sistema le pide completar información antes de confirmar. **Escenario \#5: Punto de no retorno (temporal)** \- Dado que faltan menos de 2 horas para un encuentro, Cuando un aprendiz intenta reservar, Entonces se permite pero con advertencia "El encuentro inicia pronto". |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US18 | Aprendiz | 5 | Gestión de Encuentros (Event) |
| **Title** | **Recibir confirmación con código QR** |
| **Description** | **Como** aprendiz **Quiero** recibir una confirmación de mi reserva **para** poder hacer check-in fácilmente al llegar al local. **Escenario \#1: Generación de QR** \- Dado que un aprendiz ha completado una reserva, Cuando consulta los detalles de su reserva, Entonces ve un código QR único y dinámico que lo identifica para ese encuentro específico. **Escenario \#2: QR accesible en múltiples lugares** \- Dado que un aprendiz tiene su reserva, Cuando abre la app o web, Entonces puede ver el QR en: email de confirmación, página "Mis Reservas", calendario, notificación recordatorio. **Escenario \#3: QR temporal y expiración** \- Dado que es el día del encuentro, Cuando el QR se escaneará, Entonces el código es válido solo desde 30 minutos antes hasta 30 minutos después del encuentro. **Escenario \#4: Alternativa sin QR** \- Dado que un aprendiz no puede mostrar QR (sin batería en móvil), Cuando llega al local, Entonces puede decir su nombre al organizador y se valida manualmente en la lista. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US19 | Aprendiz | 8 | Gestión de Encuentros (Event) |
| **Title** | **Crear un encuentro (iniciativa del aprendiz)** |
| **Description** | **Como** aprendiz **Quiero** proponer la creación de un nuevo encuentro en un local registrado **para** organizar una sesión si no hay ninguna que se ajuste a mis necesidades. **Escenario \#1: Propuesta exitosa** \- Dado que un aprendiz desea organizar un encuentro, Cuando selecciona un local, especifica idioma, tema, fecha/hora, capacidad máxima y descripción, Entonces el sistema crea el encuentro con el aprendiz como "Organizador" y lo registra como primer asistente. **Escenario \#2: Validación de local disponible** \- Dado que un aprendiz propone un encuentro, Cuando selecciona un local y horario, Entonces el sistema valida que el local está activo y no hay conflicto de encuentros a esa hora. **Escenario \#3: Revisión por Partner** \- Dado que un aprendiz creó un encuentro, Cuando el Partner del local lo ve, Entonces puede aceptar, sugerir cambios u rechazar con comentarios. **Escenario \#4: Encuentro rechazado** \- Dado que un Partner rechaza la propuesta, Cuando el aprendiz lo ve, Entonces recibe notificación con razón del rechazo y opción de replantear. **Escenario \#5: Encuentro sin Partner** \- Dado que un aprendiz quiere crear encuentro virtual o en espacio no registrado, Cuando intenta crear, Entonces solo puede hacerlo si selecciona un local ya registrado en la plataforma. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US20 | Aprendiz | 8 | Gestión de Encuentros (Event) |
| **Title** | **Check-in en un encuentro** |
| **Description** | **Como** aprendiz **Quiero** confirmar mi asistencia a un encuentro **para** registrar mi participación y recibir los beneficios por ello. **Escenario \#1: Check-in exitoso** \- Dado que un aprendiz llega al local del encuentro, Cuando muestra su QR al organizador/partner, Entonces el sistema valida el código, registra su asistencia, actualiza contadores, asigna puntos de lealtad. **Escenario \#2: Check-in manual** \- Dado que un aprendiz no puede mostrar QR, Cuando dice su nombre al organizador, Entonces el sistema permite búsqueda manual en la lista de reservados. **Escenario \#3: No-show (ausencia)** \- Dado que faltan 30 minutos para el encuentro, Si ningún aprendiz hacía check-in, Entonces se marca como no-show y puede afectar su perfil. **Escenario \#4: Intento tardío de check-in** \- Dado que un aprendiz intenta hacer check-in 40 minutos después que terminó el encuentro, Cuando intenta, Entonces el sistema rechaza indicando "Encuentro finalizado, no es posible check-in". **Escenario \#5: Doble check-in** \- Dado que un aprendiz ya hizo check-in, Cuando intenta de nuevo, Entonces el sistema detecta la duplicación y lo evita. **Escenario \#6: Validación de puntos** \- Dado que se completó el check-in, Cuando el aprendiz abre su perfil, Entonces ve incremento automático de puntos de lealtad (ej: +10 puntos). |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US21 | Partner | 3 | Gestión de Encuentros (Event) |
| **Title** | **Ver lista de asistentes (vista de Partner)** |
| **Description** | **Como** Partner **Quiero** ver la lista de personas que han reservado para un encuentro en mi local **para** tener una idea del aforo esperado. **Escenario \#1: Visualización de asistentes** \- Dado que un Partner tiene un encuentro programado, Cuando consulta los detalles, Entonces ve lista con nombres, fotos, idiomas de cada aprendiz reservado. **Escenario \#2: Actualización en tiempo real** \- Dado que nuevos aprendices están reservando, Cuando Partner actualiza la página, Entonces la lista se refleja al momento. **Escenario \#3: Comunicación con aprendices** \- Dado que Partner quiere avisar cambios, Cuando selecciona asistentes, Entonces puede enviar notificación masiva. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US22 | Aprendiz con una reserva | 2 | Gestión de Encuentros (Event) |
| **Title** | **Recibir recordatorio de encuentro** |
| **Description** | **Como** aprendiz con una reserva **Quiero** recibir una notificación de recordatorio 24 horas antes del encuentro **para** no olvidarme de asistir. **Escenario \#1: Recordatorio automático** \- Dado que un aprendiz tiene una reserva para mañana, Cuando faltan exactamente 24 horas, Entonces el sistema envía automáticamente una notificación (push + email) con detalles del encuentro. **Escenario \#2: Recordatorio adicional** \- Dado que faltan 2 horas para el encuentro, Cuando el tiempo se acerca, Entonces el sistema envía segundo recordatorio (push). **Escenario \#3: Desactivar recordatorios** \- Dado que un aprendiz quiere menos notificaciones, Cuando entra a preferencias, Entonces puede desactivar recordatorios específicos. **Escenario \#4: Recordatorio para encuentros cancelados** \- Dado que un encuentro fue cancelado, Cuando se acerca la fecha original, Entonces el aprendiz NO recibe recordatorio. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US23 | Aprendiz | 3 | Gestión de Encuentros (Event) |
| **Title** | **Unirse a la lista de espera** |
| **Description** | **Como** aprendiz **Quiero** unirme a una lista de espera si un encuentro está lleno **para** tener la oportunidad de asistir si alguien cancela. **Escenario \#1: Inscripción en lista** \- Dado que un aprendiz desea asistir a un encuentro sin cupos, Cuando opta por "Unirse a Lista de Espera", Entonces el sistema lo añade a la cola con posición (ej: "Eres #3 en la lista") y envía notificación. **Escenario \#2: Posición visible** \- Dado que un aprendiz está en lista de espera, Cuando abre detalles del encuentro, Entonces ve su posición y puede salirse si cambia de opinión. **Escenario \#3: Límite de lista** \- Dado que hay más de 20 personas en lista de espera, Cuando alguien intenta unirse, Entonces se acepta pero con advertencia de baja probabilidad. **Escenario \#4: Cancelación de lista** \- Dado que un aprendiz se arrepiente, Cuando hace clic en "Salir de lista de espera", Entonces se remueve sin penalización. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US24 | Aprendiz en una lista de espera | 5 | Gestión de Encuentros (Event) |
| **Title** | **Recibir notificación de cupo liberado** |
| **Description** | **Como** aprendiz en una lista de espera **Quiero** recibir una notificación inmediata si un cupo se libera **para** poder reservarlo rápidamente. **Escenario \#1: Notificación inmediata** \- Dado que un aprendiz está en lista de espera y alguien cancela su reserva, Cuando se libera un cupo, Entonces el sistema notifica al siguiente en la cola con link directo para confirmar su reserva. **Escenario \#2: Ventana temporal de confirmación** \- Dado que el aprendiz recibe notificación, Cuando tiene 15 minutos para confirmar, Si no responde, Entonces pasa al siguiente en la lista. **Escenario \#3: Confirmación automática** \- Dado que un aprendiz confirma rápido, Cuando hace clic en "Confirmar Reserva", Entonces su cupo se asegura automáticamente y recibe confirmación. **Escenario \#4: Múltiples listas** \- Dado que un aprendiz está en lista de espera de 2 encuentros, Cuando se libera un cupo en ambos, Entonces recibe notificaciones independientes. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US25 | Aprendiz que asistió a un encuentro | 3 | Gestión de Encuentros (Event) |
| **Title** | **Dejar feedback de un encuentro** |
| **Description** | **Como** aprendiz que asistió a un encuentro **Quiero** dejar una calificación y un comentario sobre mi experiencia **para** ayudar a otros usuarios y a los locales. **Escenario \#1: Feedback exitoso** \- Dado que un aprendiz asistió y hizo check-in, Cuando ve el encuentro en su historial, Entonces puede dejar calificación (1-5 estrellas) y comentario opcional (máx. 500 caracteres). **Escenario \#2: Validación de feedback** \- Dado que un aprendiz intenta dejar un comentario ofensivo, Cuando intenta enviar, Entonces el sistema detecta contenido inadecuado y lo rechaza. **Escenario \#3: Visibilidad del feedback** \- Dado que feedback fue enviado, Cuando otros ven el encuentro o el local, Entonces ven la calificación promedio y comentarios públicos. **Escenario \#4: Edición limitada** \- Dado que un aprendiz se arrepiente, Cuando intenta editar su comentario, Entonces puede hacerlo solo dentro de 7 días del encuentro. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US26 | Aprendiz | 3 | Gestión de Encuentros (Event) |
| **Title** | **Cancelar mi reserva** |
| **Description** | **Como** aprendiz **Quiero** poder cancelar mi reserva a un encuentro con antelación **para** liberar mi cupo si no puedo asistir. **Escenario \#1: Cancelación exitosa** \- Dado que un aprendiz tiene una reserva y no puede asistir, Cuando solicita cancelación más de 2 horas antes, Entonces su cupo se libera, se notifica al siguiente en lista de espera, y recibe confirmación por email. **Escenario \#2: Cancelación tardía (penalización leve)** \- Dado que un aprendiz cancela menos de 2 horas antes, Cuando intenta cancelar, Entonces se permite pero le advierte que puede afectar su historial. **Escenario \#3: Intento de cancelación post-encuentro** \- Dado que el encuentro ya pasó, Cuando intenta cancelar, Entonces el sistema no lo permite. **Escenario \#4: Ausencia sin cancelar** \- Dado que un aprendiz no asistió ni canceló, Cuando el encuentro termina, Entonces se marca como "No se presentó" en su perfil (informativo, sin castigo inmediato). |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US27 | Aprendiz | 2 | Gestión de Encuentros (Event) |
| **Title** | **Ver encuentros pasados** |
| **Description** | **Como** aprendiz **Quiero** tener un historial de los encuentros a los que he asistido **para** recordar los lugares y las fechas. **Escenario \#1: Historial visible** \- Dado que un aprendiz quiere revisar su actividad pasada, Cuando accede a "Mi Historial" en su perfil, Entonces el sistema muestra lista cronológica de encuentros con estado (asistido, cancelado, no-show). **Escenario \#2: Filtrado por período** \- Dado que desea ver encuentros de un mes específico, Cuando aplica filtro "Últimos 3 meses", Entonces la lista se filtra dinámicamente. **Escenario \#3: Acceso rápido a feedback** \- Dado que ve un encuentro pasado, Cuando hace clic en él, Entonces puede ver su feedback, dejar comentario adicional o editar calificación. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US28 | Aprendiz | 5 | Gestión de Encuentros (Event) |
| **Title** | **Ver el mapa de locales** |
| **Description** | **Como** aprendiz **Quiero** ver locales disponibles según mi ubicación **para** encontrar los lugares más cercanos donde para organizar encuentros. **Escenario \#1: Mapa interactivo** \- Dado que un aprendiz quiere descubrir nuevos locales, Cuando accede a la vista "Mapa de Locales", Entonces ve mapa interactivo con marcadores de todos los locales activos, mostrando nombre e icono de identificación. **Escenario \#2: Filtrado por proximidad** \- Dado que un aprendiz permite ubicación, Cuando abre el mapa, Entonces los locales se ordenan por distancia y aparece círculo de radio 5km alrededor del usuario. **Escenario \#3: Información en popup** \- Dado que hace clic en un local, Cuando abre popup, Entonces muestra: nombre, dirección, teléfono, foto portada, encuentros próximos. **Escenario \#4: Link directo a reserva** \- Dado que ve un local interesante, Cuando hace clic en "Ver Encuentros", Entonces filtra automáticamente encuentros en ese local. **Escenario \#5: Modo offline** \- Dado que perdió conexión, Cuando intenta ver mapa, Entonces muestra último mapa cacheado con data local disponible. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US29 | Aprendiz | 5 | Lealtad y Gamificación (Loyalty) |
| **Title** | **Ganar puntos por asistencia** |
| **Description** | **Como** aprendiz **Quiero** ganar puntos de lealtad cada vez que hago check-in en un encuentro **para** ser recompensado por mi participación activa. **Escenario \#1: Acumulación automática** \- Dado que un aprendiz ha hecho check-in exitosamente, Cuando el sistema procesa su asistencia, Entonces automáticamente suma puntos (ej: +10 puntos base + bonus si es primer encuentro en idioma +5). **Escenario \#2: Visualización inmediata** \- Dado que completó check-in, Cuando abre su perfil, Entonces ve incremento de puntos en tiempo real con notificación visual. **Escenario \#3: Puntos por referido** \- Dado que una persona se registra usando código referral, Cuando completa su primer encuentro, Entonces tanto referidor como referido ganan puntos bonus (+15 cada uno). **Escenario \#4: Encuentros premium** \- Dado que participa en encuentro con tema especial, Cuando hace check-in, Entonces gana puntos multiplicados (ej: 1.5x). |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US30 | Aprendiz | 1 | Lealtad y Gamificación (Loyalty) |
| **Title** | **Ver mi total de puntos y nivel** |
| **Description** | **Como** aprendiz **Quiero** poder ver mi saldo total de puntos y mi nivel actual en mi perfil **para** seguir mi progreso. **Escenario \#1: Panel de progreso** \- Dado que un aprendiz accede a su perfil, Cuando consulta la sección "Mi Progreso", Entonces ve: puntos totales, nivel actual (ej: "Oro"), progreso a próximo nivel con barra visual. **Escenario \#2: Niveles con beneficios** \- Dado que un aprendiz ve su nivel, Cuando hace clic en "Ver Beneficios", Entonces accede a tabla que explica qué beneficios ofrece cada nivel (Bronce, Plata, Oro, Platino). **Escenario \#3: Historial de puntos** \- Dado que quiere entender cómo ganó puntos, Cuando hace clic en "Ver Historial", Entonces ve lista de transacciones (check-ins, bonificaciones, canjes). |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US31 | Aprendiz | 5 | Lealtad y Gamificación (Loyalty) |
| **Title** | **Desbloquear una insignia (badge)** |
| **Description** | **Como** aprendiz **Quiero** desbloquear insignias al alcanzar ciertos hitos (ej. "Asistir a 5 encuentros de francés") **para** sentir que logro algo. **Escenario \#1: Desbloqueo automático** \- Dado que un aprendiz cumple requisito de insignia (ej: 5 encuentros en Francés), Cuando completa el 5to encuentro, Entonces el sistema detecta el logro, desbloquea insignia y envía notificación celebratoria. **Escenario \#2: Insignias visibles** \- Dado que desbloqueó insignia, Cuando otros ven su perfil, Entonces aparecen sus insignias activas. **Escenario \#3: Desafíos mensuales** \- Dado que inicia mes nuevo, Cuando accede a la sección "Desafíos", Entonces ve insignias temporales (ej: "Asiste a 10 encuentros este mes para desbloquear: Viajero del Mes"). |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US32 | Aprendiz | 3 | Lealtad y Gamificación (Loyalty) |
| **Title** | **Ver mis insignias desbloqueadas** |
| **Description** | **Como** aprendiz **Quiero** tener una sección en mi perfil donde pueda ver todas las insignias que he ganado **para** mostrarlas a la comunidad. **Escenario \#1: Galería de logros** \- Dado que un aprendiz ha desbloqueado insignias, Cuando visita su perfil, Entonces una sección "Mis Insignias" muestra todas las badges ganadas en grid visual con tooltips. **Escenario \#2: Insignias en perfil público** \- Dado que otro usuario ve mi perfil, Cuando observa mis insignias, Entonces puede hacer hover para ver descripción y fecha de desbloqueo. **Escenario \#3: Ordenamiento personalizado** \- Dado que tengo múltiples insignias, Cuando entro a editar orden, Entonces puedo fijar mis favoritas en posiciones destacadas. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US33 | Aprendiz | 3 | Lealtad y Gamificación (Loyalty) |
| **Title** | **Ver un ranking de usuarios** |
| **Description** | **Como** aprendiz **Quiero** recibir y acceder a información sobre mi progreso y compararlo con el de otros usuarios **para** competir de forma amistosa con otros miembros de la comunidad. **Escenario \#1: Leaderboard global** \- Dado que un aprendiz quiere ver su posición, Cuando accede al "Leaderboard", Entonces ve ranking de top 100 usuarios por puntos con su posición destacada. **Escenario \#2: Filtro por período** \- Dado que quiere competencia justa, Cuando selecciona "Último Mes", Entonces el ranking se recalcula mostrando solo puntos ganados en ese período. **Escenario \#3: Mis amigos** \- Dado que quiero competencia cercana, Cuando activo "Ver solo Mis Contactos", Entonces ve ranking reducido solo de sus conexiones. **Escenario \#4: Insignia de ranking** \- Dado que alcanza Top 10, Cuando lo logra, Entonces gana insignia especial "Top 10 Del Mes". |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US34 | Aprendiz leal | 5 | Lealtad y Gamificación (Loyalty) |
| **Title** | **Recibir ofertas de locales por lealtad** |
| **Description** | **Como** aprendiz leal **Quiero** recibir ofertas especiales o descuentos de los locales asociados **para** tener recompensas por mi participación. **Escenario \#1: Ofertas automáticas** \- Dado que un aprendiz alcanza nivel "Oro", Cuando entra a un local aliado, Entonces ve notificación "Bienvenida Miembro Oro - 15% descuento en bebidas". **Escenario \#2: Catálogo de ofertas** \- Dado que un aprendiz quiere aprovechar beneficios, Cuando accede a la sección "Mis Ofertas", Entonces ve todas las promociones activas de locales donde frecuenta. **Escenario \#3: Cupones digitales** \- Dado que desea usar oferta, Cuando hace clic en promoción, Entonces obtiene código QR descargable para presentar en el local. **Escenario \#4: Ofertas personalizadas** \- Dado que frecuenta cierto idioma, Cuando hay promoción de encuentros de francés, Entonces la ofrece prioritariamente. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US35 | Aprendiz | 3 | Lealtad y Gamificación (Loyalty) |
| **Title** | **Mantener una racha de asistencia** |
| **Description** | **Como** aprendiz **Quiero** que el sistema registre mi racha de asistencia semanal **para** motivarme a participar de forma consistente. **Escenario \#1: Racha visible** \- Dado que un aprendiz asistió a encuentros consistentemente, Cuando abre su perfil, Entonces ve indicador "Racha: 8 encuentros en 8 semanas" con fuego visual. **Escenario \#2: Restablecimiento de racha** \- Dado que falté una semana, Cuando pasa una semana sin asistir, Entonces mi racha se restablece a 0. **Escenario \#3: Notificación motivacional** \- Dado que tengo racha activa, Cuando faltan 2 días para fin de semana, Entonces recibo push: "Tienes racha de 7 semanas - ¡No la rompas! Hay 5 encuentros disponibles". **Escenario \#4: Recompensa de racha** \- Dado que alcancé 12 semanas seguidas, Cuando lo logro, Entonces gano insignia "Adicto al Aprendizaje" + 50 puntos bonus. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US36 | Partner | 5 | Analíticas (Analytics) |
| **Title** | **Ver número de asistentes por mes** |
| **Description** | **Como** Partner **Quiero** conocer la cantidad de asistentes en mi local cada mes mediante gráficos **para** medir el impacto de la plataforma. **Escenario \#1: Gráfico mensual** \- Dado que un Partner está en su panel de analíticas, Cuando consulta el reporte "Asistentes por Mes", Entonces ve gráfico de barras mostrando asistentes confirmados vs. reales (check-in) por cada mes. **Escenario \#2: Comparación año a año** \- Dado que quiere ver crecimiento, Cuando activa "Comparar con año anterior", Entonces aparecen dos líneas mostrando evolución. **Escenario \#3: Predicción** \- Dado que hay datos suficientes, Cuando scroll en gráfico, Entonces sistema estima proyección para próximos 3 meses basada en tendencia. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US37 | Partner | 3 | Analíticas (Analytics) |
| **Title** | **Ver calificación promedio de mi local** |
| **Description** | **Como** Partner **Quiero** ver la calificación promedio que los aprendices le han dado a los encuentros realizados en mi local **para** evaluar la satisfacción del cliente. **Escenario \#1: Métrica destacada** \- Dado que un Partner accede a su dashboard, Cuando mira la sección de "Satisfacción", Entonces ve calificación promedio (ej: 4.7/5) con número total de reviews. **Escenario \#2: Distribución de estrellas** \- Dado que quiere análisis detallado, Cuando hace clic en la métrica, Entonces ve gráfico de distribución (cuántas reviews de 1⭐, 2⭐, 3⭐, 4⭐, 5⭐). **Escenario \#3: Comentarios filtrados** \- Dado que quiere mejorar, Cuando selecciona "Ver comentarios negativos", Entonces aparecen reviews con 1-2 estrellas para identificar problemas. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US38 | Partner | 8 | Analíticas (Analytics) |
| **Title** | **Identificar horas y días pico** |
| **Description** | **Como** Partner **Quiero** ver un reporte que me muestre qué días de la semana y a qué horas se realizan más encuentros en mi local **para** optimizar mi personal. **Escenario \#1: Mapa de calor** \- Dado que un Partner quiere optimizar horarios, Cuando consulta el reporte "Horas Pico", Entonces ve matriz visual (heatmap) con días vs. horas mostrando intensidad de encuentros (color rojo = muy concurrido). **Escenario \#2: Estadísticas por slot** \- Dado que mira el heatmap, Cuando hace clic en un slot horario, Entonces ve detalles: número promedio de asistentes, encuentros en ese horario, tendencia. **Escenario \#3: Recomendaciones** \- Dado que hay datos, Cuando el sistema analiza, Entonces sugiere: "Jueves 7-9 PM es tu mejor horario - considera agregar más encuentros". |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US39 | Partner | 8 | Analíticas (Analytics) |
| **Title** | **Rastrear asistentes nuevos vs. recurrentes** |
| **Description** | **Como** Partner **Quiero** saber qué porcentaje de los asistentes son nuevos clientes versus personas que ya han venido antes **para** medir la captación de nuevo público. **Escenario \#1: Análisis de retención** \- Dado que un Partner analiza sus métricas, Cuando consulta "Retención de Clientes", Entonces ve tabla: X% nuevos, Y% recurrentes, Z% VIP (más de 10 visitas). **Escenario \#2: Cohorte de análisis** \- Dado que quiere ver evolución, Cuando selecciona un período, Entonces ve cómo los "nuevos" de ese período se convirtieron en recurrentes. **Escenario \#3: Identificación de VIPs** \- Dado que quiere fidelizar, Cuando filtra "Clientes VIP", Entonces ve lista de personas más fieles para ofrecer beneficios especiales. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US40 | Partner | 5 | Analíticas (Analytics) |
| **Title** | **Descargar reporte básico** |
| **Description** | **Como** Partner **Quiero** poder descargar un resumen la información de mi actividad en un formato que pueda usar fuera de la plataforma **para** mis registros internos. **Escenario \#1: Descarga en múltiples formatos** \- Dado que un Partner necesita un informe, Cuando hace clic en "Descargar Reporte", Entonces elige formato: PDF (formateado), CSV (datos brutos), o Excel con gráficos. **Escenario \#2: Período personalizado** \- Dado que quiere reporte específico, Cuando selecciona rango de fechas, Entonces el reporte generado contiene solo datos de ese período. **Escenario \#3: Compresión de archivos** \- Dado que descarga reportes múltiples, Cuando descarga, Entonces los archivos se comprimen automáticamente en ZIP si son varios. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US41 | Aprendiz | 3 | Comunidad y Social |
| **Title** | **Enviar solicitud de contacto** |
| **Description** | **Como** aprendiz **Quiero** poder enviar una solicitud de contacto a otra persona con la que interactué en un encuentro **para** mantener la comunicación. **Escenario \#1: Envío de solicitud** \- Dado que he interactuado con otro aprendiz en un encuentro, Cuando visualizo su perfil y hago clic en "Agregar Contacto", Entonces se envía solicitud y el otro usuario recibe notificación. **Escenario \#2: Solicitud duplicada** \- Dado que ya envié solicitud, Cuando intento nuevamente, Entonces el sistema indica "Solicitud pendiente". **Escenario \#3: Usuarios bloqueados** \- Dado que bloqueé a alguien, Cuando intenta enviarme solicitud, Entonces es rechazada silenciosamente. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US42 | Aprendiz | 3 | Comunidad y Social |
| **Title** | **Aceptar solicitud de contacto** |
| **Description** | **Como** aprendiz **Quiero** recibir notificaciones de nuevas solicitudes de contacto **para** poder aceptarlas o rechazarlas. **Escenario \#1: Gestión de solicitudes** \- Dado que recibí solicitud de contacto, Cuando voy a "Solicitudes Pendientes", Entonces veo lista con opción de aceptar o rechazar cada una. **Escenario \#2: Aceptación automática de amigos mutuos** \- Dado que alguien que es contacto de mi contacto me solicita, Cuando recibo solicitud, Entonces puedo ver "Mutuo: conocen a [nombre]" para más contexto. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US43 | Aprendiz | 2 | Comunidad y Social |
| **Title** | **Ver mi lista de contactos** |
| **Description** | **Como** aprendiz **Quiero** tener una lista de todos los usuarios con los que he conectado **para** poder iniciar una conversación. **Escenario \#1: Lista de contactos** \- Dado que he establecido contactos en la plataforma, Cuando accedo a "Mis Contactos", Entonces aparece lista con avatares, nombres, último idioma practicado juntos. **Escenario \#2: Ordenamiento personalizado** \- Dado que tengo muchos contactos, Cuando selecciono "Ordenar por", Entonces puedo ver opciones: Recientes, Alfabético, Frecuencia de contacto. **Escenario \#3: Búsqueda rápida** \- Dado que busco a alguien específico, Cuando uso barra de búsqueda, Entonces filtra contactos por nombre. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US44 | Aprendiz | 5 | Mensajería |
| **Title** | **Enviar mensaje a un contacto** |
| **Description** | **Como** aprendiz **Quiero** poder enviar un mensaje directo a uno de mis contactos **para** organizar una futura práctica de idiomas. **Escenario \#1: Envío de mensaje** \- Dado que deseo comunicarme con un contacto, Cuando abro la conversación, escribo mensaje y hago clic "Enviar", Entonces el sistema lo entrega y notifica al destinatario. **Escenario \#2: Historial de conversación** \- Dado que tengo conversaciones previas, Cuando abro un chat, Entonces veo todo el historial de mensajes ordenado cronológicamente. **Escenario \#3: Mensajes de escribiendo** \- Dado que estoy escribiendo, Cuando mi contacto está activo, Entonces ve indicador "Escribiendo..." en tiempo real. **Escenario \#4: Borrado de mensajes** \- Dado que me arrepiento, Cuando hago clic en mensaje, Entonces puedo borrarlo (mostrado como "[mensaje eliminado]" para el otro). |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US45 | Usuario | 5 | Notificaciones |
| **Title** | **Recibir notificaciones de mensajes nuevos** |
| **Description** | **Como** usuario **Quiero** recibir una notificación cuando uno de mis contactos me envía un mensaje **para** poder responder a tiempo. **Escenario \#1: Notificación inmediata** \- Dado que estoy usando la aplicación, Cuando recibo un nuevo mensaje de un contacto, Entonces el sistema me alerta con notificación. **Escenario \#2: Notificación en background** \- Dado que la app está cerrada, Cuando llega mensaje, Entonces recibo notificación push que abre la conversación al hacer clic. **Escenario \#3: Silenciar conversación** \- Dado que una conversación es muy activa, Cuando hago clic en "Silenciar", Entonces no recibo notificaciones pero sí veo mensajes no leídos. **Escenario \#4: No molestar** \- Dado que configuré horarios de descanso (ej: 10PM-8AM), Cuando llega mensaje en esas horas, Entonces se guarda pero sin sonido/vibración. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US46 | Usuario | 5 | Moderación |
| **Title** | **Reportar un usuario** |
| **Description** | **Como** usuario **Quiero** tener la opción de reportar a otro usuario por comportamiento inapropiado **para** mantener un ambiente seguro y respetuoso en la comunidad. **Escenario \#1: Crear reporte** \- Dado que he presenciado un comportamiento inapropiado, Cuando hago clic en el perfil del usuario y selecciono "Reportar", Entonces aparece formulario con opciones: spam, ofensivo, acoso, fraude, otro. **Escenario \#2: Descripción detallada** \- Dado que abro reporte, Cuando escribo descripción (máx. 500 caracteres) con detalles del incidente, Entonces puedo incluir screenshot/evidencia. **Escenario \#3: Anonimato del reportero** \- Dado que hago reporte, Cuando se envía, Entonces el usuario reportado NO sabe quién lo reportó (protección de denunciante). **Escenario \#4: Confirmación de reporte** \- Dado que envié reporte, Cuando se procesa, Entonces recibo notificación: "Gracias por reportar. Investigaremos en 24h". |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US47 | Administrador | 8 | Administración |
| **Title** | **Ver dashboard de administrador** |
| **Description** | **Como** administrador de la plataforma **Quiero** acceder a información sobre el uso que se le da a la plataforma en mi local **para** monitorear su buen funcionamiento. **Escenario \#1: Dashboard ejecutivo** \- Dado que un administrador ha iniciado sesión, Cuando accede al panel, Entonces ve métricas clave: usuarios totales, encuentros realizados, ingresos, reportes pendientes, locales por validar. **Escenario \#2: Alertas críticas** \- Dado que hay anomalías, Cuando se abre el dashboard, Entonces ve sección de "Alertas" mostrando: "3 nuevos reportes críticos", "Local con calificación < 3 estrellas". **Escenario \#3: Acceso rápido a acciones** \- Dado que ve alerta, Cuando hace clic, Entonces se navega directamente a la sección para tomar acción. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US48 | Administrador | 5 | Administración |
| **Title** | **Gestionar usuarios** |
| **Description** | **Como** administrador **Quiero** poder ver la lista de todos los usuarios y poder desactivar una cuenta en caso de abuso **para** mantener la calidad de la comunidad. **Escenario \#1: Gestión de usuarios** \- Dado que un administrador accede a "Gestión de Usuarios", Cuando busca usuario problemático, Entonces ve sus datos, historial de reportes y opción "Desactivar Cuenta". **Escenario \#2: Desactivación reversible** \- Dado que desactivo una cuenta, Cuando lo hago, Entonces el usuario recibe notificación del motivo y puede apelar en 30 días. **Escenario \#3: Filtrado de usuarios** \- Dado que hay muchos usuarios, Cuando uso filtros (reportados, ban temporales, nivel bajo), Entonces se filtran dinámicamente. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US49 | Administrador | 5 | Administración |
| **Title** | **Validar nuevos locales** |
| **Description** | **Como** administrador **Quiero** tener un proceso para validar y aprobar los nuevos locales que se registran **para** asegurar que son lugares apropiados y reales. **Escenario \#1: Panel de validación** \- Dado que un nuevo local está pendiente de aprobación, Cuando entro a "Locales Pendientes", Entonces veo lista con información: nombre, dirección, foto, datos contacto. **Escenario \#2: Validación manual** \- Dado que reviso un local, Cuando verifico dirección en Google Maps y fotos, Entonces puedo "Aprobar" o "Rechazar con comentarios". **Escenario \#3: Notificación al Partner** \- Dado que aprobé un local, Cuando confirmo, Entonces el Partner recibe email: "Tu local fue aprobado y ya es visible". |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US50 | Administrador | 8 | Administración |
| **Title** | **Gestionar reportes de usuarios** |
| **Description** | **Como** administrador **Quiero** ver una lista de todos los reportes enviados por los usuarios **para** poder investigarlos y tomar acciones. **Escenario \#1: Cola de reportes** \- Dado que un usuario ha sido reportado, Cuando accedo a "Reportes Pendientes", Entonces veo lista ordenada por prioridad (crítico/normal), fecha, tipo de reporte. **Escenario \#2: Investigación detallada** \- Dado que hago clic en reporte, Cuando abro, Entonces veo: descripción, evidencia, perfil del reportado, historial de reportes previos. **Escenario \#3: Resolución** \- Dado que investigué, Cuando determino acción (desactivar, advertencia, etc.), Entonces registro decisión con notas para auditoría. **Escenario \#4: Comunicación** \- Dado que tomé acción, Cuando confirmo, Entonces se envía notificación al usuario afectado explicando decisión. |

| Story ID | User | Priority | Epic |
| :--- | :--- | :--- | :--- |
| US51 | Administrador | 8 | Administración |
| **Title** | **Enviar comunicaciones globales** |
| **Description** | **Como** administrador **Quiero** poder enviar notificaciones o correos electrónicos a todos los usuarios **para** comunicar novedades o mantenimientos de la plataforma. **Escenario \#1: Mensaje global** \- Dado que necesito comunicar algo importante, Cuando accedo a "Comunicaciones", escribo mensaje y selecciono "Todos los usuarios", Entonces se envía notificación push + email automáticamente. **Escenario \#2: Segmentación de audiencia** \- Dado que el mensaje es específico, Cuando selecciono "Solo Aprendices" o "Solo Partners", Entonces se envía solo al segmento elegido. **Escenario \#3: Programación** \- Dado que quiero evitar horarios pico, Cuando uso "Enviar en...", Entonces puedo programar para momento específico. **Escenario \#4: Plantillas** \- Dado que envío mensajes recurrentes, Cuando selecciono "Usar plantilla", Entonces aparecen templates pre-formateadas (mantenimiento, novedad, alerta). |

## 3.3	Impact Map

Se presentara los mapas de impacto realizados por cada segmento, el primero es para el segmento de aprendices y el segundo para el segmento de locales, ambos realizados por Carlos.

![Impact Map 1](assets/img/cap3/Impact-map.png)

Como se puede observar, el mapa de impacto para los aprendices se enfoca en mejorar la experiencia de búsqueda y reserva de encuentros, así como en fomentar la participación a través de un sistema de puntos y recompensas. Por otro lado, el mapa para los locales se centra en facilitar la gestión de sus espacios y eventos, y en proporcionarles herramientas para medir el impacto de su colaboración con la plataforma.

---

![Impact Map 2](assets/img/cap3/Impact-map-Carlos.png)

En el mapa de impacto para los locales, se identifican objetivos como aumentar la visibilidad de los locales, mejorar la gestión de eventos y obtener insights sobre el rendimiento de sus espacios. Las funcionalidades propuestas incluyen la creación de un dashboard para locales, la posibilidad de subir fotos y definir consumos mínimos, y la generación de reportes analíticos sobre asistentes y calificaciones.

## 3.4	Product Backlog   

En esta sección, el equipo organiza el Product Backlog en función de su valor comercial y su complejidad relativa estimada en Story Points. La secuencia de Fibonacci (1, 2, 3, 5, 8) se ha utilizado para establecer una escala consistente que refleja tanto el esfuerzo técnico como la complejidad de implementación de cada historia de usuario.

**Escala de Story Points y su Interpretación:**

| Story Points | Descripción Técnica | Riesgo e Incertidumbre | Complejidad de Dominio (DDD) |
| :--- | :--- | :--- | :--- |
| **1** | **Trivial:** Cambios en UI estática o ajustes menores en lógica pura sin efectos secundarios. | Casi nulo. | Entidad aislada sin lógica de negocio. |
| **2** | **Simple:** CRUD estándar dentro de un solo dominio. Validaciones básicas y persistencia directa. | Bajo. Conocimiento total de la tarea. | Operación básica en un solo *Aggregate*. |
| **3** | **Moderada:** Lógica de negocio específica, validaciones de dominio y coordinación entre capas. | Controlado. Requiere análisis de impacto. | Lógica interna del *Domain Service* o *Value Objects*. |
| **5** | **Compleja:** Integración con servicios externos (APIs, Storage, Maps) o múltiples componentes internos. | Moderado. Dependencias externas o técnicas. | Acoplamiento entre dos o más *Bounded Contexts*. |
| **8** | **Crítica:** Lógica de estados compleja, alta concurrencia, reportes agregados o flujos críticos de seguridad. | Alto. Riesgo de deuda técnica o bloqueos. | Operaciones atómicas que afectan la consistencia global del sistema. |

A continuación se presenta la tabla con el orden de desarrollo propuesto:

| Orden | User Story Id | Título | Descripción | Story Points |
| :--- | :--- | :--- | :--- | :--- |
| 1 | US01 | Registro de nuevo aprendiz | Como** una persona interesada en practicar idiomas **Quiero** registrarme en la plataforma con mi correo y contraseña **Para** poder acceder a la comunidad y a los encuentros. | 3 |
| 2 | US03 | Inicio de sesión | **Como** usuario registrado (aprendiz o dueño de local) **Quiero** iniciar sesión con mi correo y contraseña **Para** acceder a mis funcionalidades personalizadas. | 3 |
| 3 | US06 | Completar perfil de aprendiz | **Como** nuevo aprendiz **Quiero** completar mi perfil con mi idioma nativo, los idiomas que quiero practicar y mi nivel **Para** que otros usuarios me conozcan y el sistema me recomiende encuentros relevantes. | 3 |
| 4 | US15 | Buscar encuentros | **Como** aprendiz **Quiero** buscar encuentros usando filtros por idioma, ciudad y fecha **Para** encontrar fácilmente una sesión de práctica que me interese. | 3 |
| 5 | US16 | Ver detalles de encuentro | **Como** aprendiz **Quiero** ver los detalles completos de un encuentro **Para** saber el idioma, el tema, el lugar, la hora y quiénes más asistirán. | 2 |
| 6 | US17 | Reservar encuentro | **Como** aprendiz **Quiero** reservar mi cupo en un encuentro que tenga plazas disponibles **Para** asegurar mi asistencia. | 5 |
| 7 | US22 | Recordatorio de encuentro | **Como** aprendiz con una reserva **Quiero** recibir una notificación de recordatorio 24 horas antes del encuentro **Para** no olvidarme de asistir. | 2 |
| 8 | US26 | Cancelar reserva | **Como** aprendiz **Quiero** poder cancelar mi reserva a un encuentro con antelación **Para** liberar mi cupo si no puedo asistir. | 3 |
| 9 | US27 | Historial de encuentros | **Como** aprendiz **Quiero** tener un historial de los encuentros a los que he asistido **Para** recordar los lugares y las fechas. | 2 |
| 10 | US25 | Feedback de encuentro | **Como** aprendiz que asistió a un encuentro **Quiero** dejar una calificación y un comentario sobre mi experiencia **Para** ayudar a otros usuarios y a los locales. | 3 |
| 11 | US28 | Ver mapa de locales |  **Como** aprendiz **Quiero** ver locales disponibles según mi ubicación **Para** encontrar los lugares más cercanos donde para organizar encuentros. | 5 |
| 12 | US02 | Registro de nuevo local | **Como** dueño de un local **Quiero** registrar mi negocio en la plataforma **Para** ofrecer mi espacio para los encuentros y ganar visibilidad. | 5 |
| 13 | US10 | Registrar local | **Como** dueño de negocio (Partner) **Quiero** añadir los detalles de mi local, incluyendo nombre, dirección, aforo y horario **Para** que aparezca en la plataforma como un lugar disponible para encuentros. | 5 |
| 14 | US13 | Definir consumo mínimo | **Como** Partner **Quiero** tener la opción de definir un consumo mínimo sugerido para los asistentes a encuentros en mi local **Para** asegurar un retorno económico. | 2 |
| 15 | US11 | Editar local |  **Como** Partner **Quiero** poder editar los detalles de mi local registrado **Para** mantener la información actualizada (ej. cambio de horario). | 3 |
| 16 | US12 | Añadir fotos del local | **Como** Partner **Quiero** subir varias fotos de mi local **Para** hacerlo más atractivo y mostrar el ambiente a los aprendices. | 3 |
| 17 | US14 | Dashboard del local | **Como** Partner **Quiero** acceder a un resumen de la actividad de mi local **Para** entender rápidamente cuántos encuentros se han realizado y cuántas personas han asistido. | 5 |
| 18 | US36 | Ver asistentes por mes |  **Como** Partner **Quiero** conocer la cantidad de asistentes en mi local cada mes mediante gráficos **Para** medir el impacto de la plataforma. | 5 |
| 19 | US37 | Ver calificación promedio |  **Como** Partner **Quiero** ver la calificación promedio que los aprendices le han dado a los encuentros realizados en mi local **Para** evaluar la satisfacción del cliente. | 3 |
| 20 | US29 | Ganar puntos | **Como** aprendiz **Quiero** ganar puntos de lealtad cada vez que hago check-in en un encuentro **Para** ser recompensado por mi participación activa. | 5 |
| 21 | US30 | Ver puntos y nivel | **Como** aprendiz **Quiero** poder ver mi saldo total de puntos y mi nivel actual en mi perfil **Para** seguir mi progreso. | 1 |
| 22 | US35 | Mantener racha | **Como** aprendiz **Quiero** que el sistema registre mi racha de asistencia semanal **Para** motivarme a participar de forma consistente. | 3 |
| 23 | US31 | **Como** aprendiz **Quiero** desbloquear insignias al alcanzar ciertos hitos (ej. "Asistir a 5 encuentros de francés") **Para** sentir que logro algo. | 5 |
| 24 | US41 | Enviar solicitud de contacto |  **Como** aprendiz **Quiero** poder enviar una solicitud de contacto a otra persona con la que interactué en un encuentro **Para** mantener la comunicación. | 3 |
| 25 | US42 | Aceptar solicitudes |  **Como** aprendiz **Quiero** recibir notificaciones de nuevas solicitudes de contacto **Para** poder aceptarlas o rechazarlas. | 3 |
| 26 | US43 | Ver contactos | **Como** aprendiz **Quiero** tener una lista de todos los usuarios con los que he conectado **Para** poder iniciar una conversación. | 2 |
| 27 | US44 | Enviar mensajes | **Como** aprendiz **Quiero** poder enviar un mensaje directo a uno de mis contactos **Para** organizar una futura práctica de idiomas. | 5 |
| 28 | US45 | Notificaciones de mensajes |  **Como** usuario **Quiero** recibir una notificación cuando uno de mis contactos me envía un mensaje **Para** poder responder a tiempo. | 5 |
| 29 | US08 | Ver perfil de otros usuarios | **Como** aprendiz **Quiero** ver el perfil de otros asistentes a un encuentro **Para** conocer sus idiomas de interés y conectar con ellos.  | 2 |
| 30 | US07 | Editar perfil |  **Como** aprendiz **Quiero** poder editar la información de mi perfil en cualquier momento **Para** mantenerla actualizada. | 2 |
| 31 | US09 | Subir foto de perfil |  **Como** usuario **Quiero** subir una foto de perfil **Para** personalizar mi cuenta y que otros me reconozcan más fácilmente.| 2 |
| 32 | US46 | Reportar usuario | **Como** usuario **Quiero** tener la opción de reportar a otro usuario por comportamiento inapropiado **Para** mantener un ambiente seguro y respetuoso en la comunidad. | 5 |
| 33 | US47 | Dashboard admin | **Como** administrador de la plataforma **Quiero** acceder a información sobre el uso que se le da a la plataforma en mi local **Para** monitorear su buen funcionamiento. | 8 |
| 34 | US48 | Gestionar usuarios | **Como** administrador **Quiero** poder ver la lista de todos los usuarios y poder desactivar una cuenta en caso de abuso **Para** mantener la calidad de la comunidad. | 5 |
| 35 | US49 | Validar locales | **Como** administrador **Quiero** tener un proceso para validar y aprobar los nuevos locales que se registran **Para** asegurar que son lugares apropiados y reales. | 5 |
| 36 | US50 | Gestionar reportes |  **Como** administrador **Quiero** ver una lista de todos los reportes enviados por los usuarios **Para** poder investigarlos y tomar acciones. | 8 |
| 37 | US51 | Comunicación global | **Como** administrador **Quiero** poder enviar notificaciones o correos electrónicos a todos los usuarios **Para** comunicar novedades o mantenimientos de la plataforma.| 8 |
| 38 | US18 | Confirmación con QR | **Como** aprendiz **Quiero** recibir una confirmación de mi reserva **Para** poder hacer check-in fácilmente al llegar al local. | 5 |
| 39 | US20 | Check-in con QR |  **Como** aprendiz **Quiero** confirmar mi asistencia a un encuentro **Para** para registrar mi participación y recibir los beneficios por ello. | 8 |
| 40 | US23 | Lista de espera |  **Como** aprendiz **Quiero** unirme a una lista de espera si un encuentro está lleno **Para** tener la oportunidad de asistir si alguien cancela. | 3 |
| 41 | US24 | Notificación de cupo | **Como** aprendiz en una lista de espera **Quiero** recibir una notificación inmediata si un cupo se libera **Para** poder reservarlo rápidamente. | 5 |
| 42 | US04 | Cierre de sesión | **Como** usuario autenticado **Quiero** poder cerrar mi sesión **Para** proteger la privacidad de mi cuenta en dispositivos compartidos.  | 1 |
| 43 | US05 | Recuperación de contraseña |  **Como** usuario registrado **Quiero** solicitar un enlace para restablecer mi contraseña si la he olvidado **Para** poder recuperar el acceso a mi cuenta. | 2 |
| 44 | US38 | Ver horas pico | **Como** Partner **Quiero** ver un reporte que me muestre qué días de la semana y a qué horas se realizan más encuentros en mi local **Para** optimizar mi personal. | 8 |
| 45 | US39 | Clientes nuevos vs recurrentes | **Como** Partner **Quiero** saber qué porcentaje de los asistentes son nuevos clientes versus personas que ya han venido antes **Para** medir la captación de nuevo público. | 8 |
| 46 | US40 | Descargar reportes | **Como** Partner **Quiero** poder descargar un resumen la información de mi actividad en un formato que pueda usar fuera de la plataforma **Para** mis registros internos.| 5 |

---

![Product Backlog](assets/img/cap3/Product-Blackog.png)

[Ver Product Backlog en Jira](https://upc-hampcoders-fundamentos.atlassian.net/jira/software/projects/PI/boards/2/backlog?atlOrigin=eyJpIjoiNjI0Njg0NzE3MDRlNGNjOWE5ODM3ODhmMWQ2YjA5NDYiLCJwIjoiaiJ9)



