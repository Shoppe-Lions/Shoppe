//
//  ImageLoader.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 05.03.2025.
//
import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    
    func loadImage(from image: UIImage, completion: @escaping (UIImage?, String?) -> Void) {
        let imageName = "profile_avatar.jpg"
        let fileURL = getFileURL(for: imageName)
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                do {
                    try imageData.write(to: fileURL)
                    completion(image, fileURL.path)
                } catch {
                    print("Ошибка при сохранении изображения: \(error)")
                    completion(nil, nil)
                }
            }
        } else {
            completion(image, fileURL.path)
        }
    }

    private func getFileURL(for imageName: String) -> URL {
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent(imageName)
    }

    func loadImage(from url: String, completion: @escaping (UIImage?, String?) -> Void) {
        guard let imageURL = URL(string: url) else {
            completion(nil, nil)
            return
        }

        let imageName = imageURL.lastPathComponent
        let fileURL = getFileURL(for: imageName)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            let image = UIImage(contentsOfFile: fileURL.path)
            completion(image, fileURL.path)
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                try? data.write(to: fileURL)
                completion(image, fileURL.path)
            } else {
                completion(nil, nil)
            }
        }.resume()
    }
}
