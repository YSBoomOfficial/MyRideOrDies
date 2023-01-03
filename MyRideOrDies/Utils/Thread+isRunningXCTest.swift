//
//  Thread+isRunningXCTest.swift
//  MyRideOrDies
//
//  Created by Yash Shah on 03/01/2023.
//

import Foundation

extension Thread {
	var isRunningXCTest: Bool {
		for key in self.threadDictionary.allKeys {
			guard let keyAsString = key as? String else { continue }
			if keyAsString.split(separator: ".").contains("xctest") { return true }
		}
		return false
	}
}
