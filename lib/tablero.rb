#encoding: utf-8


module ModeloQytetet
  class Tablero
    def initialize
      inicializar
    end
    
    attr_reader:casillas
    attr_reader:carcel
    
    def to_s
      devolver = "TABLERO: \n"
      casilla = 0
      for casilla in 0...@casillas.length
        devolver = devolver + @casillas[casilla].to_s
      end
      devolver = devolver + "CARCEL: #{@carcel.numeroCasilla}"
    end
    
    def esCasillaCarcel(numeroCasilla)
      return @casillas[numeroCasilla]==@carcel
    end
    
    def obtenerCasillaFinal(casilla, desplazamiento)
      numero=(casilla.numeroCasilla+desplazamiento)%@casillas.length
      return @casillas[numero]
    end
    
    def obtenerCasillaNumero(numeroCasilla)
      return @casillas[numeroCasilla]
    end
    
    private
    
    def inicializar
      @casillas=Array.new
      @carcel=Casilla.new(10, 0, TipoCasilla::CARCEL)
      @casillas<<Casilla.new(0, 0, TipoCasilla::SALIDA)
      @casillas<<Calle.new(1, TituloPropiedad.new("El Faro", 500, 50, 0.1, 150, 250))
      @casillas<<Calle.new(2, TituloPropiedad.new("Distrito Medico", 550, 55, 0, 200, 300))
      @casillas<<Casilla.new(3, 0, TipoCasilla::SORPRESA)
      @casillas<<Calle.new(4, TituloPropiedad.new("Neptunes Bounty", 600, 60, -0.5, 250, 350))
      @casillas<<Calle.new(5, TituloPropiedad.new("Fountain Futuristics", 650, 65, 0.05, 300, 400))
      @casillas<<Calle.new(6, TituloPropiedad.new("Arcadia", 700, 70, 0.15, 350, 450))
      @casillas<<Casilla.new(7, 150, TipoCasilla::IMPUESTO)
      @casillas<<Calle.new(8, TituloPropiedad.new("Feria Agricola", 750, 75, 0.2, 400, 500))
      @casillas<<Casilla.new(9, 0, TipoCasilla::SORPRESA)
      @casillas<<@carcel
      @casillas<<Calle.new(11, TituloPropiedad.new("Fort Frolic", 800, 80, 0.1, 500, 550))
      @casillas<<Calle.new(12, TituloPropiedad.new("Hephaestus", 850, 85, -0.1, 600, 600))
      @casillas<<Casilla.new(13, 0, TipoCasilla::JUEZ)
      @casillas<<Calle.new(14, TituloPropiedad.new("Control Central", 900, 90, -0.2, 700, 650))
      @casillas<<Casilla.new(15, 0, TipoCasilla::PARKING)
      @casillas<<Calle.new(16, TituloPropiedad.new("Olympus Heights", 950, 95, 0, 800, 700))
      @casillas<<Calle.new(17, TituloPropiedad.new("Plaza Apollo", 975, 97, 0.2, 900, 725))
      @casillas<<Casilla.new(18, 0, TipoCasilla::SORPRESA)
      @casillas<<Calle.new(19, TituloPropiedad.new("Point Prometheus", 1000, 100, 0.15, 1000, 750))
    end    
  end
end
