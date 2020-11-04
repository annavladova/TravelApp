
import UIKit
import FirebaseRemoteConfig

class WelcomeViewController: UIViewController {
    
// MARK: - OUTLETS
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
// MARK: - LIFECICLE

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad WelcomeViewController")
        roundCorners(button: loginButton , radius: 4)
        roundCorners(button: createAccountButton , radius: 4)
        navigationItem.hidesBackButton = true
    }

// MARK: - ACTIONS
    
    @IBAction func loginClicked(_ sender: Any) {
        let storybord = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storybord.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        navigationController?.pushViewController(loginVC, animated: true)
    }
    
    
    @IBAction func createClicked(_ sender: Any) {
        let storybord = UIStoryboard(name: "Main", bundle: nil)
        let registrationVC = storybord.instantiateViewController(identifier: "RegistrationViewController") as! RegistrationViewController
        navigationController?.pushViewController(registrationVC, animated: true)
    }
   
// MARK: - FUNCTIONS
    
    func roundCorners(button: UIButton, radius: CGFloat) {
        button.layer.cornerRadius = radius
    }
}
    
