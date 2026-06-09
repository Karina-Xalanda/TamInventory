<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, modelos.Insumo" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TAMinventory - Gestion de Insumos</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6f8; }

    /* navbar igual al resto del sistema */
    .top-nav {
      background: #1a1a2e;
      color: white;
      padding: 12px 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .nav-logo { display: flex; align-items: center; gap: 10px; }
    .nav-logo img { height: 36px; }
    .nav-logo span { font-size: 1.2rem; font-weight: 700; letter-spacing: 1px; }
    .nav-btn {
      background: #b8962e;
      color: white;
      border: none;
      padding: 8px 16px;
      border-radius: 6px;
      cursor: pointer;
      font-weight: 600;
      text-decoration: none;
      font-size: 0.85rem;
    }
    .nav-btn:hover { background: #9a7a22; }

    .contenedor { max-width: 860px; margin: 24px auto; padding: 0 16px; }

    .titulo-modulo {
      font-size: 1.2rem;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 1px;
      color: #1a1a2e;
      margin-bottom: 20px;
    }

    /* alertas */
    .alerta {
      padding: 12px 16px;
      border-radius: 8px;
      font-size: 0.9rem;
      font-weight: 600;
      margin-bottom: 16px;
    }
    .alerta-ok    { background: #d5f5e3; color: #1e8449; }
    .alerta-error { background: #fdecea; color: #c0392b; }

    /* tarjeta de formulario para agregar */
    .tarjeta {
      background: white;
      border-radius: 10px;
      padding: 22px 24px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
      margin-bottom: 20px;
    }

    .tarjeta-titulo {
      font-size: 0.85rem;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 1px;
      color: #27ae60;
      margin-bottom: 16px;
      padding-bottom: 10px;
      border-bottom: 3px solid #27ae60;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    /* fila del formulario agregar */
    .form-agregar {
      display: flex;
      gap: 12px;
      align-items: flex-end;
      flex-wrap: wrap;
    }
    .campo-grupo { display: flex; flex-direction: column; gap: 5px; flex: 1; min-width: 180px; }
    .campo-grupo label {
      font-size: 0.82rem;
      font-weight: 600;
      color: #555;
    }
    .campo-grupo input {
      padding: 9px 12px;
      border: 1px solid #ddd;
      border-radius: 8px;
      font-size: 0.9rem;
      color: #333;
      transition: border-color 0.2s;
      width: 100%;
    }
    .campo-grupo input:focus { outline: none; border-color: #27ae60; }

    .btn-agregar {
      padding: 10px 22px;
      background: #27ae60;
      color: white;
      border: none;
      border-radius: 8px;
      font-weight: 700;
      font-size: 0.9rem;
      cursor: pointer;
      white-space: nowrap;
      align-self: flex-end;
    }
    .btn-agregar:hover { background: #219653; }

    /* tabla de insumos */
    .tabla-wrap { overflow-x: auto; }
    table { width: 100%; border-collapse: collapse; font-size: 0.88rem; }
    th {
      text-align: left;
      padding: 10px 14px;
      background: #f8f9fa;
      color: #888;
      font-weight: 700;
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    td { padding: 12px 14px; border-bottom: 1px solid #f0f0f0; color: #333; vertical-align: middle; }
    tr:last-child td { border-bottom: none; }
    tr:hover td { background: #fafafa; }

    /* badge de estado */
    .badge-estado {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      padding: 3px 10px;
      border-radius: 10px;
      font-size: 0.75rem;
      font-weight: 700;
    }
    .badge-ok    { background: #d5f5e3; color: #1e8449; }
    .badge-bajo  { background: #fef3e2; color: #d35400; }
    .badge-critico { background: #fdecea; color: #c0392b; }

    /* cantidad resaltada en rojo si es critica */
    .cant-critica { color: #e74c3c; font-weight: 800; }
    .cant-bajo    { color: #e67e22; font-weight: 700; }
    .cant-ok      { color: #1a1a2e; font-weight: 600; }

    /* form de actualizacion inline */
    .form-actualizar { display: flex; align-items: center; gap: 8px; }
    .form-actualizar input {
      width: 90px;
      padding: 7px 10px;
      border: 1px solid #ddd;
      border-radius: 8px;
      font-size: 0.9rem;
      font-weight: 700;
      text-align: center;
      transition: border-color 0.2s;
    }
    .form-actualizar input:focus { outline: none; border-color: #27ae60; }
    .btn-guardar {
      padding: 7px 14px;
      background: #b8962e;
      color: white;
      border: none;
      border-radius: 8px;
      font-size: 0.82rem;
      font-weight: 700;
      cursor: pointer;
    }
    .btn-guardar:hover { background: #9a7a22; }

    /* fila sin datos */
    .sin-datos { text-align: center; color: #bbb; padding: 28px; font-size: 0.9rem; }

    /* resumen de alertas arriba de la tabla */
    .resumen-alertas {
      display: flex;
      gap: 12px;
      margin-bottom: 16px;
      flex-wrap: wrap;
    }
    .chip-alerta {
      display: flex;
      align-items: center;
      gap: 6px;
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 700;
    }
    .chip-critico { background: #fdecea; color: #c0392b; }
    .chip-bajo    { background: #fef3e2; color: #d35400; }
    .chip-ok      { background: #d5f5e3; color: #1e8449; }

    @media (max-width: 600px) {
      .form-agregar { flex-direction: column; }
      .btn-agregar  { width: 100%; }
    }
  </style>
</head>
<body>

<%
  List<Insumo> lista = (List<Insumo>) request.getAttribute("insumos");

  // contar insumos por estado para el resumen
  int totalCriticos = 0, totalBajos = 0, totalOk = 0;
  if (lista != null) {
    for (Insumo i : lista) {
      if      (i.getCantidad() < 2.0)  totalCriticos++;
      else if (i.getCantidad() < 5.0)  totalBajos++;
      else                              totalOk++;
    }
  }
%>

<nav class="top-nav">
  <div class="nav-logo">
    <img src="${pageContext.request.contextPath}/imagenes/LogoV.png" alt="TAMinventory">
    <span>TAMinventory</span>
  </div>
  <a class="nav-btn" href="${pageContext.request.contextPath}/menu">Menu Principal</a>
</nav>

<div class="contenedor">

  <h2 class="titulo-modulo">Modulo: Gestion de Insumos</h2>

  <%-- alertas de resultado --%>
  <% if ("1".equals(request.getParameter("exito"))) { %>
  <div class="alerta alerta-ok">Insumo guardado correctamente.</div>
  <% } else if ("1".equals(request.getParameter("error"))) { %>
  <div class="alerta alerta-error">Ocurrio un error. Verifica los datos e intenta de nuevo.</div>
  <% } %>

  <%-- tarjeta: registrar nuevo insumo --%>
  <div class="tarjeta">
    <div class="tarjeta-titulo">
      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
        <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
      </svg>
      Registrar Nuevo Insumo
    </div>
    <form action="${pageContext.request.contextPath}/insumos" method="POST" class="form-agregar">
      <input type="hidden" name="accion" value="agregar">
      <div class="campo-grupo">
        <label>Nombre del insumo</label>
        <input type="text" name="nombre" placeholder="Ej. Masa, Hojas de platano, Pollo..." required>
      </div>
      <div class="campo-grupo" style="max-width:160px;">
        <label>Cantidad (kg o paq)</label>
        <input type="number" name="cantidad" step="0.5" min="0" placeholder="0.0" required>
      </div>
      <button type="submit" class="btn-agregar">Agregar Insumo</button>
    </form>
  </div>

  <%-- tarjeta: inventario actual --%>
  <div class="tarjeta">
    <div class="tarjeta-titulo" style="color:#1a1a2e; border-color:#1a1a2e;">
      <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
        <path d="M9 17H7A5 5 0 0 1 7 7h2"/><path d="M15 7h2a5 5 0 0 1 0 10h-2"/>
        <line x1="8" y1="12" x2="16" y2="12"/>
      </svg>
      Inventario Actual de Insumos
    </div>

    <%-- resumen de estados --%>
    <div class="resumen-alertas">
      <% if (totalCriticos > 0) { %>
      <div class="chip-alerta chip-critico">
        <svg width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
          <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
        </svg>
        <%= totalCriticos %> critico<%= totalCriticos > 1 ? "s" : "" %>
      </div>
      <% } %>
      <% if (totalBajos > 0) { %>
      <div class="chip-alerta chip-bajo">
        <svg width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
          <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
        </svg>
        <%= totalBajos %> bajo<%= totalBajos > 1 ? "s" : "" %>
      </div>
      <% } %>
      <% if (totalOk > 0) { %>
      <div class="chip-alerta chip-ok">
        <svg width="12" height="12" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
          <polyline points="20 6 9 17 4 12"/>
        </svg>
        <%= totalOk %> en nivel optimo
      </div>
      <% } %>
    </div>

    <div class="tabla-wrap">
      <table>
        <thead>
        <tr>
          <th>Nombre del Insumo</th>
          <th>Cantidad Disponible</th>
          <th>Estado</th>
          <th>Actualizar Stock</th>
        </tr>
        </thead>
        <tbody>
        <% if (lista == null || lista.isEmpty()) { %>
        <tr><td colspan="4" class="sin-datos">No hay insumos registrados. Agrega el primero.</td></tr>
        <% } else {
          for (Insumo i : lista) {
            boolean critico = i.getCantidad() < 2.0;
            boolean bajo    = !critico && i.getCantidad() < 5.0;
            String claseQty = critico ? "cant-critica" : (bajo ? "cant-bajo" : "cant-ok");
            String badgeClase = critico ? "badge-critico" : (bajo ? "badge-bajo" : "badge-ok");
            String badgeLabel = critico ? "Critico" : (bajo ? "Bajo Stock" : "Optimo");
        %>
        <tr>
          <td><strong><%= i.getNombre() %></strong></td>
          <td class="<%= claseQty %>"><%= i.getCantidad() %> uds.</td>
          <td>
              <span class="badge-estado <%= badgeClase %>">
                <% if (critico) { %>
                  <svg width="10" height="10" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
                  </svg>
                <% } else if (bajo) { %>
                  <svg width="10" height="10" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
                    <circle cx="12" cy="12" r="10"/>
                  </svg>
                <% } else { %>
                  <svg width="10" height="10" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
                    <polyline points="20 6 9 17 4 12"/>
                  </svg>
                <% } %>
                <%= badgeLabel %>
              </span>
          </td>
          <td>
            <form action="${pageContext.request.contextPath}/insumos" method="POST"
                  class="form-actualizar">
              <input type="hidden" name="accion" value="actualizar">
              <input type="hidden" name="id" value="<%= i.getId() %>">
              <input type="number" name="nuevaCantidad" step="0.5" min="0"
                     value="<%= i.getCantidad() %>" required>
              <button type="submit" class="btn-guardar">Guardar</button>
            </form>
          </td>
        </tr>
        <% } } %>
        </tbody>
      </table>
    </div>
  </div>

</div>

</body>
</html>