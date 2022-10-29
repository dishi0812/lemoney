//
//  CreateWishlistSheet.swift
//  lemoney
//
//  Created by T Krobot on 29/10/22.
//

import SwiftUI

struct CreateWishlistSheet: View {
    @State var item = ""
    @State var type = 1
    var body: some View {
        VStack {
            Form {
                Section {
                    Picker("Type", selection: $type) {
                        ForEach(1 ..< 3, content: { i in
                            if (i == 1) {
                                Text("Need")
                            } else {
                                Text("Want")
                            }
                        })
                        .pickerStyle(.segmented)
                    }
                    TextField("Enter item here", text: $item)
                    Text("Hello World!")
                }
            }
        }
    }
}
struct CreateWishlistSheet_Previews: PreviewProvider {
    static var previews: some View {
        CreateWishlistSheet()
    }
}
