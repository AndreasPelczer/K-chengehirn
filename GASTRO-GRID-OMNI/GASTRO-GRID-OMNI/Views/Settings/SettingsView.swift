import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                List {
                    // --- SEKTION: ROLLEN-WECHSEL (DEIN WUNSCH) ---
                    Section(header: Text("ROLLEN-SIMULATION (DEMO-MODUS)").foregroundColor(.gray)) {
                        VStack(spacing: 12) {
                            roleButton(title: "DIRECTOR (CHEF)", icon: "crown.fill", role: .director, color: .yellow)
                            roleButton(title: "DISPATCHER (PLANER)", icon: "person.2.badge.gearshape.fill", role: .dispatcher, color: .orange)
                            roleButton(title: "CREW (MITARBEITER)", icon: "person.fill", role: .crew, color: env.neonGreen)
                        }
                        .padding(.vertical, 8)
                    }
                    
                    Section(header: Text("SPRACHE").foregroundColor(.gray)) {
                        Picker("App Sprache", selection: $env.userLanguage) {
                            Text("Deutsch 🇩🇪").tag("de")
                            Text("English 🇺🇸").tag("en")
                            Text("Español 🇪🇸").tag("es")
                        }
                    }
                    
                    Section(header: Text("SYSTEM").foregroundColor(.gray)) {
                        HStack {
                            Text("Status:")
                            Spacer()
                            Text(env.currentUserRole.rawValue.uppercased())
                                .foregroundColor(env.neonGreen).bold()
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("EINSTELLUNGEN")
        }
    }
    
    // Hilfsfunktion für die Rollen-Buttons
    private func roleButton(title: String, icon: String, role: GlobalEnvironment.UserRole, color: Color) -> some View {
        Button(action: {
            withAnimation {
                env.currentUserRole = role
            }
        }) {
            HStack {
                Image(systemName: icon)
                Text(title)
                Spacer()
                if env.currentUserRole == role {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(color)
                }
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)
            .foregroundColor(env.currentUserRole == role ? color : .white)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
