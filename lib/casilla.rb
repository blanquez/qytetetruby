#encoding: utf-8


module ModeloQytetet
  class Casilla
    def initialize(numeroCasilla, coste, tipo)
      @numeroCasilla=numeroCasilla
      @coste=coste
      @tipo=tipo
      @titulo=nil
    end
    
    attr_writer:coste
    
    def to_s
      return "CASILLA=NumCasilla: #{@numeroCasilla}, Coste: #{@coste}, Tipo: #{@tipo} \n"
    end
    
    def soyEdificable
      return false
    end
    
    attr_reader:titulo
    attr_reader:numeroCasilla
    attr_reader:coste
    attr_reader:tipo
  end
end
