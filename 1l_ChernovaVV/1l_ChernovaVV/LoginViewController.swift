import UIKit

class Session {
    
    static let instanse = Session()
    
    private init(){}
    
    var token = ""
    var userId = 0
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        //присваиваем его UIScrollView
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }
    
    
     //Функция, исполняющая проверку без сегвея, но с активностью кнопки Sign In
     
     @IBAction func loginButtonPressed(_ sender: Any) {
        // Проверяем, верны ли введенные данные
        
        buttonLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        }
        
        let checkResult = checkUserData()
        
        if !checkResult {
            showLoginError()
        }
        
        let session = Session.instanse
        session.token = "admin"
        session.userId = 0
    }
    
    func checkUserData() -> Bool {
        let login = loginInput.text!
        let password = passwordInput.text!
        
        if login == "1" && password == "1" {
            return true
        } else {
            return false
        }
    }
    
    func showLoginError() {
        // Создаем контроллер
        let alter = UIAlertController(title: "Ошибка", message: "Введены не верные данные пользователя", preferredStyle: .alert)
        // Создаем кнопку для UIAlertController
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        // Добавляем кнопку на UIAlertController
        alter.addAction(action)
        // Показываем UIAlertController
        present(alter, animated: true, completion: nil)
    }
    
    func buttonLoading() {
        //темная задняя текстовая метка
        let darkTextLabel = UILabel()
        darkTextLabel.text = "..."
        darkTextLabel.textColor = UIColor(white: 0, alpha: 0.1)
        darkTextLabel.font = UIFont.systemFont(ofSize: 180)
        darkTextLabel.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 500)
        darkTextLabel.textAlignment = .center
        
        view.addSubview(darkTextLabel)
        
        //светлая передняя текстовая метка
        let shinyTextLabel = UILabel()
        shinyTextLabel.text = "..."
        shinyTextLabel.textColor = .blue
        shinyTextLabel.font = UIFont.systemFont(ofSize: 180)
        shinyTextLabel.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: 500)
        shinyTextLabel.textAlignment = .center
//                shinyTextLabel.backgroundColor = .red
        
        view.addSubview(shinyTextLabel)
        
        //рисуем градиент
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.blue.cgColor, UIColor.clear.cgColor]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = shinyTextLabel.frame
        
        
        let angle = 60 * CGFloat.pi / 180
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        
        shinyTextLabel.layer.mask = gradientLayer
        
        //анимация
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 2
        animation.fromValue = -view.frame.width
        animation.toValue = view.frame.width
        animation.repeatCount = Float.infinity
        
        gradientLayer.add(animation, forKey: "-")
//        view.layer.addSublayer(gradientLayer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
        
        //Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets (top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        //Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
        
    }
    
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden (notification: Notification) {
        
        //Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    //Подписка на уведомления от клавиатуры
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Подписываемся на два уведомления: одно приходит при повлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //Второе - когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //Отписка
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }

}
