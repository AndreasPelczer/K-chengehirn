//
//  ProductionManager.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//


import Foundation

/// Verwaltet die Vorlagen (Templates) für Produktionsaufträge.
/// So muss der Chef nicht jedes Mal alles neu tippen.
class ProductionManager {
    static let shared = ProductionManager()
    
    // Unsere Standard-Aufträge (Templates)
    let vorlagen: [ProductionTask] = [
        ProductionTask(
            titel: "Vorbereitung: Zwiebel-Hähnchen",
            komponenten: ["5kg Zwiebeln", "3 Kartons Huhn (Seubert 170g)"],
            hardware: "Schwarze Bleche 1/1 GN",
            anweisung: "Zwiebeln fein schneiden, Huhn 15 Stk/Blech darauf setzen.",
            zielOrt: "Hortenwagen 7 / Kühlhaus",
            geplanteDauerMinuten: 120
        ),
        ProductionTask(
            titel: "Patisserie: Schoko-Mousse Messe",
            komponenten: ["10kg Callebaut", "20L Sahne"],
            hardware: "Edelstahlschüsseln / Spritzbeutel",
            anweisung: "Aufschlagen, portionieren in Gläser.",
            zielOrt: "Kühlung Halle 9",
            geplanteDauerMinuten: 180
        )
    ]
}