//
//  ImageDirectory.swift
//  matemeup
//
//  Created by Mehdi Meddour on 5/5/18.
//  Copyright © 2018 MateMeUp. All rights reserved.
//

import Foundation

func checkedImageDirectoryStringPath()->String {
    
    // create/check OUR OWN IMAGE DIRECTORY for use of this app.
    
    let paths = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true)
    
    if paths.count < 1 {
        print("some sort of disaster finding the our Image Directory - giving up")
        return "x"
        // any return will lead to disaster, so just do that
        // (it will then gracefully fail when you "try" to write etc)
    }
    
    let docDirPath: String = paths.first!
    let ourDirectoryPath = docDirPath.appending("/YourCompanyName")
    // so simply makes a directory called "YourCompanyName"
    // which will be there for all time, for your use
    
    var ocb: ObjCBool = true
    let exists = FileManager.default.fileExists(
        atPath: ourDirectoryPath, isDirectory: &ocb)
    
    if !exists {
        do {
            try FileManager.default.createDirectory(
                atPath: ourDirectoryPath,
                withIntermediateDirectories: false,
                attributes: nil)
            
            print("we did create our Image Directory, for the first time.")
            // never need to again
            return ourDirectoryPath
        }
        catch {
            print(error.localizedDescription)
            print("disaster trying to make our Image Directory?")
            return "x"
            // any return will lead to disaster, so just do that
        }
    }
        
    else {
        
        // already exists, as usual.
        return ourDirectoryPath
    }
}
