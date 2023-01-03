//
//  ContentView.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 02/01/2023.
//

import SwiftUI
import CoreData

struct ContactListView: View {
	@FetchRequest(fetchRequest: Contact.all()) private var contacts
	@ObservedObject var editContactViewModel = EditContactViewModel(provider: .shared)
	
	@State private var isShowingNewContact = false

	var body: some View {
		NavigationStack {
			ZStack {
				if contacts.isEmpty {
					NoContactsView()
				} else {
					List {
						ForEach(contacts) { contact in
							ZStack(alignment: .leading) {
								NavigationLink(
									destination: ContactDetailView(contact: contact),
									label: EmptyView.init
								)
								.opacity(0)
								ContactRowView(contact: contact)
							}
						}
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
					CreateContactView(vm: editContactViewModel)
				}
			}
		}
	}
}

struct ContactListView_Previews: PreviewProvider {
	static var previews: some View {
		ContactListView()
			.environment(\.managedObjectContext, ContactsProvider.shared.viewContext)
			.previewDisplayName("Contacts with data")
			.onAppear {
				Contact.makePreview(count: 10, in: ContactsProvider.shared.viewContext)
			}
	}
}

struct ContactListView_EmptyPreviews: PreviewProvider {
	static var previews: some View {
		ContactListView()
			.environment(\.managedObjectContext, ContactsProvider.shared.viewContext)
			.previewDisplayName("Contacts with no data")
	}
}
