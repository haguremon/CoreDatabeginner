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
    var personData: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    //保存
    @IBAction func createButton(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext),
           let name = nameTextField.text,
           let age = ageTextField.text { //ageはintじゃないと落ちるようにしたい
            let personObject = NSManagedObject(entity: entity, insertInto: managedContext)
            personObject.setValue(name, forKey: "name")
            personObject.setValue(NSInteger(age), forKey: "age")
        }
        if managedContext.hasChanges { //値が入ったら保存する？
            do {
                try managedContext.save()
            print("保存に成功しました")
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")//Pasonのテーブルから何か取得したい<ResultType>ジェネリック型
        fetchRequest.returnsDistinctResults = false
        do {
            let myResults = try managedContext.fetch(fetchRequest)
            //fetch<T>(_ request: NSFetchRequest<T>)
//            var column1 : [NSInteger]
//            var column2 : [NSString]
         
            for myData in myResults {
                if let age = myData.value(forKey: "age") as? NSInteger,
                   let name = myData.value(forKey: "name") as? NSString{
                    print("name\(name),age: \(age)")
                    print(myData)
                }
               
            }
            }catch  {
                let nsError = error as NSError
                print("保存に失敗しました\(nsError)")
            }

    }
}


