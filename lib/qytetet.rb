#encoding: utf-8

require "singleton"

require_relative "sorpresa"
require_relative "tipo_sorpresa"
require_relative "tablero"
require_relative "casilla"
require_relative "modelo_qytetet"
require_relative "tipo_casilla"
require_relative "titulo_propiedad"
require_relative "dado"
require_relative "jugador"
require_relative "metodo_salir_carcel"
require_relative "estado_juego"
require_relative "especulador"
require_relative "calle"

module ModeloQytetet
  class Qytetet
    
    include Singleton
    
    @@MAX_JUGADORES=4
    @@NUM_SORPRESAS=10
    @@NUM_CASILLAS=20
    @@PRECIO_LIBERTAD=200
    @@SALDO_SALIDA=1000

    def initialize
      @mazo=Array.new
      @cartaActual=nil
      @dado=Dado.instance
      @jugadorActual=nil
      @jugadores=Array.new
      @estado=nil
    end
    
    attr_reader:mazo
    attr_reader:tablero
    attr_reader:cartaActual
    attr_reader:dado
    attr_reader:jugadorActual
    attr_reader:jugadores
    attr_accessor:estado
    
    def actuarSiEnCasillaEdificable
      deboPagar = @jugadorActual.deboPagarAlquiler
      if deboPagar
        @jugadorActual.pagarAlquiler
        if @jugadorActual.saldo <= 0
          @estado = EstadoJuego::ALGUNJUGADORENBANCARROTA
        end
      end
      casilla = obtenerCasillaJugadorActual
      tengoPropietario = casilla.tengoPropietario
      if @estado != EstadoJuego::ALGUNJUGADORENBANCARROTA
        if tengoPropietario
          @estado = EstadoJuego::JA_PUEDEGESTIONAR
        else
          @estado = EstadoJuego::JA_PUEDECOMPRAROGESTIONAR
        end
      end
    end
    
    def actuarSiEnCasillaNoEdificable
      @estado = EstadoJuego::JA_PUEDEGESTIONAR
      casillaActual = @jugadorActual.casillaActual
      if casillaActual.tipo == TipoCasilla::IMPUESTO
        @jugadorActual.pagarImpuesto
      else
        if casillaActual.tipo == TipoCasilla::JUEZ
          encarcelarJugador
        end
        if casillaActual.tipo == TipoCasilla::SORPRESA
          @cartaActual = mazo.delete_at(0)
          @estado = EstadoJuego::JA_CONSORPRESA
        end
      end
    end
    
    def mover(numCasillaDestino)
      casillaInicial = @jugadorActual.casillaActual
      casillaFinal = @tablero.obtenerCasillaNumero(numCasillaDestino)
      @jugadorActual.casillaActual=casillaFinal
      if numCasillaDestino<casillaInicial.numeroCasilla
        @jugadorActual.modificarSaldo(@@SALDO_SALIDA)
      end
      if casillaFinal.soyEdificable
        actuarSiEnCasillaEdificable
      else
        actuarSiEnCasillaNoEdificable
      end
    end
    
    def tirarDado
      @dado.tirar
    end
    
    def getValorDado()
      return @dado.valor
    end
    
    def cancelarHipoteca(numeroCasilla)
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      prop = @jugadorActual.obtenerPropiedades(true)
      cancelar=false
      for p in prop
        if p == casilla.titulo
          cancelar=true
        end
      end
      if cancelar
        cancelar = @jugadorActual.cancelarHipoteca(casilla.titulo)
      end
      @estado = EstadoJuego::JA_PUEDEGESTIONAR
      return cancelar
    end
    
    def comprarTituloPropiedad
      comprado = @jugadorActual.comprarTituloPropiedad
      if comprado
        @estado = EstadoJuego::JA_PUEDEGESTIONAR
      end
      return comprado
    end
    
    def edificarCasa(numeroCasilla)
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      titulo = casilla.titulo
      edificada = @jugadorActual.edificarCasa(titulo)
      if edificada
        @estado = EstadoJuego::JA_PUEDEGESTIONAR
      end
      return edificada
    end
    
    def edificarHotel(numeroCasilla)
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      titulo = casilla.titulo
      edificada = @jugadorActual.edificarHotel(titulo)
      if edificada
        @estado = EstadoJuego::JA_PUEDEGESTIONAR
      end
      return edificada
    end
    
    def hipotecarPropiedad(numeroCasilla)
      casilla = @tablero.obtenerCasillaNumero(numeroCasilla)
      titulo = casilla.titulo
      @jugadorActual.hipotecarPropiedad(titulo)
      @estado = EstadoJuego::JA_PUEDEGESTIONAR
    end
    
    def inicializarJuego(nombres)
      inicializarJugadores(nombres)
      inicializarTablero
      inicializarCartasSorpresa
      salidaJugadores
    end
    
    def intentarSalirCarcel(metodo)
      if metodo == MetodoSalirCarcel::TIRANDODADO
        resultado = tirarDado
        if resultado >= 5
          @jugadorActual.encarcelado = false
        end
      end
      if metodo == MetodoSalirCarcel::PAGANDOLIBERTAD
        @jugadorActual.pagarLibertad(@@PRECIO_LIBERTAD)
      end
      encarcelado = @jugadorActual.encarcelado
      if encarcelado
        @estado = EstadoJuego::JA_ENCARCELADO
      else
        @estado = EstadoJuego::JA_PREPARADO
      end
      return !encarcelado
    end
    
    def jugar
      tirarDado
      casilla=@tablero.obtenerCasillaFinal(@jugadorActual.casillaActual, getValorDado)
      mover(casilla.numeroCasilla)
    end
    
    def obtenerCasillaJugadorActual
      return @jugadorActual.casillaActual
    end
    
    def obtenerCasillasTablero
      return @tablero.casillas
    end
    
    def obtenerPropiedadesJugador
      propiedad=Array.new
      for casilla in @tablero.casillas
        if (casilla.titulo != nil)
          for tit in @jugadorActual.propiedades
            if(casilla.titulo == tit)
              propiedad<<casilla.numeroCasilla
            end
          end
        end
      end
      return propiedad
    end
    
    def obtenerPropiedadesJugadorSegunEstadoHipoteca(estadoHipoteca)
      propiedad=Array.new
      titulos=Array.new
      titulos=@jugadorActual.obtenerPropiedades(estadoHipoteca)
      for casilla in @tablero.casillas
        if (casilla.titulo != nil)
          for tit in titulos
            if(casilla.titulo == tit)
              propiedad<<casilla.numeroCasilla
            end
          end
        end
      end
      return propiedad
    end
    
    def obtenerRanking
      @jugadores=@jugadores.sort
    end
    
    def obtenerSaldoJugadorActual
      return @jugadorActual.saldo
    end
    
    def siguienteJugador
      for i in 0..@jugadores.length
        if (@jugadores[i] == @jugadorActual)
          numjug=i
        end
      end
      if (numjug < @jugadores.length - 1)
        @jugadorActual = @jugadores[numjug+1]
      else
        @jugadorActual = @jugadores[0]
      end
      if (@jugadorActual.encarcelado)
        @estado = EstadoJuego::JA_ENCARCELADOCONOPCIONDELIBERTAD
      else
        @estado = EstadoJuego::JA_PREPARADO
      end
    end
    
    def venderPropiedad(numCasilla)
      casilla = @tablero.obtenerCasillaNumero(numCasilla)
      @jugadorActual.venderPropiedad(casilla)
      @estado = EstadoJuego::JA_PUEDEGESTIONAR
    end
    
    def aplicarSorpresa
      @estado = EstadoJuego::JA_PUEDEGESTIONAR
      if @cartaActual.tipo == TipoSorpresa::SALIRCARCEL
        @jugadorActual.cartaLibertad = @cartaActual
      else
        @mazo<<@cartaActual
        if @cartaActual.tipo == TipoSorpresa::PAGARCOBRAR
          @jugadorActual.modificarSaldo(@cartaActual.valor)
          if @jugadorActual.saldo <= 0
            @estado = EstadoJuego::JA_ALGUNJUGADORENBANCARROTA
          end
        end
        if @cartaActual.tipo == TipoSorpresa::IRACASILLA
          valor = @cartaActual.valor
          casillaCarcel=@tablero.esCasillaCarcel(valor)
          if casillaCarcel
            encarcelarJugador
          else
            mover(valor)
          end
        end
        if @cartaActual.tipo == TipoSorpresa::PORCASAHOTEL
          cantidad = @cartaActual.valor
          numeroTotal = @jugadorActual.cuantasCasasHotelesTengo
          @jugadorActual.modificarSaldo(cantidad*numeroTotal)
          if @jugadorActual.saldo <= 0
            @estado = EstadoJuego::ALGUNJUGADORENBANCARROTA
          end
        end
        if @cartaActual.tipo == TipoSorpresa::PORJUGADOR
          for jug in @jugadores
            if jug != @jugadorActual
              jug.modificarSaldo(-@cartaActual.valor)
            end
            if jug.saldo <= 0
              @estado = EstadoJuego::ALGUNJUGADORENBANCARROTA
            end
            @jugadorActual.modificarSaldo(@cartaActual.valor)
            if @jugadorActual.saldo <= 0
              @estado = EstadoJuego::ALGUNJUGADORENBANCARROTA
            end
          end
        end
        if @cartaActual.tipo == TipoSorpresa::CONVERTIRME
          i=@jugadores.index(@jugadorActual)
          @jugadorActual=@jugadorActual.convertirme(@cartaActual.valor)
          @jugadores[i]=@jugadorActual
        end
      end
    end
    
    private
    
    attr_writer:cartaActual
    
    def encarcelarJugador
      if @jugadorActual.deboIrACarcel
        casillaCarcel = @tablero.carcel
        @jugadorActual.irACarcel(casillaCarcel)
        @estado = EstadoJuego::JA_ENCARCELADO
      else
        carta = @jugadorActual.devolverCartaLibertad
        mazo<<carta
        @estado = EstadoJuego::JA_PUEDEGESTIONAR
      end
    end
    
    def inicializarCartasSorpresa
      @mazo<< Sorpresa.new("Te conviertes en especulador con una fianza de 3000e", 3000, TipoSorpresa::CONVERTIRME)
      @mazo<< Sorpresa.new("Te conviertes en especulador con una fianza de 5000e", 5000, TipoSorpresa::CONVERTIRME)
      @mazo<< Sorpresa.new("Tus inversiones en bolsa han dado sus frutos, ganas 600e", 600, TipoSorpresa::PAGARCOBRAR)
      @mazo<< Sorpresa.new("Te multan con 300e por circular por el carril bus", -300, TipoSorpresa::PAGARCOBRAR)
      @mazo<< Sorpresa.new("Necesitas un respiro, ve a dar un paso por Olympues Height", 16, TipoSorpresa::IRACASILLA)
      @mazo<< Sorpresa.new("La grua se ha llevado tu coche, recogelo en el parking", 15, TipoSorpresa::IRACASILLA)
      @mazo<< Sorpresa.new("Te condenan por fraude en una antigua venta, vas a la carcel", @tablero.carcel.numeroCasilla, TipoSorpresa::IRACASILLA)
      @mazo<< Sorpresa.new("Cedes habitaciones para un evento local, cobras 30e por edificio", 30, TipoSorpresa::PORCASAHOTEL)
      @mazo<< Sorpresa.new("Ha llegado la factura del mobiliario nuevo, pagas 30e por edificio", -30, TipoSorpresa::PORCASAHOTEL)
      @mazo<< Sorpresa.new("Has cerrado una compra-venta rapida ganando 200e", 200, TipoSorpresa::PORJUGADOR)
      @mazo<< Sorpresa.new("Anoche bebiste y perdiste una apuesta, debes pagar 150e a cada jugador", -150, TipoSorpresa::PORJUGADOR)
      @mazo<< Sorpresa.new("Uno de tus contactos te debe un favor y paga tu fianza", 0, TipoSorpresa::SALIRCARCEL)
      @mazo.shuffle
    end
    
    def inicializarJugadores(nombres)
      for nomb in nombres
        @jugadores<< Jugador.nuevo(nomb)
      end
    end
    
    def inicializarTablero
      @tablero=Tablero.new
    end
    
    def salidaJugadores()
      for jug in @jugadores
        jug.casillaActual=@tablero.casillas[0]
      end
      @jugadorActual = @jugadores[rand(@jugadores.length)]
      @estado = EstadoJuego::JA_PREPARADO
    end    
  end
end
