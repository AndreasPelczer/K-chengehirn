//
//  StaffViewModel.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//


import Foundation
import SwiftUI

/// Verwaltet den Speiseplan für die 600 Mitarbeiter und die Reste-Integration.
class StaffViewModel: ObservableObject {
    
    @Published var heutigerSpeiseplan: [StaffDish] = []
    @Published var prognoseGaeste: Int = 600 // Basis-Zahl Mitarbeiter
    
    let neonGreen = Color(red: 0.22, green: 1.0, blue: 0.08)
    
    init() {
        ladenSpeiseplan()
    }
    
    /// Simuliert das Laden des Speiseplans inkl. der geretteten Portionen
    func ladenSpeiseplan() {
        self.heutigerSpeiseplan = [
            // Ein reguläres Gericht
            StaffDish(nameKey: "PASTA_PESTO", kategorie: .veggie, istResteRettung: false, verfuegbarePortionen: 400, allergene: ["A", "G"]),
            
            // DAS HIGHLIGHT: Die 200 Portionen vom Event gestern!
            StaffDish(nameKey: "BOEUF_BOURGIGNON", kategorie: .special, istResteRettung: true, verfuegbarePortionen: 200, allergene: ["G", "L"])
        ]
    }
    
    /// Berechnet, wie viel "echtes Geld" heute durch Reste-Rettung gespart wurde
    func berechneErsparnis() -> Double {
        let gerettetePortionen = heutigerSpeiseplan.filter { $0.istResteRettung }.reduce(0) { $0 + $1.verfuegbarePortionen }
        return Double(gerettetePortionen) * 4.50 // Annahme: 4,50€ Warenwert pro Portion
    }
}