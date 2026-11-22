//
//  TerminalService.swift
//  HorusApp
//
//  Manages terminal command execution via SwiftProcess (sandboxed).
//  iOS sandbox limits what can run locally; remote SSH is used for full agents.
//

import Foundation
import Combine

final class TerminalService: ObservableObject {
    @Published var isRunning = false
    
    private var process: Process?
    
    func execute(command: String, in directory: String, onOutput: @escaping (String) -> Void) {
        isRunning = true
        
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/bin/sh")
        task.arguments = ["-c", command]
        task.currentDirectoryURL = URL(fileURLWithPath: directory)
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        
        pipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            if let string = String(data: data, encoding: .utf8), !string.isEmpty {
                DispatchQueue.main.async {
                    onOutput(string)
                }
            }
        }
        
        task.terminationHandler = { _ in
            DispatchQueue.main.async {
                self.isRunning = false
            }
        }
        
        self.process = task
        
        do {
            try task.run()
        } catch {
            onOutput("Error: \(error.localizedDescription)\n")
            isRunning = false
        }
    }
    
    func stop() {
        process?.terminate()
        process = nil
        isRunning = false
    }
}