//
//  ViewController.swift
//  Virtual-Oswald
//
//  Created by niels vaes on 04/03/2019.
//  Copyright © 2019 niels vaes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var preButton: UIButton!
    @IBOutlet weak var Oswald: UIImageView!
    @IBOutlet weak var welcomeBackground: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var welcomeTextView: UITextView!
    
    let strPage = ["welkom in de virtuele dierentuin. In deze dierentuin komen dieren tot leven. En geen nood al uw vragen zullen beantwoord worden door uw persoonlijke assistente.","Om gebruik te maken van de persoonlijke assistente moet u ons toegang geven om uw microfoon te gebruiken. Indien u dit weigert zal de persoonlijke assistente niet beschikbaar zijn."]
    var currentPage : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = 0
        welcomeTextView.text = strPage[currentPage]
        welcomeTextView.layer.cornerRadius = 15
        welcomeTextView.layer.shadowColor = UIColor.black.cgColor
        welcomeTextView.layer.shadowRadius = 50
        welcomeTextView.layer.shadowOpacity = 0.8
        welcomeTextView.layer.shadowOffset = CGSize(width: 0	, height: 0)
        
        nextButton.setTitle(" Volgende ", for: .normal)
        nextButton.layer.cornerRadius = nextButton.frame.height / 2;
        nextButton.layer.shadowColor = UIColor.black.cgColor
        nextButton.layer.shadowRadius = 50
        nextButton.layer.shadowOpacity = 0.8
        nextButton.layer.shadowOffset = CGSize(width: 0    , height: 0)
        
        preButton.setTitle(" vorige ", for: .normal)
        preButton.layer.cornerRadius = nextButton.frame.height / 2;
        preButton.layer.shadowColor = UIColor.black.cgColor
        preButton.layer.shadowRadius = 50
        preButton.layer.shadowOpacity = 0.8
        preButton.layer.shadowOffset = CGSize(width: 0    , height: 0)
        
        preButton.isHidden = true
    }

    @IBAction func NextButtonAction(_ sender: Any) {
        print(currentPage , strPage.count);
        if(currentPage < (strPage.count - 1)){
            currentPage += 1;
            welcomeTextView.text = strPage[currentPage];
            print("next button is geclickt current page : " , currentPage );
            if(currentPage == 1){
                preButton.isHidden = false;
            }
            if(currentPage == (strPage.count-1)){
                nextButton.setTitle(" finnish ", for: .normal)
            }
            
        }else{
            performSegue(withIdentifier: "NavigateToCameraView", sender: self)
            
        }
        
    }
    
    @IBAction func PreButtonAction(_ sender: Any) {
        if (currentPage > 0){
            currentPage -= 1;
            welcomeTextView.text = strPage[currentPage];
            if(currentPage == 0){
                preButton.isHidden = true;
            }
            if(currentPage == (strPage.count-2)){
                nextButton.setTitle(" volgende ", for: .normal)
            }
        }    }
}

