//
//  FeedbackView.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//


import SwiftUI

/// Das Rückmelde-Fenster für den Koch am Posten.
/// Hier wird dokumentiert, warum etwas länger gedauert hat oder was gefehlt hat.
struct FeedbackView: View {
    let task: ProductionTask
    @ObservedObject var viewModel: ProductionTaskViewModel
    @Environment(\.dismiss) var dismiss
    
    // Lokale States für die Eingabe
    @State private var verzoegerung: String = "Keine Verzögerung"
    @State private var kommentar: String = ""
    
    // Die Gründe, die du vorgegeben hast
    let gruende = [
        "Keine Verzögerung",
        "Ware nicht am Platz",
        "Zu wenig Ware",
        "Pause gemacht",
        "Zeit zu kurz bemessen",
        "Technik-Problem",
        "Unklarer Auftrag",
        "Unvorhergesehene Transportfehler",
        "Ungültiger Auftrag, da war einer der hat gesagt, hör auf"

    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                Form {
                    Section(header: Text("STATUS FÜR: \(task.titel)").foregroundColor(.gray)) {
                        HStack {
                            Image(systemName: "clock.fill")
                            Text("Geplante Zeit: \(task.geplanteDauerMinuten) Min")
                        }
                    }
                    
                    Section(header: Text("WARUM GAB ES VERZÖGERUNGEN?").foregroundColor(.gray)) {
                        Picker("Grund", selection: $verzoegerung) {
                            ForEach(gruende, id: \.self) { grund in
                                Text(grund).tag(grund)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    
                    Section(header: Text("ANMERKUNGEN AN DEN CHEF").foregroundColor(.gray)) {
                        TextEditor(text: $kommentar)
                            .frame(height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                    
                    Section {
                        Button(action: {
                            viewModel.auftragAbschliessen(id: task.id, grund: verzoegerung == "Keine Verzögerung" ? nil : verzoegerung)
                            // Hier könnte man den Kommentar noch im ViewModel speichern
                            dismiss()
                        }) {
                            Text("PRODUKTION ABSCHLIESSEN")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.black)
                        }
                        .listRowBackground(Color(red: 0.2, green: 1.0, blue: 0.0)) // Neon Green
                    }
                }
                .preferredColorScheme(.dark)
            }
            .navigationTitle("Feedback & Abschluss")
            .navigationBarItems(leading: Button("Abbrechen") { dismiss() })
        }
    }
}
