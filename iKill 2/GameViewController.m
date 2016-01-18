//
//  GameViewController.m
//  iKill 2
//
//  Created by Udayan Bulchandani on 26/12/2015.
//  Copyright (c) 2015 Udayan Bulchandani. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController



-(void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    
    if ( !skView.scene ) {
        
        // Configure the view.
        SKView * skView = (SKView *)self.view;
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        //skView.showsPhysics = YES;
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = YES;
        
        // Create and configure the scene.
        GameScene *scene = [GameScene nodeWithFileNamed:@"GameScene"];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];

    }
}



- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
