//
//  BriefingBoardView.swift
//  GASTRO-GRID-OMNI
//

import SwiftUI

/// "Mein Tag" Ansicht für den Mitarbeiter.
struct BriefingBoardView: View {
    @EnvironmentObject var env: GlobalEnvironment
    @ObservedObject var dispatcherVM: DispatcherViewModel
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        headerSection
                        
                        Text("MEINE AUFTRÄGE").font(.headline).foregroundColor(env.neonGreen).padding(.horizontal)
                        
                        // FIX: Eindeutiger Aufruf
                        let currentID = env.currentUser?.id ?? UUID()
                        let meineJobs = dispatcherVM.filtereTasksFuerMitarbeiter(mitarbeiterID: currentID)
                        
                        if meineJobs.isEmpty {
                            Text("Keine Aufträge zugewiesen.").foregroundColor(.gray).padding()
                        } else {
                            ForEach(meineJobs, id: \.task.id) { job in
                                VStack(alignment: .leading) {
                                    Text(job.missionTitel.uppercased()).font(.caption2).foregroundColor(.gray)
                                    ProductionTaskRow(task: job.task, env: env)
                                }.padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading) {
            Text("LOGGED IN: \(env.currentUser?.name ?? "Gast")").font(.caption).foregroundColor(env.neonGreen)
            Text("Briefing Board").font(.largeTitle).bold().foregroundColor(.white)
        }.padding()
    }
}

struct ProductionTaskRow: View {
    let task: DetailedTask
    let env: GlobalEnvironment
    var body: some View {
        VStack(alignment: .leading) {
            Text(task.titel).font(.headline).foregroundColor(.white)
            HStack {
                Label(task.hardware, systemImage: "case.fill")
                Spacer()
                Label(task.zielOrt, systemImage: "location.fill")
            }.font(.caption).foregroundColor(env.neonGreen)
        }
        .padding().background(Color.white.opacity(0.1)).cornerRadius(10)
    }
}
