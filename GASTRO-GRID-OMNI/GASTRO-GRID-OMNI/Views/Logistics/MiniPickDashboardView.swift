import SwiftUI

struct MiniPickDashboardView: View {
    @StateObject private var viewModel = MiniPickViewModel()
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 15) {
                    headerSection
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(viewModel.tourenPlan) { order in
                                deliveryCard(for: order)
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
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("MINIPICK LOGISTICS")
                    .font(.caption).bold().foregroundColor(.orange)
                Text("TOURENPLAN")
                    .font(.title.bold()).foregroundColor(.white)
            }
            Spacer()
            Image(systemName: "box.truck.fill")
                .foregroundColor(.orange)
                .font(.largeTitle)
        }
        .padding(.horizontal)
    }
    
    private func deliveryCard(for order: LogisticsOrder) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(LocalizedStringKey(order.produktNameKey))
                    .font(.headline).foregroundColor(.white)
                Spacer()
                if order.prioritaet == .urgent {
                    Text("PRIO")
                        .font(.system(size: 10, weight: .black))
                        .padding(4)
                        .background(Color.red)
                        .cornerRadius(4)
                }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Label(order.vonOrt, systemImage: "house.fill")
                    Label(order.nachOrt, systemImage: "mappin.and.ellipse")
                }
                .font(.caption).foregroundColor(.gray)
                Spacer()
                Text("\(order.menge) \(order.einheit)")
                    .font(.headline).foregroundColor(env.neonGreen)
            }
            
            Button(action: { viewModel.updateStatus(for: order) }) {
                HStack {
                    Text(statusActionText(for: order.status))
                    Spacer()
                    Image(systemName: "chevron.right")
                }
                .font(.subheadline.bold())
                .padding()
                .background(order.status == .geliefert ? Color.gray : env.neonGreen)
                .foregroundColor(.black)
                .cornerRadius(8)
            }
            .disabled(order.status == .geliefert)
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
    
    private func statusActionText(for status: LogisticsOrder.DeliveryStatus) -> String {
        switch status {
        case .bereit: return "ABHOLUNG BESTÄTIGEN"
        case .unterwegs: return "ALS GELIEFERT MARKIEREN"
        case .geliefert: return "ERLEDIGT"
        }
    }
}
