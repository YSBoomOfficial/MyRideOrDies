//
//  ContentView.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 02/01/2023.
//

import SwiftUI
import CoreData

struct ContactListView: View {
	private let provider = ContactsProvider.shared
	@FetchRequest(fetchRequest: Contact.all()) private var contacts
	@State private var contactToEdit: Contact? = nil

	@State private var error: Error? = nil
	private var hasError: Binding<Bool> {
		.init(get: { error != nil }, set: { _ in error = nil })
	}

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
								
								ContactRowView(provider: .shared, contact: contact, error: $error)
									.swipeActions(allowsFullSwipe: true) {
										Button(role: .destructive) {
											provider.delete(contact, in: provider.newContext)
										} label: {
											Label("Delete", systemImage: "trash")
										}.tint(.red)

										Button {
											contactToEdit = contact
										} label: {
											Label("Edit", systemImage: "pencil")
										}
										.tint(.orange)
									}
							}
						}
					}
				}
			}
			.navigationTitle("Contacts")
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					Button {
						contactToEdit = .empty(context: provider.newContext)
					} label: {
						Image(systemName: "plus")
							.font(.title2)
					}
				}
			}
			.sheet(item: $contactToEdit) {
				contactToEdit = nil
			} content: { contact in
				NavigationStack {
					CreateContactView(vm: .init(provider: provider, contact: contactToEdit), error: $error)
				}
				.interactiveDismissDisabled()
			}
			.alert( "Oops! Something went wrong.", isPresented: hasError) {
				Button("Ok") {}
			} message: {
				Text(error?.localizedDescription ?? "Lets try that again!")
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
