//
//  ContactRowView.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 02/01/2023.
//

import SwiftUI

struct ContactRowView: View {
	@Environment(\.managedObjectContext) var moc
	let provider: ContactsProvider
	@ObservedObject var contact: Contact
	@Binding var error: Error?

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			rowContent
		}
		.frame(maxWidth: .infinity, alignment: .leading)
		.overlay(alignment: .topTrailing) {
			toggleFavoriteButton
		}
	}
}


fileprivate extension ContactRowView {
	@ViewBuilder
	var rowContent: some View {
		Text(contact.formattedName)
			.font(.system(size: 26, design: .rounded).bold())

		Text(contact.email)
			.font(.callout.bold())

		Text(contact.phoneNumber)
			.font(.callout.bold())
	}

	var toggleFavoriteButton: some View {
		Button {
			contact.isFavorite.toggle()
			do {
				try provider.persist(in: moc)
			} catch {
				self.error = error
			}
		} label: {
			Image(systemName: "star")
				.font(.title3)
				.symbolVariant(.fill)
				.foregroundColor(contact.isFavorite ? .yellow : .gray.opacity(0.3))
		}
		.buttonStyle(.plain)
	}
}


struct ContactRowView_Previews: PreviewProvider {
	static var previews: some View {
		ContactRowView(provider: .shared, contact: .preview(), error: .constant(nil))
			.padding()
			.previewLayout(.sizeThatFits)
	}
}
