


import UIKit

class ViewController: UIViewController {
    
    let networkManger = NetworkManager()
    var stackView = UIStackView.init()
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManger.fetchData { (model) in
            let views = model.view
            print(views)
        }
    }
    
    
    func configurateStack(with data: NetworkManager) {
        
    }
    
}
