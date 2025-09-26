//
//  MoviesItem.swift
//  MovieApp
//
//  Created by selinay ceylan on 24.09.2025.
//

import Foundation
import SwiftUI

struct MoviesItem : View {
    var movie = Movies()
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: "http://kasimadalan.pe.hu/movies/images/\(movie.image!)")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 150, height: 250)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 8)) 
                case .failure(_):
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 250)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
                
            Text(movie.name!).foregroundStyle(.blue)
        }
        .padding(8)
    }
}
