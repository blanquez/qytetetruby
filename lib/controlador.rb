# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require "singleton"
require_relative "qytetet"
require_relative "opcion_menu"
module ControladorQytetet
  class Controlador
    
    include Singleton
    include ModeloQytetet
    
    attr_writer:nombreJugadores
    
    def initialize
      @modelo = Qytetet.instance
    end
    
    def obtenerOperacionesJuegoValidas
      operacionesValidas = Array.new
      if @modelo.jugadorActual == nil 
        operacionesValidas << OpcionMenu.index(:INICIARJUEGO)
      else 
        case @modelo.estado
        when EstadoJuego::JA_PREPARADO
          operacionesValidas<<OpcionMenu.index(:JUGAR)
          operacionesValidas<<OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          operacionesValidas<<OpcionMenu.index(:MOSTRARJUGADORES)
          operacionesValidas<<OpcionMenu.index(:MOSTRARTABLERO)
          operacionesValidas<<OpcionMenu.index(:TERMINARJUEGO)
        when EstadoJuego::JA_PUEDEGESTIONAR
          operacionesValidas<<OpcionMenu.index(:PASARTURNO)
          operacionesValidas<<OpcionMenu.index(:VENDERPROPIEDAD)
          operacionesValidas<<OpcionMenu.index(:HIPOTECARPROPIEDAD)
          operacionesValidas<<OpcionMenu.index(:CANCELARHIPOTECA)
          operacionesValidas<<OpcionMenu.index(:EDIFICARCASA)
          operacionesValidas<<OpcionMenu.index(:EDIFICARHOTEL)
          operacionesValidas<<OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          operacionesValidas<<OpcionMenu.index(:MOSTRARJUGADORES)
          operacionesValidas<<OpcionMenu.index(:MOSTRARTABLERO)
          operacionesValidas<<OpcionMenu.index(:TERMINARJUEGO)
                    
        when EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
          operacionesValidas<<OpcionMenu.index(:INTENTARSALIRCARCELTIRANDODADO)
          operacionesValidas<<OpcionMenu.index(:INTENTARSALIRCARCELPAGANDOLIBERTAD)
          operacionesValidas<<OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          operacionesValidas<<OpcionMenu.index(:MOSTRARJUGADORES)
          operacionesValidas<<OpcionMenu.index(:MOSTRARTABLERO)
          operacionesValidas<<OpcionMenu.index(:TERMINARJUEGO)
                    
        when EstadoJuego::JA_PUEDECOMPRAROGESTIONAR
          operacionesValidas<<OpcionMenu.index(:PASARTURNO)
          operacionesValidas<<OpcionMenu.index(:COMPRARTITULOPROPIEDAD)
          operacionesValidas<<OpcionMenu.index(:VENDERPROPIEDAD)
          operacionesValidas<<OpcionMenu.index(:HIPOTECARPROPIEDAD)
          operacionesValidas<<OpcionMenu.index(:CANCELARHIPOTECA)
          operacionesValidas<<OpcionMenu.index(:EDIFICARCASA)
          operacionesValidas<<OpcionMenu.index(:EDIFICARHOTEL)
          operacionesValidas<<OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          operacionesValidas<<OpcionMenu.index(:MOSTRARJUGADORES)
          operacionesValidas<<OpcionMenu.index(:MOSTRARTABLERO)
          operacionesValidas<<OpcionMenu.index(:TERMINARJUEGO)
                    
        when EstadoJuego::JA_CONSORPRESA
          operacionesValidas<<OpcionMenu.index(:APLICARSORPRESA)
          operacionesValidas<<OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          operacionesValidas<<OpcionMenu.index(:MOSTRARJUGADORES)
          operacionesValidas<<OpcionMenu.index(:MOSTRARTABLERO)
          operacionesValidas<<OpcionMenu.index(:TERMINARJUEGO)
                    
        when EstadoJuego::ALGUNJUGADORENBANCARROTA
          operacionesValidas<<OpcionMenu.index(:OBTENERRANKING)
          operacionesValidas<<OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          operacionesValidas<<OpcionMenu.index(:MOSTRARJUGADORES)
          operacionesValidas<<OpcionMenu.index(:MOSTRARTABLERO)
          operacionesValidas<<OpcionMenu.index(:TERMINARJUEGO)
                    
        when EstadoJuego::JA_ENCARCELADO
          operacionesValidas<<OpcionMenu.index(:PASARTURNO)
          operacionesValidas<<OpcionMenu.index(:MOSTRARJUGADORACTUAL)
          operacionesValidas<<OpcionMenu.index(:MOSTRARJUGADORES)
          operacionesValidas<<OpcionMenu.index(:MOSTRARTABLERO)
          operacionesValidas<<OpcionMenu.index(:TERMINARJUEGO)
                    
        end
      end
      operacionesValidas
    end
    
    def necesitaElegirCasilla(opcionMenu)
      opcion = OpcionMenu[opcionMenu]
      if (opcion == :HIPOTECARPROPIEDAD) || (opcion == :CANCELARHIPOTECA) ||
          (opcion == :EDIFICARCASA) || (opcion == :EDIFICARHOTEL) || (opcion == :VENDERPROPIEDAD)
        return true
      end
      return false
    end
    
    def obtenerCasillasValidas(opcionMenu)
      opcion = OpcionMenu[opcionMenu]
      casillasValidas = Array.new
      case opcion 
      when :CANCELARHIPOTECA
        casillasValidas = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(true) 
      when :HIPOTECARPROPIEDAD
        casillasValidas = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false)
      when :EDIFICARHOTEL
        casillasValidas = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false)
      when :EDIFICARCASA
        casillasValidas = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false)
      when :VENDERPROPIEDAD
        casillasValidas = @modelo.obtenerPropiedadesJugadorSegunEstadoHipoteca(false)
      end
      return casillasValidas
    end
    
    def realizarOperacion(opcionElegida, casillaElegida)
      opcion = OpcionMenu[opcionElegida]
      salida = ""
      case opcion
      when :INICIARJUEGO
        @modelo.inicializarJuego(@nombreJugadores)
        salida += "***********************JUEGO INICIADO***********************\n"
      when :JUGAR
        @modelo.jugar
        salida += "Te ha salido un " + @modelo.getValorDado.to_s
        salida += " por lo que has caido en la casilla " + @modelo.obtenerCasillaJugadorActual.to_s + "\n"
      when :APLICARSORPRESA
        salida += @modelo.cartaActual.to_s
        @modelo.aplicarSorpresa
      when :INTENTARSALIRCARCELPAGANDOLIBERTAD
        if @modelo.intentarSalirCarcel(MetodoSalirCarcel::PAGANDOLIBERTAD)
          salida += "El jugador actual intenta salir de la carcel y lo consigue"
        else 
          salida += "El jugador actual intenta salir de la carcel y no lo consigue (ya no puede intentarlo mas en su turno)"
        end
      when :INTENTARSALIRCARCELTIRANDODADO
        if @modelo.intentarSalirCarcel(MetodoSalirCarcel::TIRANDODADO)
          salida += "El jugador actual intenta salir de la carcel y lo consigue"
        else 
          salida += "El jugador actual intenta salir de la carcel y no lo consigue (ya no puede intentarlo mas en su turno)"
        end
      when :COMPRARTITULOPROPIEDAD
        if !(@modelo.comprarTituloPropiedad()) 
          salida += "No has podido comprar el titulo de propiedad\n"
        else 
          salida += "La casilla actual ahora es tuya\n"
        end
      when :HIPOTECARPROPIEDAD
        @modelo.hipotecarPropiedad(casillaElegida)
        salida += "Propiedad en casilla #{casillaElegida} hipotecada\n"
      when :CANCELARHIPOTECA
        @modelo.cancelarHipoteca(casillaElegida)
        salida += "Hipoteca cancelada\n"
      when :EDIFICARCASA
        if (@modelo.edificarCasa(casillaElegida)) 
          salida += "Casa edificada\n"
        else 
          salida += "No has podido edificar la casa\n"
        end
      when :EDIFICARHOTEL
        if (@modelo.edificarHotel(casillaElegida)) 
          salida += "Hotel edificado\n"
        else 
          salida += "No has podido edificar el hotel\n"
        end

      when :VENDERPROPIEDAD
        @modelo.venderPropiedad(casillaElegida)
        salida += "Propiedad vendida\n"
      when :PASARTURNO
        @modelo.siguienteJugador
        salida += "Turno siguiente\n"
      when :OBTENERRANKING
        @modelo.obtenerRanking
        for j in @modelo.jugadores
          salida += j.to_s
          salida += "\n"
        end
      when :TERMINARJUEGO
        salida += "FIN DEL JUEGO\n"
      when :MOSTRARJUGADORACTUAL
        salida += "==============================================="
        salida += "\nJUGADOR ACTUAL ---->" + @modelo.jugadorActual.to_s
        salida += "\n===============================================\n"
      when :MOSTRARJUGADORES
        for j in @modelo.jugadores
          salida += j.to_s
          salida += "\n"
        end
      when :MOSTRARTABLERO
        salida += @modelo.tablero.to_s + "\n"      
      end  
        return salida
    end
  end
end
