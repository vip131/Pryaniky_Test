


import UIKit

class ViewController: UIViewController {
    
    
    let networkManger = NetworkManager()
    var stackView = UIStackView.init()
    var selectorsArr = [(id: Int,text: String)]()
    var textBlock : String?
    var selectedSegment : Int?
    var photoName: String?
    var photoUrl: String?
    var views : [String]?
    var uiViews = [UIView]()
    
    
    
    override func viewDidLoad() {
        networkManger.delegate = self
        print("didload")
        fetch()
        
        
    }
    
    @IBAction func ddd(_ sender: UIButton) {
        configurateStack()
    }
    
    func configurateStack() {
        DispatchQueue.main.async {
            //MARK: - StackView Setup
            self.stackView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            self.stackView.axis = .vertical
            self.stackView.alignment = .fill
            self.stackView.distribution = .fillEqually
            
            //MARK: - ImageView setup
            let imageView =  UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            imageView.accessibilityLabel = self.photoName
            self.getImage(from: self.photoUrl, to: imageView)
            
            
            
            
            
            
            //MARK: - TextView Setup
            let textView = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            if let safeText = self.textBlock {
                textView.text = safeText
            }
            
            
            
            //MARK: - Segmented COntrol SetUp
            let segmentedControl = UISegmentedControl(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            segmentedControl.selectedSegmentTintColor = .red
            
            for  (index, _) in self.selectorsArr.enumerated() {
                segmentedControl.insertSegment(withTitle: self.selectorsArr[index].text, at: index, animated: true)
            }
            
            if let selectedID = self.selectedSegment {
                segmentedControl.selectedSegmentIndex = selectedID
            }
            
            //MARK: - Adding to StackView
            for view in self.views! {
                switch view {
                case "hz" : self.uiViews.append(textView)
                case "selector": self.uiViews.append(segmentedControl)
                case "picture": self.uiViews.append(imageView)
                default:
                    print("error")
                }
                
            }
            
            for view in self.uiViews {
                self.stackView.addArrangedSubview(view)
            }
            
            
            //MARK: - Add stackView to mainView
            self.view.addSubview(self.stackView)
            self.view.reloadInputViews()
        }
        
    }
    
    
    func fetch() {
        print("fetch")
        networkManger.fetchData { (model) in
            let views = model.view
            self.views = views
            let data = model.data
            for model in data {
                if model.name == "hz" {
                    print("text")
                    if let safeText = model.data.text {
                        print(safeText)
                        self.textBlock = safeText
                    }
                } else if model.name == "picture" {
                    print("picture")
                    if let safePictureUrl = model.data.url, let safePictureName = model.data.text{
                        print(safePictureUrl)
                        print(safePictureName)
                        self.photoName = safePictureName
                        self.photoUrl = safePictureUrl
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
        print("end fetch")
        
    }
    
    
    func getImage(from string: String?, to view: UIImageView) {
        if let urlString =  string {
            if  let url = URL(string: urlString) {
                let session = URLSession.init(configuration: .default)
                let task = session.dataTask(with: url) { (data, responce, error) in
                    if error != nil {
                        print("error when get image data")
                    }
                    if let safeData = data {
                        DispatchQueue.main.async {
                            let image = UIImage(data: safeData)
                            view.image = image
                        }
                        
                    }
                    
                }
                task.resume()
            }
            
        }
    }
    
    
    
    
    
    
    
}

extension ViewController: UIUpdateProtocol {
    func updateUI(_ networkManager: NetworkManager, data: PryanikyData) {
        configurateStack()
    }
    
    
}
