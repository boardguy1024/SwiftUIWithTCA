//
//  UserListState.swift
//  TCASample
//
//  Created by パク on 2023/04/16.
//

import ComposableArchitecture

struct UserListState: Equatable {
    var users: [User] = []
    var selectedUser: User?
}

enum UserListAction: Equatable {
    case fetchUsers
    // Result型は Equatableを準拠していないため、そのまま使えないため、「.success」、「.failure」でcaseを分ける
    //case userFetched(Result<[String], Error>)
    case userFatched([User])
    case userFatchingFailed(String)

    case selectUser(User)
    case deselectUser
}

struct UserListEnvironment {
    var fetchUsers: () -> EffectPublisher<[User], Error>
}

let userListReducer = AnyReducer<UserListState, UserListAction, UserListEnvironment> { state, action, environment in
    switch action {
    case .fetchUsers:
        return environment.fetchUsers()
            .map(UserListAction.userFatched)
            .catch { error in
                return EffectPublisher(value: UserListAction.userFatchingFailed(error.localizedDescription))
            }
            .eraseToEffect()

    case .userFatchingFailed(let error):
        return .none
    case .userFatched(let users):
        state.users = users
        return .none

    case .selectUser(let user):
        state.selectedUser = user
        return .none

    case .deselectUser:
        state.selectedUser = nil
        return .none
    }
}


