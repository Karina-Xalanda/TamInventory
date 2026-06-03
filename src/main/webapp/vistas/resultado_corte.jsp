<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Resultado del Corte</title>
  <style>
    .ok { color: green; font-weight: bold; }
    .error { color: red; font-weight: bold; }
  </style>
</head>
<body>
<h2>Resumen del Corte</h2>
<p>Efectivo Esperado: $ ${corte.efectivoEsperado}</p>
<p>Efectivo Real: $ ${corte.efectivoReal}</p>
<hr>
<p>Diferencia:
  <span class="${diferencia < 0 ? 'error' : 'ok'}">
            $ ${diferencia}
        </span>
</p>
<a href="${pageContext.request.contextPath}/vistas/menu.jsp">Volver al Menú</a>
</body>
</html>