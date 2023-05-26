//
//  ServerProvider.swift
//  ResponseMocker
//
//  Created by Bror2 on 25/05/2023.
//

import Foundation
import Swifter

class ServerProvider: ObservableObject {
    @Published var isRunning = false
    @Published var mockeries: [Mockery] = []
    
    private var server: HttpServer?

    func start() {
        DispatchQueue.global(qos: .background).async {
            do {
                self.server = HttpServer()
                try self.configure(self.server!)
                try self.server!.start()

                DispatchQueue.main.async {
                    self.isRunning = true
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.isRunning = false
                }
            }
        }
    }

    func stop() {
        DispatchQueue.global(qos: .background).async {
            if (self.isRunning) {
                self.server?.stop()
                DispatchQueue.main.async {
                    self.isRunning = false
                }
            }
        }
    }
    
    func reboot() async {
        stop()
        try? await Task.sleep(for: .seconds(2))
        start()
    }

    private func configure(_ server: HttpServer) throws {

        for mockery in mockeries {

            if let statusCode = Int(mockery.statusCode) {
                server[mockery.endpoint] = { request in
                    return HttpResponse.raw(
                        statusCode,
                        mockery.responseDescription,
                        ["Content-Type": "application/json"]
                    ) { writer in
                        let body = mockery.responseBody
                        try writer.write(Array(body.utf8))
                    }
                }
            }

        }

    }
    
    func addMock() async {
        DispatchQueue.main.async {
            if (self.isRunning) {
                self.stop()
            }
            self.mockeries.append(Mockery())
        }
    }
}
