import SwiftUI

// MARK: - Cuestionario2View (botones de opción)
struct NewCuestionarioView: View {
    let cuestionarioID: UUID

    @State private var edad = 5
    @State private var respuestas: [Int: Int] = [:]   // índice pregunta → 0..4
    @State private var respuesta1: Bool? = nil          // Pregunta 1: Sí/No
    @State private var paginaActual = 0                 // 0 = edad+p1, 1..19 = preguntas 2–20
    
    @StateObject private var viewModel = ViewModel()
    
    //Variables para almacenar los resultados
    var valorExpresivo = 0
    var valorExpresivoNormalizado = 0
    var valorReceptivo = 0
    var valorReceptivoNormalizado = 0
    var frustracion = 0
    var frustracionNormalizada = 0
    
    @State private var selectedOption = "Opción 1"
    let options = ["Opción 1", "Opción 2", "Opción 3"]

    let grados = ["Nunca", "Rara vez", "A veces", "Casi siempre", "Siempre"]
    let gradosSubtitulo = [
        "No presenta esta dificultad",
        "Solo en situaciones muy específicas",
        "Depende del contexto",
        "Con frecuencia notable",
        "De manera consistente"
    ]

    let preguntas = [
        "¿Su hijo responde a su nombre?",
        "¿Su hijo en ocasiones se comporta distinto o prefiere estar solo?",
        "¿A su hijo le cuesta controlar sus emociones o reacciona de manera espontánea?",
        "¿Su hijo es sensible a multitudes?",
        "¿Su hijo presenta problemas al hablar?",
        "¿Su hijo requiere que usted suba el tono de voz para acatar indicaciones?",
        "¿Su hijo es fácil de irritar al no cumplir algún deseo suyo?",
        "¿Su hijo presenta dificultades para seguir indicaciones?",
        "¿Su hijo se comporta de forma anormal a otros niños de su edad?",
        "¿Su hijo presenta problemas de aprendizaje?",
        "¿Su hijo tiene dificultades para seguir múltiples indicaciones?",
        "¿Su hijo presenta problemas para mantener la atención en una conversación?",
        "¿Su hijo usa un lenguaje descortés y no respeta los turnos de conversación?",
        "¿Su hijo presenta una débil comunicación a la hora de expresar sus deseos?",
        "¿Su hijo no presenta coherencia en sus palabras al momento de expresar sus ideas?",
        "¿Su hijo suele desistir de sus actividades cuando falla?",
        "¿Su hijo maneja de forma negativa llamados de atención?",
        "¿Su hijo reacciona de manera negativa cuando un evento no resulta como lo esperaba?",
        "¿Su hijo tiene dificultades para comprender expresiones coloquiales?",
        "¿Su hijo tiene dificultades para entender expresiones humanas?"
    ]

    // Progreso 0.0–1.0
    var progreso: Double {
        if paginaActual == 0 { return 0.0 }
        return Double(paginaActual) / Double(preguntas.count)
    }

    // ¿Puede avanzar?
    var puedeAvanzar: Bool {
        if paginaActual == 0 { return respuesta1 != nil }
        return respuestas[paginaActual + 1] != nil
    }

    var body: some View {
        ZStack {
            //Color.lino.ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Header con progreso
                VStack(spacing: 12) {
                    HStack {
                        // Número de pregunta
                        Text(paginaActual == 0 ? "Inicio" : String(format: "%02d", paginaActual + 1))
                            .font(.custom("Georgia", size: 28))
                            //.foregroundColor(.slateLight)

                        Spacer()

                        Text("\(paginaActual == 0 ? 0 : paginaActual + 1) / \(preguntas.count)")
                            .font(.system(size: 11, weight: .light))
                            .kerning(1)
                            .foregroundColor(.textLight)
                    }

                    // Barra de progreso
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color.linoDark)
                                .frame(height: 1.5)
                            Rectangle()
                                .fill(Color.slateDark)
                                .frame(width: geo.size.width * progreso, height: 1.5)
                                .animation(.easeInOut(duration: 0.3), value: progreso)
                        }
                    }
                    .frame(height: 1.5)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                .padding(.bottom, 16)

                Divider().background(Color.linoDark)

                // MARK: Contenido scrollable
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        if paginaActual == 0 {
                            // Página 0: Edad + Pregunta 1
                            //edadYPregunta1
                            resultados
                        } else if paginaActual == 20 {
                            // Última página: Resultados y respuesta de IA
                            resultados
                        } else {
                            // Páginas 1–19: Preguntas con botones
                            let idx = paginaActual  // pregunta index 1..19 (array index 1..19)
                            preguntaConOpciones(
                                numeroPregunta: idx + 1,
                                texto: preguntas[idx],
                                respuestaActual: respuestas[idx + 1]
                            ) { valor in
                                respuestas[idx + 1] = valor
                            }
                        }
                    }
                    .padding(24)
                }

                Divider().background(Color.linoDark)

                // MARK: Botón siguiente / finalizar
                HStack {
                    if paginaActual > 0 {
                        Button(action: { withAnimation { paginaActual -= 1 } }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 12, weight: .medium))
                                Text("Anterior")
                                    .font(.system(size: 13, weight: .regular))
                                    .kerning(1.5)
                            }
                            .foregroundColor(.textMid)
                            .textCase(.uppercase)
                        }
                    }

                    Spacer()

                    Button(action: {
                        withAnimation {
                            if paginaActual < preguntas.count - 1 {
                                paginaActual += 1
                            } else if paginaActual == preguntas.count - 1 {
                                // TODO: procesar resultados
                                print("Cuestionario completo:", respuestas)
                                paginaActual += 1
                            } else {
                                print("Cuestionario completo:", respuestas)
                            }
                        }
                    }) {
                        HStack(spacing: 8) {
                            Text(paginaActual == preguntas.count ? "Retornar" : (paginaActual == preguntas.count - 1 ? "Finalizar" : "Siguiente"))
                            .font(.system(size: 13, weight: .medium))
                            .kerning(2)
                            .textCase(.uppercase)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundColor(puedeAvanzar ? .cream : .textLight)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(puedeAvanzar ? Color.slateDark : Color.linoDark)
                        .cornerRadius(4)
                        .animation(.easeInOut(duration: 0.2), value: puedeAvanzar)
                    }
                    .disabled(!puedeAvanzar)
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 20)
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Página 0: Edad y Pregunta 1
    @ViewBuilder
    var edadYPregunta1: some View {
        // Encabezado sección
        VStack(alignment: .leading, spacing: 4) {
            Text("Evaluación inicial")
                .font(.custom("Georgia", size: 22))
                .foregroundColor(.textDark)
            Text("Esta información nos ayuda a personalizar los resultados")
                .font(.system(size: 13, weight: .light))
                .foregroundColor(.textMid)
                .lineSpacing(3)
        }

        // Stepper de edad
        VStack(alignment: .leading, spacing: 12) {
            Text("Edad de su hijo")
                .font(.system(size: 11, weight: .regular))
                .kerning(2)
                .textCase(.uppercase)
                .foregroundColor(.textLight)

            HStack {
                Button(action: { if edad > 5 { edad -= 1 } }) {
                    Image(systemName: "minus")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.slateDark)
                        .frame(width: 36, height: 36)
                        .overlay(Circle().stroke(Color.slate, lineWidth: 1))
                }

                Text("\(edad) años")
                    .font(.custom("Georgia", size: 24))
                    .foregroundColor(.textDark)
                    .frame(minWidth: 80)
                    .multilineTextAlignment(.center)

                Button(action: { if edad < 10 { edad += 1 } }) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.slateDark)
                        .frame(width: 36, height: 36)
                        .overlay(Circle().stroke(Color.slate, lineWidth: 1))
                }
            }
        }
        .padding(20)
        .background(Color.cream)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.linoDark, lineWidth: 0.5))
        
        // Pregunta trastornos
        VStack(alignment: .leading, spacing: 16) {
            Text("¿Su hijo ha sido diagnosticado con alguno de los siguientes trastornos?")
                .font(.custom("Georgia", size: 17))
                .foregroundColor(.textDark)
                .lineSpacing(4)
            Text("Solo agregue los que estén diagnosticados por un profesional")
                .font(.system(size: 13, weight: .light))
                .foregroundColor(.textMid)
                .lineSpacing(3)
            VStack(alignment: .leading, spacing: 12) {
                MultipleSelectionGroup(options: [
                    ("op1", "Trastorno de Deficit de Atención e Hiperactividad (TDAH)"),
                    ("op2", "Autismo"),
                    ("op3", "Discapacidad Intelectual"),
                    ("op4", "Trastorno de Estrés Postraumático (TEPT)")
                ])
            }
            .padding(20)
            .background(Color.cream)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.linoDark, lineWidth: 0.5))
            
        }
        
        // Pregunta 1 (Sí/No)
        VStack(alignment: .leading, spacing: 16) {
            Text("Pregunta 01")
                .font(.system(size: 11, weight: .regular))
                .kerning(2)
                .textCase(.uppercase)
                .foregroundColor(.textLight)

            Text(preguntas[0])
                .font(.custom("Georgia", size: 17))
                .foregroundColor(.textDark)
                .lineSpacing(4)

            HStack(spacing: 12) {
                ForEach([("Sí", true), ("No", false)], id: \.0) { label, valor in
                    //se almacena la respuesta 1
                    Button(action: { respuesta1 = valor }) {
                        HStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .stroke(respuesta1 == valor ? Color.slateDark : Color.slateLight, lineWidth: 1.5)
                                    .frame(width: 20, height: 20)
                                if respuesta1 == valor {
                                    Circle()
                                        .fill(Color.slateDark)
                                        .frame(width: 10, height: 10)
                                }
                            }
                            Text(label)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundColor(.textDark)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(respuesta1 == valor ? Color.white : Color.cream)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(respuesta1 == valor ? Color.slateDark : Color.linoDark, lineWidth: respuesta1 == valor ? 1.5 : 0.5)
                        )
                    }
                }
            }
        }
    }

    // MARK: - Componente pregunta con 5 opciones
    @ViewBuilder
    func preguntaConOpciones(
        numeroPregunta: Int,
        texto: String,
        respuestaActual: Int?,
        onSelect: @escaping (Int) -> Void
    ) -> some View {

        VStack(alignment: .leading, spacing: 20) {
            // Texto de la pregunta
            Text(texto)
                .font(.custom("Georgia", size: 18))
                .foregroundColor(.textDark)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            // Opciones
            VStack(spacing: 10) {
                ForEach(0..<5) { i in
                    Button(action: { onSelect(i) }) {
                        HStack(spacing: 14) {
                            // Indicador circular
                            ZStack {
                                Circle()
                                    .stroke(
                                        respuestaActual == i ? Color.slateDark : Color.slateLight,
                                        lineWidth: 1.5
                                    )
                                    .frame(width: 22, height: 22)
                                if respuestaActual == i {
                                    Circle()
                                        .fill(Color.slateDark)
                                        .frame(width: 10, height: 10)
                                }
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(grados[i])
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.textDark)
                                Text(gradosSubtitulo[i])
                                    .font(.system(size: 12, weight: .light))
                                    .foregroundColor(.textLight)
                            }

                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(respuestaActual == i ? Color.white : Color.cream)
                        .cornerRadius(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(
                                    respuestaActual == i ? Color.slateDark : Color.linoDark,
                                    lineWidth: respuestaActual == i ? 1.5 : 0.5
                                )
                        )
                        .animation(.easeInOut(duration: 0.15), value: respuestaActual)
                    }
                    //
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    // MARK: - Componente de Círculo de Progreso
    struct CircularProgressView: View {
        let progress: Double  // 0.0 a 1.0
        let score: Int        // Puntaje 0-100
        let size: CGFloat
        
        private let lineWidth: CGFloat = 20
        
        var body: some View {
            ZStack {
                // Círculo de fondo
                Circle()
                    .stroke(
                        Color.linoDark.opacity(0.3),
                        lineWidth: lineWidth
                    )
                
                // Círculo de progreso
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                Color.slateLight,
                                Color.slateDark,
                                Color.slateDark
                            ]),
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270)
                        ),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: progress)
                
                // Contenido central
                VStack(spacing: 8) {
                    Text("\(score)")
                        .font(.custom("Georgia", size: size * 0.25))
                        .fontWeight(.bold)
                        .foregroundColor(.textDark)
                    
                    Text("Puntaje")
                        .font(.system(size: size * 0.08, weight: .light))
                        .foregroundColor(.textMid)
                        .kerning(1)
                    
                    Text("Total")
                        .font(.system(size: size * 0.08, weight: .light))
                        .foregroundColor(.textMid)
                        .kerning(1)
                }
            }
            .frame(width: size, height: size)
        }
    }

    // MARK: - Círculo de Progreso con Texto de Nivel
    struct ScoreCircleView: View {
        let score: Int
        let size: CGFloat
        
        private var progress: Double {
            return Double(score) / 100.0
        }
        
        private var nivel: (texto: String, color: Color) {
            switch score {
            case 0..<20:
                return ("Muy Bajo", Color.red.opacity(0.8))
            case 20..<40:
                return ("Bajo", Color.orange.opacity(0.8))
            case 40..<60:
                return ("Moderado", Color.yellow.opacity(0.8))
            case 60..<80:
                return ("Alto", Color.green.opacity(0.8))
            default:
                return ("Muy Alto", Color.blue.opacity(0.8))
            }
        }
        
        var body: some View {
            VStack(spacing: 16) {
                CircularProgressView(progress: progress, score: score, size: size)
                    .overlay(
                        Circle()
                            .stroke(nivel.color.opacity(0.3), lineWidth: 2)
                            .frame(width: size + 10, height: size + 10)
                    )
                
                VStack(spacing: 4) {
                    Text("Nivel: \(nivel.texto)")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(nivel.color)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(nivel.color.opacity(0.1))
                        .cornerRadius(20)
                    
                    Text("\(score)% de desarrollo comunicativo")
                        .font(.system(size: 13, weight: .light))
                        .foregroundColor(.textMid)
                }
            }
        }
    }
    
    // MARK: - Página Final: Resultados
    @ViewBuilder
    var resultados: some View {
        
        /*
        
        // Calcular resultados basado en respuestas
        let r1 = respuesta1 == true ? 1 : 0  // Pregunta 1 (Sí/No)
        let r2 = respuestas[2] ?? 0   // Índice 2 = pregunta 2
        let r3 = respuestas[3] ?? 0   // pregunta 3
        let r4 = respuestas[4] ?? 0   // pregunta 4
        let r5 = respuestas[5] ?? 0   // pregunta 5
        let r6 = respuestas[6] ?? 0   // pregunta 6
        let r7 = respuestas[7] ?? 0   // pregunta 7
        let r8 = respuestas[8] ?? 0   // pregunta 8
        let r9 = respuestas[9] ?? 0   // pregunta 9
        let r10 = respuestas[10] ?? 0  // pregunta 10
        let r11 = respuestas[11] ?? 0  // pregunta 11
        let r12 = respuestas[12] ?? 0  // pregunta 12
        let r13 = respuestas[13] ?? 0  // pregunta 13
        let r14 = respuestas[14] ?? 0  // pregunta 14
        let r15 = respuestas[15] ?? 0  // pregunta 15
        let r16 = respuestas[16] ?? 0  // pregunta 16
        let r17 = respuestas[17] ?? 0  // pregunta 17
        let r18 = respuestas[18] ?? 0  // pregunta 18
        let r19 = respuestas[19] ?? 0  // pregunta 19
        let r20 = respuestas[20] ?? 0  // pregunta 20
        
        let valorExpresivo = r1 + r3 + r4 + r8 + r12 + r13 + r14
        let valorReceptivo = r5 + r2 + r7 + r9 + r10 + r11 + r18 + r19 + r20
        let frustracion = r2 + r6 + r15 + r16 + r17
        
        // Normalizar valores (0-100)
        let maxExpresivo = 7 * 4  // 7 preguntas * 4 (máximo valor)
        let valorExpresivoNormalizado = maxExpresivo > 0 ? (Double(valorExpresivo) / Double(maxExpresivo)) * 100 : 0
        
        let maxReceptivo = 8 * 4  // 8 preguntas * 4
        let valorReceptivoNormalizado = maxReceptivo > 0 ? (Double(valorReceptivo) / Double(maxReceptivo)) * 100 : 0
        
        let maxFrustracion = 5 * 4  // 5 preguntas * 4
        let frustracionNormalizada = maxFrustracion > 0 ? (Double(frustracion) / Double(maxFrustracion)) * 100 : 0
        
        let edadFactor = Double(edad - 5) / 5.0  // Normalizado entre 0 y 1 para edad 5-10
        
        // var N = 50*Ve + 30*Vr + 20*En - F*15
        let puntuacionTotal = (50 * (valorExpresivoNormalizado / 100)) +
                              (30 * (valorReceptivoNormalizado / 100)) +
                              (20 * edadFactor) -
                              (15 * (frustracionNormalizada / 100))
        
         */
         
        VStack(alignment: .leading, spacing: 20) {
            // Encabezado
            VStack(alignment: .leading, spacing: 4) {
                Text("Resultados")
                    .font(.custom("Georgia", size: 22))
                    .foregroundColor(.textDark)
                Text("Solo determinan el nivel de comunicación donde el niño será colocado, no refleja un diagnóstico real")
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(.textMid)
                    .lineSpacing(3)
            }
            
            // Mostrar resultados
            
            VStack {
                ScoreCircleView(score: 88, size: 220)
            
                Button(action: {
                    Task {
                        await viewModel.runModel()
                    }
                }) {
                    HStack {
                        if viewModel.isProcessing {
                            ProgressView()
                        }
                        Text("Run Model")
                    }
                    .disabled(viewModel.isProcessing)
                    
                    if let error = viewModel.errorMessage{
                        Text(error).foregroundStyle(.red)
                    }
                        
                    ScrollView{
                        Text(viewModel.output)
                            .padding()
                    }
                    
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.cream.opacity(0.5))
            .cornerRadius(16)
            .padding(.horizontal)
        }
        .padding(24)
    }
}

#Preview {
    NavigationStack {
        NewCuestionarioView(cuestionarioID: UUID())
    }
}

