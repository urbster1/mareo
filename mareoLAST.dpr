Program mareoLAST;

// MAREO ALBUM IS DISTRIBUTED UNDER THE GPL LICENSE - Copyright 2003-2006 by Kwanbis.

{$APPTYPE CONSOLE}

uses SysUtils;

var OwnPath, OwnName: ansistring; albumFile: TextFile; tracks: integer;

begin
  OwnPath := ExcludeTrailingPathDelimiter(ExtractFilePath(ExpandFileName(ParamStr(0))));
  OwnName := ExtractFileName(ExpandFileName(ParamStr(0)));

  WriteLn('MAREO ALBUM - Multiple Applications Runner for EAC and Others - GPL Licensed');
  WriteLn('Version 1.0 - Copyright 2003-2006 by Kwanbis - http://www.webearce.com.ar/');
  WriteLn('Developed with Borland Delphi (info @ http://borland.com/delphi/)');
  WriteLn('');
  WriteLn('Please, enter the number of tracks of the current album and press enter: ');
  Readln(tracks);

  AssignFile(albumFile, OwnPath + '\mareoLAST.ini');
  Rewrite(albumFile);
  WriteLn(albumFile, tracks);
  CloseFile(albumFile);

  WriteLn('Successfully configured ' + OwnPath + '\mareoLAST.ini for ' + IntToStr(tracks) + ' tracks.');

end.
