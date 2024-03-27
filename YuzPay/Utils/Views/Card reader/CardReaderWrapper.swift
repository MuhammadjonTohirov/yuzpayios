//
//  CardReaderWerapper.swift
//  YuzPay
//
//  Created by applebro on 27/12/22.
//

import SwiftUI

struct CardReaderWrapper: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    
    var onSuccess: ((_ number: String, _ date: String) -> Void)?
    
    func makeUIViewController(context: Context) -> CardReaderViewController {
        let vc = CardReaderViewController()
        
        vc.onSuccess = { number, date in
            onSuccess?(number, date)
            dismiss()
        }
        
        vc.onDismiss = {
            dismiss()
        }
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: CardReaderViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = CardReaderViewController
}

struct CardReaderWerapper_Previews: PreviewProvider {
    static var previews: some View {
        CardReaderWrapper()
            .ignoresSafeArea()
    }
}
