// =============================================================
// Vínculo — "Plática del Día"
// Backend completo con Apple Foundation Models (Apple Intelligence)
// iOS 18.4+ / Xcode 16.4+
//
// Archivos de este módulo:
//   1. PlaticaSession.swift         — Motor de IA (Foundation Models)
//   2. PlaticaViewModel.swift       — Estado observable (MVVM)
//   3. PlaticaDelDiaView.swift      — UI principal
//   4. PlaticaComponents.swift      — Subvistas reutilizables
//   5. PlaticaModels.swift          — Tipos de datos compartidos
// =============================================================


// ─────────────────────────────────────────────────────────────
// MARK: 1 · PlaticaModels.swift
// Tipos de datos compartidos por todo el módulo
// ─────────────────────────────────────────────────────────────

/*

import Foundation
import SwiftUI

// Nivel del niño — determina el prompt del sistema
enum NivelVinculo: Int, Codable {
    case uno   = 1   // Nula comunicación
    case dos   = 2   // Habla poco
    case tres  = 3   // Habla bien, dificultad social
}

// Mensaje individual en la conversación
struct MensajePlatica: Identifiable, Equatable {
    let id: UUID
    let rol: RolMensaje
    let texto: String
    let timestamp: Date
    var emojiReaccion: String?   // el niño puede reaccionar con emoji

    init(rol: RolMensaje, texto: String, emojiReaccion: String? = nil) {
        self.id = UUID()
        self.rol = rol
        self.texto = texto
        self.timestamp = Date()
        self.emojiReaccion = emojiReaccion
    }
}

enum RolMensaje: Equatable {
    case vinculo       // IA
    case nino          // usuario
    case sistema       // mensajes de estado (no visibles en chat)
}

// Opciones rápidas que Vínculo genera para facilitar respuestas
struct OpcionRapida: Identifiable {
    let id = UUID()
    let texto: String
    let emoji: String
}

// Estado de la sesión de plática
enum EstadoPlatica: Equatable {
    case inicial
    case cargando           // modelo inicializando
    case activa             // conversación en curso
    case esperandoRespuesta // IA generando respuesta
    case completada         // 3 turnos finalizados
    case error(String)
}

// Resultado al finalizar la sesión
struct ResultadoPlatica {
    let turnosCompletados: Int
    let duracionSegundos: TimeInterval
    let palabrasUsadas: Int
    let puntosGanados: Int
    let insignia: String?
}

// Tema de la plática del día (rotativo)
struct TemaPlatica {
    let titulo: String
    let contexto: String         // contexto breve para el prompt del sistema
    let opcionesIniciales: [OpcionRapida]
}

extension TemaPlatica {
    // Banco de temas para Nivel 2
    static let temasNivel2: [TemaPlatica] = [
        TemaPlatica(
            titulo: "Mi día de hoy",
            contexto: "El niño va a hablar sobre lo que hizo hoy.",
            opcionesIniciales: [
                OpcionRapida(texto: "Jugué afuera", emoji: "⚽"),
                OpcionRapida(texto: "Vi televisión", emoji: "📺"),
                OpcionRapida(texto: "Estuve con mi familia", emoji: "👨‍👩‍👦"),
                OpcionRapida(texto: "Descansé en casa", emoji: "🏠")
            ]
        ),
        TemaPlatica(
            titulo: "Mi animal favorito",
            contexto: "El niño va a hablar sobre su animal favorito y por qué le gusta.",
            opcionesIniciales: [
                OpcionRapida(texto: "Un perro", emoji: "🐶"),
                OpcionRapida(texto: "Un gato", emoji: "🐱"),
                OpcionRapida(texto: "Un dinosaurio", emoji: "🦕"),
                OpcionRapida(texto: "Un delfín", emoji: "🐬")
            ]
        ),
        TemaPlatica(
            titulo: "Mi comida favorita",
            contexto: "El niño va a hablar sobre la comida que más le gusta.",
            opcionesIniciales: [
                OpcionRapida(texto: "Pizza", emoji: "🍕"),
                OpcionRapida(texto: "Tacos", emoji: "🌮"),
                OpcionRapida(texto: "Helado", emoji: "🍦"),
                OpcionRapida(texto: "Espagueti", emoji: "🍝")
            ]
        ),
        TemaPlatica(
            titulo: "Un superpoder",
            contexto: "El niño va a imaginar qué superpoder le gustaría tener.",
            opcionesIniciales: [
                OpcionRapida(texto: "Volar", emoji: "🦸"),
                OpcionRapida(texto: "Ser invisible", emoji: "👻"),
                OpcionRapida(texto: "Super velocidad", emoji: "⚡"),
                OpcionRapida(texto: "Hablar con animales", emoji: "🐾")
            ]
        )
    ]

    // Tema del día: rotativo por día del año
    static var temaDehoy: TemaPlatica {
        let indice = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 0
        return temasNivel2[indice % temasNivel2.count]
    }
}


// ─────────────────────────────────────────────────────────────
// MARK: 2 · PlaticaSession.swift
// Motor principal — Apple Foundation Models
// Requiere: import FoundationModels (iOS 18.4+, Apple Intelligence)
// ─────────────────────────────────────────────────────────────

import Foundation
import FoundationModels  // Apple Intelligence — Foundation Models framework

// Actor de sesión: gestiona el ciclo de vida del modelo de lenguaje
@globalActor
actor PlaticaModelActor {
    static let shared = PlaticaModelActor()
}

// Protocolo para facilitar pruebas unitarias (mockable)
protocol PlaticaSessionProtocol {
    func iniciar(nivel: NivelVinculo, tema: TemaPlatica) async throws
    func enviarMensaje(_ texto: String) async throws -> String
    func generarOpcionesRapidas(contexto: String) async throws -> [OpcionRapida]
    func finalizar() async
}

// ──────────────────────────────────
// Implementación real con Foundation Models
// ──────────────────────────────────
@PlaticaModelActor
final class PlaticaSession: PlaticaSessionProtocol {

    // Sesión de lenguaje de Apple Intelligence
    private var session: LanguageModelSession?
    private var nivel: NivelVinculo = .dos
    private var tema: TemaPlatica = .temaDehoy
    private var historialContexto: String = ""
    private var turnoActual: Int = 0
    static let maxTurnos = 3

    // ── Inicializa la sesión con el system prompt adecuado al nivel ──
    func iniciar(nivel: NivelVinculo, tema: TemaPlatica) async throws {
        self.nivel = nivel
        self.tema = tema
        self.turnoActual = 0
        self.historialContexto = ""

        let systemPrompt = buildSystemPrompt(nivel: nivel, tema: tema)

        // Verificamos disponibilidad del modelo antes de crear la sesión
        guard await SystemLanguageModel.default.isAvailable else {
            throw PlaticaError.modeloNoDisponible
        }

        // Creamos la sesión con instrucciones del sistema
        session = LanguageModelSession(
            model: .default,
            instructions: systemPrompt
        )
    }

    // ── Envía el mensaje del niño y obtiene la respuesta de Vínculo ──
    func enviarMensaje(_ texto: String) async throws -> String {
        guard let session else {
            throw PlaticaError.sesionNoInicializada
        }
        guard turnoActual < PlaticaSession.maxTurnos else {
            throw PlaticaError.conversacionCompleta
        }

        turnoActual += 1

        // Construimos el mensaje con contexto de turno
        let mensajeConContexto = buildMensajeConContexto(
            texto: texto,
            turno: turnoActual,
            maxTurnos: PlaticaSession.maxTurnos
        )

        // Llamada al modelo — generación de texto
        let respuesta = try await session.respond(
            to: mensajeConContexto,
            options: GenerationOptions(
                temperature: 0.7,    // creatividad moderada
                maximumResponseTokens: 80  // respuestas cortas para niños
            )
        )

        // Acumulamos contexto para que el modelo "recuerde"
        historialContexto += "\nNiño: \(texto)\nVínculo: \(respuesta.content)"

        return respuesta.content
    }

    // ── Genera opciones rápidas contextuales usando el modelo ──
    func generarOpcionesRapidas(contexto: String) async throws -> [OpcionRapida] {
        guard let session else {
            throw PlaticaError.sesionNoInicializada
        }

        // Prompt especializado para generar opciones cortas
        let promptOpciones = """
        Basándote en la conversación, genera exactamente 3 opciones de respuesta muy cortas \
        (máximo 5 palabras cada una) que un niño de \(edadRangoPorNivel(nivel)) años podría decir. \
        Contexto reciente: \(contexto)
        
        Responde SOLO con las 3 opciones separadas por el carácter |, sin números ni puntos. \
        Ejemplo: Jugué con mi perro|Fui al parque|Me quedé en casa
        """

        let resultado = try await session.respond(
            to: promptOpciones,
            options: GenerationOptions(temperature: 0.8, maximumResponseTokens: 40)
        )

        let partes = resultado.content
            .split(separator: "|")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .prefix(3)

        guard partes.count >= 2 else {
            // Fallback: opciones genéricas si el modelo no responde en formato esperado
            return opcionesFallback()
        }

        let emojis = ["💬", "😊", "🌟"]
        return zip(partes, emojis).map { OpcionRapida(texto: String($0), emoji: $1) }
    }

    // ── Libera la sesión del modelo ──
    func finalizar() async {
        session = nil
        historialContexto = ""
        turnoActual = 0
    }

    // ── Acceso al turno actual (para la UI) ──
    var turnoActualValor: Int { turnoActual }

    // ─────────────────────────────────────────────────────────
    // MARK: Construcción de prompts
    // ─────────────────────────────────────────────────────────

    private func buildSystemPrompt(nivel: NivelVinculo, tema: TemaPlatica) -> String {
        let edadRango = edadRangoPorNivel(nivel)
        let instruccionesNivel = instruccionesPorNivel(nivel)

        return """
        Eres Vínculo, un amigo virtual cálido y paciente que ayuda a niños de \(edadRango) años \
        a practicar la comunicación oral. Hoy el tema de conversación es: "\(tema.titulo)". \
        Contexto del tema: \(tema.contexto)

        REGLAS IMPORTANTES — SÍGUELAS SIEMPRE:
        \(instruccionesNivel)

        FORMATO DE TUS RESPUESTAS:
        - Máximo 2 oraciones por respuesta.
        - Usa lenguaje muy sencillo, palabras cotidianas.
        - Siempre termina con UNA pregunta corta y amigable para continuar la plática.
        - Sé positivo y alentador. Nunca corrijas errores de gramática directamente.
        - Si el niño dice algo fuera de tema, redirige suavemente: "Qué interesante. Y sobre [tema], ¿qué piensas tú?"
        - Nunca hagas dos preguntas seguidas.
        - Usa máximo 1 emoji por respuesta, al inicio o al final.

        ÚLTIMO TURNO (turno 3 de 3):
        - Termina con un mensaje de cierre emotivo y motivador.
        - No hagas preguntas en el mensaje de cierre.
        - Ejemplo de cierre: "¡Qué plática tan bonita tuvimos hoy! Eres muy bueno conversando 🌟"
        """
    }

    private func instruccionesPorNivel(_ nivel: NivelVinculo) -> String {
        switch nivel {
        case .uno:
            return """
            - El niño tiene comunicación muy limitada. Acepta respuestas de 1 o 2 palabras.
            - Celebra mucho cada respuesta, aunque sea muy corta.
            - Ofrece siempre una opción de respuesta dentro de tu pregunta. Ejemplo: "¿Te gusta más el sol o la lluvia?"
            - Si el niño no responde o responde con una sola letra, di algo como "Está bien, ¡tú puedes!"
            """
        case .dos:
            return """
            - El niño habla poco. Busca que expanda sus respuestas con oraciones cortas.
            - Haz preguntas abiertas simples: "¿Por qué?" o "¿Cómo fue eso?"
            - Cuando el niño responda con 1 palabra, ayúdale a expandir: "¡Qué cool! ¿Y cómo fue eso?"
            - Valida cada respuesta antes de preguntar algo nuevo.
            """
        case .tres:
            return """
            - El niño habla bien. El objetivo es que practique argumentar y escuchar.
            - Haz preguntas que requieran opinión: "¿Por qué crees eso?" o "¿Qué harías tú?"
            - Puedes introducir un punto de vista diferente al suyo de forma amigable.
            - Refuerza cuando use palabras nuevas o estructuras más complejas.
            """
        }
    }

    private func buildMensajeConContexto(texto: String, turno: Int, maxTurnos: Int) -> String {
        if turno == maxTurnos {
            return "\(texto)\n\n[Este es el turno \(turno) de \(maxTurnos). Es el último, da un mensaje de cierre cálido.]"
        }
        return "\(texto)\n\n[Turno \(turno) de \(maxTurnos)]"
    }

    private func edadRangoPorNivel(_ nivel: NivelVinculo) -> String {
        switch nivel {
        case .uno:  return "4 a 6"
        case .dos:  return "5 a 8"
        case .tres: return "7 a 12"
        }
    }

    private func opcionesFallback() -> [OpcionRapida] {
        [
            OpcionRapida(texto: "Me gustó mucho", emoji: "😊"),
            OpcionRapida(texto: "Fue divertido", emoji: "🎉"),
            OpcionRapida(texto: "No sé", emoji: "🤔")
        ]
    }
}


// ─────────────────────────────────────────────────────────────
// MARK: Errores del módulo
// ─────────────────────────────────────────────────────────────

enum PlaticaError: LocalizedError {
    case modeloNoDisponible
    case sesionNoInicializada
    case conversacionCompleta
    case respuestaVacia
    case dispositivoIncompatible

    var errorDescription: String? {
        switch self {
        case .modeloNoDisponible:
            return "Apple Intelligence no está disponible en este dispositivo. Actívalo en Ajustes > Apple Intelligence & Siri."
        case .sesionNoInicializada:
            return "La sesión de Vínculo no se ha iniciado. Inténtalo de nuevo."
        case .conversacionCompleta:
            return "¡La plática de hoy ya terminó! Vuelve mañana."
        case .respuestaVacia:
            return "Vínculo no pudo responder. Inténtalo de nuevo."
        case .dispositivoIncompatible:
            return "Este dispositivo necesita iPhone 15 Pro o superior para usar Apple Intelligence."
        }
    }
}


// ─────────────────────────────────────────────────────────────
// MARK: 3 · PlaticaViewModel.swift
// ViewModel observable — conecta sesión IA con la UI
// ─────────────────────────────────────────────────────────────

import Foundation
import SwiftUI
import Observation

@Observable
final class PlaticaViewModel {

    // ── Estado observable ──
    var mensajes: [MensajePlatica] = []
    var estadoPlatica: EstadoPlatica = .inicial
    var opcionesRapidas: [OpcionRapida] = []
    var textoInput: String = ""
    var turnoActual: Int = 0
    var mostrarOpciones: Bool = true
    var resultado: ResultadoPlatica?
    var errorMensaje: String?

    // ── Datos de la sesión ──
    let nivel: NivelVinculo
    let tema: TemaPlatica
    private let session: PlaticaSession
    private var tiempoInicio: Date?
    private var palabrasTotal: Int = 0

    // ── Constantes ──
    static let maxTurnos = PlaticaSession.maxTurnos

    init(nivel: NivelVinculo = .dos, tema: TemaPlatica = .temaDehoy) {
        self.nivel = nivel
        self.tema = tema
        self.session = PlaticaSession()
    }

    // ─────────────────────────────────────────────────────────
    // MARK: Ciclo de vida
    // ─────────────────────────────────────────────────────────

    @MainActor
    func iniciarPlatica() async {
        estadoPlatica = .cargando
        tiempoInicio = Date()

        do {
            // 1. Inicializa la sesión en el actor del modelo
            try await PlaticaModelActor.run {
                try await session.iniciar(nivel: nivel, tema: tema)
            }

            // 2. Carga opciones iniciales del tema
            opcionesRapidas = tema.opcionesIniciales
            mostrarOpciones = true

            // 3. Genera el primer mensaje de bienvenida de Vínculo
            let bienvenida = try await PlaticaModelActor.run {
                try await session.enviarMensaje(
                    "Saluda al niño de forma muy amigable y haz tu primera pregunta sobre el tema '\(tema.titulo)'. Sé muy cálido y emocionante."
                )
            }

            agregarMensaje(MensajePlatica(rol: .vinculo, texto: bienvenida))
            turnoActual = 0  // la bienvenida no cuenta como turno del niño
            estadoPlatica = .activa

        } catch PlaticaError.modeloNoDisponible {
            estadoPlatica = .error("Apple Intelligence no está activado en este dispositivo.")
        } catch PlaticaError.dispositivoIncompatible {
            estadoPlatica = .error("Se necesita iPhone 15 Pro o superior para esta actividad.")
        } catch {
            estadoPlatica = .error(error.localizedDescription)
        }
    }

    // ─────────────────────────────────────────────────────────
    // MARK: Envío de mensajes
    // ─────────────────────────────────────────────────────────

    @MainActor
    func enviarMensaje() async {
        let textoLimpio = textoInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !textoLimpio.isEmpty, estadoPlatica == .activa else { return }

        // 1. Agrega el mensaje del niño
        let mensajeNino = MensajePlatica(rol: .nino, texto: textoLimpio)
        agregarMensaje(mensajeNino)
        palabrasTotal += textoLimpio.split(separator: " ").count

        // 2. Limpia input y oculta opciones
        textoInput = ""
        mostrarOpciones = false
        estadoPlatica = .esperandoRespuesta

        do {
            // 3. Obtiene respuesta de Vínculo
            let respuestaTexto = try await PlaticaModelActor.run {
                try await session.enviarMensaje(textoLimpio)
            }

            let respuesta = MensajePlatica(rol: .vinculo, texto: respuestaTexto)
            agregarMensaje(respuesta)

            // 4. Actualiza turno
            turnoActual = await PlaticaModelActor.run { session.turnoActualValor }

            // 5. ¿Completamos todos los turnos?
            if turnoActual >= PlaticaViewModel.maxTurnos {
                await completarPlatica()
            } else {
                // 6. Genera nuevas opciones rápidas contextuales
                await actualizarOpcionesRapidas(contexto: "\(textoLimpio) — \(respuestaTexto)")
                estadoPlatica = .activa
            }

        } catch PlaticaError.conversacionCompleta {
            await completarPlatica()
        } catch {
            estadoPlatica = .error("Vínculo no pudo responder. Inténtalo de nuevo.")
            // Reactivamos para que el niño pueda reintentar
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
                if case .error = self?.estadoPlatica ?? .inicial {
                    self?.estadoPlatica = .activa
                }
            }
        }
    }

    // Atajo para opciones rápidas
    @MainActor
    func seleccionarOpcion(_ opcion: OpcionRapida) async {
        textoInput = opcion.texto
        await enviarMensaje()
    }

    // ─────────────────────────────────────────────────────────
    // MARK: Finalización
    // ─────────────────────────────────────────────────────────

    @MainActor
    private func completarPlatica() async {
        let duracion = Date().timeIntervalSince(tiempoInicio ?? Date())
        let puntos = calcularPuntos(duracion: duracion, palabras: palabrasTotal, turnos: turnoActual)
        let insignia = calcularInsignia(palabras: palabrasTotal)

        resultado = ResultadoPlatica(
            turnosCompletados: turnoActual,
            duracionSegundos: duracion,
            palabrasUsadas: palabrasTotal,
            puntosGanados: puntos,
            insignia: insignia
        )

        estadoPlatica = .completada

        // Persiste progreso (UserDefaults simple; en producción usar Core Data / CloudKit)
        await guardarProgreso(puntos: puntos)

        // Libera recursos del modelo
        await PlaticaModelActor.run { await session.finalizar() }
    }

    @MainActor
    private func actualizarOpcionesRapidas(contexto: String) async {
        do {
            let nuevasOpciones = try await PlaticaModelActor.run {
                try await session.generarOpcionesRapidas(contexto: contexto)
            }
            opcionesRapidas = nuevasOpciones
            mostrarOpciones = true
        } catch {
            // Si falla, usamos opciones genéricas sin bloquear la UI
            opcionesRapidas = [
                OpcionRapida(texto: "Cuéntame más", emoji: "🤔"),
                OpcionRapida(texto: "Me gustó mucho", emoji: "😊"),
                OpcionRapida(texto: "No sé bien", emoji: "💭")
            ]
            mostrarOpciones = true
        }
    }

    // ─────────────────────────────────────────────────────────
    // MARK: Helpers
    // ─────────────────────────────────────────────────────────

    private func agregarMensaje(_ mensaje: MensajePlatica) {
        mensajes.append(mensaje)
    }

    private func calcularPuntos(duracion: TimeInterval, palabras: Int, turnos: Int) -> Int {
        var pts = turnos * 15          // 15 pts por turno completado
        pts += min(palabras * 2, 30)   // hasta 30 pts extra por vocabulario
        if duracion > 30 { pts += 10 } // bonus por sostener la conversación
        return pts
    }

    private func calcularInsignia(palabras: Int) -> String? {
        if palabras >= 20 { return "Hablador estrella ⭐" }
        if palabras >= 10 { return "En camino 🌱" }
        return nil
    }

    private func guardarProgreso(puntos: Int) async {
        let defaults = UserDefaults.standard
        let key = "vinculo_puntos_nivel\(nivel.rawValue)"
        let puntosActuales = defaults.integer(forKey: key)
        defaults.set(puntosActuales + puntos, forKey: key)
        defaults.set(Date(), forKey: "vinculo_ultima_platica")
    }

    // ─────────────────────────────────────────────────────────
    // MARK: Disponibilidad de Apple Intelligence
    // ─────────────────────────────────────────────────────────

    // Verifica disponibilidad antes de mostrar la actividad en el menú
    static func appleIntelligenceDisponible() async -> Bool {
        return await SystemLanguageModel.default.isAvailable
    }
}


// ─────────────────────────────────────────────────────────────
// MARK: 4 · PlaticaComponents.swift
// Subvistas reutilizables de la UI
// ─────────────────────────────────────────────────────────────

import SwiftUI

// ── Burbuja de chat ──
struct BurbujaMensaje: View {
    let mensaje: MensajePlatica
    @State private var aparecer = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if mensaje.rol == .vinculo {
                avatarVinculo
                bubbleIA
                Spacer(minLength: 44)
            } else {
                Spacer(minLength: 44)
                bubbleNino
            }
        }
        .padding(.horizontal, 16)
        .opacity(aparecer ? 1 : 0)
        .offset(y: aparecer ? 0 : 12)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: aparecer)
        .onAppear { aparecer = true }
    }

    private var avatarVinculo: some View {
        ZStack {
            Circle()
                .fill(Color.slateDark)
                .frame(width: 30, height: 30)
            Text("V")
                .font(.custom("Georgia", size: 13))
                .foregroundColor(.white)
        }
    }

    private var bubbleIA: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("Vínculo")
                .font(.system(size: 8, weight: .light))
                .kerning(1.2)
                .textCase(.uppercase)
                .foregroundColor(.textLight)
            Text(mensaje.texto)
                .font(.system(size: 14, weight: .light))
                .foregroundColor(.textDark)
                .lineSpacing(3)
                .padding(12)
                .background(Color.white)
                .cornerRadius(12)
                .cornerRadius(2, corners: .bottomLeft)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.linoDark, lineWidth: 0.5)
                )
        }
        .frame(maxWidth: .infinity * 0.78, alignment: .leading)
    }

    private var bubbleNino: some View {
        Text(mensaje.texto)
            .font(.system(size: 14, weight: .light))
            .foregroundColor(.white)
            .lineSpacing(3)
            .padding(12)
            .background(Color.slateDark)
            .cornerRadius(12)
            .cornerRadius(2, corners: .bottomRight)
    }
}

// ── Indicador de escritura (Vínculo está pensando) ──
struct VinculoEscribiendo: View {
    @State private var dot1 = false
    @State private var dot2 = false
    @State private var dot3 = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            // Avatar
            ZStack {
                Circle().fill(Color.slateDark).frame(width: 30, height: 30)
                Text("V").font(.custom("Georgia", size: 13)).foregroundColor(.white)
            }
            HStack(spacing: 4) {
                Circle().fill(Color.slateDark).frame(width: 5, height: 5)
                    .scaleEffect(dot1 ? 1 : 0.5)
                    .animation(.easeInOut(duration: 0.4).repeatForever().delay(0.0), value: dot1)
                Circle().fill(Color.slateDark).frame(width: 5, height: 5)
                    .scaleEffect(dot2 ? 1 : 0.5)
                    .animation(.easeInOut(duration: 0.4).repeatForever().delay(0.15), value: dot2)
                Circle().fill(Color.slateDark).frame(width: 5, height: 5)
                    .scaleEffect(dot3 ? 1 : 0.5)
                    .animation(.easeInOut(duration: 0.4).repeatForever().delay(0.3), value: dot3)
            }
            .padding(10)
            .background(Color.white)
            .cornerRadius(12)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.linoDark, lineWidth: 0.5))
            Spacer()
        }
        .padding(.horizontal, 16)
        .onAppear { dot1 = true; dot2 = true; dot3 = true }
    }
}

// ── Opciones rápidas ──
struct OpcionesRapidasView: View {
    let opciones: [OpcionRapida]
    let onSeleccionar: (OpcionRapida) -> Void
    @State private var aparecer = false

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Elige o escribe tu respuesta")
                .font(.system(size: 8, weight: .light))
                .kerning(1.5)
                .textCase(.uppercase)
                .foregroundColor(.textLight)
                .padding(.leading, 4)

            ForEach(opciones) { opcion in
                Button(action: { onSeleccionar(opcion) }) {
                    HStack(spacing: 8) {
                        Text(opcion.emoji)
                            .font(.system(size: 14))
                        Text(opcion.texto)
                            .font(.system(size: 13, weight: .light))
                            .foregroundColor(.slateDark)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .font(.system(size: 10, weight: .light))
                            .foregroundColor(.textLight)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .background(Color.white)
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.slateLight, lineWidth: 0.7)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 4)
        .opacity(aparecer ? 1 : 0)
        .offset(y: aparecer ? 0 : 8)
        .animation(.spring(response: 0.35, dampingFraction: 0.75).delay(0.1), value: aparecer)
        .onAppear { aparecer = true }
    }
}

// ── Indicador de turnos en el header ──
struct TurnosIndicador: View {
    let turnoActual: Int
    let maxTurnos: Int

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxTurnos, id: \.self) { i in
                Circle()
                    .fill(i <= turnoActual ? Color.slateDark : Color.linoDark)
                    .frame(width: 6, height: 6)
                    .animation(.spring(response: 0.3), value: turnoActual)
            }
        }
    }
}

// ── Pantalla de carga ──
struct PlaticaCargandoView: View {
    @State private var rotacion: Double = 0

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            ZStack {
                Circle().stroke(Color.linoDark, lineWidth: 1.5).frame(width: 56, height: 56)
                Circle()
                    .trim(from: 0, to: 0.3)
                    .stroke(Color.slateDark, style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                    .frame(width: 56, height: 56)
                    .rotationEffect(.degrees(rotacion))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: rotacion)
                Text("V")
                    .font(.custom("Georgia", size: 18))
                    .foregroundColor(.slateDark)
            }
            Text("Vínculo se está preparando…")
                .font(.system(size: 12, weight: .light))
                .kerning(1)
                .foregroundColor(.textMid)
            Spacer()
        }
        .onAppear { rotacion = 360 }
    }
}

// ── Pantalla de resultado ──
struct PlaticaResultadoView: View {
    let resultado: ResultadoPlatica
    let onCerrar: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 20) {
                    Spacer().frame(height: 24)

                    // Icono de logro
                    ZStack {
                        Circle().stroke(Color.slateLight, lineWidth: 1).frame(width: 72, height: 72)
                        Text("🌟")
                            .font(.system(size: 32))
                    }

                    Text("¡Plática completada!")
                        .font(.custom("Georgia", size: 24))
                        .foregroundColor(.textDark)

                    if let insignia = resultado.insignia {
                        Text(insignia)
                            .font(.system(size: 11, weight: .light))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color.slateDark)
                            .cornerRadius(4)
                    }

                    // Stats
                    VStack(spacing: 0) {
                        ResultadoFila(icono: "bubble.left.and.bubble.right",
                                      etiqueta: "Turnos completados",
                                      valor: "\(resultado.turnosCompletados) de 3")
                        Divider().background(Color.linoDark)
                        ResultadoFila(icono: "textformat.abc",
                                      etiqueta: "Palabras usadas",
                                      valor: "\(resultado.palabrasUsadas)")
                        Divider().background(Color.linoDark)
                        ResultadoFila(icono: "clock",
                                      etiqueta: "Duración",
                                      valor: formatearDuracion(resultado.duracionSegundos))
                        Divider().background(Color.linoDark)
                        ResultadoFila(icono: "plus.circle",
                                      etiqueta: "Puntos ganados",
                                      valor: "+\(resultado.puntosGanados)")
                    }
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.linoDark, lineWidth: 0.5))
                    .padding(.horizontal, 24)

                    Text("¡Cada plática te hace más valiente para hablar con los demás! 💪")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.textMid)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 32)
            }

            // Botón cerrar
            VStack(spacing: 0) {
                Divider().background(Color.linoDark)
                Button(action: onCerrar) {
                    Text("Volver a actividades")
                        .font(.system(size: 11, weight: .regular))
                        .kerning(2)
                        .textCase(.uppercase)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 46)
                        .background(Color.slateDark)
                        .cornerRadius(4)
                }
                .buttonStyle(.plain)
                .padding(16)
                .background(Color.cream)
            }
        }
    }

    private func formatearDuracion(_ segundos: TimeInterval) -> String {
        let mins = Int(segundos) / 60
        let segs = Int(segundos) % 60
        return mins > 0 ? "\(mins) min \(segs) s" : "\(segs) segundos"
    }
}

struct ResultadoFila: View {
    let icono: String
    let etiqueta: String
    let valor: String

    var body: some View {
        HStack {
            Image(systemName: icono)
                .font(.system(size: 11, weight: .light))
                .foregroundColor(.slate)
                .frame(width: 20)
            Text(etiqueta)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(.textDark)
            Spacer()
            Text(valor)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.slateDark)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}

// ── Banner de error ──
struct BannerError: View {
    let mensaje: String
    let onReintentar: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Text(mensaje)
                .font(.system(size: 12, weight: .light))
                .foregroundColor(.textDark)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
            Button(action: onReintentar) {
                Text("Reintentar")
                    .font(.system(size: 10, weight: .regular))
                    .kerning(1.5)
                    .textCase(.uppercase)
                    .foregroundColor(.slateDark)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.slate, lineWidth: 0.8))
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.linoDark, lineWidth: 0.5))
        .padding(.horizontal, 16)
    }
}


// ─────────────────────────────────────────────────────────────
// MARK: 5 · PlaticaDelDiaView.swift
// Vista principal — integra todo el módulo
// ─────────────────────────────────────────────────────────────

import SwiftUI

struct PlaticaDelDiaView: View {
    @State private var viewModel: PlaticaViewModel
    @Environment(\.dismiss) private var dismiss

    // Permite pasar nivel y tema desde la tab de actividades
    init(nivel: NivelVinculo = .dos, tema: TemaPlatica = .temaDehoy) {
        _viewModel = State(initialValue: PlaticaViewModel(nivel: nivel, tema: tema))
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider().background(Color.linoDark)
            contenidoPrincipal
        }
        .background(Color.lino.ignoresSafeArea())
        .navigationBarHidden(true)
        .task {
            await viewModel.iniciarPlatica()
        }
    }

    // ─────────────────────────────────────────────────────────
    // MARK: Header
    // ─────────────────────────────────────────────────────────
    private var header: some View {
        HStack(spacing: 12) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .light))
                    .foregroundColor(.slateDark)
            }

            VStack(alignment: .leading, spacing: 1) {
                Text(viewModel.tema.titulo)
                    .font(.custom("Georgia", size: 18))
                    .foregroundColor(.textDark)
                Text("Plática del día · Nivel \(viewModel.nivel.rawValue)")
                    .font(.system(size: 8, weight: .light))
                    .kerning(1.5)
                    .textCase(.uppercase)
                    .foregroundColor(.textLight)
            }

            Spacer()

            TurnosIndicador(
                turnoActual: viewModel.turnoActual,
                maxTurnos: PlaticaViewModel.maxTurnos
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.cream)
    }

    // ─────────────────────────────────────────────────────────
    // MARK: Contenido según estado
    // ─────────────────────────────────────────────────────────
    @ViewBuilder
    private var contenidoPrincipal: some View {
        switch viewModel.estadoPlatica {
        case .inicial, .cargando:
            PlaticaCargandoView()

        case .activa, .esperandoRespuesta:
            chatActivo

        case .completada:
            if let resultado = viewModel.resultado {
                PlaticaResultadoView(resultado: resultado, onCerrar: { dismiss() })
            }

        case .error(let msg):
            VStack {
                Spacer()
                BannerError(mensaje: msg) {
                    Task { await viewModel.iniciarPlatica() }
                }
                Spacer()
            }
        }
    }

    // ─────────────────────────────────────────────────────────
    // MARK: Chat activo
    // ─────────────────────────────────────────────────────────
    private var chatActivo: some View {
        VStack(spacing: 0) {
            // Área de mensajes
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.mensajes) { msg in
                            BurbujaMensaje(mensaje: msg)
                                .id(msg.id)
                        }

                        // Indicador de escritura
                        if viewModel.estadoPlatica == .esperandoRespuesta {
                            VinculoEscribiendo()
                                .id("typing")
                        }

                        // Opciones rápidas (solo cuando está activo y hay opciones)
                        if viewModel.estadoPlatica == .activa && viewModel.mostrarOpciones {
                            OpcionesRapidasView(
                                opciones: viewModel.opcionesRapidas,
                                onSeleccionar: { opcion in
                                    Task { await viewModel.seleccionarOpcion(opcion) }
                                }
                            )
                            .id("opciones")
                        }

                        // Spacer inferior para que el input no tape mensajes
                        Color.clear.frame(height: 8).id("bottom")
                    }
                    .padding(.vertical, 12)
                }
                .background(Color.lino)
                // Auto-scroll al último mensaje
                .onChange(of: viewModel.mensajes.count) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
                .onChange(of: viewModel.estadoPlatica) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        proxy.scrollTo("bottom", anchor: .bottom)
                    }
                }
            }

            Divider().background(Color.linoDark)

            // Barra de input
            inputBar
        }
    }

    // ─────────────────────────────────────────────────────────
    // MARK: Input bar
    // ─────────────────────────────────────────────────────────
    private var inputBar: some View {
        HStack(spacing: 10) {
            // Micrófono (placeholder — Speech Recognition se integra aquí)
            Button(action: { /* Speech Recognition integration point */ }) {
                ZStack {
                    Circle()
                        .stroke(Color.slateLight, lineWidth: 1)
                        .frame(width: 40, height: 40)
                    Image(systemName: "mic")
                        .font(.system(size: 13, weight: .light))
                        .foregroundColor(.slateDark)
                }
            }
            .buttonStyle(.plain)
            .disabled(viewModel.estadoPlatica == .esperandoRespuesta)

            // Campo de texto
            TextField("Escribe tu respuesta…", text: $viewModel.textoInput, axis: .vertical)
                .font(.system(size: 14, weight: .light))
                .foregroundColor(.textDark)
                .lineLimit(1...3)
                .padding(.horizontal, 12)
                .padding(.vertical, 9)
                .background(Color.white)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.linoDark, lineWidth: 0.7)
                )
                .disabled(viewModel.estadoPlatica == .esperandoRespuesta)
                .onSubmit {
                    Task { await viewModel.enviarMensaje() }
                }

            // Botón enviar
            Button(action: {
                Task { await viewModel.enviarMensaje() }
            }) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(puedeEnviar ? Color.slateDark : Color.slateLight)
                    .clipShape(Circle())
                    .animation(.easeInOut(duration: 0.2), value: puedeEnviar)
            }
            .buttonStyle(.plain)
            .disabled(!puedeEnviar)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.cream)
    }

    private var puedeEnviar: Bool {
        !viewModel.textoInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && viewModel.estadoPlatica == .activa
    }
}


// ─────────────────────────────────────────────────────────────
// MARK: Entrypoint desde ActividadesTab — ejemplo de uso
// ─────────────────────────────────────────────────────────────

// En ActividadesTabNivel2, al tocar la tarjeta "Plática del día":
//
//   NavigationLink(destination: PlaticaDelDiaView(
//       nivel: .dos,
//       tema: .temaDehoy
//   )) { ... }
//
// O desde un sheet:
//
//   .sheet(isPresented: $mostrarPlatica) {
//       PlaticaDelDiaView(nivel: .dos, tema: .temaDehoy)
//   }


// ─────────────────────────────────────────────────────────────
// MARK: Verificación de disponibilidad (en ActividadesTabNivel2)
// ─────────────────────────────────────────────────────────────

// Añade esto a ActividadesTabNivel2 para verificar Apple Intelligence:
//
// @State private var iaDisponible: Bool = false
//
// .task {
//     iaDisponible = await PlaticaViewModel.appleIntelligenceDisponible()
// }
//
// Si !iaDisponible: muestra un banner indicando que el dispositivo
// necesita tener Apple Intelligence activado.


// ─────────────────────────────────────────────────────────────
// MARK: Info.plist — permisos necesarios
// ─────────────────────────────────────────────────────────────
//
// Agregar en Info.plist:
//
// NSMicrophoneUsageDescription
//   → "Vínculo necesita el micrófono para escuchar tus respuestas en voz alta."
//
// NSSpeechRecognitionUsageDescription
//   → "Vínculo usa reconocimiento de voz para transcribir lo que dices."
//
// (El permiso de Foundation Models / Apple Intelligence NO requiere
//  una entrada específica en Info.plist — se gestiona vía sistema.)


// ─────────────────────────────────────────────────────────────
// MARK: Package.swift / Project config
// ─────────────────────────────────────────────────────────────
//
// Deployment Target: iOS 18.4+
// Frameworks a linkear:
//   - FoundationModels.framework  (Apple Intelligence)
//   - Speech.framework            (para micrófono, fase 2)
// Capabilities en Xcode:
//   - Apple Intelligence (en Signing & Capabilities)
//
// NOTA: Apple Intelligence requiere:
//   - iPhone 15 Pro / iPhone 16 o superior
//   - iPad con chip M1 o superior
//   - Idioma del dispositivo en inglés (iOS 18.4 agrega español beta)
//   - Región compatible (US, Canada, UK, Australia…)
//     En México se activa con región US y idioma en inglés como principal.


// ─────────────────────────────────────────────────────────────
// MARK: Previews
// ─────────────────────────────────────────────────────────────

#Preview("Plática del Día") {
    NavigationStack {
        PlaticaDelDiaView(nivel: .dos, tema: .temaDehoy)
    }
}

#Preview("Resultado") {
    PlaticaResultadoView(
        resultado: ResultadoPlatica(
            turnosCompletados: 3,
            duracionSegundos: 145,
            palabrasUsadas: 18,
            puntosGanados: 55,
            insignia: "Hablador estrella ⭐"
        ),
        onCerrar: {}
    )
}

#Preview("Cargando") {
    PlaticaCargandoView()
}
*/
