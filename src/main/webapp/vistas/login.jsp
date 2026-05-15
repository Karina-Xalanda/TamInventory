<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>TAMinventary - Login</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4;
            display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .caja { background: white; padding: 2rem; border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); width: 300px; }
        h2 { text-align: center; color: #333; margin-bottom: 1.5rem; }
        input { width: 100%; padding: 10px; margin-bottom: 1rem;
            border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        button { width: 100%; padding: 10px; background: #e67e22;
            color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 15px; }
        button:hover { background: #d35400; }
        .error { color: red; text-align: center; margin-bottom: 1rem; font-size: 14px; }
    </style>
</head>
<body>
<div class="caja">
    <h2>TAMinventary</h2>
    <% if ("1".equals(request.getParameter("error"))) { %>
    <p class="error">Usuario o contraseña incorrectos</p>
    <% } %>
    <form method="post" action="${pageContext.request.contextPath}/login">
        <input type="text"     name="nombre"   placeholder="Usuario"    required />
        <input type="password" name="password" placeholder="Contraseña" required />
        <button type="submit">Entrar</button>
    </form>
</div>
</body>
</html>