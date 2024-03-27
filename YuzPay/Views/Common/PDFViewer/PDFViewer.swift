//
//  PDFViewer.swift
//  YuzPay
//
//  Created by applebro on 10/03/24.
//

import Foundation
import SwiftUI
import PDFKit

struct PDFViewer: View {
    @State private var pdfDocument: PDFDocument?
    
    let pdfURL: URL
    
    var body: some View {
        VStack {
            if let pdfDocument = pdfDocument {
                PDFKitView(pdfDocument: pdfDocument)
            } else {
                Text("Loading PDF...")
            }
        }
        .onAppear {
            loadPDF()
            debugPrint("Loading \(pdfURL)")
        }
        .navigationBarTitle("PDF Viewer")
    }
    
    func loadPDF() {
        URLSession.shared.dataTask(with: .new(url: pdfURL)) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to load PDF:", error?.localizedDescription ?? "Unknown error")
                return
            }
            
            if let pdfDocument = PDFDocument(data: data) {
                DispatchQueue.main.async {
                    self.pdfDocument = pdfDocument
                }
            } else {
                print("Invalid PDF data")
            }
        }.resume()
    }
}

struct PDFKitView: UIViewRepresentable {
    let pdfDocument: PDFDocument
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        // Update the view
    }
}
