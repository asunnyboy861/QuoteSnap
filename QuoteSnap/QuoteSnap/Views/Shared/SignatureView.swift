import SwiftUI

struct SignatureView: View {
    @Binding var signatureData: Data?
    @State private var currentPath = Path()
    @State private var isDrawing = false
    @State private var paths: [Path] = []
    @State private var currentPoints: [CGPoint] = []
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 12) {
            Text("Customer Signature")
                .font(.headline)
                .foregroundColor(.textPrimary)

            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(colorScheme == .dark ? Color(white: 0.15) : Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.textSecondary.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [5]))
                    )

                Canvas { context, size in
                    for path in paths {
                        context.stroke(path, with: .color(.trustBlue), lineWidth: 2.5)
                    }
                    context.stroke(currentPath, with: .color(.trustBlue), lineWidth: 2.5)
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            isDrawing = true
                            currentPoints.append(value.location)
                            currentPath = Path { path in
                                guard let first = currentPoints.first else { return }
                                path.move(to: first)
                                for point in currentPoints.dropFirst() {
                                    path.addLine(to: point)
                                }
                            }
                        }
                        .onEnded { _ in
                            isDrawing = false
                            if !currentPoints.isEmpty {
                                paths.append(currentPath)
                            }
                            currentPath = Path()
                            currentPoints = []
                            saveSignature()
                        }
                )

                if paths.isEmpty && currentPoints.isEmpty {
                    Text("Sign here")
                        .foregroundColor(.textSecondary.opacity(0.5))
                        .font(.body)
                }
            }
            .frame(height: 150)

            HStack {
                Button(action: clearSignature) {
                    Label("Clear", systemImage: "xmark.circle")
                        .font(.subheadline)
                        .foregroundColor(.dangerRed)
                }
                Spacer()
            }
        }
    }

    private func clearSignature() {
        paths = []
        currentPath = Path()
        currentPoints = []
        signatureData = nil
    }

    private func saveSignature() {
        let renderer = ImageRenderer(content:
            Canvas { context, size in
                for path in paths {
                    context.stroke(path, with: .color(.trustBlue), lineWidth: 2.5)
                }
            }
            .frame(width: 300, height: 150)
        )
        renderer.scale = 2.0
        if let uiImage = renderer.uiImage, let pngData = uiImage.pngData() {
            signatureData = pngData
        }
    }
}
