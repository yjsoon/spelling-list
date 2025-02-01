import SwiftUI

struct SortOptionButton<T: Equatable>: View {
    let label: String
    let sort: T
    @Binding var selectedSort: T
    @Binding var isAscending: Bool

    var body: some View {
        Button {
            if selectedSort == sort {
                isAscending.toggle()
            } else {
                selectedSort = sort
                isAscending = true
            }
        } label: {
            HStack {
                Text(label)
                Spacer()
                if selectedSort == sort {
                    Image(systemName: isAscending ? "chevron.down" : "chevron.up")
                }
            }
        }
    }
}