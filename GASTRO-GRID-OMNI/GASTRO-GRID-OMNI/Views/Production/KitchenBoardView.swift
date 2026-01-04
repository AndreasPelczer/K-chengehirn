//
//  KitchenBoardView.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//


import SwiftUI

/// Die digitale Posten-Übersicht für die Produktionseinheiten.
struct KitchenBoardView: View {
    @StateObject private var viewModel = ProductionViewModel()
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // --- HEADER ---
                    HStack {
                        VStack(alignment: .leading) {
                            Text("PRODUCTION CONTROL")
                                .font(.caption).bold().foregroundColor(env.neonGreen)
                            Text("KÜCHEN-BOARD")
                                .font(.title.bold()).foregroundColor(.white)
                        }
                        Spacer()
                        // Abteilungswähler (Filter)
                        Image(systemName: "燒肉") // Platzhalter für Gastro-Icon
                            .font(.largeTitle).foregroundColor(env.neonGreen)
                    }
                    .padding(.horizontal)
                    
                    // --- PRODUKTIONS-SLOTS ---
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(viewModel.produktionsListe) { order in
                                orderCard(for: order)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .environment(\.locale, env.selectedLocale)
        }
    }
    
    // Karte für ein einzelnes Produkt (z.B. 150x Salatbowl)
    private func orderCard(for order: ProductionOrder) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(LocalizedStringKey(order.titelKey))
                    .font(.headline).foregroundColor(.white)
                Text("Abteilung: \(order.abteilung.rawValue)")
                    .font(.caption2).foregroundColor(.gray)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(order.menge) \(order.einheit)")
                    .font(.title2.bold()).foregroundColor(env.neonGreen)
                
                Button(action: { viewModel.schliesseProduktionAb(order: order) }) {
                    Text(order.istFertig ? "COMPLETED" : "READY TO SHIP")
                        .font(.system(size: 10, weight: .black))
                        .padding(8)
                        .background(order.istFertig ? Color.gray : env.neonGreen)
                        .foregroundColor(.black)
                        .cornerRadius(5)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(order.istFertig ? Color.clear : env.neonGreen.opacity(0.3), lineWidth: 1)
        )
    }
}