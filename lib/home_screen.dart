import 'package:dash_playground/about_screen.dart';
import 'package:dash_playground/check_for_updates_screen.dart';
import 'package:dash_playground/get_started_screen.dart';
import 'package:dash_playground/review_installation_screen.dart';
import 'package:dash_playground/utils/size_config.dart';
import 'package:dash_playground/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  var activeNavigationRailIndex = 0;
  var isReviewScreen = false;
  var isInstallationScreen = false;
  var installationScreenController = PageController();

  void setActiveNavigationRailIndex(int i) {
    activeNavigationRailIndex = i;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeConfig().init(context);
    return Scaffold(
        backgroundColor: ThemeConfig.background,
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            isReviewScreen && activeNavigationRailIndex == 0
                ? Padding(
                    padding: EdgeInsets.only(right: getProportionateWidth(24)),
                    child: SizedBox(
                      width: getProportionateWidth(180),
                      child: MaterialButton(
                        onPressed: () {
                          // previous screen
                          setState(() {
                            isReviewScreen = !isReviewScreen;
                            installationScreenController.animateToPage(0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut);
                          });
                        },
                        elevation: 0,
                        splashColor: const Color(0x2001579b),
                        hoverColor: const Color(0x2001579b),
                        highlightColor: const Color(0x2001579b),
                        focusColor: const Color(0x2001579b),
                        height: getProportionateHeight(64),
                        color: const Color(0xFF99bcd7),
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                getProportionateHeight(20))),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: getProportionateWidth(16)),
                          child: Row(
                            children: [
                              const Icon(Icons.chevron_left_rounded),
                              const Spacer(),
                              Text(
                                "Modify",
                                style: TextStyle(
                                  fontFamily: 'Product Sans',
                                  fontWeight: FontWeight.w500,
                                  fontSize: getProportionateHeight(18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            !isInstallationScreen
                ? SizedBox(
                    width: getProportionateWidth(280),
                    child: MaterialButton(
                      onPressed: () {
                        // next screen
                        switch (activeNavigationRailIndex) {
                          case 0:
                            setState(() {
                              if (!isReviewScreen) {
                                installationScreenController.animateToPage(1,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                                isReviewScreen = !isReviewScreen;
                              } else {
                                installationScreenController.animateToPage(2,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                                isReviewScreen = !isReviewScreen;
                                isInstallationScreen = !isInstallationScreen;
                              }
                            });
                            break;
                          default:
                        }
                      },
                      height: getProportionateHeight(64),
                      color: const Color(0xFF01579b),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              getProportionateHeight(20))),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateWidth(16)),
                        child: Row(
                          children: [
                            Text(
                              activeNavigationRailIndex == 0
                                  ? (isReviewScreen ? "Install" : "Review")
                                  : activeNavigationRailIndex == 1
                                      ? "Next"
                                      : activeNavigationRailIndex == 2
                                          ? "Configure"
                                          : activeNavigationRailIndex == 3
                                              ? "Check Again"
                                              : activeNavigationRailIndex == 4
                                                  ? "Uninstall"
                                                  : "Share",
                              style: TextStyle(
                                fontFamily: 'Product Sans',
                                fontWeight: FontWeight.w500,
                                fontSize: getProportionateHeight(18),
                              ),
                            ),
                            const Spacer(),
                            Icon(activeNavigationRailIndex == 0
                                ? Icons.chevron_right_rounded
                                : activeNavigationRailIndex == 1
                                    ? Icons.chevron_right_rounded
                                    : activeNavigationRailIndex == 2
                                        ? Icons.settings_rounded
                                        : activeNavigationRailIndex == 3
                                            ? Icons.refresh_rounded
                                            : activeNavigationRailIndex == 4
                                                ? Icons.delete_forever_rounded
                                                : Icons.share_rounded),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        ),
        body: Row(
          children: [
            Container(
              width: getProportionateWidth(360),
              color: const Color(0x2054c5f8),
              padding: EdgeInsets.symmetric(
                  vertical: getProportionateHeight(28),
                  horizontal: getProportionateWidth(24)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getProportionateHeight(14),
                  ),
                  activeNavigationRailIndex != 5
                      ? Text(
                          "Dash's",
                          style: TextStyle(
                            fontFamily: 'Childish Reverie',
                            fontSize: getProportionateHeight(24),
                            color: ThemeConfig.primary,
                          ),
                        )
                      : const SizedBox(),
                  activeNavigationRailIndex != 5
                      ? Text(
                          "Playground",
                          style: TextStyle(
                            fontFamily: 'Childish Reverie',
                            fontSize: getProportionateHeight(48),
                            color: ThemeConfig.primary,
                          ),
                        )
                      : const SizedBox(),
                  const Spacer(
                    flex: 2,
                  ),
                  MaterialButton(
                    onPressed: () {
                      setActiveNavigationRailIndex(0);
                    },
                    height: getProportionateHeight(64),
                    color: const Color(0xFF01579b),
                    minWidth: double.infinity,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(getProportionateHeight(20))),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateWidth(16)),
                      child: Row(
                        children: [
                          Text(
                            "Get Started",
                            style: TextStyle(
                              fontFamily: 'Product Sans',
                              fontWeight: FontWeight.w500,
                              fontSize: getProportionateHeight(18),
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  NavigationRailItem(
                    label: "Create",
                    icon: Icons.add_circle_outline_rounded,
                    onTap: () {
                      setActiveNavigationRailIndex(1);
                    },
                    isSelected: activeNavigationRailIndex == 1,
                  ),
                  NavigationRailItem(
                    label: "Customize",
                    icon: Icons.edit_note_rounded,
                    iconUrl: 'assets/images/edit.svg',
                    onTap: () {
                      setActiveNavigationRailIndex(2);
                    },
                    isSelected: activeNavigationRailIndex == 2,
                  ),
                  NavigationRailItem(
                    label: "Check For Updates",
                    icon: Icons.system_update_alt_rounded,
                    onTap: () {
                      setActiveNavigationRailIndex(3);
                    },
                    isSelected: activeNavigationRailIndex == 3,
                  ),
                  NavigationRailItem(
                    label: "Uninstall",
                    icon: Icons.delete_outline_rounded,
                    onTap: () {
                      setActiveNavigationRailIndex(4);
                    },
                    isSelected: activeNavigationRailIndex == 4,
                  ),
                  const Spacer(
                    flex: 6,
                  ),
                  NavigationRailItem(
                    label: "About",
                    icon: Icons.info_outline_rounded,
                    onTap: () {
                      setActiveNavigationRailIndex(5);
                    },
                    isSelected: activeNavigationRailIndex == 5,
                  ),
                ],
              ),
            ),
            Expanded(
                child: activeNavigationRailIndex == 0
                    ? PageView.builder(
                        controller: installationScreenController,
                        itemBuilder: (context, index) {
                          return index == 0
                              ? const GetStartedScreen()
                              : index == 1
                                  ? const ReviewInstallationScreen()
                                  : Container();
                        },
                        physics: const NeverScrollableScrollPhysics(),
                      )
                    : activeNavigationRailIndex == 1
                        ? Container()
                        : activeNavigationRailIndex == 2
                            ? Container()
                            : activeNavigationRailIndex == 3
                                ? const CheckForUpdatesScreen()
                                : activeNavigationRailIndex == 4
                                    ? Container()
                                    : const AboutScreen()),
          ],
        ));
  }
}

class NavigationRailItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function() onTap;
  final bool isSelected;
  final String? iconUrl;

  const NavigationRailItem(
      {Key? key,
      required this.label,
      required this.icon,
      required this.onTap,
      required this.isSelected,
      this.iconUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(getProportionateHeight(16)),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: getProportionateHeight(16)),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateWidth(isSelected ? 16 : 32)),
              child: isSelected
                  ? Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateWidth(16),
                          vertical: getProportionateHeight(4)),
                      decoration: BoxDecoration(
                          color: const Color(0x5001579b),
                          borderRadius: BorderRadius.circular(
                              getProportionateHeight(32))),
                      child: iconUrl == null
                          ? Icon(
                              icon,
                              size: getProportionateHeight(20),
                              color: ThemeConfig.primary,
                            )
                          : SvgPicture.asset(
                              iconUrl!,
                              height: getProportionateHeight(20),
                              color: ThemeConfig.primary,
                            ),
                    )
                  : iconUrl == null
                      ? Icon(
                          icon,
                          size: getProportionateHeight(20),
                          color: ThemeConfig.primary,
                        )
                      : SvgPicture.asset(
                          iconUrl!,
                          height: getProportionateHeight(20),
                          color: ThemeConfig.primary,
                        ),
            ),
            SizedBox(
              child: Text(
                label,
                style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontWeight: FontWeight.w500,
                  fontSize: getProportionateHeight(20),
                  color: ThemeConfig.onBackground,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
