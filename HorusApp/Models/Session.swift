//
//  Session.swift
//  HorusApp
//
//  Represents an active terminal/agent session.
//

import Foundation

struct Session: Identifiable, Codable {
    let id: UUID
    var name: String
    var agentType: AgentType
    var status: SessionStatus
    var createdAt: Date
    var lastActivity: Date
    var workingDirectory: String
    
    init(name: String, agentType: AgentType, workingDirectory: String = "~") {
        self.id = UUID()
        self.name = name
        self.agentType = agentType
        self.status = .starting
        self.createdAt = Date()
        self.lastActivity = Date()
        self.workingDirectory = workingDirectory
    }
}

enum AgentType: String, Codable, CaseIterable {
    case claudeCode = "claude-code"
    case codex = "codex"
    case openCode = "opencode"
    case shell = "shell"
    
    var displayName: String {
        switch self {
        case .claudeCode: return "Claude Code"
        case .codex: return "Codex"
        case .openCode: return "OpenCode"
        case .shell: return "Terminal"
        }
    }
    
    var iconName: String {
        switch self {
        case .claudeCode: return "brain"
        case .codex: return "gear"
        case .openCode: return "command"
        case .shell: return "terminal"
        }
    }
    
    var color: String {
        switch self {
        case .claudeCode: return "orange"
        case .codex: return "green"
        case .openCode: return "blue"
        case .shell: return "gray"
        }
    }
}

enum SessionStatus: String, Codable {
    case starting
    case ready
    case running
    case stopped
    case error
    
    var displayName: String {
        switch self {
        case .starting: return "Starting…"
        case .ready: return "Ready"
        case .running: return "Running"
        case .stopped: return "Stopped"
        case .error: return "Error"
        }
    }
    
    var color: String {
        switch self {
        case .starting: return "yellow"
        case .ready: return "green"
        case .running: return "blue"
        case .stopped: return "gray"
        case .error: return "red"
        }
    }
}

struct TerminalOutput: Identifiable {
    let id = UUID()
    var text: String
    var timestamp: Date
    var isError: Bool
    
    init(text: String, isError: Bool = false) {
        self.text = text
        self.timestamp = Date()
        self.isError = isError
    }
}