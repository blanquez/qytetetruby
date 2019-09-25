#encoding: utf-8

require_relative "qytetet"
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

module ModeloQytetet
   
  class PruebaQytetet
    @@juego = Qytetet.instance
    
    def self.main
      nombreJugadores = Array.new
      puts "Numero de Jugadores: "
      numJug = gets.chomp.to_i
      puts "\n"
      i=0
      while i < numJug
        puts "Jugador #{i+1}: "
        nombreJugadores << gets.chomp
        puts "\n"
        i= i+1
      end
      
      @@juego.inicializarJuego(nombreJugadores)
       puts "#{ @@juego.jugadorActual} \n"
        @@juego.siguienteJugador
       puts "#{ @@juego.jugadorActual} \n\n"
        
       puts "-------------MENU PRUEBAS--------------\n"
       puts "Elegir prueba:\n"
       puts "1. Mover\n"
       puts "2. Asignar propiedad a jugador y que otro pague alquiler al pasar\n"
       puts "3. Sorpresas\n"
       puts "4. Hipotecar, cancelar hipoteca, vender y edificar\n"
       puts "5. Salir de la carcel\n"
       puts "6. Ranking\n\n"
       
       num = gets.chomp.to_i
       case(num)          
       when 1
                @@juego.jugar
               puts "El jugador ha jugado y se ha movido a la casilla #{@@juego.jugadorActual.casillaActual.to_s}\n" 
                @@juego.mover(3)
               puts "El jugador ha jugado y se ha movido a la casilla  #{@@juego.jugadorActual.casillaActual.to_s} \n" 
                @@juego.mover(5)
               puts "El jugador ha jugado y se ha movido a la casilla #{@@juego.jugadorActual.casillaActual.to_s}\n" 
                @@juego.jugadorActual.comprarTituloPropiedad
               for prop in @@juego.jugadorActual.propiedades
                    puts "El jugador ha comprado la casilla actual: #{prop.to_s}\n" 
               end
               puts  " #{@@juego.jugadorActual}\n" 
                @@juego.mover(7)
               puts ("El jugador ha jugado y se ha movido a la casilla #{@@juego.jugadorActual.casillaActual.to_s}\n") 
                @@juego.mover(10)
               puts "El jugador ha jugado y se ha movido a la casilla #{@@juego.jugadorActual.casillaActual.to_s}\n" 
               puts "El jugador ha entrado a la carcel: #{@@juego.jugadorActual.encarcelado}\n" 
                @@juego.mover(13)
               puts "El jugador ha jugado y se ha movido a la casilla #{@@juego.jugadorActual.casillaActual.to_s}\n" 
               puts "El jugador ha entrado a la carcel: #{@@juego.jugadorActual.encarcelado}\n"
        when 2
               puts  "#{@@juego.jugadorActual}\n" 
                @@juego.mover(4)
                @@juego.comprarTituloPropiedad
               for prop in @@juego.jugadorActual.propiedades
                    puts "El jugador ha comprado la casilla actual: #{prop.to_s}\n" 
               end
               puts "#{@@juego.jugadorActual}\n" 
                @@juego.siguienteJugador()
               puts "#{@@juego.jugadorActual}\n" 
                @@juego.mover(4)
               puts "#{@@juego.jugadorActual}\n"
        when 3
               puts "#{@@juego.jugadorActual}\n" 
                @@juego.mover(3)
                @@juego.aplicarSorpresa
               puts "#{@@juego.jugadorActual}\n" 
                @@juego.mover(3)
                @@juego.aplicarSorpresa
               puts "#{@@juego.jugadorActual.casillaActual}\n" 
                @@juego.mover(3)
                @@juego.mover(16)
                @@juego.comprarTituloPropiedad 
                @@juego.edificarCasa(16)
                @@juego.aplicarSorpresa 
               puts "#{@@juego.jugadorActual}\n" 
                @@juego.mover(3)
               puts "#{@@juego.jugadores[0]}\n" 
                @@juego.aplicarSorpresa
               puts "#{@@juego.jugadorActual}\n" 
               puts "#{@@juego.jugadores[0]}\n" 
                @@juego.mover(3)
                @@juego.aplicarSorpresa 
                @@juego.mover(13)
               puts "#{@@juego.jugadorActual.encarcelado}\n" 
       when 4
                @@juego.mover(16)
               puts "#{@@juego.jugadorActual}  #{@@juego.jugadorActual.casillaActual.to_s}\n" 
                @@juego.comprarTituloPropiedad
               puts "#{@@juego.jugadorActual}  #{@@juego.jugadorActual.casillaActual.to_s}\n" 
                @@juego.edificarCasa(16)
                @@juego.edificarHotel(16)
               puts "#{@@juego.jugadorActual}  #{@@juego.jugadorActual.casillaActual.to_s}\n" 
                @@juego.hipotecarPropiedad(16)
               puts "#{@@juego.jugadorActual}  #{@@juego.jugadorActual.casillaActual.to_s}\n" 
                @@juego.cancelarHipoteca(16)
               puts "#{@@juego.jugadorActual}  #{@@juego.jugadorActual.casillaActual.to_s}\n" 
                @@juego.venderPropiedad(16)
               puts "#{@@juego.jugadorActual}  #{@@juego.jugadorActual.casillaActual.to_s}\n" 
       when 5
                @@juego.mover(13)
               puts "#{@@juego.jugadorActual.encarcelado}\n" 
                @@juego.intentarSalirCarcel(MetodoSalirCarcel::TIRANDODADO)
               puts "#{@@juego.jugadorActual.encarcelado}\n" 
                @@juego.intentarSalirCarcel(MetodoSalirCarcel::TIRANDODADO)
               puts "#{@@juego.jugadorActual.encarcelado}\n" 
                @@juego.intentarSalirCarcel(MetodoSalirCarcel::TIRANDODADO)
               puts "#{@@juego.jugadorActual.encarcelado}\n" 
                @@juego.intentarSalirCarcel(MetodoSalirCarcel::PAGANDOLIBERTAD)
               puts "#{@@juego.jugadorActual.encarcelado}\n" 
       when 6
        20.times do |i|
          puts("Turno #{i}:\n")
          @@juego.jugar
          if(@@juego.estado == EstadoJuego::JA_PUEDECOMPRAROGESTIONAR)
            @@juego.comprarTituloPropiedad
          end
          puts(@@juego.jugadores)
          puts("\n")
          @@juego.siguienteJugador()
        end
        @@juego.obtenerRanking
        for i in @@juego.jugadores
          puts i
        end
    end
    
    def self.getMayorCero
      @mazocero = Array.new
      
      for sorpresa in @@juego.mazo
        if sorpresa.valor > 0
          @mazocero<<sorpresa
        end
      end
      return @mazocero
    end 
    
    def self.getIrACasilla
      @mazocasilla = Array.new
      
      for sorpresa in @@juego.mazo
        if sorpresa.tipo == TipoSorpresa::IRACASILLA
          @mazocasilla<<sorpresa
        end
      end
      
      return @mazocasilla
    end
    
    def self.getTipoEspecifico(tipo)
      @mazotipo = Array.new
      for sorpresa in @@juego.mazo
        if sorpresa.tipo == tipo
          @mazotipo<<sorpresa
        end
      end
      return @mazotipo
    end
    
  end
  
  PruebaQytetet.main
  
end
end
