//Welcomeview controller to show the view when the app is started
import UIKit
import RevealingSplashView

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width * 0.7
        let height = CGFloat(width * (5 / 4))
        print(height.description + " " + width.description)
        //Initialize a revealing Splash with with the iconImage, the initial size and the background color
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "oswaldSafari")!,iconInitialSize: CGSize(width: width, height: height), backgroundColor: UIColor.white)
        revealingSplashView.center = self.view.center
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        //Starts animation
        revealingSplashView.startAnimation(){
        
        }
    }
}
