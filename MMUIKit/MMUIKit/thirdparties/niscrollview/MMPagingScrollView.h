//
// Copyright 2011-2014 NimbusKit
// Copyright 2012 Manu Cornet (vertical layouts)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * numberOfPages will be this value until reloadData is called.
 */
extern const NSInteger MMPagingScrollViewUnknownNumberOfPages;

/**
 * The default number of pixels on the side of each page.
 *
 * Value: 10
 */
extern const CGFloat MMPagingScrollViewDefaultPageMargin;

typedef enum {
  MMPagingScrollViewHorizontal = 0,
  MMPagingScrollViewVertical,
} MMPagingScrollViewType;

@protocol MMPagingScrollViewDataSource;
@protocol MMPagingScrollViewDelegate;
@protocol MMPagingScrollViewPage;
@protocol MMRecyclableView;
@class MMViewRecycler;

/**
 * The MMPagingScrollView class provides a UITableView-like interface for loading pages via a data
 * source.
 *
 * @ingroup NimbusPagingScrollView
 */
@interface MMPagingScrollView : UIView <UIScrollViewDelegate>

#pragma mark Data Source

- (void)reloadData;
@property (nonatomic, weak) id<MMPagingScrollViewDataSource> dataSource;
@property (nonatomic, weak) id<MMPagingScrollViewDelegate> delegate;

// It is highly recommended that you use this method to manage view recycling.
- (UIView<MMPagingScrollViewPage> *)dequeueReusablePageWithIdentifier:(NSString *)identifier;

#pragma mark State

- (UIView<MMPagingScrollViewPage> *)centerPageView;
@property (nonatomic) NSInteger centerPageIndex; // Use moveToPageAtIndex:animated: to animate to a given page.

@property (nonatomic, readonly) NSInteger numberOfPages;

#pragma mark Configuring Presentation

// Controls the border between pages.
@property (nonatomic) CGFloat pageMargin;
// Used to make the view smaller than the frame of the paging scroll view, thus showing
// neighboring pages, either horizontally or vertically depending on the configuration
// of the view.
@property (nonatomic) CGFloat pageInset;
@property (nonatomic) MMPagingScrollViewType type; // Default: MMPagingScrollViewHorizontal

#pragma mark Visible Pages

- (BOOL)hasNext;
- (BOOL)hasPrevious;
- (void)moveToNextAnimated:(BOOL)animated;
- (void)moveToPreviousAnimated:(BOOL)animated;
- (BOOL)moveToPageAtIndex:(NSInteger)pageIndex animated:(BOOL)animated updateVisiblePagesWhileScrolling:(BOOL)updateVisiblePagesWhileScrolling;

// Short form for moveToPageAtIndex:pageIndex animated:animated updateVisiblePagesWhileScrolling:NO
- (BOOL)moveToPageAtIndex:(NSInteger)pageIndex animated:(BOOL)animated;

#pragma mark Rotating the Scroll View

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end

/**
 * The delegate for MMPagingScrollView.
 *
 * @ingroup NimbusPagingScrollView
 */
@protocol MMPagingScrollViewDelegate <UIScrollViewDelegate>
@optional

#pragma mark Scrolling and Zooming /** @name [NIPhotoAlbumScrollViewDelegate] Scrolling and Zooming */

/**
 * The user is scrolling between two photos.
 */
- (void)pagingScrollViewDidScroll:(MMPagingScrollView *)pagingScrollView;

#pragma mark Changing Pages /** @name [MMPagingScrollViewDelegate] Changing Pages */

/**
 * The current page will change.
 *
 * pagingScrollView.centerPageIndex will reflect the old page index, not the new
 * page index.
 */
- (void)pagingScrollViewWillChangePages:(MMPagingScrollView *)pagingScrollView;

/**
 * The current page has changed.
 *
 * pagingScrollView.centerPageIndex will reflect the changed page index.
 */
- (void)pagingScrollViewDidChangePages:(MMPagingScrollView *)pagingScrollView;

@end

/**
 * The data source for MMPagingScrollView.
 *
 * @ingroup NimbusPagingScrollView
 */
@protocol MMPagingScrollViewDataSource <NSObject>
@required

#pragma mark Fetching Required Album Information /** @name [MMPagingScrollViewDataSource] Fetching Required Album Information */

/**
 * Fetches the total number of pages in the scroll view.
 *
 * The value returned in this method will be cached by the scroll view until reloadData
 * is called again.
 */
- (NSInteger)numberOfPagesInPagingScrollView:(MMPagingScrollView *)pagingScrollView;

/**
 * Fetches a page that will be displayed at the given page index.
 *
 * You should always try to reuse pages by calling dequeueReusablePageWithIdentifier: on the
 * paging scroll view before allocating a new page.
 */
- (UIView<MMPagingScrollViewPage> *)pagingScrollView:(MMPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex;

@end

/**
 * The protocol that a paging scroll view page should implement.
 *
 * By providing a protocol instead of a UIView base class we allow more flexibility when
 * building pages.
 *
 * @ingroup NimbusPagingScrollView
 */
@protocol MMPagingScrollViewPage <MMRecyclableView>
@required

/**
 * The index of this page view.
 */
@property (nonatomic, assign) NSInteger pageIndex;

@optional

/**
 * Called after the page has gone off-screen.
 *
 * This method should be used to reset any state information after a page goes off-screen.
 * For example, in the Nimbus photo viewer we reset the zoom scale so that if the photo
 * was zoomed in it will fit on the screen again when the user flips back and forth between
 * two pages.
 */
- (void)pageDidDisappear;

/**
 * Called when the frame of the page is going to change.
 *
 * Use this method to maintain any state that may be affected by the frame changing.
 * The Nimbus photo viewer uses this method to save and restore the zoom and center
 * point. This makes the photo always appear to rotate around the center point of the screen
 * rather than the center of the photo.
 */
- (void)setFrameAndMaintainState:(CGRect)frame;

@end

/** @name Data Source */

/**
 * The data source for this page album view.
 *
 * This is the only means by which this paging view acquires any information about the
 * album to be displayed.
 *
 * @fn MMPagingScrollView::dataSource
 */

/**
 * Force the view to reload its data by asking the data source for information.
 *
 * This must be called at least once after dataSource has been set in order for the view
 * to gather any presentable information.
 *
 * This method is cheap because we only fetch new information about the currently displayed
 * pages. If the number of pages shrinks then the current center page index will be decreased
 * accordingly.
 *
 * @fn MMPagingScrollView::reloadData
 */

/**
 * Dequeues a reusable page from the set of recycled pages.
 *
 * If no pages have been recycled for the given identifier then this will return nil.
 * In this case it is your responsibility to create a new page.
 *
 * @fn MMPagingScrollView::dequeueReusablePageWithIdentifier:
 */

/**
 * The delegate for this paging view.
 *
 * Any user interactions or state changes are sent to the delegate through this property.
 *
 * @fn MMPagingScrollView::delegate
 */

/** @name Configuring Presentation */

/**
 * The number of pixels on either side of each page.
 *
 * The space between each page will be 2x this value.
 *
 * By default this is MMPagingScrollViewDefaultPageMargin.
 *
 * @fn MMPagingScrollView::pageMargin
 */

/**
 * The type of paging scroll view to display.
 *
 * This property allows you to configure whether you want a horizontal or vertical paging scroll
 * view. You should set this property before you present the scroll view and not modify it after.
 *
 * By default this is MMPagingScrollViewHorizontal.
 *
 * @fn MMPagingScrollView::type
 */

/** @name State */

/**
 * The current center page view.
 *
 * If no pages exist then this will return nil.
 *
 * @fn MMPagingScrollView::centerPageView
 */

/**
 * The current center page index.
 *
 * This is a zero-based value. If you intend to use this in a label such as "page ## of n" be
 * sure to add one to this value.
 *
 * Setting this value directly will center the new page without any animation.
 *
 * @fn MMPagingScrollView::centerPageIndex
 */

/**
 * Change the center page index with optional animation.
 *
 * This method is deprecated in favor of
 * @link MMPagingScrollView::moveToPageAtIndex:animated: moveToPageAtIndex:animated:@endlink
 *
 * @fn MMPagingScrollView::setCenterPageIndex:animated:
 */

/**
 * The total number of pages in this paging view, as gathered from the data source.
 *
 * This value is cached after reloadData has been called.
 *
 * Until reloadData is called the first time, numberOfPages will be
 * MMPagingScrollViewUnknownNumberOfPages.
 *
 * @fn MMPagingScrollView::numberOfPages
 */

/** @name Changing the Visible Page */

/**
 * Returns YES if there is a next page.
 *
 * @fn MMPagingScrollView::hasNext
 */

/**
 * Returns YES if there is a previous page.
 *
 * @fn MMPagingScrollView::hasPrevious
 */

/**
 * Move to the next page if there is one.
 *
 * @fn MMPagingScrollView::moveToNextAnimated:
 */

/**
 * Move to the previous page if there is one.
 *
 * @fn MMPagingScrollView::moveToPreviousAnimated:
 */

/**
 * Move to the given page index with optional animation.
 *
 * @returns NO if a page change animation is already in effect and we couldn't change the page
 *               again.
 * @fn MMPagingScrollView::moveToPageAtIndex:animated:
 */

/**
 * Move to the given page index with optional animation and option to enable page updates while
 * scrolling.
 *
 * NOTE: Passing YES for moveToPageAtIndex:animated:updateVisiblePagesWhileScrolling will cause
 * every page from the present page to the destination page to be loaded. This has the potential to
 * cause choppy animations.
 *
 * @param updateVisiblePagesWhileScrolling If YES, will query the data source for any pages
 *                                              that become visible while the animation occurs.
 * @returns NO if a page change animation is already in effect and we couldn't change the page
 *               again.
 * @fn MMPagingScrollView::moveToPageAtIndex:animated:updateVisiblePagesWhileScrolling:
 */

/** @name Rotating the Scroll View */

/**
 * Stores the current state of the scroll view in preparation for rotation.
 *
 * This must be called in conjunction with willAnimateRotationToInterfaceOrientation:duration:
 * in the methods by the same name from the view controller containing this view.
 *
 * @fn MMPagingScrollView::willRotateToInterfaceOrientation:duration:
 */

/**
 * Updates the frame of the scroll view while maintaining the current visible page's state.
 *
 * @fn MMPagingScrollView::willAnimateRotationToInterfaceOrientation:duration:
 */

/** @name Subclassing */

/**
 * The internal scroll view.
 *
 * Meant to be used by subclasses only.
 *
 * @fn MMPagingScrollView::pagingScrollView
 */

/**
 * The set of currently visible pages.
 *
 * Meant to be used by subclasses only.
 *
 * @fn MMPagingScrollView::visiblePages
 */
