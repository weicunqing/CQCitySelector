//
//  CQCitySelectViewController.m
//  CQCitySelector
//
//  Created by 意一yiyi on 2017/3/1.
//  Copyright © 2017年 意一yiyi. All rights reserved.
//

#import "CQCitySelectViewController.h"

#import "CQSearchBarView.h"
#import "CQSearchResultView.h"
#import "CQPredicateTools.h"
#import "CQCityTableViewCell.h"
#import "CQSystemLocationTools.h"
#import "CQRegexTools.h"
#import "CQChineseToPinyinTools.h"

#define kNSUserDefaults [NSUserDefaults standardUserDefaults]

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kCityData ((NSDictionary *)[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CityData1" ofType:@"plist"]])

@interface CQCitySelectViewController ()<UITableViewDataSource, UITableViewDelegate, CQSystemLocationToolsDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) CQSearchBarView *tableHeaderView;
@property (strong, nonatomic) CQSearchResultView *searchResultView;

@property (strong, nonatomic) NSMutableArray *currentCityArray;// 当前城市

@property (strong, nonatomic) NSMutableArray *locateCityArray;// 定位城市

@property (strong, nonatomic) NSMutableArray *historyCityArray;// 最近访问城市

@property (strong, nonatomic) NSMutableArray *hotCityArray;// 热门城市

@property (strong, nonatomic) NSMutableArray *characterArray;// 索引字母
@property (strong, nonatomic) NSMutableArray *headerTitleArray;// 区头文本
@property (strong, nonatomic) NSMutableArray *sectionIndexArray;// 分区索引

@property (strong, nonatomic) NSMutableArray *allCityArray;// 所有城市

@property (strong, nonatomic) CQSystemLocationTools *CQSystemLocationTools;

@end

@implementation CQCitySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initialize];
    
    [self createVC];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.view endEditing:YES];
}


#pragma mark - initialize

- (void)initialize {
    
    // 当前城市
    self.currentCityArray = [NSMutableArray array];
    
    // 定位城市
    self.locateCityArray = [NSMutableArray array];
    
    // 最近访问城市
    self.historyCityArray = [NSMutableArray array];
    
    // 热门城市
    self.hotCityArray = [NSMutableArray arrayWithArray:@[@"北京", @"上海", @"广州", @"深圳", @"杭州", @"南京", @"成都", @"重庆", @"天津", @"西安", @"武汉"]];
    
    // 区头文本和分区索引
    self.characterArray = [NSMutableArray arrayWithArray:[[kCityData allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    self.headerTitleArray = [NSMutableArray arrayWithArray:@[@"当前城市", @"定位城市", @"最近访问城市", @"热门城市"]];
    [self.headerTitleArray addObjectsFromArray:self.characterArray];
    
    self.sectionIndexArray = [NSMutableArray arrayWithArray:@[@"!", @"#", @"$", @"*"]];
    [self.sectionIndexArray addObjectsFromArray:self.characterArray];
    
    // 所有城市
    self.allCityArray = [NSMutableArray array];
    for (NSString *string in self.characterArray) {
        
        [self.allCityArray addObjectsFromArray:kCityData[string]];
    }
    
    // 定位
    self.CQSystemLocationTools = [CQSystemLocationTools sharedCQSystemLocationTools];
    self.CQSystemLocationTools.delegate = self;
}


#pragma mark - createVC

- (void)createVC {
    
    // 导航栏
    self.navigationItem.title = @"城市选择";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"城市选择器-返回"] style:(UIBarButtonItemStylePlain) target:self action:@selector(leftBarButtonItemAction:)];
    
    // tableView
    [self tableViewConfiguration];
}


#pragma mark - action

- (void)leftBarButtonItemAction:(UIBarButtonItem *)barButtonItem {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 移除搜索界面
- (void)removeSearchResultView {
    
    [self.searchResultView removeFromSuperview];
    self.searchResultView = nil;
}

// 添加最近访问城市
- (void)addHistoryCityWithCityName:(NSString *)cityName {
    
    if ([self.historyCityArray containsObject:@"暂无"]) {
        
        [self.historyCityArray removeObject:@"暂无"];
    }
    
    if ([self.historyCityArray containsObject:cityName]) {// 避免重复添加, 先删除再添加
        
        [self.historyCityArray removeObject:cityName];
        [self.historyCityArray insertObject:cityName atIndex:0];
    }else {
        
        [self.historyCityArray insertObject:cityName atIndex:0];
    }
    
    if (self.historyCityArray.count > 3) {
        
        [self.historyCityArray removeLastObject];
    }
    
    [kNSUserDefaults setObject:self.historyCityArray forKey:@"historyCity"];
}


#pragma mark - tableView

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (void)tableViewConfiguration {
    
    [self.view addSubview:self.tableView];
    
    self.tableView.tableHeaderView = self.tableHeaderView;
    
    [self.tableView registerClass:[CQCityTableViewCell class] forCellReuseIdentifier:CQCityCollectionViewCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseID];
    
    // sectionIndex 的背景色和文本颜色
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexColor = self.tintColor;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.characterArray.count + 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section <= 3) {
        
        return 1;
    }else {
    
        return [kCityData[self.characterArray[section - 4]] count];
    }
}

static NSString * const CQCityCollectionViewCell = @"CQCityCollectionViewCell";
static NSString * const cellReuseID = @"cellReuseID";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section <= 3) {
        
        CQCityTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CQCityCollectionViewCell forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.block = ^(NSString *cityName) {
        
            // 更新当前城市
            [kNSUserDefaults setObject:cityName forKey:@"currentCity"];
            
            // 更新最近访问城市
            [self addHistoryCityWithCityName:cityName];
            
            self.block([kNSUserDefaults objectForKey:@"currentCity"]);
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        
        if (indexPath.section == 0) {
            
            if ([kNSUserDefaults objectForKey:@"currentCity"]) {
                
                self.currentCityArray = [NSMutableArray arrayWithArray:@[[kNSUserDefaults objectForKey:@"currentCity"]]];
            }else {
                
                self.currentCityArray = [NSMutableArray arrayWithArray:@[@"请选择"]];
            }
            
            cell.cityArray = self.currentCityArray;
        }else if (indexPath.section == 1) {
            
            if ([kNSUserDefaults objectForKey:@"locateCity"]) {
                
                self.locateCityArray = [NSMutableArray arrayWithArray:@[[kNSUserDefaults objectForKey:@"locateCity"]]];
            }else {
                
                self.locateCityArray = [NSMutableArray arrayWithArray:@[@"定位中..."]];
            }
            
            cell.cityArray = self.locateCityArray;
        }else if (indexPath.section == 2) {
            
            if ([kNSUserDefaults objectForKey:@"historyCity"]) {
                
                self.historyCityArray = [NSMutableArray arrayWithArray:[kNSUserDefaults objectForKey:@"historyCity"]];
            }else {
                
                self.historyCityArray = [NSMutableArray arrayWithArray:@[@"暂无"]];
            }
            
            cell.cityArray = self.historyCityArray;
        }else {
            
            cell.cityArray = self.hotCityArray;
        }
        
        return cell;
    }else {
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellReuseID forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.textLabel.text = kCityData[self.characterArray[indexPath.section - 4]][indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithRed:61 / 255.0 green:61 / 255.0 blue:61 / 255.0 alpha:1];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) {// 定位城市和最近访问城市
        
        return 54;
    }else if (indexPath.section == 3) {// 热门城市
        
        return 186;
    }else {
        
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 更新当前城市
    [kNSUserDefaults setObject:kCityData[self.characterArray[indexPath.section - 4]][indexPath.row] forKey:@"currentCity"];
    
    // 更新最近访问城市
    [self addHistoryCityWithCityName:kCityData[self.characterArray[indexPath.section - 4]][indexPath.row]];
    
    self.block([kNSUserDefaults objectForKey:@"currentCity"]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return self.headerTitleArray[section];
}

// 修改区头文本的一些属性
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *headerFooterView = (UITableViewHeaderFooterView *)view;
    
    if ([headerFooterView isKindOfClass:[UITableViewHeaderFooterView class]]) {
        
        headerFooterView.textLabel.font = [UIFont systemFontOfSize:13];
        headerFooterView.textLabel.textColor = [UIColor colorWithRed:108 / 255.0 green:108 / 255.0 blue:108 / 255.0 alpha:1];
        headerFooterView.contentView.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1];
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return self.sectionIndexArray;
}


#pragma mark - CQSystemLocationToolsDelegate

- (void)didFinishLocatingWithPlacemark:(CLPlacemark *)placemark {
    
    NSString *locateCity = [placemark.locality substringToIndex:placemark.locality.length - 1];
    NSLog(@"城市 : %@", locateCity);
    
    [kNSUserDefaults setObject:locateCity forKey:@"locateCity"];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] withRowAnimation:(UITableViewRowAnimationNone)];
}

- (void)refusedToLocateWithMessage:(NSString *)message {
    
    [kNSUserDefaults setObject:@"暂无" forKey:@"locateCity"];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] withRowAnimation:(UITableViewRowAnimationNone)];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didFailLocatingWithMessage:(NSString *)message {
    
    [kNSUserDefaults setObject:@"暂无" forKey:@"locateCity"];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] withRowAnimation:(UITableViewRowAnimationNone)];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
    [alertController addAction:confirmAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - 懒加载

- (CQSearchBarView *)tableHeaderView {
    
    if (!_tableHeaderView) {
        
        _tableHeaderView = [[CQSearchBarView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _tableHeaderView.backgroundColor = [UIColor clearColor];
        
        __weak typeof(self) weakSelf = self;
        
        _tableHeaderView.didBeginSearch = ^() {
            
            [weakSelf.view addSubview:weakSelf.searchResultView];
        };
        
        _tableHeaderView.textDidChange = ^(NSString *string) {
            
            if (string.length != 0) {
                
                weakSelf.searchResultView.keywords = string;
                weakSelf.searchResultView.keywordsColor = weakSelf.tintColor;
                
                if ([CQRegexTools validateChinese:string]) {
                    
                    weakSelf.searchResultView.searchResultArray = [NSMutableArray arrayWithArray:[CQPredicateTools searchResultWithSourceData:weakSelf.allCityArray Keywords:string]];
                }else {
                    
                    NSMutableArray *tempArray = [NSMutableArray array];
                    
                    for (NSString *chinese in weakSelf.allCityArray) {
                        
                        NSLog(@"%@", [[CQChineseToPinyinTools chineseToPinyinWithChinese:chinese] lowercaseString]);
                        
                        if ([[[CQChineseToPinyinTools chineseToPinyinWithChinese:chinese] lowercaseString] hasPrefix:string]) {
                            
                            [tempArray addObject:chinese];
                        }
                    }
                    
                    weakSelf.searchResultView.searchResultArray = tempArray;
                }
            }else {
                
                [weakSelf.searchResultView.searchResultTableView removeFromSuperview];
            }
        };
        
        _tableHeaderView.didCancelSearch = ^() {
            
            [weakSelf removeSearchResultView];
        };
    }
    
    return _tableHeaderView;
}

- (CQSearchResultView *)searchResultView {
    
    if (!_searchResultView) {
        
        _searchResultView = [[CQSearchResultView alloc] initWithFrame:CGRectMake(0, 64 + 44, kScreenWidth, kScreenHeight - 64 - 44)];
        _searchResultView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.382];
        
        __weak typeof(self) weakSelf = self;
        
        _searchResultView.tapView = ^() {
            
            [weakSelf.tableHeaderView cancelSearch];
        };
        
        _searchResultView.scroll = ^() {
            
            if (weakSelf.tableHeaderView.searchBar.isFirstResponder) {
    
                [weakSelf.tableHeaderView.searchBar resignFirstResponder];
            }
        };

        _searchResultView.selectCityBlock = ^(NSString *cityName) {
            
            // 更新当前城市
            [kNSUserDefaults setObject:cityName forKey:@"currentCity"];
            
            // 更新最近访问城市
            [weakSelf addHistoryCityWithCityName:cityName];
            
            weakSelf.block([kNSUserDefaults objectForKey:@"currentCity"]);
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
    }
    return _searchResultView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
