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
                default:
                    Text("No hay nada")
                    /*
                case .cuestionario(let id):
                    
                     Cuestionario2View(cuestionarioID: id)
                */
                     }
            }
            
            HStack(spacing: 15){
                NavigationLink(destination: NewCuestionarioView(cuestionarioID: UUID())) {
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
            Text("VÍNCULO")
                .bold()
                .font(.custom("Georgia", size: 48))
                .foregroundColor(.textDark)
                .padding(64)
            Button(action: {
                // TODO: Handle sign-in action
                print("Sign In tapped")
                loggedIn = true
            }) {
                Text("Iniciar")
                    .bold()
                    .font(.system(size: 36, weight: .regular))
                    .foregroundColor(.textDark)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
            }
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.cream)
            )
            
            .cornerRadius(6)
            
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }
}



#Preview {
    NavigationStack {
        ContentView()
    }
}
