<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, java.util.LinkedHashMap, java.util.ArrayList" %>
<%@ page import="modelos.Insumo" %>
<%@ page import="org.bson.Document" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>TAMinventory - Reportes</title>
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

    .contenedor { max-width: 900px; margin: 24px auto; padding: 0 16px; }

    .titulo-pagina {
      font-size: 1.3rem;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 1px;
      color: #1a1a2e;
      margin-bottom: 20px;
    }

    .tarjeta {
      background: white;
      border-radius: 10px;
      padding: 24px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
      margin-bottom: 20px;
    }

    .tarjeta-titulo {
      font-size: 1rem;
      font-weight: 800;
      color: #1a1a2e;
      margin-bottom: 18px;
      padding-bottom: 12px;
      border-bottom: 3px solid #8e44ad;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .tarjeta-titulo.alerta-titulo {
      border-color: #e74c3c;
      color: #e74c3c;
    }

    /* grupo por categoria dentro del ranking */
    .grupo-categoria {
      margin-bottom: 20px;
    }
    .grupo-categoria:last-child {
      margin-bottom: 0;
    }
    .label-categoria {
      font-size: 0.75rem;
      font-weight: 800;
      text-transform: uppercase;
      letter-spacing: 1px;
      color: #888;
      margin-bottom: 8px;
      padding: 4px 0;
      border-bottom: 1px solid #f0f0f0;
    }

    /* fila de ranking */
    .ranking-fila {
      display: flex;
      align-items: center;
      gap: 14px;
      padding: 10px 0;
      border-bottom: 1px solid #f5f5f5;
    }
    .ranking-fila:last-child { border-bottom: none; }

    .ranking-pos {
      width: 28px;
      height: 28px;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 0.8rem;
      font-weight: 900;
      flex-shrink: 0;
      color: white;
    }
    .pos-1 { background: #f1c40f; color: #1a1a2e; }
    .pos-2 { background: #95a5a6; }
    .pos-3 { background: #cd7f32; }
    .pos-otro { background: #dce3e8; color: #555; }

    .ranking-nombre {
      flex: 1;
      font-size: 0.92rem;
      font-weight: 700;
      color: #1a1a2e;
    }

    .ranking-barra-wrap {
      flex: 2;
      background: #f0f0f0;
      border-radius: 4px;
      height: 10px;
      overflow: hidden;
    }
    .ranking-barra {
      height: 100%;
      border-radius: 4px;
      background: #8e44ad;
      transition: width 0.4s ease;
    }

    .ranking-total {
      font-size: 0.85rem;
      font-weight: 800;
      color: #8e44ad;
      min-width: 70px;
      text-align: right;
    }

    /* sin datos */
    .sin-datos {
      text-align: center;
      color: #bbb;
      padding: 24px;
      font-size: 0.9rem;
    }

    /* alertas de insumos */
    .alerta-item {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 10px 14px;
      background: #fdecea;
      border-radius: 8px;
      margin-bottom: 8px;
      font-size: 0.88rem;
      font-weight: 600;
      color: #c0392b;
    }
    .alerta-item:last-child { margin-bottom: 0; }
    .saludable-msg {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 12px 14px;
      background: #d5f5e3;
      border-radius: 8px;
      font-size: 0.88rem;
      font-weight: 600;
      color: #1e8449;
    }
  </style>
</head>
<body>

<%
  List<Document> topTamales = (List<Document>) request.getAttribute("topTamales");
  List<Insumo>   criticos   = (List<Insumo>)   request.getAttribute("criticos");

  // calcular el maximo para la barra proporcional
  int maxVendido = 1;
  if (topTamales != null && !topTamales.isEmpty()) {
    Number n = (Number) topTamales.get(0).get("totalVendido");
    if (n != null) maxVendido = n.intValue();
  }

  // agrupar por categoria para mostrar secciones separadas
  LinkedHashMap<String, List<Document>> porCategoria = new LinkedHashMap<>();
  if (topTamales != null) {
    for (Document doc : topTamales) {
      String cat = doc.getString("categoria");
      if (cat == null || cat.isEmpty()) cat = "Sin categoria";
      if (!porCategoria.containsKey(cat)) {
        porCategoria.put(cat, new ArrayList<>());
      }
      porCategoria.get(cat).add(doc);
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

  <h2 class="titulo-pagina">Panel de Reportes y Analitica</h2>

  <%-- seccion: ranking de productos mas vendidos --%>
  <div class="tarjeta">
    <div class="tarjeta-titulo">
      <svg width="18" height="18" fill="none" stroke="#8e44ad" stroke-width="2.5" viewBox="0 0 24 24">
        <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/>
        <polyline points="17 6 23 6 23 12"/>
      </svg>
      Ranking de Productos Mas Vendidos
    </div>

    <% if (topTamales == null || topTamales.isEmpty()) { %>
    <div class="sin-datos">Aun no hay ventas registradas para generar este reporte.</div>

    <% } else {
      int posGlobal = 1;
      for (String categoria : porCategoria.keySet()) {
        List<Document> items = porCategoria.get(categoria);
    %>
    <div class="grupo-categoria">
      <div class="label-categoria"><%= categoria %></div>

      <% for (Document doc : items) {
        String nombre = doc.getString("nombreProducto");
        if (nombre == null) nombre = "Producto desconocido";
        Number nVendido = (Number) doc.get("totalVendido");
        int vendido = nVendido != null ? nVendido.intValue() : 0;
        int porcentaje = maxVendido > 0 ? (vendido * 100 / maxVendido) : 0;
        String posClase = posGlobal == 1 ? "pos-1" : (posGlobal == 2 ? "pos-2" : (posGlobal == 3 ? "pos-3" : "pos-otro"));
      %>
      <div class="ranking-fila">
        <div class="ranking-pos <%= posClase %>"><%= posGlobal %></div>
        <div class="ranking-nombre"><%= nombre %></div>
        <div class="ranking-barra-wrap">
          <div class="ranking-barra" style="width:<%= porcentaje %>%"></div>
        </div>
        <div class="ranking-total"><%= vendido %> uds.</div>
      </div>
      <% posGlobal++; } %>
    </div>
    <% } } %>
  </div>

  <%-- seccion: alertas criticas de insumos --%>
  <div class="tarjeta">
    <div class="tarjeta-titulo alerta-titulo">
      <svg width="18" height="18" fill="none" stroke="#e74c3c" stroke-width="2.5" viewBox="0 0 24 24">
        <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
        <line x1="12" y1="9" x2="12" y2="13"/>
        <line x1="12" y1="17" x2="12.01" y2="17"/>
      </svg>
      Alertas Criticas de Insumos
    </div>

    <% if (criticos == null || criticos.isEmpty()) { %>
    <div class="saludable-msg">
      <svg width="16" height="16" fill="none" stroke="#1e8449" stroke-width="2.5" viewBox="0 0 24 24">
        <polyline points="20 6 9 17 4 12"/>
      </svg>
      Excelente. Ningun insumo esta en nivel critico por ahora.
    </div>
    <% } else {
      for (Insumo i : criticos) {
    %>
    <div class="alerta-item">
      <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
        <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
        <line x1="12" y1="9" x2="12" y2="13"/>
        <line x1="12" y1="17" x2="12.01" y2="17"/>
      </svg>
      <%= i.getNombre() %> — Solo quedan <%= i.getCantidad() %> unidades
    </div>
    <% } } %>
  </div>

</div>

</body>
</html>