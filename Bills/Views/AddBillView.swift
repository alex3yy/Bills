//
//  AddBillView.swift
//  Bills
//
//  Created by Alex Zaharia on 28.06.2023.
//

import SwiftUI

struct BillConfig {
    struct Service: Identifiable {
        var id = UUID()
        var title: String = ""
        var value: Double = 0
    }

    enum Provider: String, Identifiable, CaseIterable {
        var id: Self { self }

        case digi
        case orange
        case eon
        case electrica
        case vodafone
    }

    let mockedServices = [
        Service(title: "Serv. telecomunicatii", value: Double.random(in: 20...500)),
        Service(title: "TV", value: Double.random(in: 20...500)),
        Service(title: "Internet", value: Double.random(in: 20...500)),
        Service(title: "Consum energie", value: Double.random(in: 20...500)),
        Service(title: "Gaze naturale", value: Double.random(in: 20...500)),
        Service(title: "Verificare tehnica", value: Double.random(in: 20...500)),
        Service(title: "Echipament", value: Double.random(in: 20...500)),
    ]

    var provider: Provider = .digi
    var services: [Service] = []

    var total: Double {
        services.map(\.value).reduce(0, +)
    }

    mutating func addNewService() {
        services.append(Service())
    }

    mutating func generateRandomBill() {
        services = []
        provider = Provider.allCases.randomElement()!

        var shuffled = mockedServices.shuffled()
        for _ in 0..<Int.random(in: 1...4) {
            let element = shuffled.popLast()!
            services.append(element)
        }
    }
}

struct AddBillView: View {

    @EnvironmentObject private var billsModel: BillsModel
    @EnvironmentObject private var navigationModel: NavigationModel

    @State private var billConfig = BillConfig()

    var body: some View {
        if let user = billsModel.user {
            Form {

                Section {
                    Picker("Provider", selection: $billConfig.provider) {
                        ForEach(BillConfig.Provider.allCases) { provider in
                            Text(provider.rawValue.capitalized).tag(provider)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }

                Section("Client") {
                    LabeledContent("Name", value: user.name)
                    LabeledContent("Identifier", value: user.id)
                }

                Section {
                    ForEach($billConfig.services) { service in
                        LabeledContent {
                            TextField("", value: service.value, format: .currency(code: "RON"))
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.secondary)
                        } label: {
                            TextField("", text: service.title, prompt: Text("Service Name..."), axis: .vertical)
                                .frame(alignment: .leading)
                                .lineLimit(2)
                        }
                    }
                } header: {
                    Text("Services")
                } footer: {
                    Button {
                        billConfig.addNewService()
                    } label: {
                        Label("Service", systemImage: "plus")
                            .foregroundColor(.accentColor)
                    }
                    .tint(.white)
                    .buttonBorderShape(.capsule)
                    .buttonStyle(.borderedProminent)
                }

                Section {
                    LabeledContent("Total", value: billConfig.total, format: .currency(code: "RON"))
                }

                Button {
                    billConfig.generateRandomBill()
                } label: {
                    Text("Generate bill")
                }
            }
        }
    }
}

struct AddBillView_Previews: PreviewProvider {
    static var previews: some View {
        AddBillView()
            .environmentObject(BillsModel(gateway: .remote))
            .environmentObject(NavigationModel())
    }
}
