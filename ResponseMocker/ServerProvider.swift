//
//  ServerProvider.swift
//  ResponseMocker
//
//  Created by Bror2 on 25/05/2023.
//

import Foundation
import Swifter
import SwiftUI

class ServerProvider: ObservableObject {
    @Published var isRunning: Bool = false
    @Published var mockeries: [Mockery] = []
    
    @AppStorage("port") var port: Int = 8080
    
    private var server: HttpServer?
    private let fileName = "mockeries.json"
    
    init() {
        self.mockeries = self.fetchMockeries()
    }

    func start() async -> Bool {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                do {
                    self.server = HttpServer()
                    try self.configure(self.server!)
                    try self.server!.start()
                    
                    continuation.resume(with: .success(true))
                    DispatchQueue.main.async {
                        self.isRunning = true
                    }
                } catch {
                    print(error.localizedDescription)
                    continuation.resume(with: .success(true))
                    DispatchQueue.main.async {
                        self.isRunning = false
                    }
                }
            }
        }
    }

    func stop() async -> Bool {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                if (self.isRunning) {
                    self.server?.stop()
                    continuation.resume(with: .success(true))
                    DispatchQueue.main.async {
                        self.isRunning = false
                    }
                } else {
                    continuation.resume(with: .success(false))
                }
            }
        }
    }
    
    func reboot() async {
        saveMockeries(mockeries)
        let _ = await stop()
        let _ = await start()
    }

    private func configure(_ server: HttpServer) throws {

        for mockery in mockeries {
            server[mockery.endpoint] = { request in
                return HttpResponse.raw(
                    mockery.statusCode.rawValue,
                    "",
                    ["Content-Type": "application/json"]
                ) { writer in
                    let body = mockery.responseBody
                    try writer.write(Array(body.utf8))
                }
            }

        }

    }
    
    func addMock() async -> Bool {
        let _ = await self.stop()
        DispatchQueue.main.async {
            self.mockeries.append(Mockery())
            self.saveMockeries(self.mockeries)
        }
        let _ = await self.start()
        return true
    }
    
    func removeMock(at index: IndexSet) async -> Bool {
        let _ = await self.stop()
        DispatchQueue.main.async {
            self.mockeries.remove(atOffsets: index)
            self.saveMockeries(self.mockeries)
        }
        let _ = await self.start()
        return true
    }
    
    private func saveMockeries(_ mockeries: [Mockery]) {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(mockeries)
            if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                try jsonData.write(to: fileURL)
            }
        } catch {
            print("Failed to save mockeries: \(error)")
        }
    }
    
    private func fetchMockeries() -> [Mockery] {
        if let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            do {
                let jsonData = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let mockeries = try decoder.decode([Mockery].self, from: jsonData)
                return mockeries
            } catch {
                print("Failed to fetch mockeries: \(error)")
            }
        }
        return []
    }
}
