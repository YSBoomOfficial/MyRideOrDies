//
//  ContactRowView.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 02/01/2023.
//

import SwiftUI

struct ContactRowView: View {
	@Environment(\.managedObjectContext) var moc
	@ObservedObject var contact: Contact

	@State private var error: Error? = nil
	private var hasError: Binding<Bool> {
		.init(get: { error != nil }, set: { _ in error = nil })
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text(contact.formattedName)
				.font(.system(size: 26, design: .rounded).bold())

			Text(contact.email)
				.font(.callout.bold())

			Text(contact.phoneNumber)
				.font(.callout.bold())
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.overlay(alignment: .topTrailing) {
			Button {
				toggleFavorite()
			} label: {
				Image(systemName: "star")
					.font(.title3)
					.symbolVariant(.fill)
					.foregroundColor(contact.isFavorite ? .yellow : .gray.opacity(0.3))
			}.buttonStyle(.plain)
		}
		.alert( "Oops! Something went wrong.", isPresented: hasError) {
			Button("Ok") {}
		} message: {
			Text(error?.localizedDescription ?? "Lets try that again!")
		}
	}
}


fileprivate extension ContactRowView {
	func toggleFavorite() {
		contact.isFavorite.toggle()
		do {
			if moc.hasChanges { try moc.save() }
		} catch {
			self.error = error
		}
	}
}


struct ContactRowView_Previews: PreviewProvider {
	static var previews: some View {
		ContactRowView(contact: Contact.preview())
			.padding()
			.previewLayout(.sizeThatFits)
	}
}
