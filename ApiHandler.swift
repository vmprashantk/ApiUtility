
//

import Foundation
import Alamofire


var header = [String:String]()

//MARK:-- Make get requset
func getData(url:String,parameter:[String:String]?,header:[String:String]?,isLoader:Bool,msg:String, completion:@escaping (NSDictionary?)->()){
    print(url)

    if(isLoader){
        
        Indicator.shared().start(msg: msg)
    }
    
    Alamofire.request(url, method: .get, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON
        {
            response in
             Indicator.shared().stop()
            switch(response.result)
            {
            case .success(_):
                print(response.result.value)
                if let data = response.result.value as? NSDictionary{
                    
                    print(data)
                        
                    completion(data)
                    
                 
                }
                else{
                    completion(nil)
                }
                
                break
            case .failure(let error):
                
                print(error.localizedDescription)
                    completion(nil)
                break
                
           
            }
            
            
    }
    
}

func getDataArray(url:String,parameter:[String:String]?,header:[String:String]?,isLoader:Bool,msg:String, completion:@escaping (NSArray?,Int)->()){
    print(url)
    
    if(isLoader){
        
        Indicator.shared().start(msg: msg)
    }
    
    Alamofire.request(url, method: .get, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON
        {
            response in
            Indicator.shared().stop()
            switch(response.result)
            {
            case .success(_):
                print(response.result.value)
                if let data = response.result.value as? NSArray{
                    
                    print(data)
                    
                    completion(data,(response.response?.statusCode)!)
                    
                    
                }
                else{
                    completion(nil,(response.response?.statusCode)!)
                }
                
                break
            case .failure(let error):
                
                print(error.localizedDescription)
                completion(nil,0)
                break
                
                
            }
            
            
    }
    
}


//MARK:-- Make post requset

func postData(url:String,parameter:[String:Any]?,header:[String:String]?,isLoader:Bool,msg:String, completion:@escaping (NSDictionary?)->()){
    
    print(url)
    
 
    if(isLoader){
        
        Indicator.shared().start(msg: msg)
    }
    Alamofire.request(url, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: header).responseJSON
        {
            
            response in
       
            
            let str = String(data: response.data!, encoding: String.Encoding.utf8)
              Indicator.shared().stop()
            switch(response.result)
            {
            case .success(_):
                
                if let data = response.result.value as? NSDictionary{
                    
                    print(data)
                    completion(data)
                }
                else{
                    completion(nil)
                }
                
                break
            case .failure(_):
                
                completion(nil)
                break
                
                
            }
            
            
    }
    
    
}

func postDataWithImage(url:String,parameter:[String:Any]?,header:[String:String]?,imageDict:[String:UIImage]?,isLoader:Bool,msg:String, completion:@escaping (NSDictionary?)->()){
    
    
    if(isLoader){
        
        Indicator.shared().start(msg: msg)
    }
    print(url)
    print(parameter)
    print(header)
    print(imageDict)
    
    Alamofire.upload(multipartFormData: { (multipartFormData) in
        
        if(imageDict != nil){
            for (key, value) in imageDict!{
        /*multipartFormData.append(UIImageJPEGRepresentation(value as UIImage, 1)!, withName: "\(key)", fileName: "\(key).jpeg", mimeType: "image/jpeg")
        }*/
        
            multipartFormData.append(UIImagePNGRepresentation(value as UIImage)!, withName: "\(key)", fileName: "\(key).png", mimeType: "image/png")
    }
        }
       
        if let param = parameter{
        for (key, value) in param {
            
          
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
         
            
            }
           
           
        }
        
    },  usingThreshold:UInt64.init(), to:url,method:.post,
       headers:header)
    { (result) in
        switch result {
        case .success(let upload, _, _):
            
            upload.uploadProgress(closure: { (progress) in
                
               
            })
            
            upload.responseJSON { response in
                 Indicator.shared().stop()
              
                if let data = response.result.value as? NSDictionary{
                    
                    print(data)
                    completion(data)
                }
                else{
                    completion(nil)
                }
            }
            
        case .failure(let encodingError):
              Indicator.shared().stop()
            print(encodingError.localizedDescription)
               completion(nil)
            break
        
        }
    }
    
}



