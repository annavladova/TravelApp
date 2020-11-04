
import UIKit

class ForgotPasswordViewController: UIViewController {
    
//    MARK: - OUTLETS
    
    @IBOutlet weak var loginButton: UIButton!
    
//    MARK: - LIFECIRCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad ForgotPasswordViewController")
        roundCorners(button: loginButton, radius: 4)
    }
    
//    MARK: - FUNCTION
    
    func roundCorners(button: UIView , radius: CGFloat) {
        button.layer.cornerRadius = radius
    }
    
    
}
