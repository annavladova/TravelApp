
import UIKit
import FirebaseRemoteConfig

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var loadingView: DotsActivityIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let remoteConfig = RemoteConfig.remoteConfig() // подключить ремоут конфиг из фаербэйза - ЭТО СИНГЛТОН - ОБЪЕКТ КОТОРЫЙ СОЗДАЕТСЯ ПОКА ЖИВЕТ ПРИЛОЖЕНИЕ
        
        loadingView.startAnimation()
        remoteConfig.fetchAndActivate { (status, error) in //fetch - это извлечь/получить, то есть мы делаем запрос на сервак
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { //это такая штука ЧТОБЫ ПЕРЕХОД НА ДРУГОЙ ЭКРАН ПРОИЗОШЕЛ ПОСЛЕ ЗАГРУЗКИ ДАННЫХ С СЕРВЕРА
                self.showWelcomeScreen()
            }
        }
    }
    
    func showWelcomeScreen() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let stopVC = storyboard.instantiateViewController(identifier: "WelcomeViewController") as! WelcomeViewController
        navigationController?.pushViewController(stopVC, animated: true)
    }
    
    
}
