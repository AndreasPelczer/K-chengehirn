//
//  MissionViewModel.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//

import Foundation
import SwiftUI

/// Steuert die Daten für das Mitarbeiter-Briefing.
/// Lädt Missionen und die dazugehörigen detaillierten Arbeitsaufträge (DetailedTasks).
class MissionViewModel: ObservableObject {
    
    // Die aktuell zugewiesene Mission für den angemeldeten User
    @Published var currentMission: Mission?
    
    // Zugriff auf die globalen Einstellungen (Sprache/Rolle)
    var globalEnv: GlobalEnvironment
    
    /// Initialisierung mit Dependency Injection
    init(env: GlobalEnvironment) {
        self.globalEnv = env
        loadMockMission()
    }
    
    /// Erstellt eine Beispiel-Mission mit DEINEM Petersilien-Auftrag
    private func loadMockMission() {
        let testVenue = Venue(
            name: "Zentralküche Frankfurt",
            type: .produktionsKueche,
            halle: "Halle 1 - Süd"
        )
        
        let basisTask1 = MissionTask(titelKey: "HACCP_CHECK", beschreibungKey: "Kühlkette prüfen")
        let basisTask2 = MissionTask(titelKey: "MESSER_SCHAERFEN", beschreibungKey: "Global Messer-Set bereitstellen")
        
        // KORREKTUR: Wir erstellen hier jetzt einen 'DetailedTask' statt 'ProductionTask'
        let pTask = DetailedTask(
            id: UUID(),
            titel: "Vorbereitung: Petersilie für VA 345",
            hardware: "Hortenwagen 7 / Schwarzes Blech",
            ware: ["5 Bund Petersilie frisch"],
            anweisung: "Petersilie fein hacken, auf schwarzen Blechen verteilen.",
            zielOrt: "Kühlhaus 3 / Tageskühlung",
            geplanteDauerMinuten: 30
        )
        
        // Die Mission akzeptiert jetzt in 'produktionstasks' das Array [DetailedTask]
        self.currentMission = Mission(
            id: UUID(),
            titel: "VA 345 - Gala Dinner",
            mitarbeiterName: "Andreas",
            venueID: testVenue.id,
            ort: testVenue,
            rolle: .station,
            aufgaben: [basisTask1, basisTask2],
            produktionstasks: [pTask], // Hier landet der DetailedTask sauber im Array
            werkzeuge: ["Konvektomat R12", "Schneidebrett Gelb", "Global Messer-Set"]
        )
    }
    
    /// Wechselt den Status einer Basis-Aufgabe
    func toggleTask(_ task: MissionTask) {
        if let index = currentMission?.aufgaben.firstIndex(where: { $0.id == task.id }) {
            currentMission?.aufgaben[index].istErledigt.toggle()
        }
    }
}
