//
//  MockPermissions.swift
//  PhotosAppTests
//
//  Created by Srinivas Dodda on 16/09/18.
//  Copyright © 2018 Srinivas Dodda. All rights reserved.
//

import Photos
import AVFoundation
@testable import PhotosApp

class MockCameraPermission: CameraPermission {
    
    private static var status: AVAuthorizationStatus = AVAuthorizationStatus.notDetermined
    private static var grantedWhenAsked: Bool = false
    
    static var isCameraAccessRequested: Bool = false
    
    class func setStatus(_ status: AVAuthorizationStatus, grantedWhenAsked: Bool ) {
        MockCameraPermission.status = status
        MockCameraPermission.grantedWhenAsked = grantedWhenAsked
        isCameraAccessRequested = false
    }
    
    class func cameraAuthorizationStatus() -> AVAuthorizationStatus {
        return status
    }
    
    class func requestCameraAccess(completionHandler handler: @escaping (Bool) -> Void) {
        isCameraAccessRequested = true
        handler(grantedWhenAsked)
    }
}

class MockPhotoLibraryPermission: PhotoLibraryPermission {
    
    private static var status: PHAuthorizationStatus = PHAuthorizationStatus.notDetermined
    private static var grantedWhenAsked: Bool = false
    
    static var isPhotoLibraryAccessRequested: Bool = false
    
    class func setStatus(_ status: PHAuthorizationStatus, grantedWhenAsked: Bool ) {
        MockPhotoLibraryPermission.status = status
        MockPhotoLibraryPermission.grantedWhenAsked = grantedWhenAsked
        isPhotoLibraryAccessRequested = false
    }
    
    static func authorizationStatus() -> PHAuthorizationStatus {
        return status
    }
    
    static func requestAccess(_ handler: @escaping (Bool) -> Void) {
        isPhotoLibraryAccessRequested = true
        handler(grantedWhenAsked)
    }
    
    
}
