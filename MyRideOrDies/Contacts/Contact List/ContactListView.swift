//
//  ContentView.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 02/01/2023.
//

import SwiftUI

struct ContactListView: View {
	@State private var isShowingNewContact = false

    var body: some View {
		NavigationStack {
			List {
				ForEach(0...10, id: \.self) { _ in
					ZStack(alignment: .leading) {
						NavigationLink(
							destination: ContactDetailView(),
							label: EmptyView.init
						)
						.opacity(0)
						ContactRowView()
					}
				}
			}
			.navigationTitle("Contacts")
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					Button {
						isShowingNewContact.toggle()
					} label: {
						Image(systemName: "plus")
							.font(.title2)
					}
				}
			}
			.sheet(isPresented: $isShowingNewContact) {
				NavigationStack {
					CreateContactView()
				}
			}
		}

    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
		ContactListView()
    }
}
