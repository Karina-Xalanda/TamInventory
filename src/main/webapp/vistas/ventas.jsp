<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>TAMinventary - Registro de Ventas</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
    .caja-venta { background: white; padding: 2rem; border-radius: 8px; max-width: 500px; margin: auto; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    h2 { color: #e67e22; text-align: center; }
    .grupo { margin-bottom: 15px; }
    label { display: block; font-weight: bold; margin-bottom: 5px; }
    input, select { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
    button { width: 100%; padding: 12px; background: #e67e22; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; margin-top: 10px; }
    button:hover { background: #d35400; }
    .btn-volver { background: #95a5a6; margin-top: 10px; }
  </style>
</head>
<body>
<div class="caja-venta">
  <h2>Registrar Venta del Día</h2>
  <form action="${pageContext.request.contextPath}/venta" method="POST">

    <div class="grupo">
      <label>Total de Tamales Vendidos hoy:</label>
      <input type="number" name="cantidadTamales" required min="1">
    </div>

    <div class="grupo">
      <label>Precio Unitario Promedio (Ej. 20.00):</label>
      <input type="number" step="0.50" name="precioUnitario" required>
    </div>

    <input type="hidden" name="idProducto" value="TAMAL_GENERAL">

    <button type="submit">Guardar Venta</button>
    <button type="button" class="btn-volver" onclick="location.href='${pageContext.request.contextPath}/vistas/menu.jsp'">Volver al Menú</button>
  </form>
</div>
</body>
</html>