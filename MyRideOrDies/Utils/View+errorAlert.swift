//
//  View+errorAlert.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 03/01/2023.
//

import SwiftUI

extension View {
	func errorAlert(isPresented: Binding<Bool>, for error: Error?) -> some View {
		self.alert(
			"Oops! Something went wrong.",
			isPresented: isPresented,
			actions: {},
			message: { Text(error?.localizedDescription ?? "Lets try that again!") }
		)
	}
}
