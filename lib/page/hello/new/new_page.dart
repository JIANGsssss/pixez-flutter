import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixez/bloc/bloc.dart';
import 'package:pixez/generated/i18n.dart';
import 'package:pixez/network/api_client.dart';
import 'package:pixez/page/hello/new/bloc/bloc.dart';
import 'package:pixez/page/hello/new/illust/bloc/bloc.dart';
import 'package:pixez/page/hello/new/illust/new_illust_page.dart';
import 'package:pixez/page/hello/new/painter/bloc/bloc.dart';
import 'package:pixez/page/hello/new/painter/new_painter_page.dart';
import 'package:pixez/page/preview/preview_page.dart';
import 'package:pixez/page/user/bookmark/bloc.dart';
import 'package:pixez/page/user/bookmark/bookmark_page.dart';
import 'package:pixez/page/user/user_page.dart';

class NewPage extends StatefulWidget {
  final String newRestrict, bookRestrict, painterRestrict;

  const NewPage(
      {Key key,
      this.newRestrict = "public",
      this.bookRestrict = "public",
      this.painterRestrict = "public"})
      : super(key: key);

  @override
  _NewPageState createState() => _NewPageState();
}

enum WhyFarther { public, private }

class _NewPageState extends State<NewPage> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        TabController(initialIndex: _selectIndex, vsync: this, length: 3);
    _controller.addListener(() {
      setState(() {
        _selectIndex = this._controller.index;
        print(_controller.index);
      });
    });
  }

  List<Widget> _buildActions(
      BuildContext context, NewDataRestrictState snapshot) {
    switch (_selectIndex) {
      case 1:
        {
          return <Widget>[
            PopupMenuButton<WhyFarther>(
              initialValue: snapshot.bookRestrict == "public"
                  ? WhyFarther.public
                  : WhyFarther.private,
              onSelected: (WhyFarther result) {
                if (result == WhyFarther.public) {
                  BlocProvider.of<NewBloc>(context).add(RestrictEvent(
                      widget.newRestrict, "public", widget.painterRestrict));
                } else {
                  BlocProvider.of<NewBloc>(context).add(RestrictEvent(
                      widget.newRestrict, "private", widget.painterRestrict));
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<WhyFarther>>[
                PopupMenuItem<WhyFarther>(
                  value: WhyFarther.public,
                  child: Text(I18n.of(context).Public),
                ),
                PopupMenuItem<WhyFarther>(
                  value: WhyFarther.private,
                  child: Text(I18n.of(context).Private),
                ),
              ],
            )
          ];
        }
        break;
      case 2:
        {
          return <Widget>[
            PopupMenuButton<WhyFarther>(
              initialValue: snapshot.painterRestrict == "public"
                  ? WhyFarther.public
                  : WhyFarther.private,
              onSelected: (WhyFarther result) {
                if (result == WhyFarther.public) {
                  BlocProvider.of<NewBloc>(context).add(RestrictEvent(
                      widget.newRestrict, widget.bookRestrict, "public"));
                } else {
                  BlocProvider.of<NewBloc>(context).add(RestrictEvent(
                      widget.newRestrict, widget.bookRestrict, "private"));
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<WhyFarther>>[
                PopupMenuItem<WhyFarther>(
                  value: WhyFarther.public,
                  child: Text(I18n.of(context).Public),
                ),
                PopupMenuItem<WhyFarther>(
                  value: WhyFarther.private,
                  child: Text(I18n.of(context).Private),
                ),
              ],
            )
          ];
        }
        break;
      default:
        {
          return <Widget>[
            PopupMenuButton<WhyFarther>(
              initialValue: snapshot.newRestrict == "public"
                  ? WhyFarther.public
                  : WhyFarther.private,
              onSelected: (WhyFarther result) {
                if (result == WhyFarther.public) {
                  BlocProvider.of<NewBloc>(context).add(RestrictEvent(
                      "public", widget.bookRestrict, widget.painterRestrict));
                } else {
                  BlocProvider.of<NewBloc>(context).add(RestrictEvent(
                      "private", widget.bookRestrict, widget.painterRestrict));
                }
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<WhyFarther>>[
                PopupMenuItem<WhyFarther>(
                  value: WhyFarther.public,
                  child: Text(I18n.of(context).Public),
                ),
                PopupMenuItem<WhyFarther>(
                  value: WhyFarther.private,
                  child: Text(I18n.of(context).Private),
                ),
              ],
            )
          ];
        }
        break;
    }
  }

  int _selectIndex = 0;
  NewDataRestrictState _preNewDataRestrictState;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(builder: (context, snapshot) {
      if (snapshot is HasUserState)
        return MultiBlocProvider(
            providers: [
              BlocProvider<NewBloc>(
                create: (context) => NewBloc()
                  ..add(NewInitalEvent(widget.newRestrict, widget.bookRestrict,
                      widget.painterRestrict)),
              ),
              BlocProvider<NewIllustBloc>(
                create: (context) =>
                    NewIllustBloc(RepositoryProvider.of<ApiClient>(context)),
              ),
              BlocProvider<NewPainterBloc>(
                create: (context) =>
                    NewPainterBloc(RepositoryProvider.of<ApiClient>(context)),
              ),
              BlocProvider<BookmarkBloc>(
                create: (context) =>
                    BookmarkBloc(RepositoryProvider.of<ApiClient>(context)),
              )
            ],
            child: BlocBuilder<NewBloc, NewState>(builder: (context, snapshot) {
              if (snapshot is NewDataRestrictState) {
                return Scaffold(
                  appBar: AppBar(
                    title: TabBar(
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      controller: _controller,
                      tabs: [
                        Tab(
                          child: Text(
                              '${I18n.of(context).Follow}${I18n.of(context).New}'),
                        ),
                        Tab(
                          child: Text(
                              '${I18n.of(context).Personal}${I18n.of(context).BookMark}'),
                        ),
                        Tab(
                          child: Text(
                              '${I18n.of(context).Follow}${I18n.of(context).Painter}'),
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                          icon: Icon(Icons.account_circle),
                          onPressed: () {
                            AccountState route =
                                BlocProvider.of<AccountBloc>(context).state;
                            if (route is HasUserState)
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(builder: (_) {
                                return UserPage(
                                  id: int.parse(route.list.userId),
                                );
                              }));
                          }),
                      ..._buildActions(context, snapshot)
                    ],
                  ),
                  body: BlocBuilder<AccountBloc, AccountState>(
                      builder: (context, state1) {
                    if (state1 is HasUserState)
                      return MultiBlocListener(
                          listeners: [
                            BlocListener<NewBloc, NewState>(
                              listener: (context, state) {
                                if (state is NewDataRestrictState) {
                                  if (_preNewDataRestrictState != null) {
                                    if (_preNewDataRestrictState.bookRestrict !=
                                        state.bookRestrict)
                                      BlocProvider.of<BookmarkBloc>(context)
                                          .add(FetchBookmarkEvent(
                                              int.parse(state1.list.userId),
                                              state.bookRestrict));
                                    if (_preNewDataRestrictState.newRestrict !=
                                        state.newRestrict)
                                      BlocProvider.of<NewIllustBloc>(context)
                                          .add(FetchIllustEvent(
                                              state.newRestrict));
                                    if (_preNewDataRestrictState
                                            .painterRestrict !=
                                        state.painterRestrict)
                                      BlocProvider.of<NewPainterBloc>(context)
                                          .add(FetchPainterEvent(
                                              int.parse(state1.list.userId),
                                              state.painterRestrict));
                                  } else {
                                    BlocProvider.of<BookmarkBloc>(context).add(
                                        FetchBookmarkEvent(
                                            int.parse(state1.list.userId),
                                            state.bookRestrict));
                                    BlocProvider.of<NewIllustBloc>(context).add(
                                        FetchIllustEvent(state.newRestrict));
                                    BlocProvider.of<NewPainterBloc>(context)
                                        .add(FetchPainterEvent(
                                            int.parse(state1.list.userId),
                                            state.painterRestrict));
                                  }
                                  _preNewDataRestrictState = state; //迷惑行为
                                }
                              },
                            )
                          ],
                          child: TabBarView(
                            controller: _controller,
                            children: [
                              NewIllustPage(
                                restrict: snapshot.newRestrict,
                              ),
                              BookmarkPage(
                                id: int.parse(state1.list.userId),
                                restrict: snapshot.bookRestrict,
                              ),
                              NewPainterPage(
                                id: int.parse(state1.list.userId),
                                restrict: snapshot.painterRestrict,
                              )
                            ],
                          ));
                    else
                      return Container();
                  }),
                );
              } else
                return Scaffold();
            }));
      return Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(
                child:
                    Text('${I18n.of(context).Follow}${I18n.of(context).New}'),
              ),
              Tab(
                child: Text(
                    '${I18n.of(context).Personal}${I18n.of(context).BookMark}'),
              ),
              Tab(
                child: Text(
                    '${I18n.of(context).Follow}${I18n.of(context).Painter}'),
              ),
            ],
            controller: _controller,
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: <Widget>[
            LoginInFirst(),
            LoginInFirst(),
            LoginInFirst(),
          ],
        ),
      );
    });
  }
}
