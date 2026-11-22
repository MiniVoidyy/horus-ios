//
//  SessionViewModel.swift
//  HorusApp
//

import SwiftUI
import Combine

final class SessionViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var selectedSessionId: UUID?
    @Published var isLocked = true
    
    private var outputHistory: [UUID: [TerminalOutput]] = [:]
    
    var selectedSession: Session? {
        sessions.first { $0.id == selectedSessionId }
    }
    
    func outputs(for sessionId: UUID) -> [TerminalOutput] {
        outputHistory[sessionId] ?? []
    }
    
    func addOutput(_ text: String, to sessionId: UUID, isError: Bool = false) {
        let output = TerminalOutput(text: text, isError: isError)
        outputHistory[sessionId, default: []].append(output)
        if let idx = sessions.firstIndex(where: { $0.id == sessionId }) {
            sessions[idx].lastActivity = Date()
        }
    }
    
    func createSession(name: String, agentType: AgentType, workingDirectory: String = "~") {
        let session = Session(name: name, agentType: agentType, workingDirectory: workingDirectory)
        sessions.append(session)
        selectedSessionId = session.id
        addOutput("Session started: \(session.name)\nAgent: \(agentType.displayName)\nType 'help' for available commands.\n", to: session.id)
    }
    
    func removeSession(_ session: Session) {
        sessions.removeAll { $0.id == session.id }
        outputHistory.removeValue(forKey: session.id)
        if selectedSessionId == session.id {
            selectedSessionId = sessions.first?.id
        }
    }
    
    func unlock(password: String) -> Bool {
        // In production, verify against SecureEnclave/Keychain
        isLocked = password == "horus"
        return !isLocked
    }
    
    func toggleLock() {
        isLocked.toggle()
    }
}