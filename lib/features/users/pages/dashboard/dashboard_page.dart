import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jaga_saku/core/core.dart';
import 'package:jaga_saku/features/users/users.dart';

/// Users list — the Dashboard tab. Search field in the app bar, pull-to-refresh
/// and infinite scroll (loads more near the bottom). Tapping a tile opens the
/// user detail.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<UsersCubit>().loadMore();
    }
  }

  Future<void> _openDetail(String id) async {
    await context.pushNamed(
      Routes.userDetail.name,
      pathParameters: UserRouteArgs(id: id).toPathParameters(),
    );
    if (!mounted) return;
    // Returning from detail (which may have edited/deleted) — refresh the list.
    await context.read<UsersCubit>().refresh();
  }

  @override
  Widget build(BuildContext context) {
    final s = Strings.of(context)!;
    return Parent(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: s.searchUsers,
            prefixIcon: const Icon(Icons.search),
            border: InputBorder.none,
          ),
          onSubmitted: (value) => context.read<UsersCubit>().search(value),
        ),
      ),
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<UsersCubit>().refresh(),
          child: BlocBuilder<UsersCubit, UsersState>(
            builder: (context, state) => switch (state) {
              UsersStateInitial() ||
              UsersStateLoading() => const ListSkeleton(),
              UsersStateEmpty() => _ScrollableMessage(
                child: Empty(errorMessage: s.noUsers),
              ),
              UsersStateFailure(:final failure) => _ScrollableMessage(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Empty(errorMessage: failure.localize(context)),
                    SizedBox(height: Dimens.space16),
                    Button(
                      title: s.retry,
                      onPressed: () =>
                          context.read<UsersCubit>().fetchFirstPage(),
                    ),
                  ],
                ),
              ),
              UsersStateLoaded(:final items, :final isLoadingMore) =>
                ListView.builder(
                  controller: _scrollController,
                  // Always overscrollable so pull-to-refresh works even when
                  // the list is shorter than the viewport.
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: items.length + (isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= items.length) {
                      return Padding(
                        padding: EdgeInsets.all(Dimens.space16),
                        child: const Center(child: Loading(showMessage: false)),
                      );
                    }
                    final user = items[index];
                    return ListTile(
                      leading: SizedBox(
                        width: Dimens.space46,
                        height: Dimens.space46,
                        child:
                            (user.avatarUrl != null &&
                                user.avatarUrl!.isNotEmpty)
                            ? CircleImage(
                                url: user.avatarUrl!,
                                size: Dimens.space46,
                              )
                            : const CircleAvatar(child: Icon(Icons.person)),
                      ),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                      onTap: () => _openDetail(user.id),
                    );
                  },
                ),
            },
          ),
        ),
      ),
    );
  }
}

/// Wraps a centered message in a scrollable so [RefreshIndicator] still works
/// when the list is empty / errored.
class _ScrollableMessage extends StatelessWidget {
  const _ScrollableMessage({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Center(child: child),
      ),
    ),
  );
}
