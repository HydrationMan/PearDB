//
//  Utilities.swift
//  PearDBProject
//
//  Created by bibi_fire on 18/04/2024.
//

import Foundation

func buildNumber() -> String {
    var size = 0
    sysctlbyname("kern.osversion", nil, &size, nil, 0)
    var version = [CChar](repeating: 0,  count: size)
    sysctlbyname("kern.osversion", &version, &size, nil, 0)
    return String(cString: version)
}
