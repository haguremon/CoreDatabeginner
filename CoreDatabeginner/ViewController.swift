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
        let managedContext = appDelegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext),
           let name = nameTextField.text,
           let age = Int(ageTextField.text!),
           let email = emailTextField.text{
            let personObject = NSManagedObject(entity: entity, insertInto: managedContext)
            if name.isEmpty || email.isEmpty {
                dialogAlert(title: "保存", message: "値を入力してください")
                return
                
            }
            personObject.setValue(name, forKey: "name")
            personObject.setValue(NSInteger(age), forKey: "age")

            personObject.setValue(email, forKey: "email")
        }
        if managedContext.hasChanges { //値が入ったら保存する？
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
    //値を取得して
    @IBAction func readButton(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")//Pasonのテーブルから何か取得したい<ResultType>ジェネリック型
        fetchRequest.returnsDistinctResults = false
        do {
            let myResults = try managedContext.fetch(fetchRequest)
            //fetch<T>(_ request: NSFetchRequest<T>)
//            var column1 : [NSInteger]
//            var column2 : [NSString]
         // var Person : dic<String,Any> = ["age":Any,"name":Any,"email",Any]
            if myResults.isEmpty {
                dialogAlert(title: "取得", message: "値が保存されていません")
                return
                
            }
            for myData in myResults {
                self.age.append(myData.value(forKey: "age") as! NSInteger)
                self.name.append(myData.value(forKey: "name") as! NSString)
                self.email.append(myData.value(forKey: "email") as! NSString)
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
        if self.name.contains((nameTextField.text!) as NSString) && self.email.contains((emailTextField.text!) as NSString){
            dialogAlert(title: "取得", message: "取得に成功しました")
                
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let infoVC = self.storyboard?.instantiateViewController(identifier: "toInfo") as! InfoViewController
                infoVC.email = self.emailTextField.text ?? ""
                infoVC.name = self.nameTextField.text ?? ""
                self.present(infoVC, animated: true)
                
            }

    

        }else {

            dialogAlert(title: "取得", message: "取得に失敗しました")
        
        }

    }
    @IBAction func exit(segue: UIStoryboardSegue){}

}
