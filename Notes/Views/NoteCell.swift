//
//  NoteCell.swift
//  Notes
//
//  Created by Mohit Gupta on 24/03/21.
//

import UIKit

class NoteCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var notes: UILabel!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var lockImage: UIImageView!
    
    /// Method will present the data in cell
    /// - Parameter note : Data of note
    func configureCell(note: Note ) {
        self.title.text = note.title
        self.notes.text = note.noteData
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYYY HH:MM"
        
        self.date.text = dateFormatter.string(from: note.date ?? Date())
        if note.password {
            self.lockImage.isHidden = false
        }
        else{
            self.lockImage.isHidden = true
        }
        
    }

}
