//
//  LoadingErrorView.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//

import SwiftUI

struct LoadingErrorView: View {
    @EnvironmentObject private var billsModel: BillsModel

    @State private var isProcessingRequest: Bool = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("There was a problem retrieving your user data. Please try again.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)

                Button {
                    checkSignedUpUser()
                } label: {
                    Text("Retry")
                        .frame(maxWidth: .infinity)
                        .opacity(isProcessingRequest ? 0 : 1)
                        .overlay {
                            if isProcessingRequest {
                                ProgressView()
                            }
                        }
                }
                .buttonStyle(.roundedProminent)
                .disabled(isProcessingRequest)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        billsModel.signOut()
                    } label: {
                        Text("Sign Out")
                            .bold()
                    }
                }
            }
        }
    }

    private func checkSignedUpUser() {
        Task { @MainActor in
            isProcessingRequest = true
            await billsModel.checkSignedUpUser()
            isProcessingRequest = false
        }
    }
}

struct LoadingErrorView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingErrorView()
            .environmentObject(BillsModel(gateway: .remote))
    }
}
