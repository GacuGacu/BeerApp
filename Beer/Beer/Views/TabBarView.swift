import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Int = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
                .tabItem {
                    Label("Collection", systemImage: "cabinet.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .tabViewStyle(DefaultTabViewStyle())
        .accentColor(.orange)
    }
}

#Preview {
    TabBarView()
}
