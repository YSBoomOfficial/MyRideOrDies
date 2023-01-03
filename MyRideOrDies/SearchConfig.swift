//
//  SearchConfig.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 03/01/2023.
//

import Foundation

struct SearchConfig: Equatable {
	enum Filter {
		case all, favs
	}
	var filter: Filter = .all
	var query = ""
}
