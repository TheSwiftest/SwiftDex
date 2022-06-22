//
//  TestData.swift
//  SwiftDex
//
//  Created by Brian Corbin on 4/3/22.
//

import Foundation
import RealmSwift

let testRealm = try! Realm(configuration: Realm.Configuration(fileURL: URL(fileURLWithPath: Bundle.main.path(forResource: "swiftdex", ofType: "realm")!), readOnly: true))
