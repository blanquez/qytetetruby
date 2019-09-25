# enconding: utf-8

require "singleton"
module ModeloQytetet
  class Dado
    
    include Singleton
    def initialize
      tirar
    end
    
    def tirar
      @valor=rand(6)+1
    end
    
    def to_s
      return "Dado: #{valor}"
    end
    
    attr_reader:valor
    
  end
end
