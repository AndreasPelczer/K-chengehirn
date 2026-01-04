//
//  ProductionTask.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//


import Foundation

/// Ein präziser Produktionsauftrag (z.B. für Kalte Küche oder Patisserie).
struct ProductionTask: Identifiable, Codable {
    var id = UUID()
    
    // --- WAS & WIE ---
    var titel: String               // z.B. "Vorbereitung: Hähnchen auf Zwiebelbett"
    var komponenten: [String]       // ["5kg Zwiebeln", "3 Kartons Huhn (Seubert 170g)"]
    var hardware: String            // "Schwarze Bleche 1/1 GN"
    var anweisung: String           // "Zwiebeln fein schneiden, Huhn 15 Stk/Blech darauf setzen."
    
    // --- LOGISTIK ---
    var zielOrt: String             // "Hortenwagen 7 / Tageskühlung"
    
    // --- ZEITMANAGEMENT (Chef-Analyse) ---
    var geplanteDauerMinuten: Int   // z.B. 120
    var startZeit: Date?
    var endZeit: Date?
    var verzoegerungsGrund: String? // "Ware nicht am Platz", etc.
    
    var istAbgeschlossen: Bool = false
}