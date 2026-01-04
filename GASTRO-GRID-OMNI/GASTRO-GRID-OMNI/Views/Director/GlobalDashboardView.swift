import SwiftUI

/// Die Kommando-Zentrale für den Direktor.
/// Übersicht über alle 30 Outlets, Produktion und Finanzen.
struct GlobalDashboardView: View {
    @EnvironmentObject var env: GlobalEnvironment
    @StateObject private var viewModel = DirectorViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        
                        // --- FINANZ-KPIs (Der Cash-Flow) ---
                        kpiHeader
                        
                        // --- STATUS ALLER OUTLETS ---
                        VStack(alignment: .leading, spacing: 15) {
                            Text("OUTLET STATUS (30 GESAMT)")
                                .font(.caption).bold().foregroundColor(.gray)
                            
                            // Liste der Venues aus dem Masterplan
                            ForEach(viewModel.allVenues) { venue in
                                VenueStatusRow(venue: venue)
                            }
                        }
                        .padding(.horizontal)
                        
                        // --- PRODUKTIONS-AUSLASTUNG ---
                        auslastungSection
                    }
                }
            }
            .navigationTitle("DIRECTOR GRID")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    // Oberer Bereich mit den wichtigsten Zahlen
    private var kpiHeader: some View {
        HStack(spacing: 15) {
            KPIBox(title: "REVENUE", value: "45.2k", color: env.neonGreen)
            KPIBox(title: "WASTE SAVED", value: "1.2k", color: .orange)
            KPIBox(title: "STAFF ON SITE", value: "582", color: .blue)
        }
        .padding()
    }
    
    private var auslastungSection: some View {
        VStack(alignment: .leading) {
            Text("PRODUKTIONS-AUSLASTUNG")
                .font(.caption).bold().foregroundColor(.gray)
            
            HStack {
                Text("Zentralküche Warm").font(.footnote)
                Spacer()
                ProgressView(value: 0.8) // 80% Auslastung
                    .accentColor(env.neonGreen)
                    .frame(width: 150)
            }
            .padding()
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

// --- HILFS-VIEWS FÜR DAS DASHBOARD ---

struct KPIBox: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.system(size: 10, weight: .bold)).foregroundColor(.gray)
            Text(value).font(.system(size: 24, weight: .black)).foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(color.opacity(0.2), lineWidth: 1))
    }
}

struct VenueStatusRow: View {
    let venue: Venue
    
    var body: some View {
        HStack {
            Circle()
                .fill(venue.istProduktion ? .blue : Color(red: 0.22, green: 1.0, blue: 0.08))
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading) {
                Text(venue.name).font(.subheadline).bold().foregroundColor(.white)
                Text(venue.type.rawValue).font(.system(size: 10)).foregroundColor(.gray)
            }
            Spacer()
            Text(venue.halle ?? "Zentrale").font(.system(size: 10, design: .monospaced)).foregroundColor(.gray)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
    }
}
