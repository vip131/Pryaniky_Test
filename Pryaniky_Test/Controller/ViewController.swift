


import UIKit

class ViewController: UIViewController {
    let networkManger = NetworkManager()
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.selectedSegmentTintColor = .red
        if let selectedID = self.selectedSegment {
            segmentedControl.selectedSegmentIndex = selectedID
            segmentedControl.addTarget(self, action: #selector(selectorChangeValue), for: .valueChanged)
        }
        return segmentedControl
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(frame: CGRect(x: 0,y: 0,
                                              width: self.view.bounds.width,
                                              height: self.view.bounds.height))
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 60
        return stack
    }()
    
    lazy var imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.accessibilityLabel = self.photoName
        self.getImage(from: self.photoUrl, to: imgView)
        return imgView
    }()
    
    lazy var textView : UILabel = {
        let textView = UILabel()
        textView.text = self.textBlock
        return textView
    }()
    
    private var selectorsArr = [(id: Int,text: String)]()
    private var textBlock : String?
    private var selectedSegment : Int?
    private var photoName: String?
    private var photoUrl: String?
    private var views : [String]!
    private var uiViews = [UIView]()
    
    override func viewDidLoad() {
        networkManger.delegate = self
        networkManger.fetchData()
    }
    
    func configurateStack() {
        DispatchQueue.main.async {
            //MARK: - Segmented COntrol SetUp
            for (index, _) in self.selectorsArr.enumerated() {
                self.segmentedControl.insertSegment(withTitle: self.selectorsArr[index].text,
                                                    at: index,
                                                    animated: true)
                self.segmentedControl.selectedSegmentIndex = self.selectedSegment!
            }
            //MARK: - Adding to StackView
            for view in self.views {
                switch view {
                case "hz" : self.stackView.addArrangedSubview(self.textView)
                case "selector": self.stackView.addArrangedSubview(self.segmentedControl)
                case "picture": self.stackView.addArrangedSubview(self.imageView)
                default:
                    print("error in configurateStack Method ")
                }
            }
            //MARK: - Add stackView to mainView
            self.view.addSubview(self.stackView)
        }
    }
    
    //MARK: - GetImage -
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
    
    //MARK: - Touches Began -
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: view)
            if self.imageView.frame.contains(position) {
                print("->ImageView")
            }
            if self.textView.frame.contains(position) {
                print("->Text")
            }
        }
    }
    
    //MARK: - Actions -
    @objc func selectorChangeValue(sender: UISegmentedControl) {
        print("Selected segment -> \(sender.selectedSegmentIndex)")
    }
    
}


//MARK: - UIUpdateProtocolDelegate -
extension ViewController: UIUpdateProtocol {
    func didUpdateUI(_ networkManager: NetworkManager, data: PryanikyData) {
        self.views = data.view
        let data = data.data
        for model in data {
            if model.name == "hz" {
                if let safeText = model.data.text {
                    self.textBlock = safeText
                }
            } else if model.name == "picture" {
                if let safePictureUrl = model.data.url,
                    let safePictureName = model.data.text {
                    self.photoName = safePictureName
                    self.photoUrl = safePictureUrl
                }
            } else if model.name == "selector" {
                if let selectedID = model.data.selectedID {
                    self.selectedSegment = selectedID
                }
                if let selectors = model.data.variants {
                    for selector in selectors {
                        let select = (selector.id, selector.text)
                        self.selectorsArr.append(select)
                    }
                }
            }
        }
        configurateStack()
    }
}
