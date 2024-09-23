// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import 'package:hovering/hovering.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  DocumentReference? userRef;
  String fullname = 'Emall Admin';
  bool profileExpansionTile = false;
  bool userExpansionTile = false;
  bool payoutExpansionTile = false;
  bool courierExpansionTile = false;
  bool categoryExpansionTile = false;
  String routeName = 'home';
  String expansionTileName = '';

  String profilePic =
      'https://eitrawmaterials.eu/wp-content/uploads/2016/09/person-icon.png'
          .tr();

  @override
  void initState() {
    getFirebaseDetails();
    super.initState();
  }

  getSelectedRoute() {
    SharedPreferences.getInstance().then((prefs) {
      var route = prefs.getString('route-name');
      setState(() {
        routeName = route!;
      });
    });
  }

  String adminImage = '';
  String oldPassword = '';
  String adminUsername = '';
  getFirebaseDetails() {
    FirebaseFirestore.instance
        .collection('Admin')
        .doc('Admin')
        .get()
        .then((value) {
      setState(() {
        adminImage = value['ProfilePic'];
        oldPassword = value['password'];
        adminUsername = value['username'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //  getSelectedRoute();
    // String platform = Platform.operatingSystem;
    return Drawer(
      elevation: 1,
      child: Container(
        color: Theme.of(context).cardColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // if (platform == 'android' || platform == 'ios')
              //   const SizedBox(
              //     height: 50,
              //   ),
              HoverAnimatedContainer(
                hoverColor: Colors.grey,
                child: Container(
                  color: routeName == '' ? Colors.grey : null,
                  child: ListTile(
                    onTap: () async {
                      if (MediaQuery.of(context).size.width >= 1100) {
                        context.go(
                          '/',
                        );
                      } else {
                        context.go(
                          '/',
                        );
                        Navigator.pop(context);
                      }

                      // var prefs = await SharedPreferences.getInstance();
                      //prefs.setString('route-name', '/');
                    },
                    title: Text(
                      'Dashboard',
                      style: TextStyle(
                        color: Theme.of(context).iconTheme.color,
                        fontSize: 12,
                      ),
                    ).tr(),
                    leading: Icon(Icons.dashboard,
                        color: Theme.of(context).iconTheme.color),
                  ),
                ),
              ),
              HoverAnimatedContainer(
                hoverColor: Colors.grey,
                child: Container(
                  color: routeName == 'profile' ? Colors.grey : null,
                  child: ListTile(
                      onTap: () async {
                        if (MediaQuery.of(context).size.width >= 1100) {
                          context.go(
                            '/profile',
                          );
                        } else {
                          context.go(
                            '/profile',
                          );
                          Navigator.pop(context);
                        }

                        setState(() {
                          profileExpansionTile = true;
                        });
                        // var prefs = await SharedPreferences.getInstance();
                        //prefs.setString('route-name', 'profile');
                      },
                      title: Text(
                        'Profile',
                        style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontSize: 12,
                        ),
                      ).tr(),
                      leading: Icon(
                        Icons.people,
                        color: Theme.of(context).iconTheme.color,
                      )),
                ),
              ),
              HoverAnimatedContainer(
                hoverColor: Colors.grey,
                child: Container(
                  color: routeName == 'app-settings' ? Colors.grey : null,
                  child: ListTile(
                      onTap: () async {
                        if (MediaQuery.of(context).size.width >= 1100) {
                          context.go(
                            '/settings',
                          );
                        } else {
                          context.go(
                            '/settings',
                          );
                          Navigator.pop(context);
                        }

                        setState(() {
                          profileExpansionTile = true;
                        });
                        // var prefs = await SharedPreferences.getInstance();
                        //prefs.setString('route-name', 'app-settings');
                      },
                      title: Text(
                        'App Settings',
                        style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontSize: 12,
                        ),
                      ).tr(),
                      leading: Icon(Icons.settings,
                          color: Theme.of(context).iconTheme.color)),
                ),
              ),
              HoverAnimatedContainer(
                hoverColor: Colors.grey,
                child: Container(
                  color: routeName == 'push-notifications' ? Colors.grey : null,
                  child: ListTile(
                      onTap: () async {
                        if (MediaQuery.of(context).size.width >= 1100) {
                          context.go(
                            '/push-notifications',
                          );
                        } else {
                          context.go(
                            '/push-notifications',
                          );
                          Navigator.pop(context);
                        }

                        setState(() {
                          profileExpansionTile = true;
                        });
                        // var prefs = await SharedPreferences.getInstance();
                        //prefs.setString('route-name', 'app-settings');
                      },
                      title: Text(
                        'Bulk Push Notifications',
                        style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontSize: 12,
                        ),
                      ).tr(),
                      leading: Icon(Icons.notification_important,
                          color: Theme.of(context).iconTheme.color)),
                ),
              ),
              HoverAnimatedContainer(
                hoverColor: Colors.grey,
                child: Container(
                  color: routeName == 'pickup-address' ? Colors.grey : null,
                  child: ListTile(
                      onTap: () async {
                        if (MediaQuery.of(context).size.width >= 1100) {
                          context.go(
                            '/pickup-address',
                          );
                        } else {
                          context.go(
                            '/pickup-address',
                          );
                          Navigator.pop(context);
                        }

                        setState(() {
                          profileExpansionTile = true;
                        });
                        // var prefs = await SharedPreferences.getInstance();
                        //prefs.setString('route-name', 'app-settings');
                      },
                      title: Text(
                        'Pickup Settings',
                        style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontSize: 12,
                        ),
                      ).tr(),
                      leading: Icon(Icons.delivery_dining,
                          color: Theme.of(context).iconTheme.color)),
                ),
              ),
              HoverAnimatedContainer(
                hoverColor: Colors.grey,
                child: Container(
                  color: routeName == 'coupon' ? Colors.grey : null,
                  child: ListTile(
                      onTap: () async {
                        if (MediaQuery.of(context).size.width >= 1100) {
                          context.go(
                            '/coupon',
                          );
                        } else {
                          context.go(
                            '/coupon',
                          );
                          Navigator.pop(context);
                        }

                        setState(() {
                          profileExpansionTile = true;
                        });
                        // var prefs = await SharedPreferences.getInstance();
                        //prefs.setString('route-name', 'app-settings');
                      },
                      title: Text(
                        'Cupon Settings',
                        style: TextStyle(
                          color: Theme.of(context).iconTheme.color,
                          fontSize: 12,
                        ),
                      ).tr(),
                      leading: Icon(Icons.card_giftcard,
                          color: Theme.of(context).iconTheme.color)),
                ),
              ),
              // HoverAnimatedContainer(
              //   hoverColor: Colors.grey,
              //   child: Container(
              //     color: routeName == '/bulk-emails' ? Colors.grey : null,
              //     child: ListTile(
              //         onTap: () async {
              //           context.go(
              //             '/bulk-emails',
              //           );
              //           setState(() {
              //             categoryExpansionTile = true;
              //           });
              //         },
              //         title: Text(
              //           'Bulk Emails',
              //           style: TextStyle(
              //             color: Theme.of(context).iconTheme.color,
              //             fontSize: 12,
              //           ),
              //         ).tr(),
              //         leading: Icon(Icons.category,
              //             color: Theme.of(context).iconTheme.color)),
              //   ),
              // ),
              ExpansionTile(
                // collapsedIconColor: Colors.white,
                // iconColor: Colors.white,
                // textColor: Colors.white,
                onExpansionChanged: (value) {
                  setState(() {
                    profileExpansionTile = !profileExpansionTile;
                  });
                },
                title: Text(
                  'Reports',
                  style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontSize: 12,
                  ),
                ).tr(),
                leading:
                    Icon(Icons.list, color: Theme.of(context).iconTheme.color),
                children: <Widget>[
                  HoverAnimatedContainer(
                    hoverColor: Colors.grey,
                    child: Container(
                      color: routeName == 'users-report' ? Colors.grey : null,
                      child: ListTile(
                          onTap: () async {
                            context.go(
                              '/users-report',
                            );
                            setState(() {
                              profileExpansionTile = true;
                            });
                          },
                          title: Text(
                            'Users Report',
                            style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: 12,
                            ),
                          ).tr(),
                          leading: Icon(Icons.list,
                              color: Theme.of(context).iconTheme.color)),
                    ),
                  ),
                  HoverAnimatedContainer(
                    hoverColor: Colors.grey,
                    child: Container(
                      color: routeName == 'orders-report' ? Colors.grey : null,
                      child: ListTile(
                          onTap: () async {
                            context.go(
                              '/orders-report',
                            );
                            setState(() {
                              profileExpansionTile = true;
                            });
                          },
                          title: Text(
                            'Orders Report',
                            style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: 12,
                            ),
                          ).tr(),
                          leading: Icon(Icons.list,
                              color: Theme.of(context).iconTheme.color)),
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                leading: Icon(Icons.category,
                    color: Theme.of(context).iconTheme.color),
                title: Text('Categories Management',
                    style: TextStyle(
                      color: Theme.of(context).iconTheme.color,
                      fontSize: 12,
                    )).tr(),
                children: [
                  HoverAnimatedContainer(
                    hoverColor: Colors.grey,
                    child: Container(
                      color: routeName == 'categories' ? Colors.grey : null,
                      child: ListTile(
                          onTap: () async {
                            if (MediaQuery.of(context).size.width >= 1100) {
                              context.go(
                                '/categories',
                              );
                            } else {
                              context.go(
                                '/categories',
                              );
                              Navigator.pop(context);
                            }

                            setState(() {
                              categoryExpansionTile = true;
                            });
                            // var prefs = await SharedPreferences.getInstance();
                            //prefs.setString('route-name', 'categories');
                          },
                          title: Text(
                            'Categories',
                            style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: 12,
                            ),
                          ).tr(),
                          leading: Icon(Icons.category,
                              color: Theme.of(context).iconTheme.color)),
                    ),
                  ),
                  HoverAnimatedContainer(
                    hoverColor: Colors.grey,
                    child: Container(
                      color: routeName == 'collections' ? Colors.grey : null,
                      child: ListTile(
                          onTap: () async {
                            if (MediaQuery.of(context).size.width >= 1100) {
                              context.go(
                                '/collections',
                              );
                            } else {
                              context.go(
                                '/collections',
                              );
                              Navigator.pop(context);
                            }

                            setState(() {
                              categoryExpansionTile = true;
                            });
                            // var prefs = await SharedPreferences.getInstance();
                            //prefs.setString('route-name', 'collections');
                          },
                          title: Text(
                            'Collections',
                            style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: 12,
                            ),
                          ).tr(),
                          leading: Icon(Icons.library_books,
                              color: Theme.of(context).iconTheme.color)),
                    ),
                  ),
                  HoverAnimatedContainer(
                    hoverColor: Colors.grey,
                    child: Container(
                      color:
                          routeName == 'sub-collections' ? Colors.grey : null,
                      child: ListTile(
                          onTap: () async {
                            if (MediaQuery.of(context).size.width >= 1100) {
                              context.go(
                                '/sub-collections',
                              );
                            } else {
                              context.go(
                                '/sub-collections',
                              );
                              Navigator.pop(context);
                            }

                            setState(() {
                              categoryExpansionTile = true;
                            });
                            // var prefs = await SharedPreferences.getInstance();
                            //prefs.setString('route-name', 'sub-collections');
                          },
                          title: Text(
                            'Sub Collections',
                            style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: 12,
                            ),
                          ).tr(),
                          leading: Icon(Icons.list,
                              color: Theme.of(context).iconTheme.color)),
                    ),
                  ),
                  HoverAnimatedContainer(
                    hoverColor: Colors.grey,
                    child: Container(
                      color: routeName == 'brands' ? Colors.grey : null,
                      child: ListTile(
                          onTap: () async {
                            if (MediaQuery.of(context).size.width >= 1100) {
                              context.go(
                                '/brands',
                              );
                            } else {
                              context.go(
                                '/brands',
                              );
                              Navigator.pop(context);
                            }

                            setState(() {
                              categoryExpansionTile = true;
                            });
                            // var prefs = await SharedPreferences.getInstance();
                            //prefs.setString('route-name', 'brands');
                          },
                          title: Text(
                            'Brands',
                            style: TextStyle(
                              color: Theme.of(context).iconTheme.color,
                              fontSize: 12,
                            ),
                          ).tr(),
                          leading: Icon(Icons.abc,
                              color: Theme.of(context).iconTheme.color)),
                    ),
                  ),
                ],
              ),
              HoverAnimatedContainer(
                hoverColor: Colors.grey,
                child: Container(
                  color: routeName == 'orders' ? Colors.grey : null,
                  child: ListTile(
                    onTap: () async {
                      if (MediaQuery.of(context).size.width >= 1100) {
                        context.go(
                          '/orders',
                        );
                      } else {
                        context.go(
                          '/orders',
                        );
                        Navigator.pop(context);
                      }
                      // var prefs = await SharedPreferences.getInstance();
                      //prefs.setString('route-name', 'orders');
                    },
                    title: Text(
                      'Orders',
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).iconTheme.color),
                    ).tr(),
                    leading: Icon(Icons.list,
                        color: Theme.of(context).iconTheme.color),
                  ),
                ),
              ),
              ExpansionTile(
                leading: Icon(Icons.local_mall,
                    color: Theme.of(context).iconTheme.color),
                title: Text('Products Management',
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).iconTheme.color))
                    .tr(),
                children: [
                  HoverAnimatedContainer(
                    hoverColor: Colors.grey,
                    child: Container(
                      color: routeName == 'products' ? Colors.grey : null,
                      child: ListTile(
                          onTap: () async {
                            if (MediaQuery.of(context).size.width >= 1100) {
                              context.go(
                                '/products',
                              );
                            } else {
                              context.go(
                                '/products',
                              );
                              Navigator.pop(context);
                            }
                            // var prefs = await SharedPreferences.getInstance();
                            //prefs.setString('route-name', 'products');
                          },
                          title: Text(
                            'Products',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).iconTheme.color),
                          ).tr(),
                          leading: Icon(Icons.local_mall,
                              color: Theme.of(context).iconTheme.color)),
                    ),
                  ),
                  HoverAnimatedContainer(
                    hoverColor: Colors.grey,
                    child: Container(
                      color: routeName == 'flash-sales' ? Colors.grey : null,
                      child: ListTile(
                          onTap: () async {
                            if (MediaQuery.of(context).size.width >= 1100) {
                              context.go(
                                '/flash-sales',
                              );
                            } else {
                              context.go(
                                '/flash-sales',
                              );
                              Navigator.pop(context);
                            }
                            // var prefs = await SharedPreferences.getInstance();
                            //prefs.setString('route-name', 'products');
                          },
                          title: Text(
                            'Flash Sales',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).iconTheme.color),
                          ).tr(),
                          leading: Icon(Icons.timer,
                              color: Theme.of(context).iconTheme.color)),
                    ),
                  ),
                  HoverAnimatedContainer(
                    hoverColor: Colors.grey,
                    child: Container(
                      color: routeName == 'hot-deals' ? Colors.grey : null,
                      child: ListTile(
                          onTap: () async {
                            if (MediaQuery.of(context).size.width >= 1100) {
                              context.go(
                                '/hot-deals',
                              );
                            } else {
                              context.go(
                                '/hot-deals',
                              );
                              Navigator.pop(context);
                            }
                            // var prefs = await SharedPreferences.getInstance();
                            //prefs.setString('route-name', 'products');
                          },
                          title: Text(
                            'Hot Deals',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).iconTheme.color),
                          ).tr(),
                          leading: Icon(Icons.local_mall,
                              color: Theme.of(context).iconTheme.color)),
                    ),
                  ),
                  HoverAnimatedContainer(
                    hoverColor: Colors.grey,
                    child: Container(
                      color:
                          routeName == 'returned-products' ? Colors.grey : null,
                      child: ListTile(
                          onTap: () async {
                            if (MediaQuery.of(context).size.width >= 1100) {
                              context.go(
                                '/returned-products',
                              );
                            } else {
                              context.go(
                                '/returned-products',
                              );
                              Navigator.pop(context);
                            }
                            // var prefs = await SharedPreferences.getInstance();
                            //prefs.setString('route-name', 'products');
                          },
                          title: Text(
                            'Returned Products',
                            style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).iconTheme.color),
                          ).tr(),
                          leading: Icon(Icons.production_quantity_limits,
                              color: Theme.of(context).iconTheme.color)),
                    ),
                  ),
                ],
              ),
              HoverAnimatedContainer(
                hoverColor: Colors.grey,
                child: Container(
                  color: routeName == 'users' ? Colors.grey : null,
                  child: ListTile(
                      onTap: () async {
                        if (MediaQuery.of(context).size.width >= 1100) {
                          context.go(
                            '/users',
                          );
                        } else {
                          context.go(
                            '/users',
                          );
                          Navigator.pop(context);
                        }
                        setState(() {
                          userExpansionTile = true;
                        });
                        // var prefs = await SharedPreferences.getInstance();
                        //prefs.setString('route-name', 'users');
                      },
                      title: Text(
                        'Users',
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).iconTheme.color),
                      ).tr(),
                      leading: Icon(Icons.person,
                          color: Theme.of(context).iconTheme.color)),
                ),
              ),
              HoverAnimatedContainer(
                hoverColor: Colors.grey,
                child: Container(
                  color: routeName == 'riders' ? Colors.grey : null,
                  child: ListTile(
                      onTap: () async {
                        if (MediaQuery.of(context).size.width >= 1100) {
                          context.go(
                            '/riders',
                          );
                        } else {
                          context.go(
                            '/riders',
                          );
                          Navigator.pop(context);
                        }
                        setState(() {
                          userExpansionTile = true;
                        });
                        // var prefs = await SharedPreferences.getInstance();
                        //prefs.setString('route-name', 'users');
                      },
                      title: Text(
                        'Riders',
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).iconTheme.color),
                      ).tr(),
                      leading: Icon(Icons.person,
                          color: Theme.of(context).iconTheme.color)),
                ),
              ),
              ExpansionTile(
                leading:
                    Icon(Icons.feed, color: Theme.of(context).iconTheme.color),
                title: Text(
                  'Feeds',
                  style: TextStyle(
                      fontSize: 12, color: Theme.of(context).iconTheme.color),
                ).tr(),
                children: [
                  HoverAnimatedContainer(
                    hoverColor: Colors.grey,
                    child: Container(
                      color: routeName == 'feeds' ? Colors.grey : null,
                      child: ListTile(
                        onTap: () async {
                          if (MediaQuery.of(context).size.width >= 1100) {
                            context.go(
                              '/feeds',
                            );
                          } else {
                            context.go(
                              '/feeds',
                            );
                            Navigator.pop(context);
                          }
                          // var prefs = await SharedPreferences.getInstance();
                          //prefs.setString('route-name', 'feeds');
                        },
                        title: Text(
                          'Feeds',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).iconTheme.color),
                        ).tr(),
                        leading: Icon(Icons.feed,
                            color: Theme.of(context).iconTheme.color),
                      ),
                    ),
                  ),
                  HoverAnimatedContainer(
                    hoverColor: Colors.grey,
                    child: Container(
                      color: routeName == 'banners' ? Colors.grey : null,
                      child: ListTile(
                        onTap: () async {
                          if (MediaQuery.of(context).size.width >= 1100) {
                            context.go(
                              '/banners',
                            );
                          } else {
                            context.go(
                              '/banners',
                            );
                            Navigator.pop(context);
                          }
                          // var prefs = await SharedPreferences.getInstance();
                          //prefs.setString('route-name', 'feeds');
                        },
                        title: Text(
                          'Banners',
                          style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).iconTheme.color),
                        ).tr(),
                        leading: Icon(Icons.feed,
                            color: Theme.of(context).iconTheme.color),
                      ),
                    ),
                  ),
                ],
              ),
              HoverAnimatedContainer(
                hoverColor: Colors.grey,
                child: Container(
                  color: routeName == 'notifications' ? Colors.grey : null,
                  child: ListTile(
                    onTap: () async {
                      if (MediaQuery.of(context).size.width >= 1100) {
                        context.go(
                          '/notifications',
                        );
                      } else {
                        context.go(
                          '/notifications',
                        );
                        Navigator.pop(context);
                      }
                      setState(() {
                        userExpansionTile = true;
                      });
                      // var prefs = await SharedPreferences.getInstance();
                      //prefs.setString('route-name', 'notifications');
                    },
                    title: Text(
                      'Notifications',
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).iconTheme.color),
                    ).tr(),
                    leading: Icon(Icons.notifications,
                        color: Theme.of(context).iconTheme.color),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
