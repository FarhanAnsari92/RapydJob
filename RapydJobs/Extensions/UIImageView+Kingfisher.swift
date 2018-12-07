//
//  UIImageView+Kingfisher.swift
//  RapydJobs
//
//  Created by Muhammad Abdul Subhan on 28/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func setImageWithName(_ imageName: String, isCompleteUrl: Bool = false) {
        
        guard let token = AppContainer.shared.user.user?.accessToken else {
            print("token not found in Kingfisher")
            return
        }
        KingfisherManager.shared.defaultOptions = [.requestModifier(TokenPlugin(token:"Bearer \(token)"))]

        var url: URL
        if isCompleteUrl {
            url = URL(string: imageName)!
        } else {
            url = API.rapydPublic.getBaseURLForImage(imageName);
        }
        print("chat message ---- \(url.absoluteString)")
        self.kf.setImage(with: url, placeholder: UIImage(named: "Placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func setChatImageWithName(_ imageName: String) {
        
        let token = AppContainer.shared.user.token!
        KingfisherManager.shared.defaultOptions = [.requestModifier(TokenPlugin(token:"Bearer \(token)"))]
        
        let url = API.rapydPublic.getBaseURLForChatImage(imageName)
        
        self.kf.setImage(with: url, placeholder: UIImage(named: "Placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
    }
}

class TokenPlugin: ImageDownloadRequestModifier {
    let token:String
    
    init(token:String) {
        self.token = token
    }
    
    func modified(for request: URLRequest) -> URLRequest? {
        var request = request
        request.addValue(token, forHTTPHeaderField: "Authorization")
        return request
    }
}
