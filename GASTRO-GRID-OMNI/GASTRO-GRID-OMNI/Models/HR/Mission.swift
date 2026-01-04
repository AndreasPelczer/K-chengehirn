//
//  Mission.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//

import Foundation

// MARK: - Unterstützende Typen

/// Die Posten-Rolle (wichtig für den Dispatcher)
enum PostenRolle: String, Codable, CaseIterable {
    case leitung = "Verantwortung (Lead)"
    case buffet = "Buffetbetreuung"
    case station = "Schneidestation"
    case laeufer = "Läufer / Refill"
}

/// Basis-Checkliste für den Check-In
struct MissionTask: Identifiable, Codable {
    var id = UUID()
    var titelKey: String
    var beschreibungKey: String
    var istErledigt: Bool = false
}

// MARK: - Hauptmodell

/// Repräsentiert einen Einsatzort oder einen Messestand.
struct Mission: Identifiable, Codable {
    var id = UUID()
    var titel: String
    var mitarbeiterName: String
    var venueID: UUID
    var ort: Venue
    var rolle: PostenRolle
    var aufgaben: [MissionTask] = []
    
    // UMGESCHRIEBEN: Nutzt jetzt den Gold-Standard DetailedTask für Zuweisungen
    var produktionstasks: [DetailedTask] = []
    
    var werkzeuge: [String] = []
    
    var istZugewiesen: Bool {
        mitarbeiterName != "Nicht zugewiesen" && !mitarbeiterName.isEmpty
    }
}
