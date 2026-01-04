import SwiftUI

@main
struct GastroGridApp: App {
    // 1. CoreData Controller initialisieren (Unser Datentresor)
    let persistenceController = PersistenceController.shared
    
    // 2. Die globale Umgebung (Rolle, Sprache, Design)
    @StateObject private var globalEnv = GlobalEnvironment()

    var body: some Scene {
        WindowGroup {
            // Der Einstiegspunkt ist unsere RootTabView (Datei 7)
            RootTabView()
                // Den Datenbank-Kontext für alle Views verfügbar machen
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                // Die globale Umgebung injizieren (Zuständigkeiten/Sprache)
                .environmentObject(globalEnv)
                // App-weit den Dark Mode erzwingen (Frankfurt Style)
                .preferredColorScheme(.dark)
        }
    }
}
