//
//  HomeViewModel.swift
//  MovieApp
//
//  Created by selinay ceylan on 23.09.2025.
//

import Foundation

@MainActor
class HomeViewModel : ObservableObject {
    private let repository = MoviesRepository()
    @Published var movieList = [Movies]()
    
    func getAllMovies() async {
        do {
            movieList = try await repository.getAllMovies()
        } catch {
            movieList = [Movies]()
        }
    }
    
    func search(searchText: String) async {
        do {
            movieList = try await repository.search(searchText: searchText)
        } catch {
            movieList = [Movies]()
        }
    }
    
}
