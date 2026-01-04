//
//  MiniPickViewModel.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//


import Foundation
import SwiftUI

/// Verwaltet die Lieferrouten und den Status der MiniPick-Fahrzeuge.
class MiniPickViewModel: ObservableObject {
    
    // Aktive Lieferaufträge im System
    @Published var tourenPlan: [LogisticsOrder] = []
    
    let neonGreen = Color(red: 0.22, green: 1.0, blue: 0.08)
    
    init() {
        ladeAktuelleTouren()
    }
    
    /// Holt die fertigen Aufträge aus der Produktion (Simulation)
    func ladeAktuelleTouren() {
        self.tourenPlan = [
            LogisticsOrder(produktNameKey: "SALAT_BOWL_VEGGIE", menge: 150, einheit: "Stk", vonOrt: "Zentralküche", nachOrt: "Halle 3 - Foodtruck", prioritaet: .urgent, status: .bereit),
            LogisticsOrder(produktNameKey: "DESSERT_MOUSSE", menge: 80, einheit: "Glas", vonOrt: "Patisserie", nachOrt: "Halle 9 - Restaurant A", prioritaet: .normal, status: .unterwegs)
        ]
    }
    
    /// Ändert den Status einer Lieferung (z.B. von Abholbereit auf Unterwegs)
    func updateStatus(for order: LogisticsOrder) {
        if let index = tourenPlan.firstIndex(where: { $0.id == order.id }) {
            switch tourenPlan[index].status {
            case .bereit: tourenPlan[index].status = .unterwegs
            case .unterwegs: tourenPlan[index].status = .geliefert
            case .geliefert: break
            }
        }
    }
}