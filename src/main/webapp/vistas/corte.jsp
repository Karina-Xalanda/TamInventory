<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>TAMinventary - Realizar Corte</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 20px; }
        .caja-corte { background: white; padding: 2rem; border-radius: 8px; max-width: 500px; margin: auto; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h2 { color: #2980b9; text-align: center; }
        .grupo { margin-bottom: 15px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; color: #555; }
        input { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        .btn-calcular { width: 100%; padding: 12px; background: #2980b9; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; margin-top: 10px; }
        .btn-calcular:hover { background: #1f6391; }
    </style>
</head>
<body>
<div class="caja-corte">
    <h2>Calculadora de Corte</h2>
    <form action="${pageContext.request.contextPath}/corte" method="POST">
        <h3>Inventario de Tamales</h3>
        <div class="grupo">
            <label>Tamales de Hoy:</label>
            <input type="number" name="tamalesHoy" required>
        </div>
        <div class="grupo">
            <label>Tamales de Ayer:</label>
            <input type="number" name="tamalesAyer" required>
        </div>
        <div class="grupo">
            <label>Mermas (Comido + Sobrante + Fiado):</label>
            <input type="number" name="mermas" required>
        </div>

        <hr>
        <h3>Finanzas</h3>
        <div class="grupo">
            <label>Efectivo en Caja (Real):</label>
            <input type="number" name="efectivoReal" step="0.01" required>
        </div>
        <div class="grupo">
            <label>Efectivo Inicial (Fondo):</label>
            <input type="number" name="efectivoInicial" step="0.01" required>
        </div>

        <button type="submit" class="btn-calcular">Procesar Corte Diario</button>
    </form>
</div>
</body>
</html>