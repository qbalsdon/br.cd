//
//  OutPanAPI.swift
//  brcd
//
//  Created by Quintin Balsdon on 2016/02/02.
//  Copyright © 2016 Balsdon. All rights reserved.
//
import CoreData

class OutpanAPI: NSObject {
    var session: NSURLSession!
    var userKey: String!
    
    var appId: String!
    
    let OutpanEndPoint = "https://api.outpan.com/v2/products/{BARCODE}?apikey={KEY}"
    
    let POST = "POST"
    let GET = "GET"
    
    static let sharedInstance = OutpanAPI()
    
    override init(){
        session = NSURLSession.sharedSession()
        if let path = NSBundle.mainBundle().pathForResource("ApiKey", ofType: "plist") {
            let keys = NSDictionary(contentsOfFile: path)
            if let _ = keys {
                appId = keys?["OutpanAppId"] as? String
            }
        }
        super.init()
    }
    
    //MARK: Generic API
    func apiCall(barcode: String, httpMethod: String!, httpBody: String!, onSuccess: (AnyObject!) -> (), onError: (String, String!) -> ()){
        let endPoint = OutpanEndPoint.stringByReplacingOccurrencesOfString("{BARCODE}", withString: barcode).stringByReplacingOccurrencesOfString("{KEY}", withString: appId)
        
        let url : NSURL = NSURL(string: endPoint)!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = httpMethod
        
        if (httpBody != nil){
            request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
        }
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    onError("Connection Error","Internet connectivity is down")
                }
                return
            }
            
            var parsingError: NSError? = nil
            let parsedResult: AnyObject!
            do {
                parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            } catch error! as NSError {
                parsingError = error
                parsedResult = nil
            } catch {
                print("\(parsingError)")
                fatalError()
            }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                onSuccess(parsedResult)
            }
            return
        }
        task.resume()
    }
    
    // MARK: - Method calls
    func getProduct(barcode: String, onSuccess: (ProductEntity!) -> (), onError: (String, String!) -> ()) {
        OutpanAPI.sharedInstance.apiCall(barcode, httpMethod: GET, httpBody: nil, onSuccess: {
            data in
                self.parseProduct(data, onSuccess: onSuccess, onError: onError)
            }, onError: onError)
    }
    
    // MARK: - Data parsing methods
    func parseProduct(parsedResult: AnyObject!,onSuccess: (ProductEntity!) -> (), onError: (String, String!) -> ()){
        let product = NSEntityDescription.insertNewObjectForEntityForName("ProductEntity", inManagedObjectContext: CoreDataStackManager.sharedInstance.managedObjectContext) as? ProductEntity
        if let name = parsedResult.valueForKey("name") as? String {
            product?.setValue(name, forKey: ProductEntity.FIELD.NAME.rawValue)
            if let attrs = parsedResult.valueForKey("attributes") as? NSDictionary {
                for (key, value) in attrs {
                    let attribute = NSEntityDescription.insertNewObjectForEntityForName("AttributeEntity", inManagedObjectContext: CoreDataStackManager.sharedInstance.managedObjectContext) as? AttributeEntity
                    attribute?.setValue(key, forKey: AttributeEntity.FIELD.NAME.rawValue)
                    attribute?.setValue(value, forKey: AttributeEntity.FIELD.VALUE.rawValue)
                    attribute?.setValue(product, forKey: AttributeEntity.FIELD.PRODUCT.rawValue)
                }
            }
            onSuccess(product)
            return
        }
        onError("Invalid / Empty data", "\(parsedResult)")
    }
}
