#import "CustomCollectionViewLayout.h"
#import "AppSettings.h"

#define CELL_SIZE 50

@interface CustomCollectionViewLayout ()
@property (strong, nonatomic) NSMutableArray *itemAttributes;
@property (nonatomic, assign) CGSize contentSize;
@end

@implementation CustomCollectionViewLayout

- (void)prepareLayout
{
    if ([self.collectionView numberOfSections] == 0) {
        return;
    }
    
    self.itemAttributes = [@[] mutableCopy];
    
    if([self.collectionView numberOfSections] > 0) {
        NSInteger cellHeight = CELL_SIZE;
        if([AppSettings cellSize] > 0) {
            cellHeight = [AppSettings cellSize];
        }
        for (int section = 0; section < [self.collectionView numberOfSections]; section++) {
            NSMutableArray *sectionAttributes = [@[] mutableCopy];
            for (NSUInteger index = 0; index < [self.collectionView numberOfItemsInSection:section]; index++) {
                
                double xPos = (double)index * cellHeight;
                double yPos = (double)section * cellHeight;
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
                UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                 attributes.frame = CGRectIntegral(CGRectMake(xPos, yPos, cellHeight, cellHeight));
                // Determine zIndex based on cell type.
                if(section == 0 && index == 0) {
                    attributes.zIndex = 4;
                } else if (section == 0) {
                    attributes.zIndex = 3;
                } else if (index == 0) {
                    attributes.zIndex = 2;
                } else {
                    attributes.zIndex = 1;
                }
                [sectionAttributes addObject:attributes];
            }
            [self.itemAttributes addObject:sectionAttributes];
        }
        double contentWidth = (double)[self.collectionView numberOfItemsInSection:0] * cellHeight;
        double contentHeight = (double)[self.collectionView numberOfSections] * cellHeight;
        self.contentSize = CGSizeMake(contentWidth, contentHeight);
}
}

- (CGSize)collectionViewContentSize
{
    return self.contentSize;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemAttributes[indexPath.section][indexPath.row];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [@[] mutableCopy];
    for (NSArray *section in self.itemAttributes) {
        [attributes addObjectsFromArray:[section filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
            return CGRectIntersectsRect(rect, [evaluatedObject frame]);
        }]]];
    }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return NO; // Set this to YES to call prepareLayout on every scroll
}
@end
