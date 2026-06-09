<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TAMinventory - Iniciar Sesion</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f0f0f0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .tarjeta {
            background: white;
            padding: 2.5rem 2rem;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
            width: 340px;
            text-align: center;
        }

        .tarjeta img { width: 90px; margin-bottom: 0.5rem; }

        .titulo {
            font-size: 1.4rem;
            font-weight: 700;
            color: #1a1a1a;
            letter-spacing: 1px;
        }

        .subtitulo {
            font-size: 0.8rem;
            color: #888;
            margin-bottom: 1.8rem;
            letter-spacing: 2px;
        }

        .campo-label {
            text-align: left;
            font-size: 0.85rem;
            font-weight: 600;
            color: #444;
            margin-bottom: 0.3rem;
        }

        .campo-wrap {
            display: flex;
            align-items: center;
            border-bottom: 1px solid #ccc;
            margin-bottom: 1.4rem;
            padding-bottom: 6px;
            gap: 8px;
        }

        .campo-wrap svg { flex-shrink: 0; color: #888; }

        .campo-wrap input {
            border: none;
            outline: none;
            width: 100%;
            font-size: 0.95rem;
            color: #333;
            background: transparent;
        }

        .btn-mostrar {
            background: none;
            border: none;
            color: #b8962e;
            font-size: 0.8rem;
            cursor: pointer;
            white-space: nowrap;
        }

        /* el error viene via request.setAttribute("errorMsg") desde LoginServlet */
        .error {
            background: #fdecea;
            color: #c0392b;
            border-radius: 8px;
            padding: 0.6rem 1rem;
            font-size: 0.85rem;
            margin-bottom: 1rem;
            text-align: left;
        }

        .btn-ingresar {
            width: 100%;
            padding: 0.85rem;
            background: #b8962e;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 700;
            letter-spacing: 1px;
            cursor: pointer;
            transition: background 0.2s;
        }
        .btn-ingresar:hover { background: #9a7a22; }

        .pie { margin-top: 1.2rem; font-size: 0.8rem; color: #aaa; }
    </style>
</head>
<body>

<div class="tarjeta">

    <img src="${pageContext.request.contextPath}/imagenes/LogoV.png" alt="TAMinventory">
    <p class="titulo">TAMinventory</p>
    <p class="subtitulo">INICIAR SESION</p>

    <%-- errorMsg viene via forward desde LoginServlet.doPost --%>
    <% if (request.getAttribute("errorMsg") != null) { %>
    <div class="error"><%= request.getAttribute("errorMsg") %></div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/login">

        <p class="campo-label">Nombre de usuario</p>
        <div class="campo-wrap">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
                <circle cx="12" cy="7" r="4"/>
            </svg>
            <input type="text" name="nombre" placeholder="tu usuario" required
                   value="<%= request.getParameter("nombre") != null ? request.getParameter("nombre") : "" %>">
        </div>

        <p class="campo-label">Contrasena</p>
        <div class="campo-wrap">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
            </svg>
            <input type="password" name="password" id="campoPassword"
                   placeholder="············" required>
            <button type="button" class="btn-mostrar" onclick="togglePassword()">Mostrar</button>
        </div>

        <button type="submit" class="btn-ingresar">INGRESAR</button>
    </form>

    <p class="pie">Contacta a Soporte Tecnico si no tienes cuenta</p>
</div>

<script>
    function togglePassword() {
        var campo = document.getElementById('campoPassword');
        var boton = event.target;
        if (campo.type === 'password') {
            campo.type = 'text';
            boton.textContent = 'Ocultar';
        } else {
            campo.type = 'password';
            boton.textContent = 'Mostrar';
        }
    }
</script>

</body>
</html>