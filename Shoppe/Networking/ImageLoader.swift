//
//  ImageLoader.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 05.03.2025.
//
import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
