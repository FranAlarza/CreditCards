//
//  Home.swift
//  TryCreditCards
//
//  Created by Francisco Javier Alarza Sanchez on 6/4/23.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @FocusState private var activeTF: ActiveKeyboardField!
    @State private var cardNumber = ""
    @State private var cardHolder = ""
    @State private var expirationDate = ""
    @State private var cvv = ""
    @State private var cardType: CreditCardType = .visa
    
    var body: some View {
        /// Header
        NavigationStack {
            VStack {
                VStack {
                    Text("Chooose your card")
                    Picker("Tarjeta", selection: $cardType) {
                        ForEach(CreditCardType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.vertical, 12)
                HStack {
                    Button {
                        //
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    Text("Add card")
                        .font(.title3)
                        .padding(.leading, 10)
                    Spacer(minLength: 0)
                    Button {
                        //
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title2)
                    }
                }
                
                CardView(type: cardType)
                
                Spacer()
                
                Button {
                    //
                } label: {
                    Label("Add Card", systemImage: "lock")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.black.gradient)
                        }
                }
                .disableWithOpacity(cardNumber.count != 19 || cardHolder.isEmpty || expirationDate.count != 5 || cvv.count != 3)

            }
            .padding()
            .toolbar(.hidden, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    if activeTF != .cardHolder {
                        Button {
                            switch activeTF {
                            case .cardNumber:
                                activeTF = .expirationDate
                            case .cardHolder:
                                break
                            case .expirationDate:
                                activeTF = .cvv
                            case .cvv:
                                activeTF = .cardHolder
                            case .none:
                                break
                            }
                        } label: {
                            Text("Next")
                        }

                    }
                }
            }
        }
    }
    
    /// Card View
    @ViewBuilder
    func CardView(type: CreditCardType) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.linearGradient(colors: type == .visa ? [Color("blue-light"), Color("blue-dark")] : [Color("yellow-light"), Color("red-dark")], startPoint: .topLeading, endPoint: .bottomTrailing))
            
            /// Card Details
            VStack(spacing: 10) {
                HStack {
                    TextField("XXXX-XXXX-XXXX-XXXX", text: .init(get: {
                        cardNumber
                    }, set: { value in
                        cardNumber = ""
                        
                        let startIndex = value.startIndex
                        
                        for index in 0..<value.count {
                            let stringIndex = value.index(startIndex, offsetBy: index)
                            cardNumber += String(value[stringIndex])
                            
                            if (index + 1) % 5 == 0 && value[stringIndex] != " " {
                                cardNumber.insert(" ", at: stringIndex)
                            }
                        }
                        
                        /// Remove space when delete number
                        if value.last == " " {
                            cardNumber.removeLast()
                        }
                        /// Limit max  number
                        cardNumber = String(cardNumber.prefix(19))
                    }))
                        .font(.title3)
                        .keyboardType(.numberPad)
                        .focused($activeTF, equals: .cardNumber)
                    Spacer(minLength: 0)
                    Image(type == .visa ? "logo-visa" : "logo-mastercard")
                        .resizable()
                        .renderingMode(type == .visa ? .template : .none)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
                
                HStack(spacing: 12) {
                    TextField("MM/YY", text: .init(get: {
                        expirationDate
                    }, set: { value in
                        expirationDate = value
                        if value.count == 3 && !value.contains("/") {
                            let startIndex = value.startIndex
                            let thirdPosition = value.index(startIndex, offsetBy: 2)
                            expirationDate.insert("/", at: thirdPosition)
                        }
                        
                        if value.last == "/" {
                            expirationDate.removeLast()
                        }
                        
                        expirationDate = String(expirationDate.prefix(5))
                    }))
                        .keyboardType(.numberPad)
                        .focused($activeTF, equals: .expirationDate)
                    
                    Spacer(minLength: 0)
                    
                    TextField("CVV", text: .init(get: {
                        cvv
                    }, set: { value in
                        cvv = value
                        cvv = String(cvv.prefix(3))
                    }))
                        .frame(width: 35)
                        .keyboardType(.numberPad)
                        .focused($activeTF, equals: .cvv)
                    
                    Image(systemName: "questionmark.circle.fill")
                }
                .padding(.top, 15)
                
                Spacer(minLength: 0)
                
                TextField("CARD NAME HOLDER", text: $cardHolder)
                    .focused($activeTF, equals: .cardHolder)
                    .submitLabel(.done)
                
            }
            .padding(20)
            .environment(\.colorScheme, .dark)
            .tint(.white)
        }
        .frame(height: 200)
        .padding(.top, 35)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/// Disable  with opacity extension

extension View {
    func disableWithOpacity(_ state: Bool) -> some View {
        self
            .disabled(state)
            .opacity(state ? 0.6 : 1)
    }
}
