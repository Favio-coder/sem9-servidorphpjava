# Evidencias que debes obtener personalmente

No hay capturas creadas ni procesamiento completado. Marca cada punto solo
después de ejecutar la prueba y guarda la captura con una descripción y fecha.

1. **Versiones y arranque:** `php -v`, `php -m`, `java -version`,
   `javac -version`, `apache2 -v`, versión de Tomcat instalado,
   `systemctl status apache2 tomcat10 --no-pager` y puertos 80/8080.
   Muestra que el proceso de Tomcat usa un usuario distinto de root.
2. **Página inicial PHP:** navegador con URL completa y formulario visible.
3. **Página inicial JSP:** URL completa, formulario y ausencia de error 500.
   Complementa con los `.class` generados por Jasper para demostrar compilación.
4. **Procesamiento personal:** código escrito por ti, POST válido y respuesta
   con datos escapados. El aviso «pendiente» no demuestra procesamiento.
5. **Network:** DevTools → Network → petición al procesador; muestra método,
   estado, request/response headers y parámetros. Usa datos ficticios.
6. **Validaciones:** vacíos, espacios, correo inválido, UTF-8 y caracteres HTML.
   Usa curl para evitar que la validación del navegador oculte la del servidor.
7. **405:** GET al procesador y cabecera `Allow: POST` en ambos proyectos.
   Captura 302 únicamente si tú implementaste una redirección y verifica Location.
8. **Logs:** consultas a access.log/error.log de Apache y logs/journal de Tomcat,
   correlacionadas por hora con tus peticiones. No borres ni trunques registros.
9. **GitHub:** después de publicar personalmente, URL del repositorio, estructura
   de archivos e historial que distinga el esqueleto de tus aportes.

## Registro de ayuda de IA

Las recomendaciones iniciales están en el README raíz. Para cada nueva ayuda
sobre errores de servidor o comparación de ciclos, registra:

> IA: [problema] → Solución manual: [explicación]

En la explicación distingue «propuesta pendiente» de «ejecutada», y solo añade
fecha, resultado y captura cuando realmente hayas realizado la acción.
