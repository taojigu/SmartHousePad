//
//  LocationViewController.m
//  SmartHousePad7
//
//  Created by gjt on 13-7-11.
//
//

#import "LocationViewController.h"
#import "LocationInfo.h"
#import "CCDirector.h"
#import "CC3Scene.h"
#import "AddLocationViewController.h"
#import "LocationDetailViewController.h"
#import "LocationDetailPadViewController.h"
#import "ImageCollectionViewController.h"

#define LocationInfoFileName @"LocationInfo.xml"

@interface LocationViewController ()

@end

@implementation LocationViewController

@synthesize locationArray;
@synthesize mainCC3Scene;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title=@"定位选择";
        self.locationArray=[LocationInfo arrayFromFile:LocationInfoFileName];
        
    }
    return self;
}

-(void)dealloc{
    [self.mainCC3Scene release];
    [self.locationArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentSizeForViewInPopover=CGSizeMake(320, 548);
    self.navigationItem.leftBarButtonItem=self.editButtonItem;
    
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLocation:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    [addButtonItem release];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.locationArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the cell...
    LocationInfo*li=[self.locationArray objectAtIndex:indexPath.row];
    cell.textLabel.text=li.locationName;
    cell.detailTextLabel.text=li.urlString;
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(UITableViewCellEditingStyleDelete==editingStyle, @"NOT valid edit style");
    [self.locationArray removeObjectAtIndex:indexPath.row];
    [LocationInfo synchronizeToFile:LocationInfoFileName array:self.locationArray];
    [self.tableView reloadData];
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationInfo*li=[self.locationArray objectAtIndex:indexPath.row];
    CC3Vector vct=li.location;
    CC3Camera*activeCamera=self.mainCC3Scene.activeCamera;
    activeCamera.location=vct;
    activeCamera.rotation=li.rotation;
    
    //LocationDetailViewController*ldvc=[[LocationDetailViewController alloc]init];
    //ldvc.locationInfo=li;
    
    LocationDetailPadViewController*ldvc=[[LocationDetailPadViewController alloc]init];
    ldvc.locationInfo=li;
    [self.navigationController pushViewController:ldvc animated:YES];
    [ldvc release];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(80, 80)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    /*
    ImageCollectionViewController*icvc=[[ImageCollectionViewController alloc]initWithCollectionViewLayout:flowLayout];
    [flowLayout release];
    
    [self.navigationController pushViewController:icvc animated:YES];
    [icvc release];
     */
    
    

}


#pragma mark - delegate messages

-(void)locationDidAdd:(AddLocationViewController*)viewController location:(LocationInfo*)location{
    
    NSAssert(0!=[location.locationName length],@"location name should not be nil");
    [self.locationArray addObject:location];
    [LocationInfo synchronizeToFile:LocationInfoFileName array:self.locationArray];
    [self.tableView reloadData];
    
}

#pragma mark - Selector messages
-(void)addLocation:(id)sender{

    CC3Camera*camera=self.mainCC3Scene.activeCamera;
    LocationInfo*li=[[LocationInfo alloc]init];
    NSString*newLocaitionId=[self locationIdFromArray:self.locationArray];
    li.locationId=newLocaitionId;
    li.location=camera.location;
    li.rotation=camera.rotation;
    
    AddLocationViewController*alvc=[[AddLocationViewController alloc]init];
    alvc.locationInfo=li;
    [li release];
    alvc.delegate=self;
    [self.navigationController pushViewController:alvc animated:YES];
    [alvc release];
}

-(NSString*)locationIdFromArray:(NSArray*)array{
    NSInteger locationIndex=0;
    if (nil==array||[array count]==0) {
        return [NSString stringWithFormat:@"%i",locationIndex];
    }
    for (LocationInfo*li in array) {
        NSInteger currentIndex=[li.locationId intValue];
        if (currentIndex>locationIndex) {
            locationIndex=currentIndex;
        }
    }
    locationIndex++;
    return [NSString stringWithFormat:@"%i",locationIndex];
}
@end
