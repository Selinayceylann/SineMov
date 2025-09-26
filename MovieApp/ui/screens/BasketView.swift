//
//  BasketScreen.swift
//  MovieApp
//
//  Created by selinay ceylan on 23.09.2025.
//

import SwiftUI

struct BasketView: View {
    @StateObject var viewmodel = BasketViewModel()
    let userName = "selinay_ceylan"
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            if viewmodel.groupedCart.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "cart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                    Text("Your cart is empty")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewmodel.groupedCart) { item in
                            HStack(spacing: 12) {
                                // Film görseli
                                AsyncImage(url: URL(string: "http://kasimadalan.pe.hu/movies/images/\(item.image ?? "")")) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView().frame(width: 80, height: 120)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 120)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                                    case .failure(_):
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 120)
                                            .foregroundColor(.gray)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    @unknown default: EmptyView()
                                    }
                                }

                                VStack(alignment: .leading, spacing: 8) {
                                    Text(item.name ?? "name")
                                        .font(.custom("Lato-Bold", size: 20))
                                        .foregroundColor(.primary)
                                    HStack {
                                        Text("Quantity: \(item.orderAmount ?? 0)")
                                            .foregroundColor(.secondary)
                                        Spacer()
                                    }
                                }

                                Spacer()

                                VStack(spacing: 12) {
                                    Button(action: {
                                        Task {
                                            if let lastMovie = viewmodel.movieCartList.filter({ $0.name == item.name }).last,
                                               let cartId = lastMovie.cartId,
                                               let currentAmount = lastMovie.orderAmount {
                                                await viewmodel.deleteMovie(cartId: cartId, userName: userName)
                                                if currentAmount > 1 {
                                                    await viewmodel.insertMovie(movie: lastMovie, amount: currentAmount - 1)
                                                }
                                                await viewmodel.getMovieCart(userName: userName)
                                            }
                                        }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.red)
                                    }

                                    Button(action: {
                                        Task {
                                            if let lastMovie = viewmodel.movieCartList.filter({ $0.name == item.name }).last {
                                                await viewmodel.insertMovie(movie: lastMovie, amount: 1)
                                                await viewmodel.getMovieCart(userName: userName)
                                            }
                                        }
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(AppColor.mainColor).opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 16))

                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            Task {
                await viewmodel.getMovieCart(userName: userName)
            }
        }
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                        Text("SineMov")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                }
            }
        }
    }
}

#Preview {
    BasketView()
}
