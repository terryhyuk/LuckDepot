//
//  ImageSearchView.swift
//  Lucky_Depot
//
//  Created by Eunji Kim on 2/4/25.
//

import SwiftUI
import CoreML
import Vision
import SDWebImageSwiftUI

struct ImageSearchView: View {
    @State private var image: UIImage? = nil
    @State private var isImagePickerPresented: Bool = false
    @State var predictionLabel: String = ""
   
    @EnvironmentObject var productViewModel: ProductViewModel

    @State var productList: [Product] = []
    @State var similarProducts: [Product] = []
    @State var similarImages: [UIImage] = []
    @State var productImages: [UIImage] = []
    
    @Binding var navigationPath: NavigationPath
    
    @State var reset: Bool = false
    @State var listLabel = ""
    @State var finishSearch = true
    
    var body: some View {
        ZStack {
            backgroundColor
              .ignoresSafeArea()
            VStack {
                Text("Discover Similar Products")
                    .font(.title)
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: finishSearch ? 150 : 300, height: finishSearch ? 100 : 300)
                        .padding()
                        .cornerRadius(10)
                } else {
                    Rectangle()
                            .fill(Color.gray.opacity(0.2)) // 회색 박스
                            .frame(height: 300)
                            .cornerRadius(10) // 모서리 둥글게
                            .padding()
                            .overlay(
                                Text("Please upload a photo from your gallery") // 이미지가 없을 때 텍스트 추가
                                    .bold()
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            )
                }
                HStack(content: {
                    Button(action: {
                        isImagePickerPresented = true
                        reset = false
                        
                        if !listLabel.isEmpty {
                                    finishSearch = true
                                } else {
                                    finishSearch = false
                                }
                    }, label: {
                        Image(systemName: "photo.badge.plus.fill")
                    })
                    .disabled(finishSearch == false)
                    .padding()
                    .frame(maxWidth: .infinity) // 버튼의 너비를 가득 차게 만듦
                    .foregroundColor(.white) // 텍스트 색상
                    .background(finishSearch ? Color.blue.opacity(0.7): Color.gray)
                    .cornerRadius(10)
                    
                    Button("Reset") {
                        isImagePickerPresented = false
                        image = nil
                        similarImages.removeAll()
                        similarProducts.removeAll()
                        finishSearch = true
                        reset = true
                        listLabel = ""
                    }
                    .disabled(finishSearch == false && reset == false)
                    .padding()
                    .frame(maxWidth: .infinity) // 버튼의 너비를 가득 차게 만듦
                    .foregroundColor(.white) // 텍스트 색상
                    .background(finishSearch ? Color.red.opacity(0.7) : Color.gray)
                    .cornerRadius(10)
                })
                .padding()
                
                if similarProducts.isEmpty {
                    Text(listLabel)
                } else {
                    if finishSearch {
                        List(similarProducts, id:\.self){
                            product in
                            HStack(content: {
                                WebImage(url: URL(string: product.imagePath))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
                                VStack(alignment: .leading, content: {
                                    Text(product.name)
                                      
                                    HStack(content: {
                                        
                                        Spacer()
                                        
                                        Text("$"+String(format : "%.2f", product.price))
                                            .bold()
                                    })
                                    
                           
                                })
                            })
                            .onTapGesture {
                                productViewModel.productId = product.id
                                navigationPath.append("DetailView")
                                print("Detail")
                            }
                        }
                    } else {
                        ProgressView()
                    }
                    
                    
                }
            if !productList.isEmpty {
                Spacer()
                }
              
            }
            .onAppear(perform: {
                Task{
                    productList = try await productViewModel.fetchProduct()
                }
                
            })
            .sheet(isPresented: $isImagePickerPresented, content: {
                ImagePicker(image: $image, onImagePicked: classifyImage, onCancel: {
                    finishSearch = true
                })
            })
            .onChange(of: image, {
                if reset == true {
                    similarProducts.removeAll()
                } else {
                    Task {
                        await findSimilarImages(identifier: predictionLabel)
                        if similarProducts.isEmpty {
                            listLabel = "No similar products found"
                            
                        }
                    }
                }
                
            })
                       
        }
        
        
    }

    // 이미지 다운로드 함수
    private func downloadImage(from url: String) async -> UIImage? {
            guard let imageURL = URL(string: url) else { return nil }
            
            do {
                let (data,_ ) = try await URLSession.shared.data(from: imageURL)
                if let image = UIImage(data: data) {
                    return image
                }
            } catch {
                print("Error downloading image: \(error.localizedDescription)")
            }
            
            return nil
        }
    
    private func classifyURLImage(_ image: UIImage) async -> String? {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        
        do {
            let modelConfiguration = MLModelConfiguration()
            let model = try VNCoreMLModel(for: MobileNetV2(configuration: modelConfiguration).model)
            
            let request = VNCoreMLRequest(model: model)
            let handler = VNImageRequestHandler(ciImage: ciImage)
            try handler.perform([request])
            
            if let results = request.results as? [VNClassificationObservation], let topResult = results.first {
                return topResult.identifier
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    private func findSimilarImages(identifier: String) async {
        similarImages.removeAll()
        similarProducts.removeAll()

        // 1. productList의 각 제품에 이미지를 다운로드하여 비교
        for product in productList {
            // 이미지 다운로드
            guard let image = await downloadImage(from: product.imagePath) else {
                print("Failed to download image for product: \(product.name)")
                continue // 이미지 다운로드에 실패한 경우, 다음 제품으로 넘어갑니다.
            }

            // 2. 이미지를 비교하여 유사한 이미지 찾기
            if let assetIdentifier = await classifyURLImage(image) {
                if assetIdentifier == identifier {
                    similarImages.append(image)

                    // 3. productList에서 동일한 이미지를 가진 제품 찾기
                    for otherProduct in productList {
                        // 다른 제품의 이미지를 다운로드하여 비교
                        guard let otherImage = await downloadImage(from: otherProduct.imagePath) else { continue }
                        
                        // 이미지를 Data로 변환하여 비교
                        if let imageData = image.pngData(), let otherImageData = otherImage.pngData(), imageData == otherImageData {
                            // 동일한 이미지를 가진 제품을 similarProducts에 추가
                            similarProducts.append(otherProduct)
                        }
                    }
                }
            }
            
            
        }
        finishSearch = true
    }


    // Function to classify the image using Core ML
    func classifyImage(_ image: UIImage) {
        
        guard let ciImage = CIImage(image: image) else {
            return
        }
        
        do {
            // Initialize the model with a configuration
            let modelConfiguration = MLModelConfiguration()
            let model = try VNCoreMLModel(for: MobileNetV2(configuration: modelConfiguration).model)
            
            // Create a request for image classification
            let request = VNCoreMLRequest(model: model) { request, error in
                if let results = request.results as? [VNClassificationObservation], let topResult = results.first {
                    
                    predictionLabel = topResult.identifier
                    
                }
            }
            
            // Perform the request
            let handler = VNImageRequestHandler(ciImage: ciImage)
            
            try? handler.perform([request])
            
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    
  
}

// ImagePicker helper to allow the user to pick an image
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onImagePicked: (UIImage) -> Void
    var onCancel: () -> Void
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.onImagePicked(uiImage)
            }
            
            picker.dismiss(animated: true)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                    parent.onCancel() // 취소 시 실행할 클로저 호출
                    picker.dismiss(animated: true)
                }
    }
}

#Preview {
    ContentView()
}
