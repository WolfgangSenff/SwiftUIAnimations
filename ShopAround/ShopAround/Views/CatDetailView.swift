//
//  CatDetailView.swift
//  ShopAround
//
//  Created by Kyle Szklenski on 8/11/24.
//

import SwiftUI
import SwiftData

struct CatDetailView: View {
    @Query(sort: \Cat.cost) private var allCats: [Cat]
    
    @State private var wantsToBuy = false
    @State private var isLeading = false
    @State private var isAnimating = false
    
    @State var data: Cat
    
    var body: some View {
        VStack {
            Text(data.friendlyName).padding()
            data.image
                .resizable()
                .scaledToFit()
                .cornerRadius(7)
            HStack {
                if wantsToBuy {
                    Spacer()
                } else {
                    Group {
                        VStack {
                            Text("Base")
                                .underline()
                            Text("$\(data.cost.formatted())")
                        }
                        Spacer()
                        Text("X")
                        Spacer()
                        VStack {
                            Text("Love")
                                .underline()
                            Text("\(data.interest.formatted())")
                        }
                        Spacer()
                        Text("=")
                        Spacer()
                    }
                    .opacity(wantsToBuy ? 0 : 1)
                }
                
                Group {
                    VStack {
                        Text("Total")
                            .underline()
                            .if(wantsToBuy) { view in
                                view.fontWeight(.heavy)
                                    .bold()
                            }
                        
                        Text("$\(data.totalCost.formatted())")
                            .if(wantsToBuy) { view in
                                view.fontWeight(.heavy)
                                    .bold()
                            }
                    }
                }
                .animation(.easeInOut(duration: 1.0), value: isLeading)
                
                if isLeading {
                    Spacer()
                }
            }
            .padding()
            
            Text(data.catDescription)
            Spacer()
            Button {
                data.isInCart = !data.isInCart
                try? data.modelContext?.save()
                if wantsToBuy {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isAnimating.toggle()
                        isLeading.toggle()
                    } completion: {
                        withAnimation {
                            wantsToBuy.toggle()
                        } completion: {
                            withAnimation {
                                isAnimating.toggle()
                            }
                        }
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isAnimating.toggle()
                        wantsToBuy.toggle()
                    } completion: {
                        var trans = Transaction(animation: .easeInOut(duration: 0.5))
                        trans.addAnimationCompletion {
                            withAnimation {
                                isAnimating.toggle()
                            }
                        }
                        withTransaction(trans) {
                            isLeading.toggle()
                        }
                    }
                }
            } label: {
                if data.isInCart {
                    Text("Remove from cart")
                } else {
                    Text("Add to cart")
                }
            }
            .buttonStyle(.borderedProminent)
            .padding(.leading, 40)
            .padding(.trailing, 40)
            .offset(y: -20)
            .disabled(isAnimating)
        }
        .gesture(
            DragGesture(minimumDistance: 5.0, coordinateSpace: .local)
                .onEnded({ value in
                    if value.translation.width > 0 {
                        // left
                        var index = allCats.firstIndex(of: data)!
                        index -= 1
                        if index < 0 {
                            index = allCats.count - 1
                        }
                        data = allCats[index]
                        var trans = Transaction()
                        trans.disablesAnimations = true
                        withTransaction(trans) {
                            isLeading = data.isInCart
                            wantsToBuy = data.isInCart
                        }
                    } else if value.translation.width < 0 {
                        // right
                        var index = allCats.firstIndex(of: data)!
                        index += 1
                        if index >= allCats.count {
                            index = 0
                        }
                        data = allCats[index]
                        var trans = Transaction()
                        trans.disablesAnimations = true
                        withTransaction(trans) {
                            isLeading = data.isInCart
                            wantsToBuy = data.isInCart
                        }
                    }
                })
        )
        .padding()
        .onAppear {
            if self.data.isInCart && !wantsToBuy {
                var trans = Transaction()
                trans.disablesAnimations = true
                withTransaction(trans) {
                    wantsToBuy.toggle()
                    isLeading.toggle()
                }
            }
        }
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

#Preview {
    CatDetailView(data: Cat(friendlyName: "Feeshee", imgFilename: "anymore_of_that_feeshee", catDescription: "Feeshee comes to us from the south, a rescue from the recent hurricane Debby! Luckily, she likes fish!", cost: 40.0, status: .available, interest: 1.2))
}
