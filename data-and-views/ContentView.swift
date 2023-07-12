import SwiftUI

public class MyModel: ObservableObject {
  @Published public var slots: [String] = []
  public func append(_ slot: String) {
    slots.append(slot)
  }
}

public class Reservation: ObservableObject {
  @Published public var item: String = ""
}

struct ContentView: View {
  @State private var nextSlot = 0
  @State private var selection = 0
  @StateObject private var model = MyModel()
  
  var body: some View {
    VStack {
      Button("Add") {
        model.append("Slot \(nextSlot)")
        nextSlot += 1
      }
      ForEach(Array(model.slots.enumerated()), id:\.offset) { index, slot in
        Text(slot)
          .bold(index == selection)
      }
      ChildView(model: model, selection: $selection)
    }
    .padding()
  }
}

struct ChildView: View {
  @ObservedObject var model: MyModel
  @Binding var selection: Int
  
  var body: some View {
    GrandchildView(model: model, selection: $selection)
  }
}

struct GrandchildView: View {
  @ObservedObject var model: MyModel
  @Binding var selection: Int

  var body: some View {
    HStack {
      Button(action: {
        selection = max(0, selection - 1)
      }) {
        Image(systemName: "arrowtriangle.up.fill")
      }
      Button(action: {
        selection = min(selection + 1,  model.slots.count - 1)
      }) {
        Image(systemName: "arrowtriangle.down.fill")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
