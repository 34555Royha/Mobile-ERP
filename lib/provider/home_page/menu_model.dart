import 'package:bank/api_helper/http_services.dart';
import 'package:bank/constance_routes/base_routes.dart';
import 'package:http/http.dart' as http;

class Menu extends HttpService {
  //Parameters
  String funcType;
  String parentType;
  String funcDesc;
  int imageId;
  String fontName;
  int fontSize;
  int fontBold;
  String menuName;
  String menuList;
  String allowmodule;
  String rightid;
  int numChild;
  String webModule;
  dynamic webExt;
  String webGroup;
  String iconCode;
  String webUrl;
  String webMenu;
  int id;
  int parentId;

  //Constructors
  Menu({
    this.funcType,
    this.parentType,
    this.funcDesc,
    this.imageId,
    this.fontName,
    this.fontSize,
    this.fontBold,
    this.menuName,
    this.menuList,
    this.allowmodule,
    this.rightid,
    this.numChild,
    this.webModule,
    this.webExt,
    this.webGroup,
    this.iconCode,
    this.webUrl,
    this.webMenu,
    this.id,
    this.parentId,
  });

  //Map
  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        funcType: json["FuncType"],
        parentType: json["ParentType"],
        funcDesc: json["FuncDesc"],
        imageId: json["ImageID"],
        fontName: json["FontName"],
        fontSize: json["FontSize"],
        fontBold: json["FontBold"],
        menuName: json["MenuName"],
        menuList: json["MenuList"],
        allowmodule: json["allowmodule"],
        rightid: json["rightid"],
        numChild: json["NumChild"],
        webModule: json["WebModule"],
        webExt: json["WebExt"],
        webGroup: json["WebGroup"],
        iconCode: json["IconCode"],
        webUrl: json["WebUrl"],
        webMenu: json["WebMenu"],
        id: json["ID"],
        parentId: json["ParentID"],
      );

  //Get Api
  Future<http.Response> getMenu(String search) async {
    return await get(urlGetMenu);
  }
}
