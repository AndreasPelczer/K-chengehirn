//
//  MissionDetailDetailView.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//

import SwiftUI

/// Architektur: MVVM
/// Detailansicht mit Editor-Funktion und Multi-Crew Zuweisung für Großprojekte.
struct MissionDetailDetailView: View {
    
    // --- PROPERTIES ---
    
    var mission: Mission
    @EnvironmentObject var env: GlobalEnvironment
    
    /// Das zentrale ViewModel für die Logik.
    @ObservedObject var viewModel: DispatcherViewModel
    
    // --- BODY ---
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                
                // --- QUICK ACTIONS ---
                HStack {
                    Spacer()
                    Button(action: {
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
                
                List {
                    Section(header: Text("AUFTRAGS-EDITOR (MULTI-CREW)").foregroundColor(.gray)) {
                        
                        if let mIdx = viewModel.geplanteMissions.firstIndex(where: { $0.id == mission.id }) {
                            
                            ForEach(viewModel.geplanteMissions[mIdx].produktionstasks.indices, id: \.self) { tIdx in
                                let currentTask = viewModel.geplanteMissions[mIdx].produktionstasks[tIdx]
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        // Editierbarer Titel
                                        TextField("Auftragsname...", text: $viewModel.geplanteMissions[mIdx].produktionstasks[tIdx].titel)
                                            .font(.headline)
                                            .foregroundColor(env.neonGreen)
                                            .textFieldStyle(PlainTextFieldStyle())
                                        
                                        // Anzeige der zugewiesenen Crew
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
                                    
                                    // Menü für die Zuweisung
                                    menuPicker(missionIndex: mIdx, taskIndex: tIdx)
                                }
                                .padding(.vertical, 8)
                            }
                            .onDelete { indexSet in
                                viewModel.geplanteMissions[mIdx].produktionstasks.remove(atOffsets: indexSet)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Helper
    
    /// Der Multi-Picker: Erlaubt das An- und Abwählen mehrerer Köche.
    private func menuPicker(missionIndex: Int, taskIndex: Int) -> some View {
        let task = viewModel.geplanteMissions[missionIndex].produktionstasks[taskIndex]
        
        return Menu {
            Text("CREW AUSWÄHLEN (MEHRFACHWAHL)").font(.caption)
            Divider()
            // FIX: Explizite Typ-Angabe für 'koch', um dem Compiler zu helfen
            ForEach(viewModel.verfuegbareCrew) { (koch: UserProfile) in
                Button(action: {
                    viewModel.delegiereTeilauftrag(mitarbeiter: koch, taskID: task.id, in: mission.id)
                }) {
                    HStack {
                        Text(koch.name)
                        if task.zugewieseneMitarbeiterIDs.contains(koch.id) {
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            Image(systemName: "person.2.badge.gearshape.fill")
                .font(.title2)
                .foregroundColor(env.neonGreen)
                .padding(8)
                .background(env.neonGreen.opacity(0.1))
                .clipShape(Circle())
        }
    }
    
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
}
