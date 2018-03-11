// swift-tools-version:4.0
//  Package.swift
//  ChatApp
//
//  Created by cody's macbook on 11/3/17.
//  Copyright © 2017 crank llc. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "ChatApp",
    targets: [
        .target(
            name: "ChatApp",
            dependencies: ["SwiftyJSON"]
        ),
        .target(name: "ChatApp")
    ],
    dependencies: [
        .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", versions: Version(1, 0, 0)..<Version(3, .max, .max))
        ]
)
