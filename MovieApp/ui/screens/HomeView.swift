//
//  ContentView.swift
//  MovieApp
//
//  Created by selinay ceylan on 23.09.2025.
//

import SwiftUI

struct HomeView: View {
    
    init() {
        NavigationBarStyle.setupNavigationBar()

    }

    @ObservedObject var viewmodel = HomeViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    let categories = Array(Set(viewmodel.movieList.compactMap { $0.category }))
                    
                    ForEach(categories, id: \.self) { category in
                        let moviesByCategory = viewmodel.movieList.filter { $0.category == category }
                        
                        if !moviesByCategory.isEmpty {
                            Text(category)
                                .font(.custom("Lato-Bold", size: 22))
                                .padding(.horizontal)
                                .padding(.vertical, 4)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 16) {
                                    ForEach(moviesByCategory) { movie in
                                        NavigationLink(destination: DetailView(movie: movie)) {
                                            VStack(spacing: 8) {
                                                AsyncImage(url: URL(string: "http://kasimadalan.pe.hu/movies/images/\(movie.image ?? "")")) { phase in
                                                    switch phase {
                                                    case .empty:
                                                        ProgressView()
                                                            .frame(width: 140, height: 200)
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 140, height: 200)
                                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                                                    case .failure(_):
                                                        Image(systemName: "photo")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 140, height: 200)
                                                            .foregroundColor(.gray)
                                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                                    @unknown default: EmptyView()
                                                    }
                                                }
                                                
                                                Text(movie.name ?? "movie")
                                                    .lineLimit(1)
                                                    .foregroundColor(.primary)
                                                
                                                HStack(spacing: 4) {
                                                    Image(systemName: "star.fill")
                                                        .foregroundColor(.yellow)
                                                    Text(String(format: "%.1f", movie.rating ?? 0))
                                                        .foregroundColor(.secondary)
                                                }
                                            }
                                            .frame(width: 140)
                                            .padding(8)
                                            .background(AppColor.mainColor.opacity(0.5))
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("SineMov")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: BasketView()) {
                        Image(systemName: "cart")
                            .foregroundColor(.white)
                    }
                }
            }
            .onAppear {
                Task {
                    await viewmodel.getAllMovies()
                }
            }
        }
        .searchable(text: $searchText,prompt: "Search")
        .onChange(of: searchText){ _,result in
            Task{
                await viewmodel.search(searchText: result)
            }
        }
    }
}

#Preview {
    HomeView()
}
