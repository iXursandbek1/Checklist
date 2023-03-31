//
//  AddItemViewController.swift
//  Checklist
//
//  Created by Xursandbek Qambaraliyev on 25/03/23.
//

import UIKit

protocol ItemDetailViewControllerDelegate: AnyObject {
    
  func itemDetailViewControllerDidCancel(
    _ controller: ItemDetailViewController)
    
  func itemDetailViewController(
    _ controller: ItemDetailViewController,
    didFinishAdding item: ChecklistItem
  )
    
    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishEditing item: ChecklistItem
      )
}

class ItemDetailViewController: UITableViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
         }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }

    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    @IBAction func done() {
        
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item)
            
          } else {
            let item = ChecklistItem()
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
}

extension ItemDetailViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
          let stringRange = Range(range, in: oldText)!
          let newText = oldText.replacingCharacters(
            in: stringRange,
            with: string)
          if newText.isEmpty {
            doneBarButton.isEnabled = false
          } else {
            doneBarButton.isEnabled = true
          }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
