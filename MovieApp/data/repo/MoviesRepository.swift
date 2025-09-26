//
//  MoviesRepository.swift
//  MovieApp
//
//  Created by selinay ceylan on 23.09.2025.
//

import Foundation

class MoviesRepository {
    
    private let baseUrl = "http://kasimadalan.pe.hu/movies/"

    func getAllMovies() async throws -> [Movies] {
        let apiUrl = "\(baseUrl)getAllMovies.php"
        
        guard let url = URL(string: apiUrl) else {
            throw URLError(.badURL)
        }
        
        let (data,_) = try await URLSession.shared.data(from: url)
        let moviesResponse = try JSONDecoder().decode(MoviesResponse.self, from: data)
        
        return moviesResponse.movies ?? []
    }
    
    func insertMovie(name: String, image: String, price: Int, category: String, rating: Double, year: Int, director: String, description: String, orderAmount: Int, userName: String) async throws {
        let apiUrl = "\(baseUrl)insertMovie.php"
        
        guard let url = URL(string: apiUrl) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "name=\(name)&image=\(image)&price=\(price)&category=\(category)&rating=\(rating)&year=\(year)&director=\(director)&description=\(description)&orderAmount=\(orderAmount)&userName=\(userName)"
        
        request.httpBody = postString.data(using: .utf8)
        
        let (data,_) = try await URLSession.shared.data(for: request)

        let responseString = String(data: data, encoding: .utf8)
        let crudResponse = try JSONDecoder().decode(CRUDResponse.self, from: data)
    }
    
    func getMovieCart(userName: String) async throws -> [MovieCart] {
        let apiUrl = "\(baseUrl)getMovieCart.php"
        
        guard let url = URL(string: apiUrl) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "userName=\(userName)"

        
        request.httpBody = postString.data(using: .utf8)
        let (data,_) = try await URLSession.shared.data(for: request)
        
        let responseString = String(data: data, encoding: .utf8)
        
        let movieCartResponse = try JSONDecoder().decode(MovieCartResponse.self, from: data)
        let cartItems = movieCartResponse.movie_cart ?? []

        return cartItems
    }
    
    func deleteMovie(cartId: Int, userName: String) async throws {
        let apiUrl = "\(baseUrl)deleteMovie.php"
        
        guard let url = URL(string: apiUrl) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let postString = "cartId=\(cartId)&userName=\(userName)"
        request.httpBody = postString.data(using: .utf8)
        
        let (data,_) = try await URLSession.shared.data(for: request)
        let crudResponse = try JSONDecoder().decode(CRUDResponse.self, from: data)
        print("Response : \(crudResponse.success ?? 0) - \(crudResponse.message ?? "No message")")
    }
    
    
    func search(searchText:String) async throws -> [Movies] {
        let allMovies = try await getAllMovies()
        
        if searchText.isEmpty {
            return allMovies
        }
        
        return allMovies.filter { $0.name!.lowercased().contains(searchText.lowercased()) }
    }
}
