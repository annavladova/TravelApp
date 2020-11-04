
import UIKit
import Firebase

class LoginViewController: UIViewController {
    
//    MARK: - OUTLETS
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var separatorEmailView: UIView!
    @IBOutlet weak var separatorPasswordView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
//    MARK: - LIFECIRCLE
    
        override func viewDidLoad() {
            super.viewDidLoad()
            print("viewDidLoad LoginViewController")
            roundCorners(button: loginButton, radius: 4)
            passwordTextField.isSecureTextEntry = true
            navigationItem.hidesBackButton = true
        }
    
// MARK: - FUNCTION
    
    func roundCorners(button: UIView , radius: CGFloat) {
        button.layer.cornerRadius = radius
    }
    
//    MARK: - PROPERTIES
        
    var eyeButton = true
    
// MARK: - ACTIONS
    
    @IBAction func loginClicked(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let user = result?.user {
                print("Юзер залогинился: \(user.email)")
                
                let storybord = UIStoryboard(name: "Main", bundle: nil)
                let travelVC = storybord.instantiateViewController(identifier: "TravelListViewController") as! TravelListViewController
                self.navigationController?.pushViewController(travelVC, animated: true)
                
            } else if let error = error {
                print("Create error: \(error)")
                self.separatorEmailView.backgroundColor = .red
                self.separatorPasswordView.backgroundColor = .red
                self.emailLabel.textColor = .red
                self.passwordLabel.textColor = .red
            }
        }
    }
    
    @IBAction func forgotClicked(_ sender: Any) {
        let storybord = UIStoryboard(name: "Main", bundle: nil)
        let forgotVC = storybord.instantiateViewController(identifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        
        navigationController?.pushViewController(forgotVC, animated: true)
    }
    
    
    @IBAction func eyeClicked(_ sender: Any) {
        if(eyeButton == true) {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
        eyeButton = !eyeButton
    } 
}
