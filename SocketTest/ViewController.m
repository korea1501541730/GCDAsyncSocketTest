//
//  ViewController.m
//  SocketTest
//
//  Created by dnake on 2017/3/31.
//  Copyright © 2017年 dnake. All rights reserved.
//

#import "ViewController.h"
#import "TCPViewController.h"
#import "UDPViewController.h"
#import "GCDAsyncSocket.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
//BOOL needConnect;
//NSMutableData *restData;
@interface ViewController ()<GCDAsyncSocketDelegate>
@property (nonatomic,strong) GCDAsyncSocket *socket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self getConnection];
    //    [self csocket];
    //    self.socket= [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //    [self.socket connectToHost:@"192.168.13.93" onPort:7070 error:nil];
    //    //        NSLog(@"发送成功！！");
    //    [self.socket readDataToData:[GCDAsyncSocket CRLFData] withTimeout:10 maxLength:50000 tag:0];
}
//建立连接
-(NSError *)setupConnection {
    if (nil == self.socket)
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    if (![self.socket connectToHost:@"192.168.13.93"  onPort:7070 error:&err]) {
    } else {
        err = nil;
    }
//    needConnect = YES;
    NSLog(@"连接成功！");
    [self listenData];
    return err;
}
//发起一个读取的请求，当收到数据时后面的didReadData才能被回调
-(void)listenData {
    //    NSString* sp = @"\n";
    //    NSData* sp_data = [sp dataUsingEncoding:NSUTF8StringEncoding];
//    [self.socket readDataToData:[GCDAsyncSocket LFData] withTimeout:10 tag:1];
        [self.socket readDataWithTimeout:-1 tag:1];
}
//判断是否是连接的状态
-(BOOL)isConnected {
    return self.socket.isConnected;
}

//断开连接
-(void)disConnect {
//    needConnect = NO;
    [self.socket disconnect];
}
//取得连接
-(void)getConnection {
    if (![self.socket isConnected]) {
        [self disConnect];
        //        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setupConnection) userInfo:nil repeats:NO];
        //        NSLog(@"scheduled start");
        [self setupConnection];
    }
}
-(void)sendCMD {
    [self getConnection];
    NSString *cmd = @"2312反倒是gwrr\n";
    NSData *data = [cmd dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:20 tag:1];
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *ip = [sock connectedHost];
    uint16_t port = [sock connectedPort];
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"返回的数据 TCP [%@:%d] %@", ip, port, s);
    [self splitData:data];
}

//-(void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag {
//    NSLog(@"Reading data length of %lu",(unsigned long)partialLength);
//}
- (IBAction)touchSendMsg:(UIButton *)sender {
    //发送数据
//    [self sendCMD];
    TCPViewController *vc = [[TCPViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
}
- (IBAction)touchUDP:(UIButton *)sender {
    UDPViewController *vc = [[UDPViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}
//分割数据包

-(void)splitData:(NSData*)orignal_data {
//    NSUInteger l = [orignal_data length];
//    NSLog(@"Data length1 = %d",l);
//    NSString* sp = @"\n";
//    NSData* sp_data = [sp dataUsingEncoding:NSUTF8StringEncoding];
//    NSUInteger sp_length = [sp_data length];
//    NSUInteger offset = 0;
//    int line = 0;
//    while (TRUE) {
//        NSUInteger index = [self indexOfData:sp_data inData:orignal_data offset:offset];
//        if (NSNotFound == index) {
//            if (offset<l) {
//                NSLog(@"Have data not read");
//                NSRange range = {offset,l-offset};
//                NSData* rest = [orignal_data subdataWithRange:range];
//                if (restData == nil) {
//                    restData = [[NSMutableData alloc] init];
//                }
//                [restData appendData:rest];
//            }
//            return;
//        }
//        NSUInteger length = index + sp_length;
//        NSRange range = {offset,length-offset};
//        NSData* sub = [orignal_data subdataWithRange:range];
//        if (restData != nil) {
//            [restData appendData:sub];
//            //            [delegate readData:restData];
//            restData = nil;
//        } else {
//            NSLog(@"line %d",line++);
//            //            [delegate readData:sub];
//        }
//        offset += length;
//    }
}

//查找指定的数据包的位置
- (NSUInteger)indexOfData:(NSData*)needle inData:(NSData*)haystack offset:(NSUInteger)offset
{
    Byte* needleBytes = (Byte*)[needle bytes];
    Byte* haystackBytes = (Byte*)[haystack bytes];
    
    // walk the length of the buffer, looking for a byte that matches the start
    // of the pattern; we can skip (|needle|-1) bytes at the end, since we can't
    // have a match that's shorter than needle itself
    for (NSUInteger i=offset; i < [haystack length]-[needle length]+1; i++)
    {
        // walk needle's bytes while they still match the bytes of haystack
        // starting at i; if we walk off the end of needle, we found a match
        NSUInteger j=0;
        while (j < [needle length] && needleBytes[j] == haystackBytes[i+j])
        {
            j++;
        }
        if (j == [needle length])
        {
            return i;
        }
    }
    return NSNotFound;
}
//-(void)csocket
//{
//    // Do any additional setup after loading the view, typically from a nib.
//    /*1.协议
//     2.数据流 SOCK_STREAM TCP  UDP SOCK_DGRAM
//     3.协议(指定哪一种协议)
//     */
//    int client = socket(AF_INET,SOCK_STREAM, IPPROTO_TCP);
//    //连接
//    /*1.客户端的socket
//     2.客户端的IP地址
//     3.
//     */
//    struct sockaddr_in serviceAddr;
//    serviceAddr.sin_family = AF_INET;
//    serviceAddr.sin_port = htons(7070);
//    serviceAddr.sin_addr.s_addr = inet_addr("192.168.13.93");
//    //返回值 int  返回一个正数
//    int result=connect(client,(const struct sockaddr *)&serviceAddr, sizeof(serviceAddr));
//    if (result==0) {
//        NSLog(@"连接成功");
//        NSString *message=@"hello 中 World!";
//        //又是一个指针
//        /*
//         1.客户端 sc
//         2.发送内容的第一个指针
//         3.发送内容的长度
//         4.int 指的是 发送表示
//         */
//        ssize_t sendL = send(client,message.UTF8String, strlen(message.UTF8String), 0);
//        NSLog(@"你发送成了%zd",sendL);
//        //服务器给你回个消息
//        NSString *recvStr=@"hello 中 World!";
//        recv(client, recvStr.UTF8String, strlen(recvStr.UTF8String), 0);
//    }
//    else
//    {
//        NSLog(@"连接失败 错误码%d",result);
//    }
//}
///*连接成功回调*/
//- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(UInt16)port
//{
//    NSLog(@"连接成功");
//}
///*连接失败回调,做重新连接操作*/
//- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err
//{
//    [self.socket connectToHost:@"192.168.13.93" onPort:7070 error:nil];
//}
//- (IBAction)touchSendMsg:(UIButton *)sender {
//
//    [self.socket writeData:[@"GCD hello World！" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:10 tag:100];
//}
///**/
//- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag
//{
//    if (tag==100) {
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
