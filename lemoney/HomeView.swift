import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
                    Text("Hello, World!")
                .navigationTitle("Home")
                }
            }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
