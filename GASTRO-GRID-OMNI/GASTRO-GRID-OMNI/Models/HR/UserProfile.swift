//
//  UserProfile.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//

import Foundation

/// Das Profil eines Mitarbeiters im GASTRO-GRID System.
struct UserProfile: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var personalNummer: String
    var sprache: String // z.B. "de", "en", "es", "hi"
    var rolle: GlobalEnvironment.UserRole
    var istMietkoch: Bool
    
    // Frankfurt-Special: Zuweisung zu einer Stamm-Abteilung
    var stammAbteilung: VenueType?
    
    // EINDEUTIGER INITIALIZER: Verhindert "Missing argument for parameter 'from'"
    init(id: UUID = UUID(),
         name: String,
         personalNummer: String = "0000",
         sprache: String = "de",
         rolle: GlobalEnvironment.UserRole = .crew,
         istMietkoch: Bool = false,
         stammAbteilung: VenueType? = nil) {
        self.id = id
        self.name = name
        self.personalNummer = personalNummer
        self.sprache = sprache
        self.rolle = rolle
        self.istMietkoch = istMietkoch
        self.stammAbteilung = stammAbteilung
    }
}
