//
//  Cat.swift
//  ShopAround
//
//  Created by Kyle Szklenski on 8/11/24.
//

import SwiftData
import SwiftUI

enum Status: Codable { case available, unavailable(reason: String) }

@Model
final class Cat: ObservableObject, Identifiable {
    var friendlyName: String
    var imgFilename: String
    var catDescription: String
    var cost: Decimal
    var status: Status
    var interest: Double
    var isInCart: Bool
    
    var totalCost: Decimal {
        cost * Decimal(interest)
    }
    
    var image: Image {
        Image(imgFilename)
    }
    
    init(friendlyName: String, imgFilename: String, catDescription: String, cost: Decimal, status: Status, interest: Double, isInCart: Bool = false) {
        self.friendlyName = friendlyName
        self.imgFilename = imgFilename
        self.catDescription = catDescription
        self.cost = cost
        self.status = status
        self.interest = interest
        self.isInCart = isInCart
    }
    
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: Cat.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        for cat in previewCats {
            container.mainContext.insert(cat)
        }
        
        return container
    }
    
    static var previewCats: [Cat] {
        [
            Cat(friendlyName: "Feeshee", imgFilename: "anymore_of_that_feeshee", catDescription: "Feeshee comes to us from the south, a rescue from the recent hurricane Debby! Luckily, she likes fish!", cost: 40.0, status: .available, interest: 1.2, isInCart: true),
            Cat(friendlyName: "Hooman", imgFilename: "hooman", catDescription: "Hooman, as he likes to be called, loafs around all day, like a perfect cat.", cost: 30.0, status: .available, interest: 1.5, isInCart: true),
            Cat(friendlyName: "George", imgFilename: "monkey", catDescription: "George climbs trees and prunes them for a living. He'll make around $20 for every job for you!", cost: 70.0, status: .available, interest: 1.6, isInCart: true),
            Cat(friendlyName: "Brainful", imgFilename: "no_brains", catDescription: "We absolutely adore Brainful, but he runs into cabinets sometimes.", cost: 55.0, status: .available, interest: 2.2),
            Cat(friendlyName: "Super Mario", imgFilename: "super_mario", catDescription: "This guy can jump and stomp on goombas!", cost: 52.0, status: .available, interest: 1.3),
            Cat(friendlyName: "Calypso", imgFilename: "tonight_im_lovin_you", catDescription: "She can melt anyone's heart with a simple glance, wouldn't you agree?", cost: 150.0, status: .unavailable(reason: "Reserved"), interest: 1.1),
            Cat(friendlyName: "Einstein", imgFilename: "youre_in_trouble", catDescription: "Is literally the smartest cat alive, and can escape almost any enclosure.", cost: 70.0, status: .available, interest: 1.4)
        ]
    }
}

@ModelActor
actor CatActor: Sendable {
    private var context: ModelContext { modelExecutor.modelContext }
        
    func createDatabaseIfNotExists() {
            Task {
                let fetched = try? context.fetchCount(FetchDescriptor<Cat>())
                if (fetched ?? 0) == 0 {
                    context.insert(Cat(friendlyName: "Hooman", imgFilename: "hooman", catDescription: "Hooman, as he likes to be called, loafs around all day, like a perfect cat.", cost: 30.0, status: .available, interest: 1.5))
                    context.insert(Cat(friendlyName: "Feeshee", imgFilename: "anymore_of_that_feeshee", catDescription: "Feeshee comes to us from the south, a rescue from the recent hurricane Debby! Luckily, she likes fish!", cost: 40.0, status: .available, interest: 1.2))
                    context.insert(Cat(friendlyName: "George", imgFilename: "monkey", catDescription: "George climbs trees and prunes them for a living. He'll make around $20 for every job for you!", cost: 70.0, status: .available, interest: 1.6))
                    context.insert(Cat(friendlyName: "Brainful", imgFilename: "no_brains", catDescription: "We absolutely adore Brainful, but he runs into cabinets sometimes.", cost: 55.0, status: .available, interest: 2.2))
                    context.insert(Cat(friendlyName: "Super Mario", imgFilename: "super_mario", catDescription: "This guy can jump and stomp on goombas!", cost: 52.0, status: .available, interest: 1.3))
                    context.insert(Cat(friendlyName: "Calypso", imgFilename: "tonight_im_lovin_you", catDescription: "She can melt anyone's heart with a simple glance, wouldn't you agree?", cost: 150.0, status: .unavailable(reason: "Reserved"), interest: 1.1))
                    context.insert(Cat(friendlyName: "Einstein", imgFilename: "youre_in_trouble", catDescription: "Is literally the smartest cat alive, and can escape almost any enclosure.", cost: 70.0, status: .available, interest: 1.4))
                    try? context.save()
                }
            }
    }
}
