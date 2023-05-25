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
            self.server?.stop()
            DispatchQueue.main.async {
                self.isRunning = false
            }
        }
    }
    
    func reboot() async {
        stop()
        try? await Task.sleep(for: .seconds(4))
        start()
    }

    private func configure(_ server: HttpServer) throws {

        server["*"] = { request in
            return HttpResponse.raw(200, "", ["Content-Type": "application/json"]) { writer in
                let body = "This is a custom response body"
                try writer.write(Array(body.utf8))
            }
        }

    }
}
