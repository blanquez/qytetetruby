#encoding: utf-8


module ModeloQytetet
  class Sorpresa
    def initialize(texto,valor,tipo)
      @texto=texto
      @valor=valor
      @tipo=tipo
    end
    
    attr_reader:texto
    attr_reader:valor
    attr_reader:tipo
    
    def to_s()
      "SORPRESA \n Texto: #{@texto} \n Valor: #{@valor} \n Tipo: #{@tipo}"
    end
  end
end
