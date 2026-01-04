import Foundation

/// Definiert die verschiedenen Arten von Standorten im GASTRO-GRID.
/// Durch 'CaseIterable' können wir alle Typen einfach in Pickern anzeigen.
enum VenueType: String, Codable, CaseIterable {
    case produktionsKueche = "Produktionsküche"
    case kalteKueche = "Kalte Küche"
    case patisserie = "Patisserie"
    case miniPick = "MiniPick (Logistik)"
    case foodTruck = "Foodtruck"
    case restaurant = "Messe-Restaurant"
    case outlet = "Verkaufsstation"
    case grossVA = "Großveranstaltung"
}

/// Das zentrale Datenmodell für einen Standort.
/// 'Hashable' ist zwingend erforderlich, damit der Picker im Dispatcher funktioniert.
struct Venue: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var type: VenueType
    var halle: String?
    var ebene: String?
    
    /// Hilfsfunktion zur schnellen Identifizierung von Produktionseinheiten
    var istProduktion: Bool {
        return [.produktionsKueche, .kalteKueche, .patisserie].contains(self.type)
    }
}
