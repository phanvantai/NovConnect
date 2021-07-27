//
//  ImageUploader.swift
//  NovConnect
//
//  Created by Tai Phan Van on 18/07/2021.
//

import FirebaseStorage

struct ImageUploader {
    static func upload(image: UIImage, completion: @escaping (Result<String, Error>) -> ()) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let fileName = UUID().uuidString
        let reference = Storage.storage().reference(withPath: "/\(IMAGE_STORAGE)/\(fileName)")
        
        reference.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("\(#function) \(error.localizedDescription)")
                completion(.failure(error))
            }
            reference.downloadURL { url, error in
                guard let url = url?.absoluteString else { return }
                completion(.success(url))
            }
        }
    }
}

