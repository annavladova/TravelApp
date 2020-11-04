
import UIKit
import Firebase
import FirebaseDatabase

protocol CreateStopViewControllerDelegate {
    func didCreate(stop: Stop)
    func didUpdate(stop: Stop)
}

class CreateStopViewController: UIViewController {
    
// MARK: - OUTLETS
   
    @IBOutlet weak var stepperRating: UIStepper!
    @IBOutlet weak var chooseTransportButton: UISegmentedControl!
    @IBOutlet weak var stopNameTextField: UITextField!
    @IBOutlet weak var ratingLable: UILabel!
    @IBOutlet weak var locationLable: UILabel!
    @IBOutlet weak var spentMoneyLable: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var loadingView: DotsActivityIndicator!
    
 // MARK: - PROPERTIES
    
    var travelId: String = ""
    var textToTransfer: String = ""
    var money: Double = 0
    var curencySelected: Currency = .none
    var delegate: CreateStopViewControllerDelegate?
    var stop: Stop?
    var transport: Stop?
    
// MARK: - LIFECIRCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
//        толщина бордера
        borderWidth(view: stepperRating, width: 1)
        borderWidth(view: chooseTransportButton, width: 1)
        
        let customColor = CGColor.init(srgbRed: 0.515, green: 0.528, blue: 0.937, alpha: 1)
        loadingView.tintColor = UIColor(cgColor: customColor)
        
//        цвет бордера
        stepperRating.layer.borderColor = customColor
        chooseTransportButton.layer.borderColor = customColor

//        закругление степпера
        roundCorners(button: stepperRating, radius: 4)
        
//        цвет текста в степпере
        stepperRating.tintColor = UIColor(cgColor: customColor)
        stepperRating.setDecrementImage(stepperRating.decrementImage(for: .normal), for: .normal)
        stepperRating.setIncrementImage(stepperRating.incrementImage(for: .normal), for: .normal)
    
        stopNameTextField.text = String(stop?.name ?? "")
        ratingLable.text = String(stop?.rating ?? 0)
        textView.text = stop?.description
        spentMoneyLable.text = String(stop?.spendMoney ?? 0)

        textView.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    
// MARK: - FUNCTIONS
    
    func roundCorners(button: UIView , radius: CGFloat) {
        button.layer.cornerRadius = radius
    }
   
    func borderWidth(view: UIView , width: CGFloat) {
        view.layer.borderWidth = width
    }
    
    func spent(money: Double, currency: Currency) {
           spentMoneyLable.text = String(money) + currency.rawValue
           self.curencySelected = currency
           self.money = money
    }
    
    func sendToServer(stop: Stop) {
        let database = Database.database().reference()
        let child = database.child("stops").child("\(stop.id)")
        
        loadingView.startAnimation()
        
        child.setValue(stop.json) { (error, ref) in
            print(error, ref) // в консоли по этой ссылке будет nil если ошибок нет
            self.loadingView.stopAnimation()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
// MARK: - ACTIONS
    
    @IBAction func saveClicked(_ sender: Any) {
        if stop != nil {
            update(stop: stop!)
            delegate?.didUpdate(stop: stop!)
            sendToServer(stop: stop!)
        } else {
            let id = UUID().uuidString
            let stopNew = Stop(id: id,
                               travelId: travelId,
                               name: stopNameTextField.text ?? "",
                               rating: Int(ratingLable.text ?? "") ?? 0,
                               location: .zero, //исправить с нуля !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                               description: textView.text,
                               spendMoney: money,
                               currency: curencySelected)
            
            if chooseTransportButton.selectedSegmentIndex == 0 {
                stopNew.transport = .airplane
            } else if chooseTransportButton.selectedSegmentIndex == 1 {
                stopNew.transport = .train
            } else if chooseTransportButton.selectedSegmentIndex == 2 {
                stopNew.transport = .car
            }
            delegate?.didCreate(stop: stopNew)
            sendToServer(stop: stopNew)
        }
    }
    
    func update(stop: Stop) {
        stop.travelId = travelId
        stop.name = stopNameTextField.text ?? ""
        stop.rating = Int(ratingLable.text ?? "") ?? 0
        stop.location = .zero //исправить с нуля !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        stop.description = textView.text
        stop.spendMoney = money
        stop.currency = curencySelected
        if chooseTransportButton.selectedSegmentIndex == 0 {
            stop.transport = .airplane
        } else if chooseTransportButton.selectedSegmentIndex == 1 {
            stop.transport = .train
        } else if chooseTransportButton.selectedSegmentIndex == 2 {
            stop.transport = .car
        }
    }
    
    
    @IBAction func plusLocationClicked(_ sender: Any) {

        let mapVC = MapViewController.fromStoryboard() as! MapViewController
        navigationController?.pushViewController(mapVC, animated: true)

        mapVC.closure = { point in
            self.locationLable.text = "\(point.x) - \(point.y)"
        }
    }
    
    @IBAction func ratingStepper(_ sender: Any) {
        ratingLable.text = String(Int(stepperRating.value))
    }
    
    @IBAction func transportSegment(_ sender: Any) {
        
    }
    
    @IBAction func spentMoneyClicked(_ sender: Any) {
        let storybord = UIStoryboard(name: "Main", bundle: nil)
        let spentVC = storybord.instantiateViewController(identifier: "SpentMoneyViewController") as! SpentMoneyViewController
        
        present(spentVC, animated: true, completion: nil)
        
        spentVC.closure = { money, currency in
            self.spentMoneyLable.text = "\(Int(money)) \(currency.rawValue)"
            self.curencySelected = currency
            self.money = money
        }
    }
    
    
    @IBAction func cancelClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
