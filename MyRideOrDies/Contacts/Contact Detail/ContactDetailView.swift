//
//  ContactDetailView.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 02/01/2023.
//

import SwiftUI

struct ContactDetailView: View {
	var body: some View {
		List {
			Section("General") {
				LabeledContent {
					Text("Email Here")
				} label: {
					Text("Email")
				}

				LabeledContent {
					Text("Phone Number Here")
				} label: {
					Text("Phone Number")
				}

				LabeledContent {
					Text(.now, style: .date)
				} label: {
					Text("Birthday")
				}
			}

			Section("Notes") {
				Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
			}
		}
		.navigationTitle("Name Here")
	}
}

struct ContactDetailView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			ContactDetailView()
		}
	}
}
