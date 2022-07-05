# UtilityPackage

UtilityPackage priovides the necessary classes, extensions, protocols and helpers for your swift project. You can speed up your development time and save lines of code by using this package.

UtilityPackage offers many things here are the details and usage examples.
## Installation
## Swift Package Manager
Go to `File | Swift Packages | Add Package Dependency...` in Xcode and search for "UtilityPackage".
```swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/irshad281/UtilityPackage")
    ],
)
```

# NetworkManager
It's a advance NetworkInterface to execute your web services, it developed over combine framework, This single class is itself enough to fulfill all your web services requrements. You can easily modularize your web-serices.

## Request
You make make seperate request for your modules like this.
```swift
enum AuthRequest: Request {
    
    // MARK: - AuthRequest Request -
    case login(model: LoginParams)
    case signup(model: SignupParams)
    case userDetail(id: Int)
    case userArticles(id: Int)
    case search(q: String, size: Int, page: Int)
    
    // MARK: -
    var method: HTTPMethod {
        switch self {
        case .userDetail, .userArticles, .search:
            return .get
            
        default:
            return .post
        }
    }
    
    var version: APIVersion { .v1 }
    
    var baseURLString: String { App.url }
    
    var endPoint: String {
        switch self {
        case .login:
            return "/login"
        case .signup:
            return "/signup"
        case .userDetail(let id):
            return "/users/\(id)"
        case .search(let query, let size, let page):
            return "/news/search?q=\(query)&size=\(size)&page=\(page)"
        case .userArticles(let id):
            return "/users/article/\(id)"
        }
    }
    
    func body() throws -> Data? {
        switch self {
        case .login(let params):
            return try? params.asRequestBody()
        case .signup(let params):
            return try? params.asRequestBody()
        case .search, .detail, .relatedArticles:
            return nil
        }
    }
    
    func headers() -> Headers { App.shared.headers }
        
}
```

After creating your `request`, you can make your `service` implementation like this 

```swift
struct AuthService {
    static func loginWith(params: LoginParams) -> Future<LoginModel, RequestError> {
        NetworkManager.performRequest(AuthRequest.login(model: params))
    }
    
    static func signupWith(params: SignupParams) -> Future<SignupModel, RequestError> {
        NetworkManager.performRequest(NewsRequest.signup(model: params))
    }
    
    static func getUserDetailsWith(id: Int) -> Future<UserDetailModel, RequestError> {
        NetworkManager.performRequest(NewsRequest.userDetail(id: id))
    }
}
```

# ViewRegistrable:
This provides `identifier` and `nib` for your registrable classes like `UITablViewCell, UICollectionViewCell` etc.

Here is the default method to register your nib to `UITableView` and `UICollectionView`.

#### Default Implementation 

```swift
tableView.register(UINib(nibName: "YourClassName", bundle: nil), forCellReuseIdentifier: "YourCellIdentifier")
collectionView.register(UINib(nibName: "YourClassName", bundle: nil), forCellWithReuseIdentifier: "YourCellIdentifier")
```

Registering your cells becomes super easy in `UtilityPackage`, You just need to confirm your cells to `ViewRegistrable` and you can register your cells like this.

#### UtilityPackage Implementation 

```swift
tableView.register(YourCell.self)
collectionView.register(YourCell.self)
```

### Loading your cells become even more easy than the default implementation.

#### Default UITableViewCell Implementation 
```swift
guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellIdentifier") as? TableViewCell else {
      return UITableViewCell()
}
```

#### UtilityPackage: UITableViewCell Implementation 
```swift
let cell: TableViewCell = tableView.dequeCell()
```

#### Default UICollectionViewCell Implementation 
```swift
guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellIdentifier", for: indexPath) as? CollectionViewCell else {
      return UICollectionViewCell()
}
```

#### UtilityPackage: UICollectionViewCell Implementation 
`let cell: CollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)`

# XibLoadable:
XibLoadable is design to load `UIViewController` and `UIView` from xib.

#### Default UIViewController Implementation 

```swift
let controller = MyViewController(nibName: "MyViewController", bundle: nil)
```

#### UtilityPackage: UIViewController Implementation 
`let controller = MyViewController.instance`

#### Default UIView Implementation 

```swift
let view =  UINib(nibName: "nib file name", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MyView
```

#### UtilityPackage: UIView Implementation
`let view =  MyView.nib`

# ColorExtensions
ColorExtensions privide wide range of preadded colors and it has many useful methods like.
### Load color from hex code 
`let color = UIColor(hexString: "#f1f1f1")`

### Generate random color
`let color = UIColor.random`

### Get RGB componnets of a color
`let components = UIColor.random.rgbComponents`

### Get Hex Code of a color
`let code = UIColor.random.hexString`

### 200+ Pre Added Colors
```swift
UIColor.Social.facebook
UIColor.Social.googlePlus
UIColor.Social.skype
UIColor.CSS.aliceBlue
UIColor.CSS.antiqueWhite
UIColor.CSS.aqua
```
# JOSNDecoder.dateDecoder
An extension of JOSNDecoder which can handle your date parsing while decoding your models. for an example if your are getting date in web service 
```swift
{
  "id": 1,
  "title": "Title",
  "desc": "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
  "publicationDate": "2022-03-24T00:00:00Z"
}
```
You can directly take publicationDate as `let publicationDate: Date` in your model.
```swift
struct MyModel: Codable {
    let id: Int
    let title, desc: String
    let publicationDate: Date
}
```
and parse your model simply using the `JSONDecoder.dateDecoder` like this 

```swift
JSONDecoder.dateDecoder.decode(YourModel.self, from: data)
```
# LocationManager
Get User Location, Get Reverse GeoCoded Address From Location, Get Reverse GeoCoded Location From Address and many other operation becomes so very easy.

### 1. Get User Location

```swift
LocationManager.shared.getLocation { (location, error) in

    if let error = error {
        print(error)
        return
    }

    guard let location = location else { return }
    print("Location:", location)
}
```

### 2. Get User GeoCoded Address From CLLocation
```swift
LocationManager.shared.getReverseGeoCodedLocation(location: customLocation) { (location, placemark, error) in
    guard let location = location, let placemark = placemark else {
        return
    }
    let address = placemark.addressDictionary?["FormattedAddressLines"] as! NSArray
    self.addressLabel.text = address.description

}
```
### 3. Get User GeoCoded CLLocation From Address
```swift
led address = "3692 W Gandy Blvd, Tampa, FL 33611, United States"
LocationManager.shared.getReverseGeoCodedLocation(address: address, completionHandler: { (location, placemark, error) in
    guard let placemark = placemark else {
        print("Location can't be fetched")
        return
    }

    print("Placemark:", placemark)
    print("Location:", placemark.location)
})
```
# UserDefaultWrapper
Custom and advance way to store properties in app. Save default data type or any cusomt Codable object simply by property wrapper class like this.
```swift
struct PersistentManager {
    private struct Keys {
        static let accessToken = "3k35tkxrz506pxj9pfon"
        static let refreshToken = "ekn2t72p6kor0byqrwfw"
        static let userData = "5pvtizagcjx79z4o96qw"
    }
    
    @UserDefaultWrapper(key: Keys.accessToken)
    static var accessToken: String?
    
    @UserDefaultWrapper(key: Keys.refreshToken)
    static var refreshToken: String?
    
    @CodablePropertyWrapper(key: Keys.userData)
    static var userData: UserModel?

}
```
# DatePickerField
DatePickerField class provide the facility to pick a date or time in textfield in just few lines of code.

```swift
let birthdayTextField = DatePickerField()

birthdayTextField.dateChanged = { [weak self] selectedDate in
    guard let self = self else {
        return
    }
    print(selectedDate)
}
```

# Encodable Extension
Convert your models into Dictionary or in Data.
```swift
let userModel = UserModel()
// convert model into disctionary
let userModelDict = try? userModel.asDictionary()
// convert model into data
let userModelData = try? userModel.asRequestBody()
```
# OTPView
Taking otp input in the app easily by using OTPView class. It's fully customizable based on your requirements.

![OTP-View](https://user-images.githubusercontent.com/19393497/177251047-4659517f-6fd7-48d3-b767-696720ea549e.jpg)

# ImagePicker
It's a simple and easy to use class to pick photos from `camera` and `gallery`

### 1. Show Image picker with action sheet
Pass your view in parameter like `ImagePicker.shared.showImagePicker(from: view)` if you are running in iPad.
```swift
ImagePicker.shared.showImagePicker(from: nil) { pickedImage in
    if let image = pickedImage {
       // do your work with image..
    }
}
```

### 2. Pick Image from a source type like camera or gallery.
```swift
ImagePicker.shared.pickImage(from: .photoLibrary) { pickedImage in
    if let image = pickedImage {
        // do your work with image..
    }
}
```


https://user-images.githubusercontent.com/19393497/177253148-d18c7d86-9e5f-44e2-ad5a-39cd57c2afd4.mov

