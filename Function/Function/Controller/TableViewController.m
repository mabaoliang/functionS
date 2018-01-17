//
//  TableViewController.m
//  Function
//
//  Created by 马宝亮 on 2017/12/4.
//  Copyright © 2017年 马宝亮. All rights reserved.
//

#import "TableViewController.h"
#import "Coder.h"
@interface TableViewController ()
@property(strong,nonatomic)NSArray *arrKey;
@property(strong,nonatomic)NSArray *arrValueClass;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   
}

//多对象归档解档
-(void)coderMoreObject
{
    
    // 多个对象的归档解档-------------------
    
    Coder *a=[[Coder alloc]init];
    a.name=@"赵一";
    a.sex=@"男";
    a.age=21;
    
    Coder *b=[[Coder alloc]init];
    b.name=@"钱儿";
    b.sex=@"男";
    b.age=22;
    //新建一块可变数据区
    NSMutableData *data=[NSMutableData data];
    //将数据区连接到一个NSKeyedArchiver对象
    NSKeyedArchiver *archiver=[[NSKeyedArchiver alloc]initForWritingWithMutableData:data] ;
    // 开始存档对象，存档的数据都会存储到NSMutableData中 中资财经
    [archiver encodeObject:a forKey:@"a"];
    [archiver encodeObject:b forKey:@"b"];
    // 存档完毕(一定要调用这个方法)
    [archiver finishEncoding];
    //将存档的数据写入文件
    NSString *temp = NSTemporaryDirectory();
    NSString *filePath = [temp stringByAppendingPathComponent:@"coder.data"]; //注：保存文件的扩展名可以任意取
    [data writeToFile:filePath atomically:YES];
    //***************解当
    
    // 从文件中读取数据
    NSData *data1 = [NSData dataWithContentsOfFile:filePath];
    // 根据数据，解析成一个NSKeyedUnarchiver对象
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data1];
    Coder *person1 = [unarchiver decodeObjectForKey:@"a"];
    Coder *person2 = [unarchiver decodeObjectForKey:@"b"];
    NSLog(@"%@",person1.name);
    NSLog(@"%@",person2.name);
    // 恢复完毕
    [unarchiver finishDecoding];
    
    //_------------------------------------------
    
}
//单个对象的归档解档
-(void)coderDgWay
{
    //对象归档
    Coder *c=[[Coder alloc]init];
    c.name=@"肖明";
    c.sex=@"男";
    c.age=23;
    //这里以temp路径为例，存到temp路径下
    NSString *temp = NSTemporaryDirectory();
    NSString *filePath = [temp stringByAppendingPathComponent:@"obj.data"]; //注：保存文件的扩展名可以任意取，不影响。
    NSLog(@"%@", filePath);
    //归档
    [NSKeyedArchiver archiveRootObject:c toFile:filePath];
    
    //取出归档的文件再解档
    NSString *filePaths = [NSTemporaryDirectory() stringByAppendingPathComponent:@"obj.data"];
    //解档
    Coder *person = [NSKeyedUnarchiver unarchiveObjectWithFile:filePaths];
    NSLog(@"name = %@, age = %d",person.name,person.age);
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
