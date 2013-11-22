/*
 * HNCanvas.m
 *
 * Copyright (c) 2013 Hironori Ichimiya <hiron@hironytic.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <JavaScriptCore/JavaScriptCore.h>
#import "HNCanvas.h"

@implementation HNCanvas {
@private
    UIBezierPath *m_currentPath;
}

- (void)beginDrawingWithSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);

    [[UIColor blackColor] setStroke];
    
    [self readyNewPath];
}

- (UIImage *)endDrawing {
    [self flushCurrentPath];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)flushCurrentPath {
    if (nil != m_currentPath) {
        [m_currentPath stroke];
        m_currentPath = nil;
    }
}

- (void)readyNewPath {
    [self flushCurrentPath];
    m_currentPath = [UIBezierPath bezierPath];
    m_currentPath.lineWidth = 1.0;
    m_currentPath.lineCapStyle = kCGLineCapButt;
    m_currentPath.lineJoinStyle = kCGLineJoinMiter;
}

#pragma mark - HNCanvasExport protocol (called in JavaScript)

- (void)moveTo:(double)x :(double)y {
    if (nil != m_currentPath) {
        [m_currentPath moveToPoint:CGPointMake(x, y)];
    }
}

- (void)lineTo:(double)x :(double)y {
    if (nil != m_currentPath) {
        [m_currentPath addLineToPoint:CGPointMake(x, y)];
    }
}

@end
