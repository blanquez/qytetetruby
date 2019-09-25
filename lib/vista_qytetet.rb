# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "controlador"
require_relative "opcion_menu"
module VistaTextualQytetet
  class VistaQytetet
    
    include ControladorQytetet
    
    attr_reader :controlador
    def initialize
      @controlador = Controlador.instance
    end
    
    def obtenerNombreJugadores
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
      return nombreJugadores
    end
    
    def elegirCasilla(opcionMenu)
      casillasValidas=controlador.obtenerCasillasValidas(opcionMenu)
        if casillasValidas.empty?
            return -1
        else
            listaConvertida=Array.new
            
            for i in casillasValidas
                listaConvertida << i.to_s
            end
            
            puts "Casillas validas:\n"
            
            for s in listaConvertida
                puts s
            end
        end
            return leerValorCorrecto(listaConvertida).to_i
    end
    
    def leerValorCorrecto(valoresCorrectos)
      puts "Introduce un valor: "
      entrada = gets.chomp.to_s
      while !valoresCorrectos.include?(entrada) do
        puts "Valor no valido, introduce uno valido: "
        entrada = gets.chomp.to_s
      end
      return entrada;
    end
    
    def elegirOperacion
      operacionesValidas = @controlador.obtenerOperacionesJuegoValidas

      operacionesValidasStr = Array.new
      for i in operacionesValidas
        operacionesValidasStr << i.to_s
      end

      opciones = ControladorQytetet::OpcionMenu
      
      for i in operacionesValidas
        puts "#{opciones[i]} #{i.to_s}"
      end
      
      return leerValorCorrecto(operacionesValidasStr).to_i
    end
    
    def self.main
      ui = VistaQytetet.new
      salida = ""
      ui.controlador.nombreJugadores = ui.obtenerNombreJugadores
      operacionElegida, casillaElegida = 0
      loop do
        operacionElegida = ui.elegirOperacion
        necesitaElegirCasilla = ui.controlador.necesitaElegirCasilla(operacionElegida)
        if necesitaElegirCasilla 
          casillaElegida = ui.elegirCasilla(operacionElegida)
        end
        if (!necesitaElegirCasilla || casillaElegida >= 0) 
          salida = ui.controlador.realizarOperacion(operacionElegida, casillaElegida)
          puts salida
        end
        break if salida == "FIN DEL JUEGO\n"
      end
    end
  end
  VistaQytetet.main 
end
