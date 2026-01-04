//
//  LogisticsOrder.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//


import Foundation

/// Ein Logistik-Auftrag für den MiniPick-Fahrer.
struct LogisticsOrder: Identifiable, Codable {
    var id = UUID()
    var produktNameKey: String  // z.B. "SALAT_BOWL_VEGGIE"
    var menge: Int
    var einheit: String
    
    var vonOrt: String          // z.B. "Zentralküche"
    var nachOrt: String         // z.B. "Halle 9 - Outlet B"
    
    var prioritaet: Priority
    var status: DeliveryStatus
    
    enum Priority: String, Codable {
        case normal = "Normal"
        case urgent = "EILT SEHR"
    }
    
    enum DeliveryStatus: String, Codable {
        case bereit = "Abholbereit"
        case unterwegs = "Auf dem Weg"
        case geliefert = "Geliefert"
    }
}