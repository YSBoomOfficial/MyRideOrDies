//
//  ContactDetailView.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 02/01/2023.
//

import SwiftUI

struct ContactDetailView: View {
	let contact: Contact

	var body: some View {
		List {
			Section("General") {
				emailLabel
				phoneNumberLabel
				dobLabel
			}

			Section("Notes") { Text(contact.notes) }
		}
		.navigationTitle(contact.formattedName)
	}
}

// MARK: General Section
fileprivate extension ContactDetailView {
	var emailLabel: some View {
		LabeledContent {
			Text(contact.email)
		} label: {
			Text("Email")
		}
	}

	var phoneNumberLabel: some View {
		LabeledContent {
			Text(contact.phoneNumber)
		} label: {
			Text("Phone Number")
		}
	}

	var dobLabel: some View {
		LabeledContent {
			Text(contact.dob, style: .date)
		} label: {
			Text("Birthday")
		}
	}
}

struct ContactDetailView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			ContactDetailView(contact: Contact.preview())
		}
	}
}
