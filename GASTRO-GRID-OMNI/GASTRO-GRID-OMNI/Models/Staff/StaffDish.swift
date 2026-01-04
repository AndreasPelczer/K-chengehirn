//
//  StaffDish.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//


import Foundation

/// Repräsentiert ein Gericht im Staff-Grid (Kantinen-Speiseplan)
struct StaffDish: Identifiable, Codable {
    var id = UUID()
    var nameKey: String          // Lokalisiert (z.B. "BOEUF_BOURGIGNON")
    var kategorie: DishCategory
    var istResteRettung: Bool    // Flag: Kommt dieses Essen von einer VA?
    var verfuegbarePortionen: Int
    var allergene: [String]
    
    enum DishCategory: String, Codable {
        case meat = "Fleisch"
        case veggie = "Vegetarisch"
        case vegan = "Vegan"
        case special = "Chef's Special"
    }
}