<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%--
TODO personal, antes de producir la respuesta:
1. Fijar UTF-8 en request antes de leer cualquier parámetro.
2. Validar el método HTTP; para métodos distintos de POST enviar
   405 y Allow: POST, y terminar el procesamiento.
3. Obtener nombre y correo mediante request.getParameter().
4. Validar null, espacios/campos vacíos y formato del correo.
5. Guardar los datos válidos mediante session.setAttribute().
6. Escapar los valores para texto HTML antes de mostrarlos; incluir
   &, <, >, comillas dobles y simples. EL por sí sola no escapa HTML.
7. Responder 200 para datos válidos y un estado de error para inválidos.
Mantener el código breve; no usar campos de instancia para datos de usuarios.
--%>
<!doctype html>
<html lang="es">
<head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><link rel="stylesheet" href="styles.css"><title>JSP pendiente</title></head>
<body>
  <main class="card result">
  <span class="eyebrow">LAB 09 / JAVA</span>
  <h1>Un paso más.</h1><h2>Procesamiento pendiente</h2>
  <p>Debes completar los TODO personalmente. Esta página todavía no lee,
     valida ni guarda los datos enviados.</p>
  <a class="back" href="index.jsp">Volver al formulario <span aria-hidden="true">↗</span></a>
  </main>
</body>
</html>
