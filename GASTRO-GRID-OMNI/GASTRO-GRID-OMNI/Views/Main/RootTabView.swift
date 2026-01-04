//
//  RootTabView.swift
//  GASTRO-GRID-OMNI
//
//  Created by Andreas Pelczer on 04.01.26.
//

import SwiftUI

/// Die Haupt-Navigation der App.
/// Hier werden alle Module (Director, Dispatcher, Produktion und My Day) zusammengeführt.
struct RootTabView: View {
    @EnvironmentObject var env: GlobalEnvironment
    
    // --- FIX: ZENTRALES VIEWMODEL ---
    // Wir erstellen das DispatcherViewModel hier einmal als StateObject.
    // Dadurch greifen Dispatcher (Chef) und BriefingBoard (Koch) auf die IDENTISCHEN Daten zu.
    @StateObject private var sharedDispatcherVM = DispatcherViewModel()
    
    var body: some View {
        TabView {
            // TAB 1: DAS BRIEFING (Dein persönlicher Einsatzplan)
            // FIX: Wir übergeben hier das sharedDispatcherVM an den Parameter 'dispatcherVM'
            BriefingBoardView(dispatcherVM: sharedDispatcherVM)
                .tabItem {
                    Label("Mein Tag", systemImage: "clipboard.fill")
                }
            
            // TAB 2: DIRECTOR DASHBOARD (KPIs und Outlet-Status)
            GlobalDashboardView()
                .tabItem {
                    Label("Director", systemImage: "chart.bar.xaxis")
                }
            
            // TAB 3: DISPATCHER (Planung und Personal-Zuweisung)
            // Auch hier nutzen wir das geteilte ViewModel
            DispatcherView(viewModel: sharedDispatcherVM)
                .tabItem {
                    Label("Dispatcher", systemImage: "person.2.badge.gearshape.fill")
                }
            
            // TAB 4: PRODUKTION (Aufgaben wie Zwiebeln/Huhn)
            ProductionControlView()
                .tabItem {
                    Label("Produktion", systemImage: "fork.knife")
                }
            
            // TAB 5: EINSTELLUNGEN (Sprachwahl und Profil)
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.2.fill")
                }
        }
        .accentColor(env.neonGreen) // Dein Corporate Neon-Green
    }
}
