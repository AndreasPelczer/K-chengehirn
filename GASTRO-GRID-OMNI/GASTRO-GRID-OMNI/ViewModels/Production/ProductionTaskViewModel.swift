//
//  ProductionTaskViewModel.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//


import Foundation
import SwiftUI

/// Verwaltet die aktiven Produktionsaufträge am Posten.
class ProductionTaskViewModel: ObservableObject {
    @Published var aktiveAuftraege: [ProductionTask] = []
    
    init() {
        // Hier laden wir Testdaten für deine Präsentation
        self.aktiveAuftraege = [
            ProductionTask(
                titel: "Vorbereitung: Zwiebel-Hähnchen",
                komponenten: ["5kg Zwiebeln fein", "3 Kartons Huhn Seubert"],
                hardware: "Schwarze Bleche 1/1 GN",
                anweisung: "Zwiebeln als Bett, Huhn gefroren darauf (15 Stk/Blech).",
                zielOrt: "Hortenwagen 7 / Kühlhaus",
                geplanteDauerMinuten: 120
            )
        ]
    }
    
    func auftragAbschliessen(id: UUID, grund: String?) {
        if let index = aktiveAuftraege.firstIndex(where: { $0.id == id }) {
            aktiveAuftraege[index].istAbgeschlossen = true
            aktiveAuftraege[index].verzoegerungsGrund = grund
            aktiveAuftraege[index].endZeit = Date()
        }
    }
}