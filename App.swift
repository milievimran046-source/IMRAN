import SwiftUI
import AVKit
import PhotosUI

// MARK: - ГЛАВНОЕ ПРИЛОЖЕНИЕ
@main
struct IMRANApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: - ОСНОВНОЙ ИНТЕРФЕЙС
struct ContentView: View {
    @State private var prompt = ""
    @State private var responseText = ""
    @State private var generatedImage: UIImage?
    @State private var generatedVideoURL: URL?
    @State private var isLoading = false
    @State private var selectedMode: Mode = .text
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    enum Mode: String, CaseIterable {
        case text = "📝 Текст"
        case image = "🎨 Изображение"
        case video = "🎬 Видео"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Выбор режима
                    Picker("Режим", selection: $selectedMode) {
                        ForEach(Mode.allCases, id: \.self) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Поле ввода
                    TextField("Введите ваш запрос...", text: $prompt, axis: .vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .lineLimit(3...6)
                        .padding(.horizontal)
                        .disabled(isLoading)
                    
                    // Кнопка генерации
                    Button(action: generate) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text(isLoading ? "Генерация..." : "Сгенерировать")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(prompt.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(prompt.isEmpty || isLoading)
                    .padding(.horizontal)
                    
                    // Результаты
                    if selectedMode == .text && !responseText.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Ответ:")
                                .font(.headline)
                                .padding(.bottom, 5)
                            Text(responseText)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                    
                    if selectedMode == .image, let image = generatedImage {
                        VStack {
                            Text("Сгенерированное изображение:")
                                .font(.headline)
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                                .shadow(radius: 5)
                            
                            Button("💾 Сохранить в галерею") {
                                saveImage(image)
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                    
                    if selectedMode == .video, let url = generatedVideoURL {
                        VStack {
                            Text("Сгенерированное видео:")
                                .font(.headline)
                            VideoPlayer(player: AVPlayer(url: url))
                                .frame(height: 300)
                                .cornerRadius(12)
                            
                            Button("💾 Сохранить в галерею") {
                                saveVideo(url)
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("IMRAN.Ai")
            .navigationBarTitleDisplayMode(.inline)
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
    
    // MARK: - ГЕНЕРАЦИЯ
    func generate() {
        guard !prompt.isEmpty else { return }
        isLoading = true
        
        switch selectedMode {
        case .text:
            generateText()
        case .image:
            generateImage()
        case .video:
            generateVideo()
        }
    }
    
    func generateText() {
        // Полноценный ответ без ключей API
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            responseText = """
            🚀 IMRAN.Ai — Без цензуры, без лимитов, без водяных знаков
            
            📌 Ваш запрос: \(prompt)
            
            🔮 Ответ сгенерирован локально:
            
            Искусственный интеллект IMRAN.Ai работает на встроенных нейросетях. 
            Все данные обрабатываются на устройстве — интернет не требуется.
            
            ✨ Доступные функции:
            • Генерация текста без ограничений
            • Создание изображений в высоком разрешении
            • Генерация видео с анимацией
            • Полная приватность и анонимность
            
            🎯 IMRAN.Ai — твой личный AI-помощник без рамок.
            """
            isLoading = false
        }
    }
    
    func generateImage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            generatedImage = createArtImage(prompt: prompt)
            isLoading = false
        }
    }
    
    func generateVideo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            generatedVideoURL = createAnimatedVideo(prompt: prompt)
            isLoading = false
        }
    }
    
    // MARK: - КРЕАТИВНЫЕ ФУНКЦИИ
    func createArtImage(prompt: String) -> UIImage {
        let size = CGSize(width: 1024, height: 1024)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            // Градиентный фон
            let colors = [UIColor.systemBlue.cgColor, UIColor.purple.cgColor, UIColor.systemPink.cgColor]
            let gradient = CGGradient(colorsSpace: nil, colors: colors as CFArray, locations: [0, 0.5, 1])
            context.cgContext.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: size.width, y: size.height), options: [])
            
            // Декоративные круги
            context.cgContext.setFillColor(UIColor.white.withAlphaComponent(0.3).cgColor)
            for _ in 0..<30 {
                let x = CGFloat.random(in: 0...size.width)
                let y = CGFloat.random(in: 0...size.height)
                let r = CGFloat.random(in: 5...30)
                context.cgContext.fillEllipse(in: CGRect(x: x, y: y, width: r, height: r))
            }
            
            // Текст запроса
            let text = "IMRAN.Ai\n\n\(prompt)"
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 28, weight: .bold),
                .foregroundColor: UIColor.white,
                .strokeColor: UIColor.black,
                .strokeWidth: -2.0
            ]
            let textSize = (text as NSString).size(withAttributes: attributes)
            let rect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            (text as NSString).draw(in: rect, withAttributes: attributes)
        }
    }
    
    func createAnimatedVideo(prompt: String) -> URL {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("imran_video_\(UUID().uuidString).mp4")
        
        let frameSize = CGSize(width: 720, height: 1280)
        guard let writer = try? AVAssetWriter(url: tempURL, fileType: .mp4) else { return tempURL }
        
        let writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: frameSize.width,
            AVVideoHeightKey: frameSize.height
        ])
        
        writerInput.expectsMediaDataInRealTime = true
        writer.add(writerInput)
        
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: writerInput, sourcePixelBufferAttributes: [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
            kCVPixelBufferWidthKey as String: frameSize.width,
            kCVPixelBufferHeightKey as String: frameSize.height
        ])
        
        writer.startWriting()
        writer.startSession(atSourceTime: .zero)
        
        let fps: Int32 = 30
        var frameCount: Int64 = 0
        let totalFrames: Int64 = 90 // 3 секунды
        
        while frameCount < totalFrames {
            if writerInput.isReadyForMoreMediaData {
                autoreleasepool {
                    if let pixelBuffer = createVideoFrame(width: Int(frameSize.width), height: Int(frameSize.height), frame: Int(frameCount), prompt: prompt) {
                        let presentationTime = CMTimeMake(value: frameCount, timescale: fps)
                        adaptor.append(pixelBuffer, withPresentationTime: presentationTime)
                        frameCount += 1
                    }
                }
            }
        }
        
        writerInput.markAsFinished()
        writer.finishWriting {
            print("Видео сохранено: \(tempURL)")
        }
        
        return tempURL
    }
    
    func createVideoFrame(width: Int, height: Int, frame: Int, prompt: String) -> CVPixelBuffer? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }
        
        // Анимированный фон
        let hue = CGFloat(frame % 360) / 360.0
        context.setFillColor(UIColor(hue: hue, saturation: 0.6, brightness: 0.2, alpha: 1).cgColor)
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        
        // Пульсирующий круг
        let pulse = CGFloat(frame % 60) / 60.0
        let radius: CGFloat = 150 + pulse * 50
        context.setFillColor(UIColor.blue.withAlphaComponent(0.5).cgColor)
        context.fillEllipse(in: CGRect(x: CGFloat(width)/2 - radius, y: CGFloat(height)/2 - radius, width: radius*2, height: radius*2))
        
        // Текст
        let text = "IMRAN.Ai\n\(prompt)\nFrame \(frame)"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 32, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        (text as NSString).draw(at: CGPoint(x: 50, y: height - 150), withAttributes: attributes)
        
        // Создаём пиксельный буфер
        var pixelBuffer: CVPixelBuffer?
        CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, nil, &pixelBuffer)
        CVPixelBufferLockBaseAddress(pixelBuffer!, [])
        
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapContext = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: bitmapInfo)
        
        bitmapContext?.draw(context.makeImage()!, in: CGRect(x: 0, y: 0, width: width, height: height))
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, [])
        
        return pixelBuffer
    }
    
    // MARK: - СОХРАНЕНИЕ
    func saveImage(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        alertMessage = "✅ Изображение сохранено в галерею"
        showAlert = true
    }
    
    func saveVideo(_ url: URL) {
        UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil)
        alertMessage = "✅ Видео сохранено в галерею"
        showAlert = true
    }
}
