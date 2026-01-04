//
//  PersistenceController.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//


import CoreData

/// Der Controller für die Datenbank-Anbindung (CoreData).
/// Er verwaltet den Lebenszyklus der gespeicherten Daten.
struct PersistenceController {
    static let shared = PersistenceController()

    // Ein Vorschau-Controller für den Xcode-Canvas (Preview)
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // Hier könnten wir Testdaten für die Preview vorgießen
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        // Der Name muss exakt mit deiner .xcdatamodeld Datei übereinstimmen!
        container = NSPersistentContainer(name: "GastroGridDataModel")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // In einer echten App: Sauberes Fehler-Handling
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        // Sorgt dafür, dass Änderungen in Echtzeit zusammengeführt werden
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}