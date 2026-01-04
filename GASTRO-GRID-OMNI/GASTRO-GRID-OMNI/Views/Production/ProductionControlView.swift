//
//  ProductionControlView.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//


import SwiftUI

struct ProductionControlView: View {
    @StateObject private var viewModel = ProductionTaskViewModel()
    @EnvironmentObject var env: GlobalEnvironment
    @State private var zeigeFeedbackModal = false
    @State private var ausgewaehlterAuftrag: ProductionTask?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("PRODUKTIONS-AUFTRÄGE")
                    .font(.title2.bold()).foregroundColor(.white)
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.aktiveAuftraege) { task in
                            ProductionTaskCard(task: task, env: env) {
                                self.ausgewaehlterAuftrag = task
                                self.zeigeFeedbackModal = true
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(item: $ausgewaehlterAuftrag) { task in
            FeedbackView(task: task, viewModel: viewModel)
        }
    }
}

/// Die Karte für einen einzelnen Auftrag (z.B. Zwiebeln schneiden)
struct ProductionTaskCard: View {
    let task: ProductionTask
    let env: GlobalEnvironment
    var onComplete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(task.titel).font(.headline).foregroundColor(env.neonGreen)
                Spacer()
                Text("\(task.geplanteDauerMinuten) Min").font(.caption).foregroundColor(.gray)
            }
            
            Divider().background(Color.gray)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("WARE: \(task.komponenten.joined(separator: ", "))").font(.footnote)
                Text("HARDWARE: \(task.hardware)").font(.footnote).foregroundColor(.orange)
                Text("ZIEL: \(task.zielOrt)").font(.footnote).bold()
            }
            .foregroundColor(.white)
            
            Button(action: onComplete) {
                Text(task.istAbgeschlossen ? "ERLEDIGT" : "ABSCHLIESSEN / FEEDBACK")
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(task.istAbgeschlossen ? Color.gray : env.neonGreen)
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(12)
    }
}