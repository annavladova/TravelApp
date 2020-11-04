
import UIKit
import FirebaseRemoteConfig

class WelcomeViewController: UIViewController {
    
// MARK: - OUTLETS
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
// MARK: - LIFECICLE
//    !!!!!!!!! системная функция вьюдидлоад/ ее надо вызвать у вью контроллера (у родителя) только через супер/вьюдидлоад
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad WelcomeViewController")
        roundCorners(button: loginButton , radius: 4)
        roundCorners(button: createAccountButton , radius: 4)
        navigationItem.hidesBackButton = true
//        let remoteConfig = RemoteConfig.remoteConfig()
//        let loginText = remoteConfig["loginButtonText"].stringValue
//        loginButton.setTitle(loginText, for: .normal)
//        
//        let isNeedToShowLoginButton = remoteConfig["isNeedToShowLoginButton"].boolValue
//        if isNeedToShowLoginButton == false {
//            loginButton.isHidden = true
//        }
    }
    
//    вьюдидлоад срабатывает когда экран был загружен/ верстки еще нет. это значит что во вьюдидлоаде размеры всего такие какие они у нас установлены в сториборде (например под айфон 8)
    
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
    
