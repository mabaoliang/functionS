//
//  TableViewController.m
//  Function
//
//  Created by 马宝亮 on 2017/12/4.
//  Copyright © 2017年 马宝亮. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()
@property(strong,nonatomic)NSArray *arrKey;
@property(strong,nonatomic)NSArray *arrValueClass;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(NSArray *)arrKey
{
    if (!_arrKey) {
        
        _arrKey=@[@"二维码生成",@"扫描二维码",@"手势解锁",@"重力感应",@"transForm",@"下拉框",@"自定义键盘",@"计步",@"统计图"];
    }

    return _arrKey;
}
-(NSArray *)arrValueClass
{
    if (!_arrValueClass) {
        _arrValueClass=@[@"GenerateQrCodeViewController",@"ScanQrCodeViewController",@"GesticulationViewController",@"GravityInductionViewController",@"TransformViewController",@"DropDownBoxViewController",@"KeyBoardViewController",@"StepGaugeViewController",@"BezierViewController"];
    }
  
    return _arrValueClass;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.arrKey.count;
}

#pragma mark - cell初始化事件
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"clas"];
    
    cell.textLabel.text=self.arrKey[indexPath.row];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - cell点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name=self.arrValueClass[indexPath.row];
    
    Class cls=NSClassFromString(name);
    
    UIViewController *vc=[[cls alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
