//
//  ViewController.swift
//  TwitterSentiment
//
//  Created by Madhu on 28/06/20.
//  Copyright © 2020 Madhu. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController
{
    
    
    @IBOutlet weak var label     : UILabel!
    @IBOutlet weak var searchTF  : UITextField!
    
    
    let swifter = Swifter(consumerKey: "ZMyvsWnK3tRhBeE3NiQrWIpj8", consumerSecret: "RhMAthpJbvKJKj2yHzR3BtV26V5umY2Inof6AIQ18MzRn2WxYa")
    
    let sentimentClassifier = TweetSentimentClassifier()
    
    
    
    
    @IBAction func predictButtonPressed(_ sender: UIButton)
    {
        
         if let searchTextField = searchTF.text
         {
           swifter.searchTweet(using: searchTextField, lang:"en",count: 100, tweetMode:.extended,success: {
                   (results, metadata) in
                   
                   // print(results)
                   
                   
                   var tweets = [TweetSentimentClassifierInput]()
                   
                   for m in 0..<100
                   {
                       if let tweet = results[m]["full_text"].string
                                 {
                                   let tweetForClassification = TweetSentimentClassifierInput(text: tweet)
                                   tweets.append(tweetForClassification)
                                  }
                       
                   }
                  // print(tweets)
                   do
                   {
                        let predictions =  try self.sentimentClassifier.predictions(inputs: tweets)
                       
                       var sentimentScore = 0
                       
                       for pred in predictions
                       {
                            let sentiment = pred.label
                           
                           if (sentiment == "Pos")
                           {
                               sentimentScore += 1
                           }
                           else if (sentiment == "Neg")
                           {
                               sentimentScore -= 1
                           }
                       }
                      
                       //print(sentimentScore)
                    
                    if (sentimentScore > 20)
                    {
                        self.label.text = "😍"
                    }
                    else if sentimentScore > 10
                    {
                        self.label.text = "😀"
                    } else if sentimentScore > 0
                    {
                        self.label.text = "🙂"
                    } else if sentimentScore == 0
                    {
                        self.label.text = "😐"
                    } else if sentimentScore > -10
                    {
                        self.label.text = "😕"
                    } else if sentimentScore > -20
                    {
                        self.label.text = "😡"
                    } else
                    {
                        self.label.text = "🤮"
                    }
                       
                   }
                   catch
                   {
                       print("Error making A Predicate \(error)")
                   }
                  
                   
                 
               })
            
               {
                (error) in
                   print("There is an Error in Twitter Request \(error)")
               }
              
           }
  }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        let prediction = try! sentimentClassifier.prediction(text: "@Apple Is Best Company")
//
//        print(prediction.label)
//
        
    
    }

}
