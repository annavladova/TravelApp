
import UIKit
import Firebase

class RegistrationViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundCorners(button: registrationButton, radius: 4)
    }
    
    func roundCorners(button: UIView, radius: CGFloat) {
        button.layer.cornerRadius = radius
    }
    
    
    @IBAction func registrationClicked(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let user = result?.user {
                print("Юзер создан: \(user.email)")
                
                let storybord = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storybord.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                       
                self.navigationController?.pushViewController(loginVC, animated: true)
                
            } else if let error = error {
                print("Create error: \(error)")
            }
        }
    }
}
