//
//  CreateContactView.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 02/01/2023.
//

import SwiftUI

struct CreateContactView: View {
	@Environment(\.dismiss) var dismiss
	@ObservedObject var vm: EditContactViewModel
	@Binding var error: Error?

	var body: some View {
		List {
			Section("General") {
				nameTextField
				emailTextField
				phoneNumberTextField
				birthdayPicker
			}

			Section("Notes") {
				notesTextField
			}
		}
		.navigationTitle(navTitle)
		.toolbar {
			doneButton
			cancelButton
		}
	}
}

// MARK: General and Notes Section
fileprivate extension CreateContactView {
	var navTitle: String {
		vm.isNew ? "New Contact" : "Update Contact"
	}

	var nameTextField: some View {
		TextField("Name", text: $vm.contact.name)
			.keyboardType(.namePhonePad)
	}

	var emailTextField: some View {
		TextField("Email", text: $vm.contact.email)
			.keyboardType(.emailAddress)
	}

	var phoneNumberTextField: some View {
		TextField("Phone Number", text: $vm.contact.phoneNumber)
			.keyboardType(.phonePad)
	}

	var birthdayPicker: some View {
		DatePicker(
			"Birthday",
			selection: $vm.contact.dob,
			displayedComponents: [.date]
		)
		.datePickerStyle(.compact)
	}

	var notesTextField: some View {
		TextField("", text: $vm.contact.notes, axis: .vertical )
	}
}

// MARK: Toolbar Items
fileprivate extension CreateContactView {
	var doneButton: some ToolbarContent {
		ToolbarItem(placement: .confirmationAction) {
			Button("Done") {
				do {
					try vm.save()
					dismiss()
				} catch {
					self.error = error
				}
			}.disabled(!vm.contact.isValid)
		}
	}

	var cancelButton: some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			Button("Cancel", action: dismiss.callAsFunction)
		}
	}
}

struct CreateContactView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			CreateContactView(vm: .init(provider: ContactsProvider.shared), error: .constant(nil))
				.environment(\.managedObjectContext, ContactsProvider.shared.viewContext)
		}
	}
}
