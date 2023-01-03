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
	var query = ""
	var filter: Filter = .all
}

enum Sort {
	case ascending, descending
}
