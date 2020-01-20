//
//  ViewController.swift
//  homeWork_16
//
//  Created by Дмитрий Яковлев on 18.01.2020.
//  Copyright © 2020 Дмитрий Яковлев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- outlets
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var timerButton: UIButton!
    
    let postModel = PostModel()
    
    //MARK:- ViewDidLoad -> subscribe
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        myTableView.delegate = self
        myTableView.dataSource = self
        postModel.subscribe(myTableView: myTableView, type: MyItem.self)
        
    }
    
    //MARK:- actions
    @IBAction func timerButtonClicked(_ sender: UIButton) {
        let tmp = postModel.startDownlodTimer()
        timerButton.setTitle(tmp, for: .normal) 
    }
    
    @IBAction func clearDBCLicked(_ sender: UIButton) {
        makeAlert(title: "Attentinon", text: "Are you sure?", str: "", actionAdd: postModel.deleteAllDB)
    }
    
    @IBAction func addClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondView") as! SecondViewController
        vc.currentItem = nil
        vc.postModel = postModel
        self.present(vc, animated: true, completion: nil)
    }
    
    private func makeAlert(title: String , text: String, str: String ,  actionAdd: @escaping ()->()) {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            actionAdd()
        }))
        self.present(alert, animated: true)
    }
    
    
}



//MARK:- UITableViewDelegate

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) else{return}
        guard let tmp = cell.detailTextLabel?.text else {return}
        
        let item = postModel.getPost(id: tmp, type: MyItem.self)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondView") as! SecondViewController
        
        vc.currentItem = item
        vc.postModel = postModel
        self.present(vc, animated: true, completion: nil)
        
    }
    
}

//MARK:- UITableViewDataSource

extension ViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let tmp =  postModel.getAllPosts(ofType: MyItem.self)
        return tmp.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        let index = Int(indexPath.row)
        
        let items = postModel.getAllPosts(ofType: MyItem.self)
        
        cell.textLabel?.text = items[index].textString
        cell.detailTextLabel?.text = items[index].id
        
        return cell
        
    }
}
