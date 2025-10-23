import enemigos.*
import menu.*

object protagonista {

//-------VARIABLES DE MOVIMIENTO-----------
  const fuerzaSalto = 1.8 // Impulso inicial hacia arriba.
  const gravedad = -0.2 // Fuerza que tira hacia abajo en cada tick.
  var velocidadVertical = 0 // Positiva es subiendo, negativa es bajando.
  var movimientoHorizontal = false // Variable de estado para el movimiento.
  var property position= game.at(0, 1)
  var velocidadX = 0
  const friccion = 0.1
//-------VARIABLES DE ATAQUE-----------
  var estaAtacando = false      
  var timerAtaque = 0          
  const duracionAtaque = 15

//------VARIABLES DE VIDA
  var property personajeVida = 200
  var property estaVivo = true

  method personajeVida() = personajeVida

    // --- PROPIEDADES PARA ANIMACIÓN ---
  var property image = "guerrero1Derecha.png"
  var direccionHorizontal = "Derecha"
  var frameActual = 0 // Un contador para ciclar las imágenes.

  //------ASSETS DE ANIMACION
    method obtenerAnimacionCaminar() {
        return ["guerrero2" + direccionHorizontal + ".png", "guerrero3" + direccionHorizontal + ".png", "guerrero4" + direccionHorizontal + ".png"]
    }

    method obtenerAnimacionSalto() {
        return "guerreroSalto" + direccionHorizontal + ".png"
    }

    method obtenerAnimacionAtaque() {
        return ["ataque" + direccionHorizontal + "1.png", "ataque" + direccionHorizontal + "2.png", "ataque" + direccionHorizontal + "3.png", "ataque" + direccionHorizontal + "4.png", "ataque" + direccionHorizontal + "5.png"]
    }

 // Método para configurar el estado inicial del personaje.
    method iniciar() {
        position = game.at(5, 1) // Posición inicial.
        personajeVida = 200
        estaVivo = true
    }
// MÉTODOS DE ACCIÓN (Llamados por el teclado)
// Estos métodos no controlan la imagen ni la física, solo inician una acción.

  method moverDerecha() {
        velocidadX += 0.5
        movimientoHorizontal = true
        direccionHorizontal = "Derecha"
    }

    method moverIzquierda() {
        velocidadX -= 0.5
        movimientoHorizontal = true
        direccionHorizontal = "Izquierda"
    }

  method intentarSaltar() {
        // Solo puede saltar si está en el suelo.
        if (self.estaEnElSuelo()) {
            velocidadVertical = fuerzaSalto
        }
    }


  
  // MÉTODO DE ACTUALIZACIÓN PRINCIPAL (Llamado por game.onTick)
  // Este es el corazón del objeto.
    method actualizar() {
        if (not estaVivo){
            image = "guerreroDerrotado.png"
            //menu.reiniciar()
        }
        else if (self.position().distance(maniqui.position()) < 1) {
            self.restarVida(maniqui.danioDeGolpes())
            //moverderecha()
        }
        else {
            self.aplicarFisicaHorizontal() //aplicar física horizontal (movimiento).
            self.aplicarFisicaVertical() //aplicar física vertical (salto y gravedad).
            self.actualizarAnimacion()
            self.resetearMovimiento() 
        }
    }

    // MÉTODOS AUXILIARES (Ayudan a organizar el código)
    method aplicarFisicaVertical() {
   // Mover el personaje según la velocidad vertical actual.
        position = position.up(velocidadVertical)

    // Si no está en el suelo, la gravedad lo afecta.
        if (not self.estaEnElSuelo()) {
            velocidadVertical += gravedad
        }

        // Control para que no se caiga por debajo del suelo.
        if (position.y() < 0) {
             position = game.at(position.x(), 1)
            velocidadVertical = 0
        }

    }


    method aplicarFisicaHorizontal() {
    const velocidadMaxima = 0.6

    // Limitar velocidad para que no supere el máximo
    if (velocidadX > velocidadMaxima) {
        velocidadX = velocidadMaxima
    } else if (velocidadX < -velocidadMaxima) {
        velocidadX = -velocidadMaxima
    }

    // Mover al personaje según la velocidad
    if (position.x() < -1) {
        position = game.at(-1, position.y())
        velocidadX = 0
    } else if (position.x() > 53) {
        position = game.at(53, position.y())
        velocidadX = 0
    } else { 
        position = position.right(velocidadX)
    }

    // Aplicar fricción (frena gradualmente)
    if (velocidadX > 0) {
        velocidadX -= friccion
        if (velocidadX < 0) velocidadX = 0
    } else if (velocidadX < 0) {
        velocidadX += friccion
        if (velocidadX > 0) velocidadX = 0
    }
}
 

 // --- MÉTODO PARA LA LÓGICA DE ANIMACIÓN ---
    method actualizarAnimacion() {
        // Aumentamos el contador de frames.
        frameActual += 1
        // --- LÓGICA DE ATAQUE  ---
    if (estaAtacando) {
        // 1. Elige la lista de animación correcta (derecha o izquierda).
        const animacion = self.obtenerAnimacionAtaque()
        
        // 2. Calcula cuántos ticks dura cada frame de la animación.
        const ticksPorFrame = duracionAtaque / animacion.size()

        // 3. Calcula el índice del frame actual basándote en el tiempo transcurrido.
        const tiempoPasado = duracionAtaque - timerAtaque
        var frameIndex = (tiempoPasado / ticksPorFrame).floor()
        
        // 4. Medida de seguridad para evitar errores si el cálculo falla.
        frameIndex = frameIndex.min(animacion.size() - 1)
        
        // 5. Muestra la imagen correcta de la lista.
        image = animacion.get(frameIndex)

        // 6. Reduce el timer.
        timerAtaque -= 1
        
        // 7. Si el timer llega a cero, el ataque termina.
        if (timerAtaque <= 0) {
            estaAtacando = false
        }

    } else {
        // Lógica para decidir qué animación usar.
        if (not self.estaEnElSuelo()) {
            // Si está en el aire, usa la imagen de salto.
            image = self.obtenerAnimacionSalto()
        
        } else if (movimientoHorizontal) {
            // Si se está moviendo a la derecha, cicla la animación de caminar.
            const frameIndex = frameActual % self.obtenerAnimacionCaminar().size()
            image = self.obtenerAnimacionCaminar().get(frameIndex)
            
        } else {
            // Si está quieto, muestra la imagen de "idle" (parado).
            image = "guerrero1" + direccionHorizontal + ".png"
        }
      }
    }
 
    method resetearMovimiento() {
        movimientoHorizontal = false
    }

    method estaEnElSuelo() {
        // Consideramos que está en el suelo si su altura es 0 o menos.
     return position.y() <= 1
    }

    method restarVida(cantidadDeDaño){
        if (estaVivo){
	    const nuevaVida = personajeVida - cantidadDeDaño
        personajeVida = 0.max(nuevaVida) //Valor maximo entre 0 y la nueva vida, se asegura que la vida no baje de 0

        if (personajeVida == 0) {
            estaVivo = false
        }
      }
    }

    method atacar(){
        if (not estaAtacando and self.estaEnElSuelo()) {
            estaAtacando = true
            timerAtaque = duracionAtaque 
            movimientoHorizontal = false

        const alcanceAtaque = 2.5// Distancia a la que el ataque conecta.
        const danioAtaque = 25  // El daño que hace el ataque.

        // 2. Comprobar si el maniquí está dentro del alcance.
        if (maniqui.estaVivo() and self.position().distance(maniqui.position()) <= alcanceAtaque) {
        
            // 3. Comprobar que estás mirando en la dirección correcta.
            const mirandoHaciaEnemigo = 
                (direccionHorizontal == "Derecha" and maniqui.position().x() > self.position().x()) or
                (direccionHorizontal == "Izquierda" and maniqui.position().x() < self.position().x())

            if (mirandoHaciaEnemigo) {
                // 4. Si todo se cumple, llama al método del maniquí.
                maniqui.recibirGolpe(danioAtaque)
            }
        }
        }

    }




}