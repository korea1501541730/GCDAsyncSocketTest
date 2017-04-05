//
//  UDPViewController.m
//  SocketTest
//
//  Created by dnake on 2017/4/5.
//  Copyright © 2017年 dnake. All rights reserved.
//

#import "UDPViewController.h"
#import "GCDAsyncUdpSocket.h"

@interface UDPViewController ()<GCDAsyncUdpSocketDelegate>
@property (nonatomic,strong)GCDAsyncUdpSocket *udpSocket;
@property (nonatomic,strong) UIButton *button;
@property (nonatomic,strong) UIButton *closeBtn;
@end

@implementation UDPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button.frame=CGRectMake(100, 100, 66, 40);
    [self.button setTitle:@"发消息" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(touchSendMsg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    self.closeBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.closeBtn.frame=CGRectMake(200, 100, 66, 40);
    [self.closeBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(touchClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeBtn];
    [self setupConnection];
}
-(void)touchClose:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//建立连接
-(NSError *)setupConnection {
    if (nil == self.udpSocket)
        self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    if (![self.udpSocket connectToHost:@"192.168.13.93"  onPort:7070 error:&err]) {
    } else {
        err = nil;
    }
    NSLog(@"连接成功！");
    [self listenData];
    return err;
}
//发起一个读取的请求，当收到数据时后面的didReadData才能被回调
-(void)listenData {
      NSError *err = nil;
    [self.udpSocket beginReceiving:&err];
    
//    self.udpSocket beginReceiving:<#(NSError * _Nullable __autoreleasing * _Nullable)#>
    //    [self.socket readDataToData:[GCDAsyncSocket LFData] withTimeout:10 tag:1];
//    [self.udpSocket readDataWithTimeout:-1 tag:1];
}
//判断是否是连接的状态
-(BOOL)isConnected {
    return self.udpSocket.isConnected;
}

//断开连接
-(void)disConnect {

  [self.udpSocket close];
}
//取得连接
-(void)getConnection {
    if (![self.udpSocket isConnected]) {
        [self disConnect];
        //        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setupConnection) userInfo:nil repeats:NO];
        //        NSLog(@"scheduled start");
        [self setupConnection];
    }
}
-(void)sendCMD {
    [self getConnection];
    NSString *cmd = @"UDP测试\n";
    NSData *data = [cmd dataUsingEncoding:NSUTF8StringEncoding];
    [self.udpSocket sendData:data withTimeout:10 tag:1];
}
- (void)socket:(GCDAsyncUdpSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *ip = [sock connectedHost];
    uint16_t port = [sock connectedPort];
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"接收 UDP [%@:%d] %@", ip, port, s);
}
- (IBAction)touchSendMsg:(UIButton *)sender {
    //发送数据
    [self sendCMD];
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"发送信息成功");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    NSLog(@"发送信息失败");
}


@end
