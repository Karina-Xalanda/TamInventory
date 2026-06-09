<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, modelos.Producto, modelos.Inventario" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <title>TAMinventory - Punto de Venta</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6f8; }

    /* barra superior */
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
      margin-left: 8px;
    }
    .nav-btn:hover { background: #9a7a22; }

    /* layout */
    .app-container {
      display: flex;
      padding: 16px;
      gap: 16px;
      height: calc(100vh - 62px);
    }
    .main-content { flex: 2; overflow-y: auto; }
    .cart-section {
      flex: 1;
      background: white;
      border-radius: 10px;
      padding: 16px;
      display: flex;
      flex-direction: column;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
      min-width: 280px;
    }

    /* busqueda */
    .buscador {
      width: 100%;
      padding: 10px 14px;
      border: 1px solid #ddd;
      border-radius: 8px;
      font-size: 0.9rem;
      margin-bottom: 14px;
    }

    /* grid de productos */
    .products-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
      gap: 12px;
    }
    .product-card {
      background: white;
      border: 1px solid #e0e0e0;
      border-radius: 10px;
      padding: 12px;
      text-align: center;
      position: relative;
      transition: box-shadow 0.2s;
    }
    .product-card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
    .product-card.agotado { opacity: 0.5; }

    /* badge de stock */
    .badge-stock {
      position: absolute;
      top: 8px;
      right: 8px;
      padding: 2px 7px;
      border-radius: 10px;
      font-size: 0.7rem;
      font-weight: 700;
      color: white;
    }
    .badge-optimo  { background: #27ae60; }
    .badge-bajo    { background: #f39c12; }
    .badge-critico { background: #e74c3c; }
    .badge-agotado { background: #95a5a6; }

    .product-img {
      width: 80px;
      height: 80px;
      object-fit: contain;
      margin: 8px auto;
      display: block;
    }
    .product-title {
      font-size: 0.85rem;
      font-weight: 700;
      margin-bottom: 4px;
      min-height: 2.5em;
      line-height: 1.3;
    }
    .product-price {
      color: #b8962e;
      font-weight: 800;
      font-size: 1rem;
      margin-bottom: 8px;
    }
    .btn-add {
      background: #27ae60;
      color: white;
      border: none;
      padding: 7px;
      width: 100%;
      border-radius: 6px;
      cursor: pointer;
      font-weight: 600;
      font-size: 0.9rem;
    }
    .btn-add:disabled { background: #bdc3c7; cursor: not-allowed; }
    .btn-add:hover:not(:disabled) { background: #219653; }

    /* carrito */
    .cart-title {
      font-size: 1rem;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 1px;
      margin-bottom: 12px;
      padding-bottom: 8px;
      border-bottom: 2px solid #f0f0f0;
    }
    .cart-header {
      display: grid;
      grid-template-columns: 2fr 1fr 1fr 28px;
      font-size: 0.75rem;
      font-weight: 700;
      color: #888;
      text-transform: uppercase;
      padding: 4px 0;
      border-bottom: 1px solid #eee;
      margin-bottom: 6px;
    }
    .cart-items { flex-grow: 1; overflow-y: auto; }
    .cart-row {
      display: grid;
      grid-template-columns: 2fr 1fr 1fr 28px;
      align-items: center;
      padding: 8px 0;
      border-bottom: 1px solid #f5f5f5;
      font-size: 0.85rem;
    }
    .cart-row .nombre { font-weight: 600; }
    .cart-row .cant-ctrl {
      display: flex;
      align-items: center;
      gap: 4px;
    }
    .btn-cant {
      background: #f0f0f0;
      border: none;
      border-radius: 4px;
      width: 22px;
      height: 22px;
      cursor: pointer;
      font-weight: 700;
      font-size: 0.85rem;
      line-height: 1;
    }
    .btn-cant:hover { background: #ddd; }
    .btn-eliminar {
      background: none;
      border: none;
      color: #e74c3c;
      cursor: pointer;
      font-size: 1rem;
      padding: 0;
    }
    .cart-empty {
      text-align: center;
      color: #bbb;
      padding: 30px 0;
      font-size: 0.9rem;
    }

    /* total y botones finales */
    .cart-total {
      border-top: 2px solid #f0f0f0;
      padding-top: 12px;
      margin-top: 8px;
    }
    .total-label { font-size: 0.85rem; color: #888; font-weight: 600; }
    .total-monto {
      font-size: 1.8rem;
      font-weight: 900;
      color: #1a1a2e;
      text-align: right;
    }
    .btn-registrar {
      width: 100%;
      padding: 13px;
      background: #27ae60;
      color: white;
      border: none;
      border-radius: 8px;
      font-size: 1rem;
      font-weight: 800;
      cursor: pointer;
      margin-top: 10px;
      letter-spacing: 0.5px;
    }
    .btn-registrar:hover { background: #219653; }
    .btn-cancelar {
      width: 100%;
      padding: 10px;
      background: white;
      color: #555;
      border: 1px solid #ddd;
      border-radius: 8px;
      font-size: 0.9rem;
      cursor: pointer;
      margin-top: 6px;
    }
    .btn-cancelar:hover { background: #f5f5f5; }

    /* alertas */
    .alerta {
      padding: 10px 16px;
      border-radius: 8px;
      margin-bottom: 12px;
      font-size: 0.9rem;
      font-weight: 600;
    }
    .alerta-ok    { background: #d5f5e3; color: #1e8449; }
    .alerta-error { background: #fdecea; color: #c0392b; }

    /* modal apertura del dia */
    .modal-overlay {
      display: none;
      position: fixed;
      inset: 0;
      background: rgba(0,0,0,0.55);
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }
    .modal-box {
      background: white;
      border-radius: 12px;
      padding: 24px;
      width: 420px;
      max-height: 80vh;
      overflow-y: auto;
      box-shadow: 0 8px 30px rgba(0,0,0,0.2);
    }
    .modal-box h3 {
      font-size: 1rem;
      font-weight: 800;
      text-transform: uppercase;
      margin-bottom: 16px;
      padding-bottom: 10px;
      border-bottom: 2px solid #f0f0f0;
    }
    .modal-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 8px 0;
      border-bottom: 1px solid #f5f5f5;
      font-size: 0.9rem;
    }
    .modal-row input {
      width: 90px;
      padding: 6px;
      border: 1px solid #ddd;
      border-radius: 6px;
      text-align: center;
      font-size: 0.9rem;
    }
    .btn-modal-guardar {
      width: 100%;
      padding: 12px;
      background: #b8962e;
      color: white;
      border: none;
      border-radius: 8px;
      font-weight: 700;
      cursor: pointer;
      margin-top: 16px;
    }
    .btn-modal-guardar:hover { background: #9a7a22; }
    .btn-modal-cerrar {
      width: 100%;
      padding: 10px;
      background: white;
      border: 1px solid #ddd;
      border-radius: 8px;
      cursor: pointer;
      margin-top: 6px;
      font-size: 0.9rem;
      color: #555;
    }
  </style>
</head>
<body>

<%
  List<Producto>   productos       = (List<Producto>)   request.getAttribute("productos");
  List<Inventario> stockHoy        = (List<Inventario>) request.getAttribute("stockHoy");
  boolean          stockRegistrado = Boolean.TRUE.equals(request.getAttribute("stockRegistrado"));
  String           paramExito      = request.getParameter("exito");
  String           paramError      = request.getParameter("error");
  String           paramApertura   = request.getParameter("apertura");
%>

<%-- barra superior --%>
<nav class="top-nav">
  <div class="nav-logo">
    <img src="${pageContext.request.contextPath}/imagenes/LogoV.png" alt="TAMinventory">
    <span>TAMinventory</span>
  </div>
  <div>
    <button class="nav-btn" onclick="abrirModalStock()">Configurar Stock del Dia</button>
    <a class="nav-btn" href="${pageContext.request.contextPath}/menu">Menu Principal</a>
  </div>
</nav>

<%-- modal: apertura del dia --%>
<div class="modal-overlay" id="modalStock"
     style="<%= !stockRegistrado ? "display:flex;" : "" %>">
  <div class="modal-box">
    <h3>Inventario Inicial del Dia</h3>
    <form action="${pageContext.request.contextPath}/venta" method="POST">
      <input type="hidden" name="accion" value="abrirDia">
      <% if (productos != null) {
        for (Producto p : productos) { %>
      <div class="modal-row">
        <span><%= p.getNombre() != null ? p.getNombre() : "Producto" %></span>
        <input type="number" name="stock_<%= p.getId() %>"
               value="0" min="0" required>
      </div>
      <% } } %>
      <button type="submit" class="btn-modal-guardar">Guardar e Iniciar Ventas</button>
      <% if (stockRegistrado) { %>
      <button type="button" class="btn-modal-cerrar"
              onclick="cerrarModalStock()">Cancelar</button>
      <% } %>
    </form>
  </div>
</div>

<div class="app-container">

  <%-- columna izquierda: catalogo --%>
  <main class="main-content">

    <% if ("1".equals(paramExito)) { %>
    <div class="alerta alerta-ok">Venta registrada correctamente.</div>
    <% } else if ("1".equals(paramError)) { %>
    <div class="alerta alerta-error">Ocurrio un error al registrar la venta. Intenta de nuevo.</div>
    <% } else if ("vacio".equals(paramError)) { %>
    <div class="alerta alerta-error">Agrega al menos un producto antes de registrar.</div>
    <% } else if ("ok".equals(paramApertura)) { %>
    <div class="alerta alerta-ok">Stock del dia configurado. Ya puedes vender.</div>
    <% } %>

    <input class="buscador" type="text" id="buscador"
           placeholder="Buscar producto..." onkeyup="filtrarProductos()">

    <div class="products-grid" id="gridProductos">
      <% if (productos != null) {
        for (Producto p : productos) {
          int disp = 0;
          String estado = "AGOTADO";
          if (stockHoy != null) {
            for (Inventario inv : stockHoy) {
              if (inv.getIdProducto() != null &&
                      inv.getIdProducto().equals(p.getId())) {
                disp   = inv.getStockDisponible();
                estado = inv.getEstado();
              }
            }
          }
          String badgeClase = "badge-" + estado.toLowerCase();
          boolean agotado   = disp <= 0;
      %>
      <div class="product-card <%= agotado ? "agotado" : "" %>"
           data-nombre="<%= p.getNombre() != null ? p.getNombre().toLowerCase() : "" %>">

        <span class="badge-stock <%= badgeClase %>"><%= disp %></span>

        <img class="product-img"
             src="${pageContext.request.contextPath}/imagenes/<%= p.getImagenUrl() != null ? p.getImagenUrl() : "LogoV.png" %>"
             alt="<%= p.getNombre() %>">

        <div class="product-title"><%= p.getNombre() != null ? p.getNombre() : "Sin nombre" %></div>
        <div class="product-price">$<%= String.format("%.2f", p.getPrecioVenta()) %></div>

        <button class="btn-add"
                <%= agotado ? "disabled" : "" %>
                onclick="agregarAlCarrito(
                        '<%= p.getId() %>',
                        '<%= p.getNombre() != null ? p.getNombre().replace("'","") : "Tamal" %>',
                  <%= p.getPrecioVenta() %>,
                  <%= disp %>
                        )">
          <%= agotado ? "Agotado" : "Agregar +" %>
        </button>
      </div>
      <% } } %>
    </div>

  </main>

  <%-- columna derecha: carrito --%>
  <aside class="cart-section">
    <div class="cart-title">Orden Actual</div>

    <div class="cart-header">
      <span>Producto</span>
      <span>Cant.</span>
      <span>Subt.</span>
      <span></span>
    </div>

    <div class="cart-items" id="cuerpoCarrito">
      <div class="cart-empty" id="mensajeVacio">Sin productos aun</div>
    </div>

    <div class="cart-total">
      <div class="total-label">TOTAL A COBRAR:</div>
      <div class="total-monto" id="lblTotal">$0.00</div>
    </div>

    <form id="formVenta" action="${pageContext.request.contextPath}/venta" method="POST">
      <input type="hidden" name="accion" value="registrarVenta">
      <div id="inputsOcultos"></div>
      <button type="button" class="btn-registrar" onclick="procesarVenta()">
        REGISTRAR VENTA
      </button>
      <button type="button" class="btn-cancelar" onclick="cancelarOrden()">
        CANCELAR ORDEN
      </button>
    </form>
  </aside>

</div>

<script>
  /*
   * carrito: arreglo de objetos { id, nombre, precio, cantidad, maxStock }
   * Cada producto aparece una sola vez; los clicks siguientes suman cantidad.
   */
  var carrito = [];

  function agregarAlCarrito(id, nombre, precio, maxStock) {
    var existente = carrito.find(function(i) { return i.id === id; });

    if (existente) {
      // si ya esta, sube la cantidad respetando el stock disponible
      if (existente.cantidad < existente.maxStock) {
        existente.cantidad++;
      } else {
        alert('No hay mas stock disponible de ' + nombre);
        return;
      }
    } else {
      carrito.push({ id: id, nombre: nombre, precio: precio,
        cantidad: 1, maxStock: maxStock });
    }
    renderCarrito();
  }

  function cambiarCantidad(id, delta) {
    var item = carrito.find(function(i) { return i.id === id; });
    if (!item) return;

    var nueva = item.cantidad + delta;
    if (nueva <= 0) {
      // si baja a 0, elimina el producto del carrito
      quitarDelCarrito(id);
      return;
    }
    if (nueva > item.maxStock) {
      alert('Stock maximo: ' + item.maxStock);
      return;
    }
    item.cantidad = nueva;
    renderCarrito();
  }

  function quitarDelCarrito(id) {
    carrito = carrito.filter(function(i) { return i.id !== id; });
    renderCarrito();
  }

  function renderCarrito() {
    var contenedor = document.getElementById('cuerpoCarrito');
    var vacio      = document.getElementById('mensajeVacio');

    if (carrito.length === 0) {
      contenedor.innerHTML = '<div class="cart-empty" id="mensajeVacio">Sin productos aun</div>';
      document.getElementById('lblTotal').textContent = '$0.00';
      return;
    }

    var html  = '';
    var total = 0;

    carrito.forEach(function(item) {
      var subtotal = item.precio * item.cantidad;
      total += subtotal;
      html += '<div class="cart-row">'
              + '  <span class="nombre">' + item.nombre + '</span>'
              + '  <span class="cant-ctrl">'
              + '    <button class="btn-cant" onclick="cambiarCantidad(\'' + item.id + '\', -1)">-</button>'
              + '    <span>' + item.cantidad + '</span>'
              + '    <button class="btn-cant" onclick="cambiarCantidad(\'' + item.id + '\', 1)">+</button>'
              + '  </span>'
              + '  <span>$' + subtotal.toFixed(2) + '</span>'
              + '  <button class="btn-eliminar" onclick="quitarDelCarrito(\'' + item.id + '\')" title="Quitar">x</button>'
              + '</div>';
    });

    contenedor.innerHTML = html;
    document.getElementById('lblTotal').textContent = '$' + total.toFixed(2);
  }

  function procesarVenta() {
    if (carrito.length === 0) {
      alert('Agrega al menos un producto antes de registrar.');
      return;
    }
    // limpia inputs anteriores para evitar duplicados si el usuario
    // intenta enviar dos veces
    var cont = document.getElementById('inputsOcultos');
    cont.innerHTML = '';

    carrito.forEach(function(item) {
      cont.innerHTML += '<input type="hidden" name="idProducto[]" value="' + item.id + '">';
      cont.innerHTML += '<input type="hidden" name="cantidad[]"   value="' + item.cantidad + '">';
      cont.innerHTML += '<input type="hidden" name="precio[]"     value="' + item.precio + '">';
    });

    document.getElementById('formVenta').submit();
  }

  function cancelarOrden() {
    carrito = [];
    renderCarrito();
  }

  // filtra las tarjetas de productos segun el texto del buscador
  function filtrarProductos() {
    var texto    = document.getElementById('buscador').value.toLowerCase();
    var tarjetas = document.querySelectorAll('.product-card');
    tarjetas.forEach(function(t) {
      var nombre = t.getAttribute('data-nombre') || '';
      t.style.display = nombre.includes(texto) ? '' : 'none';
    });
  }

  function abrirModalStock() {
    document.getElementById('modalStock').style.display = 'flex';
  }

  function cerrarModalStock() {
    document.getElementById('modalStock').style.display = 'none';
  }
</script>

</body>
</html>