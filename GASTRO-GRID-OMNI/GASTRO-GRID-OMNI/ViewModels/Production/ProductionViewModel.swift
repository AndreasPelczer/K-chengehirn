//
//  ProductionViewModel.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//


import Foundation
import SwiftUI

/// Das Gehirn der Zentralküche. Bündelt Bedarfe von Outlets & Events.
class ProductionViewModel: ObservableObject {
    
    // Aktive Produktionsaufträge (Was muss heute gebaut werden?)
    @Published var produktionsListe: [ProductionOrder] = []
    
    // Status der Standbelieferung (MiniPick)
    @Published var miniPickStatus: String = "Bereit"
    
    init() {
        berechneTagesBedarf()
    }
    
    /// Simuliert die Aggregation: Sammelt Bedarfe aus allen 30 Outlets
    func berechneTagesBedarf() {
        self.produktionsListe = [
            ProductionOrder(titelKey: "SALAT_BOWL_VEGGIE", menge: 150, einheit: "Stk", abteilung: .kalteKueche),
            ProductionOrder(titelKey: "DESSERT_MOUSSE", menge: 80, einheit: "Glas", abteilung: .patisserie),
            ProductionOrder(titelKey: "BREZELN_FRISCH", menge: 300, einheit: "Stk", abteilung: .miniPick)
        ]
    }
    
    /// Markiert eine Charge als "Fertig für MiniPick" (Logistik-Umschlag)
    func schliesseProduktionAb(order: ProductionOrder) {
        if let index = produktionsListe.firstIndex(where: { $0.id == order.id }) {
            produktionsListe[index].istFertig = true
            // Hier würde die Push an den MiniPick-Fahrer erfolgen
            print("Logistik-Info: \(order.titelKey) ist abholbereit am MiniPick.")
        }
    }
}

/// Datenstruktur für einen Produktionsauftrag
struct ProductionOrder: Identifiable {
    var id = UUID()
    var titelKey: String
    var menge: Int
    var einheit: String
    var abteilung: VenueType
    var istFertig: Bool = false
}