//
//  MyRideOrDiesApp.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 02/01/2023.
//

import SwiftUI

@main
struct MyRideOrDiesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(\.managedObjectContext, ContactsProvider.shared.viewContext)
        }
    }
}
