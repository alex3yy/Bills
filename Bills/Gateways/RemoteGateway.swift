//
//  RemoteGateway.swift
//  Bills
//
//  Created by Alex Zaharia on 04.05.2023.
//

import Foundation

extension Gateway where Self == RemoteGateway {

    /// A gateway that provides API calls from the remote repository.
    static var remote: RemoteGateway {
        RemoteGateway()
    }
}

struct RemoteGateway: Gateway {

    // MARK: - Auth user methods

    func getUser(id: User.ID) async throws -> User {
        var request = GetUserRequest()
        request.id = id

        let response = try await request.response()

        return User(response.user)
    }

    func addUser(id: User.ID, name: String, email: String, photoURL: String?) async throws -> User {
        var request = AddUserRequest()
        request.id = id
        request.name = name
        request.email = email
        //request.photoURL = photoURL

        let response = try await request.response()

        return User(response.user)
    }

    func updateUser(id: User.ID, name: String?, email: String?, photoData: Data?) async throws -> User {
        var request = UpdateUserRequest()
        request.id = id
        request.name = name
        request.email = email
        //request.photoData = photoData

        let response = try await request.response()

        return User(response.user)
    }

    func deleteUser(id: User.ID) async throws {
        var request = DeleteUserRequest()
        request.id = id

        _ = try await request.response()
    }

    // MARK: - Search user methods

    func searchUser(id: User.ID) async throws -> User? {
        var request = SearchUserRequest()
        request.id = id

        let response = try await request.response()

        return User(response.user)
    }

    // MARK: - Invite user methods

    func inviteUser(senderId: User.ID, receiverId: User.ID) async throws {
        var request = InviteUserRequest()
        request.senderUserId = senderId
        request.receiverUserId = receiverId

        _ = try await request.response()
    }

    func invitedUser(senderId: User.ID, receiverId: User.ID) async throws -> Invitation.Status? {
        var request = CheckInvitedUserRequest()
        request.senderUserId = senderId
        request.receiverUserId = receiverId
        
        let response = try await request.response()

        if let invitationStatus = response.invitationStatus {
            return Invitation.Status(invitationStatus)
        }
        return nil
    }

    func getUserInvitations(userId: User.ID) async throws -> AsyncStream<[Invitation]> {
        var request = GetUserInvitationsRequest()
        request.userId = userId

        let response = try await request.response()

        let invitationsStream = AsyncStream {
            for await invitationDtos in response.invitationsStream {
                return invitationDtos.map(Invitation.init)
            }
            return []
        }

        return invitationsStream
    }

    func deleteUserInvitation(senderId: User.ID, receiverId: User.ID) async throws {
        var request = DeleteUserInvitationRequest()
        request.senderUserId = senderId
        request.receiverUserId = receiverId

        _ = try await request.response()
    }

    // MARK: - Connection user methods
    func addUserConnection(senderId: User.ID, receiverId: User.ID) async throws {
        var request = AddUserConnectionRequest()
        request.senderUserId = senderId
        request.receiverUserId = receiverId

        _ = try await request.response()
    }

    func connectedUser(senderId: User.ID, receiverId: User.ID) async throws -> Bool {
        var request = CheckConnectedUserRequest()
        request.senderUserId = senderId
        request.receiverUserId = receiverId

        let response = try await request.response()

        return response.isConnected
    }

    func getUserConnections(userId: User.ID) async throws -> [Connection] {
        var request = GetUserConnectionsRequest()
        request.userId = userId

        let response = try await request.response()

        return response.connections.map(Connection.init)
    }

    func deleteUserConnection(senderId: User.ID, receiverId: User.ID) async throws {
        var request = DeleteUserConnectionRequest()
        request.senderUserId = senderId
        request.receiverUserId = receiverId

        _ = try await request.response()
    }

    // MARK: - Bills methods

    func addBill(userId: User.ID, bill: Bill) async throws {
        let billDTO = BillDTO(
            uid: "",
            client: BillDTO.ClientDTO(
                uid: bill.client.id,
                name: bill.client.name
            ),
            provider: bill.provider.rawValue,
            services: bill.services.map({ service in
                BillDTO.ServiceDTO(
                    title: service.title,
                    price: service.price,
                    currencyCode: service.currencyCode)
            }),
            price: bill.price,
            currencyCode: bill.currencyCode,
            dueDate: bill.dueDate,
            paymentStatus: bill.paymentStatus.rawValue
        )

        let request = AddBillRequest(
            userId: userId,
            billDto: billDTO
        )

        _ = try await request.response()
    }

    func getBills(userId: User.ID) async throws -> [Bill] {
        var request = GetBillsRequest()
        request.userId = userId

        let response = try await request.response()

        return response.bills.map(Bill.init)
    }

    func addSharedBill(viewerIds: [Connection.ID], billId: Bill.ID) async throws {
        var request = UpdateSharedBillRequest()
        request.viewerIds = viewerIds
        request.billId = billId

        _ = try await request.response()
    }

    func getSharedBills(userId: User.ID) async throws -> [Bill] {
        var request = GetSharedBillsRequest()
        request.userId = userId

        let response = try await request.response()

        return response.bills.map(Bill.init)
    }

    func payBill(billId: Bill.ID) async throws {
        var request = PayBillRequest()
        request.id = billId

        _ = try await request.response()
    }
}
