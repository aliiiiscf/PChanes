/*

VStack(spacing: 24) {
    
    
    // Preguntas 2 a 20 (Slider)
    ForEach(11...20, id: \.self) { index in
        VStack(alignment: .leading, spacing: 12) {
            Text(preguntas[index - 11])
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
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}


*/
