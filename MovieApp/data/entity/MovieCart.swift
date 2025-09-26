//
//  MovieCart.swift
//  MovieApp
//
//  Created by selinay ceylan on 23.09.2025.
//

import Foundation

class MovieCart : Identifiable, Codable {
    var cartId: Int?
    var name: String?
    var image: String?
    var price: Int?
    var category: String?
    var rating: Double?
    var year: Int?
    var director: String?
    var description: String?
    var orderAmount: Int?
    var userName: String?
    
    init(cartId: Int? = nil, name: String? = nil, image: String? = nil, price: Int? = nil, category: String? = nil, rating: Double? = nil, year: Int? = nil, director: String? = nil, description: String? = nil, orderAmount: Int? = nil, userName: String? = nil) {
        self.cartId = cartId
        self.name = name
        self.image = image
        self.price = price
        self.category = category
        self.rating = rating
        self.year = year
        self.director = director
        self.description = description
        self.orderAmount = orderAmount
        self.userName = userName
    }
    
    init() {
        
    }
}
