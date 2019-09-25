# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module ModeloQytetet
  class Especulador < Jugador
    
    attr_accessor :fianza
   
    def convertirme(fianza)
      return self
    end
    
    def deboIrACarcel
      return ((super) && !pagarFianza)
    end
    
    def self.copia(jugador, fian)
      e = super(jugador)
      e.fianza=fian
      return e
    end
    
    def to_s
      super + ", fianza=#{@fianza}"
    end
    
    def pagarImpuesto
      @saldo=@saldo - ((@casillaActual.coste) / 2)
    end
    
    def puedoEdificarCasa(titulo)
      return titulo.numCasas < 8
    end
    
    def puedoEdificarHotel(titulo)
      return (titulo.numCasas >= 4 && titulo.numHoteles < 8)
    end
    
    private
    def pagarFianza
      condicion=false
      if(@saldo>=@fianza)
        @saldo=@saldo-@fianza
        condicion=true
      end
      return condicion
    end
  end
end
