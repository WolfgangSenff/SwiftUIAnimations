//
//  ShoppingCartView.swift
//  ShopAround
//
//  Created by Kyle Szklenski on 8/12/24.
//


import SwiftUI
import SwiftData

struct ShoppingCartView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.setCartIcon) private var setCartIcon
    @Query(filter: #Predicate {
        $0.isInCart
    }, sort: \Cat.friendlyName) private var shoppingCartCats: [Cat]
    
    @State private var totalCost = Decimal(0.0)
    @State private var isCleared = false
    @State private var isAnimatedMasking = false
    @State private var xoffset = 0.0
    @State private var isAnimatingIntoView = false
    
    private var predicate: Predicate<Cat> {
        #Predicate<Cat> {
            $0.isInCart
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if !isCleared {
                    VStack {
                        List(shoppingCartCats) { cat in
                            ShoppingCartItemView(data: cat)
                                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                                    return 0
                                }
                                .alignmentGuide(.listRowSeparatorTrailing) { viewDimensions in
                                    return viewDimensions[.listRowSeparatorTrailing] // This sort of odd-looking move makes the separators be inset the same amount on both sides, which looks much nicer to me than either not being inset at all, or only being inset on the leading anchor
                                }
                                .transition(isAnimatingIntoView ? .slide : .identity)
                        }
                        .animation(.easeInOut, value: shoppingCartCats)
                        .listStyle(.plain)
                        .frame(height: 500)
                        if !isCleared {
                            HStack {
                                Text("Total cats: \(shoppingCartCats.count)")
                                Spacer()
                                Text("Total cost: $\(totalCost.formatted())")
                            }.padding()
                            Spacer()
                            if !isAnimatedMasking {
                                Button {
                                    withAnimation {
                                        isAnimatedMasking.toggle()
                                    }
                                } label: {
                                    HStack {
                                        Spacer()
                                        Text("Checkout")
                                        Spacer()
                                    }
                                }
                                .offset(y: -50)
                                .padding(.leading, 40)
                                .padding(.trailing, 40)
                                .buttonStyle(.borderedProminent)
                            } else {
                                AnimatedCatView()
                                    .onDoneAction {
                                        clearCart()
                                    }
                            }
                        }
                    }
                }
            }
            .toolbar {
                if !isCleared {
                    ToolbarItem(placement: .topBarTrailing) {
                        if shoppingCartCats.count > 0 {
                            Button {
                                clearCart()
                            } label: {
                                Text("Empty Cart")
                            }
                        }
                    }
                }
            }
            .onAppear {
                for cat in shoppingCartCats {
                    totalCost += cat.totalCost
                }
                withAnimation {
                    isAnimatingIntoView = true
                }
            }
            .onDisappear {
                isAnimatingIntoView = false
            }
        }
    }
    
    func clearCart() {
        Task {
            for cat in shoppingCartCats {
                cat.isInCart.toggle()
                try await Task.sleep(nanoseconds: 500000000)
            }
            
            var trans = Transaction()
            trans.addAnimationCompletion {
                withAnimation {
                    setCartIcon?.call()
                    dismiss()
                }
            }
            withTransaction(trans) {
                if !isCleared {
                    isCleared.toggle()
                }
            }
        }
    }
}

#Preview {
    ShoppingCartView().modelContainer(Cat.preview)
}
