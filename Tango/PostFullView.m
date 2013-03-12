#import "PostFullView.h"
#import "ST_Oembed.h"
#import "ST_Posts.h"
#import "ST_Comments.h"
#import "ST_Attachments.h"
#import "CSLinearLayoutView.h"
#import "CommentView.h"
#import "PostImageView.h"
#import "GSSystem.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
@interface  PostFullView()
{
    FullViewController *delegate;
    UILabel *_author;
    UILabel *_descriptionLabel;
    UILabel *_urlLabel;
    UILabel *_viaLabel;
    UIImageView *_authorThumbView;
    UIImageView *_postImageView;
    UIImageView *_likeImageView;
    UIImageView *_commentImageView;
    UIImageView *_reshareImageView;
    UIImageView *_viaauthorThumbView;
    UIImageView *_linkImageView;
    UILabel *_likes;
    UILabel *_imglabel;
    UILabel *_comments;
    UILabel *_reshares;
    float cellwidth;
    float cellheight;
    BOOL isportrait;
    CGRect cgrcontent;
    CGRect cgrc;
    CGRect cgrstatus;
    CGRect cgrimage;
    CGRect imgframe;
    ST_Posts* post;
    CommentView *morecview;
    GSSystem *GSMainSystem;
    NSMutableArray* commentviews;
    BOOL postisPortrait;
}
@end

@implementation PostFullView
@synthesize verticallinearLayoutView;
@synthesize horizontalStatuslinearLayoutView;
@synthesize post;
@synthesize delegate;
@synthesize fullLayoutView;
@synthesize verticalcommentLayoutView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    GSMainSystem = [[GSSystem alloc]init]; //create one of these for each view you want to use the grid system on.
    return  self;
}

- (void)setPost:(ST_Posts *) pst :(BOOL) isPortrait;
{
    post = pst;
    [self setPostLayout:isPortrait];
    postisPortrait = isPortrait;
    [self addLayouts];
    [self addLayoutComps];
    [self setComments];
    [self setPostEmpty];
    [self setPostValues];
}

- (void) setPostFrameLayouts:(CSLinearLayoutView*)layout :(int)orientation{
    layout.orientation = orientation;
    layout.scrollEnabled = YES;
    layout.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   // layout.backgroundColor = [UIColor whiteColor];
    [self addSubview:layout];
}

- (void)setPostValues{
    _author.text        = post.author;
    if(post.wallurl.length>1) {
         _imglabel.text  =  [@"  " stringByAppendingString: post.content];
        [self addLinearItem : _imglabel : verticallinearLayoutView :CSLinearLayoutItemVerticalAlignmentTop];
    }else{
        if([post.oembed count]>0){
            ST_Oembed *embed = (ST_Oembed*)[post.oembed objectAtIndex:0];
            NSString *imgurl = embed.imageUrl;
            if ((NSNull *)imgurl == [NSNull null]) { imgurl=@""; }
            if(imgurl.length > 7) {
                [_postImageView setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"Image_Holder"]];
                [self addLinearItem : _postImageView : fullLayoutView :CSLinearLayoutItemVerticalAlignmentCenter];
                _imglabel.text  = [@"  " stringByAppendingString: post.content];
                [self addLinearItem : _imglabel : verticallinearLayoutView :CSLinearLayoutItemVerticalAlignmentBottom];
            }else{
                _descriptionLabel.text  = post.content;
                [self addLinearItem : _descriptionLabel : fullLayoutView :CSLinearLayoutItemVerticalAlignmentCenter];
            }
            _urlLabel.text = embed.Url; 
            _linkImageView.image = [UIImage imageNamed:@"connect"];
        }else{
            _postImageView.image = nil;
            _descriptionLabel.text  = post.content;
            [self addLinearItem : _descriptionLabel : fullLayoutView :CSLinearLayoutItemVerticalAlignmentCenter];
        }
    } 
    
    _likeImageView.image = [UIImage imageNamed:@"likeGreen"];
    NSString *unlike = post.unlike;
    if ((NSNull *)unlike == [NSNull null]) { unlike=@""; }
    if(unlike.length>0){
        _likeImageView.image = [UIImage imageNamed:@"unlikeGreen"];
    }
    [self addLinearItem : _likeImageView : horizontalStatuslinearLayoutView :CSLinearLayoutItemHorizontalAlignmentLeft];
   _likes.text =[NSString stringWithFormat:@"%d %s",post.likeCount , " likes"];
    [self addLinearItem : _likes : horizontalStatuslinearLayoutView :CSLinearLayoutItemHorizontalAlignmentLeft];
    
    _commentImageView.image = [UIImage imageNamed:@"commentGreen"];
    [self addLinearItem : _commentImageView : horizontalStatuslinearLayoutView :CSLinearLayoutItemHorizontalAlignmentLeft];
    _comments.text = [NSString stringWithFormat:@"%d %s", post.commentsCount, " comments"];
    [self addLinearItem : _comments : horizontalStatuslinearLayoutView :CSLinearLayoutItemHorizontalAlignmentLeft];
    
    _reshareImageView.image = [UIImage imageNamed:@"reshareGreen"];
    [self addLinearItem : _reshareImageView : horizontalStatuslinearLayoutView :CSLinearLayoutItemHorizontalAlignmentLeft];
    _reshares.text = [NSString stringWithFormat:@"%d %s", post.reshareCount, " reshares"];
    [self addLinearItem : _reshares : horizontalStatuslinearLayoutView :CSLinearLayoutItemHorizontalAlignmentLeft];
    
    [self addLinearItem : _linkImageView : horizontalStatuslinearLayoutView :CSLinearLayoutItemHorizontalAlignmentLeft];
    [self addLinearItem : _urlLabel : horizontalStatuslinearLayoutView :CSLinearLayoutItemHorizontalAlignmentLeft];
    
    [_authorThumbView setImageWithURL:[NSURL URLWithString:post.authorImageMediumUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}
- (void) setlikecount:(int)count :(BOOL)liked{
    _likes.text = [NSString stringWithFormat:@"%d %s",count , " likes"];
    if(liked){
        _likeImageView.image = [UIImage imageNamed:@"likeGreen"];
    }else{
        _likeImageView.image = [UIImage imageNamed:@"unlikeGreen"];
    }
}
- (void) setPostEmpty{
    _author.text = nil; 
    _descriptionLabel.text  = nil;
    _urlLabel.text = nil;
    _likes.text = nil;
    _comments.text = nil;
    _reshares.text = nil;
    _imglabel.text =nil;
    _postImageView.image = nil; 
    _linkImageView.image = nil; 
    _likeImageView.image=nil;
    _commentImageView.image=nil;
    _reshareImageView.image=nil;
    _authorThumbView.image=nil;
}
 
- (void) setPostLayout:(BOOL)isPortrait{
    [GSMainSystem createPoints:self:true]; 
    if(isPortrait){
        cgrcontent = CGRectMake(0, 0, [GSMainSystem twelveTwelfthsLeft] , [GSMainSystem oneTwentyFourTop]);
        cgrimage= CGRectMake(0, [GSMainSystem oneTwentyFourTop], [GSMainSystem twelveTwelfthsLeft] , [GSMainSystem nineTwelfthsTop] );
        cgrc = CGRectMake(0, [GSMainSystem tenTwelfthsTop],  [GSMainSystem twelveTwelfthsLeft], [GSMainSystem twoTwelfthsTop]);
        cgrstatus= CGRectMake(0, [GSMainSystem nineTwelfthsTop],[GSMainSystem twelveTwelfthsLeft],[GSMainSystem oneTwentyFourTop]);
        verticalcommentLayoutView.orientation = CSLinearLayoutViewOrientationHorizontal;        
        imgframe = CGRectMake(0, 0, [GSMainSystem twelveTwelfthsLeft], [GSMainSystem nineTwelfthsTop] );
    }else{
        cgrcontent = CGRectMake(0, 0, [GSMainSystem tenTwelfthsLeft], [GSMainSystem oneTwelfthTop]);
        cgrimage= CGRectMake(0, [GSMainSystem oneTwelfthTop], [GSMainSystem tenTwelfthsLeft] ,[GSMainSystem nineTwelfthsTop]);
        cgrc = CGRectMake( [GSMainSystem tenTwelfthsLeft], 0, [GSMainSystem twoTwelfthsLeft], [GSMainSystem twelveTwelfthsTop]);
        cgrstatus= CGRectMake(0, [GSMainSystem tenTwelfthsTop],[GSMainSystem tenTwelfthsLeft], [GSMainSystem oneTwentyFourTop]);
        verticalcommentLayoutView.orientation = CSLinearLayoutViewOrientationVertical;
        imgframe = CGRectMake(0, 0,[GSMainSystem tenTwelfthsLeft], [GSMainSystem nineTwelfthsTop]);
    }
    verticallinearLayoutView.frame = cgrcontent;
    verticalcommentLayoutView.frame = cgrc;
    horizontalStatuslinearLayoutView.frame = cgrstatus;
    fullLayoutView.frame = cgrimage;
    _descriptionLabel.frame = imgframe;
    _postImageView.frame = imgframe;
    for( CommentView *cview  in commentviews){
        [cview setLayout:isPortrait];
    }
}

- (void) addLayouts{
    verticallinearLayoutView = [[CSLinearLayoutView alloc] initWithFrame:cgrcontent];
    verticalcommentLayoutView =  [[CSLinearLayoutView alloc] initWithFrame:cgrc];
    horizontalStatuslinearLayoutView =  [[CSLinearLayoutView alloc] initWithFrame:cgrstatus];
    fullLayoutView = [[CSLinearLayoutView alloc] initWithFrame:cgrimage];
    [self setPostFrameLayouts : verticallinearLayoutView :CSLinearLayoutViewOrientationHorizontal ];
    [self setPostFrameLayouts : verticalcommentLayoutView :CSLinearLayoutViewOrientationHorizontal];
    [self setPostFrameLayouts : horizontalStatuslinearLayoutView :CSLinearLayoutViewOrientationHorizontal];
    [self setPostFrameLayouts : fullLayoutView :CSLinearLayoutViewOrientationHorizontal];
}

- (void) addLayoutComps{
    CGFloat textHeight = 20;
    
    _authorThumbView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,textHeight,[GSMainSystem oneTwentyFourTop])];
    _authorThumbView.layer.masksToBounds = YES;
    _authorThumbView.layer.cornerRadius  = 15.0;
    _authorThumbView.contentMode = UIViewContentModeScaleAspectFit;
    [self addLinearItem : _authorThumbView : verticallinearLayoutView :CSLinearLayoutItemVerticalAlignmentTop];
    
    _author= [[UILabel alloc] initWithFrame:CGRectMake(0,0,[GSMainSystem threeTwelfthsLeft], textHeight)];
    _author.font  = [UIFont systemFontOfSize:18.0];
    _author.numberOfLines=0;
    _author.backgroundColor = [UIColor clearColor];
    [self addLinearItem : _author : verticallinearLayoutView :CSLinearLayoutItemVerticalAlignmentTop];
    
    _descriptionLabel = [[UILabel alloc] initWithFrame:imgframe];
    _descriptionLabel.font              = [UIFont systemFontOfSize:14.0];
    _descriptionLabel.textColor         = [UIColor blackColor];
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.backgroundColor   = [UIColor clearColor];

    _postImageView = [[UIImageView alloc] initWithFrame:imgframe];
    _postImageView.layer.masksToBounds = YES;
    _postImageView.layer.cornerRadius  = 20.0;
    _postImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    _imglabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [GSMainSystem fourTwelfthsLeft],[GSMainSystem oneTwentyFourTop])];
    _imglabel.font              = [UIFont systemFontOfSize:12.0];
    _imglabel.numberOfLines = 0;
    _imglabel.textColor         = [UIColor blackColor];
    _imglabel.backgroundColor   = [UIColor clearColor];    
    
    _likeImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, textHeight, textHeight)];
    _likes =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [GSMainSystem twoTwelfthsLeft], textHeight)];
    _likes.font              = [UIFont systemFontOfSize:12.0];
    _likes.textColor         = [UIColor blackColor];
    _likes.backgroundColor   = [UIColor clearColor];
    
    _commentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,  textHeight, textHeight)];
    _comments =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [GSMainSystem twoTwelfthsLeft], textHeight)];
    _comments.font              = [UIFont systemFontOfSize:12.0];
    _comments.textColor         = [UIColor blackColor];
    _comments.backgroundColor   = [UIColor clearColor];
    
    _reshareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, textHeight, textHeight)];
    _reshares =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [GSMainSystem twoTwelfthsLeft], textHeight)];
    _reshares.font              = [UIFont systemFontOfSize:12.0];
    _reshares.textColor         = [UIColor blackColor];
    _reshares.backgroundColor   = [UIColor clearColor];
    
    _linkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, textHeight, textHeight)];
    _urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [GSMainSystem twoTwelfthsLeft], textHeight)];
    _urlLabel.font            = [UIFont systemFontOfSize:12.0];
    _urlLabel.textColor         = [UIColor blueColor];
    _urlLabel.backgroundColor = [UIColor clearColor];
}

- (void)setComments{    
    commentviews = [[NSMutableArray alloc] init];
    for(ST_Comments *comment in post.commentsArr){
        [self setCommentView:comment];
    }
    NSString *cmturl = post.allCommentsUrl;
    if ((NSNull *)cmturl == [NSNull null]) { cmturl=@""; }

    if(cmturl.length>0){ 
        CGRect cframe = CGRectMake(0, 0, [GSMainSystem twelveTwelfthsLeft], [GSMainSystem twelveTwelfthsTop]);
        morecview = [[CommentView alloc]initWithFrame:cframe];
        morecview.delegate =self;
        morecview.moreurl = cmturl;         
        [morecview setMore :postisPortrait];
        [commentviews addObject:morecview];
        [self addLinearItem : morecview : verticalcommentLayoutView :CSLinearLayoutItemVerticalAlignmentTop];

    }
    for(ST_Attachments *img in post.images){
            PostImageView *postImage= [[PostImageView alloc]initWithFrame:imgframe];
            [postImage setImageURL:img.Url];
            [self addLinearItem : postImage : fullLayoutView :CSLinearLayoutItemHorizontalAlignmentCenter];
        }
    
}
- (void)setCommentView:(ST_Comments*)comment
{
    CGFloat textHeight = 20;
    CGRect cframe = CGRectMake(0, 0, [GSMainSystem twelveTwelfthsLeft], textHeight*5);
    CommentView *cview = [[CommentView alloc]initWithFrame:cframe];
    cview.delegate =self;
    [cview setComment:comment :postisPortrait];
    [commentviews addObject:cview];
    [self addLinearItem : cview : verticalcommentLayoutView :CSLinearLayoutItemVerticalAlignmentTop];
}

- (void)clikeAction: (NSString*)likeurl
{
    //[self.delegate commentlikeAction:likeurl];
}

- (void)cunlikeAction: (NSString*)likeurl
{
   // [self.delegate commentunLikeAction:likeurl];
}

- (void)handleTapView:(UITapGestureRecognizer*)recognizer {
    for(CSLinearLayoutItem *item in self.verticallinearLayoutView.items) {
        if(item.view == recognizer.view) {
            if(item.view == _author){
               // [self.delegate loadProfile: post.authorUrl];
            }else if(item.view != _author){
               
            }
        }
    }
     for(CSLinearLayoutItem *item in self.verticalcommentLayoutView.items) {
         if(item.view == recognizer.view) {
             if(item.view == morecview ){
                 [commentviews removeLastObject];
                 //for(ST_Comments *comment in [self.delegate getMoreComments:morecview.moreurl]){
                 //    [self setCommentView:comment];
                 //}
             }
         }
     }
    
    for(CSLinearLayoutItem *item in self.horizontalStatuslinearLayoutView.items) {
        if(item.view == recognizer.view) {
            if(item.view == _urlLabel || item.view == _linkImageView){
                //[self.delegate loadWebURL: _urlLabel.text];
            }else if(item.view == _likeImageView || item.view == _likes){
                NSString *unlike = post.unlike;
                if ((NSNull *)unlike == [NSNull null]) { unlike=@""; }
                if(unlike.length>0){
                    //[self.delegate likeAction:post.unlike ];
                }else{
                  //  [self.delegate likeAction:post.likeUrl ];
                }
            }else if(item.view == _reshareImageView|| item.view == _reshares){
             //   [self.delegate reshareAction:post.reshareUrl ];
            }else if(item.view == _commentImageView|| item.view == _comments){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Social Tango" message:@"Enter your comment:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField * alertTextField = [alertView textFieldAtIndex:0];
                alertTextField.placeholder = @"Enter your comment";
                [alertView show];
            }
            break;
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  //  NSString *ctxt = [[alertView textFieldAtIndex:0] text];
    //[self.delegate createComment:post.postId :ctxt];
}

- (void)addLinearItem : (UIView*)view :(CSLinearLayoutView*)layout :(int)alignment{
    CSLinearLayoutItem *item = [CSLinearLayoutItem layoutItemForView:view];
    item.padding = CSLinearLayoutMakePadding(5.0, 5.0, 0.0, 5.0);
    view.userInteractionEnabled = YES;
    if(alignment==CSLinearLayoutItemHorizontalAlignmentCenter || alignment==CSLinearLayoutItemHorizontalAlignmentLeft ||
       alignment==CSLinearLayoutItemHorizontalAlignmentRight){ 
        item.horizontalAlignment = alignment;
    }else{
        item.verticalAlignment = alignment;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapView:)];
    [view addGestureRecognizer:tap];
    [layout addItem:item];
}
@end