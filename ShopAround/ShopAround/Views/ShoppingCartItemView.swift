//
//  ShoppingCartItem.swift
//  ShopAround
//
//  Created by Kyle Szklenski on 8/12/24.
//



import SwiftUI
import SwiftData

struct ShoppingCartItemView: View {
    @Environment(\.modelContext) private var context
    
    @State private var isOpen = false
    
    var data: Cat
        
    var body: some View {
        // Cat pic left, cost right
        HStack {
            VStack {
                data.image
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 20))
                    .frame(width: 150)
                    .padding(.leading, 10)
                Text(data.friendlyName)
            }
            Spacer()
            Text("$\(data.totalCost)")
                .padding()
        }
        .onTapGesture {
            withAnimation(.default) {
                isOpen.toggle()
            }
        }
    }
}


#Preview {
    ShoppingCartItemView(data: Cat(friendlyName: "Feeshee", imgFilename: "anymore_of_that_feeshee", catDescription: "Feeshee comes to us from the south, a rescue from the recent hurricane Debby! Luckily, she likes fish!", cost: 40.0, status: .available, interest: 1.2, isInCart: true))
}
