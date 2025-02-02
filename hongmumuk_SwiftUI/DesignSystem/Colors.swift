//
//  Colors.swift
//  hongmumuk_SwiftUI
//
//  Created by Park Seyoung on 2/2/25.
//

import Foundation
import SwiftUI

struct Colors {
    struct Primary {
        static let normal = Color(hex: "#193BE6")
        static let strong = Color(hex: "#1735CF")
        static let heavy = Color(hex: "#142FB8")
    }
    
    struct GrayScale {
        static let normal = Color(hex: "#040615")
        static let neutral = Color(hex: "#2B2D3B")
        static let alternative = Color(hex: "#8F92A3")
        static let assistive = Color(hex: "#C7C9D1")
        static let disable = Color(hex: "#E2E3E9")
    }
    
    struct Border {
        static let normal = Color(hex: "#040615").opacity(0.1)
        static let neutral = Color(hex: "#040615").opacity(0.07)
        static let alternative = Color(hex: "#040615").opacity(0.05)
        static let strong = Color(hex: "#040615").opacity(0.15)
    }
    
    struct SemanticColor {
        static let positive = Color(hex: "#20DF7F")
        static let negative = Color(hex: "#FF4433")
    }
}

