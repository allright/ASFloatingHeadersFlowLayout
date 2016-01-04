# ASFloatingHeadersFlowLayout

High performance implementation of CollectionView Flow Layout for Sticky/Floating headers behavior like in table view.
Used new iOS7/8 features with partial invalidation.

#Update for iOS9
 There is no more need to use ASFloatingHeadersFlowLayout in iOS9. Apple has been implement this functional, you can set to true
 sectionHeadersPinToVisibleBounds/sectionFootersPinToVisibleBounds properties in UICollectionViewFlowLayout.

```swift

@available(iOS 6.0, *)
public class UICollectionViewFlowLayout : UICollectionViewLayout {
    
    public var minimumLineSpacing: CGFloat
    public var minimumInteritemSpacing: CGFloat
    public var itemSize: CGSize
    @available(iOS 8.0, *)
    public var estimatedItemSize: CGSize // defaults to CGSizeZero - setting a non-zero size enables cells that self-size via -preferredLayoutAttributesFittingAttributes:
    public var scrollDirection: UICollectionViewScrollDirection // default is UICollectionViewScrollDirectionVertical
    public var headerReferenceSize: CGSize
    public var footerReferenceSize: CGSize
    public var sectionInset: UIEdgeInsets
    
    // Set these properties to YES to get headers that pin to the top of the screen and footers that pin to the bottom while scrolling (similar to UITableView).
    @available(iOS 9.0, *)
    public var sectionHeadersPinToVisibleBounds: Bool
    @available(iOS 9.0, *)
    public var sectionFootersPinToVisibleBounds: Bool
}
