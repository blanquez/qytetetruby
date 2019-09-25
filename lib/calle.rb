# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module ModeloQytetet
  class Calle < Casilla
    def initialize(numeroCasilla, titulo)
      super(numeroCasilla, titulo.precioCompra, TipoCasilla::CALLE)
      @titulo=titulo
    end
    
    def to_s
      return "CALLE=NumCasilla: #{@numeroCasilla}, Coste: #{@coste}, Titulo: #{@titulo} \n"
    end
    
   
    attr_writer:titulo
    
    public
    
    def asignarPropietario(jugador)
      @titulo.propietario=jugador
      return @titulo
    end
    
    def tengoPropietario
      return @titulo.tengoPropietario
    end
    
    attr_reader:titulo
    
    def soyEdificable
      return true
    end
  end
end
