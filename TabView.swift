import SwiftUI

let upperTitle: CGFloat = 14
let title: CGFloat = 56
let tagSize: CGFloat = 18
let nombreSize: CGFloat = 32
let descripcionSize: CGFloat = 18
let estadoSize: CGFloat = 14

// MARK: - MainTabView
struct MainTabView: View {
    @State private var tabSeleccionado = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.lino.ignoresSafeArea()
            

            VStack(spacing: 0) {
                // Contenido según tab
                Group {
                    switch tabSeleccionado {
                    case 0: ActividadesTab()
                    case 1: RetosTab()
                    case 2: ProgresoTab()
                    case 3: AjustesTab()
                    default: ActividadesTab()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Tab Bar personalizado
                VinculoTabBar(seleccionado: $tabSeleccionado)
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Tab Bar personalizado
struct VinculoTabBar: View {
    @Binding var seleccionado: Int

    let tabs: [(icono: String, etiqueta: String)] = [
        ("house", "Actividades"),
        ("star", "Retos"),
        ("chart.line.uptrend.xyaxis", "Progreso"),
        ("person", "Ajustes")
    ]

    var body: some View {
        VStack(spacing: 0) {
            Divider().background(Color.linoDark)
            HStack(spacing: 0) {
                ForEach(0..<4) { i in
                    Button(action: { seleccionado = i }) {
                        VStack(spacing: 5) {
                            Image(systemName: tabs[i].icono)
                                .font(.system(size: 18, weight: .light))
                                .foregroundColor(seleccionado == i ? .slateDark : .textLight)

                            Text(tabs[i].etiqueta)
                                .font(.system(size: upperTitle, weight: .regular))
                                .kerning(1.5)
                                .textCase(.uppercase)
                                .foregroundColor(seleccionado == i ? .slateDark : .textLight)

                            // Indicador activo
                            Circle()
                                .fill(Color.slateDark)
                                .frame(width: 4, height: 4)
                                .opacity(seleccionado == i ? 1 : 0)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                        .padding(.bottom, 16)
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(Color.cream)
        }
    }
}


// MARK: - ACTIVIDADES TAB
struct ActividadesTab: View {
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(alignment: .leading, spacing: 4) {
                Text("Vínculo · Nivel 1")
                    .font(.system(size: upperTitle, weight: .light))
                    .kerning(2.5)
                    .textCase(.uppercase)
                    .foregroundColor(.textLight)
                Text("Actividades")
                    .font(.custom("Georgia", size: title))
                    .foregroundColor(.textDark)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.vertical, 20)

            Divider().background(Color.linoDark)

            ScrollView {
                VStack(spacing: 12) {
                    ActividadCard(
                        tag: "Hoy · 5 min",
                        nombre: "Cuento del día",
                        descripcion: "Escucha y responde preguntas sobre el relato",
                        progreso: 0.0,
                        destacada: true
                    )
                    ActividadCard(
                        tag: "Lenguaje · 10 min",
                        nombre: "Describe la imagen",
                        descripcion: "Practica vocabulario descriptivo",
                        progreso: 0.6,
                        destacada: false
                    )
                    ActividadCard(
                        tag: "Atención · 8 min",
                        nombre: "Secuencia de pasos",
                        descripcion: "Sigue instrucciones en orden",
                        progreso: 1.0,
                        destacada: false
                    )
                    ActividadCard(
                        tag: "Social · 7 min",
                        nombre: "¿Cómo se siente?",
                        descripcion: "Identifica emociones en fotografías",
                        progreso: 0.3,
                        destacada: false
                    )
                }
                .padding(20)
            }
        }
    }
}

struct ActividadCard: View {
    let tag: String
    let nombre: String
    let descripcion: String
    let progreso: Double
    let destacada: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            // Ícono
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.slateLight, lineWidth: 1)
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: progreso == 1.0 ? "checkmark" : "play")
                        .font(.system(size: 12, weight: .light))
                        .foregroundColor(.slate)
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(tag)
                    .font(.system(size: tagSize, weight: .regular))
                    .kerning(1.5)
                    .textCase(.uppercase)
                    .foregroundColor(.slate)

                Text(nombre)
                    .font(.custom("Georgia", size: nombreSize))
                    .foregroundColor(.textDark)
                    .padding(.top, 6)

                Text(descripcion)
                    .font(.system(size: descripcionSize, weight: .light))
                    .foregroundColor(.textMid)
                    .lineSpacing(2)
                    .padding(.top, 6)

                // Barra de progreso
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle().fill(Color.linoDark).frame(height: 2)
                        Rectangle().fill(Color.slateDark).frame(width: geo.size.width * progreso, height: 2)
                    }
                }
                .frame(height: 2)
                .padding(.top, 12)
            }
        }
        .padding(16)
        .background(destacada ? Color.white : Color.cream)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(destacada ? Color.slate : Color.linoDark, lineWidth: destacada ? 1 : 0.5)
        )
    }
}


// MARK: - RETOS TAB
struct RetosTab: View {
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Esta semana")
                    .font(.system(size: upperTitle, weight: .light))
                    .kerning(2.5)
                    .textCase(.uppercase)
                    .foregroundColor(.textLight)
                Text("Retos")
                    .font(.custom("Georgia", size: title))
                    .foregroundColor(.textDark)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.vertical, 20)

            Divider().background(Color.linoDark)

            ScrollView {
                VStack(spacing: 12) {
                    RetoCard(numero: "01", titulo: "Conversación de 3 turnos",
                             descripcion: "Mantén un diálogo de al menos 3 intercambios sin cambio de tema.",
                             puntos: 50, estado: .activo)
                    RetoCard(numero: "02", titulo: "Nombrar 5 emociones",
                             descripcion: "Ayuda a tu hijo a identificar y nombrar cinco emociones durante el día.",
                             puntos: 80, estado: .pendiente)
                    RetoCard(numero: "03", titulo: "Lectura en voz alta",
                             descripcion: "Leer un cuento completo con pausas para preguntar sobre la historia.",
                             puntos: 40, estado: .completado)
                }
                .padding(20)
            }
        }
    }
}

enum EstadoReto { case activo, pendiente, completado }

struct RetoCard: View {
    let numero: String
    let titulo: String
    let descripcion: String
    let puntos: Int
    let estado: EstadoReto

    var estadoTexto: String {
        switch estado { case .activo: return "Activo"; case .pendiente: return "Pendiente"; case .completado: return "Completado" }
    }
    var estadoColor: Color {
        switch estado { case .activo: return .slate; case .pendiente: return .slateLight; case .completado: return .textLight }
    }
    var accionTexto: String {
        switch estado { case .activo: return "Iniciar"; case .pendiente: return "Ver"; case .completado: return "Listo" }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(numero)
                    .font(.custom("Georgia", size: 28))
                    .foregroundColor(Color.slate)
                Spacer()
                Text(estadoTexto)
                    .font(.system(size: estadoSize, weight: .regular))
                    .kerning(1.5)
                    .textCase(.uppercase)
                    .foregroundColor(estadoColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .overlay(RoundedRectangle(cornerRadius: 2).stroke(estadoColor, lineWidth: 1))
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 10)

            Divider().background(Color.linoDark).padding(.horizontal, 16)

            VStack(alignment: .leading, spacing: 4) {
                Text(titulo)
                    .font(.custom("Georgia", size: nombreSize))
                    .foregroundColor(.textDark)
                Text(descripcion)
                    .font(.system(size: descripcionSize, weight: .light))
                    .foregroundColor(.textMid)
                    .lineSpacing(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)

            Divider().background(Color.linoDark).padding(.horizontal, 16)

            HStack {
                Text("Puntos +\(puntos)")
                    .font(.system(size: tagSize, weight: .light))
                    .kerning(1)
                    //.textCase(.uppercase)
                    //.foregroundColor(.textLight)

                Spacer()

                Text(accionTexto)
                    .font(.system(size: estadoSize, weight: .regular))
                    .kerning(1.5)
                    .textCase(.uppercase)
                    .foregroundColor(estado == .completado ? .textLight : .slateDark)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(estado == .completado ? Color.linoDark : Color.slate, lineWidth: 1)
                    )
                    .opacity(estado == .completado ? 0.5 : 1)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color.cream)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.linoDark, lineWidth: 0.5))
    }
}


// MARK: - PROGRESO TAB
struct ProgresoTab: View {
    let areas: [(nombre: String, valor: Double)] = [
        ("Lenguaje", 0.68),
        ("Atención", 0.45),
        ("Social", 0.52),
        ("Emocional", 0.38)
    ]
    let hitos: [(texto: String, fecha: String, completado: Bool)] = [
        ("Primera evaluación", "Hoy", true),
        ("3 actividades completadas", "Esta sem.", true),
        ("Primer reto completado", "Pendiente", false),
        ("Alcanzar nivel 3", "Pendiente", false)
    ]

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Seguimiento")
                    .font(.system(size: upperTitle, weight: .light))
                    .kerning(2.5)
                    .textCase(.uppercase)
                    .foregroundColor(.textLight)
                Text("Progreso")
                    .font(.custom("Georgia", size: title))
                    .foregroundColor(.textDark)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.vertical, 20)

            Divider().background(Color.linoDark)

            ScrollView {
                VStack(spacing: 0) {
                    // Tarjeta de nivel
                    HStack(spacing: 16) {
                        ZStack {
                            Circle().stroke(Color.linoDark, lineWidth: 3).frame(width: 60, height: 60)
                            Circle()
                                .trim(from: 0, to: 0.32)
                                .stroke(Color.slateDark, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .frame(width: 60, height: 60)
                            Text("2")
                                .font(.custom("Georgia", size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.slateDark)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Nivel actual")
                                .font(.system(size: tagSize, weight: .light))
                                .kerning(2)
                                .textCase(.uppercase)
                                .foregroundColor(.textLight)
                            Text("Comunicación en desarrollo")
                                .font(.custom("Georgia", size: nombreSize))
                                .foregroundColor(.textDark)
                            Text("32 / 100 puntos para nivel 3")
                                .font(.system(size: descripcionSize, weight: .light))
                                .foregroundColor(.textMid)
                                .padding(.top, 1)
                        }
                        Spacer()
                    }
                    .padding(20)
                    .background(Color.white)

                    Divider().background(Color.linoDark)

                    // Áreas
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Áreas evaluadas")
                            .font(.system(size: tagSize, weight: .light))
                            .kerning(2.5)
                            .textCase(.uppercase)
                            .foregroundColor(.textLight)
                            .padding(.bottom, 4)

                        ForEach(areas, id: \.nombre) { area in
                            HStack(spacing: 10) {
                                Text(area.nombre)
                                    .font(.system(size: descripcionSize, weight: .light))
                                    .foregroundColor(.textDark)
                                    .frame(width: 120, alignment: .leading)

                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Rectangle().fill(Color.linoDark).frame(height: 2.5)
                                        Rectangle().fill(Color.slateDark).frame(width: geo.size.width * area.valor, height: 2.5)
                                    }
                                    .cornerRadius(2)
                                }
                                .frame(height: 2.5)

                                Text("\(Int(area.valor * 100))%")
                                    .font(.system(size: estadoSize, weight: .light))
                                    .foregroundColor(.textMid)
                                    .frame(width: 48, alignment: .trailing)
                            }
                        }
                    }
                    .padding(20)

                    Divider().background(Color.linoDark)

                    // Hitos
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Hitos")
                            .font(.system(size: tagSize, weight: .light))
                            .kerning(2.5)
                            .textCase(.uppercase)
                            .foregroundColor(.textLight)
                            .padding(.bottom, 4)

                        ForEach(hitos, id: \.texto) { hito in
                            HStack(spacing: 10) {
                                Circle()
                                    .fill(hito.completado ? Color.slateDark : Color.linoDark)
                                    .frame(width: 8, height: 8)
                                Text(hito.texto)
                                    .font(.system(size: descripcionSize, weight: .light))
                                    .foregroundColor(.textDark)
                                Spacer()
                                Text(hito.fecha)
                                .font(.system(size: estadoSize, weight: .light))
                                    .foregroundColor(.textLight)
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
    }
}


// MARK: - AJUSTES TAB
struct AjustesTab: View {
    @State private var notificaciones = true
    @State private var modoAcompanante = true

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Vínculo")
                    .font(.system(size: upperTitle, weight: .light))
                    .kerning(2.5)
                    .textCase(.uppercase)
                    .foregroundColor(.textLight)
                Text("Ajustes")
                    .font(.custom("Georgia", size: title))
                    .foregroundColor(.textDark)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.vertical, 20)

            Divider().background(Color.linoDark)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    AjustesSectionHeader("Perfil")
                    AjustesRow(nombre: "Nombre del niño", subtitulo: "Mateo García")
                    AjustesRow(nombre: "Edad", subtitulo: "7 años")
                    AjustesRow(nombre: "Reevaluar", subtitulo: "Volver a hacer cuestionario")

                    AjustesSectionHeader("Preferencias")
                    AjustesToggleRow(nombre: "Notificaciones", subtitulo: "Recordatorios diarios", isOn: $notificaciones)
                    AjustesToggleRow(nombre: "Modo acompañante", subtitulo: "Actividades guiadas para padres", isOn: $modoAcompanante)
                    AjustesRow(nombre: "Idioma", subtitulo: "Español")

                    AjustesSectionHeader("Acerca de")
                    AjustesRow(nombre: "Versión", subtitulo: "1.0.0", chevron: false)
                    AjustesRow(nombre: "Cerrar sesión", subtitulo: nil, destructivo: true, chevron: false)
                }
                .padding(.bottom, 32)
            }
        }
    }
}

struct AjustesSectionHeader: View {
    let titulo: String
    init(_ titulo: String) { self.titulo = titulo }
    var body: some View {
        Text(titulo)
            .font(.system(size: tagSize, weight: .light))
            .kerning(2.5)
            .textCase(.uppercase)
            .foregroundColor(.textLight)
            .padding(.horizontal, 24)
            .padding(.top, 42)
            .padding(.bottom, 8)
    }
}

struct AjustesRow: View {
    let nombre: String
    let subtitulo: String?
    var destructivo: Bool = false
    var chevron: Bool = true

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(nombre)
                    .font(.system(size: nombreSize-6, weight: .regular))
                    .foregroundColor(destructivo ? Color.textLight : Color.textMid)
                if let sub = subtitulo {
                    Text(sub)
                        .font(.system(size: descripcionSize, weight: .light))
                        .foregroundColor(.textLight)
                }
            }
            Spacer()
            if chevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .light))
                    .foregroundColor(.textLight)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .overlay(Divider().background(Color.linoDark).padding(.horizontal, 24), alignment: .bottom)
    }
}

struct AjustesToggleRow: View {
    let nombre: String
    let subtitulo: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(nombre)
                    .font(.system(size: nombreSize-6, weight: .regular))
                    .foregroundColor(.textMid)
                Text(subtitulo)
                    .font(.system(size: descripcionSize, weight: .light))
                    .foregroundColor(.textLight)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(Color.slateDark)
                .labelsHidden()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .overlay(Divider().background(Color.linoDark).padding(.horizontal, 24), alignment: .bottom)
    }
}

// MARK: - Extensión Color (si no existe en otro archivo)
extension Color {
    static let linoMid     = Color(red: 0.784, green: 0.765, blue: 0.690)  // #C8C3B0
}

#Preview("MainTab") {
    MainTabView()
}

