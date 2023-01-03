//
//  EditContactViewModel.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 03/01/2023.
//

import CoreData

final class EditContactViewModel: ObservableObject {
	private let provider: ContactsProvider
	private let context: NSManagedObjectContext
	let isNew: Bool
	@Published var contact: Contact

	init(provider: ContactsProvider, contact: Contact? = nil) {
		self.provider = provider
		self.context = provider.newContext
		if let contact, let existingContact = provider.exists(contact, in: context) {
			self.contact = existingContact
			self.isNew = false
		} else {
			self.contact = Contact(context: self.context)
			self.isNew = true
		}
	}

	func save() throws {
		try provider.persist(in: context)
	}
}
