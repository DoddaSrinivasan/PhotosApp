//
//  CameraPermission.swift
//  PhotosApp
//
//  Created by Srinivas Dodda on 16/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import AVFoundation
import Photos

protocol CameraPermission {
    static func cameraAuthorizationStatus() -> AVAuthorizationStatus
    static func requestCameraAccess(completionHandler handler: @escaping (Bool) -> Void)
}

protocol PhotoLibraryPermission {
    static func authorizationStatus() -> PHAuthorizationStatus
    static func requestAccess(_ handler: @escaping (Bool) -> Void)
}

extension AVCaptureDevice: CameraPermission {
    class func cameraAuthorizationStatus() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: .video)
    }
    
    class func requestCameraAccess(completionHandler handler: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: handler)
    }
}

extension PHPhotoLibrary: PhotoLibraryPermission {
    static func requestAccess(_ handler: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { (status) in
            handler(status == PHAuthorizationStatus.authorized)
        }
    }
}
