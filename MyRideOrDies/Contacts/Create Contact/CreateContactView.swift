//
//  CreateContactView.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 02/01/2023.
//

import SwiftUI

struct CreateContactView: View {
	@Environment(\.dismiss) var dismiss

	var body: some View {
		List {
			Section("General") {
				TextField("Name", text: .constant(""))
					.keyboardType(.namePhonePad)

				TextField("Email", text: .constant(""))
					.keyboardType(.emailAddress)

				TextField("Phone Number", text: .constant(""))
					.keyboardType(.phonePad)

				DatePicker(
					"Birthday",
					selection: .constant(.now),
					displayedComponents: [.date]
				)
				.datePickerStyle(.compact)
			}

			Section("Notes") {
				TextField(
					"",
					text: .constant("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."),
					axis: .vertical
				)
			}
		}
		.navigationTitle("Name Here")
		.toolbar {
			ToolbarItem(placement: .confirmationAction) {
				Button("Done") {
					dismiss()
				}
				.disabled(true)
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
			CreateContactView()
		}
	}
}
