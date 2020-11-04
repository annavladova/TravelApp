
import UIKit
import Firebase
import FirebaseDatabase

class StopListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateStopViewControllerDelegate {
    
    
    //MARK: - Outlets
    @IBOutlet weak var stopTableView: UITableView!
    @IBOutlet weak var noAnyStops: UILabel!
    
    //MARK: - Properties
    var travel: Travel?
    var textNameTransfer: String = ""
    
    
    //MARK: - Liftravelcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        stopTableView.delegate = self
        stopTableView.dataSource = self
        emptyList()

    }
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travel?.stops.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 141
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stopCell = tableView.dequeueReusableCell(withIdentifier: "StopTableViewCell", for: indexPath) as! StopTableViewCell
      
        if let stop = travel?.stops[indexPath.row] {
            stopCell.stopNameLable.text = stop.name
            stopCell.stopDescriptionLable.text = stop.description
            stopCell.spentMoneyLabel.text = String(stop.spendMoney) + stop.currency.rawValue

            stopCell.firstStar.image = UIImage(named: "Star Icon-1")
            stopCell.secondStar.image = UIImage(named: "Star Icon-1")
            stopCell.thirdStar.image = UIImage(named: "Star Icon-1")
            stopCell.forthStar.image = UIImage(named: "Star Icon-1")
            stopCell.fifthStar.image = UIImage(named: "Star Icon-1")
            
            switch stop.rating {
            case 1:
                stopCell.firstStar.image = UIImage(named: "Star")
            case 2:
                stopCell.firstStar.image = UIImage(named: "Star")
                stopCell.secondStar.image = UIImage(named: "Star")
            case 3:
                stopCell.firstStar.image = UIImage(named: "Star")
                stopCell.secondStar.image = UIImage(named: "Star")
                stopCell.thirdStar.image = UIImage(named: "Star")
            case 4:
                stopCell.firstStar.image = UIImage(named: "Star")
                stopCell.secondStar.image = UIImage(named: "Star")
                stopCell.thirdStar.image = UIImage(named: "Star")
                stopCell.forthStar.image = UIImage(named: "Star")
            case 5:
                stopCell.firstStar.image = UIImage(named: "Star")
                stopCell.secondStar.image = UIImage(named: "Star")
                stopCell.thirdStar.image = UIImage(named: "Star")
                stopCell.forthStar.image = UIImage(named: "Star")
                stopCell.fifthStar.image = UIImage(named: "Star")
            default:
                print("0")
            }
            
            switch stop.transport {
            case .none:
                break
            case .car:
                stopCell.transportImageView.image = UIImage(named: "Car")
            case .airplane:
                stopCell.transportImageView.image = UIImage(named: "Airplane")
            case .train:
                stopCell.transportImageView.image = UIImage(named: "Train")
            }
        }
        return stopCell
    }
               

    func didCreate(stop: Stop) {
        travel?.stops.append(stop)
        emptyList()
        stopTableView.reloadData()
    }
    
    func didUpdate(stop: Stop) {
        
        guard let indexPath = stopTableView.indexPathForSelectedRow else {
            return
        }
        travel?.stops[indexPath.row] = stop
        stopTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let createVC = storyboard.instantiateViewController(identifier: "CreateStopViewController") as! CreateStopViewController
        createVC.delegate = self
        createVC.stop = travel?.stops[indexPath.row]
        createVC.travelId = travel?.id ?? ""
        navigationController?.pushViewController(createVC, animated: true)
    }
    
//MARK: - ACTIONS
    
    @IBAction func plusButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let createStopVC = storyboard.instantiateViewController(identifier: "CreateStopViewController") as! CreateStopViewController
        createStopVC.delegate = self
        createStopVC.travelId = travel?.id ?? ""
        navigationController?.pushViewController(createStopVC, animated: true)
    }
    
    
    @IBAction func backClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func emptyList() {
        if travel?.stops.isEmpty == true {
            noAnyStops.isHidden = false
        } else {
            noAnyStops.isHidden = true
        }
    } 
}
