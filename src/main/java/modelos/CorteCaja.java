package modelos;

import java.util.Date;

public class CorteCaja {
    private String id;
    private Date fecha;
    private double efectivoInicial;
    private double efectivoEsperado;
    private double efectivoReal;
    private String notas;

    public CorteCaja() {
        this.fecha = new Date();
    }

    public CorteCaja(double efectivoInicial) {
        this.fecha = new Date();
        this.efectivoInicial = efectivoInicial;
    }

    public double calcularEfectivoEsperado(double totalVentas, double totalGastos) {
        this.efectivoEsperado = efectivoInicial + totalVentas - totalGastos;
        return this.efectivoEsperado;
    }

    public double validarDiferencia() {
        return efectivoReal - efectivoEsperado;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }
    public double getEfectivoInicial() { return efectivoInicial; }
    public void setEfectivoInicial(double efectivoInicial) { this.efectivoInicial = efectivoInicial; }
    public double getEfectivoEsperado() { return efectivoEsperado; }
    public void setEfectivoEsperado(double efectivoEsperado) { this.efectivoEsperado = efectivoEsperado; }
    public double getEfectivoReal() { return efectivoReal; }
    public void setEfectivoReal(double efectivoReal) { this.efectivoReal = efectivoReal; }
    public String getNotas() { return notas; }
    public void setNotas(String notas) { this.notas = notas; }
}
