//Tutorialviewcontroller to show all steps that needs to be done to place an object and make a request to Oswald
import Foundation
import UIKit
import FontAwesome_swift

class TutorialViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    var slides: [Slide] = []
    var steps: [Step] = [Step(title: "Stap 1", text: "Scan de omgeving tot het 3D model verschijnt. Tap daarna op het scherm om het model vast te zetten.", image: "stepOne"),Step(title: "Stap 2", text: "Nu kan je het model transformeren naar wens. Bij een enkele klik op het scherm kan je het model wijzigen. Als je lang drukt op het scherm kunnen er geen aanpassingen meer worden doorgevoerd. Als je achteraf nog veranderingen wil doorvoeren kan dit door terug lang op het scherm te drukken.", image: "stepTwo"),Step(title: "Stap 3", text: "Als je klikt op een dier in het model wordt dit dier geselecteerd. Als je nu een vraag stelt weet Oswald over welk dier het gaat. Indien er geen dier geselecteerd is zal je zelf een dier moeten vernoemen in de vraag.", image: "stepThree"),Step(title: "Stap 4", text: "Je kan Oswald makkelijk bereiken door op de microfoonknop te drukken en je vraag te stellen. Oswald zal automatisch antwoorden als je stopt met spreken.", image: "stepFour"),Step(title: "Stap 5", text: "Indien gewenst kan je ook met Oswald praten via de chatknop. Via de menuknop krijg je nog extra opties.", image: "stepFive")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        self.createSlides()
        self.setupSlideScrollView(slides: slides)
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    //Function to create the slides
    func createSlides(){
        for step in self.steps{
            let slide:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
            slide.image.image = UIImage(named: step.image)
            slide.title.text = step.title
            slide.info.text = step.text
            slide.info.numberOfLines = 0
            slide.info.sizeToFit()
            slide.menuButton.addTarget(self, action: #selector(onMenuPressed(sender:)), for: .touchUpInside)
            slide.skipButton.addTarget(self, action: #selector(onSkipPressed(sender:)), for: .touchUpInside)
            self.slides.append(slide)
        }
    }
    
    //Function to init the scrollview and set boundaries of where you can scroll
    func setupSlideScrollView(slides : [Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    //Function that is called when the view is scrolled
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        if(pageIndex == 4){
           slides[4].skipButton.setTitle("Sluit", for: .normal)
        }
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            slides[0].skipButton.alpha = 1-percentOffset.x/0.25
            slides[0].menuButton.alpha = 1-percentOffset.x/0.25
            slides[0].image.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            
            slides[1].skipButton.alpha = percentOffset.x/0.25 * 1
            slides[1].menuButton.alpha = percentOffset.x/0.25 * 1
            slides[1].image.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
            
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.5) {
            slides[1].skipButton.alpha = 1-percentOffset.x/0.5
            slides[1].menuButton.alpha = 1-percentOffset.x/0.5
            slides[1].image.transform = CGAffineTransform(scaleX: (0.5-percentOffset.x)/0.25, y: (0.5-percentOffset.x)/0.25)
            
            slides[2].skipButton.alpha = percentOffset.x/0.5 * 1
            slides[2].menuButton.alpha = percentOffset.x/0.5 * 1
            slides[2].image.transform = CGAffineTransform(scaleX: percentOffset.x/0.5, y: percentOffset.x/0.5)
        }else if(percentOffset.x > 0.5 && percentOffset.x <= 0.75) {
            slides[2].skipButton.alpha = 1-percentOffset.x/0.75
            slides[2].menuButton.alpha = 1-percentOffset.x/0.75
            slides[2].image.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
            
            slides[3].skipButton.alpha = percentOffset.x/0.75 * 1
            slides[3].menuButton.alpha = percentOffset.x/0.75 * 1
            slides[3].image.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
        }else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
            slides[3].skipButton.alpha = 1-percentOffset.x/1
            slides[3].menuButton.alpha = 1-percentOffset.x/1
            slides[3].image.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
            
            slides[4].skipButton.alpha = percentOffset.x/1 * 1
            slides[4].menuButton.alpha = percentOffset.x/1 * 1
            slides[4].image.transform = CGAffineTransform(scaleX: percentOffset.x/1, y: percentOffset.x/1)
        }
    }
    
    //Function that is called to update the scrollview boundaries when more slides are added
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupSlideScrollView(slides: slides)
    }
    
    //Function that is called when the menu button in de slide is pressed
    @objc func onMenuPressed(sender: UIButton){
        self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    //Function that is called when the skip button in de slide is pressed
    @objc func onSkipPressed(sender: UIButton){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc : MainViewController = mainStoryboard.instantiateViewController(withIdentifier: "mainView") as! MainViewController
        self.present(vc, animated: true, completion: nil)
    }
}

//Class to create a step of the tutorial
class Step {
    var title: String
    var text: String
    var image: String
    init(title: String , text: String , image: String) {
        self.title = title
        self.image = image
        self.text = text
    }
}
