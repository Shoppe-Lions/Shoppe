//
//  APIService.swift
//  Shoppe
//
//  Created by Игорь Клевжиц on 04.03.2025.
//

import Foundation

final class APIService {
    
    static let shared = APIService()
    private let baseURL = "https://fakestoreapi.com/products"
    private let defaults = UserDefaults.standard
    private let likeKey = "likedProducts"
    private let productsKey = "cachedProducts"
    
    var cachedProducts: [Product] = []
    var popularProducts: [Product] = []
    var justForYouProducts: [Product] = []
    
    init() {
        loadCachedProducts()
    }
    
    private func loadCachedProducts() {
        if let data = defaults.data(forKey: productsKey),
           let products = try? JSONDecoder().decode([Product].self, from: data) {
            cachedProducts = products
        }
    }
    
    private func saveProductsToCache(_ products: [Product]) {
        if let data = try? JSONEncoder().encode(products) {
            defaults.set(data, forKey: productsKey)
        }
    }
    
    //        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    private func updatePopularAndJustForYou(from products: [Product]) {
        let shuffledProducts = products.shuffled()
        popularProducts = Array(shuffledProducts.prefix(6))
        let startIndex = 6
        let endIndex = min(startIndex + 8, shuffledProducts.count)
        justForYouProducts = Array(shuffledProducts[startIndex..<endIndex])
    }
    
    func fetchProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        // UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//        if !cachedProducts.isEmpty {
//            print("Returning cached products")
//            completion(.success(cachedProducts))
//            return
//        }

        print("Fetching products from network...")
        NetworkManager.shared.fetchData(from: baseURL) { (result: Result<[Product], NetworkError>) in
            switch result {
            case .success(var products):
                let group = DispatchGroup()

                for i in products.indices {
                    group.enter()
                    ImageLoader.shared.loadImage(from: products[i].imageURL) { _, localPath in
                        if let path = localPath {
                            products[i].localImagePath = path
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    self.cachedProducts = products
                    self.updatePopularAndJustForYou(from: products)
                    self.saveProductsToCache(products)
                    completion(.success(products))
                }

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchProduct(by id: Int, completion: @escaping (Result<Product, NetworkError>) -> Void) {
//        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        if let cachedProduct = cachedProducts.first(where: { $0.id == id }) {
            print("Returning cached product")
            completion(.success(cachedProduct))
            return
        }
        
        let url = "\(baseURL)/\(id)"
        print("Fetching product from network...")
        
        NetworkManager.shared.fetchData(from: url) { (result: Result<Product, NetworkError>) in
            switch result {
            case .success(var product):
                let likedProducts = self.defaults.object(forKey: self.likeKey) as? [Int] ?? []
                product.like = likedProducts.contains(product.id)
                
                let group = DispatchGroup()
                group.enter()
                ImageLoader.shared.loadImage(from: product.imageURL) { _, localPath in
                    if let path = localPath {
                        product.localImagePath = path
                        print(path)
                    }
                    group.leave()
                }
                group.notify(queue: .main) {
                    completion(.success(product))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func toggleLike(for product: Product) {
        var updatedProduct = product
        updatedProduct.toggleLike()
        
        if let index = cachedProducts.firstIndex(where: { $0.id == updatedProduct.id }) {
            cachedProducts[index] = updatedProduct
            saveProductsToCache(cachedProducts)
        }
    }
    
    func updateLikesInProducts(array: [Product]) -> [Product] {
        array.compactMap { cachedProducts.firstIndex(of: $0).map { cachedProducts[$0] } }
    }
    
    func fetchProductsByCategory(_ category: String, completion: @escaping (Result<[Product], NetworkError>) -> Void) {
            fetchProducts { result in
                switch result {
                case .success(let products):
                    let filtered = products.filter { $0.category.lowercased() == category.lowercased() }
                    completion(.success(filtered))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

        func fetchProductsBySubcategory(_ subcategory: String, completion: @escaping (Result<[Product], NetworkError>) -> Void) {
            fetchProducts { result in
                switch result {
                case .success(let products):
                    let filtered = products.filter { $0.subcategory.lowercased() == subcategory.lowercased() }
                    completion(.success(filtered))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

        func fetchLikedProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
            fetchProducts { result in
                switch result {
                case .success(let products):
                    let liked = products.filter { $0.like }
                    completion(.success(liked))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }

    func updateCollections(completion: @escaping (Result<([Product], [Product]), NetworkError>) -> Void) {
        fetchProducts { result in
            switch result {
            case .success(_):
                completion(.success((self.popularProducts, self.justForYouProducts)))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
