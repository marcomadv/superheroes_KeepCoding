//
//  NetworkModelTests.swift
//  SuperHeroesTests
//
//  Created by Marco Muñoz on 21/9/23.
//

import XCTest
@testable import SuperHeroes

final class NetworkModelTests: XCTestCase {
    private var sut: NetworkModel!
    private let expectedToken = "Some Token"
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: configuration)
        sut = NetworkModel(session: session)
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    
    func testLogin() {
        
        let someUser = "SomeUser"
        let somePassword = "SomePassword"
        
        MockURLProtocol.requestHandler = { request in
            let loginString = String(format: "%@:%@", someUser, somePassword)
            let loginData = loginString.data(using: .utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(
                request.value(forHTTPHeaderField: "Authorization"),
                "Basic \(base64LoginString)"
            )
            
            let data = try XCTUnwrap(self.expectedToken.data(using: .utf8))
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            return (response, data)
        }
        
        let expectation = expectation(description: "Login success")
        sut.login(
            user: someUser,
            password: somePassword
        ) { result in
            guard case let .success(token) = result else {
                XCTFail("Expected success but received \(result)")
                return
            }
            
            XCTAssertEqual(token, self.expectedToken)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetHeroes() {
        
        let numHeroesExpected = 15

        MockURLProtocol.requestHandler = { request in
            
            let path = Bundle(for: type(of: self)).path(forResource: "heroes", ofType: "json")
            if path == nil {
                XCTFail("Expected find heroes json file")
            }
            let url = URL.init(filePath: path!)
            let data = try? Data.init(contentsOf: url)
            XCTAssertNotNil(data, "Fail decoding heroes")
            
            XCTAssertEqual(request.httpMethod, "POST")
            XCTAssertEqual(
                request.value(forHTTPHeaderField: "Authorization"),
                "Bearer \(self.expectedToken)"
            )
            let response = try XCTUnwrap(
                HTTPURLResponse(
                    url: URL(string: "https://dragonball.keepcoding.education")!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: ["Content-Type": "application/json"]
                )
            )
            return (response, data!)
        }
        
        let expectation = expectation(description: "Got Heroes")
        sut.getHeroes { result in
            
            switch result {
            case .success(let heroes):
                XCTAssertEqual(heroes.count, numHeroesExpected)
                expectation.fulfill()
            case.failure(let error):
                debugPrint(error)                }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    
}

final class MockURLProtocol: URLProtocol {
    static var error: NetworkModel.NetworkError?
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        guard let handler = MockURLProtocol.requestHandler else {
            assertionFailure("Received unexpected request with no handler")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
            
        }
    }
    
    override func stopLoading(){ }
    
}
