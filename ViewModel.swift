import SoundAnalysis
import AVFoundation
import FoundationModels
import Foundation
import Combine

@MainActor
class ViewModel: ObservableObject{
    @Published var input: String = ""
    @Published var output: String = ""
    @Published var isProcessing = false
    @Published var errorMessage: String? = nil
    
    private let model = SystemLanguageModel.default
    
    func runModel() async {
        
        guard model.isAvailable else {
            errorMessage = "Model not aviable"
            return
        }
        
        isProcessing = true
        errorMessage = nil
        
        let prompt = input.isEmpty ? "Eres un especialista en intervención temprana pediatrica y patología dellenguaje.Vas a hablarle al tutor del niño directamente y en primerapersona con un tono empático, comprensivo, profesional y esperanzador.Prompt mensaje de evaluación Evaluamos a un niño de n años en el que de valores con soporte (0, 100) con 0 el nivel más bajo y el 100 el más alto, obtuvo, según nuestra evaluación el nivel 60. Redacta un mensaje de bienvenida de máximo 100 palabras, el objetivo es validar los sentimientos de frustración del niño resaltar cuales son las fortalezas y debilidades,dando así razones para empezar en el nivel asignado. No des diagnosticos medicos ni promesas de cura" : input
        let session = LanguageModelSession()
        
        do{
            let response = try await session.respond(to: prompt)
            output = response.content
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isProcessing = false
        
    }
    
}
