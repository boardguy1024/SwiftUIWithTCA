//
//  UserListView.swift
//  TCASample
//
//  Created by パク on 2023/04/16.
//

import SwiftUI
import ComposableArchitecture

struct UserListView: View {

    let store: Store<UserListState, UserListAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {

                List(viewStore.users) { user in
                    Button(action: {
                        viewStore.send(.selectUser(user))
                    }) {
                        Text(user.name)
                    }
                }
                .navigationTitle("Users")
                .sheet(item: viewStore.binding(get: \.selectedUser, send: .deselectUser)) { selectedUser in
                    UserDefailView(user: selectedUser)
                }
            }
            .onAppear {
                viewStore.send(.fetchUsers)
            }
        }
    }
}

struct UserDefailView: View {

    let user: User
    var body: some View {
        Text("\(user.name)")
    }
}

//struct UserListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserListView()
//    }
//}
