import Foundation
import PromiseKit
import Moya

class PromiseKitWrapper {
    static func callAPI<T: TargetType, C: Codable>(provider: MoyaProvider<T>, target: T, response: C.Type = C.self) -> Promise<C> {
        return Promise<C> { seal in
            provider.request(target) { (result) in
                switch result {
                case let .success(response):
                    let data = response.data
                    do {
                        let jsonResponse: C = try JSONDecoder().decode(C.self, from: data)
                        seal.fulfill(jsonResponse)
                            // Do something with your json.
                    }
                    catch let error {
                        // Here we get either statusCode error or jsonMapping error.
                        // TODO: handle the error == best. comment. ever.
                        seal.reject(error)
                        print(String(decoding: response.data, as: UTF8.self))
                        print("Error: \(error)")
                    }
                case let .failure(error):
                    print("Error .failure: \(error)")
                }
            }
        }
    }
}
