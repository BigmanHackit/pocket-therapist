//
//  WaveformView.swift
//  Pocket Therapist
//
//  Created by Firebrand Dev on 15/07/2025.
//

import SwiftUI


struct WaveformView: View {
    @State private var waveHeights: [CGFloat] = Array(repeating: 0.1, count: 20)
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<waveHeights.count, id: \.self) { index in
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.red, .orange]),
                        startPoint: .bottom,
                        endPoint: .top
                    ))
                    .frame(width: 3, height: waveHeights[index] * 30)
                    .animation(.easeInOut(duration: 0.5), value: waveHeights[index])
            }
        }
        .onAppear {
            startWaveAnimation()
        }
    }
    
    private func startWaveAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            for i in 0..<waveHeights.count {
                waveHeights[i] = CGFloat.random(in: 0.3...1.0)
            }
        }
    }
}

// Alternative pulsing circle waveform
struct PulsingWaveView: View {
    @State private var scales: [CGFloat] = [1.0, 1.0, 1.0, 1.0, 1.0]
    @State private var opacities: [Double] = [0.8, 0.6, 0.4, 0.2, 0.1]
    
    var body: some View {
        ZStack {
            ForEach(0..<scales.count, id: \.self) { index in
                Circle()
                    .stroke(Color.blue, lineWidth: 2)
                    .frame(width: 40, height: 40)
                    .scaleEffect(scales[index])
                    .opacity(opacities[index])
                    .animation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: false)
                        .delay(Double(index) * 0.3),
                        value: scales[index]
                    )
            }
        }
        .onAppear {
            for index in 0..<scales.count {
                scales[index] = 3.0
                opacities[index] = 0.0
            }
        }
    }
}

// Microphone icon with sound waves
struct MicrophoneWaveView: View {
    @State private var waveScales: [CGFloat] = [1.0, 1.0, 1.0]
    
    var body: some View {
        HStack(spacing: 8) {
            // Microphone icon
            Image(systemName: "mic.fill")
                .font(.title2)
                .foregroundColor(.blue)
            
            // Sound waves
            HStack(spacing: 4) {
                ForEach(0..<waveScales.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.blue.opacity(0.7))
                        .frame(width: 3, height: 20)
                        .scaleEffect(y: waveScales[index], anchor: .center)
                        .animation(
                            .easeInOut(duration: 0.5)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.1),
                            value: waveScales[index]
                        )
                }
            }
        }
        .onAppear {
            for index in 0..<waveScales.count {
                waveScales[index] = CGFloat.random(in: 0.5...2.0)
            }
        }
    }
}

// Advanced waveform with better visual appeal
struct AdvancedWaveformView: View {
    @State private var heights: [CGFloat] = Array(repeating: 20, count: 12)
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 8) {
            // Recording indicator
            HStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                    .scaleEffect(1.0)
                    .animation(
                        .easeInOut(duration: 0.8)
                        .repeatForever(autoreverses: true),
                        value: 1.0
                    )
                
                Text("Recording...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Waveform bars
            HStack(spacing: 3) {
                ForEach(0..<heights.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .green, location: 0.0),
                                    .init(color: .yellow, location: 0.5),
                                    .init(color: .red, location: 1.0)
                                ]),
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(width: 4, height: heights[index])
                        .animation(
                            .easeInOut(duration: Double.random(in: 0.1...0.3)),
                            value: heights[index]
                        )
                }
            }
            .frame(height: 60)
        }
        .onAppear {
            startWaveAnimation()
        }
        .onDisappear {
            stopWaveAnimation()
        }
    }
    
    private func startWaveAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            withAnimation {
                for index in 0..<heights.count {
                    heights[index] = CGFloat.random(in: 5...55)
                }
            }
        }
    }
    
    private func stopWaveAnimation() {
        timer?.invalidate()
        timer = nil
    }
}
