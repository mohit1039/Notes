//
//  ViewController.swift
//  Notes
//
//  Created by Mohit Gupta on 24/03/21.
//

import UIKit
import CoreData
import SwiftKeychainWrapper

let appDelegate = UIApplication.shared.delegate as? AppDelegate

var searching = false

class MainVC: UIViewController {

    //@IBOutlet weak var noNotes: UILabel!
   
    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var notes : [Note] = []
    var snotes : [Note] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        noteTableView.delegate = self
        noteTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    @IBAction func changePassTapped(_ sender: Any) {
        changePassword()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObject()
        noteTableView.reloadData()
    }

    @IBAction func addTapped(_ sender: Any) {
        
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EditNotesVC else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /// function will call fetch function and on completion it will show the tableview
    func fetchCoreDataObject() {
        self.fetch { (complete) in
            if complete{
                if notes.count >= 1 {
                    noteTableView.isHidden = false
                }
                else{
                    noteTableView.isHidden = true
                }
            }
        }
    }
    
    
    

}


extension MainVC {
    ///Method fetch the data from coredata and save it to note
    func fetch(completion : (_ complete: Bool) -> ()){
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        let sort  = NSSortDescriptor(key: #keyPath(Note.date), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            notes = try managedContext.fetch(fetchRequest)
            print("Succesfully Fetched")
            completion(true)
        } catch  {
            debugPrint("Could not print: \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    
    ///Method will remove the note
    /// - Parameter indexPath : Index paths is an item’s position inside a table view    
    func removeNotes(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        if searching {
            managedContext.delete(snotes[indexPath.row])
        }
        else {
            managedContext.delete(notes[indexPath.row])
        }
        do {
            try managedContext.save()
            commonAlert(message: "Note removed", title: "Deleted")
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    ///Method will fetch search data from notes based on title
    /// - Parameter stitle : text from searchbar textfield
    /// - Returns : array of notes data
    /// - Array
    func fetchSearchData(stitle:String) -> [Note]
    {
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else{ return [Note]()}
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", stitle.lowercased())
        let fetchRequest = NSFetchRequest<Note>(entityName: "Note")
        let sort  = NSSortDescriptor(key: #keyPath(Note.date), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        do{
            snotes = try(managedContext.fetch(fetchRequest))
            return snotes
        }
        catch{
            print("Error while fetching data")
        }
        return [Note]()
        
    }
    
}

extension MainVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return snotes.count
        }
        else{
            return notes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell") as? NoteCell else { return UITableViewCell() }
        
        if searching {
            let note = snotes[indexPath.row]
            cell.configureCell(note: note)
            
        }
        else{
            let note = notes[indexPath.row]
            cell.configureCell(note: note)
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
        if searching{
            if snotes[indexPath.row].password {
                createAlert(row: indexPath.row)
            }
            else{
                pushView(note: snotes, row: indexPath.row)
            }
        }
        else{
            if notes[indexPath.row].password {
                createAlert(row: indexPath.row)
            }
            else{
                pushView(note: notes, row: indexPath.row)
            }
        }
        
    }
    ///Method will push the view to another view
    /// - Parameter 
    /// - note : Array of data from coredata Note , row : row of cell selected
    func pushView(note : [Note],row : Int){
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? EditNotesVC else {
            return
        }
        vc.initData(note : note[row], cellTap : true)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            self.removeNotes(atIndexPath: indexPath)
            if searching{
                guard let text = searchBar.text else {
                    return
                }
                snotes = self.fetchSearchData(stitle: text)
                
            }
            else{
                self.fetchCoreDataObject()
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return.delete
    }
    
    
    
    
}

extension MainVC : UISearchBarDelegate{
    
    
    

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = true
        if searchText != ""{
            snotes = fetchSearchData(stitle: searchText)
            noteTableView.reloadData()
        }
        else{
            searching = false
            fetchCoreDataObject()
            noteTableView.reloadData()
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.resignFirstResponder()
        searchBar.text = ""
        fetchCoreDataObject()
        noteTableView.reloadData()
    }
    
}


extension MainVC{
    /// Method will change the password of notes app
    func changePassword(){
        let alert = UIAlertController(title: "Change Password", message: "Enter your Password", preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
        alert.addTextField()
        
        
        alert.textFields![0].placeholder = "Old Password"
        alert.textFields![1].placeholder = "New Password"
        alert.textFields![2].placeholder = "Confirm Password"
        
        alert.textFields![0].isSecureTextEntry = true
        alert.textFields![1].isSecureTextEntry = true
        alert.textFields![2].isSecureTextEntry = true
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancel")
        }))
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action) in
            
            if let oldPassText = alert.textFields![0].text , let newPassText = alert.textFields![1].text ,
               let newConPassText = alert.textFields![2].text {
                if self.passwordCheck(pass: oldPassText){
                    if newPassText == newConPassText {
                        KeychainWrapper.standard.set(newPassText, forKey: "password")
                    }
                    
                    
                }
            }
            else{
                self.commonAlert(message: "Please insert data", title: "Insufficient Details")
            }
        }))
        self.present(alert, animated: true)
        
    }
    
    
    /// Method will compare the password entered for accesing the note
    /// - Parameter pass : password
    /// - Returns : Boolean value
    func passwordCheck(pass : String) -> Bool {
        let password = KeychainWrapper.standard.string(forKey: "password")
        print(password!)
        if  password == pass{
            return true
        }
        else {
            
            
            return false
        }
    }
    
    /// Method will create alert for different operation
    /// - Parameter message : message to display , title : title of the alert
    func commonAlert(message : String, title : String) {
        let alertController = UIAlertController(title: title, message:
               message, preferredStyle: .alert)
           alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
           self.present(alertController, animated: true, completion: nil)
    }
    
    /// Method will alert to check password to access the cell and perform the operation whether to move forward or not
    /// - Parameter row : row of cell
    func createAlert(row:Int){
        
        let alert = UIAlertController(title: "Submit", message: "Enter your Password", preferredStyle: .alert)
        alert.addTextField()
        
        
        alert.textFields![0].placeholder = "Password"
        
        alert.textFields![0].isSecureTextEntry = true
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancel")
        }))
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { (action) in
            
            guard let passText = alert.textFields![0].text else{ return }
            let pass = self.passwordCheck(pass: passText)
            if pass{
                if searching{
                    self.pushView(note: self.snotes, row: row)
                }
                else{
                    self.pushView(note: self.notes, row: row)
                }
            }else{
                self.commonAlert(message: "Password is incorrect", title: "Incorrect")
            }
            
            
        }))
        self.present(alert, animated: true)
        
    }
}
