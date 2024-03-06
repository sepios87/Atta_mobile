part of '../home_base.dart';

class _AttaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AttaAppBar({required this.user});

  final AttaUser? user;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: InkWell(
        borderRadius: BorderRadius.circular(AttaRadius.full),
        onTap: () {
          if (user == null) {
            context.adapativePushNamed(AuthPage.routeName);
          } else {
            context.adapativePushNamed(ProfilePage.routeName);
          }
        },
        child: user == null
            ? Text(
                translate('app_bar.connect'),
                style: AttaTextStyle.subHeader.copyWith(color: AttaColors.white),
              ).withPadding(
                const EdgeInsets.symmetric(
                  vertical: AttaSpacing.s,
                  horizontal: AttaSpacing.m,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserAvatar(user: user!),
                  if (user?.firstName != null || user?.lastName != null) const SizedBox(width: AttaSpacing.s),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user!.lastName != null)
                        Text(
                          user!.lastName!.toUpperCase(),
                          style: AttaTextStyle.caption.copyWith(
                            color: AttaColors.white,
                          ),
                        ),
                      if (user!.firstName != null)
                        Text(
                          user!.firstName!.capitalize(),
                          style: AttaTextStyle.caption.copyWith(
                            color: AttaColors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  if (user?.firstName != null || user?.lastName != null) const SizedBox(width: AttaSpacing.m),
                ],
              ),
      ),
      actions: [
        IconButton(
          onPressed: () => context.adapativePushNamed(CartPage.routeName),
          icon: const Icon(CupertinoIcons.cart),
        ),
        const SizedBox(width: AttaSpacing.xs),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
