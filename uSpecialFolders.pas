unit uSpecialFolders;

// source: http://msdn.microsoft.com/library/default.asp?url=/library/en-us/shellcc/platform/shell/reference/enums/csidl.asp
// for windows 9x it probably requires: http://www.microsoft.com/downloads/thankyou.aspx?familyId=6AE02498-07E9-48F1-A5D6-DBFA18D37E0F&displayLang=en&oRef=

interface

const
  CSIDL_FLAG_CREATE = $8000;
  CSIDL_ADMINTOOLS = $0030;
  CSIDL_ALTSTARTUP = $001d;
  CSIDL_APPDATA = $001a;
  CSIDL_BITBUCKET = $000a;
  CSIDL_CDBURN_AREA = $003b;
  CSIDL_COMMON_ADMINTOOLS = $002f;
  CSIDL_COMMON_ALTSTARTUP = $001e;
  CSIDL_COMMON_APPDATA = $0023;
  CSIDL_COMMON_DESKTOPDIRECTORY = $0019;
  CSIDL_COMMON_DOCUMENTS = $002e;
  CSIDL_COMMON_FAVORITES = $001f;
  CSIDL_COMMON_MUSIC = $0035;
  CSIDL_COMMON_PICTURES = $0036;
  CSIDL_COMMON_PROGRAMS = $0017;
  CSIDL_COMMON_STARTMENU = $0016;
  CSIDL_COMMON_STARTUP = $0018;
  CSIDL_COMMON_TEMPLATES = $002d;
  CSIDL_COMMON_VIDEO = $0037;
  CSIDL_COMPUTERSNEARME = $003d;
  CSIDL_CONNECTIONS = $0031;
  CSIDL_CONTROLS = $0003;
  CSIDL_COOKIES = $0021;
  CSIDL_DESKTOP = $0000;
  CSIDL_DESKTOPDIRECTORY = $0010;
  CSIDL_DRIVES = $0011;
  CSIDL_FAVORITES = $0006;
  CSIDL_FLAG_DONT_VERIFY = $4000;
  CSIDL_FONTS = $0014;
  CSIDL_HISTORY = $0022;
  CSIDL_INTERNET = $0001;
  CSIDL_INTERNET_CACHE = $0020;
  CSIDL_LOCAL_APPDATA = $001c;
  CSIDL_MYDOCUMENTS = $000c;
  CSIDL_MYMUSIC = $000d;
  CSIDL_MYPICTURES = $0027;
  CSIDL_MYVIDEO = $000e;
  CSIDL_NETHOOD = $0013;
  CSIDL_NETWORK = $0012;
  CSIDL_PERSONAL = $0005;
  CSIDL_PHOTOALBUMS = $0045;
  CSIDL_PLAYLISTS = $003f;
  CSIDL_PRINTERS = $0004;
  CSIDL_PRINTHOOD = $001b;
  CSIDL_PROFILE = $0028;
  CSIDL_PROGRAM_FILES = $0026;
  CSIDL_PROGRAM_FILES_COMMON = $002b;
  CSIDL_PROGRAMS = $0002;
  CSIDL_RECENT = $0008;
  CSIDL_RESOURCES = $0038;
  CSIDL_SAMPLE_MUSIC = $0040;
  CSIDL_SAMPLE_PLAYLISTS = $0041;
  CSIDL_SAMPLE_PICTURES = $0042;
  CSIDL_SAMPLE_VIDEOS = $0043;
  CSIDL_SENDTO = $0009;
  CSIDL_STARTMENU = $000b;
  CSIDL_STARTUP = $0007;
  CSIDL_SYSTEM = $0025;
  CSIDL_TEMPLATES = $0015;
  CSIDL_WINDOWS = $0024;

function SpecialFolder(FolderToGet: Integer): String;

implementation

uses Shlobj, SysUtils, Windows;

function SpecialFolder(FolderToGet: Integer): String;
var
  Folder : pItemIDList;
  FolderRealPath : Array[0..MAX_PATH] Of Char;
begin
  SHGetSpecialFolderLocation(0, FolderToGet, Folder);
  SHGetPathFromIDList(Folder, FolderRealPath);
  Result := StrPas(FolderRealPath);
end;

end.
