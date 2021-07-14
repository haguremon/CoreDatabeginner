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
    var name: [NSString] = []
    var email: [NSString] = []
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        //dialogAlert(title: "保存", message: "値を入力してください")
        guard let name = nameTextField.text,
              let age = Int(ageTextField.text!),
              let email = emailTextField.text else {
            dialogAlert(title: "未登録", message: "値を入力してください")
            return
        }
//        guard self.email.contains(email as NSString) else {
//            dialogAlert(title: "登録", message: "そのEmailで登録されています")
//            return
//        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext) {
            let personObject = NSManagedObject(entity: entity, insertInto: managedContext)
            if name.isEmpty || email.isEmpty {
                dialogAlert(title: "保存", message: "値を入力してください")
                return
                
            }
            personObject.setValue(name, forKey: "name")
            personObject.setValue(NSInteger(age), forKey: "age")
            if self.email.contains(email as NSString){
                self.dialogAlert(title: "保存", message: "そのemailは登録されています")
                return
            }else {
                personObject.setValue(email, forKey: "email")
            }
            print(email)
            print(self.email)
            
            
        }
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")//Pasonのテーブルから何か取得したいNSFetchRequest<ResultType>ジェネリック型
        fetchRequest.propertiesToFetch = ["email"]
        fetchRequest.returnsDistinctResults = true
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
                self.age.append(myData.value(forKey: "age") as! NSInteger)
                self.name.append(myData.value(forKey: "name") as! NSString)
                if fetchRequest.returnsDistinctResults {
                    self.email.append(myData.value(forKey: "email") as? NSString ?? "")
                }
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
        if self.name.contains((nameTextField.text!) as NSString) && self.email.contains((emailTextField.text!) as NSString) &&
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
        guard email.contains(emailTextField.text! as NSString) else {
            dialogAlert(title: "Error", message: "Emailが登録されていません")
            return
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        //これで検索↓
        let predicate = NSPredicate(format: "%K = %@", "email",emailTextField.text! as NSString)
        fetchRequest.predicate = predicate
        
        
        do {
            
            let name = try managedContext.fetch(fetchRequest)
            for nameData in name {
                
                let data = nameData.value(forKey: "name") as! NSString
                //var coreDataname = self.name
                if self.name.contains(data){
                    self.name = self.name.filter({$0 != data})
                }
            }
            self.name.append(nameTextField.text! as NSString)
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
        
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")

        fetchRequest.returnsObjectsAsFaults = false
                do {
                    let results = try managedContext.fetch(fetchRequest)
                           for managedObject in results {
                               if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                                managedContext.delete(managedObjectData)
                               }
                    self.dialogAlert(title: "全削除", message: "削除に成功しました")
                    self.age.removeAll()
                    self.name.removeAll()
                    self.email.removeAll()
                    print("削除")
                }
                           } catch  {
                    let nserror = error as NSError
                    print("削除に失敗しました")
                    print(nserror)
                }
            
            
        }
    
    @IBAction func debugBtn(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        print(
            """
            managedContext\(managedContext)
            Person\(fetchRequest)
            age \(self.age)
            name \(self.name)
            email\(self.email)
            
            """
        )
    }
    
    @IBAction func exit(segue: UIStoryboardSegue){}
    
}
