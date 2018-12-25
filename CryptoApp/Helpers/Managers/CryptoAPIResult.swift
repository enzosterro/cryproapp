//
//  CryptoAPIResult.swift
//  CryptoApp
//
//  Created by Enzo Sterro on 25/05/2018.
//  Copyright © 2018 Enzo Sterro. All rights reserved.
//


enum CryptoAPIResult<T> {

    case success(T)
    case error(Error)
    case customError(String)

}
