//
//  FaceKeyBorad.m
//  键盘切换
//
//  Created by Augus on 16/1/5.
//  Copyright © 2016年 刘伟华. All rights reserved.
//

#import "FaceKeyBorad.h"
#import "RecentFace.h"
#import <CoreData/CoreData.h>
#import "Coredata Manger.h"

#define SCREEN_SIZE [[UIScreen mainScreen]bounds].size
#define H  self.bounds.size.height
@interface FaceKeyBorad ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView * faceScrollView;
@property (strong, nonatomic)UIView * historyView;
@property (strong, nonatomic) UIButton * historyBtn;
@property (strong, nonatomic) UIButton * defaultBtn;
@property (strong, nonatomic) UIButton * confirmBtn;
@property (strong, nonatomic) UIPageControl * pageControl;
@property (strong, nonatomic) NSManagedObjectContext * context;
@end

@implementation FaceKeyBorad

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadModule];
    }
    return self;
}

- (void)loadModule
{
    //初始化上下文
    Coredata_Manger * manager = [Coredata_Manger shareCoreDataManager];
    self.context = manager.context;
    
//#warning 需要将表情贴到faceKB上
    //默认表情的view
    self.faceScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.faceScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.faceScrollView.pagingEnabled = YES;
    self.faceScrollView.delegate = self;
    [self addSubview:self.faceScrollView];
    //添加pageControl
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((SCREEN_SIZE.width-80)/2.0, (SCREEN_SIZE.width/2.0+3), 80, 20)];
    self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPage = 0;
    [self addSubview:self.pageControl];
    
    //历史表情view
    self.historyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 258)];
    self.historyView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.historyView.hidden = YES;
    [self addSubview:self.historyView];
    
    self.historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.historyBtn setTitle:@"历史" forState:UIControlStateNormal];
    [self.historyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.historyBtn.backgroundColor = [UIColor grayColor];
    self.historyBtn.tag = 1;
    [self.historyBtn addTarget:self action:@selector(tapFaceFuncButton:) forControlEvents:UIControlEventTouchUpInside];
    self.historyBtn.frame = CGRectMake(0, 218, self.bounds.size.width/3.0, 40);
    [self addSubview:self.historyBtn];
    
    self.defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.defaultBtn setTitle:@"默认" forState:UIControlStateNormal];
    [self.defaultBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.defaultBtn.backgroundColor = [UIColor grayColor];
    self.defaultBtn.tag = 2;
    [self.defaultBtn addTarget:self action:@selector(tapFaceFuncButton:) forControlEvents:UIControlEventTouchUpInside];
    self.defaultBtn.frame = CGRectMake(self.bounds.size.width/3.0, 218, self.bounds.size.width/3.0, 40);
    [self addSubview:self.defaultBtn];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.confirmBtn.backgroundColor = [UIColor grayColor];
    self.confirmBtn.enabled = NO;
    self.confirmBtn.tag = 3;
    [self.confirmBtn addTarget:self action:@selector(tapFaceFuncButton:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn.frame = CGRectMake(self.bounds.size.width/3.0*2, 218, self.bounds.size.width/3.0, 40);
    [self addSubview:self.confirmBtn];

    //检测数据源
    [self addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew context:nil];
    
    //注册通知
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(recieveToolViewNoti:) name:@"MyTextViewContentDidChange" object:nil];
}

- (void)recieveToolViewNoti:(NSNotification *)noti
{
    NSDictionary * dic = noti.userInfo;
    UITextView * textView = dic[@"content"];
    if (![textView.text isEqualToString:@""])
    {
        self.confirmBtn.enabled = YES;
        self.confirmBtn.backgroundColor = [UIColor orangeColor];
        if (self.changeToolViewHeight) {
            self.changeToolViewHeight(textView.contentSize.height+textView.font.ascender+textView.font.descender);
        }
    }else
    {
        self.confirmBtn.enabled = NO;
        self.confirmBtn.backgroundColor = [UIColor grayColor];
        if (self.changeToolViewHeight) {
            self.changeToolViewHeight(40.0);
        }
    }
}
//KVO事件处理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //在此处贴表情
    NSInteger count = [self.dataSource numberOfFaceItemInFaceKeyBoard:self];
    int pages = ceil(count / 32.0);
    self.pageControl.numberOfPages = pages;
    self.faceScrollView.contentSize = CGSizeMake(self.bounds.size.width*pages, self.bounds.size.height);
    for (int i = 0; i < count; i++)
    {
        //通过循环将表情贴到btn上
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        
        //当前表情在第几页
        int page = i / 32;
        //当前表情在某一页的第几个
        int index = i % 32;
        
        //当前表情在哪一行
        int row = index / 8;
        //当前表情在那一列
        int cloumn = index % 8;
        
        CGFloat bw = self.bounds.size.width / 8.0;
        CGFloat x = page * self.bounds.size.width + cloumn * bw;
        CGFloat y = row * bw;
        button.frame = CGRectMake(x, y, bw, bw);
        
        UIImage * image = [self.dataSource faceKeyBoard:self faceButtonWithFaceItemAtIndex:i];
        [button setImage:image forState:UIControlStateNormal];
        if (button.tag % 32 == 31) {
            [button addTarget:self action:@selector(tapDeleteItem:) forControlEvents:UIControlEventTouchUpInside];
        }else
        {
            [button addTarget:self action:@selector(tapFaceItem:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.faceScrollView addSubview:button];
        
    }
}

//当点击表情按钮时调用
- (void)tapFaceItem:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(faceKeyBoard:didTapFaceItemAtIndex:)])
    {
        [self.delegate faceKeyBoard:self didTapFaceItemAtIndex:btn.tag];
    }
}

- (void)tapDeleteItem:(UIButton *)btn
{
    if (self.faceDeleteStr) {
        self.faceDeleteStr();
    }
}

//当点击工具按钮时调用
- (void)tapFaceFuncButton:(UIButton *)btn
{
    [self changeFaceFuncButtonNormal];
    switch (btn.tag) {
        case 1://点击历史按钮
        {
            self.historyBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
            self.pageControl.hidden = YES;
            self.historyView.hidden = NO;
            self.faceScrollView.hidden = YES;
            
            //从数据库中获取所有表情
            NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:NSStringFromClass([RecentFace class])];
            NSSortDescriptor * sortD = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
            [request setSortDescriptors:@[sortD]];
            NSArray * list = [self.context executeFetchRequest:request error:nil];
            
            //移除历史界面上的所有表情再贴
            NSArray * subViews = self.historyView.subviews;
            
//            for (UIView * obj in subViews)
//            {
//                [obj removeFromSuperview];
//            }
            
            [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            NSMutableArray * mArr = [NSMutableArray arrayWithCapacity:32];
            int count ;
            if (list.count >32) {
                count = 32;
            }else
            {
                count = (int)list.count;
            }
            for (int k = 0; k < count; k++)
            {
                [mArr addObject:list[k]];
            }
            
            for (int j = 0; j < mArr.count; j++)
            {
                
                UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
                RecentFace * face;
                face = mArr[j];
                btn.tag = [face.faceIndex intValue];//？？？？为什么不使用j赋值
                
                //获取该表情是在第几个
                int index = j % 32;
                
                //第几行
                int row = index / 8;
                //第几列
                int cloumn = index % 8;
                
                CGFloat bw = self.bounds.size.width / 8.0;
                CGFloat x = cloumn * bw;
                CGFloat y = row * bw;
                btn.frame = CGRectMake(x, y, bw, bw);
                UIImage * image = [self.dataSource faceKeyBoard:self faceButtonWithFaceItemAtIndex:btn.tag];
                [btn setImage:image forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(tapFaceItem:) forControlEvents:UIControlEventTouchUpInside];
                [self.historyView addSubview:btn];
            }
            
            
            
            break;
        }
        case 2://点击默认
        {
            self.defaultBtn.backgroundColor = [UIColor groupTableViewBackgroundColor];
            self.historyView.hidden = YES;
            self.faceScrollView.hidden = NO;
            break;
        }
        case 3://点击确定
        {
            
            if (self.faceSendMessage) {
                self.faceSendMessage();
            }
            break;
        }
        default:
            break;
    }
}

- (void)changeFaceFuncButtonNormal
{
    self.historyBtn.backgroundColor = [UIColor grayColor];
    self.defaultBtn.backgroundColor = [UIColor grayColor];
}

#pragma mark ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    int currentPage = ceil(offset.x / SCREEN_SIZE.width);
    self.pageControl.currentPage = currentPage;
}
-(void)dealloc
{
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center removeObserver:self];
   [self removeObserver:self forKeyPath:@"dataSource"];
}
@end
