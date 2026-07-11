# Conclusiones

## Conclusiones

El desarrollo del proyecto Glottia se sustentó inicialmente en la aplicación rigurosa de metodologías centradas en el usuario, tales como Lean UX, entrevistas en profundidad, Customer Journey Mapping (As-Is) e Impact Mapping. Estas herramientas permitieron identificar de manera precisa las necesidades, frustraciones y expectativas de los segmentos objetivo, asegurando que la propuesta de solución se construya sobre evidencia empírica y no sobre supuestos, fortaleciendo así la validez del enfoque planteado.

En la etapa correspondiente al TB2, el proyecto evolucionó hacia un enfoque arquitectónico estructurado, incorporando principios y prácticas avanzadas de diseño de software. Se aplicaron patrones arquitectónicos como Domain-Driven Design (DDD), lo que permitió delimitar claramente los bounded contexts y organizar el dominio del problema de manera coherente, facilitando la comprensión, mantenibilidad y escalabilidad del sistema.

Asimismo, se empleó el método Attribute-Driven Design (ADD) para guiar la toma de decisiones arquitectónicas en función de los drivers del sistema, tales como atributos de calidad, restricciones y requerimientos funcionales. Este enfoque permitió estructurar iteraciones arquitectónicas, definir responsabilidades, establecer interfaces y justificar decisiones técnicas de manera sistemática, fortaleciendo la solidez del diseño propuesto.

Durante la etapa del TB3 y TB4, el proyecto completó la migración de 10 bounded contexts del monolito modular a microservicios independientes desplegados en AWS, utilizando Terraform como Infrastructure as Code para el aprovisionamiento automatizado de la infraestructura cloud (VPC, EC2, ECR, RDS PostgreSQL). Se implementó un API Gateway (Spring Cloud Gateway) como punto único de entrada con 17 rutas de enrutamiento, un Service Registry (Netflix Eureka) para descubrimiento de servicios, y RabbitMQ como bus de mensajería asíncrona para la comunicación desacoplada entre dominios mediante el patrón Transactional Outbox.

En el frente de aseguramiento de calidad, se implementaron suites de pruebas BDD con Cucumber.js y Gherkin que cubren los 10 microservicios, alcanzando una cobertura superior al 70% de las user stories definidas. Los escenarios Gherkin ejecutables verifican códigos de estado HTTP, esquemas de respuesta JSON y flujos excepcionales de seguridad, integrándose al pipeline de CI/CD para validación continua. Los reportes de ejecución generados evidencian el paso exitoso de los escenarios críticos de registro, autenticación, gestión de perfiles, encuentros, promociones, gamificación y notificaciones.

El proyecto demuestra una evolución significativa desde la comprensión del problema hasta la construcción de una arquitectura de software fundamentada en buenas prácticas de ingeniería. La integración de metodologías UX con enfoques arquitectónicos avanzados permitió desarrollar una solución coherente, viable y preparada para su implementación, consolidando una base sólida para el desarrollo futuro del sistema.

Finalmente, Glottia no solo responde a una problemática real del mercado, sino que también establece una arquitectura escalable, mantenible y alineada a estándares modernos de desarrollo de software, lo que incrementa significativamente su potencial de impacto tecnológico, social y económico.

## Recomendaciones

Se recomienda continuar con la validación de la solución mediante la interacción constante con usuarios reales, integrando ciclos iterativos de retroalimentación que permitan ajustar tanto las funcionalidades como las decisiones arquitectónicas en función de la experiencia de uso.

Asimismo, es fundamental profundizar en la implementación técnica de la arquitectura propuesta, especialmente en la materialización de los bounded contexts definidos mediante DDD y en la correcta implementación de los patrones y tácticas arquitectónicas identificadas, asegurando la coherencia entre el diseño teórico y su ejecución práctica.

Se sugiere también fortalecer el análisis de atributos de calidad mediante la ejecución de pruebas específicas (por ejemplo, pruebas de rendimiento, seguridad y disponibilidad), con el fin de validar que las tácticas implementadas cumplen con los escenarios definidos y los niveles de servicio esperados.

De igual manera, se recomienda mantener el uso del enfoque ADD en futuras iteraciones del proyecto, permitiendo una evolución controlada de la arquitectura conforme el sistema crezca en complejidad, asegurando que las decisiones de diseño continúen alineadas con los drivers arquitectónicos.

Adicionalmente, resulta conveniente ampliar la documentación arquitectónica, incorporando decisiones de diseño (Architecture Decision Records - ADRs) que permitan justificar y registrar los cambios realizados, facilitando la mantenibilidad y comprensión del sistema a largo plazo.

Finalmente, se recomienda continuar aplicando metodologías ágiles y enfoques centrados en el usuario como eje transversal del proyecto, integrándolos con prácticas sólidas de arquitectura de software, lo que permitirá desarrollar una solución adaptable, escalable y alineada a las necesidades dinámicas del mercado.