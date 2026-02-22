//
//  LoadingView.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 13/2/26.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var showMessage = false
    
    let message: String
    
    init(message: String = "Sincronizando tu colección...") {
        self.message = message
    }
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    .tankoPrimary.opacity(0.8),
                    .tankoSecondary.opacity(0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Animated book icon
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .scaleEffect(isAnimating ? 1.2 : 1.0)
                        .opacity(isAnimating ? 0.3 : 0.8)
                    
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .opacity(isAnimating ? 0.5 : 1.0)
                    
                    Image(systemName: "books.vertical.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.white)
                        .rotationEffect(.degrees(isAnimating ? 360 : 0))
                }
                .animation(
                    .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true),
                    value: isAnimating
                )
                
                // Loading message
                VStack(spacing: 12) {
                    Text(message)
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
                    if showMessage {
                        Text("Esto puede tardar unos segundos...")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                            .transition(.opacity)
                    }
                }
                .padding(.horizontal, 40)
                
                // Progress indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                    .padding(.top, 20)
                
                Spacer()
                
                // Tanko branding
                VStack(spacing: 8) {
                    Text("TANKO")
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                    
                    Text("Tu colección de manga")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation {
                isAnimating = true
            }
            
            // Show additional message after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showMessage = true
                }
            }
        }
    }
}

#Preview {
    LoadingView()
}

#Preview("With custom message") {
    LoadingView(message: "Cargando tu biblioteca...")
}
