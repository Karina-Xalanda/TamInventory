<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="modelos.Insumo" %>
<!DOCTYPE html>
<html>
<head>
  <title>TAMinventary - Gestión de Insumos</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
    .contenedor { background: white; padding: 2rem; border-radius: 8px; max-width: 800px; margin: auto; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    h2 { color: #27ae60; text-align: center; }
    table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
    th { background-color: #27ae60; color: white; }
    .formulario-agregar { background: #e8f8f5; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
    input[type="text"], input[type="number"] { padding: 8px; margin-right: 10px; border: 1px solid #ccc; border-radius: 4px; }
    button { padding: 8px 15px; background: #27ae60; color: white; border: none; border-radius: 4px; cursor: pointer; }
    button:hover { background: #1e8449; }
    .btn-volver { background: #95a5a6; margin-top: 20px; width: 100%; }
    .btn-actualizar { background: #f39c12; padding: 5px 10px; font-size: 12px; }
    .alerta-stock { color: red; font-weight: bold; }
  </style>
</head>
<body>
<div class="contenedor">
  <h2> Gestión de Insumos y Materia Prima</h2>

  <div class="formulario-agregar">
    <h3>Registrar Nuevo Insumo</h3>
    <form action="${pageContext.request.contextPath}/insumos" method="POST">
      <input type="hidden" name="accion" value="agregar">
      <input type="text" name="nombre" placeholder="Ej. Masa, Hojas de plátano, Pollo..." required>
      <input type="number" name="cantidad" step="0.5" placeholder="Cant. (kg o paq)" required>
      <button type="submit"> Agregar Insumo</button>
    </form>
  </div>

  <h3>Inventario Actual</h3>
  <table>
    <thead>
    <tr>
      <th>Nombre</th>
      <th>Cantidad Disponible</th>
      <th>Acción (Actualizar Stock)</th>
    </tr>
    </thead>
    <tbody>
    <%
      List<Insumo> lista = (List<Insumo>) request.getAttribute("insumos");
      if (lista != null && !lista.isEmpty()) {
        for (Insumo i : lista) {
    %>
    <tr>
      <td><%= i.getNombre() %></td>
      <td>
        <% if(i.getCantidad() < 5.0) { %>
        <span class="alerta-stock"> <%= i.getCantidad() %> (¡Bajo!)</span>
        <% } else { %>
        <%= i.getCantidad() %>
        <% } %>
      </td>
      <td>
        <form action="${pageContext.request.contextPath}/insumos" method="POST" style="display:inline;">
          <input type="hidden" name="accion" value="actualizar">
          <input type="hidden" name="id" value="<%= i.getId() %>">
          <input type="number" name="nuevaCantidad" step="0.5" value="<%= i.getCantidad() %>" style="width: 80px;" required>
          <button type="submit" class="btn-actualizar">Guardar</button>
        </form>
      </td>
    </tr>
    <%
      }
    } else {
    %>
    <tr>
      <td colspan="3" style="text-align:center;">No hay insumos registrados en la nube. ¡Agrega el primero!</td>
    </tr>
    <%  } %>
    </tbody>
  </table>

  <button type="button" class="btn-volver" onclick="location.href='${pageContext.request.contextPath}/vistas/menu.jsp'">Volver al Menú</button>
</div>
</body>
</html>