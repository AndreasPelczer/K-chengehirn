//
//  DispatcherView.swift
//  GASTRO-GRID-OMNI
//

import SwiftUI

/// Die Hauptzentrale für den Dispatcher (Chef).
struct DispatcherView: View {
    @ObservedObject var viewModel: DispatcherViewModel
    @EnvironmentObject var env: GlobalEnvironment
    
    @State private var showingAddEvent = false
    @State private var neueMissionTitel = ""
    @State private var ausgewaehlteVenueID: UUID?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("COMMAND CENTER")
                        .font(.system(size: 28, weight: .black))
                        .foregroundColor(.white)
                        .padding([.horizontal, .top])
                    
                    crewStatusLeiste
                        .padding(.vertical, 15)
                    
                    List {
                        Section(header: Text("AKTIVE EINSATZORTE").foregroundColor(.gray)) {
                            if viewModel.geplanteMissions.isEmpty {
                                Text("Keine Einsätze geplant.").foregroundColor(.gray)
                            } else {
                                ForEach(viewModel.geplanteMissions) { mission in
                                    NavigationLink(destination: MissionDetailDetailView(mission: mission, viewModel: viewModel)) {
                                        missionRow(for: mission)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    
                    Button(action: { showingAddEvent = true }) {
                        Label("NEUER EINSATZ", systemImage: "plus.app.fill")
                            .font(.headline).frame(maxWidth: .infinity).padding()
                            .background(env.neonGreen).foregroundColor(.black).cornerRadius(12).padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddEvent) { addEventSheet }
        }
    }
    
    private func missionRow(for mission: Mission) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(mission.titel).font(.headline).foregroundColor(.white)
                Spacer()
                Text("\(mission.produktionstasks.count) Tasks").font(.caption2).bold()
                    .padding(4).background(env.neonGreen.opacity(0.2)).foregroundColor(env.neonGreen).cornerRadius(4)
            }
            
            HStack {
                Label(mission.ort.name, systemImage: "mappin.and.ellipse")
                Spacer()
                
                // --- FIX: Wir prüfen, ob IRGENDJAND zugewiesen ist (Plural-Logik) ---
                let zugewieseneCount = mission.produktionstasks.filter { !$0.zugewieseneMitarbeiterIDs.isEmpty }.count
                
                if zugewieseneCount == 0 {
                    Label("OFFEN", systemImage: "person.fill.questionmark").foregroundColor(.orange)
                } else {
                    Label("\(zugewieseneCount) ZUGEWIESEN", systemImage: "person.fill.checkmark").foregroundColor(env.neonGreen)
                }
            }
            .font(.caption).foregroundColor(.gray)
        }
    }
    
    private var crewStatusLeiste: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(viewModel.verfuegbareCrew) { mitarbeiter in
                    VStack {
                        Circle().fill(Color.white.opacity(0.1)).frame(width: 50, height: 50)
                            .overlay(Text(String(mitarbeiter.name.prefix(1))).foregroundColor(.white).bold())
                        Text(mitarbeiter.name).font(.caption2).foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var addEventSheet: some View {
        NavigationView {
            Form {
                TextField("Event Name", text: $neueMissionTitel)
                Picker("Ort", selection: $ausgewaehlteVenueID) {
                    Text("Wählen...").tag(nil as UUID?)
                    ForEach(viewModel.verfuegbareVenues) { v in Text(v.name).tag(v.id as UUID?) }
                }
                Button("SPEICHERN") {
                    if let vID = ausgewaehlteVenueID, let v = viewModel.verfuegbareVenues.first(where: { $0.id == vID }) {
                        viewModel.erstelleEvent(titel: neueMissionTitel, venue: v)
                        showingAddEvent = false
                    }
                }
            }.navigationTitle("Neuer Einsatz").preferredColorScheme(.dark)
        }
    }
}
