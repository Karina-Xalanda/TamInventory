<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="modelos.Insumo" %>
<%@ page import="org.bson.Document" %>
<!DOCTYPE html>
<html>
<head>
  <title>TAMinventary - Panel de Reportes</title>
  <style>
    body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
    .contenedor { max-width: 900px; margin: auto; }
    .tarjeta { background: white; padding: 2rem; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    h2 { color: #8e44ad; border-bottom: 2px solid #8e44ad; padding-bottom: 10px; }
    .alerta { color: #c0392b; font-weight: bold; }
    .saludable { color: #27ae60; font-weight: bold; }
    .btn-volver { background: #95a5a6; width: 100%; padding: 12px; border: none; border-radius: 4px; color: white; cursor: pointer; font-size: 16px; }
    table { width: 100%; border-collapse: collapse; margin-top: 15px; }
    th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
    th { background-color: #8e44ad; color: white; }
  </style>
</head>
<body>
<div class="contenedor">
  <h1 style="text-align: center; color: #333;"> Panel de Analítica Estratégica</h1>

  <div class="tarjeta">
    <h2> Producto Estrella (Más Vendido)</h2>

    <table>
      <thead>
      <tr>
        <th>Producto (ID)</th>
        <th>Total de Unidades Vendidas</th>
      </tr>
      </thead>
      <tbody>
      <%
        List<Document> topTamales = (List<Document>) request.getAttribute("topTamales");
        if (topTamales != null && !topTamales.isEmpty()) {
          for (Document doc : topTamales) {
      %>
      <tr>
        <td><%= doc.getString("_id") %></td>
        <td><strong><%= doc.getInteger("totalVendido") %></strong> unidades</td>
      </tr>
      <%      }
      } else { %>
      <tr>
        <td colspan="2">Aún no hay ventas registradas para generar este reporte.</td>
      </tr>
      <%  } %>
      </tbody>
    </table>
  </div>

  <div class="tarjeta">
    <h2 class="alerta"> Alertas Críticas de Inventario</h2>
    <p>Insumos que cayeron por debajo de 5.0 unidades (Requieren reabastecimiento urgente).</p>
    <ul>
      <%
        List<Insumo> criticos = (List<Insumo>) request.getAttribute("criticos");
        if (criticos != null && !criticos.isEmpty()) {
          for (Insumo i : criticos) {
      %>
      <li class="alerta">Falta <%= i.getNombre() %> (Solo quedan <%= i.getCantidad() %>)</li>
      <%      }
      } else { %>
      <li class="saludable">¡Excelente! El inventario está saludable. Ningún insumo está en nivel crítico.</li>
      <%  } %>
    </ul>
  </div>

  <button type="button" class="btn-volver" onclick="location.href='${pageContext.request.contextPath}/vistas/menu.jsp'">Volver al Menú Principal</button>
</div>
</body>
</html>
