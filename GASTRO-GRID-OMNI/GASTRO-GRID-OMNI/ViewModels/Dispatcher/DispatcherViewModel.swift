//
//  DispatcherViewModel.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//

import Foundation
import SwiftUI

/// Architektur: MVVM - ViewModel
/// Zentrale Logik für die Einsatzplanung und Crew-Zuweisung.
class DispatcherViewModel: ObservableObject {
    
    // --- PROPERTIES ---
    @Published var geplanteMissions: [Mission] = []
    @Published var verfuegbareVenues: [Venue] = []
    @Published var verfuegbareCrew: [UserProfile] = []
    
    // --- INITIALISIERUNG ---
    init() {
        demoDatenLaden()
    }
    
    // --- PRIVATE LOGIK ---
    private func demoDatenLaden() {
        self.verfuegbareVenues = [
            Venue(name: "Halle 9 - Stand A12", type: .outlet, halle: "9")
        ]
        
        self.verfuegbareCrew = [
            UserProfile(id: GlobalEnvironment.andreasID, name: "Andreas", rolle: .director),
            UserProfile(id: UUID(), name: "Stefan", rolle: .crew),
            UserProfile(id: UUID(), name: "Maria", rolle: .crew)
        ]
    }
    
    // --- PUBLIC FUNKTIONEN ---
    
    /// Erstellt ein Event mit einem Initial-Task.
    func erstelleEvent(titel: String, venue: Venue) {
        let initialerTask = DetailedTask(
            titel: "Vorbereitung: Petersilie für \(titel)",
            hardware: "Hortenwagen 7",
            ware: ["5 Bund"],
            anweisung: "Fein hacken.",
            zielOrt: "Kühlhaus 3",
            geplanteDauerMinuten: 20
        )
        
        let neueMission = Mission(
            id: UUID(),
            titel: titel,
            mitarbeiterName: "Nicht zugewiesen",
            venueID: venue.id,
            ort: venue,
            rolle: .leitung,
            aufgaben: [],
            produktionstasks: [initialerTask],
            werkzeuge: ["Kochmesser"]
        )
        
        withAnimation {
            geplanteMissions.append(neueMission)
        }
    }
    
    /// FIX: Nutzt jetzt 'zugewieseneMitarbeiterIDs.contains' für die Filterung (Plural-Logik).
    func filtereTasksFuerMitarbeiter(mitarbeiterID: UUID) -> [(missionTitel: String, task: DetailedTask)] {
        var ergebnis: [(missionTitel: String, task: DetailedTask)] = []
        
        for mission in geplanteMissions {
            // Wir schauen nach, ob die ID in der Menge der zugewiesenen IDs steckt
            let passende = mission.produktionstasks.filter { $0.zugewieseneMitarbeiterIDs.contains(mitarbeiterID) }
            for task in passende {
                ergebnis.append((missionTitel: mission.titel, task: task))
            }
        }
        return ergebnis
    }

    /// Weist einen Mitarbeiter einem Task zu oder entfernt ihn (Toggle für Großprojekte).
    func delegiereTeilauftrag(mitarbeiter: UserProfile, taskID: UUID, in missionID: UUID) {
        if let mIndex = geplanteMissions.firstIndex(where: { $0.id == missionID }),
           let tIndex = geplanteMissions[mIndex].produktionstasks.firstIndex(where: { $0.id == taskID }) {
            
            // Logik: Wenn ID vorhanden -> entfernen, sonst hinzufügen
            if geplanteMissions[mIndex].produktionstasks[tIndex].zugewieseneMitarbeiterIDs.contains(mitarbeiter.id) {
                geplanteMissions[mIndex].produktionstasks[tIndex].zugewieseneMitarbeiterIDs.remove(mitarbeiter.id)
                geplanteMissions[mIndex].produktionstasks[tIndex].mitarbeiterNamen.removeAll(where: { $0 == mitarbeiter.name })
            } else {
                geplanteMissions[mIndex].produktionstasks[tIndex].zugewieseneMitarbeiterIDs.insert(mitarbeiter.id)
                geplanteMissions[mIndex].produktionstasks[tIndex].mitarbeiterNamen.append(mitarbeiter.name)
            }
            
            // Abwärtskompatibilität: Ersten Namen für alte Anzeigen setzen
            geplanteMissions[mIndex].produktionstasks[tIndex].mitarbeiterName = geplanteMissions[mIndex].produktionstasks[tIndex].mitarbeiterNamen.first
            
            objectWillChange.send()
        }
    }
    
    /// Fügt einer Mission einen neuen Task hinzu.
    func neuenTaskHinzufuegen(zu missionIndex: Int) {
        let neuerTask = DetailedTask(
            titel: "Neuer Auftrag",
            hardware: "Standard",
            ware: [],
            anweisung: "",
            zielOrt: "",
            geplanteDauerMinuten: 15
        )
        withAnimation {
            geplanteMissions[missionIndex].produktionstasks.append(neuerTask)
        }
        objectWillChange.send()
    }
}
