//
//  ProductionOrderView.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//


import SwiftUI

struct ProductionOrderView: View {
    @State var task: DetailedTask
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // --- HEADER: WAS & WORIN? ---
                VStack(alignment: .leading) {
                    Text(task.titel.uppercased())
                        .font(.title2.bold())
                        .foregroundColor(env.neonGreen)
                    
                    Label(task.hardware, systemImage: "tray.full.fill")
                        .font(.headline)
                        .foregroundColor(.orange)
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)

                // --- WARENLISTE ---
                VStack(alignment: .leading, spacing: 10) {
                    Text("BENÖTIGTE WARE:").font(.caption).bold().foregroundColor(.gray)
                    ForEach(task.ware, id: \.self) { item in
                        Label(item, systemImage: "box.truck.fill")
                            .foregroundColor(.white)
                    }
                }
                .padding()

                // --- ARBEITSSCHRITTE ---
                VStack(alignment: .leading, spacing: 10) {
                    Text("AUFTRAG:").font(.caption).bold().foregroundColor(.gray)
                    Text(task.anweisung)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(env.neonGreen.opacity(0.1))
                        .cornerRadius(8)
                }
                .padding()

                // --- ABSCHLUSS-MODUL ---
                VStack(spacing: 15) {
                    Text("LOGISTIK-ZIEL: \(task.zielOrt)")
                        .font(.footnote).bold().foregroundColor(.blue)
                    
                    Button(action: { task.istAbgeschlossen.toggle() }) {
                        HStack {
                            Text(task.istAbgeschlossen ? "AUFTRAG ABGESCHLOSSEN" : "JETZT ABSCHLIESSEN")
                            Spacer()
                            Image(systemName: task.istAbgeschlossen ? "checkmark.seal.fill" : "circle")
                        }
                        .font(.headline)
                        .padding()
                        .background(task.istAbgeschlossen ? Color.green : env.neonGreen)
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    }
                    
                    if task.istAbgeschlossen {
                        feedbackSection
                    }
                }
                .padding()
            }
        }
        .background(Color.black.ignoresSafeArea())
    }
    
    // Sektion für Verzögerungen und Kommentare
    private var feedbackSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("FEEDBACK AN DEN CHEF").font(.caption).bold().foregroundColor(.gray)
            
            Picker("Verzögerung?", selection: $task.verzoegerungsGrund) {
                Text("Keine Verzögerung").tag(nil as DetailedTask.DelayReason?)
                ForEach(DetailedTask.DelayReason.allCases, id: \.self) { reason in
                    Text(reason.rawValue).tag(reason as DetailedTask.DelayReason?)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)

            TextField("Kommentar (z.B. Zeit zu kurz)", text: Binding(
                get: { task.kommentar ?? "" },
                set: { task.kommentar = $0 }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .foregroundColor(.white)
        }
    }
}