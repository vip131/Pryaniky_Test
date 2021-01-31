


import UIKit

class ViewController: UIViewController {
    
    
    let networkManger = NetworkManager()
    var stackView = UIStackView.init()
    var selectorsArr = [(id: Int,text: String)]()
    var textBlock : String?
    var selectedSegment : Int?
    var photoName: String?
    var photoUrl: String?
    var views : [UIView]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
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
            
            self.stackView.addArrangedSubview(segmentedControl)
            self.stackView.addArrangedSubview(textView)
            self.stackView.addArrangedSubview(imageView)
            //MARK: - Add stackView to mainView
            self.view.addSubview(self.stackView)
            self.view.reloadInputViews()
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
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    
    
}
