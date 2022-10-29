import SwiftUI

struct WishlistView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    Text("flkdsjflkdsjfsd")
                } header: {
                    Text("Needs").foregroundColor(.black)
                }
                Section {
                    Text("nookayergs")
                } header: {
                    Text("Wants").foregroundColor(.black)
                }
            }
            .toolbar {
                Menu {
                    
                } label: {
                    Image(systemName: "plus")
                }
            }
            .navigationTitle("Wishlist")
        }
    }
}

struct WishlistView_Previews: PreviewProvider {
    static var previews: some View {
        WishlistView()
    }
}
//
