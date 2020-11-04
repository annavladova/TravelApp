
import UIKit
import Firebase
import FirebaseDatabase
import SwipeCellKit
import RealmSwift


//мы тут добавили протоколы, они дают нам 2 системных метода

class TravelListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    
    // MARK: - OUTLETS
    //создаем аутлет таблицы
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: DotsActivityIndicator!
    @IBOutlet weak var noAnyTravel: UILabel!
    
    
    // MARK: - PROPERTIES
    var travels: [Travel] = []
    
    
    // MARK: - LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getTravelsFromServer()
        getStopsFromServer()
        loadingView.tintColor = .systemBlue
        navigationItem.hidesBackButton = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - TABLEVIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    // функции надо вернуть сколько элементов надо отображать на экране из таблицы, таблица просит всегда эти 2 обязательные штуки, сколько и какие
    
    // ЭТА ФУНКЦИЯ ВЫЗЫВАЕТСЯ СИСТЕМОЙ КАЖДЫЙ РАЗ КОГДА У НАС ХОЧЕТ ПОЯВИТЬСЯ ЯЧЕЙКА мы скролим должна появится новая ячейка снизу и вызывается этот метод чтобы мы заполнили ее новыми данными. то есть система нам отдает ячейку, у нее есть параметры(таблица и индекс пасс(структура с роу и секшн) секшн всегда 0, а роу - это индекс текущего элемента. если ячейка нулевая.
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TravelCell", for: indexPath) as! TravelCell
        cell.delegate = self
        let travel = travels[indexPath.row]
        cell.nameLable.text = travel.name
        cell.descriptionLabel.text = travel.description
        
        cell.firstStarTravel.image = UIImage(named: "Star Icon-1")
        cell.secondStarTravel.image = UIImage(named: "Star Icon-1")
        cell.thirdStarTravel.image = UIImage(named: "Star Icon-1")
        cell.forthStarTravel.image = UIImage(named: "Star Icon-1")
        cell.fifthStarTravel.image = UIImage(named: "Star Icon-1")
        
        let resultRating: Int = travel.avarageRate
        print(resultRating)
        
        switch resultRating {
        case 1:
            cell.firstStarTravel.image = UIImage(named: "Star")
        case 2:
            cell.firstStarTravel.image = UIImage(named: "Star")
            cell.secondStarTravel.image = UIImage(named: "Star")
        case 3:
            cell.firstStarTravel.image = UIImage(named: "Star")
            cell.secondStarTravel.image = UIImage(named: "Star")
            cell.thirdStarTravel.image = UIImage(named: "Star")
        case 4:
            cell.firstStarTravel.image = UIImage(named: "Star")
            cell.secondStarTravel.image = UIImage(named: "Star")
            cell.thirdStarTravel.image = UIImage(named: "Star")
            cell.forthStarTravel.image = UIImage(named: "Star")
        case 5:
            cell.firstStarTravel.image = UIImage(named: "Star")
            cell.secondStarTravel.image = UIImage(named: "Star")
            cell.thirdStarTravel.image = UIImage(named: "Star")
            cell.forthStarTravel.image = UIImage(named: "Star")
            cell.fifthStarTravel.image = UIImage(named: "Star")
        default:
            print("0")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let stopVC = storyboard.instantiateViewController(identifier: "StopListViewController") as! StopListViewController
        stopVC.travel = travels[indexPath.row]
        navigationController?.pushViewController(stopVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Удалить") { action, indexPath in
            let travel = self.travels[indexPath.row]
            self.travels.remove(at: indexPath.row)
            self.emptyList() //++++++++++++++++++++++++++++++++++++++++
            self.tableView.reloadData()
            
            let database = Database.database().reference()
            for stop in travel.stops {
                database.child("stops").child(stop.id).removeValue()
            }
            let child = database.child("travels").child("\(travel.id)")
            child.removeValue()
        }
        
        
        let editAction = SwipeAction(style: .default, title: "Изменить") { action, indexPath in
            let travel = self.travels[indexPath.row]
            let alertController = UIAlertController(title: "Изменить путешествие", message: "", preferredStyle: .alert)
            
            alertController.addTextField { (textField: UITextField!) -> Void in
                textField.text = travel.name
            }
            alertController.addTextField { (textField: UITextField!) -> Void in
                textField.text = travel.description
            }
            
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
            alertController.addAction(cancelAction)
            
            let saveAction = UIAlertAction(title: "Сохранить", style: .default, handler: { alert -> Void in
                let newName = alertController.textFields![0] as UITextField
                let newDescription = alertController.textFields![1] as UITextField
                
                let id = travel.id
                let userId = travel.userId
                let newTravel = Travel(userId: userId, id: id, name: newName.text ?? "", description: newDescription.text ?? "")
                
                self.travels[indexPath.row] = newTravel
                self.tableView.reloadData()
                self.sendToServer(travel: newTravel)
            })
            
            alertController.addAction(saveAction)
            self.present(alertController, animated: true, completion: nil)
        }
        return [deleteAction, editAction]
    }
    
    
    //MARK: - ACTIONS
    
    @IBAction func createTravelAlertClicked(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Новое путешествие", message: "Введите название и описание", preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Название страны"
        }
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Описание"
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default, handler: { alert -> Void in
            let newName = alertController.textFields![0] as UITextField
            let newDescription = alertController.textFields![1] as UITextField
            
            let id = UUID().uuidString //генератор айдишников
            let userId = Auth.auth().currentUser?.uid
            let newTravel = Travel.init(userId: userId ?? "", id: id, name: newName.text ?? "", description: newDescription.text ?? "") // может не работать опционал юзерайди
            
            self.travels.append(newTravel)
            self.emptyList()
            self.tableView.reloadData()
            self.sendToServer(travel: newTravel)
            DatabaseManager.shared.saveTravelInDatabase(newTravel)
        })
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: { (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //!!!!!!!!!!!!! таблицы и коллекшн вью не работают если не указать им делегат и датасорс!!!!!!!!!!!!!!!!!!!!!!!! выше отметила восклицательными знаками
    
    // MARK: - FUNCTIONS
    
    //    функция отправки на сервер фаербэйз наши трэвелы
    //    в папку тревел на фаербейзе пытаемся сохранить ребенка со своим айдишником который мы сами и создали
    
    func sendToServer(travel: Travel) {
        let database = Database.database().reference()
        let child = database.child("travels").child("\(travel.id)")
        
        self.loadingView.startAnimation()
        
        child.setValue(travel.json) { (error, ref) in
            print(error, ref) // в консоли по этой ссылке будет nil если ошибок нет
            
            self.loadingView.stopAnimation()
        }
    }
    
    func getTravelsFromServer() {
        let database = Database.database().reference()
        database.child("travels").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            print(value.values)
            for item in value.values {
                if let travelJson = item as? [String: Any] {
                    if let id = travelJson["id"] as? String,
                       let name = travelJson["name"] as? String,
                       let description = travelJson["description"] as? String,
                       let userId = Auth.auth().currentUser?.uid {
                        let travel = Travel(userId: userId, id: id, name: name, description: description)
                        self.travels.append(travel)
                        self.tableView.reloadData()
                        self.emptyList()
                    }
                }
            }
        }
    }
    
    func getStopsFromServer() {
        let database = Database.database().reference()
        database.child("stops").observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            for item in value.values {
                if let stopJson = item as? [String: Any] {
                    if let id = stopJson["id"] as? String,
                       let travelId = stopJson["travelId"] as? String,
                       let name = stopJson["name"] as? String,
                       let description = stopJson["description"] as? String,
                       let rating = stopJson["rating"] as? Int,
                       let locationString = stopJson["location"] as? String,
                       let spendMoney = stopJson["spendMoney"] as? Double,
                       let currencyString = stopJson["currency"] as? String,
                       let transportInt = stopJson["transport"] as? Int {
                        
                        var location: CGPoint = .zero
                        let components = locationString.components(separatedBy: "-")
                        if let x = Double(components.first!), let y = Double(components.last!) {
                            location = CGPoint(x: x, y: y)
                        }
                        
                        let currency = Currency(rawValue: currencyString)!
                        let stop = Stop(id: id, travelId: travelId, name: name, rating: rating, location: location, description: description, spendMoney: spendMoney, currency: currency)
                        stop.transport = Transport(rawValue: transportInt)!
                        
                        for travel in self.travels {
                            if travel.id == travelId {
                                travel.stops.append(stop)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func emptyList() {
        if travels.isEmpty {
            noAnyTravel.isHidden = false
        } else {
            noAnyTravel.isHidden = true
        }
    }
    
    
    
    
}






