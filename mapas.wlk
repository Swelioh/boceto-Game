import wollok.game.*
import protagonista.*
import enemigos.*

// 1. PRIMERO LAS CLASES (los "moldes")
class Nivel {
  const numero = 0
  var property position = game.at(20,15)
  method image() = "nivel" + numero + ".png"
}

class TipoMapa {
  const nivel = new Nivel(numero = 0)
  const fondo = fondoNivel
  const listaEnemigos = []
  const musica = null
  method iniciar() {
    protagonista.iniciar()
    game.addVisual(fondo)
    game.addVisual(protagonista)
    game.addVisual(nivel)
    game.addVisual(maniqui)
    
    if (musica != null) {
            musica.shouldLoop(true)// Le decimos que se repita
            musica.volume(0.15)
            musica.play()           // Lo reproducimos
        }
    

    game.schedule(5000, { => game.removeVisual(nivel) })
    //enemigos.spawnearenemigos(listaEnemigos)
  }
}
class fondoNivel{
  var property position = game.at(0,0)
  var imagen="bosque.png"
  method image()=imagen

}

// 2. LUEGO LAS CONSTANTES (los "objetos" creados a partir de los moldes)
const bosque = new TipoMapa(nivel = new Nivel(numero = 1), fondo = new fondoNivel(imagen="Summer1.png"), listaEnemigos = [maniqui],musica = game.sound(""))
const desierto = new TipoMapa(nivel = new Nivel(numero = 2), fondo = new fondoNivel(imagen="arena.png"), listaEnemigos = [])
const agua = new TipoMapa(nivel = new Nivel(numero = 3), fondo = new fondoNivel(imagen="agua.png"), listaEnemigos = [])
const nevado = new TipoMapa(nivel = new Nivel(numero = 4), fondo = new fondoNivel(imagen="nevada.png"), listaEnemigos = [])
const mapaFinal = new TipoMapa(nivel = new Nivel(numero = 5), fondo = new fondoNivel(imagen="mapaFinal.png"), listaEnemigos = [])



// 3. AL FINAL DE TODO, EL OBJETO PRINCIPAL QUE USA LO ANTERIOR
object mapa {
  var niveles=[bosque,desierto,nevado,agua,mapaFinal]
  var indiceNivel=0
  var nuevoMapa = bosque
  method reiniciar(){
    niveles=[bosque,desierto,nevado,agua,mapaFinal]
  }

  method siguienteMapa() {
    nuevoMapa=niveles.first()
    niveles.remove(nuevoMapa)
    nuevoMapa.iniciar()
  }
  
  
  
  
  
  
  /*method reiniciaJuego(){
    indiceNivel=0
    enemigos.reinciar
    self.mapaActual().iniciar()
  }*/

}
