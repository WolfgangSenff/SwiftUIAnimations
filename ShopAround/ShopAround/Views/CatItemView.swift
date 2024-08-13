//
//  CatItemView.swift
//  ShopAround
//
//  Created by Kyle Szklenski on 8/11/24.
//

import SwiftUI

struct CatItemView: View {
    @Environment(\.setCartIcon) private var setCartIcon
    
    let data: Cat
        
    var body: some View {
        VStack {
            Image(data.imgFilename)
                .resizable()
                .scaledToFit()
                .clipShape(.rect(cornerRadius: 20))
            HStack {
                Text(data.friendlyName)
                Spacer()
                Text("Cost: $\(data.totalCost.formatted())")
                Spacer()
                Button {
                    data.isInCart.toggle()
                    setCartIcon?.call()
                } label: {
                    Image(systemName: data.isInCart ? "cart.badge.minus" : "cart.badge.plus")
                        .resizable()
                        .frame(width: 50, height: 40)
                }
            }
            .padding()
        }
        .scrollTransition { content, phase in
            content
                .scaleEffect(phase.isIdentity ? 1 : 0.5)
                .opacity(phase.isIdentity ? 1 : 0.5)
        }
    }
}

#Preview {
    CatItemView(data: Cat(friendlyName: "Feeshee", imgFilename: "anymore_of_that_feeshee", catDescription: "Feeshee comes to us from the south, a rescue from the recent hurricane Debby! Luckily, she likes fish!", cost: 40.0, status: .available, interest: 1.2))
}
