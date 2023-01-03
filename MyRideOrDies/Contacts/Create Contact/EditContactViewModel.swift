//
//  EditContactViewModel.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 03/01/2023.
//

import CoreData

final class EditContactViewModel: ObservableObject {
	@Published var contact: Contact
	private let context: NSManagedObjectContext

	init(provider: ContactsProvider, contact: Contact? = nil) {
		self.context = provider.newContext
		self.contact = contact ?? Contact(context: context)
	}

	func save() throws {
		if context.hasChanges { try context.save() }
	}
}
