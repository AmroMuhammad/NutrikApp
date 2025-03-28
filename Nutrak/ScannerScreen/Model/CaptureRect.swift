//
//  CaptureRect.swift
//  Nutrak
//
//  Created by Amr Muhammad on 29/03/2025.
//

import SwiftUI

struct CaptureRect {
    var frame: CGRect
    let cornerLength: CGFloat
    let borderWidth: CGFloat
    let cornerRadius: CGFloat

    func cornerPath(in rect: CGRect) -> Path {
        var path = Path()
        
        
        // Top Left
        path.move(to: CGPoint(x: frame.minX, y: frame.minY + cornerLength))
        path.addLine(to: CGPoint(x: frame.minX, y: frame.minY + cornerRadius))
        path.addQuadCurve(to: CGPoint(x: frame.minX + cornerRadius, y: frame.minY),
                          control: CGPoint(x: frame.minX, y: frame.minY))
        path.addLine(to: CGPoint(x: frame.minX + cornerLength, y: frame.minY))
        
        // Top Right
        path.move(to: CGPoint(x: frame.maxX - cornerLength, y: frame.minY))
        path.addLine(to: CGPoint(x: frame.maxX - cornerRadius, y: frame.minY))
        path.addQuadCurve(to: CGPoint(x: frame.maxX, y: frame.minY + cornerRadius),
                          control: CGPoint(x: frame.maxX, y: frame.minY))
        path.addLine(to: CGPoint(x: frame.maxX, y: frame.minY + cornerLength))
        
        // Bottom Left
        path.move(to: CGPoint(x: frame.minX, y: frame.maxY - cornerLength))
        path.addLine(to: CGPoint(x: frame.minX, y: frame.maxY - cornerRadius))
        path.addQuadCurve(to: CGPoint(x: frame.minX + cornerRadius, y: frame.maxY),
                          control: CGPoint(x: frame.minX, y: frame.maxY))
        path.addLine(to: CGPoint(x: frame.minX + cornerLength, y: frame.maxY))
        
        // Bottom Right
        path.move(to: CGPoint(x: frame.maxX - cornerLength, y: frame.maxY))
        path.addLine(to: CGPoint(x: frame.maxX - cornerRadius, y: frame.maxY))
        path.addQuadCurve(to: CGPoint(x: frame.maxX, y: frame.maxY - cornerRadius),
                          control: CGPoint(x: frame.maxX, y: frame.maxY))
        path.addLine(to: CGPoint(x: frame.maxX, y: frame.maxY - cornerLength))
        
        return path
    }
}
