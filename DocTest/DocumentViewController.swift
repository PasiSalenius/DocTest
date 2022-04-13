//
//  DocumentViewController.swift
//  DocTest
//
//  Created by Pasi Salenius on 12.4.2022.
//

import UIKit

class DocumentViewController: UIViewController, UITextViewDelegate {
    
    private let textView = UITextView()
    
    var document: Document
    
    init(document: Document) {
        self.document = document

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Document"
        
        let closeItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction() { [unowned self] action in
            self.dismissDocumentViewController()
        })
        
        navigationItem.rightBarButtonItem = closeItem

        textView.delegate = self
        
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .systemBackground
        
        view.addConstraints([
            textView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
        
        textView.text = document.text
    }
    
    private func dismissDocumentViewController() {
        dismiss(animated: true) {
            self.document.close(completionHandler: nil)
        }
    }
    
    // MARK: - Text view delegate
    
    func textViewDidChange(_ textView: UITextView) {
        document.text = textView.text
        document.updateChangeCount(.done)
    }
    
}
