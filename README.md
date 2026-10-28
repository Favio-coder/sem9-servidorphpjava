# Laboratorio 09: PHP y JSP en Linux

Esqueleto educativo: los formularios existen, **el procesamiento está pendiente**.
Fuentes: `/home/favio-coder/universidad/desarrolloWeb/sem9`.

## Estado actualizado: desplegado con diseño

Actualización del 28/10/2026, 13:36 (hora local). **Ambos proyectos están
publicados**. Las referencias posteriores a Tomcat no instalado y publicación
pendiente describen la inspección inicial; quedan superadas por esta verificación.

- PHP: **http://localhost/lab09-php/**, Apache en puerto 80.
- Java/JSP: **http://localhost:8080/lab09-jsp/**, Tomcat **10.1.55** y JDK 21.
- Se encontró el directorio desplegado de JSP vacío: esa era la causa del 404.
- Se publicaron ambas fuentes mediante `rsync`, con autenticación de escritorio
  `pkexec`. Los respaldos previos están en
  `/var/backups/lab09-php-20261028-133612` y
  `/var/backups/lab09-jsp-20261028-133612`.
- Tomcat ejecuta su JVM como usuario `tomcat`; detectó los cambios y completó
  la recarga de la aplicación sin reiniciar servicios.
- Verificado: GET de ambas páginas iniciales y ambos CSS → **200**;
  GET y POST de ambos procesadores → **200** con aviso pendiente.
  Apache entregó HTML generado por PHP sin código fuente. Tomcat compiló y
  ejecutó las páginas JSP, entregando HTML sin directivas JSP y con UTF-8.
- `php -l` pasó nuevamente en `config.php` y `procesar.php`.
- La inspección directa de clases en `/var/cache/tomcat10` no fue accesible
  con los permisos del usuario; la ejecución JSP se comprobó por HTTP.

Diseño generado por IA: `styles.css` independiente en cada proyecto, presentación
adaptable, tarjetas, etiquetas accesibles, foco de teclado, colores violeta/verde
y páginas de respuesta con enlace de regreso. Sin fuentes o recursos externos.
La revisión visual en navegador y las capturas quedan a tu cargo; si ves el estilo
antiguo, recarga con **Ctrl+F5**. La validación, sesión explícita y respuestas 405
continúan pendientes: el POST actual muestra un aviso y no procesa los campos.

Logs de Tomcat **confirmados ahora**:

```bash
less /var/log/tomcat10/catalina.2026-10-28.log
less /var/log/tomcat10/catalina.out
less /var/log/tomcat10/localhost_access_log.2026-10-28.txt
journalctl -u tomcat10 -n 80 --no-pager
```

`/var/lib/tomcat10/logs` enlaza a `/var/log/tomcat10` y
`/var/lib/tomcat10/work` a `/var/cache/tomcat10`. Los nombres fechados cambian
cada día. Para actualizar en adelante, conserva las fuentes y repite el respaldo
y los `rsync` de la sección 3; **no necesitas instalar Tomcat otra vez**.

IA: JSP devolvía 404 aunque Tomcat estaba activo → Solución manual: copiar el
contenido completo de lab09-jsp, incluido WEB-INF, a su carpeta en webapps y
verificar por HTTP; en esta intervención la copia fue ejecutada por el agente
mediante autenticación administrativa, no se atribuye como trabajo manual del
estudiante. Resultado comprobado: 200 en index.jsp y procesar.jsp.

## 1. Entorno inspeccionado

Inspección del 28 de octubre de 2026:

| Componente | Resultado real |
| --- | --- |
| Distribución | Linux Mint 22.2 Zara, base Ubuntu 24.04 Noble, APT |
| PHP CLI | 8.3.6; cumple PHP ≥ 8.2 |
| Java / compilador | OpenJDK y javac 21.0.12.1; cumple JDK ≥ 17 |
| Apache | 2.4.58 activo; `php_module` y `mpm_prefork_module` cargados |
| PHP para Apache | `libapache2-mod-php8.3` instalado |
| DocumentRoot | `/var/www/html`, root:root, sin escritura para este usuario |
| VirtualHost | `/etc/apache2/sites-enabled/000-default.conf`, puerto 80 |
| XAMPP | No detectado en `/opt` ni entre procesos activos |
| Tomcat | No instalado en APT ni en las rutas estándar inspeccionadas; sin proceso activo |
| Candidato APT | `tomcat10` 10.1.55-1ubuntu2~24.04.1; puede cambiar tras actualizar índices |
| Puertos | 80 ocupado por Apache; 8080 libre al inspeccionar |
| Herramientas | curl, git, rsync, apt-get, systemctl, ss y sudo disponibles |
| Permisos | Usuario `favio-coder`, grupos sudo y adm; `sudo -n true` exige contraseña |

Módulos obtenidos con `php -m` (CLI, no prueba del SAPI web):

```text
bcmath calendar Core ctype curl date dom exif FFI fileinfo filter ftp gettext
hash iconv intl json libxml mbstring mysqli mysqlnd openssl pcntl pcre PDO
pdo_mysql pdo_pgsql pdo_sqlite pgsql Phar posix random readline Reflection
session shmop SimpleXML sockets sodium SPL sqlite3 standard sysvmsg sysvsem
sysvshm tokenizer xml xmlreader xmlwriter xsl Zend OPcache zip zlib
```

Se consultó la documentación oficial de
[Apache en Ubuntu](https://documentation.ubuntu.com/server/how-to/web-services/install-apache2/)
y [despliegue Tomcat 10.1](https://tomcat.apache.org/tomcat-10.1-doc/appdev/deployment.html).
El catálogo web de paquetes Ubuntu devolvió HTTP 500; la disponibilidad del paquete
se confirmó con `apt-cache policy tomcat10` y `apt-cache show tomcat10` locales.
No se instalaron dependencias ni se modificaron servicios.

## 2. Autoría y restricción académica

**Generado por IA:** formularios, avisos estáticos, comentarios TODO, charset de
configuración, descriptor Jakarta Servlet 6.0 con bienvenida, esta guía,
`.gitignore` y lista de evidencias. Incluso los comandos de esta guía son ayuda
generada: ejecutarlos no los convierte en configuración escrita por ti.

**Debes escribir personalmente:** todas las decisiones y ramas del procesamiento,
validación, escape y sesión; tu procedimiento de despliegue justificado y las
configuraciones que tu rúbrica requiera; pruebas, evidencias y comparación.
No se certifica un 70 % mediante líneas ni por dejar comentarios. Contrasta esta
separación con tu docente y conserva tus cambios/explicaciones en commits. Si la
rúbrica exige más configuración propia, redáctala tú a partir de la documentación
sin agregar funcionalidades innecesarias ni cambiar servicios compartidos.

## 3. Instalación y despliegue que debes ejecutar

Trabaja desde la raíz indicada. En tu terminal:

```bash
cd /home/favio-coder/universidad/desarrolloWeb/sem9
export LAB="$PWD"
ss -ltnp '( sport = :80 or sport = :8080 )'
```

### PHP: reutilizar Apache existente

Apache ya está activo; si estuviera inactivo, arráncalo con
`sudo systemctl start apache2`. No hace falta instalar PHP, Apache o XAMPP.
Comprueba primero que el destino no contiene trabajo ajeno:

```bash
ls -ld /var/www/html
ls -ld /var/www/html/lab09-php
```

En el primer despliegue, el segundo comando debería indicar que no existe.
Si existe, inspecciónalo antes de continuar; estos comandos son solo para tu app.

```bash
sudo install -d -m 755 /var/www/html/lab09-php
sudo rsync -rt --chmod=D755,F644 "$LAB/lab09-php/" /var/www/html/lab09-php/
curl -i http://localhost/lab09-php/
curl -i http://localhost/lab09-php/procesar.php
```

El procesador inicial debe devolver HTML con «PHP ejecutó este esqueleto», sin
`<?php`, `echo` ni comentarios TODO en el cuerpo recibido. Así se verifica
ejecución por Apache; un HTTP 200 del formulario HTML por sí solo no la prueba.
No uses `file://` ni el servidor integrado de PHP como evidencia de Apache.

### JSP: instalar el paquete Tomcat 10.x de Noble

El JDK 21 ya existe. Si en otro momento faltase un JDK ≥ 17, el paquete propuesto
es `sudo apt-get install openjdk-21-jdk`; no lo necesitas ahora.
Con 8080 libre, ejecuta personalmente:

```bash
sudo apt-get update
apt-cache policy tomcat10
sudo apt-get install tomcat10
dpkg-query -W tomcat10 tomcat10-common
sudo systemctl start tomcat10
systemctl status tomcat10 --no-pager
systemctl show tomcat10 -p User -p Group
ps -eo user,pid,args | grep '[o]rg.apache.catalina.startup.Bootstrap'
```

El servicio del paquete debe ejecutar la JVM como usuario `tomcat`, **no root**.
Usar sudo para administrar systemd no implica arrancar la JVM como root.
No ejecutes `sudo catalina.sh`.

Rutas previstas del paquete (aún no existen; confírmalas después de instalar):

```bash
ls -ld /usr/share/tomcat10 /var/lib/tomcat10 /var/lib/tomcat10/webapps /etc/tomcat10
systemctl cat tomcat10
sudo less /etc/tomcat10/server.xml
```

Comprueba el Connector 8080 y `appBase="webapps"`. El `web.xml` generado usa
Servlet 6.0, compatible con el Tomcat **10.1** candidato, no con Tomcat 10.0
(Servlet 5.0). Verifica la versión instalada antes de desplegar. No hay imports
`javax.servlet`, JSTL ni bibliotecas externas.

```bash
ls -ld /var/lib/tomcat10/webapps/lab09-jsp
# Si no existe, crear; si existe, revisar primero que sea tu aplicación.
sudo install -d -m 755 /var/lib/tomcat10/webapps/lab09-jsp
sudo rsync -rt --chmod=D755,F644 "$LAB/lab09-jsp/" /var/lib/tomcat10/webapps/lab09-jsp/
curl -i http://localhost:8080/lab09-jsp/
curl -i http://localhost:8080/lab09-jsp/procesar.jsp
```

El despliegue automático puede tardar unos segundos. Al pedir ambas páginas,
Jasper debe compilarlas y responder HTML sin directivas JSP ni HTTP 500.
Comprueba los artefactos compilados y los logs:

```bash
sudo find /var/cache/tomcat10 /var/lib/tomcat10/work -type f -path '*lab09-jsp*' -name '*_jsp.class' 2>/dev/null
sudo journalctl -u tomcat10 -n 80 --no-pager
```

Una de esas rutas de trabajo puede ser un enlace o no existir: confirma el
`CATALINA_BASE` y su directorio `work` con la unidad instalada. Esta compilación
real queda pendiente; revisar XML no sustituye ejecutar Jasper.

### Puertos y publicación de cambios

URL previstas, sin cambio de puertos durante esta preparación:

- PHP: **http://localhost/lab09-php/**
- JSP: **http://localhost:8080/lab09-jsp/**

Si 8080 se ocupa antes de instalar, no detengas a su propietario. Comprueba que
8081 esté libre, respalda `/etc/tomcat10/server.xml` y edita manualmente solo
el Connector HTTP de tu Tomcat para usar 8081. En ese caso la URL será
**http://localhost:8081/lab09-jsp/**; registra el cambio y adapta los curl.
No cambies el puerto del Apache existente.

Edita siempre las carpetas originales del repositorio. Para redesplegar, respalda
tu copia desplegada fuera del DocumentRoot y repite los dos `rsync` anteriores:

```bash
ls -ld /var/backups
STAMP=$(date +%Y%m%d-%H%M%S)
sudo cp -a /var/www/html/lab09-php "/var/backups/lab09-php-$STAMP"
sudo cp -a /var/lib/tomcat10/webapps/lab09-jsp "/var/backups/lab09-jsp-$STAMP"
```

No se usa `--delete`. PHP se actualizará en la próxima petición; Tomcat normalmente
detecta JSP modificados. Si cambias el descriptor y necesitas reiniciar, hazlo
solo en la instancia del laboratorio, sin aplicaciones ajenas:
`sudo systemctl restart tomcat10`. Antes de cualquier edición de configuración
del sistema, copia el archivo con sufijo `.bak-fecha` y conserva el original.

## 4. Trabajo manual, en orden

1. Escribe tu explicación de rutas, usuarios, puertos, contexto y bienvenida;
   revisa la versión de Jakarta y ejecuta/verifica tu despliegue inicial.
2. PHP: carga `config.php`; verifica el método antes de cualquier salida. Para
   no POST, envía 405 con `Allow: POST` y finaliza esa rama.
3. Lee con `filter_input()`; distingue `null` y `false`, valida tipos antes de
   `trim()`, rechaza ausencias/vacíos y valida correo con `FILTER_VALIDATE_EMAIL`.
4. Elige y documenta 400 para datos inválidos. Para válidos, responde 200 y muestra
   nombre/correo con `htmlspecialchars()` y UTF-8. No confundas filtrar con escapar.
5. JSP: establece codificación de request antes del primer `getParameter()`;
   verifica POST, implementa 405 con Allow y termina la rama rechazada.
6. Obtén y valida parámetros (incluidos null y espacios). Define una comprobación
   razonable del correo y documenta su alcance; usa 400 para inválidos.
7. Guarda únicamente datos válidos con `session.setAttribute()`; comprueba la
   sesión con la misma cookie. Escribe escape para contexto de texto HTML antes
   de mostrar los valores, sin scriptlets extensos ni estado de usuario compartido.
8. Redespliega y prueba; documenta decisiones y resultados. No necesitas base de
   datos, CRUD, framework, JSTL o redirecciones para cumplir estos ejercicios.
9. Redacta tu tabla comparativa y toma tus evidencias; revisa la autoría con la rúbrica.

## 5. Pruebas manuales y curl

Primero abre ambas URL en navegador, envía datos ficticios y revisa Network.
Los avisos iniciales dan normalmente 200 incluso con entradas inválidas: **no
significa procesamiento correcto**. Las expectativas siguientes son para tu
implementación terminada, no para los esqueletos.

```bash
php -l lab09-php/config.php
php -l lab09-php/procesar.php
curl -i http://localhost/lab09-php/
curl -i http://localhost:8080/lab09-jsp/

for URL in http://localhost/lab09-php/procesar.php http://localhost:8080/lab09-jsp/procesar.jsp; do
  # GET al procesador: 405 y Allow: POST.
  curl -i "$URL"
  # POST válido: 200, caracteres UTF-8 correctos.
  curl -i --data-urlencode 'nombre=José Pérez' --data-urlencode 'correo=jose@example.com' "$URL"
  # Vacíos/espacios: 400 según el contrato propuesto.
  curl -i --data-urlencode 'nombre=   ' --data-urlencode 'correo=' "$URL"
  # Correo inválido: 400.
  curl -i --data-urlencode 'nombre=Ana' --data-urlencode 'correo=no-es-correo' "$URL"
  # Parámetros ausentes: 400, sin excepciones.
  curl -i -d '' "$URL"
  # Otro método: 405 y Allow: POST.
  curl -i -X PUT -d 'nombre=Ana&correo=ana@example.com' "$URL"
  # Escape: si se acepta como nombre, mostrar como texto, nunca como HTML.
  curl -i --data-urlencode 'nombre=<b>Ana & "Luz"</b>' --data-urlencode 'correo=ana@example.com' "$URL"
done
```

En JSP comprueba `JSESSIONID` en Network y reutiliza la cookie en otra petición.
Puedes usar `curl -c /tmp/lab09-cookies.txt` en el POST válido y después
`curl -b /tmp/lab09-cookies.txt`; comprueba el atributo con el depurador o tu salida
segura del ejercicio. No publiques el archivo de cookies. HTML `required` y
`type="email"` no sustituyen validación del servidor.

**302 solo se prueba si implementas una redirección.** En ese caso usa `curl -i`
sin `-L` para observar el estado y `Location`; después verifica el destino. No
añadas una redirección solo para producir una captura.

## 6. Logs y diagnóstico

Apache: rutas **confirmadas** `/var/log/apache2/access.log` y
`/var/log/apache2/error.log`. El usuario pertenece a adm y puede consultarlas:

```bash
less /var/log/apache2/access.log
less /var/log/apache2/error.log
tail -f /var/log/apache2/access.log /var/log/apache2/error.log
```

Tomcat aún no tiene logs reales en el equipo. Tras instalar el paquete, confirma
`/var/log/tomcat10` (normalmente destino del enlace `/var/lib/tomcat10/logs`):

```bash
ls -ld /var/lib/tomcat10/logs
sudo ls -l /var/log/tomcat10
sudo journalctl -u tomcat10 -n 100 --no-pager
sudo journalctl -u tomcat10 -f
sudo less /etc/tomcat10/server.xml
```

Consulta con `sudo less` el archivo fechado que exista, por ejemplo
`catalina.AAAA-MM-DD.log` o `localhost.AAAA-MM-DD.log`. El AccessLogValve de
`server.xml` determina el acceso HTTP: verifica `directory`, `prefix` y `suffix`
para localizar `localhost_access_log.AAAA-MM-DD.txt`. No presupongas
`catalina.out` en systemd. Si la Valve no está habilitada, documenta y configura
manualmente el registro de acceso con respaldo previo. No borres los logs.

### Registro de ayuda de IA (recomendaciones, no acciones manuales realizadas)

- IA: sudo solicita contraseña y DocumentRoot no es escribible → Solución manual: pendiente; ejecutar en tu terminal los comandos de publicación con sudo, manteniendo las fuentes en sem9.
- IA: Tomcat no está instalado y 8080 no responde → Solución manual: pendiente; instalar tomcat10 desde APT, comprobar usuario/puerto, desplegar y consultar journal.
- IA: Apache emite AH00558 por ausencia de ServerName global → Solución manual: no requiere corrección para este laboratorio, pues localhost responde; documentar el aviso y conservar la configuración existente.
- IA: la URL lab09-php devuelve 404 antes del despliegue → Solución manual: pendiente; copiar únicamente la carpeta del proyecto al DocumentRoot confirmado y repetir curl.
- IA: distinguir ciclos de PHP y JSP para la comparación → Solución manual: pendiente; consultar las fuentes siguientes y redactar tu explicación con observaciones propias.

Para nuevas ayudas usa siempre `IA: [problema] → Solución manual: [explicación]`;
señala si es propuesta o ejecutada, sin inventar capturas o resultados.

## 7. Investigación para tu tabla comparativa

Redacta tú las columnas PHP, JSP/Tomcat, fuente y observación experimental.
Estas preguntas son orientación, no una comparación resuelta:

| Tema | Preguntas que debes responder | Fuentes oficiales |
| --- | --- | --- |
| Ciclo de vida | ¿Qué ocurre en la primera petición y en las siguientes? ¿Cómo influyen SAPI, OPcache, traducción JSP, carga e inicialización? | [PHP uso](https://www.php.net/manual/es/features.php), [OPcache](https://www.php.net/manual/es/book.opcache.php), [Jasper](https://tomcat.apache.org/tomcat-10.1-doc/jasper-howto.html), [Jakarta Pages 3.1](https://jakarta.ee/specifications/pages/3.1/) |
| Memoria | ¿Qué vive por petición, proceso, hilo o sesión? ¿Qué puedes medir y qué no demuestra una medición aislada? | [Apache prefork](https://httpd.apache.org/docs/2.4/mod/prefork.html), [PHP memoria](https://www.php.net/manual/es/ini.core.php#ini.memory-limit), [Tomcat HTTP](https://tomcat.apache.org/tomcat-10.1-doc/config/http.html) |
| Sesiones | ¿Dónde se guarda el estado y cómo se relaciona con cookies, expiración y concurrencia? | [PHP sesiones](https://www.php.net/manual/es/book.session.php), [HttpSession](https://tomcat.apache.org/tomcat-10.1-doc/servletapi/jakarta/servlet/http/HttpSession.html) |
| Despliegue | ¿Qué papel tienen DocumentRoot, SAPI, contexto, webapps y web.xml? ¿Cómo llega un cambio al servidor? | [Apache](https://httpd.apache.org/docs/2.4/urlmapping.html), [Tomcat despliegue](https://tomcat.apache.org/tomcat-10.1-doc/appdev/deployment.html) |
| Escalabilidad | ¿Cómo afecta el estado de sesión a varias instancias? ¿Qué límites impiden concluir que una tecnología siempre escala mejor? | [PHP configuración de sesión](https://www.php.net/manual/es/session.configuration.php), [Tomcat clustering](https://tomcat.apache.org/tomcat-10.1-doc/cluster-howto.html) |

Para implementar: [filter_input](https://www.php.net/manual/es/function.filter-input.php),
[htmlspecialchars](https://www.php.net/manual/es/function.htmlspecialchars.php),
[ServletRequest](https://tomcat.apache.org/tomcat-10.1-doc/servletapi/jakarta/servlet/ServletRequest.html).

## 8. Verificaciones de esta preparación

- Ejecutadas: versiones de Linux/PHP/Java/Apache, módulos, paquetes, procesos,
  puertos, permisos, VirtualHost y rutas de logs de Apache.
- `php -l lab09-php/config.php` y `php -l lab09-php/procesar.php`: sin errores
  de sintaxis. Ejecución CLI del procesador: aviso estático correcto; esto no
  demuestra ejecución mediante Apache.
- `web.xml`: XML bien formado comprobado con SimpleXML, versión 6.0. No es
  validación contra el esquema ni prueba de compilación JSP.
- HTTP ejecutado: `http://localhost/` devolvió 200; `/lab09-php/` devolvió 404
  porque aún no está publicado; puerto 8080 rechazó la conexión.
- Pendiente: publicación con sudo, ejecución PHP mediante Apache para este
  proyecto, instalación de Tomcat, compilación JSP y HTTP de ambas aplicaciones.
- Pendiente: todas las pruebas de lógica, sesiones, escape, 405 y evidencias.

## 9. Subida personal a GitHub

No se inicializó Git ni se creó/publicó un remoto. Después de revisar los archivos,
crea tú un repositorio vacío en GitHub (sin README remoto) y ejecuta:

```bash
cd /home/favio-coder/universidad/desarrolloWeb/sem9
git init -b main
git status
git add .gitignore README.md lab09-php lab09-jsp evidencias
git diff --cached
git commit -m "Añade esqueleto del laboratorio 09"
# Sustituye TU_USUARIO y TU_REPOSITORIO por los valores reales.
git remote add origin https://github.com/TU_USUARIO/TU_REPOSITORIO.git
git push -u origin main
```

Haz commits posteriores de tus implementaciones y evidencias reales. Revisa cada
diff; autentícate mediante el mecanismo de GitHub configurado, sin guardar tokens
en los archivos ni en la URL del remoto.
