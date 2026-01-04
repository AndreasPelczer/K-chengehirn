//
//  DetailedTask.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//

import Foundation

/// Detaillierter Produktionsauftrag für die Küche.
/// Diese Struktur ist das Herzstück der operativen Zuweisung (Teilaufträge).
struct DetailedTask: Identifiable, Codable {
    var id = UUID()
    
    // --- ZUWEISUNG (Großprojekt-Update: Mehrfachauswahl möglich) ---
    /// Speichert alle IDs der zugewiesenen Köche (Set verhindert Dubletten).
    var zugewieseneMitarbeiterIDs: Set<UUID> = []
    
    /// Optionaler Name für die Abwärtskompatibilität oder Einzelanzeige.
    var mitarbeiterName: String?
    
    /// Liste der Namen aller beteiligten Crew-Mitglieder.
    var mitarbeiterNamen: [String] = []
    
    // --- DIE INSTRUKTION ---
    var titel: String               // z.B. "Vorbereitung: Zwiebel-Hähnchen"
    var hardware: String            // z.B. "Schwarze Bleche 1/1 GN"
    var ware: [String]              // ["5kg Zwiebeln", "3 Kartons Huhn"]
    var anweisung: String           // "Zwiebeln schneiden, Huhn darauf setzen"
    
    // --- DIE LOGISTIK ---
    var zielOrt: String             // z.B. "Hortenwagen 7 / Tageskühlung"
    
    // --- DAS FEEDBACK ---
    var istAbgeschlossen: Bool = false
    var geplanteDauerMinuten: Int   // Zeitvorgabe vom Chef
    var tatsaechlicheDauerMinuten: Int?
    var verzoegerungsGrund: DelayReason?
    var kommentar: String?          // Feedback vom Posten
    
    /// Die vordefinierten Gründe für Verzögerungen (Frankfurt-Standard)
    enum DelayReason: String, Codable, CaseIterable {
        case wareFehlt = "Ware nicht am Platz"
        case zuWenigWare = "Zu wenig Ware"
        case pause = "Pause gemacht"
        case technikDefekt = "Technik/Geräte Problem"
        case unvorhergeseheneVerluste = "Unvorhergesehene verluste"
        case unvorhergeseheneFehler = "Unvorhergesehene Fehler"
        case unklarerAuftrag = "Unklarer Auftrag"
        case unvorhergeseheneTransportFehler = "Unvorhergesehene Transportfehler"
        case unvorhergeseheneSonstiges = "Unvorhergesehenes"
        case ungueltigerAuftrag = "Ungültiger Auftrag, da war einer der hat gesagt, hör auf"
    }
}
