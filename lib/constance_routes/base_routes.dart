//API Server
String ipAdd = '192.168.5.44:8080'; //IP Address of API Server

//API Local
//String ipAdd = 'Number of IP Address your computer';  //IP Address of Local

final String httpMethod = "http://";
final String baseTokenUrl = '$ipAdd/mbapi/oauth/token';
final String baseApiUrl = '$ipAdd/mbapi/api'; //required token
final String clientId = 'testjwtclientid';
final String clientSecret = 'XY7kmzoNzl100';
final String baseUrl = "$ipAdd/mbapi"; //not required token

//Token
final String urlAccessToken =
    '$httpMethod$clientId:$clientSecret@$baseTokenUrl';
final String urlGetMenu = '$httpMethod$baseApiUrl/menus';
final String urlGetParams = '$httpMethod$baseApiUrl/leave/param';
final String urlGetUserProfile = '$httpMethod$baseApiUrl/profile';
final urllogout = "$httpMethod$baseApiUrl/profile/logout";

//Auth
final urlRegister = '$httpMethod$baseUrl/register/verify';
final urlRecoveryPassword = '$httpMethod$baseUrl/register/recpwd';
