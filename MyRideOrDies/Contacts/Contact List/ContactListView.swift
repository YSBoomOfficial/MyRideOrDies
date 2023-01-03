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

	@State private var searchConfig = SearchConfig()
	@State private var sort = Sort.ascending

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
					contactList
				}
			}
			.navigationTitle("Contacts")
			.toolbar {
				addContactButton
				if !contacts.isEmpty {
					filterMenu
				}
			}
			.errorAlert(isPresented: hasError, for: error)
			.sheet(
				item: $contactToEdit,
				onDismiss: { contactToEdit = nil },
				content: sheetContent(for:)
			)
			.searchable(text: $searchConfig.query)
			.onChange(of: searchConfig) {
				contacts.nsPredicate = Contact.filter(with: $0)
			}
			.onChange(of: sort) {
				contacts.nsSortDescriptors = Contact.sort(order: $0)
			}
		}
	}
}

// MARK: Contact List
fileprivate extension ContactListView {
	func deleteButton(for contact: Contact) -> some View {
		Button(role: .destructive) {
			provider.delete(contact, in: provider.newContext)
		} label: {
			Label("Delete", systemImage: "trash")
		}.tint(.red)
	}

	func editButton(for contact: Contact) -> some View {
		Button {
			contactToEdit = contact
		} label: {
			Label("Edit", systemImage: "pencil")
		}.tint(.orange)
	}

	func listRowWithSwipeActions(for contact: Contact) -> some View {
		ContactRowView(provider: .shared, contact: contact, error: $error)
			.swipeActions(allowsFullSwipe: true) {
				deleteButton(for: contact)
				editButton(for: contact)
			}
	}

	var contactList: some View {
		List {
			ForEach(contacts) { contact in
				ZStack(alignment: .leading) {
					NavigationLink(
						destination: ContactDetailView(contact: contact),
						label: EmptyView.init
					).opacity(0)
					listRowWithSwipeActions(for: contact)
				}
			}
		}
	}
}

// MARK: Toolbar Items
fileprivate extension ContactListView {
	var addContactButton: some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			Button {
				contactToEdit = .empty(context: provider.newContext)
			} label: {
				Image(systemName: "plus")
					.font(.title2)
			}
		}
	}

	var filterMenuFilterSection: some View {
		Section("Filter") {
			Picker(selection: $searchConfig.filter) {
				Text("All").tag(SearchConfig.Filter.all)
				Label("Favorites", systemImage: "star.fill")
					.tag(SearchConfig.Filter.favs)
			} label: {
				Text("Filter Favorites")
			}
		}
	}

	var filterMenuSortSection: some View {
		Section("Sort") {
			Picker(selection: $sort) {
				Label("Ascending", systemImage: "arrow.up")
					.tag(Sort.ascending)
				Label("Descending", systemImage: "arrow.down")
					.tag(Sort.descending)
			} label: {
				Text("Sort Order")
			}
		}
	}

	var filterMenu: some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			Menu {
				filterMenuFilterSection
				filterMenuSortSection
			} label: {
				Image(systemName: "line.3.horizontal.decrease.circle")
					.symbolVariant(.circle)
					.font(.title2)
			}
		}
	}

	func sheetContent(for contact: Contact) -> some View {
		NavigationStack {
			CreateContactView(
				vm: .init(provider: provider, contact: contact),
				error: $error
			)
		}.interactiveDismissDisabled()
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
