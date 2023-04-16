//
//  ContentView.swift
//  TCASample
//
//  Created by パク on 2023/04/09.
//

import ComposableArchitecture
import SwiftUI


struct ContentView: View {

    var body: some View {


        UserListView(store: .init(initialState: UserListState(),
                                  reducer: userListReducer,
                                  environment: UserListEnvironment(fetchUsers: APIClient.fetchUsers)
                                 ))


      //  NavigationView {
//            TwoCountersView(store: Store(initialState: TwoCountersState(),
//                                         reducer: twoCountersReducer,
//                                         environment: TwoCountersEnvironment()))


      //  }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
