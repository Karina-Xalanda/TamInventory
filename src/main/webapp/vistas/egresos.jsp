<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>TAMinventary - Gastos y Mermas</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
    .contenedor { display: flex; gap: 20px; max-width: 900px; margin: auto; }
    .tarjeta { background: white; padding: 2rem; border-radius: 8px; flex: 1; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    h2 { text-align: center; }
    .titulo-gasto { color: #c0392b; }
    .titulo-merma { color: #d35400; }
    .grupo { margin-bottom: 15px; }
    label { display: block; font-weight: bold; margin-bottom: 5px; }
    input, select { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
    button { width: 100%; padding: 12px; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; margin-top: 10px; }
    .btn-gasto { background: #c0392b; }
    .btn-merma { background: #d35400; }
    .btn-volver { background: #95a5a6; margin-top: 20px; width: 100%; padding: 12px; border: none; border-radius: 4px; color: white; cursor: pointer;}
    .mensaje { text-align: center; font-weight: bold; color: green; }
  </style>
</head>
<body>
<h1 style="text-align: center; color: #333;">Registro de Egresos Diarios</h1>

<% if (request.getParameter("exito") != null) { %>
<p class="mensaje">¡Registro guardado exitosamente en la nube!</p>
<% } %>

<div class="contenedor">
  <div class="tarjeta">
    <h2 class="titulo-gasto"> Registrar Gasto</h2>
    <form action="${pageContext.request.contextPath}/egresos" method="POST">
      <input type="hidden" name="tipoOperacion" value="gasto">

      <div class="grupo">
        <label>Tipo de Gasto:</label>
        <select name="tipo" required>
          <option value="INSUMO">Compra de Insumo (Urgencia)</option>
          <option value="SALARIO">Pago de Salario / Trabajador</option>
          <option value="SERVICIOS">Pago de Servicios (Gas, Luz)</option>
        </select>
      </div>
      <div class="grupo">
        <label>Descripción corta:</label>
        <input type="text" name="descripcion" placeholder="Ej. 2kg extra de masa" required>
      </div>
      <div class="grupo">
        <label>Monto pagado ($):</label>
        <input type="number" step="0.5" name="monto" required>
      </div>
      <button type="submit" class="btn-gasto">Guardar Gasto</button>
    </form>
  </div>

  <div class="tarjeta">
    <h2 class="titulo-merma"> Registrar Merma (Tamales)</h2>
    <form action="${pageContext.request.contextPath}/egresos" method="POST">
      <input type="hidden" name="tipoOperacion" value="merma">

      <div class="grupo">
        <label>Tipo de Merma:</label>
        <select name="tipo" required>
          <option value="COMIDO">Comido por personal</option>
          <option value="FIADO">Fiado (No pagado hoy)</option>
          <option value="SOBRANTE">Sobrante (Dañado/No vendible)</option>
        </select>
      </div>
      <div class="grupo">
        <label>Descripción / Justificación:</label>
        <input type="text" name="descripcion" placeholder="Ej. Tamales de elote rotos" required>
      </div>
      <div class="grupo">
        <label>Cantidad de Tamales:</label>
        <input type="number" name="cantidadMerma" required>
      </div>
      <button type="submit" class="btn-merma">Guardar Merma</button>
    </form>
  </div>
</div>

<div style="max-width: 900px; margin: auto;">
  <button type="button" class="btn-volver" onclick="location.href='${pageContext.request.contextPath}/vistas/menu.jsp'">Volver al Menú Principal</button>
</div>
</body>
</html>