# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "titulo_propiedad"

module ModeloQytetet
  class Jugador
    
    def initialize(nomb, encar, saldo, carta, casilla, propiedades)
      @encarcelado=encar
      @nombre=nomb
      @saldo=saldo
      @cartaLibertad=carta
      @casillaActual=casilla
      @propiedades=propiedades
    end
    
    def self.nuevo(nombre)
      return Jugador.new(nombre, false, 7500, nil, nil, Array.new )
    end
    
    def to_s
      mensaje = "Jugador: #{@nombre}, saldo: #{@saldo}, capital: #{obtenerCapital}, propiedades: "
      for prop in @propiedades
        mensaje += "#{prop} // "
      end
      return mensaje
    end
    
    attr_reader:cartaLibertad
    attr_reader:casillaActual
    attr_reader:encarcelado
    attr_reader:nombre
    attr_reader:propiedades
    attr_reader:saldo
    attr_writer:cartaLibertad
    attr_writer:casillaActual
    attr_writer:encarcelado
    
    def <=>(otroJugador)            
      otroJugador.obtenerCapital <=> obtenerCapital     
    end
    
    def cancelarHipoteca(titulo)
      cancelar = @saldo > titulo.calcularCosteCancelarHipoteca
      if cancelar
        modificarSaldo(-titulo.calcularCosteCancelarHipoteca)
        titulo.cancelarHipoteca
      end
      return cancelar
    end
    
    def comprarTituloPropiedad
      comprado = false
      costeCompra = @casillaActual.coste
      if (costeCompra < @saldo)
        titulo = @casillaActual.asignarPropietario(@jugadorActual)
        comprado = true
        @propiedades<< titulo
        modificarSaldo(-costeCompra)
      end
      return comprado
    end
    
    def cuantasCasasHotelesTengo
      numero=0
      for i in 0..@propiedades.length-1
        numero = numero + @propiedades[i].numCasas + @propiedades[i].numHoteles
      end
      return numero
    end
    
    def deboPagarAlquiler
      titulo = @casillaActual.titulo
      esDeMiPropiedad = esDeMiPropiedad(titulo)
      if !esDeMiPropiedad
        tienePropietario = titulo.tengoPropietario
        if tienePropietario
          encarcelado = titulo.propietarioEncarcelado
          if !encarcelado
            estaHipotecada = titulo.hipotecado
          end
        end
      end
      return !esDeMiPropiedad && tienePropietario && !encarcelado && !estaHipotecada
    end
    
    def devolverCartaLibertad
      carta = @cartaLibertad
      @cartaLibertad = nil
      return carta
    end
    
    def edificarCasa(titulo)
      if puedoEdificarCasa(titulo)
        costeEdificarCasa=titulo.precioEdificar
        tengoSaldo=tengoSaldo(costeEdificarCasa)
        if tengoSaldo
          titulo.edificarCasa
          modificarSaldo(-costeEdificarCasa)
          edificada=true
        end
      end
      return edificada
    end
    
    def edificarHotel(titulo)
      if puedoEdificarHotel(titulo)
        costeEdificarHotel=titulo.precioEdificar
        tengoSaldo=tengoSaldo(costeEdificarHotel)
        if tengoSaldo
          titulo.edificarHotel
          modificarSaldo(-costeEdificarHotel)
          edificada=true
        end
      end
      return edificada
    end
    
    def estoyEnCalleLibre
      return @casillaActual.propietario == nil
    end
    
    def hipotecarPropiedad(titulo)
      costeHipoteca = titulo.hipotecar
      modificarSaldo(costeHipoteca)
    end
    
    def irACarcel(casilla)
      @casillaActual=casilla
      @encarcelado=true
    end
    
    def modificarSaldo(cantidad)
      @saldo=@saldo+cantidad
    end
    
    def obtenerCapital
      capital = @saldo
      for i in @propiedades
        capital = capital + i.precioCompra + i.precioEdificar * (i.numCasas + i.numHoteles)
      end
      return capital
    end
    
    def obtenerPropiedades(hipotecada)
      prop = Array.new
      for i in 0..@propiedades.length-1
        if(@propiedades[i].hipotecada == hipotecada)
          prop << @propiedades[i]
        end
      end
      return prop
    end
    
    def pagarAlquiler
      costeAlquiler = @casillaActual.pagarAlquiler
      modificarSaldo(-costeAlquiler)
    end
    
    def pagarLibertad(cantidad)
      tengoSaldo = tengoSaldo(cantidad)
      if tengoSaldo
        @encarcelado=false
        modificarSaldo(-cantidad)
      end
    end
    
    def tengoCartaLibertad
      return @cartaLibertad != nil
    end
    
    def venderPropiedad(casilla)
      titulo = casilla.titulo
      eliminarDeMisPropiedades(titulo)
      precioVenta = titulo.calcularPrecioVenta
      modificarSaldo(precioVenta)
    end
    
    def convertirme(fianza)
      return Especulador.copia(self, fianza)
    end
    
    def deboIrACarcel
      return !tengoCartaLibertad
    end
    
    
    def pagarImpuesto
      @saldo=@saldo - (@casillaActual.coste)
    end
    
    def self.copia(jugador)
      return self.new(jugador.nombre, jugador.encarcelado, jugador.saldo, jugador.cartaLibertad, jugador.casillaActual, jugador.propiedades)
    end
    
    def tengoSaldo(cantidad)
      return @saldo>cantidad
    end
    
    def puedoEdificarCasa(titulo)
      return titulo.numCasas < 4
    end
    
    def puedoEdificarHotel(titulo)
      return (titulo.numCasas == 4 && titulo.numHoteles < 4)
    end
    
    private
    
    def eliminarDeMisPropiedades(titulo)
      @propiedades.delete(titulo)
      titulo.propietario = nil
    end
    
    def esDeMiPropiedad(titulo)
      cond=false
      if(@propiedades != nil)
      for i in 0..@propiedades.length
        if @propiedades[i] == titulo
          cond=true
        end
      end
      end
      return cond
    end
   
 
  end
end
