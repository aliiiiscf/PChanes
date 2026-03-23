import SoundAnalysis
import AVFoundation
import FoundationModels
/*
struct CuestionarioView: View {
    let cuestionarioID: UUID
    @State private var respuestas: [Int: Int] = [:]
    @State private var answers: [Double] = []
    @State private var enviado = false
    @State private var calificacion: Double = 0
    @State private var answer1 = false
    @State private var grados = ["Nunca", "Rara vez", "A veces", "Casi siempre", "Siempre"]
    
    @State private var respuesta1: Double = 0
    @State private var respuesta2: Double = 0
    @State private var respuesta3: Double = 0
    @State private var respuesta4: Double = 0
    @State private var respuesta5: Double = 0
    @State private var respuesta6: Double = 0
    @State private var respuesta7: Double = 0
    @State private var respuesta8: Double = 0
    @State private var respuesta9: Double = 0
    @State private var respuesta10: Double = 0
    @State private var respuesta11: Double = 0
    @State private var respuesta12: Double = 0
    @State private var respuesta13: Double = 0
    @State private var respuesta14: Double = 0
    @State private var respuesta15: Double = 0
    @State private var respuesta16: Double = 0
    @State private var respuesta17: Double = 0
    @State private var respuesta18: Double = 0
    @State private var respuesta19: Double = 0
    @State private var respuesta20: Double = 0
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Cuestionario")
                .font(.title)
                .bold()
            ScrollView(.vertical, showsIndicators: true){
                VStack(spacing:8){
                    VStack(spacing: 12){
                        Toggle(isOn: $answer1){
                            Text("1: ¿Su hijo responde a su nombre?")
                        }
                        .frame(maxWidth: 500)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    if answer1 {
                        var respuesta1 = 1
                    }
                    
                    
                    Text("2: ¿Su hijo en ocasiones se comporta distinto o prefiere estar solo?")
                    VStack(spacing: 8) {
                        Slider(value: $respuesta2, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta2)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    
                    Text("3: ¿A su hijo le cuesta contolar sus emociones o reacciona de manera espontanea?")
                    VStack(spacing: 8) {
                        Slider(value: $respuesta3, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta3)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    
                    /*Text("4: ¿Su hijo es sensible a multitudes?")
                     // Califica de 0 a 5
                     VStack(spacing: 8) {
                     /*
                      HStack {
                      Text("Calificación: ")
                      Text(String(format: "%.0f", calificacion))
                      .monospacedDigit()
                      .bold()
                      }
                      */
                     Slider(value: $calificacion, in: 0...4, step: 1)
                     .frame(maxWidth: 300)
                     .frame(maxWidth: .infinity, alignment: .center)
                     
                     // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                     
                     HStack {
                     ForEach(0...4, id: \.self) { mark in
                     Text("\(mark)")
                     .font(.caption)
                     .frame(maxWidth: .infinity)
                     }
                     }
                     
                     .frame(maxWidth: 300)
                     .frame(maxWidth: .infinity, alignment: .center)
                     }
                     .padding(.vertical, 8)*/
                    
                    
                    //Pregunta
                    
                    Text("4: ¿Su hijo es sensible a multitudes?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta4, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta4)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    
                    //Fin Pregunta
                    //Pregunta
                    
                    Text("5: ¿Su hijo presenta problemas al hablar?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta5, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta5)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                    //Pregunta
                    
                    Text("6: ¿Su hijo requiere que usted suba el tono de voz para acatar indicaciones?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta6, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta6)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                    Text("7: ¿Su hijo es facil de irritar al no cumplir algun deseo suyo?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta7, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta7)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                    Text("8: ¿Su hijo presenta dificultades para seguir indicaciones?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta8, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta8)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                    Text("9: ¿Su hijo se comporta de forma anormal a otros niños de su edad?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta9, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta9)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                    Text("10: ¿Su hijo presenta problemas de aprendizaje?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta10, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta10)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                    Text("11: ¿Su hijo tiene dificultades para seguir multiples indicaciones?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta11, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta11)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                    Text("12: ¿Su hijo presenta problemas para mantener la atención en una conversacion?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta12, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta12)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                    Text("13: ¿Su hijo usa un lenguaje descortés y no respeta los turnos de conversacion?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta13, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta13)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                    Text("14: ¿Su hijo presenta una débil comunicación a la hora de expresar sus deseos?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta14, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta14)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                    Text("15: ¿Su hijo no presenta coherencia en sus palabras al momento de expresar sus ideas?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta15, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta15)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                    Text("16: ¿Su hijo suele desistir de sus actividades cuando falla?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta16, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta16)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                    Text("17: ¿Su hijo maneja de forma negativa llamados de atencion?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta17, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta17)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                    Text("18: ¿Su hijo reaccciona de manera negativa cuando un evento no resulta como lo esperaba?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta18, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta18)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                    Text("19: ¿Su hijo tiene dificultades para comprender expresiones coloquiales?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta19, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta19)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                    Text("20: ¿Su hijo tiene dificultades para entender expresiones humanas?")
                    
                    //Slider
                    
                    VStack(spacing: 8) {
                        Slider(value: $respuesta20, in: 0...4, step: 1)
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                        Text(grados[Int(respuesta20)])
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(.vertical, 8)
                    //
                }
                // Ejemplo simple de pregunta
                /*Text("1: ¿Su hijo responde a su nombre?")
                 HStack(spacing: 12) {
                 Button("Sí") { respuestas[1] = 1 }
                 Button("No") { respuestas[1] = 0 }
                 }*/
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Button("Enviar respuestas") {
                enviado = true
                print("Respuestas:", respuestas)
                
                var VeR = respuesta2 + respuesta4 + respuesta5 + respuesta9 + respuesta14 + respuesta15 + respuesta13
                var VrR = respuesta1 + respuesta6 + respuesta8 + respuesta10 + respuesta11 + respuesta12 + respuesta19 + respuesta20
                var FR = respuesta3 + respuesta7 + respuesta16 + respuesta17 + respuesta18
                
                var En = (8 - 5)/5
                var Ve = VeR/28
                var Vr = VrR/32
                var F = FR/20
                
                var N = 50*Ve + 30*Vr + 20*En - F*15
            }
            .buttonStyle(.borderedProminent)
            
            if enviado {
                Text("¡Gracias por completar el cuestionario!")
                    .foregroundStyle(.green)
            }
        }
        .padding()
        .navigationTitle("Cuestionario")
    }
    
    
    
}
*/
/*
struct Cuestionario1View: View {
    let cuestionarioID: UUID
    @State private var respuestas: [Int: Double] = [:] // Almacena respuestas 2-20
    @State private var respuesta1: Bool = false // Respuesta especial para la pregunta 1 (Sí/No)
    @State private var enviado = false
    @State private var mostrarAlerta = false
    
    let grados = ["Nunca", "Rara vez", "A veces", "Casi siempre", "Siempre"]
    
    // Array con todas las preguntas
    let preguntas = [
        "1: ¿Su hijo responde a su nombre?",
        "2: ¿Su hijo en ocasiones se comporta distinto o prefiere estar solo?",
        "3: ¿A su hijo le cuesta controlar sus emociones o reacciona de manera espontánea?",
        "4: ¿Su hijo es sensible a multitudes?",
        "5: ¿Su hijo presenta problemas al hablar?",
        "6: ¿Su hijo requiere que usted suba el tono de voz para acatar indicaciones?",
        "7: ¿Su hijo es fácil de irritar al no cumplir algún deseo suyo?",
        "8: ¿Su hijo presenta dificultades para seguir indicaciones?",
        "9: ¿Su hijo se comporta de forma anormal a otros niños de su edad?",
        "10: ¿Su hijo presenta problemas de aprendizaje?",
        "11: ¿Su hijo tiene dificultades para seguir múltiples indicaciones?",
        "12: ¿Su hijo presenta problemas para mantener la atención en una conversación?",
        "13: ¿Su hijo usa un lenguaje descortés y no respeta los turnos de conversación?",
        "14: ¿Su hijo presenta una débil comunicación a la hora de expresar sus deseos?",
        "15: ¿Su hijo no presenta coherencia en sus palabras al momento de expresar sus ideas?",
        "16: ¿Su hijo suele desistir de sus actividades cuando falla?",
        "17: ¿Su hijo maneja de forma negativa llamados de atención?",
        "18: ¿Su hijo reacciona de manera negativa cuando un evento no resulta como lo esperaba?",
        "19: ¿Su hijo tiene dificultades para comprender expresiones coloquiales?",
        "20: ¿Su hijo tiene dificultades para entender expresiones humanas?"
    ]
    /*
    // Computed property para verificar si todas las preguntas están respondidas
    var todasRespondidas: Bool {
        // Verificar que todas las preguntas del 2 al 20 tengan respuesta
        for i in 2...20 {
            if respuestas[i] == nil {
                return false
            }
        }
        return true
    }
    
    // Calcular puntaje total (solo preguntas 2-20, cada una de 0 a 4)
    var puntajeTotal: Double {
        var total: Double = 0
        for i in 2...20 {
            if let valor = respuestas[i] {
                total += valor
            }
        }
        return total
    }
     
    */
     
    
    // Calcular nivel de riesgo basado en el puntaje
    /*
    var nivelRiesgo: (nivel: String, color: Color, mensaje: String) {
        let maximoPosible = Double(19 * 4) // 19 preguntas * 4 puntos máximos
        let porcentaje = (puntajeTotal / maximoPosible) * 100
        
        switch porcentaje {
        case 0..<25:
            return ("Bajo", .green, "Los resultados indican un bajo nivel de riesgo. Continúa observando el desarrollo de tu hijo.")
        case 25..<50:
            return ("Moderado", .yellow, "Se observan algunos indicadores que podrían requerir atención. Considera consultar con un especialista.")
        case 50..<75:
            return ("Elevado", .orange, "Los resultados muestran varios indicadores de riesgo. Te recomendamos buscar evaluación profesional.")
        default:
            return ("Muy Elevado", .red, "Los resultados indican múltiples áreas de preocupación. Es importante buscar evaluación profesional lo antes posible.")
        }
    }
     
     */
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Cuestionario de Evaluación")
                .font(.title)
                .bold()
                .padding(.top)
            
            Text("Por favor, responde todas las preguntas basándote en el comportamiento de tu hijo en los últimos 6 meses")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 24) {
                    // Pregunta 1 (Toggle especial Sí/No)
                    VStack(alignment: .leading, spacing: 12) {
                        Text(preguntas[0])
                            .font(.headline)
                            .fontWeight(.medium)
                        
                        HStack(spacing: 20) {
                            Button(action: { respuesta1 = true }) {
                                HStack {
                                    Image(systemName: respuesta1 ? "checkmark.circle.fill" : "circle")
                                    Text("Sí")
                                }
                                .foregroundColor(respuesta1 ? .green : .primary)
                            }
                            
                            Button(action: { respuesta1 = false }) {
                                HStack {
                                    Image(systemName: !respuesta1 && respuesta1 != nil ? "checkmark.circle.fill" : "circle")
                                    Text("No")
                                }
                                .foregroundColor(!respuesta1 && respuesta1 != nil ? .red : .primary)
                            }
                        }
                        .padding(.leading)

                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    
                    // Preguntas 2 a 20 (Slider)
                    ForEach(2...5, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 12) {
                            Text(preguntas[index - 1])
                                .font(.headline)
                                .fontWeight(.medium)
                            
                            VStack(spacing: 8) {
                                Slider(
                                    value: Binding(
                                        get: { respuestas[index, default: 0] },
                                        set: { respuestas[index] = $0 }
                                    ),
                                    in: 0...4,
                                    step: 1
                                )
                                .tint(colorParaValor(respuestas[index, default: 0]))
                                
                                Text(grados[Int(respuestas[index, default: 0])])
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .fontWeight(.medium)
                                
                                // Indicador visual de selección
                                HStack {
                                    ForEach(0..<5) { grado in
                                        Circle()
                                            .fill(colorParaGrado(grado, seleccionado: Int(respuestas[index, default: 0])) == grado)
                                            .frame(width: 8, height: 8)
                                            .onTapGesture {
                                                respuestas[index] = Double(grado)
                                            }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }
            /*
            // Mostrar progreso
            VStack(spacing: 12) {
                let respondidas = respuestas.filter { $0.key >= 2 && $0.key <= 20 }.count
                ProgressView(value: Double(respondidas), total: 19) {
                    Text("Progreso: \(respondidas)/19 preguntas respondidas")
                        .font(.caption)
                }
                .tint(.blue)
                .padding(.horizontal)
            }
            
            
            Button(action: {
                if todasRespondidas {
                    enviado = true
                    // Aquí puedes agregar la lógica para guardar las respuestas
                    guardarRespuestas()
                } else {
                    mostrarAlerta = true
                }
            }) {
                Text("Enviar respuestas")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(todasRespondidas ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!todasRespondidas)
            .padding(.horizontal)
            .padding(.bottom)
            */
            
            /*
            if enviado {
                VStack(spacing: 12) {
                    Text("¡Gracias por completar el cuestionario!")
                        .foregroundStyle(.green)
                        .fontWeight(.semibold)
                    
                    // Mostrar resultados
                    VStack(spacing: 8) {
                        Text("Resultados:")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text("Puntaje total: \(Int(puntajeTotal)) de \(19 * 4) puntos")
                            .font(.subheadline)
                        
                        Text("Nivel de riesgo: \(nivelRiesgo.nivel)")
                            .foregroundColor(nivelRiesgo.color)
                            .fontWeight(.bold)
                        
                        Text(nivelRiesgo.mensaje)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            */
            
        }
        /*
        .alert("Preguntas incompletas", isPresented: $mostrarAlerta) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Por favor, responde todas las preguntas antes de enviar el cuestionario.")
        }
        .navigationTitle("Cuestionario")
        .navigationBarTitleDisplayMode(.inline)
        */
    }
    
    // Función auxiliar para el color del slider
    func colorParaValor(_ valor: Double) -> Color {
        switch Int(valor) {
        case 0: return .green
        case 1: return .green.opacity(0.8)
        case 2: return .yellow
        case 3: return .orange
        case 4: return .red
        default: return .blue
        }
    }
    
    // Función auxiliar para saber si un grado está seleccionado
    func colorParaGrado(_ grado: Int, seleccionado: Int) -> Color {
        if grado == seleccionado {
            return .blue
        } else if grado < seleccionado {
            return .blue.opacity(0.3)
        } else {
            return .gray.opacity(0.3)
        }
    }
    
    
    // Función para guardar respuestas (puedes expandirla según necesites)
    func guardarRespuestas() {
        print("=== RESULTADOS DEL CUESTIONARIO ===")
        print("ID del cuestionario: \(cuestionarioID)")
        print("\nPregunta 1: \(respuesta1 ? "Sí" : "No")")
        
        for index in 2...20 {
            if let valor = respuestas[index] {
                print("Pregunta \(index): \(grados[Int(valor)])")
            }
        }
        
        
        //print("Nivel de riesgo: \(nivelRiesgo.nivel)")
        print("================================")
        
        // Aquí puedes agregar lógica para:
        // - Guardar en UserDefaults
        // - Enviar a un servidor
        // - Guardar en CoreData
        // - etc.
    }
}
*/
