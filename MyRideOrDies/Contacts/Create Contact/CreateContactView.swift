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

	@State private var error: Error? = nil

	private var hasError: Binding<Bool> {
		.init(get: { error != nil }, set: { _ in error = nil })
	}

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
		.navigationTitle("Name Here")
		.alert( "Oops! Something went wrong.", isPresented: hasError) {
			Button("Ok") {}
		} message: {
			Text(error?.localizedDescription ?? "Lets try that again!")
		}
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
				.disabled(vm.contact.name.isEmpty)
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
			CreateContactView(vm: .init(provider: ContactsProvider.shared))
				.environment(\.managedObjectContext, ContactsProvider.shared.viewContext)
		}
	}
}
