//
//  Network.swift
//  KIWI
//
//  Created by Karthik on 08/12/2016.
//  Copyright © 2016 Karthik. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import Marshal


/// A networking layer that handles the resource request and appropriately provides the required `RxSwift` `Observable`.
public struct KIWINetwork<ResourceType> where ResourceType: Model {

    /// Processes the request for a certain resource and provides results from the API.
    ///
    /// - Parameter resource: Resource that is requested.
    /// - Returns: An `Observable` to monitor the request.
    public func request(resource: KIWIAPI) -> Observable<ResourceType?> {
        return Observable<ResourceType?>.create { (observer) -> Disposable in
            let requestReference = Alamofire.request(resource.url(),
                                                     method: resource.method,
                                                     parameters: resource.parameters,
                                                     encoding: resource.encoding,
                                                     headers: resource.headerParameters
            ).responseJSON(completionHandler: {
                (response) in
                switch response.result {
                case .success(let json):
                    let resourceHandler = KIWIAPIResource<ResourceType>(api: resource)
                    if let jsonValue = json as? MarshaledObject {
                        let finalResource = resourceHandler.parse(object: jsonValue)
                        observer.onNext(finalResource)
                    } else {
                        observer.onNext(nil)
                    }
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            })
            return Disposables.create(with: { requestReference.cancel() })
        }
    }
}
