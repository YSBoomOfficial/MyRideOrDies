//
//  NoContactsView.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 03/01/2023.
//

import SwiftUI

struct NoContactsView: View {
	var body: some View {
		VStack {
			Text("Looks like you don't have any saved contacts")
			Text("press the \(Image(systemName: "plus")) icon to create some")
		}.font(.subheadline)
	}
}

struct NoContactsView_Previews: PreviewProvider {
	static var previews: some View {
		NoContactsView()
	}
}
