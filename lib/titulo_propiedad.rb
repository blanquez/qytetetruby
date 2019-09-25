#encoding: utf-8


module ModeloQytetet
  class TituloPropiedad
    
    attr_reader:nombre
    attr_writer:hipotecada
    attr_reader:hipotecada
    attr_reader:precioCompra
    attr_reader:alquilerBase
    attr_reader:factorRevalorizacion
    attr_reader:hipotecaBase
    attr_reader:precioEdificar
    attr_reader:numCasas
    attr_reader:numHoteles
    attr_reader:propietario
    attr_writer:propietario
    
    def initialize(nombre, precioCompra, alquilerBase, factorRevalorizacion, hipotecaBase, precioEdificar)
      @nombre=nombre
      @hipotecada=false
      @precioCompra=precioCompra
      @alquilerBase=alquilerBase
      @factorRevalorizacion=factorRevalorizacion
      @hipotecaBase=hipotecaBase
      @precioEdificar=precioEdificar
      @numCasas=0
      @numHoteles=0
      @propietario=nil
    end
    
    
  
    def to_s
      "TITULO DE PROPIEDAD{ Nombre: #{@nombre}, Hipotecada: #{@hipotecada}, PrecioCompra: #{@precioCompra}, AlquilerBase: #{@alquilerBase}, FactorRevalorizacion: #{@factorRevalorizacion}, HipotecaBase: #{@hipotecaBase}, PrecioEdificar: #{@precioEdificar}, NumCasas: #{@numCasas}, NumHoteles: #{@numHoteles} }"
    end
    
    def calcularCosteCancelarHipoteca
      return calcularCosteHipotecar * 1.1
    end
    
    def calcularCosteHipotecar
      return @hipotecaBase + @numCasas * 0.5 * @hipotecaBase + @numHoteles * @hipotecaBase
    end
    
    def calcularImporteAlquiler
      return @costeAlquilerBase + (@numCasas * 0.5 + @numHoteles * 2)
    end
    
    def calcularPrecioVenta
      return @precioCompra + (@numCasas + @numHoteles) * @precioEdificar * @factorRevalorizacion
    end
    
    def cancelarHipoteca
      @hipotecada = false
      return !@hipotecada
    end
    
    def edificarCasa
      @numCasas=@numCasas+1
    end
    
    def edificarHotel
      @numHoteles=@numHoteles+1
      @numCasas=@numCasas-4
    end
    
    def hipotecar
      costeHipoteca = calcularCosteHipotecar
      @hipotecada = true
      return costeHipoteca
    end
    
    def pagarAlquiler
      costeAlquiler = calcularImporteAlquiler
      @propietario.modificarSaldo(-costeAlquiler)
    end
    
    def propietarioEncarcelado
      return @propietario.encarcelado
    end
    
    def tengoPropietario
      return @propietario != nil
    end
  end
end
