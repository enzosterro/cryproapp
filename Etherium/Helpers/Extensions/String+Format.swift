//
//  String+Format.swift
//  Etherium
//
//  Created by Enzo Sterro on 02/10/2017.
//  Copyright © 2017 Enzo Sterro. All rights reserved.
//

import Foundation

extension String {
	var formattedString: String {
		return (self.components(separatedBy: ".").first ?? self) + " $" 
	}
}
