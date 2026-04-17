# Capítulo III: Requirements Specification

En este capítulo se detallan los requisitos del proyecto, incluyendo los To-be Scenario Mappings, User Stories, Impact Map y el Product Backlog. Estos elementos son fundamentales para guiar el desarrollo del proyecto y asegurar que se cumplan las necesidades y expectativas de los usuarios finales.

## 3.1	To-Be Scenario Mapping

A continuación se presenta el To-Be Scenario Mapping para la aplicación de práctica de idiomas, que ilustra cómo los usuarios interactuarán con el sistema para practicar idiomas en espacios locales. Como tenemos dos segmentos objetivos (practicantes de idiomas y establecimientos aliados), se han desarrollado dos escenarios distintos para cada uno de ellos, con el fin de capturar sus respectivas experiencias y necesidades.

### Escenario 1: Experiencia del estudiante de idiomas
 
![to-be-scenario-1](assets/img/cap3/to-be-scenario1.jpg)

Este escenario describe el viaje de un usuario que busca practicar un idioma. Abarca desde la búsqueda inicial con filtros personalizados y la reserva de un cupo en una mesa temática, hasta la validación de asistencia mediante código QR en el establecimiento aliado y el seguimiento de su evolución a través de retroalimentación y recompensas por lealtad. El proceso está diseñado para generar una experiencia de aprendizaje flexible, segura y motivadora que fomente el sentido de comunidad.

### Escenario 2: Experiencia del establecimiento aliado
 
![to-be-scenario-2](assets/img/cap3/to-be-scenario2.jpg)

Este escenario detalla la interacción de los negocios asociados (cafeterías) con la plataforma. Inicia con la configuración del perfil y disponibilidad del local, seguido por la gestión y validación de reservas durante los encuentros. Adicionalmente, incluye el análisis de métricas mediante un panel de control (dashboard) y culmina con la optimización de la oferta a través de promociones basadas en datos. El objetivo principal es maximizar la ocupación en horas valle, incrementar la rentabilidad y fidelizar a una nueva clientela.


## 3.2	User Stories

## Tabla de User Stories de Landing Page

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-01 | Visitante de la página | 3 | Landing Page |
| **Título** | **Visualización de la Propuesta de Valor** |  |  |
| **Descripción** | **Como** visitante de la página **Quiero** ver una sección principal atractiva que resuma la idea del producto **Para** entender rápidamente de qué se trata el servicio. **Escenario \#1: Presentación del propósito de Glottia** \- Dado que un visitante accede a la landing page, Cuando la carga inicial se completa, Entonces se muestra un título claro que comunica el propósito: "Practica idiomas cara a cara", un subtítulo que resume el valor principal, y una llamada a la acción para registrarse. |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-02 | Visitante interesado en practicar idiomas | 2 | Landing Page |
| **Título** | **Ver Beneficios para Aprendices** |  |  |
| **Descripción** | **Como** visitante interesado en practicar idiomas **Quiero** ver claramente los beneficios específicos para aprendices **Para** entender cómo Glottia me puede ayudar a mejorar. **Escenario \#1: Visualización de beneficios para aprendices** \- Dado que un visitante explora la landing page, Cuando se desplaza a la sección de "Para Aprendices", Entonces identifica claramente beneficios como "Gana fluidez en conversaciones reales", "Conoce gente nueva" y "Acceso accesible sin academias", cada uno con una descripción breve. |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-03 | Dueño de un local | 2 | Landing Page |
| **Título** | **Ver Beneficios para Locales** |  |  |
| **Descripción** | **Como** dueño de un local **Quiero** ver claramente los beneficios que la plataforma ofrece a mi negocio **Para** comprender cómo puede aumentar mis clientes y visibilidad. **Escenario \#1: Visualización de beneficios para locales** \- Dado que un dueño de un local visita la landing page, Cuando navega a la sección de "Para Locales", Entonces ve beneficios destacados como "Atrae nuevos clientes", "Aumenta el consumo en horas valle" y "Publicidad gratuita para tu negocio". |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-04 | Visitante | 3 | Landing Page |
| **Título** | **Explicación de Cómo Funciona** |  |  |
| **Descripción** | **Como** visitante **Quiero** ver una explicación sencilla y visual de cómo funciona la plataforma **Para** entender los pasos necesarios para participar. **Escenario \#1: Pasos para el aprendiz** \- Dado que un visitante está en la sección "Cómo Funciona", Cuando revisa el flujo para aprendices, Entonces ve una secuencia de 3 o 4 pasos sencillos, como "1. Regístrate y completa tu perfil", "2. Busca un encuentro" y "3. ¡Asiste y practica\!". **Escenario \#2: Pasos para el local** \- Dado que un visitante está en la sección "Cómo Funciona", Cuando revisa el flujo para locales, Entonces ve los pasos correspondientes: "1. Registra tu local", "2. Ofrece tu espacio" y "3. Recibe a los practicantes". |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-05 | Visitante indeciso | 3 | Landing Page |
| **Título** | **Visualización de Testimonios** |  |  |
| **Descripción** | **Como** visitante indeciso **Quiero** ver testimonios de aprendices y dueños de locales reales **Para** aumentar mi confianza en el servicio. **Escenario \#1: Visualización de testimonios diversos** \- Dado que el visitante explora la landing page, Cuando accede a la sección de testimonios, Entonces debe ver al menos un testimonio de un aprendiz y uno de un dueño de local, mostrando su nombre, una foto, su rol y su comentario. |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-06 | Visitante | 2 | Landing Page |
| **Título** | **Llamadas a la Acción (CTA) Diferenciadas** |  |  |
| **Descripción** | **Como** visitante **Quiero** ver botones de llamada a la acción claros y separados, uno para aprendices y otro para locales **Para** poder registrarme fácilmente según mi interés. **Escenario \#1: Registro como aprendiz** \- Dado que un visitante está interesado en practicar idiomas, Cuando hace clic en el botón "Únete como Aprendiz", Entonces es redirigido a la página de registro para usuarios aprendices. **Escenario \#2: Registro como local** \- Dado que un visitante es dueño de un local, Cuando hace clic en el botón "Registra tu Local", Entonces es redirigido a la página de registro para partners. |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-07 | Visitante que accede desde diferentes dispositivos | 5 | Landing Page |
| **Título** | **Adaptabilidad a Diferentes Dispositivos (Responsive)** |  |  |
| **Descripción** | **Como** visitante que accede desde diferentes dispositivos **Quiero** que la landing page se adapte correctamente a mi pantalla **Para** tener una experiencia óptima independientemente del dispositivo que use. **Escenario \#1: Experiencia en dispositivo móvil** \- Dado que un visitante accede a la landing page desde un smartphone, Cuando la página se carga, Entonces todos los elementos se reorganizan en una sola columna, el texto es legible y los botones son fáciles de presionar, sin necesidad de hacer zoom o scroll horizontal. |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-08 | Visitante | 3 | Landing Page |
| **Título** | **Navegación mediante Encabezado Fijo** |  |  |
| **Descripción** | **Como** visitante **Quiero** un menú de navegación claro en el encabezado que permanezca visible mientras me desplazo **Para** acceder fácilmente a las diferentes secciones de la página. **Escenario \#1: Acceso a secciones desde el encabezado** \- Dado que un visitante explora la landing page, Cuando hace clic en una opción del menú de navegación (ej. "Beneficios"), Entonces la página se desplaza suavemente hasta esa sección, y el encabezado permanece fijo en la parte superior de la pantalla. |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-09 | Visitante con dudas | 2 | Landing Page |
| **Título** | **Visualización de una Sección de Preguntas Frecuentes (FAQ)** |  |  |
| **Descripción** | **Como** visitante con dudas **Quiero** encontrar una sección de preguntas frecuentes **Para** resolver rápidamente mis inquietudes más comunes. **Escenario \#1: Resolver una duda común** \- Dado que un visitante se pregunta si tiene que pagar para asistir, Cuando accede a la sección de FAQ y hace clic en la pregunta "¿Tiene algún costo?", Entonces se despliega una respuesta clara y concisa. |  |  |

| Story ID | User | Story Points | Epic |
| :---- | :---- | :---- | :---- |
| US-LP-10 | Visitante | 1 | Landing Page |
| **Título** | **Visualización del Pie de Página (Footer)** |  |  |
| **Descripción** | **Como** visitante **Quiero** ver un pie de página organizado con enlaces de interés **Para** encontrar información adicional o contactar con la empresa. **Escenario \#1: Contenido completo del pie de página** \- Dado que un visitante se desplaza hasta el final de la landing page, Cuando llega al pie de página, Entonces debe ver enlaces a "Términos y Condiciones", "Política de Privacidad", y enlaces a las redes sociales del proyecto. |  |  |

## Tabla de User Stories por Epic

| Story ID | User | Story Points | Epic |
|----------|------|----------|------|
| US01 | Persona interesada en practicar idiomas | 3 | Gestión de Identidad y Acceso (IAM) |
| **Title** | **Registro de nuevo aprendiz** |
| **Description** | **Como** una persona interesada en practicar idiomas **Quiero** registrarme en la plataforma con mi correo y contraseña **Para** poder acceder a la comunidad y a los encuentros. **Escenario #1: Registro exitoso** - Dado que un nuevo usuario desea unirse a la plataforma, Cuando proporciona los datos requeridos para el registro y acepta los términos, Entonces el sistema crea su cuenta, le envía una bienvenida y lo guía para completar su perfil. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US02 | Dueño de un local | 5 | Gestión de Identidad y Acceso (IAM) |
| **Title** | **Registro de nuevo local** |
| **Description** | **Como** dueño de un local **Quiero** registrar mi negocio en la plataforma **Para** ofrecer mi espacio para los encuentros y ganar visibilidad. **Escenario #1: Registro de local exitoso** - Dado que el dueño de un local desea unirse a la plataforma, Cuando proporciona la información de su cuenta y los datos de su negocio, Entonces el sistema crea una cuenta de tipo "Partner", la asocia al local y le concede acceso al panel de gestión. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US03 | Usuario registrado (aprendiz o dueño de local) | 3 | Gestión de Identidad y Acceso (IAM) |
| **Title** | **Inicio de sesión general** |
| **Description** | **Como** usuario registrado (aprendiz o dueño de local) **Quiero** iniciar sesión con mi correo y contraseña **Para** acceder a mis funcionalidades personalizadas. **Escenario #1: Inicio de sesión exitoso** - Dado que un usuario registrado desea acceder a su cuenta, Cuando proporciona sus credenciales de acceso correctas, Entonces el sistema lo autentica y le presenta su panel principal correspondiente. **Escenario #2: Credenciales incorrectas** - Dado que un usuario registrado desea acceder a su cuenta, Cuando proporciona credenciales incorrectas, Entonces el sistema le informa que el acceso ha sido denegado por credenciales inválidas. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US04 | Usuario autenticado | 1 | Gestión de Identidad y Acceso (IAM) |
| **Title** | **Cierre de sesión** |
| **Description** | **Como** usuario autenticado **Quiero** poder cerrar mi sesión **Para** proteger la privacidad de mi cuenta en dispositivos compartidos. **Escenario #1: Cierre de sesión exitoso** - Dado que un usuario ha iniciado sesión en la plataforma, Cuando solicita finalizar su sesión, Entonces el sistema termina la sesión activa y lo devuelve a la página de inicio pública. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US05 | Usuario registrado | 2 | Gestión de Identidad y Acceso (IAM) |
| **Title** | **Recuperación de contraseña** |
| **Description** | **Como** usuario registrado **Quiero** solicitar un enlace para restablecer mi contraseña si la he olvidado **Para** poder recuperar el acceso a mi cuenta. **Escenario #1: Solicitud de recuperación exitosa** - Dado que un usuario olvidó su contraseña, Cuando proporciona el correo electrónico de su cuenta para la recuperación, Entonces el sistema le envía un correo con las instrucciones para crear una nueva contraseña. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US06 | Nuevo aprendiz | 3 | Perfiles de Usuario (Profiles) |
| **Title** | **Completar perfil de aprendiz** |
| **Description** | **Como** nuevo aprendiz **Quiero** completar mi perfil con mi idioma nativo, los idiomas que quiero practicar y mi nivel **Para** que otros usuarios me conozcan y el sistema me recomiende encuentros relevantes. **Escenario #1: Primer llenado de perfil** - Dado que un aprendiz se ha registrado, Cuando especifica sus idiomas, su nivel de fluidez y guarda la información, Entonces su perfil se actualiza y el sistema utiliza estas preferencias para recomendarle encuentros. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US07 | Aprendiz | 2 | Perfiles de Usuario (Profiles) |
| **Title** | **Editar perfil de aprendiz** |
| **Description** | **Como** aprendiz **Quiero** poder editar la información de mi perfil en cualquier momento **Para** mantenerla actualizada. **Escenario #1: Actualización de idiomas** - Dado que un aprendiz ha mejorado su nivel de inglés, Cuando actualiza su nivel de fluidez en su perfil, Entonces el sistema guarda los cambios y su perfil público refleja la nueva información. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US08 | Aprendiz | 2 | Perfiles de Usuario (Profiles) |
| **Title** | **Ver perfil de otro usuario** |
| **Description** | **Como** aprendiz **Quiero** ver el perfil de otros asistentes a un encuentro **Para** conocer sus idiomas de interés y conectar con ellos. **Escenario #1: Visualización de perfil público** - Dado que estoy viendo los detalles de un encuentro, Cuando solicito ver el perfil de otro asistente, Entonces se me muestra su información pública relevante (foto, nombre, idiomas). |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US09 | Usuario | 2 | Perfiles de Usuario (Profiles) |
| **Title** | **Subir foto de perfil** |
| **Description** | **Como** usuario **Quiero** subir una foto de perfil **Para** personalizar mi cuenta y que otros me reconozcan más fácilmente. **Escenario #1: Carga de imagen exitosa** - Dado que estoy gestionando mi perfil, Cuando proporciono una nueva imagen para mi perfil, Entonces la imagen se actualiza y se muestra en toda la plataforma. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US10 | Dueño de negocio (Partner) | 5 | Gestión de Locales (Partner) |
| **Title** | **Dar de alta un nuevo local** |
| **Description** | **Como** dueño de negocio (Partner) **Quiero** añadir los detalles de mi local, incluyendo nombre, dirección, aforo y horario **Para** que aparezca en la plataforma como un lugar disponible para encuentros. **Escenario #1: Registro de información del local** - Dado que un Partner desea añadir un nuevo local, Cuando proporciona toda la información requerida del establecimiento y la guarda, Entonces el local se añade a su perfil y se vuelve visible en la plataforma. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US11 | Partner | 3 | Gestión de Locales (Partner) |
| **Title** | **Editar información de un local** |
| **Description** | **Como** Partner **Quiero** poder editar los detalles de mi local registrado **Para** mantener la información actualizada (ej. cambio de horario). **Escenario #1: Actualizar horario del local** - Dado que un Partner necesita cambiar el horario de su cafetería, Cuando modifica la información del horario en los detalles del local, Entonces la nueva información se refleja inmediatamente en la plataforma. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US12 | Partner | 3 | Gestión de Locales (Partner) |
| **Title** | **Añadir fotos del local** |
| **Description** | **Como** Partner **Quiero** subir varias fotos de mi local **Para** hacerlo más atractivo y mostrar el ambiente a los aprendices. **Escenario #1: Cargar galería de fotos** - Dado que un Partner está gestionando el perfil de su local, Cuando proporciona un conjunto de imágenes del establecimiento, Entonces las fotos se asocian al perfil del local y se muestran en una galería. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US13 | Partner | 2 | Gestión de Locales (Partner) |
| **Title** | **Definir consumo mínimo (Opcional)** |
| **Description** | **Como** Partner **Quiero** tener la opción de definir un consumo mínimo sugerido para los asistentes a encuentros en mi local **Para** asegurar un retorno económico. **Escenario #1: Establecer consumo mínimo** - Dado que un Partner desea incentivar el consumo, Cuando establece un consumo mínimo sugerido para los encuentros en su local, Entonces esta información es visible en los detalles de dichos encuentros. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US14 | Partner | 5 | Gestión de Locales (Partner) |
| **Title** | **Ver dashboard de mi local** |
| **Description** | **Como** Partner **Quiero** acceder a un resumen de la actividad de mi local **Para** entender rápidamente cuántos encuentros se han realizado y cuántas personas han asistido. **Escenario #1: Visualización de métricas clave** - Dado que un Partner accede a su panel, Cuando solicita ver el resumen de actividad, Entonces se le presentan las métricas clave de sus locales (encuentros, asistentes, calificación). |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US15 | Aprendiz | 3 | Gestión de Encuentros (Event) |
| **Title** | **Buscar encuentros disponibles** |
| **Description** | **Como** aprendiz **Quiero** buscar encuentros usando filtros por idioma, ciudad y fecha **Para** encontrar fácilmente una sesión de práctica que me interese. **Escenario #1: Búsqueda con filtros** - Dado que un aprendiz quiere encontrar un encuentro, Cuando aplica filtros de búsqueda por idioma, ciudad y fecha, Entonces el sistema le muestra una lista de resultados que coinciden con sus criterios. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US16 | Aprendiz | 2 | Gestión de Encuentros (Event) |
| **Title** | **Ver detalles de un encuentro** |
| **Description** | **Como** aprendiz **Quiero** ver los detalles completos de un encuentro **Para** saber el idioma, el tema, el lugar, la hora y quiénes más asistirán. **Escenario #1: Acceder a la información del encuentro** - Dado que un aprendiz ha encontrado un encuentro de su interés, Cuando selecciona ese encuentro de la lista, Entonces se le presenta toda la información detallada del evento. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US17 | Aprendiz | 5 | Gestión de Encuentros (Event) |
| **Title** | **Reservar un cupo en un encuentro** |
| **Description** | **Como** aprendiz **Quiero** reservar mi cupo en un encuentro que tenga plazas disponibles **Para** asegurar mi asistencia. **Escenario #1: Reserva exitosa** - Dado que un aprendiz está viendo un encuentro con cupos disponibles, Cuando confirma su deseo de reservar un cupo, Entonces el sistema procesa su reserva, actualiza los cupos y le envía una notificación. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US18 | Aprendiz | 5 | Gestión de Encuentros (Event) |
| **Title** | **Recibir confirmación con código QR** |
| **Description** | **Como** aprendiz **Quiero** recibir una confirmación de mi reserva **Para** poder hacer check-in fácilmente al llegar al local. **Escenario #1: Generación de QR tras reserva** - Dado que un aprendiz ha completado una reserva, Cuando consulta los detalles de su reserva, Entonces el sistema le proporciona un código QR único para el check-in. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US19 | Aprendiz | 8 | Gestión de Encuentros (Event) |
| **Title** | **Crear un encuentro (iniciativa del aprendiz)** |
| **Description** | **Como** aprendiz **Quiero** proponer la creación de un nuevo encuentro en un local registrado **Para** organizar una sesión si no hay ninguna que se ajuste a mis necesidades. **Escenario #1: Proponer nuevo encuentro** - Dado que un aprendiz desea organizar un encuentro, Cuando proporciona los detalles del nuevo evento (local, fecha, idioma), Entonces el sistema crea el encuentro, lo registra como el primer asistente y lo hace visible para otros usuarios. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US20 | Aprendiz | 8 | Gestión de Encuentros (Event) |
| **Title** | **Check-in en un encuentro** |
| **Description** | **Como** aprendiz **Quiero** confirmar mi asistencia a un encuentro **Para** para registrar mi participación y recebir los beneficios por ello. **Escenario #1: Check-in exitoso por parte del local** - Dado que un aprendiz llega al local del encuentro, Cuando su código QR es validado por el organizador, Entonces el sistema registra su asistencia y le asigna los puntos correspondientes. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US21 | Partner | 3 | Gestión de Encuentros (Event) |
| **Title** | **Ver lista de asistentes (vista de Partner)** |
| **Description** | **Como** Partner **Quiero** ver la lista de personas que han reservado para un encuentro en mi local **Para** tener una idea del aforo esperado. **Escenario #1: Consultar asistentes** - Dado que un Partner tiene un encuentro programado, Cuando consulta los detalles de dicho evento, Entonces el sistema le muestra la lista de los aprendices que han confirmado su asistencia. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US22 | Aprendiz con una reserva | 2 | Gestión de Encuentros (Event) |
| **Title** | **Recibir recordatorio de encuentro** |
| **Description** | **Como** aprendiz con una reserva **Quiero** recibir una notificación de recordatorio 24 horas antes del encuentro **Para** no olvidarme de asistir. **Escenario #1: Notificación automática** - Dado que un aprendiz tiene una reserva para mañana, Cuando faltan 24 horas para el evento, Entonces el sistema le envía automáticamente un recordatorio. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US23 | Aprendiz | 3 | Gestión de Encuentros (Event) |
| **Title** | **Unirse a la lista de espera** |
| **Description** | **Como** aprendiz **Quiero** unirme a una lista de espera si un encuentro está lleno **Para** tener la oportunidad de asistir si alguien cancela. **Escenario #1: Encuentro lleno** - Dado que un aprendiz desea asistir a un encuentro sin cupos, Cuando opta por unirse a la lista de espera, Entonces el sistema lo añade a la cola y le notifica su posición. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US24 | Aprendiz en una lista de espera | 5 | Gestión de Encuentros (Event) |
| **Title** | **Recibir notificación de cupo liberado** |
| **Description** | **Como** aprendiz en una lista de espera **Quiero** recibir una notificación inmediata si un cupo se libera **Para** poder reservarlo rápidamente. **Escenario #1: Alguien cancela** - Dado que un aprendiz está en una lista de espera y se libera un cupo, Cuando le llega su turno, Entonces el sistema le envía una notificación para que pueda confirmar su asistencia en un tiempo limitado. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US25 | Aprendiz que asistió a un encuentro | 3 | Gestión de Encuentros (Event) |
| **Title** | **Dejar feedback de un encuentro** |
| **Description** | **Como** aprendiz que asistió a un encuentro **Quiero** dejar una calificación y un comentario sobre mi experiencia **Para** ayudar a otros usuarios y a los locales. **Escenario #1: Calificar la experiencia** - Dado que un aprendiz ha asistido a un encuentro, Cuando proporciona una calificación y un comentario sobre el evento, Entonces el sistema guarda su feedback y lo asocia al encuentro y al local. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US26 | Aprendiz | 3 | Gestión de Encuentros (Event) |
| **Title** | **Cancelar mi reserva** |
| **Description** | **Como** aprendiz **Quiero** poder cancelar mi reserva a un encuentro con antelación **Para** liberar mi cupo si no puedo asistir. **Escenario #1: Cancelación a tiempo** - Dado que un aprendiz tiene una reserva y no puede asistir, Cuando solicita la cancelación de su reserva antes del tiempo límite, Entonces su cupo se libera para otros usuarios. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US27 | Aprendiz | 2 | Gestión de Encuentros (Event) |
| **Title** | **Ver encuentros pasados** |
| **Description** | **Como** aprendiz **Quiero** tener un historial de los encuentros a los que he asistido **Para** recordar los lugares y las fechas. **Escenario #1: Consultar historial** - Dado que un aprendiz quiere revisar su actividad pasada, Cuando consulta su historial de encuentros, Entonces el sistema le muestra una lista de todos los eventos en los que participó. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US28 | Aprendiz | 5 | Gestión de Encuentros (Event) |
| **Title** | **Ver el mapa de locales** |
| **Description** | **Como** aprendiz **Quiero** ver locales disponibles según mi ubicación **Para** encontrar los lugares más cercanos donde para organizar encuentros. **Escenario #1: Exploración geográfica** - Dado que un aprendiz quiere descubrir nuevos locales, Cuando explora la vista de mapa, Entonces el sistema le muestra la ubicación de todos los locales aliados. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US29 | Aprendiz | 5 | Lealtad y Gamificación (Loyalty) |
| **Title** | **Ganar puntos por asistencia** |
| **Description** | **Como** aprendiz **Quiero** ganar puntos de lealtad cada vez que hago check-in en un encuentro **Para** ser recompensado por mi participación activa. **Escenario #1: Acumulación de puntos** - Dado que un aprendiz ha hecho check-in exitosamente en un evento, Cuando el sistema procesa su asistencia, Entonces automáticamente se suman los puntos correspondientes a su cuenta. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US30 | Aprendiz | 1 | Lealtad y Gamificación (Loyalty) |
| **Title** | **Ver mi total de puntos y nivel** |
| **Description** | **Como** aprendiz **Quiero** poder ver mi saldo total de puntos y mi nivel actual en mi perfil **Para** seguir mi progreso. **Escenario #1: Consultar progreso** - Dado que un aprendiz accede a su perfil, Cuando consulta su progreso de lealtad, Entonces el sistema le muestra sus puntos totales y su nivel actual. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US31 | Aprendiz | 5 | Lealtad y Gamificación (Loyalty) |
| **Title** | **Desbloquear una insignia (badge)** |
| **Description** | **Como** aprendiz **Quiero** desbloquear insignias al alcanzar ciertos hitos (ej. "Asistir a 5 encuentros de francés") **Para** sentir que logro algo. **Escenario #1: Desbloqueo de insignia por asistencia** - Dado que un aprendiz ha cumplido los requisitos para una insignia, Cuando el sistema verifica el hito, Entonces le otorga la insignia correspondiente y le muestra una notificación. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US32 | Aprendiz | 3 | Lealtad y Gamificación (Loyalty) |
| **Title** | **Ver mis insignias desbloqueadas** |
| **Description** | **Como** aprendiz **Quiero** tener una sección en mi perfil donde pueda ver todas las insignias que he ganado **Para** mostrarlas a la comunidad. **Escenario #1: Galería de logros** - Dado que un aprendiz ha desbloqueado insignias, Cuando visita un perfil (suyo o de otro usuario), Entonces puede ver la colección de insignias ganadas. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US33 | Aprendiz | 3 | Lealtad y Gamificación (Loyalty) |
| **Title** | **Ver un ranking de usuarios** |
| **Description** | **Como** aprendiz **Quiero** recibir y acceder a información sobre mi progreso y compararlo con el de otros usuarios **Para** competir de forma amistosa con otros miembros de la comunidad. **Escenario #1: Consultar el leaderboard** - Dado que un aprendiz quiere ver su posición en la comunidad, Cuando accede a la tabla de clasificación, Entonces el sistema le muestra el ranking de usuarios basado en puntos. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US34 | Aprendiz leal | 5 | Lealtad y Gamificación (Loyalty) |
| **Title** | **Recibir ofertas de locales por lealtad** |
| **Description** | **Como** aprendiz leal **Quiero** recibir ofertas especiales o descuentos de los locales asociados **Como** recompensa por mi participación. **Escenario #1: Recompensa de un Partner** - Dado que un aprendiz ha alcanzado un nivel de lealtad alto, Cuando un local ofrece una recompensa para ese nivel, Entonces el aprendiz recibe una notificación con la oferta especial. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US35 | Aprendiz | 3 | Lealtad y Gamificación (Loyalty) |
| **Title** | **Mantener una racha de asistencia** |
| **Description** | **Como** aprendiz **Quiero** que el sistema registre mi racha de asistencia semanal **Para** motivarme a participar de forma consistente. **Escenario #1: Incrementar la racha** - Dado que un aprendiz asistió a un encuentro la semana pasada, Cuando asiste a otro encuentro esta semana, Entonces el sistema incrementa su racha de asistencia y se lo notifica. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US36 | Partner | 5 | Analíticas (Analytics) |
| **Title** | **Ver número de asistentes por mes** |
| **Description** | **Como** Partner **Quiero** conocer la cantidad de asistentes en mi local cada mes mediante gráficos **Para** medir el impacto de la plataforma. **Escenario #1: Reporte mensual de asistencia** - Dado que un Partner está en su panel de analíticas, Cuando consulta el reporte de asistencia mensual, Entonces el sistema le presenta un gráfico con los datos de asistencia por mes. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US37 | Partner | 3 | Analíticas (Analytics) |
| **Title** | **Ver calificación promedio de mi local** |
| **Description** | **Como** Partner **Quiero** ver la calificación promedio que los aprendices le han dado a los encuentros realizados en mi local **Para** evaluar la satisfacción del cliente. **Escenario #1: Métrica de satisfacción** - Dado que un Partner está en su dashboard, Cuando consulta el rendimiento de su local, Entonces el sistema le muestra la calificación promedio basada en el feedback de los usuarios. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US38 | Partner | 8 | Analíticas (Analytics) |
| **Title** | **Identificar horas y días pico** |
| **Description** | **Como** Partner **Quiero** ver un reporte que me muestre qué días de la semana y a qué horas se realizan más encuentros en mi local **Para** optimizar mi personal. **Escenario #1: Mapa de calor de actividad** - Dado que un Partner quiere conocer sus horas más populares, Cuando consulta el reporte de horas pico, Entonces el sistema le presenta una visualización de los días y horas con mayor actividad. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US39 | Partner | 8 | Analíticas (Analytics) |
| **Title** | **Rastrear asistentes nuevos vs. recurrentes** |
| **Description** | **Como** Partner **Quiero** saber qué porcentaje de los asistentes son nuevos clientes versus personas que ya han venido antes **Para** medir la captación de nuevo público. **Escenario #1: Reporte de retención** - Dado que un Partner está analizando sus métricas, Cuando consulta el reporte de clientes, Entonces el sistema le muestra la proporción de asistentes nuevos vs. recurrentes. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US40 | Partner | 5 | Analíticas (Analytics) |
| **Title** | **Descargar reporte básico** |
| **Description** | **Como** Partner **Quiero** poder descargar un resumen la información de mi actividad en un formato que pueda usar fuera de la plataforma **Para** mis registros internos. **Escenario #1: Exportar datos** - Dado que un Partner necesita un informe de su actividad, Cuando solicita la descarga del reporte de analíticas, Entonces el sistema genera un archivo con los datos del período seleccionado. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US41 | Aprendiz | 3 | Comunidad y Social |
| **Title** | **Enviar solicitud de contacto** |
| **Description** | **Como** aprendiz **Quiero** poder enviar una solicitud de contacto a otra persona con la que interactué en un encuentro **Para** mantener la comunicación. **Escenario #1: Conectar después de un evento** - Dado que he interactuado con otro aprendiz en un encuentro, Cuando envío una solicitud de contacto a través de su perfil, Entonces el sistema notifica al otro usuario de mi solicitud. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US42 | Aprendiz | 3 | Comunidad y Social |
| **Title** | **Aceptar solicitud de contacto** |
| **Description** | **Como** aprendiz **Quiero** recibir notificaciones de nuevas solicitudes de contacto **Para** poder aceptarlas o rechazarlas. **Escenario #1: Gestión de solicitudes** - Dado que he recibido una solicitud de contacto, Cuando acepto la solicitud, Entonces ambos pasamos a formar parte de nuestras respectivas listas de contactos. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US43 | Aprendiz | 2 | Comunidad y Social |
| **Title** | **Ver mi lista de contactos** |
| **Description** | **Como** aprendiz **Quiero** tener una lista de todos los usuarios con los que he conectado **Para** poder iniciar una conversación. **Escenario #1: Acceder a mis conexiones** - Dado que he establecido contactos en la plataforma, Cuando consulto mi lista de contactos, Entonces el sistema me muestra todos los usuarios con los que he conectado. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US44 | Aprendiz | 5 | Mensajería |
| **Title** | **Enviar mensaje a un contacto** |
| **Description** | **Como** aprendiz **Quiero** poder enviar un mensaje directo a uno de mis contactos **Para** organizar una futura práctica de idiomas. **Escenario #1: Iniciar una conversación** - Dado que deseo comunicarme con un contacto, Cuando le envío un mensaje privado, Entonces el sistema entrega el mensaje y le notifica al destinatario. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US45 | Usuario | 5 | Notificaciones |
| **Title** | **Recibir notificaciones de mensajes nuevos** |
| **Description** | **Como** usuario **Quiero** recibir una notificación cuando uno de mis contactos me envía un mensaje **Para** poder responder a tiempo. **Escenario #1: Alerta de mensaje** - Dado que estoy usando la aplicación, Cuando recibo un nuevo mensaje de un contacto, Entonces el sistema me alerta de la notificación. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US46 | Usuario | 5 | Moderación |
| **Title** | **Reportar un usuario** |
| **Description** | **Como** usuario **Quiero** tener la opción de reportar a otro usuario por comportamiento inapropiado **Para** mantener un ambiente seguro y respetuoso en la comunidad. **Escenario #1: Denunciar comportamiento** - Dado que he presenciado un comportamiento inapropiado, Cuando envío un reporte sobre un usuario especificando el motivo, Entonces el sistema envía el reporte a los administradores para su revisión. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US47 | Administrador | 8 | Administración |
| **Title** | **Ver dashboard de administrador** |
| **Description** | **Como** administrador de la plataforma **Quiero** acceder a información sobre el uso que se le da a la plataforma en mi local **Para** monitorear su buen funcionamiento. **Escenario #1: Vista general del sistema** - Dado que un administrador ha iniciado sesión, Cuando accede al panel de administración, Entonces el sistema le presenta las métricas clave de la plataforma. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US48 | Administrador | 5 | Administración |
| **Title** | **Gestionar usuarios** |
| **Description** | **Como** administrador **Quiero** poder ver la lista de todos los usuarios y poder desactivar una cuenta en caso de abuso **Para** mantener la calidad de la comunidad. **Escenario #1: Desactivar una cuenta** - Dado que se ha verificado un reporte de abuso, Cuando el administrador ejecuta la acción de desactivar la cuenta del infractor, Entonces el usuario ya no puede acceder a la plataforma. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US49 | Administrador | 5 | Administración |
| **Title** | **Validar nuevos locales** |
| **Description** | **Como** administrador **Quiero** tener un proceso para validar y aprobar los nuevos locales que se registran **Para** asegurar que son lugares apropiados y reales. **Escenario #1: Aprobación de local** - Dado que un nuevo local está pendiente de aprobación, Cuando el administrador verifica y aprueba la solicitud, Entonces el local se activa y se hace visible públicamente en la plataforma. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US50 | Administrador | 8 | Administración |
| **Title** | **Gestionar reportes de usuarios** |
| **Description** | **Como** administrador **Quiero** ver una lista de todos los reportes enviados por los usuarios **Para** poder investigarlos y tomar acciones. **Escenario #1: Revisar una denuncia** - Dado que un usuario ha sido reportado, Cuando el administrador consulta los reportes pendientes, Entonces puede ver todos los detalles de la denuncia para su investigación. |

| Story ID | User | Priority | Epic |
|----------|------|----------|------|
| US51 | Administrador | 8 | Administración |
| **Title** | **Enviar comunicaciones globales** |
| **Description** | **Como** administrador **Quiero** poder enviar notificaciones o correos electrónicos a todos los usuarios **Para** comunicar novedades o mantenimientos de la plataforma. **Escenario #1: Anuncio de nueva funcionalidad** - Dado que se necesita comunicar una novedad a todos los usuarios, Cuando el administrador envía una comunicación global, Entonces todos los usuarios registrados reciben la notificación. |

## 3.3	Impact Map
Se presentara los mapas de impacto realizados por cada segemnto 

![](assets/img/cap3/Impact-map.png)

---
![](assets/img/cap3/Impact-map-Carlos.png)


## 3.4	Product Backlog   
