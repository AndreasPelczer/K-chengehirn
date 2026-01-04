//
//  StaffDashboardView.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//


import SwiftUI

/// Die Ansicht für die Mitarbeiter-Kantine (Staff-Grid).
struct StaffDashboardView: View {
    @StateObject private var viewModel = StaffViewModel()
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // --- ÜBERSCHRIFT ---
                    HStack {
                        VStack(alignment: .leading) {
                            Text("STAFF-GRID")
                                .font(.caption).bold().foregroundColor(env.neonGreen)
                            Text("SPEISEPLAN HEUTE")
                                .font(.title.bold()).foregroundColor(.white)
                        }
                        Spacer()
                        // Anzeige der CO2/Geld-Ersparnis für das gute Gewissen
                        VStack(alignment: .trailing) {
                            Text("SAVED TODAY")
                                .font(.system(size: 10)).foregroundColor(.orange)
                            Text("\(Int(viewModel.berechneErsparnis()))€")
                                .font(.headline).foregroundColor(.orange)
                        }
                    }
                    .padding(.horizontal)
                    
                    // --- SPEISEKARTE ---
                    List {
                        ForEach(viewModel.heutigerSpeiseplan) { dish in
                            dishRow(for: dish)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarHidden(true)
            .environment(\.locale, env.selectedLocale)
        }
    }
    
    // Eine Zeile in der Speisekarte
    private func dishRow(for dish: StaffDish) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(LocalizedStringKey(dish.nameKey))
                        .font(.headline).foregroundColor(.white)
                    
                    if dish.istResteRettung {
                        Text("EVENT SPECIAL")
                            .font(.system(size: 8, weight: .black))
                            .padding(4)
                            .background(Color.orange)
                            .cornerRadius(4)
                    }
                }
                
                Text("Verfügbar: \(dish.verfuegbarePortionen) Portionen")
                    .font(.caption2).foregroundColor(.gray)
            }
            Spacer()
            
            // Icon für Kategorie
            Image(systemName: dish.kategorie == .veggie ? "leaf.fill" : "flame.fill")
                .foregroundColor(dish.kategorie == .veggie ? .green : .red)
        }
        .padding(.vertical, 8)
        .listRowBackground(Color.white.opacity(0.05))
    }
}
