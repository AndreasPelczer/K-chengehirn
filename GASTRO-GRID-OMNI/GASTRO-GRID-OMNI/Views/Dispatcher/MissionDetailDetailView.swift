//
//  MissionDetailDetailView.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//  Optimiert von Senior Developer (Helpful Teacher Buddy)
//

import SwiftUI

/// **MissionDetailDetailView**
/// Architektur: MVVM (Model-View-ViewModel)
/// Diese View dient als Editor für eine spezifische Mission. Hier können Aufgaben (Tasks)
/// erstellt, bearbeitet und mehreren Crew-Mitgliedern (Multi-Crew) zugewiesen werden.
struct MissionDetailDetailView: View {
    
    // MARK: - Properties
    
    /// Die aktuelle Mission, die im Detail betrachtet wird.
    var mission: Mission
    
    /// Globaler Style-Guide für Farben (z.B. NeonGreen) und konsistentes Design.
    @EnvironmentObject var env: GlobalEnvironment
    
    /// Das zentrale ViewModel, das die Datenhoheit besitzt.
    /// @ObservedObject sorgt dafür, dass die View bei Änderungen im ViewModel aktualisiert wird.
    @ObservedObject var viewModel: DispatcherViewModel
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Hintergrund-Design: Deep Black für den Cyber-Look
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                // Obere Sektion mit Titel und Ort
                headerSection
                
                // Schnell-Aktionen (z. B. Task hinzufügen)
                quickActionsBar
                
                // Liste der Aufgaben mit Editor-Funktionalität
                taskEditorList
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Sub-Views
    
    /// Header mit Missionsname und Standort.
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(mission.titel.uppercased())
                .font(.system(size: 24, weight: .black))
                .foregroundColor(.white)
            Text("Ort: \(mission.ort.name)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.05))
    }
    
    /// Aktionsleiste für schnelle Befehle wie "Neuer Task".
    private var quickActionsBar: some View {
        HStack {
            Spacer()
            Button(action: {
                // Sucht den Index der aktuellen Mission und fügt einen Task hinzu
                if let index = viewModel.geplanteMissions.firstIndex(where: { $0.id == mission.id }) {
                    viewModel.neuenTaskHinzufuegen(zu: index)
                }
            }) {
                Label("NEUER TASK", systemImage: "plus.circle.fill")
                    .font(.subheadline).bold()
                    .foregroundColor(.black)
                    .padding(10)
                    .background(env.neonGreen)
                    .cornerRadius(8)
            }
            .padding()
        }
    }
    
    /// Die Hauptliste, die alle Produktionstasks und deren Zuweisungen anzeigt.
    private var taskEditorList: some View {
        List {
            Section(header: Text("AUFTRAGS-EDITOR (MULTI-CREW)").foregroundColor(.gray)) {
                
                // Wir identifizieren die Mission im ViewModel, um direkt auf dem State zu arbeiten
                if let mIdx = viewModel.geplanteMissions.firstIndex(where: { $0.id == mission.id }) {
                    
                    ForEach(viewModel.geplanteMissions[mIdx].produktionstasks.indices, id: \.self) { tIdx in
                        taskRow(missionIndex: mIdx, taskIndex: tIdx)
                    }
                    .onDelete { indexSet in
                        // Ermöglicht das Löschen von Tasks per Swipe-Geste
                        viewModel.geplanteMissions[mIdx].produktionstasks.remove(atOffsets: indexSet)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    /// Erstellt eine einzelne Zeile für einen Task innerhalb der Liste.
    /// - Parameters:
    ///   - missionIndex: Index der Mission im ViewModel.
    ///   - taskIndex: Index des Tasks innerhalb der Mission.
    private func taskRow(missionIndex: Int, taskIndex: Int) -> some View {
        let currentTask = viewModel.geplanteMissions[missionIndex].produktionstasks[taskIndex]
        
        return HStack {
            VStack(alignment: .leading, spacing: 5) {
                // Editierbarer Titel: Bindet direkt an das ViewModel
                TextField("Auftragsname...", text: $viewModel.geplanteMissions[missionIndex].produktionstasks[taskIndex].titel)
                    .font(.headline)
                    .foregroundColor(env.neonGreen)
                    .textFieldStyle(PlainTextFieldStyle())
                
                // Anzeige der zugewiesenen Crew-Mitglieder
                if currentTask.mitarbeiterNamen.isEmpty {
                    Text("NIEMAND ZUGEWIESEN")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.orange)
                } else {
                    Text("CREW: " + currentTask.mitarbeiterNamen.joined(separator: ", "))
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            // Menü für die Multi-Crew Zuweisung
            menuPicker(missionIndex: missionIndex, taskIndex: taskIndex)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Helper Methods
    
    /// Der Multi-Picker: Erlaubt das An- und Abwählen mehrerer Mitarbeiter für einen Task.
    /// Realisiert über ein SwiftUI `Menu`.
    private func menuPicker(missionIndex: Int, taskIndex: Int) -> some View {
        let task = viewModel.geplanteMissions[missionIndex].produktionstasks[taskIndex]
        
        return Menu {
            Text("CREW AUSWÄHLEN (MEHRFACHWAHL)").font(.caption)
            Divider()
            
            // Iteriert über alle verfügbaren Mitarbeiter aus dem ViewModel
            ForEach(viewModel.verfuegbareCrew) { (koch: UserProfile) in
                Button(action: {
                    // Logik für Zuweisung/Entfernung im ViewModel
                    viewModel.delegiereTeilauftrag(mitarbeiter: koch, taskID: task.id, in: mission.id)
                }) {
                    HStack {
                        Text(koch.name)
                        // Visuelles Feedback: Haken zeigt an, ob der Koch zugewiesen ist
                        if task.zugewieseneMitarbeiterIDs.contains(koch.id) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            // Das Icon für den Zuweisungs-Button
            Image(systemName: "person.2.badge.gearshape.fill")
                .font(.title2)
                .foregroundColor(env.neonGreen)
                .padding(8)
                .background(env.neonGreen.opacity(0.1))
                .clipShape(Circle())
        }
    }
}
