<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TAMinventory - Menu Principal</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f4f6f8;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* barra superior igual que ventas y corte */
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
        .nav-usuario {
            font-size: 0.85rem;
            color: #ccc;
        }
        .nav-usuario strong { color: #b8962e; }

        /* cuerpo central */
        .cuerpo {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 32px 16px;
        }

        .saludo {
            font-size: 0.95rem;
            color: #888;
            margin-bottom: 32px;
            text-align: center;
        }
        .saludo strong { color: #1a1a2e; }

        /* grid de modulos */
        .modulos {
            display: grid;
            grid-template-columns: repeat(3, 200px);
            gap: 16px;
            margin-bottom: 36px;
        }

        .card-modulo {
            background: white;
            border-radius: 14px;
            padding: 28px 16px 22px;
            text-align: center;
            text-decoration: none;
            color: #1a1a2e;
            box-shadow: 0 2px 8px rgba(0,0,0,0.07);
            transition: transform 0.15s, box-shadow 0.15s;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
        }
        .card-modulo:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }

        /* circulo de icono */
        .card-icono {
            width: 56px;
            height: 56px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .card-icono svg { width: 26px; height: 26px; }

        .ic-ventas   { background: #fff3e0; }
        .ic-insumos  { background: #e8f5e9; }
        .ic-corte    { background: #e3f2fd; }
        .ic-egresos  { background: #fdecea; }
        .ic-reportes { background: #f3e5f5; }

        .card-num {
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #bbb;
        }
        .card-nombre {
            font-size: 0.95rem;
            font-weight: 800;
            color: #1a1a2e;
        }
        .card-desc {
            font-size: 0.78rem;
            color: #999;
            line-height: 1.4;
        }

        /* barra inferior de acento de color */
        .card-barra {
            width: 40px;
            height: 3px;
            border-radius: 2px;
            margin-top: 4px;
        }
        .barra-ventas   { background: #e67e22; }
        .barra-insumos  { background: #27ae60; }
        .barra-corte    { background: #3b82f6; }
        .barra-egresos  { background: #e74c3c; }
        .barra-reportes { background: #8e44ad; }

        /* boton cerrar sesion */
        .btn-salir {
            color: #aaa;
            text-decoration: none;
            font-size: 0.85rem;
            padding: 8px 20px;
            border: 1px solid #ddd;
            border-radius: 20px;
            transition: all 0.2s;
        }
        .btn-salir:hover {
            background: #1a1a2e;
            color: white;
            border-color: #1a1a2e;
        }

        @media (max-width: 680px) {
            .modulos { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 420px) {
            .modulos { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<nav class="top-nav">
    <div class="nav-logo">
        <img src="${pageContext.request.contextPath}/imagenes/LogoV.png" alt="TAMinventory">
        <span>TAMinventory</span>
    </div>
    <div class="nav-usuario">
        Usuario: <strong><%= session.getAttribute("usuario") %></strong>
    </div>
</nav>

<div class="cuerpo">

    <p class="saludo">
        Bienvenido, <strong><%= session.getAttribute("usuario") %></strong>.
        Selecciona un modulo para continuar.
    </p>

    <div class="modulos">

        <a class="card-modulo" href="${pageContext.request.contextPath}/venta">
            <div class="card-icono ic-ventas">
                <svg fill="none" stroke="#e67e22" stroke-width="2" viewBox="0 0 24 24">
                    <path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"/>
                    <line x1="3" y1="6" x2="21" y2="6"/>
                    <path d="M16 10a4 4 0 0 1-8 0"/>
                </svg>
            </div>
            <span class="card-num">Modulo 1</span>
            <span class="card-nombre">Registro de Ventas</span>
            <span class="card-desc">Registra pedidos y descuenta inventario</span>
            <div class="card-barra barra-ventas"></div>
        </a>

        <a class="card-modulo" href="${pageContext.request.contextPath}/insumos">
            <div class="card-icono ic-insumos">
                <svg fill="none" stroke="#27ae60" stroke-width="2" viewBox="0 0 24 24">
                    <path d="M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z"/>
                </svg>
            </div>
            <span class="card-num">Modulo 2</span>
            <span class="card-nombre">Gestion de Insumos</span>
            <span class="card-desc">Controla ingredientes y materias primas</span>
            <div class="card-barra barra-insumos"></div>
        </a>

        <a class="card-modulo" href="${pageContext.request.contextPath}/egresos">
            <div class="card-icono ic-egresos">
                <svg fill="none" stroke="#e74c3c" stroke-width="2" viewBox="0 0 24 24">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                    <polyline points="14 2 14 8 20 8"/>
                    <line x1="12" y1="18" x2="12" y2="12"/>
                    <line x1="9" y1="15" x2="15" y2="15"/>
                </svg>
            </div>
            <span class="card-num">Modulo 3</span>
            <span class="card-nombre">Gastos y Mermas</span>
            <span class="card-desc">Registra egresos y perdidas del dia</span>
            <div class="card-barra barra-egresos"></div>
        </a>

        <a class="card-modulo" href="${pageContext.request.contextPath}/corte">
            <div class="card-icono ic-corte">
                <svg fill="none" stroke="#3b82f6" stroke-width="2" viewBox="0 0 24 24">
                    <rect x="2" y="7" width="20" height="14" rx="2"/>
                    <path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/>
                    <line x1="12" y1="12" x2="12" y2="16"/>
                    <line x1="10" y1="14" x2="14" y2="14"/>
                </svg>
            </div>
            <span class="card-num">Modulo 4</span>
            <span class="card-nombre">Corte de Caja</span>
            <span class="card-desc">Concilia ventas, gastos y efectivo real</span>
            <div class="card-barra barra-corte"></div>
        </a>

        <a class="card-modulo" href="${pageContext.request.contextPath}/reportes">
            <div class="card-icono ic-reportes">
                <svg fill="none" stroke="#8e44ad" stroke-width="2" viewBox="0 0 24 24">
                    <line x1="18" y1="20" x2="18" y2="10"/>
                    <line x1="12" y1="20" x2="12" y2="4"/>
                    <line x1="6"  y1="20" x2="6"  y2="14"/>
                </svg>
            </div>
            <span class="card-num">Modulo 5</span>
            <span class="card-nombre">Reportes</span>
            <span class="card-desc">Estadisticas y resumen de operaciones</span>
            <div class="card-barra barra-reportes"></div>
        </a>

    </div>

    <a class="btn-salir" href="${pageContext.request.contextPath}/logout">
        Cerrar sesion
    </a>

</div>

</body>
</html>