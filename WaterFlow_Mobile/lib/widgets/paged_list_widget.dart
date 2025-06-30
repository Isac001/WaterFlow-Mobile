import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:waterflow_mobile/utils/constans_values/paddings_constants.dart';
import 'package:waterflow_mobile/utils/constans_values/theme_color_constants.dart';

// A reusable widget for lists that load data in pages.
class PagedListViewWidget extends StatelessWidget {
  // --- Settings for the widget ---
  
  // Controls the pages and list data. Required.
  final PagingController pagingController;
  
  // A function that draws each item in the list. Required.
  final Widget Function(BuildContext, dynamic, int) itemBuilder;

  // Optional settings to style the grid.
  final double? childAspectRatio;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final ScrollController? scrollController;
  
  // Optional text for when the list is empty.
  final String? noItemsFoundText;

  // Constructor
  const PagedListViewWidget({
    super.key,
    required this.pagingController,
    required this.itemBuilder,
    this.childAspectRatio,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.noItemsFoundText,
    this.scrollController,
  });

  // --- How the widget looks on screen ---
  @override
  Widget build(BuildContext context) {
    // Checks if the screen is in landscape (sideways).
    RxBool orientation =
        (MediaQuery.of(context).orientation == Orientation.landscape).obs;
        
    // Allows the user to pull down to refresh the list.
    return RefreshIndicator(
      // When pulled, it tells the controller to reload everything.
      onRefresh: () => Future.sync(() => pagingController.refresh()),
      // The main grid that shows the paged items.
      child: PagedGridView(
        scrollController: scrollController,
        // Defines the grid layout.
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          // Use a default value if none is provided.
          childAspectRatio: childAspectRatio ?? 3,
          crossAxisSpacing: crossAxisSpacing ?? 0.0,
          mainAxisSpacing: mainAxisSpacing ?? 0.0,
          // Shows 2 columns in landscape, 1 otherwise.
          crossAxisCount: orientation.value ? 2 : 1,
        ),
        // Connects the grid to the page controller.
        pagingController: pagingController,
        // Tells the grid what to show in different situations.
        builderDelegate: PagedChildBuilderDelegate(
          // This builds each list item using the function passed to the widget.
          itemBuilder: itemBuilder,
          
          // What to show when the list is empty.
          noItemsFoundIndicatorBuilder: (context) => SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingSmall),
                child: Text(
                  noItemsFoundText ?? 'Nenhum item encontrado!',
                  textAlign: TextAlign.center,
                  maxLines: 4,
                ),
              ),
            ),
          ),
          
          // What to show during the very first load (here, nothing).
          firstPageProgressIndicatorBuilder: (context) =>
              const SizedBox.shrink(),
              
          // What to show if the first load fails.
          firstPageErrorIndicatorBuilder: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Ocorreu um erro ao carregar os dados!',
                    maxLines: 4,
                  ),
                  // A button to let the user try loading again.
                  IconButton(
                    color: ThemeColor.primaryColor,
                    icon: const Icon(Icons.replay_outlined),
                    onPressed: () => pagingController.refresh(),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
}