#import "LineLayout.h"

#define ITEM_SIZEW 225.0
#define ITEM_SIZEH 150.0
#define ITEM_PHONE_SIZEW 140.0
#define ITEM_PHONE_SIZEH 120.0
#define ITEM_SPACING 25.0
#define ITEM_PHONE_SPACING 15.0
@implementation LineLayout

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.0

-(id)init
{
    self = [super init];
    if (self) {
        if(AppDelegate.deviceIsPhone){
            self.itemSize = CGSizeMake(ITEM_PHONE_SIZEW, ITEM_PHONE_SIZEH);
            self.sectionInset = UIEdgeInsetsMake(ITEM_PHONE_SPACING, ITEM_PHONE_SPACING, ITEM_PHONE_SPACING, ITEM_PHONE_SPACING);
        }else{
            self.itemSize = CGSizeMake(ITEM_SIZEW, ITEM_SIZEH);
            self.sectionInset = UIEdgeInsetsMake(ITEM_SPACING, ITEM_SPACING, ITEM_SPACING, ITEM_SPACING);
        }
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 40.0;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
            }
        }
    }
    return array;
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end