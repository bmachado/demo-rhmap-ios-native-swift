//
//  SecondViewController.swift
//  blank-ios-app
//
//  Created by Administrator on 10/24/17.
//  Copyright © 2017 FeedHenry. All rights reserved.
//

import UIKit
import Alamofire
import FeedHenry

class SecondViewController: UIViewController {

    @IBOutlet weak var nome: UILabel!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.nome.text = name
        
        Alamofire.request("https://api.coindesk.com/v1/bpi/currentprice.json").responseJSON { response in print(response)
            
            if let bitcoinJSON = response.result.value {
                let bitcoinObject: Dictionary = bitcoinJSON as! Dictionary<String, Any>
                
                let bpiObject: Dictionary = bitcoinObject["bpi"] as! Dictionary<String, Any>
                let usdObject:Dictionary = bpiObject["USD"] as! Dictionary<String, Any>
                let rate:Float = usdObject["rate_float"] as! Float
                
                self.label.text = "$\(rate)"
            }
        }
        print("Loading web service")
        
        // FH.init using Swift FH sdk
        // trailing closure Swift syntax
        FH.init { (resp:Response, error: NSError?) -> Void in
            if let error = error {
                self.statusLabel.text = "FH init in error \(error.localizedDescription)"
                print("Error: \(error)")
                return
            }
            self.statusLabel.text = "FH init successful"
            print("Response: \(resp.parsedResponse)")
            FH.cloud(path:"/hello",
                     args: ["hello": name as AnyObject],
                     completionHandler: {(resp: Response, error: NSError?) -> Void in
                        if let error = error {
                            print("Cloud Call Failed, \\(error)")
                            return
                        }
                        print("Success \(resp.parsedResponse)")
                        if let json = resp.parsedResponse {
                            let jsonObject: Dictionary = json as! Dictionary<String, Any>
                            let msg: String = jsonObject["msg"] as! String
                            self.statusLabel.text = msg
                        }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
