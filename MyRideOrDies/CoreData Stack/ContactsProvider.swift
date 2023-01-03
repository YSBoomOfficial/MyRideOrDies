//
//  ContactsProvider.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 02/01/2023.
//

import Foundation
import CoreData
import SwiftUI

final class ContactsProvider {
	static let shared = ContactsProvider()

	private let persistentContainer: NSPersistentContainer

	var viewContext: NSManagedObjectContext { persistentContainer.viewContext }

	var newContext: NSManagedObjectContext {
		persistentContainer.newBackgroundContext()
	}

	private init() {
		persistentContainer = .init(name: "ContactsDataModel")
		persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
		if EnvironmentValues.isPreview || Thread.current.isRunningXCTest {
			persistentContainer.persistentStoreDescriptions.first!.url = .init(fileURLWithPath: "/dev/null")
		}
		persistentContainer.loadPersistentStores { _, error in
			if let error { fatalError("Unable to load 'ContactsDataModel' Persistent Store. \(error.localizedDescription)") }
		}
	}
}

extension ContactsProvider {
	func exists(_ contact: Contact, in context: NSManagedObjectContext) -> Contact? {
		try? context.existingObject(with: contact.objectID) as? Contact
	}

	func delete(_ contact: Contact, in context: NSManagedObjectContext) {
		if let existingContact = exists(contact, in: context) {
			context.delete(existingContact)
			Task(priority: .background) {
				try await context.perform { try context.save() }
			}
		}
	}

	func persist(in context: NSManagedObjectContext) throws {
		if context.hasChanges { try context.save() }
	}

}
