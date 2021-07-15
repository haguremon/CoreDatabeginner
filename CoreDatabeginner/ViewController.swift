//
//  ViewController.swift
//  CoreDatabeginner
//
//  Created by IwasakIYuta on 2021/07/10.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    //値を入れる配列を作る
    var age: [NSInteger] = []
    var name: [String] = []
    var email: [String] = []
    //var test = [["a","a",1],["a","a",2]]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func dialogAlert(title: String, message: String, completion: (() -> Void)? = nil){
        let dialog = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(dialog, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismiss(animated: true)
            }
        }
        
    }
    //保存それぞれの配列に入れる
    @IBAction func createButton(_ sender: UIButton) {
        if nameTextField.text!.isEmpty || emailTextField.text!.isEmpty {
            dialogAlert(title: "未登録", message: "値を入力してください")
            return
        }
        print("22\(nameTextField.text!)\n\(emailTextField.text!)'2'2")
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        //dialogAlert(title: "保存", message: "値を入力してください")
        guard let name = nameTextField.text,
              let age = Int(ageTextField.text!),
              let email = emailTextField.text else {
            dialogAlert(title: "未登録", message: "値を入力してください")
            return
        }
       
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext) else { return }
            let personObject = NSManagedObject(entity: entity, insertInto: managedContext) as! Person
            personObject.name = name
            personObject.age = Int16(age)
           personObject.email = email
            //personObject.email = email
            if self.email.contains(email as String){
                self.dialogAlert(title: "保存", message: "そのemailは登録されています")
                return
            }
        
        print(email)
            print(self.email)
            
            
        if managedContext.hasChanges {
            do {
                try managedContext.save()
                self.dialogAlert(title: "登録", message: "保存に成功しました")
                print("CoreDataに保存が成功しました")
            } catch  {
                let nserror = error as NSError
                print("保存に失敗しました")
                print(nserror)
            }
        }
    }
    //値を取得
    @IBAction func readButton(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        
        do {
            let myResults = try managedContext.fetch(fetchRequest)
            //fetch<T>(_ request: NSFetchRequest<T>)
            
            // var Person : dic<String,Any> = ["age":Any,"name":Any,"email",Any]
            if myResults.isEmpty && self.email.isEmpty {
                dialogAlert(title: "取得", message: "値が保存されていません")
                return
                
            }
            let count = myResults.count
            print(count)
            //            guard ((emailTextField.text?.isEmpty) != nil) else {
            //                return
            //            }
            for myData in myResults {
                self.age.append(NSInteger(myData.age) )
                self.name.append(myData.email!)
                self.email.append(myData.email!)
            }
            //nameTextField.text　と　emailTextField.textの内容がそれぞれの配列に入ってる時に遷移する
            
            print(
                """
                age -> \(age.last!)
                name ->\(name.last!)
                email ->\(email.last!)


"""
            )
            
            
        }catch  {
            let nsError = error as NSError
            print("取得に失敗しました\(nsError)")
        }
        //フィルター
        if self.name.contains(nameTextField.text!) && self.email.contains(emailTextField.text!) &&
            self.age.contains(Int(ageTextField.text!) ?? 0){
            dialogAlert(title: "取得", message: "取得に成功しました")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let infoVC1 = self.storyboard?.instantiateViewController(identifier: "toInfo") as! InfoViewController
                infoVC1.email = self.emailTextField.text ?? ""
                infoVC1.name = self.nameTextField.text ?? ""
                infoVC1.mode = .Mode1
                self.present(infoVC1, animated: true)
                
            }
            
            
            
        }else {
            
            dialogAlert(title: "取得", message: "取得に失敗しました")
            
        }
        
    }
    
    
    @IBAction func upDateButton(_ sender: UIButton) {
        guard email.contains(emailTextField.text!) else {
            dialogAlert(title: "Error", message: "Emailが登録されていません")
            return
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Person>(entityName: "Person")
        //これで検索↓
        let predicate = NSPredicate(format: "%K = %@", "email",emailTextField.text! as NSString)
        fetchRequest.predicate = predicate
        
        
        do {
            
            let name = try managedContext.fetch(fetchRequest)
            for nameData in name {
                
                let data = nameData.name! as String
                //var coreDataname = self.name
                if self.name.contains(data){
                    self.name = self.name.filter({$0 != data})
                }
            }
            self.name.append(nameTextField.text!)
        } catch  {
            dialogAlert(title: "error", message: "\(error)")
        }
        
        
        
        do {
            try managedContext.save()
            self.dialogAlert(title: "変更", message: "名前を変更しました")
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                let infoVC2 = self.storyboard?.instantiateViewController(identifier: "toInfo") as! InfoViewController
                infoVC2.email = self.emailTextField.text ?? ""
                infoVC2.name = self.nameTextField.text ?? ""
                infoVC2.mode = .Mode2
                self.present(infoVC2, animated: true)
                
            }
            print("CoreDataに保存が成功しました")
        } catch  {
            let nserror = error as NSError
            print("保存に失敗しました")
            print(nserror)
        }
        print("\(fetchRequest)")
        print(
            """
            age -> \(age.last!)
            name ->\(name.last!)
            email ->\(email.last!)
            """
        )
        
        
    }
    
    
    @IBAction func fullDeletionButton(_ sender: UIButton) {
        self.age.removeAll()
        self.name.removeAll()
        self.email.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext) else { return }
        let personObject = NSManagedObject(entity: entity, insertInto: managedContext) as! Person
        managedContext.delete(personObject)
        //fetchRequest.returnsObjectsAsFaults = false
        do {
            try managedContext.save()
            self.dialogAlert(title: "全削除", message: "削除に成功しました")

            
        } catch  {
            let nserror = error as NSError
            print("削除に失敗しました")
            print(nserror)
        }
        
    }
    
    @IBAction func debugBtn(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        print(
            """
            managedContext\(managedContext)
            paspn \(Person.self)
            age \(self.age)
            name \(self.name)
            email\(self.email)
            
            """
        )
    }
    
    @IBAction func exit(segue: UIStoryboardSegue){}
    
}
