//
//  VideoTableViewController.m
//  SmartHousePad7
//
//  Created by gjt on 13-7-2.
//
//

#import "VideoTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ImageCollectionViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "VideoCategory.h"
#import "VideoAbstract.h"
#import "CategoryParser.h"


#define LocalVideoIndex 0
#define ImageIndex 1

#define ImageSectionTitle @"图片资源"
#define LocalVideoSectionTitle @"本地视频资源"
#define BrowseImageText @"浏览图片"
#define BrowseVideoText @"浏览视频"

#define VideoDir @"Video"
#define VideoIndexFileName @"VideoIndex.xml"



@interface VideoTableViewController ()

@end

@implementation VideoTableViewController

@synthesize videoCategory;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title=@"视频资源";
        VideoCategory*tmpCategory=[[VideoCategory alloc]init];
        self.videoCategory=tmpCategory;
        [tmpCategory release];
    }
    return self;
}

-(void)dealloc{
 
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self readLocalVideo];
    
    

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(LocalVideoIndex==section){
        return [self.videoCategory.videoAbstractArray count];
    }
    if (ImageIndex==section) {
        return 1;
    }


    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    if (LocalVideoIndex==indexPath.section) {
        VideoAbstract*va=[self.videoCategory.videoAbstractArray objectAtIndex:indexPath.row];
        cell.textLabel.text=va.name;
    }
    if (ImageIndex==indexPath.section) {
         cell.textLabel.text=BrowseImageText;
    }
    
   
    // Configure the cell...
   return cell;
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(LocalVideoIndex==section){
        return LocalVideoSectionTitle;
    }
    if (ImageIndex==section) {
        return ImageSectionTitle;
    }


    return  nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(LocalVideoIndex==indexPath.section){
        
        //[self selectVideo];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        VideoAbstract*va=[self.videoCategory.videoAbstractArray objectAtIndex:indexPath.row];
        
        NSString*docDirPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString*videoDirPath=[docDirPath stringByAppendingPathComponent:VideoDir];
        
        NSString*videoFilePath=[videoDirPath stringByAppendingPathComponent:va.playUrl];
        MPMoviePlayerViewController*mplayer=[[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL fileURLWithPath:videoFilePath]];
        [self.navigationController presentMoviePlayerViewControllerAnimated:mplayer];
        [mplayer release];
    }
    
    if (ImageIndex==indexPath.section) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(80, 80)];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        ImageCollectionViewController*icvc=[[ImageCollectionViewController alloc]init];
        [flowLayout release];
        
        [self.navigationController pushViewController:icvc animated:YES];
        [icvc release];
        return;
    }


    
}



-(void)readLocalVideo{
    NSString*docDirPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString*videoDirPath=[docDirPath stringByAppendingPathComponent:VideoDir];
    NSFileManager*manager=[NSFileManager defaultManager];
    BOOL isDir=NO;
    BOOL existed=[manager fileExistsAtPath:videoDirPath isDirectory:&isDir];
    if (isDir&&!existed){
        [manager createDirectoryAtPath:videoDirPath withIntermediateDirectories:nil attributes:nil error:nil];
    }
    NSString*videoIndexPath=[videoDirPath stringByAppendingPathComponent:VideoIndexFileName];
    if (![manager fileExistsAtPath:videoIndexPath]) {
        return;
    }
    
    NSData*data=[NSData dataWithContentsOfFile:videoIndexPath];
    CategoryParser*parser=[[CategoryParser alloc]init];
    VideoCategory*rootCategory=[parser parse:data];
    self.videoCategory=[rootCategory.subCategoryArray objectAtIndex:0];
    return;
 
}


@end
