//
//  DispatcherView.swift
//  GASTRO-GRID-OMNI
//
//  Created by Senior Developer (Helpful Teacher Buddy) on 2026-01-05.
//

import SwiftUI

/// **DispatcherView**
/// Die Hauptzentrale für den Dispatcher (Chef/Planer).
/// Hier werden Einsätze (Missions) verwaltet, die Crew überwacht und neue Events erstellt.
/// Architektur: MVVM - Diese View beobachtet das `DispatcherViewModel`.
struct DispatcherView: View {
    
    // MARK: - Properties
    
    /// Das ViewModel, das die Business-Logik steuert.
    /// @ObservedObject: Reagiert auf Änderungen in den Daten des ViewModels.
    @ObservedObject var viewModel: DispatcherViewModel
    
    /// Globaler Style-Guide und Umgebungsvariablen (z.B. Neon-Farben).
    @EnvironmentObject var env: GlobalEnvironment
    
    /// State-Variable zur Steuerung des "Neuer Einsatz" Modals (Sheet).
    @State private var showingAddEvent = false
    
    /// Temporärer Speicher für den Titel einer neuen Mission während der Eingabe.
    @State private var neueMissionTitel = ""
    
    /// Die ID des ausgewählten Einsatzortes für eine neue Mission.
    @State private var ausgewaehlteVenueID: UUID?
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            ZStack {
                // Hintergrund: Klassisches Schwarz für den Dark-Mode-Cyber-Look
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    // Header-Titel
                    Text("COMMAND CENTER")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.white)
                        .padding([.horizontal, .top])
                    
                    // Horizontale Crew-Status-Anzeige
                    crewStatusLeiste
                        .padding(.vertical, 15)
                    
                    // Hauptliste der Einsätze
                    List {
                        Section(header: Text("AKTIVE EINSATZORTE").foregroundColor(.gray)) {
                            if viewModel.geplanteMissions.isEmpty {
                                emptyStateView
                            } else {
                                missionListContent
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                    // Aktions-Button für neue Einsätze
                    addMissionButton
                }
            }
            .navigationBarHidden(true)
            // Modal-Dialog für die Erstellung eines Events
            .sheet(isPresented: $showingAddEvent) {
                addEventSheet
            }
        }
    }
    
    // MARK: - Sub-Views
    
    /// Zeigt eine Meldung an, wenn keine Missionen vorhanden sind.
    private var emptyStateView: some View {
        Text("Keine Einsätze geplant.")
            .foregroundColor(.gray)
            .italic()
    }
    
    /// Iteriert durch die geplanten Missionen und erstellt die Navigations-Links.
    private var missionListContent: some View {
        ForEach(viewModel.geplanteMissions) { mission in
            NavigationLink(destination: MissionDetailDetailView(mission: mission, viewModel: viewModel)) {
                missionRow(for: mission)
            }
        }
    }
    
    /// Der "NEUER EINSATZ" Button am unteren Bildschirmrand.
    private var addMissionButton: some View {
        Button(action: { showingAddEvent = true }) {
            Label("NEUER EINSATZ", systemImage: "plus.app.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(env.neonGreen)
                .foregroundColor(.black)
                .cornerRadius(12)
                .padding()
        }
    }
    
    /// Eine einzelne Zeile innerhalb der Liste, die Details zur Mission darstellt.
    /// - Parameter mission: Das darzustellende Mission-Objekt.
    private func missionRow(for mission: Mission) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(mission.titel)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                // Badge für die Anzahl der Aufgaben
                Text("\(mission.produktionstasks.count) Tasks")
                    .font(.caption2)
                    .bold()
                    .padding(4)
                    .background(env.neonGreen.opacity(0.2))
                    .foregroundColor(env.neonGreen)
                    .cornerRadius(4)
            }
            
            HStack {
                // Standort-Information
                Label(mission.ort.name, systemImage: "mappin.and.ellipse")
                
                Spacer()
                
                // Zuweisungs-Status Logik:
                // Prüft, wie viele Tasks bereits mindestens einen Mitarbeiter zugewiesen haben.
                let zugewieseneCount = mission.produktionstasks.filter { !$0.zugewieseneMitarbeiterIDs.isEmpty }.count
                
                if zugewieseneCount == 0 {
                    Label("OFFEN", systemImage: "person.fill.questionmark")
                        .foregroundColor(.orange)
                } else {
                    Label("\(zugewieseneCount) ZUGEWIESEN", systemImage: "person.fill.checkmark")
                        .foregroundColor(env.neonGreen)
                }
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
    
    /// Eine horizontale ScrollView, die die verfügbare Crew (Mitarbeiter) anzeigt.
    private var crewStatusLeiste: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(viewModel.verfuegbareCrew) { mitarbeiter in
                    VStack {
                        // Avatar-Ersatz: Erster Buchstabe des Namens im Kreis
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Text(String(mitarbeiter.name.prefix(1)))
                                    .foregroundColor(.white)
                                    .bold()
                            )
                        
                        Text(mitarbeiter.name)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    /// Das Sheet (Eingabemaske) zur Erstellung eines neuen Events.
    private var addEventSheet: some View {
        NavigationView {
            Form {
                Section(header: Text("Basis-Informationen")) {
                    TextField("Event Name", text: $neueMissionTitel)
                    
                    Picker("Ort", selection: $ausgewaehlteVenueID) {
                        Text("Wählen...").tag(nil as UUID?)
                        ForEach(viewModel.verfuegbareVenues) { v in
                            Text(v.name).tag(v.id as UUID?)
                        }
                    }
                }
                
                Button(action: {
                    speichereNeuesEvent()
                }) {
                    Text("EVENT SPEICHERN")
                        .frame(maxWidth: .infinity)
                        .bold()
                }
                .disabled(neueMissionTitel.isEmpty || ausgewaehlteVenueID == nil)
            }
            .navigationTitle("Neuer Einsatz")
            .preferredColorScheme(.dark)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { showingAddEvent = false }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    /// Validiert die Eingabe und delegiert die Erstellung des Events an das ViewModel.
    private func speichereNeuesEvent() {
        if let vID = ausgewaehlteVenueID,
           let v = viewModel.verfuegbareVenues.first(where: { $0.id == vID }) {
            // Business Logik findet im ViewModel statt (MVVM)
            viewModel.erstelleEvent(titel: neueMissionTitel, venue: v)
            
            // Felder zurücksetzen und Sheet schließen
            neueMissionTitel = ""
            ausgewaehlteVenueID = nil
            showingAddEvent = false
        }
    }
}
