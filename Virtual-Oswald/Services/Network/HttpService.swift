//
//  HttpService.swift
//  Virtual-Oswald
//
//  Created by niels vaes on 08/03/2019.
//  Copyright © 2019 niels vaes. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftyJSON

class HttpService{
    var data = "still null";
    let synth = AVSpeechSynthesizer()
    var lang : String!
    var number: Int!
    var didReceiveMessage: ((String) -> Void)?
    var didReceiveImage: ((String, String) -> Void)?
    var didReceiveQuickReplies: (([QuickReply]) -> Void)?
    var requestForOswald: URLRequest?
    
    init(Lang : String){
        self.lang = Lang;
        self.number = Int.random(in: 0 ..< 9999)
        setupOswaldRequest()
    }
    
    // creates a template URLRequest to comunicate with Oswald
    func setupOswaldRequest(){
        let oswaldEndpoint: String = "https://api.oswald.ai/api/v1/chats/5c8669c0696d2900055a0135/message?access_token=f724446e-5092-4645-a76e-56f4856f86c6"
        let oswaldURL = URL(string: oswaldEndpoint)
        var oswaldUrlRequest = URLRequest(url: oswaldURL!)
        oswaldUrlRequest.httpMethod = "POST"
        self.requestForOswald = oswaldUrlRequest
    }
    
    // returns the URLRequest template
    func getRequestForOswald() -> URLRequest{
        return requestForOswald!
    }
    
    // Adds a message to the recieved URLRequest and returns the updated version
    func addMessageToRequest(httpRequest: URLRequest,text: String, Dier: String) -> URLRequest{
        var hRequest = httpRequest
        let newMessage: [String: Any] = ["message": text,"environment": "production","session": number,"locale": "nl-BE","sessionInfo": [],"metadata": ["Dier": Dier]]
        let jsonData = try? JSONSerialization.data(withJSONObject: newMessage, options: [])
        hRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        hRequest.httpBody = jsonData
        return hRequest
    }
    
    /* Sends a Http request to Oswald and gets his answer
     */
    func getRequest(request: URLRequest){
        let session = URLSession.shared
        let task = session.dataTask(with: request) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                guard let receivedMessage = try JSONSerialization.jsonObject(with: responseData,
                                                                             options: []) as? [String: Any] else {
                                                                                print("Could not get JSON from responseData as dictionary")
                                                                                return
                }
                self.checkRecievedMessage(swiftyJsonVar: JSON(receivedMessage))
                
            } catch  {
                return
            }
        }
        task.resume()
    }
    
    //Checks if the recieved message contains a image or not.
    func checkRecievedMessage(swiftyJsonVar: JSON) {
        if(swiftyJsonVar["data"][0]["image"].string != nil){
            self.didReceiveImage!(swiftyJsonVar["data"][0]["image"].string!, swiftyJsonVar["data"][0]["message"].string!)
        }else {
            self.didReceiveMessage!(swiftyJsonVar["data"][0]["message"].string!)
        }
        self.checkQuickReplies(swiftyJsonVar: swiftyJsonVar)
        
    }
    
    //Checks if there are quickReplies in the recieved message and sends a delegate if theire are any.
    func checkQuickReplies(swiftyJsonVar: JSON){
        var i = 0
        var moreQuickReplies = true
        var quickReplies: [QuickReply]  = []
        repeat {
            if(swiftyJsonVar["quickReplies"][i]["text"].string != nil){
                
                quickReplies.append(QuickReply(title: swiftyJsonVar["quickReplies"][i]["text"].string!, text: swiftyJsonVar["quickReplies"][i]["action"].string!))
                i = i + 1
            }
            else{
                moreQuickReplies = false
                if(quickReplies.count > 0){
                    self.didReceiveQuickReplies!(quickReplies);
                }
            }
        } while(moreQuickReplies == true)
    }
}


class QuickReply {
    var title: String
    var text: String
    init(title: String , text: String) {
        self.title = title
        self.text = text
    }
}
