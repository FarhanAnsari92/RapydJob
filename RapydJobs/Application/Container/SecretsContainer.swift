//
//  SecretsContainer.swift
//  RapydJobs
//
//  Created by Maroof Khan on 27/07/2018.
//  Copyright © 2018 chymps. All rights reserved.
//

import Foundation

protocol SecretsProvider {
    var clientSecret: Token { get }
}

final class SecretsContainer: SecretsProvider {
     var clientSecret: Token {
        //XQ9RMClrXAs30mbwSwn5VuaQmdwl1QXCZAr5PJaY Old
        return Token(value: "rB8peYmMwtNEmtLQs3QTAAorVzHthy0EHd2yja4m")
    }
}
