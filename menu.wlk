import juego.*
import wollok.game.*
import mapas.*
import protagonista.*
import enemigos.*
import controlacion.*


object menu {
  const fondo = "menuinicio.png"
  const ancho = 40
  const alto = 23
  var reinicio = false
  var listenerAgregado = false

  method iniciarJuego(){
    game.clear()
    game.height(alto)
    game.width(ancho)
    self.iniciarMenu()
  }

  method reiniciar() {
    reinicio = true
    listenerAgregado = false
    self.iniciarMenu()
  }


  method iniciarMenu(){
    if (reinicio){
      game.clear()
    }

    game.boardGround(fondo)
    game.addVisual(tituloJuego)
    game.addVisual(instrucciones)

    if (not listenerAgregado) {
      listenerAgregado = true
      keyboard.enter().onPressDo{
        self.cerrarMenu()
        mapa.siguienteMapa()
        controlacion.configuracionControles()
        listenerAgregado = false // permite reiniciar el listener en otro momento si hace falta
      }
    }
  }


  method cerrarMenu() {
    game.removeVisual(tituloJuego)
    game.removeVisual(instrucciones)
  }

}
object tituloJuego{
    method position()= game.at(18,15)
    method image() = "caballero.png"
}
object instrucciones{
  method position()= game.at(20,4)
  method image() = "inicio.png"
}
