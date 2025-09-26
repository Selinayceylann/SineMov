//
//  BasketViewModel.swift
//  MovieApp
//
//  Created by selinay ceylan on 23.09.2025.
//

import Foundation
import SwiftUI

@MainActor
class BasketViewModel: ObservableObject {
    private let repository = MoviesRepository()
    
    @Published var movieCartList = [MovieCart]()

    var groupedCart: [MovieCart] {
        var dict: [String: MovieCart] = [:]

        for item in movieCartList {
            if let name = item.name {
                if let existing = dict[name] {
                    let updatedItem = MovieCart(
                        cartId: existing.cartId,
                        name: existing.name,
                        image: existing.image,
                        price: existing.price,
                        category: existing.category,
                        rating: existing.rating,
                        year: existing.year,
                        director: existing.director,
                        description: existing.description,
                        orderAmount: (existing.orderAmount ?? 0) + (item.orderAmount ?? 0),
                        userName: existing.userName
                    )
                    dict[name] = updatedItem
                } else {
                    let newItem = MovieCart(
                        cartId: item.cartId,
                        name: item.name,
                        image: item.image,
                        price: item.price,
                        category: item.category,
                        rating: item.rating,
                        year: item.year,
                        director: item.director,
                        description: item.description,
                        orderAmount: item.orderAmount,
                        userName: item.userName
                    )
                    dict[name] = newItem
                }
            }
        }
        return Array(dict.values)
    }

    func getMovieCart(userName: String) async {
        do {
            movieCartList = try await repository.getMovieCart(userName: userName)
            print("Sepet güncellendi. Toplam öğe sayısı: \(movieCartList.count)")

            for item in movieCartList {
                print("Film: \(item.name ?? "Unknown"), Adet: \(item.orderAmount ?? 0), CartID: \(item.cartId ?? -1)")
            }

        } catch {
            
            movieCartList = []
        }
    }


    func deleteMovie(cartId: Int, userName: String) async {
        do {
            try await repository.deleteMovie(cartId: cartId, userName: userName)
        } catch {
            
        }
    }

    func insertMovie(movie: MovieCart, amount: Int) async {
        do {
            try await repository.insertMovie(
                name: movie.name ?? "",
                image: movie.image ?? "",
                price: movie.price ?? 0,
                category: movie.category ?? "",
                rating: movie.rating ?? 0,
                year: movie.year ?? 0,
                director: movie.director ?? "",
                description: movie.description ?? "",
                orderAmount: amount,
                userName: movie.userName ?? ""
            )
        } catch {
            
        }
    }
}
