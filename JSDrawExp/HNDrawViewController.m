/*
 * HNDrawViewController.m
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
#import "HNDrawViewController.h"
#import "HNCanvas.h"

@implementation HNDrawViewController {
@private
    UIImageView *m_imageView;
}

- (void)loadView {
    [super loadView];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    m_imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    m_imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    m_imageView.contentMode = UIViewContentModeTopLeft;
    [self.view addSubview:m_imageView];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Draw by draw.js" style:UIBarButtonItemStylePlain target:self action:@selector(execJS)];
}

- (void)execJS {
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *jsPath = [documentsPath stringByAppendingPathComponent:@"draw.js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:NULL];
    if (nil == jsCode) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to load JS" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:jsCode];
    
    CGSize canvasSize = self.view.bounds.size;
    HNCanvas *canvas = [[HNCanvas alloc] init];
    [canvas beginDrawingWithSize:canvasSize];
    
    JSValue *drawFunc = context[@"draw"];
    [drawFunc callWithArguments:@[canvas]];
    
    UIImage *canvasImage = [canvas endDrawing];
    m_imageView.image = canvasImage;
}

@end
