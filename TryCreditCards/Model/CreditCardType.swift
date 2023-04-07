//
//  CreditCardType.swift
//  TryCreditCards
//
//  Created by Francisco Javier Alarza Sanchez on 7/4/23.
//

import Foundation

enum CreditCardType: String, CaseIterable, Identifiable {
    case masterCard = "Master Card"
    case visa = "VISA"
    
    var id: String { self.rawValue }
}
