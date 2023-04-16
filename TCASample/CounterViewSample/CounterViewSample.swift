//
//  CounterView.swift
//  TCASample
//
//  Created by パク on 2023/04/15.
//

import ComposableArchitecture
import SwiftUI

private let readMe = """
  This screen demonstrates the basics of the Composable Architecture in an archetypal counter \
  application.

  The domain of the application is modeled using simple data types that correspond to the mutable \
  state of the application and any actions that can affect that state or the outside world.
  """

struct CounterState: Equatable {
    var count: Int = 0
}

enum CounterAction: Equatable {
    case decrementButtonTapped
    case incrementButtonTapped
}

struct TwoCountersState: Equatable {
    var counter1 = CounterState()
    var counter2 = CounterState()
}

enum TwoCountersAction {
    case counter1(CounterAction)
    case counter2(CounterAction)
}

struct CounterEnvironment { }

struct TwoCountersEnvironment { }

let counterReducaer = AnyReducer<CounterState, CounterAction, CounterEnvironment> { state, action, _ in
    switch action {
    case .decrementButtonTapped:
        state.count -= 1
        return .none
    case .incrementButtonTapped:
        state.count += 1
        return .none
    }
}


let twoCountersReducer = AnyReducer<TwoCountersState, TwoCountersAction, TwoCountersEnvironment>
    .combine(
        counterReducaer.pullback(state: \TwoCountersState.counter1,
                                      action: /TwoCountersAction.counter1, environment: { _ in CounterEnvironment() }),

        counterReducaer.pullback(state: \TwoCountersState.counter2,
                                      action: /TwoCountersAction.counter2, environment: { _ in CounterEnvironment() })
    )


struct CounterView: View {
    let store: Store<CounterState, CounterAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                Button("-") { viewStore.send(.decrementButtonTapped) }
                Text("\(viewStore.count)")
                Button("+") { viewStore.send(.incrementButtonTapped) }
            }
        }
    }
}


struct TwoCountersView: View {
    let store: Store<TwoCountersState, TwoCountersAction>

    var body: some View {
        Form {
            Section(header: Text(readMe)) {

                HStack {
                    Text("Counter 1")
                    CounterView(store: self.store.scope(state: { $0.counter1 }, action: TwoCountersAction.counter1))
                        .buttonStyle(BorderedButtonStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                HStack {
                    Text("Counter 2")
                    CounterView(store: self.store.scope(state: { $0.counter2 }, action: TwoCountersAction.counter2))
                        .buttonStyle(BorderedButtonStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationTitle("Two Counter Demo")
    }

}

//
//struct CounterView_Previews: PreviewProvider {
//    static var previews: some View {
//        CounterView()
//    }
//}
