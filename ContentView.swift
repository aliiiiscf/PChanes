//
//  ContentView.swift
//  App_2026_02
//
//  Created by CEDAM24 on 23/03/26.
//

import SwiftUI
import FoundationModels

enum Route: Hashable {
    case detailInt(Int)
    case cuestionario(id: UUID)
}

struct GenerativeView: View {
    // Create a reference to the system language model.
    private var model = SystemLanguageModel.default


    var body: some View {
        switch model.availability {
        case .available:
            Text("IA Disponible")
        case .unavailable(.deviceNotEligible):
            Text("IA Disponible")
        case .unavailable(.appleIntelligenceNotEnabled):
            Text("IA Disponible")
        case .unavailable(.modelNotReady):
            // The model isn't ready because it's downloading or because
            // of other system reasons.
            Text("IA Disponible")
        case .unavailable(let _other):
            // The model is unavailable for an unknown reason.
            Text("IA Disponible")
        }
    }
}

struct ContentView: View {
    @State var loggedIn = false

    var body: some View {
        if loggedIn{
            LoggedView()
        } else {
            LoginView(loggedIn: $loggedIn)
        }
        
        
    }
}

struct LoggedView: View {
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) { //
            Text("Bienvenido ¿Quién está usando esta app?")
                .multilineTextAlignment(.center)
                .font(.system(size: 48))
                .font(.title)
            /*
            List {
                NavigationLink("Load 1", value: Route.detailInt(1))
                Button("Push 99") { path.append(Route.detailInt(99)) } //
            }
             */
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .detailInt(let num):
                    Text("Detail \(num)")
                case .cuestionario(let id):
                    Cuestionario2View(cuestionarioID: id)
                }
            }
            
            HStack(spacing: 15){
                Button(action: {
                    // Navega al cuestionario empujando una ruta específica
                    path.append(Route.cuestionario(id: UUID()))
                    print("Navegando al cuestionario")
                    
                }) {
                    Text("Padre")
                        .bold()
                        .font(.system(size: 48))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 48)
                .padding(.vertical, 12)
                .navigationTitle("Inicio") //
                
                Button(action: {
                    // Navega al cuestionario empujando una ruta específica
                    path.append(Route.cuestionario(id: UUID()))
                    print("Navegando al cuestionario")
                    
                }) {
                    Text("Hijo")
                        .bold()
                        .font(.system(size: 48))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 48)
                .padding(.vertical, 12)
            }
            
        }
        /*
        VStack(spacing: 16){
            Text("Bienvenido ¿Quién está usando esta app?")
                .multilineTextAlignment(.center)
                .font(.system(size: 48))
                .font(.title)
            HStack {
                Button(action: {
                    // TODO: Handle sign-in action
                    print("Sign In tapped")
                }) {
                    Text("Padre")
                        .bold()
                        .font(.system(size: 48))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal, 48)
                .padding(.vertical, 12)
                Button(action: {
                    // TODO: Handle sign-in action
                    print("Sign In tapped")
                }) {
                    Text("Hijo")
                        .bold()
                        .font(.system(size: 48))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        */
    }
}

struct LoginView: View {
    @Binding var loggedIn: Bool
    
    
    
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "star")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("App")
                .bold()
                .font(.system(size: 48))
            Button(action: {
                // TODO: Handle sign-in action
                print("Sign In tapped")
                loggedIn = true
            }) {
                Text("Iniciar")
                    .bold()
                    .font(.system(size: 48))
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}

struct Cuestionario2View: View {
    let cuestionarioID: UUID
    @State private var edad = 5
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
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Cuestionario de Evaluación")
                .font(.title)
                .bold()
                .padding(.top)
            
            ScrollView(.vertical, showsIndicators: true){
                VStack(spacing: 12){
                    Stepper("Edad de su hijo: \(edad)", value: $edad, in: 5...10, step: 1)
                                    .padding()
                                    .frame(maxWidth: 400)
                                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 22){
                        Text(preguntas[0])
                        
                    }
                    
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
                    
                    ForEach(2...20, id: \.self){ index in
                                        
                        VStack(alignment: .leading, spacing: 22){
                            Text(preguntas[index-1])
                            
                        }
                        
                        //Slider
                        
                        VStack(spacing: 8) {
                            Slider(
                                value: Binding(
                                    get: { respuestas[index, default: 0] },
                                    set: { respuestas[index] = $0 }
                                ),
                                in: 0...4,
                                step: 1
                            )
                            .frame(maxWidth: 300)
                            .frame(maxWidth: .infinity, alignment: .center)
                            
                            // Etiquetas 0–5 bajo el control, distribuidas uniformemente
                            Text(grados[Int(respuestas[index, default: 0])])
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .fontWeight(.medium)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            /*
            Button("Enviar respuestas") {
                enviado = true
                print("Respuestas:", respuestas)
                
                var VeR = preguntas[1] + preguntas[3] + preguntas[4] + preguntas[8] + preguntas[12] + preguntas[13] + preguntas[14]
                var VrR = respuesta1 + preguntas[5] + preguntas[1] + preguntas[7] + preguntas[9] + preguntas[10] + preguntas[11] + preguntas[18] + preguntas[19]
                var FR = preguntas[2] + preguntas[6] + preguntas[15] + preguntas[16] + preguntas[17]
                
                var En = (8 - 5)/5
                var Ve = VeR/28
                var Vr = VrR/32
                var F = FR/20
                
                var N = 50*Ve + 30*Vr + 20*En - F*15
            }
            .buttonStyle(.borderedProminent)
             */
            
        }
    }
    
}

#Preview {
    Cuestionario2View(cuestionarioID: UUID())
}
