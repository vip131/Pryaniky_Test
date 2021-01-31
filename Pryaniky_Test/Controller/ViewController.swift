


import UIKit

class ViewController: UIViewController {
    
    @IBAction func butt(_ sender: UIButton) {
        print(selectorsArr)
        configurateStack()
    }
    
    
    let networkManger = NetworkManager()
    var stackView = UIStackView.init()
    var selectorsArr = [(id: Int,text: String)]()
    var textBlock = UITextView()
    var selectedSegment : Int?
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
          fetch()
        configurateStack()
    }
    
    
    func configurateStack() {
        DispatchQueue.main.async {
            self.stackView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            let segmentedControl = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            segmentedControl.selectedSegmentTintColor = .red
            
            
            for  (index, _) in self.selectorsArr.enumerated() {
                segmentedControl.insertSegment(withTitle: self.selectorsArr[index].text, at: index, animated: true)
                
            }
            if let selectedID = self.selectedSegment {
                segmentedControl.selectedSegmentIndex = selectedID
            }
            self.stackView.addArrangedSubview(segmentedControl)
            self.view.addSubview(self.stackView)
        }
        
    }
    
    
    func fetch() {
        networkManger.fetchData { (model) in
            let views = model.view
            let data = model.data
            for model in data {
                if model.name == "hz" {
                    print("text")
                    if let safeText = model.data.text {
                        print(safeText)
                    }
                } else if model.name == "picture" {
                    print("picture")
                    if let safePictureUrl = model.data.url{
                        print(safePictureUrl)
                    }
                } else if model.name == "selector" {
                    print("selector")
                    if let selectedID = model.data.selectedID {
                        self.selectedSegment = selectedID
                        print(selectedID)
                    }
                    if let selectors = model.data.variants {
                        for selector in selectors {
                            let select = (selector.id, selector.text)
                            print(selector.id, selector.text)
                            self.selectorsArr.append(select)
                        }
                    }
                }
            }
        }
    }
    
}
