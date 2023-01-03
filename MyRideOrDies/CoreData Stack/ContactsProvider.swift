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
