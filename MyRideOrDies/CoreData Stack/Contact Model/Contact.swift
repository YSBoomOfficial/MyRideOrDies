//
//  Contact.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 02/01/2023.
//

import Foundation
import CoreData

final class Contact: NSManagedObject, Identifiable {
	@NSManaged var dob: Date
	@NSManaged var name: String
	@NSManaged var notes: String
	@NSManaged var phoneNumber: String
	@NSManaged var email: String
	@NSManaged var isFavorite: Bool

	var isBirthday: Bool {
		Calendar.current.isDateInToday(dob)
	}

	var formattedName: String {
		"\(isBirthday ? "🎈" : "") \(name)"
	}

	var isValid: Bool {
		!name.isEmpty && !email.isEmpty && !phoneNumber.isEmpty
	}
	
	override func awakeFromInsert() {
		super.awakeFromInsert()
		setPrimitiveValue(Date.now, forKey: "dob")
		setPrimitiveValue(false, forKey: "isFavorite")
	}
}

// MARK: Fetch Requests, Search and Sort
extension Contact {
	private static var contactsFetchRequest: NSFetchRequest<Contact> {
		.init(entityName: "Contact")
	}

	static func all() -> NSFetchRequest<Contact> {
		let request = contactsFetchRequest
		request.sortDescriptors = [.init(keyPath: \Contact.name, ascending: true)]
		return request
	}

	static func filter(with config: SearchConfig) -> NSPredicate {
		switch config.filter {
			case .all:
				return config.query.isEmpty ? .init(value: true) : .init(format: "name CONTAINS[cd] %@", config.query)
			case .favs:
				return config.query.isEmpty ? .init(format: "isFavorite == %@", NSNumber(value: true)) : .init(format: "name CONTAINS[cd] %@ AND isFavorite == %@", config.query, NSNumber(value: true))
		}
	}

	static func sort(order: Sort) -> [NSSortDescriptor] {
		[.init(keyPath: \Contact.name, ascending: order == .ascending)]
	}
}

// MARK: CRUD Operations
extension Contact {
	@discardableResult
	static func makePreview(count: Int, in context: NSManagedObjectContext) -> [Contact] {
		guard count > 0 else { return [] }

		var contacts = [Contact]()
		for i in 0..<count {
			let contact = Contact(context: context)
			contact.name = "User \(i)"
			contact.email = "user_\(i)@email.com"
			contact.phoneNumber = "0700000000\(i)"
			contact.notes = "User \(i) notes"
			contact.dob = Calendar.current.date(byAdding: .day, value: -i, to: .now) ?? .now
			contacts.append(contact)
		}
		contacts.first!.isFavorite = true
		return contacts
	}

	static func preview(context: NSManagedObjectContext = ContactsProvider.shared.viewContext) -> Contact {
		makePreview(count: 1, in: context).first!
	}

	static func empty(context: NSManagedObjectContext = ContactsProvider.shared.viewContext) -> Contact {
		Contact(context: context)
	}
}
