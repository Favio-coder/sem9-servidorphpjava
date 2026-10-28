<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="styles.css">
  <title>Laboratorio 09 — JSP</title>
</head>
<body>
  <header class="topbar"><a class="brand" href="index.jsp"><span class="logo">09</span> Web Lab <span class="edition">/ JAVA</span></a><span class="tag">Desarrollo web · Laboratorio 09</span></header>
  <main class="layout">
    <section class="intro">
      <span class="eyebrow">EXPLORA EL LADO DEL SERVIDOR</span>
      <h1>Pequeños datos.<br>Grandes <em>primeros pasos.</em></h1>
      <p class="lead">Conecta tu formulario con Java. Explora cómo Tomcat transforma una página JSP en una respuesta para el navegador.</p>
      <div class="flow" aria-label="Flujo de la petición"><span>01 · Formulario</span><span aria-hidden="true">→</span><span>02 · POST</span><span aria-hidden="true">→</span><span>03 · JSP</span></div>
      <div class="tech"><span class="tech-icon">J</span><div><strong>Java + Apache Tomcat</strong><p>Una experiencia con Jakarta Server Pages</p></div></div>
      <p class="note">Tu reto: validar, gestionar la sesión y mostrar una salida segura.</p>
    </section>
    <section class="card" aria-labelledby="form-title">
      <div class="card-top"><span class="eyebrow">PRUEBA TU CONEXIÓN</span><span class="pill">JSP</span></div>
      <h2 id="form-title">Empecemos por ti</h2>
      <p class="muted">Completa los campos para enviar una petición al servidor.</p>
      <form method="post" action="procesar.jsp" accept-charset="UTF-8">
        <label for="nombre">Nombre completo</label>
        <input id="nombre" type="text" name="nombre" autocomplete="name" placeholder="Ej. Ana Torres" required>
        <label for="correo">Correo electrónico</label>
        <input id="correo" type="email" name="correo" autocomplete="email" placeholder="ana@example.com" aria-describedby="email-help" required>
        <small id="email-help">Usa datos ficticios para las pruebas del laboratorio.</small>
        <button type="submit">Enviar a Tomcat <span aria-hidden="true">↗</span></button>
      </form>
      <div class="notice"><strong>En construcción</strong><p>El formulario envía datos; la validación y el procesamiento aún deben implementarse manualmente.</p></div>
    </section>
  </main>
  <footer><span>LAB 09 <span aria-hidden="true">/</span> Aprende construyendo.</span><span>HTML · CSS · JAVA</span></footer>
</body>
</html>
