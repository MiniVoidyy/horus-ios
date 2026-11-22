//
//  ContentView.swift
//  HorusApp
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = SessionViewModel()
    @State private var showingNewSession = false
    
    var body: some View {
        Group {
            if viewModel.isLocked {
                LockView(viewModel: viewModel)
            } else {
                MainView(viewModel: viewModel, showingNewSession: $showingNewSession)
            }
        }
        .sheet(isPresented: $showingNewSession) {
            NewSessionView(viewModel: viewModel)
        }
    }
}

struct MainView: View {
    @ObservedObject var viewModel: SessionViewModel
    @Binding var showingNewSession: Bool
    
    var body: some View {
        NavigationSplitView {
            List {
                Section("Sessions") {
                    ForEach(viewModel.sessions) { session in
                        SessionRow(session: session, isSelected: viewModel.selectedSessionId == session.id)
                            .onTapGesture {
                                viewModel.selectedSessionId = session.id
                            }
                    }
                    .onDelete(perform: deleteSessions)
                }
            }
            .navigationTitle("Horus")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { viewModel.toggleLock() }) {
                        Image(systemName: "lock.fill")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewSession = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
        } detail: {
            if let session = viewModel.selectedSession {
                TerminalView(session: session, viewModel: viewModel)
            } else {
                EmptyStateView()
            }
        }
    }
    
    private func deleteSessions(offsets: IndexSet) {
        for index in offsets {
            let session = viewModel.sessions[index]
            viewModel.removeSession(session)
        }
    }
}

struct SessionRow: View {
    let session: Session
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Image(systemName: session.agentType.iconName)
                .foregroundColor(Color(session.agentType.color))
                .frame(width: 30)
            VStack(alignment: .leading) {
                Text(session.name)
                    .font(.headline)
                Text(session.status.displayName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Circle()
                .fill(Color(session.status.color))
                .frame(width: 8, height: 8)
        }
        .background(isSelected ? Color.blue.opacity(0.1) : Color.clear)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "terminal.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            Text("No active session")
                .font(.title2)
                .fontWeight(.medium)
            Text("Tap + to start a new terminal or agent session")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}