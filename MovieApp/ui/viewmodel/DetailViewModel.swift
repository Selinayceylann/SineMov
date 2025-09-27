//
//  DetailViewModel.swift
//  MovieApp
//
//  Created by selinay ceylan on 23.09.2025.
//

import Foundation

@MainActor
class DetailViewModel: ObservableObject {
    private let repository = MoviesRepository()
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    func insertMovie(name: String, image: String, price: Int, category: String, rating: Double, year: Int, director: String, description: String, orderAmount: Int, userName: String) async {
        isLoading = true
        
        do {
            try await repository.insertMovie(
                name: name,
                image: image,
                price: price,
                category: category,
                rating: rating,
                year: year,
                director: director,
                description: description,
                orderAmount: orderAmount,  
                userName: userName
            )
            
            alertMessage = "Film sepete başarıyla eklendi!"
            showAlert = true
            
        } catch {
            alertMessage = "Hata: \(error.localizedDescription)"
            showAlert = true
        }
        
        isLoading = false
    }
}
