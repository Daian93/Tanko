//
//  OnboardingActions.swift
//  Tanko
//
//  Created by Diana Rammal Sansón on 25/2/26.
//

import SwiftUI

struct OnboardingActions: View {
    let onLogin: () -> Void
    let onRegister: () -> Void
    let onGuest: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Login button
            Button {
                onLogin()
            } label: {
                HStack {
                    Image(systemName: "person.fill")
                        .font(.title3)
                    Text("login.title")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.white)
                .foregroundStyle(.tankoPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            }

            // Register button
            Button {
                onRegister()
            } label: {
                HStack {
                    Image(systemName: "person.badge.plus")
                        .font(.title3)
                    Text("register.title")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.white.opacity(0.2))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.5), lineWidth: 2)
                )
            }

            // Guest button
            Button {
                onGuest()
            } label: {
                HStack {
                    Image(systemName: "person.slash")
                        .font(.title3)
                    Text("login.guest")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundStyle(.white.opacity(0.8))
                .padding(.vertical, 12)
            }
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 50)
    }
}

#Preview {
    OnboardingActions(
        onLogin: { print("Login tapped") },
        onRegister: { print("Register tapped") },
        onGuest: { print("Guest tapped") }
    )
    .background(.tankoPrimary.opacity(0.7))
}
