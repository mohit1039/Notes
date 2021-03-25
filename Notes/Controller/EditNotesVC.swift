//
//  EditNotesVC.swift
//  Notes
//
//  Created by Mohit Gupta on 24/03/21.
//

import UIKit

class EditNotesVC: UIViewController , UITextViewDelegate{

    @IBOutlet weak var passwordSlider: UISwitch!
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    var noteTitle: String!
    var notes: String!
    var date: Date!
    var password : Bool = false
    var cellTap : Bool = false
    var note : Note!
    override func viewDidLoad() {
        super.viewDidLoad()
        notesTextView.delegate = self
        
        if cellTap {
            titleLabel.text = self.noteTitle
            notesTextView.text = self.notes
            if self.password {
                passwordSlider.setOn(true, animated: false)
            }
            else{
                passwordSlider.setOn(false, animated: false)
            }
        }
    }
    

    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTextView.text == "Write your notes here" {
            notesTextView.text = ""
        }
    }
    
    @IBAction func sliderChanged(_ sender: UISwitch) {
        if sender.isOn{
            self.password = true
        }
        else{
            self.password = false
        }
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        if titleLabel.text != "" && notesTextView.text != "" && notesTextView.text != "Write your notes here"{
            if self.cellTap {
                self.update { (complete) in
                    if complete{
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
            else {
                self.save { (complete) in
                    if complete{
                        navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        else{
            commonAlert(message: "Please fill the details", title: "Insufficient Details")
        }
    }
    
    func update(completion : (_ complete : Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        note.title = titleLabel.text
        note.noteData = notesTextView.text
        if cellTap {
            note.date = self.date
        }
        else{
            note.date = Date()
        }
        note.password = self.password
        
        
        do{
            
            try managedContext.save()
            commonAlert(message: "Note saved", title: "Saved")
            completion(true)
        }catch{
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    func initData(note : Note , cellTap : Bool) {
        self.note = note
        self.noteTitle = note.title
        self.notes = note.noteData
        self.password = note.password
        self.date = note.date
        self.cellTap = cellTap
    }
    
    
    func save(completion: (_ complete : Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let note = Note(context: managedContext)
        note.title = titleLabel.text
        note.noteData = notesTextView.text
        if cellTap {
            note.date = self.date
        }
        else{
            note.date = Date()
        }
        note.password = self.password
        
        
        do{
            
            try managedContext.save()
            print("SaveData")
            completion(true)
        }catch{
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    
    func commonAlert(message : String, title : String) {
        let alertController = UIAlertController(title: title, message:
               message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
           self.present(alertController, animated: true, completion: nil)
    }

}
