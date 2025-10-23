import controlacion.*
import wollok.game.*
import mapas.*


object enemigos {
  var contador = 0
  method contadorEnemigos() = contador
  method incrementarContador() {
    contador += 1
    if(contador>10){
        mapa.siguienteMapa()  
    }
  }
  method disminuirContador() {
    contador -= 1
  }
}
object maniqui{ 
    var property position = game.at(10, 1)
    var property danioDeGolpes = 1000
    var property image = "maniquiQuieto.png"
    var property vida= 70
    var property estaVivo = true

    method vida() = vida

    const imagenReposo = "maniquiQuieto.png"
    const animacionGolpeado = ["maniquiGolpeado1.png", "maniquiGolpeado2.png","maniquiGolpeado3.png"]
    const imagenDerrotado = "maniquiroto.png"

    var timerImpacto = 0
    const duracionImpacto = 15

    method danioDeGolpes()= danioDeGolpes

    method recibirGolpe(danio) {
        if (estaVivo) {
            vida -= danio
            timerImpacto = duracionImpacto

            if (vida <= 0) {
                vida = 0
                self.morir()
            }
        }
    }

    method morir() {
        estaVivo = false
        image = imagenDerrotado
        enemigos.incrementarContador()
        position = game.at(-999, -999)
        game.removeVisual(self)
    }

    method actualizar() {
        if (timerImpacto > 0) {
            timerImpacto -= 1

            const ticksPorFrame = duracionImpacto / animacionGolpeado.size()
            const tiempoPasado = duracionImpacto - timerImpacto
            var frameIndex = (tiempoPasado / ticksPorFrame).floor()
            frameIndex = frameIndex.min(animacionGolpeado.size() - 1)

            image = animacionGolpeado.get(frameIndex)

            if (timerImpacto == 0 && estaVivo) {
                image = imagenReposo
            }
        }
    }
}