//
//  SortInputSheet.swift
//  CS IA
//
//  Created by Muhammad Riyan on 24/01/2021.
//  Copyright © 2021 Muhammad Riyan. All rights reserved.
//

import SwiftUI

struct SortInputSheet: View {
    @Environment(\.presentationMode) var presentationMode
    let sortInputs = ["All","Priority", "To Submit", "Submitted", "Rejected","Accepted"]
    @ObservedObject var input: Input
    
    var body: some View {
        List (0 ..< 6) { I in
                    Button( action: {
                        self.input.sortInput = I
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("\(self.sortInputs[I])")
                    }
            
        }
    }
}

struct SortInputSheet_Previews: PreviewProvider {
    static var previews: some View {
        SortInputSheet(input: Input())
    }
}
