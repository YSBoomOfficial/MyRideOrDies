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
				TextField("Name", text: $vm.contact.name)
					.keyboardType(.namePhonePad)

				TextField("Email", text: $vm.contact.email)
					.keyboardType(.emailAddress)

				TextField("Phone Number", text: $vm.contact.phoneNumber)
					.keyboardType(.phonePad)

				DatePicker(
					"Birthday",
					selection: $vm.contact.dob,
					displayedComponents: [.date]
				)
				.datePickerStyle(.compact)
			}

			Section("Notes") {
				TextField("", text: $vm.contact.notes, axis: .vertical )
			}
		}
		.navigationTitle(vm.isNew ? "New Contact" : "Update Contact")
		.toolbar {
			ToolbarItem(placement: .confirmationAction) {
				Button("Done") {
					do {
						try vm.save()
						dismiss()
					} catch {
						self.error = error
					}
				}
				.disabled(!vm.contact.isValid)
			}

			ToolbarItem(placement: .navigationBarLeading) {
				Button("Cancel", action: dismiss.callAsFunction)
			}
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
