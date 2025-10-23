import wollok.game.*
import mapas.*
import protagonista.*
import enemigos.*

object controlacion {
    method configuracionControles() {
    // CONTROLES DE TECLADO SIMPLIFICADOS
    // Solo le decimos al protagonista QUÉ INTENTAR HACER.
    keyboard.right().onPressDo({ => protagonista.moverDerecha() })
    keyboard.left().onPressDo({ => protagonista.moverIzquierda() })
    keyboard.up().onPressDo({ => protagonista.intentarSaltar() })
    keyboard.q().onPressDo({ => protagonista.atacar() })
    
    // GAME TICK
    // En cada pulso, actualizamos
    game.onTick(50, "actualizacion general", { => protagonista.actualizar() })
    game.onTick(50, "actualizacion maniqui", { => maniqui.actualizar() })
  }
}