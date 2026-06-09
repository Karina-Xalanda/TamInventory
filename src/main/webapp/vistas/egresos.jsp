<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, modelos.Producto, modelos.Gasto, modelos.Merma" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TAMinventory - Gastos y Mermas</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6f8; }

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

    .contenedor {
      max-width: 980px;
      margin: 24px auto;
      padding: 0 16px;
    }

    .titulo-modulo {
      font-size: 1.2rem;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 1px;
      margin-bottom: 20px;
      color: #1a1a2e;
    }

    .alerta {
      padding: 12px 16px;
      border-radius: 8px;
      font-size: 0.9rem;
      font-weight: 600;
      margin-bottom: 16px;
    }
    .alerta-ok    { background: #d5f5e3; color: #1e8449; }
    .alerta-error { background: #fdecea; color: #c0392b; }

    .grid-forms {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
      margin-bottom: 24px;
    }

    .tarjeta {
      background: white;
      border-radius: 10px;
      padding: 22px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    }

    .tarjeta-titulo {
      font-size: 0.85rem;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 1px;
      margin-bottom: 18px;
      padding-bottom: 10px;
      border-bottom: 3px solid;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .titulo-gasto { border-color: #e74c3c; color: #e74c3c; }
    .titulo-merma { border-color: #e67e22; color: #e67e22; }

    .campo-grupo { margin-bottom: 14px; }
    .campo-grupo label {
      display: block;
      font-size: 0.82rem;
      font-weight: 600;
      color: #555;
      margin-bottom: 5px;
    }
    .campo-grupo input,
    .campo-grupo select {
      width: 100%;
      padding: 9px 12px;
      border: 1px solid #ddd;
      border-radius: 8px;
      font-size: 0.9rem;
      color: #333;
      transition: border-color 0.2s;
    }
    .campo-grupo input:focus,
    .campo-grupo select:focus {
      outline: none;
      border-color: #b8962e;
    }

    /* aviso de stock disponible debajo del selector de producto */
    .stock-info {
      font-size: 0.8rem;
      margin-top: 5px;
      font-weight: 600;
      min-height: 1.1em;
    }
    .stock-ok      { color: #27ae60; }
    .stock-bajo    { color: #f39c12; }
    .stock-agotado { color: #e74c3c; }

    .btn-form {
      width: 100%;
      padding: 11px;
      color: white;
      border: none;
      border-radius: 8px;
      font-size: 0.95rem;
      font-weight: 700;
      cursor: pointer;
      margin-top: 4px;
    }
    .btn-gasto       { background: #e74c3c; }
    .btn-gasto:hover { background: #c0392b; }
    .btn-merma       { background: #e67e22; }
    .btn-merma:hover { background: #ca6f1e; }

    .tarjeta-tabla {
      background: white;
      border-radius: 10px;
      padding: 22px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
      margin-bottom: 20px;
    }
    .tabla-titulo {
      font-size: 0.85rem;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 1px;
      color: #555;
      margin-bottom: 14px;
    }
    table { width: 100%; border-collapse: collapse; font-size: 0.85rem; }
    th {
      text-align: left;
      padding: 8px 10px;
      background: #f8f9fa;
      color: #888;
      font-weight: 700;
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    td { padding: 10px; border-bottom: 1px solid #f0f0f0; color: #333; }
    tr:last-child td { border-bottom: none; }
    .sin-registros { text-align: center; color: #bbb; padding: 20px; font-size: 0.9rem; }

    .badge {
      padding: 3px 9px;
      border-radius: 10px;
      font-size: 0.75rem;
      font-weight: 700;
      color: white;
    }
    .badge-insumo    { background: #3b82f6; }
    .badge-salario   { background: #8e44ad; }
    .badge-servicios { background: #16a085; }
    .badge-comido    { background: #e67e22; }
    .badge-fiado     { background: #f39c12; }
    .badge-sobrante  { background: #95a5a6; }

    @media (max-width: 640px) {
      .grid-forms { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>

<%
  List<Producto> productos = (List<Producto>) request.getAttribute("productos");
  List<Gasto>    gastosHoy = (List<Gasto>)    request.getAttribute("gastosHoy");
  List<Merma>    mermasHoy = (List<Merma>)    request.getAttribute("mermasHoy");
  String         paramError = request.getParameter("error");
%>

<nav class="top-nav">
  <div class="nav-logo">
    <img src="${pageContext.request.contextPath}/imagenes/LogoV.png" alt="TAMinventory">
    <span>TAMinventory</span>
  </div>
  <a class="nav-btn" href="${pageContext.request.contextPath}/menu">Menu Principal</a>
</nav>

<div class="contenedor">

  <h2 class="titulo-modulo">Modulo 3: Gastos y Mermas</h2>

  <%-- mensajes de resultado --%>
  <% if ("1".equals(request.getParameter("exito"))) { %>
  <div class="alerta alerta-ok">Registro guardado correctamente.</div>
  <% } else if ("sinstock".equals(paramError)) { %>
  <div class="alerta alerta-error">
    No hay stock registrado para ese producto hoy. Abre el dia primero desde el modulo de Ventas.
  </div>
  <% } else if ("excede".equals(paramError)) { %>
  <div class="alerta alerta-error">
    La cantidad de merma ingresada supera el stock disponible de ese producto hoy.
  </div>
  <% } else if ("1".equals(paramError)) { %>
  <div class="alerta alerta-error">Ocurrio un error al guardar. Intenta de nuevo.</div>
  <% } %>

  <div class="grid-forms">

    <%-- formulario gastos --%>
    <div class="tarjeta">
      <div class="tarjeta-titulo titulo-gasto">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
          <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
        </svg>
        Registrar Gasto
      </div>
      <form action="${pageContext.request.contextPath}/egresos" method="POST">
        <input type="hidden" name="tipoOperacion" value="gasto">
        <div class="campo-grupo">
          <label>Tipo de Gasto</label>
          <select name="tipo" required>
            <option value="INSUMO">Compra de Insumo</option>
            <option value="SALARIO">Pago de Salario</option>
            <option value="SERVICIOS">Servicios (Gas, Luz)</option>
          </select>
        </div>
        <div class="campo-grupo">
          <label>Descripcion</label>
          <input type="text" name="descripcion" placeholder="Ej. 2kg extra de masa" required>
        </div>
        <div class="campo-grupo">
          <label>Monto ($)</label>
          <input type="number" step="0.50" min="0" name="monto" required>
        </div>
        <button type="submit" class="btn-form btn-gasto">Guardar Gasto</button>
      </form>
    </div>

    <%-- formulario mermas --%>
    <div class="tarjeta">
      <div class="tarjeta-titulo titulo-merma">
        <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
          <polyline points="3 6 5 6 21 6"/>
          <path d="M19 6l-1 14H6L5 6"/>
          <path d="M10 11v6M14 11v6"/>
        </svg>
        Registrar Merma
      </div>
      <form action="${pageContext.request.contextPath}/egresos" method="POST">
        <input type="hidden" name="tipoOperacion" value="merma">

        <div class="campo-grupo">
          <label>Producto</label>
          <%-- stocksDisponibles viene como atributo JSON para el JS --%>
          <select name="idProducto" id="selectProducto" required
                  onchange="mostrarStock(this)">
            <option value="">-- Selecciona un producto --</option>
            <% if (productos != null) {
              for (Producto p : productos) { %>
            <option value="<%= p.getId() %>">
              <%= p.getNombre() %> ($<%= String.format("%.2f", p.getPrecioVenta()) %>)
            </option>
            <% } } %>
          </select>
          <%-- aviso de stock en tiempo real --%>
          <div id="stockInfo" class="stock-info"></div>
        </div>

        <div class="campo-grupo">
          <label>Tipo de Merma</label>
          <select name="tipo" required>
            <option value="COMIDO">Comido por personal</option>
            <option value="FIADO">Fiado (no pagado hoy)</option>
            <option value="SOBRANTE">Sobrante / Danado</option>
          </select>
        </div>
        <div class="campo-grupo">
          <label>Descripcion</label>
          <input type="text" name="descripcion" placeholder="Ej. Tamales de elote rotos" required>
        </div>
        <div class="campo-grupo">
          <label>Cantidad</label>
          <input type="number" min="1" id="cantidadMerma" name="cantidadMerma" required>
        </div>
        <button type="submit" class="btn-form btn-merma">Guardar Merma</button>
      </form>
    </div>

  </div>

  <%-- tabla de gastos del dia --%>
  <div class="tarjeta-tabla">
    <p class="tabla-titulo">Gastos Registrados Hoy</p>
    <% if (gastosHoy == null || gastosHoy.isEmpty()) { %>
    <p class="sin-registros">No hay gastos registrados hoy</p>
    <% } else { %>
    <table>
      <thead>
      <tr>
        <th>Tipo</th>
        <th>Descripcion</th>
        <th>Monto</th>
      </tr>
      </thead>
      <tbody>
      <% for (Gasto g : gastosHoy) { %>
      <tr>
        <td><span class="badge badge-<%= g.getTipo() != null ? g.getTipo().toLowerCase() : "" %>">
            <%= g.getTipo() %></span></td>
        <td><%= g.getDescripcion() %></td>
        <td><strong>$<%= String.format("%.2f", g.getMonto()) %></strong></td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>

  <%-- tabla de mermas del dia --%>
  <div class="tarjeta-tabla">
    <p class="tabla-titulo">Mermas Registradas Hoy</p>
    <% if (mermasHoy == null || mermasHoy.isEmpty()) { %>
    <p class="sin-registros">No hay mermas registradas hoy</p>
    <% } else { %>
    <table>
      <thead>
      <tr>
        <th>Tipo</th>
        <th>Descripcion</th>
        <th>Cantidad</th>
        <th>Valor Perdido</th>
      </tr>
      </thead>
      <tbody>
      <% for (Merma m : mermasHoy) { %>
      <tr>
        <td><span class="badge badge-<%= m.getTipo() != null ? m.getTipo().toLowerCase() : "" %>">
            <%= m.getTipo() %></span></td>
        <td><%= m.getDescripcion() %></td>
        <td><%= (int) m.getCantidadMerma() %> uds.</td>
        <td><strong>$<%= String.format("%.2f", m.getValorMerma()) %></strong></td>
      </tr>
      <% } %>
      </tbody>
    </table>
    <% } %>
  </div>

</div>

<script>
  /*
    Consulta el stock disponible del producto seleccionado via fetch
    y muestra un aviso visual antes de que el usuario ingrese la cantidad.
   */
  function mostrarStock(sel) {
    var info = document.getElementById('stockInfo');
    if (!sel.value) {
      info.textContent = '';
      return;
    }
    // llamada al endpoint de stock disponible del dia
    fetch('${pageContext.request.contextPath}/stockDisponible?idProducto=' + sel.value)
            .then(function(r) { return r.json(); })
            .then(function(data) {
              var disp = data.stockDisponible || 0;
              if (disp <= 0) {
                info.className = 'stock-info stock-agotado';
                info.textContent = 'Sin stock hoy. Abre el dia en Ventas primero.';
                document.getElementById('cantidadMerma').max = 0;
              } else if (disp <= 5) {
                info.className = 'stock-info stock-bajo';
                info.textContent = 'Stock disponible hoy: ' + disp + ' uds. (stock bajo)';
                document.getElementById('cantidadMerma').max = disp;
              } else {
                info.className = 'stock-info stock-ok';
                info.textContent = 'Stock disponible hoy: ' + disp + ' uds.';
                document.getElementById('cantidadMerma').max = disp;
              }
            })
            .catch(function() {
              // si no hay endpoint JSON aun, no muestra nada (la validacion es en servidor)
              info.textContent = '';
            });
  }
</script>

</body>
</html>