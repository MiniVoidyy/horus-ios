//
//  AgentService.swift
//  HorusApp
//
//  Integrates with AI coding agents via SSH/HTTP to remote runners,
//  since iOS sandbox prevents local agent execution.
//

import Foundation

final class AgentService {
    static let shared = AgentService()
    
    private init() {}
    
    func connect(to agentType: AgentType, sessionId: UUID, onOutput: @escaping (String) -> Void) {
        // Connect via SSH to a remote runner or use HTTP API
        // iOS sandbox prevents local PRoot/Linux, so agents run remotely
        let endpoint = agentEndpoint(for: agentType)
        onOutput("Connecting to \(agentType.displayName) at \(endpoint)…\n")
        onOutput("Note: iOS sandbox prevents local Linux containers.\nAgents run on a remote runner via SSH.\n\n")
    }
    
    private func agentEndpoint(for type: AgentType) -> String {
        switch type {
        case .claudeCode: return "ssh://claude-runner.horus.local"
        case .codex: return "ssh://codex-runner.horus.local"
        case .openCode: return "ssh://opencode-runner.horus.local"
        case .shell: return "local://sandbox"
        }
    }
}