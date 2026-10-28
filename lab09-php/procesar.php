<?php
/*
 * TODO personal, antes de emitir contenido:
 * 1. Cargar config.php y usar su charset.
 * 2. Comprobar el método HTTP; si no es POST, responder 405,
 *    enviar Allow: POST y terminar la ejecución.
 * 3. Leer nombre y correo con filter_input(INPUT_POST, ...).
 *    Distinguir valores ausentes, inválidos y cadenas vacías tras trim().
 * 4. Validar el correo con FILTER_VALIDATE_EMAIL y rechazar campos inválidos.
 * 5. Escapar cada valor mostrado con htmlspecialchars(), incluyendo
 *    ENT_QUOTES | ENT_SUBSTITUTE y el charset configurado.
 * 6. Responder HTTP 200 solo en el camino de procesamiento válido.
 * No se requiere persistencia. No usar register_globals.
 */
echo '<!doctype html><html lang="es"><head><meta charset="UTF-8">'
    . '<meta name="viewport" content="width=device-width, initial-scale=1">'
    . '<link rel="stylesheet" href="styles.css"><title>PHP pendiente</title></head>'
    . '<body><main class="card result"><span class="eyebrow">LAB 09 / PHP</span><h1>Un paso más.</h1><h2>Procesamiento pendiente</h2>'
    . '<p>PHP ejecutó este esqueleto. Debes completar los TODO personalmente; '
    . 'todavía no se leen ni validan los datos enviados.</p>'
    . '<a class="back" href="index.html">Volver al formulario <span aria-hidden="true">↗</span></a></main></body></html>';
