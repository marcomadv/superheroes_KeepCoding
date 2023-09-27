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
            let response = try XCTUnwrap( self.urlResponseTest())
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
        let urlHeroe = URL.init(string: "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/Roshi.jpg?width=300")!
        let heroeExpected = Hero(id: "14BB8E98-6586-4EA7-B4D7-35D6A63F5AA3",
                                 name: "Maestro Roshi",
                                 description: "Es un maestro de artes marciales que tiene una escuela, donde entrenará a Goku y Krilin para los Torneos de Artes Marciales. Aún en los primeros episodios había un toque de tradición y disciplina, muy bien representada por el maestro. Pero Muten Roshi es un anciano extremadamente pervertido con las chicas jóvenes, una actitud que se utilizaba en escenas divertidas en los años 80. En su faceta de experto en artes marciales, fue quien le enseñó a Goku técnicas como el Kame Hame Ha",
                                 photo: urlHeroe,
                                 favorite: false)

        MockURLProtocol.requestHandler = { request in
            
            let path = Bundle(for: type(of: self)).path(forResource: "heroes", ofType: "json")
            if path == nil {
                XCTFail("Expected find heroes json file")
            }
            let url = URL.init(filePath: path!)
            let data = try? Data.init(contentsOf: url)
            XCTAssertNotNil(data, "Fail decoding heroes")
            
            XCTAssertEqual(request.httpMethod, "POST")

            let response = try XCTUnwrap( self.urlResponseTest())

            return (response, data!)
        }

        let expectation = expectation(description: "Got Heroes")
        sut.getHeroes { result in
            
            switch result {
            case let .success(heroes):
                XCTAssertEqual(heroes.count, numHeroesExpected)
                XCTAssertEqual(heroes.first?.id, heroeExpected.id)
                XCTAssertEqual(heroes.first?.name, heroeExpected.name)
                XCTAssertEqual(heroes.first?.description, heroeExpected.description)
                XCTAssertEqual(heroes.first?.photo, heroeExpected.photo)
                XCTAssertEqual(heroes.first?.favorite, heroeExpected.favorite)
                expectation.fulfill()
            case let .failure(error):
                XCTFail("Sould be success the result service \(error.localizedDescription)")
             }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetTransformations() {
        
        let numTransformationsExpected = 14
        let urlTransformations = URL.init(string: "https://areajugones.sport.es/wp-content/uploads/2021/05/ozarru.jpg.webp")!
        let transformationsExpected = Transformation(id: "17824501-1106-4815-BC7A-BFDCCEE43CC9",
                                                     name: "1. Oozaru – Gran Mono",
                                                     description: "Cómo todos los Saiyans con cola, Goku es capaz de convertirse en un mono gigante si mira fijamente a la luna llena. Así es como Goku cuando era un infante liberaba todo su potencial a cambio de perder todo el raciocinio y transformarse en una auténtica bestia. Es por ello que sus amigos optan por cortarle la cola para que no ocurran desgracias, ya que Goku mató a su propio abuelo adoptivo Son Gohan estando en este estado. Después de beber el Agua Ultra Divina, Goku liberó todo su potencial sin necesidad de volver a convertirse en Oozaru",
                                                     photo: urlTransformations)
        let heroIdTest = "D13A40E5-4418-4223-9CE6-D2F9A28EBE94"

        MockURLProtocol.requestHandler = { request in
            
            let path = Bundle(for: type(of: self)).path(forResource: "transformations", ofType: "json")
            if path == nil {
                XCTFail("Expected find transformations json file")
            }
            let url = URL.init(filePath: path!)
            let data = try? Data.init(contentsOf: url)
            XCTAssertNotNil(data, "Fail decoding transformations")
            
            XCTAssertEqual(request.httpMethod, "POST")

            let response = try XCTUnwrap( self.urlResponseTest())

            return (response, data!)
        }

        let expectation = expectation(description: "Got Transformations")
        sut.getTransformations(for: heroIdTest) { result in
            switch result {
            case let .success(transformations):
                XCTAssertEqual(transformations.count, numTransformationsExpected)
                XCTAssertEqual(transformations.first?.id, transformationsExpected.id)
                XCTAssertEqual(transformations.first?.name, transformationsExpected.name)
                XCTAssertEqual(transformations.first?.description, transformationsExpected.description)
                XCTAssertEqual(transformations.first?.photo, transformationsExpected.photo)
                expectation.fulfill()
            case let .failure(error):
                XCTFail("Sould be success the result service \(error.localizedDescription)")
            }
        }
        wait(for: [expectation], timeout: 1)
    }


    
    
    private func urlResponseTest() -> HTTPURLResponse? {
        HTTPURLResponse(
            url: URL(string: "https://dragonball.keepcoding.education")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )
    }
}

