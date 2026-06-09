<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TAMinventory - Corte de Caja</title>
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

        .contenedor { max-width: 860px; margin: 24px auto; padding: 0 16px; }

        .titulo-modulo {
            font-size: 1.2rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 20px;
            color: #1a1a2e;
        }

        /* ahora son 4 tarjetas: ventas, gastos, mermas, esperado */
        .grid-tarjetas {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 14px;
            margin-bottom: 24px;
        }
        .tarjeta-info {
            background: white;
            border-radius: 10px;
            padding: 14px 16px;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }
        .tarjeta-icono {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        .ic-verde  { background: #d5f5e3; }
        .ic-rojo   { background: #fdecea; }
        .ic-naranja{ background: #fef3e2; }
        .ic-azul   { background: #dbeafe; }
        .tarjeta-info span {
            display: block;
            font-size: 0.73rem;
            color: #888;
            font-weight: 600;
            margin-bottom: 3px;
        }
        .tarjeta-info strong {
            font-size: 1.15rem;
            font-weight: 900;
            color: #1a1a2e;
        }
        .texto-rojo    { color: #c0392b !important; }
        .texto-naranja { color: #e67e22 !important; }

        .tarjeta-form {
            background: white;
            border-radius: 10px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            margin-bottom: 20px;
        }
        .form-titulo {
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            color: #888;
            letter-spacing: 1px;
            margin-bottom: 16px;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 20px;
        }
        .campo-grupo label {
            display: block;
            font-size: 0.82rem;
            font-weight: 600;
            color: #555;
            margin-bottom: 6px;
        }
        .campo-grupo input {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 700;
            color: #1a1a2e;
            transition: border-color 0.2s;
        }
        .campo-grupo input:focus { outline: none; border-color: #b8962e; }

        /* desglose de descuentos */
        .desglose {
            background: #f8f9fa;
            border: 1px dashed #ddd;
            border-radius: 8px;
            padding: 14px 16px;
            margin-bottom: 16px;
            font-size: 0.85rem;
        }
        .desglose-fila {
            display: flex;
            justify-content: space-between;
            padding: 4px 0;
            color: #555;
        }
        .desglose-fila.total {
            border-top: 1px solid #ddd;
            margin-top: 6px;
            padding-top: 8px;
            font-weight: 800;
            font-size: 1rem;
            color: #1a1a2e;
        }
        .desglose-fila span:last-child { font-weight: 700; }

        .btn-guardar {
            width: 100%;
            padding: 14px;
            background: #27ae60;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 800;
            cursor: pointer;
        }
        .btn-guardar:hover { background: #219653; }

        /* resultado */
        .tarjeta-resultado {
            background: white;
            border-radius: 10px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            margin-bottom: 20px;
        }
        .resultado-grid {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 16px;
            align-items: center;
            margin-top: 16px;
        }
        .alerta-resultado {
            padding: 18px;
            border-radius: 8px;
            color: white;
            text-align: center;
            font-weight: 800;
            font-size: 1rem;
            line-height: 1.6;
        }
        .alerta-perfecto { background: #27ae60; }
        .alerta-sobrante { background: #f39c12; }
        .alerta-faltante { background: #e74c3c; }
        .dato-resumen {
            text-align: center;
            border-left: 1px solid #eee;
            padding-left: 16px;
        }
        .dato-resumen span {
            display: block;
            font-size: 0.8rem;
            color: #888;
            margin-bottom: 6px;
        }
        .dato-resumen strong { font-size: 1.25rem; font-weight: 900; color: #1a1a2e; }

        .alerta-error {
            background: #fdecea;
            color: #c0392b;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 16px;
        }

        @media (max-width: 700px) {
            .grid-tarjetas  { grid-template-columns: repeat(2, 1fr); }
            .form-row        { grid-template-columns: 1fr; }
            .resultado-grid  { grid-template-columns: 1fr; }
            .dato-resumen    { border-left: none; border-top: 1px solid #eee; padding: 12px 0 0; }
        }
    </style>
</head>
<body>

<%
    Double ventasHoy = (Double) request.getAttribute("ventasHoy");
    Double gastosHoy = (Double) request.getAttribute("gastosHoy");
    Double mermasHoy = (Double) request.getAttribute("mermasHoy");
    if (ventasHoy == null) ventasHoy = 0.0;
    if (gastosHoy == null) gastosHoy = 0.0;
    if (mermasHoy == null) mermasHoy = 0.0;
%>

<nav class="top-nav">
    <div class="nav-logo">
        <img src="${pageContext.request.contextPath}/imagenes/LogoV.png" alt="TAMinventory">
        <span>TAMinventory</span>
    </div>
    <a class="nav-btn" href="${pageContext.request.contextPath}/menu">Menu Principal</a>
</nav>

<div class="contenedor">

    <h2 class="titulo-modulo">Modulo 4: Corte de Caja Inteligente</h2>

    <% if ("1".equals(request.getParameter("error"))) { %>
    <div class="alerta-error">Ocurrio un error al guardar el corte. Intenta de nuevo.</div>
    <% } %>

    <%-- 4 tarjetas: ventas, gastos, mermas, esperado --%>
    <div class="grid-tarjetas">

        <div class="tarjeta-info">
            <div class="tarjeta-icono ic-verde">
                <svg width="18" height="18" fill="none" stroke="#27ae60" stroke-width="2.5" viewBox="0 0 24 24">
                    <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/>
                    <polyline points="17 6 23 6 23 12"/>
                </svg>
            </div>
            <div>
                <span>Ventas del Dia</span>
                <strong>$<%= String.format("%.2f", ventasHoy) %></strong>
            </div>
        </div>

        <div class="tarjeta-info">
            <div class="tarjeta-icono ic-rojo">
                <svg width="18" height="18" fill="none" stroke="#e74c3c" stroke-width="2.5" viewBox="0 0 24 24">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
                    <polyline points="14 2 14 8 20 8"/>
                </svg>
            </div>
            <div>
                <span>Gastos del Dia</span>
                <strong class="texto-rojo">-$<%= String.format("%.2f", gastosHoy) %></strong>
            </div>
        </div>

        <div class="tarjeta-info">
            <div class="tarjeta-icono ic-naranja">
                <svg width="18" height="18" fill="none" stroke="#e67e22" stroke-width="2.5" viewBox="0 0 24 24">
                    <polyline points="3 6 5 6 21 6"/>
                    <path d="M19 6l-1 14H6L5 6"/>
                </svg>
            </div>
            <div>
                <span>Mermas del Dia</span>
                <strong class="texto-naranja">-$<%= String.format("%.2f", mermasHoy) %></strong>
            </div>
        </div>

        <div class="tarjeta-info">
            <div class="tarjeta-icono ic-azul">
                <svg width="18" height="18" fill="none" stroke="#3b82f6" stroke-width="2.5" viewBox="0 0 24 24">
                    <rect x="2" y="7" width="20" height="14" rx="2"/>
                    <path d="M16 7V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v2"/>
                </svg>
            </div>
            <div>
                <span>Esperado (calc.)</span>
                <strong id="lblEsperadoTarjeta">
                    $<%= String.format("%.2f", ventasHoy - gastosHoy - mermasHoy) %>
                </strong>
            </div>
        </div>

    </div>

    <%-- formulario --%>
    <div class="tarjeta-form">
        <p class="form-titulo">Ingresa los datos del cierre</p>

        <form id="formCorte" action="${pageContext.request.contextPath}/corte" method="POST">

            <div class="form-row">
                <div class="campo-grupo">
                    <label for="efectivoInicial">Fondo Inicial en Caja ($)</label>
                    <input type="number" id="efectivoInicial" name="efectivoInicial"
                           step="0.50" min="0" value="0.00" required
                           oninput="recalcular()">
                </div>
                <div class="campo-grupo">
                    <label for="efectivoReal">Efectivo Real Contado ($)</label>
                    <input type="number" id="efectivoReal" name="efectivoReal"
                           step="0.50" min="0" placeholder="Ej. 2500.00" required>
                </div>
            </div>

            <%-- desglose del calculo para que el usuario entienda de donde sale el esperado --%>
            <div class="desglose">
                <div class="desglose-fila">
                    <span>Fondo inicial</span>
                    <span id="dFondo">$0.00</span>
                </div>
                <div class="desglose-fila">
                    <span>+ Ventas del dia</span>
                    <span>$<%= String.format("%.2f", ventasHoy) %></span>
                </div>
                <div class="desglose-fila">
                    <span>- Gastos del dia</span>
                    <span>-$<%= String.format("%.2f", gastosHoy) %></span>
                </div>
                <div class="desglose-fila">
                    <span>- Mermas del dia</span>
                    <span>-$<%= String.format("%.2f", mermasHoy) %></span>
                </div>
                <div class="desglose-fila total">
                    <span>Efectivo Esperado</span>
                    <span id="dEsperado">$<%= String.format("%.2f", ventasHoy - gastosHoy - mermasHoy) %></span>
                </div>
            </div>

            <button type="submit" class="btn-guardar">GUARDAR CORTE DIARIO</button>
        </form>
    </div>

    <%-- resultado tras el POST --%>
    <% if (request.getAttribute("corte") != null) {
        modelos.CorteCaja corte     = (modelos.CorteCaja) request.getAttribute("corte");
        double            diferencia = (Double) request.getAttribute("diferencia");
        String claseAlerta = diferencia == 0 ? "alerta-perfecto"
                : (diferencia > 0 ? "alerta-sobrante" : "alerta-faltante");
    %>
    <div class="tarjeta-resultado">
        <p class="form-titulo">Conciliacion Diaria</p>
        <div class="resultado-grid">
            <div class="alerta-resultado <%= claseAlerta %>">
                <%= corte.getNotas() %><br>
                <span style="font-size:0.85rem; font-weight:600;">
          Diferencia: $<%= String.format("%.2f", Math.abs(diferencia)) %>
        </span>
            </div>
            <div class="dato-resumen">
                <span>Efectivo Esperado</span>
                <strong>$<%= String.format("%.2f", corte.getEfectivoEsperado()) %></strong>
            </div>
            <div class="dato-resumen">
                <span>Efectivo Real Contado</span>
                <strong>$<%= String.format("%.2f", corte.getEfectivoReal()) %></strong>
            </div>
        </div>
    </div>
    <% } %>

</div>

<script>
    var ventasHoy = <%= ventasHoy %>;
    var gastosHoy = <%= gastosHoy %>;
    var mermasHoy = <%= mermasHoy %>;

    /*
     * Recalcula el efectivo esperado en tiempo real al cambiar el fondo inicial.
     * Formula: esperado = inicial + ventas - gastos - mermas
     */
    function recalcular() {
        var inicial  = parseFloat(document.getElementById('efectivoInicial').value) || 0;
        var esperado = inicial + ventasHoy - gastosHoy - mermasHoy;
        var txt      = '$' + esperado.toFixed(2);

        document.getElementById('dFondo').textContent           = '$' + inicial.toFixed(2);
        document.getElementById('dEsperado').textContent        = txt;
        document.getElementById('lblEsperadoTarjeta').textContent = txt;
    }
</script>

</body>
</html>