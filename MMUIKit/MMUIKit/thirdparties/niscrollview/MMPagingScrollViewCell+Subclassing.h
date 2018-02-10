//
// Copyright 2011-2014 NimbusKit
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

#import "MMPagingScrollView.h"

// Methods that are meant to be subclassed.
@interface MMPagingScrollView (Subclassing)

// Meant to be subclassed. Default implementations are stubs.
- (void)willDisplayPage:(UIView<MMPagingScrollViewPage> *)pageView;
- (void)didRecyclePage:(UIView<MMPagingScrollViewPage> *)pageView;
- (void)didReloadNumberOfPages;
- (void)didChangeCenterPageIndexFrom:(NSInteger)from to:(NSInteger)to;

// Meant to be subclassed.
- (UIView<MMPagingScrollViewPage> *)loadPageAtIndex:(NSInteger)pageIndex;

#pragma mark Accessing Child Views

- (UIScrollView *)scrollView;
- (NSMutableSet *)visiblePages; // Set of UIView<MMPagingScrollViewPage>*

@end

// Methods that are not meant to be subclassed.
@interface MMPagingScrollView (ProtectedMethods)

- (void)setCenterPageIndexIvar:(NSInteger)centerPageIndex;
- (void)recyclePageAtIndex:(NSInteger)pageIndex;
- (void)displayPageAtIndex:(NSInteger)pageIndex;
- (CGFloat)pageScrollableDimension;
- (void)layoutVisiblePages;

@end

/**
 * Called before the page is about to be shown and after its frame has been set.
 *
 * Meant to be subclassed. By default this method does nothing.
 *
 * @fn MMPagingScrollView::willDisplayPage:
 */

/**
 * Called immediately after the page is removed from the paging scroll view.
 *
 * Meant to be subclassed. By default this method does nothing.
 *
 * @fn MMPagingScrollView::didRecyclePage:
 */

/**
 * Called immediately after the data source has been queried for its number of
 * pages.
 *
 * Meant to be subclassed. By default this method does nothing.
 *
 * @fn MMPagingScrollView::didReloadNumberOfPages
 */

/**
 * Called when the visible page has changed.
 *
 * Meant to be subclassed. By default this method does nothing.
 *
 * @fn MMPagingScrollView::didChangeCenterPageIndexFrom:to:
 */

/**
 * Called when a page needs to be loaded before it is displayed.
 *
 * By default this method asks the data source for the page at the given index.
 * A subclass may chose to modify the page index using a transformation method
 * before calling super.
 *
 * @fn MMPagingScrollView::loadPageAtIndex:
 */

/**
 * Sets the centerPageIndex ivar without side effects.
 *
 * @fn MMPagingScrollView::setCenterPageIndexIvar:
 */

/**
 * Recycles the page at the given index.
 *
 * @fn MMPagingScrollView::recyclePageAtIndex:
 */

/**
 * Displays the page at the given index.
 *
 * @fn MMPagingScrollView::displayPageAtIndex:
 */

/**
 * Returns the page's scrollable dimension.
 *
 * This is the width of the paging scroll view for horizontal scroll views, or
 * the height of the paging scroll view for vertical scroll views.
 *
 * @fn MMPagingScrollView::pageScrollableDimension
 */

/**
 * Updates the frames of all visible pages based on their page indices.
 *
 * @fn MMPagingScrollView::layoutVisiblePages
 */
