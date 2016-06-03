//
//  AddReviewController.swift
//  StoreDemoApp
//
//  Created by Chris Tchoukaleff on 6/2/16.
//  Copyright © 2016 IBM. All rights reserved.
//

import UIKit

class AddReviewController: UIViewController, UITextViewDelegate {
    
    var review:Review = Review()
    var itemId:Int = 0
    
    var http: Http!
    
    @IBOutlet weak var comment: UITextView!
    @IBOutlet weak var rating: CosmosView!
    @IBOutlet weak var reviewerName: UITextField!
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
    }
    
    @IBAction func addReview(sender: AnyObject) {
        
        print("Ready to submit review comment")
        self.review.comments = comment.text
        self.review.itemRating = Int(rating.rating)
        self.review.itemID = itemId
        self.review.name = reviewerName!.text!
        
        print("review object \(self.review.itemRating) with name: \(self.review.name) with comment: \(self.review.comments)")
     
        //Prepare REST call to APIC
        let appDelegate : AppDelegate = AppDelegate().sharedInstance()
        //let appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //let userDefaults = appDelegate.userDefaults as? NSUserDefaults
        
        //var reviewRestUrl: String = appDelegate.userDefaults.objectForKey("reviewRestUrl") as! String
        
        //For temp APIC testing
        var reviewRestUrl: String = "https://api.us.apiconnect.ibmcloud.com/gangchenusibmcom-dev/inventory-catalog"
        
        
        reviewRestUrl += "/api/reviews"
        print("Review REST endpoint is : \(reviewRestUrl)")
        
        //Define Parameters
        let reviewParams = ["comment":self.review.comments,  "itemId":self.review.itemID, "rating":self.review.itemRating, "review_date":"06/06/2016", "reviewer_email":"gchen@ibm.com", "reviewer_name":self.review.name]
        
        self.postReviews(reviewRestUrl, parameters: reviewParams as? [String : AnyObject])
        
        //self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        comment.userInteractionEnabled = true
        comment.layer.borderColor = UIColor.lightGrayColor().CGColor
        comment.layer.borderWidth = 1.0
        comment.layer.cornerRadius = 5.0
        comment.delegate = self
        
        //Need to retrieve ItemID from memory userDefaults because the OAuth flow interrupts the flow
        let appDelegate : AppDelegate = AppDelegate().sharedInstance()
        self.itemId = appDelegate.userDefaults.objectForKey("currentItemId") as! Int
        
        //Set up REST framework
        self.http = Http()
        
        if (self.http.authzModule == nil)
        {
            let apicConfig = ApicConfig(
            clientId: "04ba66c7-118f-4e28-9790-1841ff09ce44",
            scopes:["review"])
            //apicConfig.isWebView = true

            // let gdModule = KeycloakOAuth2Module(config: googleConfig, session: UntrustedMemoryOAuth2Session(accountId: "ACCOUNT_FOR_CLIENTID_\(googleConfig.clientId)"))
        
            let gdModule = KeycloakOAuth2Module(config: apicConfig, session: UntrustedMemoryOAuth2Session(accountId: "ACCOUNT_FOR_CLIENTID_\(apicConfig.clientId)"))
        
            //let gdModule = AccountManager.addGoogleAccount(apicConfig)
            self.http.authzModule = gdModule

            // Initiate the OAuth flow
            let oauthRestUrl: String = "https://api.us.apiconnect.ibmcloud.com/gangchenusibmcom-dev/inventory-catalog/api/oauth"
            self.initOauth(oauthRestUrl, parameters: nil)
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
       textView.text = ""
    }
    
    func postReviews(url: String, parameters: [String: AnyObject]?) {
        print("calling listReviews")
        self.http.request(.POST, path: url, parameters: parameters, completionHandler: {(response, error) in
            // handle response
            if (error != nil) {
                print("Error \(error!.localizedDescription)")
            } else {
                print("Successfully invoked! \(response)")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    
    func initOauth(url: String, parameters: [String: AnyObject]?) {
        print("calling Init Oauth")
        self.http.request(.GET, path: url, parameters: parameters, completionHandler: {(response, error) in
            // handle response
            if (error != nil) {
                print("Error \(error!.localizedDescription)")
            } else {
                print("Successfully invoked! \(response)")
            }
        })
    }

}
