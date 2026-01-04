//
//  DirectorViewModel.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//


import Foundation
import SwiftUI

/// Das ViewModel für den Direktor. 
/// Es steuert die globale Übersicht über alle Venues (Outlets, Produktion, Events).
class DirectorViewModel: ObservableObject {
    
    // Eine Liste aller Standorte im System
    @Published var allVenues: [Venue] = []
    
    // Die aktuelle Gästeanzahl (wird für die globale Kalkulation genutzt)
    @Published var gesamtGaeste: Int = 0
    
    // Frankfurt Neon Farbe zur Verwendung in der View
    let neonGreen = Color(red: 0.22, green: 1.0, blue: 0.08)
    
    init() {
        // Initiales Laden der Stammdaten (Beispielhaft)
        setupInitialData()
    }
    
    /// Befüllt das System mit den 30 Outlets und Produktionsstätten
    private func setupInitialData() {
        allVenues = [
            Venue(name: "Zentralküche Warm", type: .produktionsKueche, halle: "Zentrale"),
            Venue(name: "Patisserie", type: .patisserie, halle: "Zentrale"),
            Venue(name: "Foodtruck 1", type: .foodTruck, halle: "Halle 3"),
            Venue(name: "Messe-Restaurant A", type: .restaurant, halle: "Halle 9"),
            Venue(name: "MiniPick Logistics", type: .miniPick, halle: "Zentrallager")
        ]
    }
    
    /// Berechnet die Performance eines Outlets (Platzhalter für reale Daten)
    func getStatusColor(for venue: Venue) -> Color {
        // Logik: Wenn Personal fehlt oder Ware knapp ist -> Rot, sonst NeonGrün
        return neonGreen
    }
}