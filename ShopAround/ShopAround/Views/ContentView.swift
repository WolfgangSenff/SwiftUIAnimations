//
//  ContentView.swift
//  ShopAround
//
//  Created by Kyle Szklenski on 8/11/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Cat.cost) private var cats: [Cat]
    
    @State private var showDetail = false
    @State private var showCart = false
    @State private var hasItemsInCart = false
    
    var body: some View {
        NavigationStack {
                ScrollView {
                    LazyVStack {
                        ForEach(cats) { cat in
                            NavigationLink {
                                CatDetailView(data: cat)
                            } label: {
                                CatItemView(data: cat)
                                    .onCartIconsChanged {
                                        setCartIcon()
                                    }
                            }
                        }
                    }
                    .padding()
                }
            .toolbar {
                if hasItemsInCart {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Shopping Cart", systemImage: "cart.fill") {
                            showCart.toggle()
                        }
                    }
                } else {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Shopping Cart", systemImage: "cart") {
                        }
                    }
                }
            }
            .sheet(isPresented: $showCart) {
                ShoppingCartView()
            }
            .navigationTitle("Cats for you!")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                setCartIcon()
            }
            .onCartIconsChanged {
                setCartIcon()
            }
        }
        .refreshable {
            print("I'd refresh if there was more stuff!")
        }
    }
    
    func setCartIcon() {
        var catsInCart = false
        for cat in cats {
            if cat.isInCart {
                catsInCart = true
                break
            }
        }
        if catsInCart {
            if !hasItemsInCart {
                hasItemsInCart.toggle()
            }
        } else {
            if hasItemsInCart {
                hasItemsInCart.toggle()
            }
        }
    }
}

struct SetCartIconAction {
    typealias Action = () -> ()
    let action: Action
    
    func call() {
        action()
    }
}

struct SetCartIconKey: EnvironmentKey {
    static var defaultValue: SetCartIconAction? = nil
}

extension EnvironmentValues {
    var setCartIcon: SetCartIconAction? {
        get { self[SetCartIconKey.self] }
        set { self[SetCartIconKey.self] = newValue }
    }
}

extension View {
    func onCartIconsChanged(_ action: @escaping SetCartIconAction.Action) -> some View {
        self.environment(\.setCartIcon, SetCartIconAction(action: action))
    }
}

struct DoneAction {
    typealias Action = () -> ()
    let action: Action
    
    func call() {
        action()
    }
}

struct DoneActionKey: EnvironmentKey {
    static var defaultValue: DoneAction? = nil
}

extension EnvironmentValues {
    var done: DoneAction? {
        get { self[DoneActionKey.self] }
        set { self[DoneActionKey.self] = newValue }
    }
}

extension View {
    func onDoneAction(_ action: @escaping DoneAction.Action) -> some View {
        self.environment(\.done, DoneAction(action: action))
    }
}

#Preview {
    ContentView().modelContainer(Cat.preview)
}
