//
//  DetailScreen.swift
//  MovieApp
//
//  Created by selinay ceylan on 23.09.2025.
//

import SwiftUI

struct DetailView: View {
    var movie = Movies()
    @StateObject var viewmodel = DetailViewModel()
    @State private var quantity: Int = 1
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                VStack(spacing: 16) {
                    AsyncImage(url: URL(string: "http://kasimadalan.pe.hu/movies/images/\(movie.image ?? "")")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 220, height: 320)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 220, height: 320)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
                        case .failure(_):
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray.opacity(0.1))
                                .frame(width: 220, height: 320)
                                .overlay(
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(.gray)
                                )
                        @unknown default: EmptyView()
                        }
                    }
                    .padding(.top, 16)

                    Text(movie.name ?? "movie")
                        .font(.custom("Lato-Bold", size: 28))
                        .foregroundColor(AppColor.mainColor)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 20) {
                        HStack(spacing: 6) {
                            Image(systemName: "tag.fill")
                                .foregroundColor(.purple)
                            Text(movie.category ?? "category")
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(AppColor.mainColor.opacity(0.5))
                        .clipShape(Capsule())
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", movie.rating ?? 0))
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(AppColor.mainColor.opacity(0.5))
                        .clipShape(Capsule())
                    }
                    .padding(.bottom, 16)
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading, spacing: 24) {
                    HStack(spacing: 16) {
                        VStack(alignment: .center, spacing: 4) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(.black)
                                Text("Year")
                                    .font(.custom("Lato-Bold", size: 18))
                                    .foregroundColor(.black)
                            }
                            if let year = movie.year {
                                Text(String(format: "%d", year))
                            } else {
                                Text("year")
                            }

                        }
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .padding()
                        .background(AppColor.mainColor.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        VStack(alignment: .center, spacing: 4) {
                            HStack {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.indigo)
                                Text("Director")
                                    .font(.custom("Lato-Bold", size: 18))
                                    .foregroundColor(.black)
                            }
                            Text(movie.director ?? "director")
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .padding()
                        .background(AppColor.mainColor.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "text.alignleft")
                                .foregroundColor(.purple)
                            Text("Description")
                                .font(.custom("Lato-Bold", size: 18))
                        }
                        
                        Text(movie.description ?? "description")
                            .foregroundColor(.primary)
                            .lineSpacing(4)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColor.mainColor.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            Text("Price: $\( (movie.price ?? 0) * quantity )")
                                .foregroundColor(.black)
                                .padding()
                                .background(AppColor.mainColor.opacity(0.5))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }

                        HStack(spacing: 16) {
                            HStack(spacing: 20) {
                                Button(action: { if quantity > 1 { quantity -= 1 } }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.gray)
                                }
                                Text("\(quantity)")
                                    .frame(minWidth: 30)
                                Button(action: { if quantity < 20 { quantity += 1 } }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(AppColor.mainColor.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            
                            Spacer()

                            Button(action: {
                                Task {
                                    await viewmodel.insertMovie(
                                        name: movie.name ?? "",
                                        image: movie.image ?? "",
                                        price: movie.price ?? 0,
                                        category: movie.category ?? "",
                                        rating: movie.rating ?? 0.0,
                                        year: movie.year ?? 0,
                                        director: movie.director ?? "",
                                        description: movie.description ?? "",
                                        orderAmount: quantity,
                                        userName: "selinay_ceylan"
                                    )
                                    showAlert = true
                                }
                            }) {
                                HStack {
                                    Image(systemName: "cart.badge.plus")
                                    Text("Add to Cart")
                                        .font(.custom("Lato-Bold", size: 18))
                                }
                                .foregroundColor(.white)
                                .frame(width: 150, height: 50)
                                .background(AppColor.mainColor)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }

                    .alert("Info", isPresented: $showAlert) {
                        Button("OK") {
                            dismiss()
                        }
                    } message: {
                        Text("Movie added to successfully!")
                    }

                }
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("SineMov")
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Detail")
    }
}

#Preview {
    DetailView()
}
