//
//  GlobalEnvironment.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//

import Foundation
import SwiftUI

/// Architektur: Single Source of Truth
/// Die globale Schaltzentrale für Sprache, Rolle und Design-Konstanten.
class GlobalEnvironment: ObservableObject {
    
    // --- STATISCHE KONSTANTEN (Globaler Anker) ---
    
    /// Diese feste ID nutzen wir, um "Andreas" systemweit eindeutig zu identifizieren.
    /// Senior-Tipp: Durch eine statische ID verhindern wir 'Mismatch'-Fehler bei der Filterung.
    static let andreasID = UUID(uuidString: "12345678-1234-1234-1234-1234567890ab")!
    
    // --- DATENTYPEN ---
    
    /// Die Rollen für das System (Director = Chef, Dispatcher = Planer, Crew = Koch)
    enum UserRole: String, Codable {
        case director, dispatcher, crew
    }
    
    // --- PUBLISHED PROPERTIES ---
    
    /// Aktive Sprache als String (für den Picker).
    /// Der didSet-Observer sorgt für die automatische Synchronisation mit dem Locale.
    @Published var userLanguage: String = "de" {
        didSet {
            selectedLocale = Locale(identifier: userLanguage)
        }
    }
    
    /// Das Locale-Objekt, das SwiftUI für die Lokalisierung (Übersetzung) nutzt.
    @Published var selectedLocale: Locale = Locale(identifier: "de")
    
    /// Die aktuelle Rolle des angemeldeten Benutzers (steuert den Zugriff auf Tabs).
    @Published var currentUserRole: UserRole = .crew
    
    // --- DER AKTUELL ANGEMELDETE USER ---
    /// Enthält das Profil des Nutzers, der das iPhone gerade in der Hand hält.
    /// Wichtig für die Filterung der Aufgaben im Briefing Board.
    @Published var currentUser: UserProfile?
    
    // --- INITIALISIERUNG ---
    
    init() {
        // --- FIX: IDENTITÄT VERANKERN ---
        // Wir nutzen hier die oben definierte statische andreasID.
        // Das stellt sicher, dass der 'Login-Andreas' dieselbe ID hat wie der 'Crew-Andreas'.
        self.currentUser = UserProfile(
            id: Self.andreasID,
            name: "Andreas",
            rolle: .director
        )
        self.currentUserRole = .director
    }
    
    // --- FUNKTIONEN ---
    
    /// Wechselt die App-Sprache zentral und löst ein UI-Update aus.
    /// - Parameter langCode: Der ISO-Code der Sprache (z.B. "de", "en").
    func changeLanguage(to langCode: String) {
        self.userLanguage = langCode
        print("Senior-Log: Sprache gewechselt auf \(langCode)")
    }
    
    // --- DESIGN KONSTANTEN ---
    
    /// Corporate Design: Das markante GASTRO-GRID Neon-Green.
    let neonGreen = Color(red: 0.22, green: 1.0, blue: 0.08)
}
