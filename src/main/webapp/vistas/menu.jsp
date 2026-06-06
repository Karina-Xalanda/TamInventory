<%@ page contentType="text/html;charset=UTF-8" %>
<%
    if (session.getAttribute("usuario") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>TAMinventary - Menú</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4;
            display: flex; flex-direction: column; align-items: center;
            justify-content: center; height: 100vh; margin: 0; }
        h2 { color: #333; margin-bottom: 2rem; }
        .modulos { display: flex; gap: 1.5rem; flex-wrap: wrap; justify-content: center; }
        .btn-modulo { width: 160px; height: 160px; border-radius: 12px; border: none;
            color: white; font-size: 16px; font-weight: bold;
            cursor: pointer; display: flex; flex-direction: column;
            align-items: center; justify-content: center; gap: 10px; }
        .ventas    { background: #e67e22; }
        .insumos   { background: #27ae60; }
        .corte     { background: #2980b9; }
        .btn-modulo:hover { opacity: 0.85; }
        .salir { margin-top: 2rem; color: #888; text-decoration: none; font-size: 14px; }
        .salir:hover { color: #333; }
    </style>
</head>
<body>
<h2>Bienvenido, <%= session.getAttribute("usuario") %></h2>
<div class="modulos">

    <button class="btn-modulo ventas"
            onclick="location.href='${pageContext.request.contextPath}/vistas/ventas.jsp'">
        <br>Ventas
    </button>
    <button class="btn-modulo insumos"
            onclick="location.href='${pageContext.request.contextPath}/insumos'">
        <br>Insumos
    </button>
    <button class="btn-modulo corte"
            onclick="location.href='${pageContext.request.contextPath}/vistas/corte.jsp'">
        <br>Corte de Caja
    </button>

    <button class="btn-modulo" style="background: #e74c3c;"
            onclick="location.href='${pageContext.request.contextPath}/vistas/egresos.jsp'">
        <br>Gastos y Mermas
    </button>

    <button class="btn-modulo" style="background: #8e44ad;"
            onclick="location.href='${pageContext.request.contextPath}/reportes'">
        <br>Reportes y Analítica
    </button>

</div>
<a class="salir" href="${pageContext.request.contextPath}/logout">Cerrar sesión</a>
</body>
</html>