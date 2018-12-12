// MAREO IS DISTRIBUTED UNDER THE GPL LICENSE - Copyright 2003-2006 by Kwanbis.

Program mareo;

{$APPTYPE CONSOLE}

uses SysUtils, StrUtils, uExecuteAndWait, uSpecialFolders;

const
  ParametrosFijos = 9;
  Header1 = '***********************************************************';
  Header2 = '* MAREO - Multiple Applications Runner for EAC and Others *';
  Header3 = '* Copyright 2003-2007 by Kwanbis -- Under the GPL License *';
  Header4 = '* Version 6.0b2 - Home Page at http://www.webearce.com.ar *';
  Header5 = '* Developed with Borland Delphi http://borland.com/delphi *';

var
    // holds the number of errors, and an auxiliar counter
    Errores, Contador: integer;

    // holds MAREO's ONW NAME and PATH
    OWNPATH, OWNNAME: ansistring;

    // the number of receibed parameters
    ParametrosCount: integer;

    // array to load the command line parameters
    vParametros: array [0..99] of ansistring;

    // variables that hold the (in order) list of parameters that we receive
    ParamINI, ParamSourceTemp, ParamDestTemp, ParamArtist, ParamAlbum, ParamTitle, ParamTrack, ParamYear, ParamGenre: ansistring;

    // clean variables
    ARTISTCLEAN, ALBUMCLEAN, TITLECLEAN, TRACKCLEAN, YEARCLEAN, GENRECLEAN: ansistring;

    // CorrectionChar
    CorrectionChar: ansistring;

    // System variables
    CsidlAppData, CsidlCdburnArea, CsidlCommonMusic, CsidlDesktop, CsidlDesktopDirectory, CsidlLocalAppdata, CsidlMyDocuments, CsidlMyMusic, CsidlMyPictures, CsidlMyVideo, CsidlPersonal, CsidlPhotoalbums, CsidlPlaylists, CsidlProfile, CsidlPrograms, CsidlProgramFiles, CsidlProgramFilesCommon, CsidlSystem, CsidlWindows: ansistring;

    // text files to MAREO's INI and MAREO's LOG files
    iniFile, logFile: TextFile;

    // variable for ini file reading
    LineaDeTexto: ansistring;

    // the type of action line
    Tipo: ansistring;

    // general configuration variables
    IsCUE, IsVA, LogToScr, LogToTxt, DeleteWav: boolean; PaddingNumber: byte;

    // text file to LastTrack.INI
    LastTrackINI: TextFile;

    // holds the LastTrack TXT
    LastTrack: ansistring;

    // Padded Track Number: example: 1 -> 01
    TrackPadded: ansistring;

    // the encoder order number
    EncoderOrder: integer;

    // encoder order definition variables
    EXECUTEIF, EXTENSION, ENCODEREXE, PARAMETERS, RENAME: ansistring;

    // TEMPORAL Destination variables: hold the temporal dest name with the correct EXTENSION
    TEMPPATH, TEMPNAME, TEMPFULLNAME: ansistring;

    // NORMAL FINAL Destionation variables: hold the final dest name, without forbiden chars.
    FINALPATH, FINALNAME, FINALFULLNAME: ansistring;

    // V.A. FINAL Destionation variables: hold the final dest name, without forbiden chars, for V.A. CDs ONLY.
    VAFINALPATH, VAFINALNAME, VAFINALFULLNAME: ansistring;

    // CUE FINAL Destionation variables: hold the final dest name, without forbiden chars, for V.A. CDs ONLY.
    CUEFINALPATH, CUEFINALNAME, CUEFINALFULLNAME: ansistring;

    // what the execution returns
    Retorno: integer;

    // aux vars
    auxstr: ansistring; auxint: integer;


// it prints to the screen and to the log file, with a carriage return at the end
Procedure PrintLogLn(texto: ansistring);
begin
  if LogToTxt then Writeln(logFile, texto);
  if LogToScr then Writeln(texto);
end;

// it prints to the screen and to the log file, with NO carriage return at the end
Procedure PrintLog(texto: ansistring);
begin
  if LogToTxt then Write(logFile, texto);
  if LogToScr then Write(texto);
end;

// given a text string, replace all the CONSTANT literals with the correct value
function ReplaceEndingFolderPeriods(texto: ansistring): ansistring;
var i: integer;
begin
  for i := Length(Texto) downto 1 do begin
    if Texto[i] = '.' then
      Texto[i] := '_'
    else
      Break;
  end;
  ReplaceEndingFolderPeriods := texto;
end;

// this function cleans any string from non "filenameable" chars
function Limpiar(texto: string): string;
var badchars, newstring: string; i: longint;
begin
  // Char(46) = . || Char(92) = \ ||
  badchars := Char(1) + Char(2) + Char(3) + Char(4) + Char(5) + Char(6) + Char(7) + Char(8) + Char(9) + Char(10) + Char(11) + Char(12) + Char(13) + Char(14) + Char(15) + Char(16) + Char(17) + Char(18) + Char(19) + Char(20) + Char(21) + Char(22) + Char(23) + Char(24) + Char(25) + Char(26) + Char(27) + Char(28) + Char(29) + Char(30) + Char(31) + Char(34) + Char(42) + Char(47) + Char(60) + Char(62) + Char(63) + Char(124);
  for i := 1 to length(texto) do begin
    // if it is a ":" (Char(58)),
    if (Ord(texto[i]) = 58) then begin
      //if it is the first one (c:\foldername), we add it to the string, if not, we replace the ":" with "_"
      if (i = 2) then
        newstring := newstring + texto[i]
      else
        newstring := newstring + CorrectionChar;
    end
    else begin
      // if it is in the list of the invalid chars, it is replaced with CorrectionChar
      if (Pos(texto[i], badchars) = 0) then
        newstring := newstring + texto[i]
      else
        newstring := newstring + CorrectionChar;
    end;
  end;
  Limpiar := newstring;
end;

// RemoveEXT removes the ".xxx" from the end of the filename
function RemoveEXT(texto: ansistring): ansistring;
var i1, i2: word;
begin
  i2 := 0;
  for i1 := length(texto) downto 1 do
    if texto[i1] = '.' then begin
      i2 := i1;
      break;
    end;
  RemoveEXT := Copy(texto, 1, i2-1);
end;

// GetEXT gets the ".xxx" from the end of the filename
function GetEXT(texto: ansistring): ansistring;
var t: ansistring; i1: word;
begin
  if Pos('.', texto) = 0 then
    GetEXT := ''
  else
    t := '';
    for i1 := length(texto) downto 1 do
      if texto[i1] <> '.' then t := texto[i1] + t else break;
  GetEXT := t;
end;

function CopyCue(source, target, newEXT: ansistring): boolean;
var src, tgt: TextFile; linea: ansistring;
{
REM GENRE Alternative
REM DATE 1977
REM DISCID 04008D01
REM COMMENT "ExactAudioCopy v0.99pb3"
PERFORMER "Artista"
TITLE "Album"
FILE "Artista - Album.mareo" WAVE
  TRACK 01 AUDIO
    TITLE "Tema"
    PERFORMER "Artista"
    INDEX 00 00:00:00
}
begin
  AssignFile(src, source); Reset(src);
  AssignFile(tgt, target + '.cue'); Rewrite(tgt);
  while not eof(src) do begin
    Readln(src, linea);
    // REM COMMENT "ExactAudioCopy v0.99pb3" => REM COMMENT "ExactAudioCopy v0.99pb3 + MAREO by Kwanbis"
    if Pos('REM COMMENT "ExactAudioCopy', linea) = 1 then
      Writeln(tgt, AnsiLeftStr(linea, length(linea)-1) + ' + MAREO by Kwanbis"')
    // FILE "Artista - Album.mareo" WAVE => FILE "Artista - Album.EXT" WAVE
    else if Pos('FILE', linea) = 1 then
      // Writeln(tgt, AnsiLeftStr(linea, length(linea)-length('mareo" WAVE'))+newEXT+'" WAVE')
      Writeln(tgt, 'FILE "' + ExtractFilename(target) + '.' + newEXT + '" WAVE')
    else
      Writeln(tgt, linea);
  end;
  CloseFile(src);
  CloseFile(tgt);
  CopyCue := True;
end;

// given a text string, replace all the CONSTANT literals with the correct value
function ReplaceStaticLiterals(texto: ansistring): ansistring;
var i: integer;
begin
  Texto := StringReplace(Texto, '[NOTHING]', '', [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[OWNPATH]', OWNPATH, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[SOURCE]', ParamSourceTemp, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[DESTTMP]', TEMPFULLNAME, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[ARTIST]', ParamArtist, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[ALBUM]', ParamAlbum, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[TITLE]', ParamTitle, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[TRACK]', ParamTrack, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[TRACKPADDED]', TrackPadded, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[LASTTRACK]', ParamTrack, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[YEAR]', ParamYear, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[GENRE]', ParamGenre, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[ARTISTCLEAN]', ARTISTCLEAN, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[ALBUMCLEAN]', ALBUMCLEAN, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[TITLECLEAN]', TITLECLEAN, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[TRACKCLEAN]', TRACKCLEAN, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[YEARCLEAN]', YEARCLEAN, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[GENRECLEAN]', GENRECLEAN, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[EXTENSION]', EXTENSION, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[APPDATA]', CsidlAppData, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[CDBURN_AREA]', CsidlCdburnArea, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[COMMON_MUSIC]', CsidlCommonMusic, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[DESKTOP]', CsidlDesktop, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[DESKTOPDIRECTORY]', CsidlDesktopDirectory, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[LOCAL_APPDATA]', CsidlLocalAppdata, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[MYDOCUMENTS]', CsidlMyDocuments, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[MYMUSIC]', CsidlMyMusic, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[MYPICTURES]', CsidlMyPictures, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[MYVIDEO]', CsidlMyVideo, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[PERSONAL]', CsidlPersonal, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[PHOTOALBUMS]', CsidlPhotoalbums, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[PLAYLISTS]', CsidlPlaylists, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[PROFILE]', CsidlProfile, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[PROGRAMS]', CsidlPrograms, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[PROGRAM_FILES]', CsidlProgramFiles, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[PROGRAM_COMMON]', CsidlProgramFilesCommon, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[SYSTEM]', CsidlSystem, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[WINDOWS]', CsidlWindows, [rfReplaceAll, rfIgnoreCase]);
  for i := 1 to (ParametrosCount - ParametrosFijos) do
    Texto := StringReplace(Texto, '['+IntToStr(i)+']', vParametros[ParametrosFijos + i], [rfReplaceAll, rfIgnoreCase]);
  ReplaceStaticLiterals := texto;
end;

// given a text string, replace all the CONSTANT literals with the correct value
function ReplaceDynamicLiterals(texto: ansistring): ansistring;
begin
  Texto := StringReplace(Texto, '[DESTTMPPATH]', TEMPPATH, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[DESTTMPNAME]', TEMPNAME, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[DESTTMPFULLNAME]', TEMPFULLNAME, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[FINALPATH]', FINALPATH, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[FINALNAME]', FINALNAME, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[FINALFULLNAME]', FINALFULLNAME, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[FINALPATHSHORT]', ExtractShortPathName(FINALPATH), [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[VAFINALPATH]', VAFINALPATH, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[VAFINALNAME]', VAFINALNAME, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[VAFINALFULLNAME]', VAFINALFULLNAME, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[VAFINALPATHSHORT]', ExtractShortPathName(VAFINALPATH), [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[CUEFINALPATH]', CUEFINALPATH, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[CUEFINALNAME]', CUEFINALNAME, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[CUEFINALFULLNAME]', CUEFINALFULLNAME, [rfReplaceAll, rfIgnoreCase]);
  Texto := StringReplace(Texto, '[CUEFINALPATHSHORT]', ExtractShortPathName(CUEFINALPATH), [rfReplaceAll, rfIgnoreCase]);
  ReplaceDynamicLiterals := texto;
end;

// Loads the command line parametters into an array.
function ParseCommandLine(texto: ansistring; var vector: array of ansistring): integer;
var aux, sep: ansistring; saltarseparador: boolean; i, i2: integer;
begin
  // initialize the variables
  texto := Trim(AnsiString(texto));
  i2 := -1; aux := '';
  // if it does not starts with ", the separator is the space, (text is already trimed)
  if texto[1] = '"' then sep := '"' else sep := ' ';
  if texto[1] = '"' then saltarseparador := true else saltarseparador := false;
  for i := 1 to length(texto) do begin
    if saltarseparador then begin
        if (texto[i+1] = '"') or (texto[i+1] = ' ') then begin
           sep := texto[i+1];
           saltarseparador := true;
        end
        else
           saltarseparador := false;
    end
    else begin
      // Ejemplo: "xyz" "abc" 123 => valor1 = xyz valor2 = abc valor3 = 123
      // Ejemplo: 123 abc"123 => valor1 = 123 valor2 = abc"123
      // Ejemplo: ABC "Sting - Ten Summoner's Tales - 03. Fields Of Gold""abc" "xyz 123" "456"abc kkk"123 abc" XX
      // si el caracter que veo es el separador ... hay que tomar guardar el valor aux, y empezar de nuevo.
      if (texto[i] = sep) then begin
        Inc(i2);
        vector[i2] := Trim(aux);
        aux := '';
        // if the next char is a ", then " is the separator, if not, the separator is the " " (space)
        if (texto[i+1] = '"') then begin
           sep := '"';
           saltarseparador := true;
        end
        else if (texto[i+1] = ' ') then begin
           sep := ' ';
           saltarseparador := true;
        end
        else begin
           sep := ' ';
           saltarseparador := false;
        end;
      end
      else
        aux := aux + texto[i];
    end;
  end;
  // if i'm at the end, and the separator wasn't the ", i add the last parameter found
  if ((texto[length(texto)] <> '"') or ((sep = ' ') and (texto[length(texto)] = '"')))and (Trim(aux) <> '') then begin
    Inc(i2);
    vector[i2] := Trim(aux);
  end;
  ParseCommandLine := i2;
end;

function Pad(texto: string; total: integer): AnsiString;
var zeros: string; i: integer;
begin
  if length(texto) >= total then
    Pad := texto
  else begin
    for i := 1 to total do
      zeros := zeros + '0';
    Pad := AnsiRightStr(zeros + texto, total);
  end;
end;

Function Eval(formula: string): boolean;
var a, b: string;
begin
  formula := Trim(uppercase(formula));
  // LASTTRACK
  if formula = 'LASTTRACK' then begin
    if (StrToInt(LastTrack) <> StrToInt(ParamTrack)) then begin
      PrintLogLn('EXECUTEIF = LASTTRACK, Last TRACK is "' + LastTrack +  '" and TRACK number is "' + ParamTrack + '", NO need to execute.');
      Eval := false;
    end else begin
      PrintLogLn('EXECUTEIF = LASTTRACK, Last TRACK is "' + LastTrack +  '" and TRACK number is "' + ParamTrack + '", ready to execute.');
      Eval := true;
    end;
  end
  // TRUE
  else if formula = 'TRUE' then begin
    Eval := True;
  end
  // XX ?= XX
  else begin
    PrintLog('EXECUTEIF = "' + formula + '" ... Evaluating ... ');
    a := Trim(Copy(formula, 1, Pos('=', formula)-1));
    Delete(Formula, 1, Pos('=', Formula));
    b := Trim(formula);
    if a = b then begin
      PrintLogLn('TRUE');
      Eval := true;
    end
    else begin
      PrintLogLn('FALSE');
      Eval := False;
    end;
  end;
  PrintLogLn('');
end;

//*****************************************************************************************************//
//********************************************* MAINSTART *********************************************//
//*****************************************************************************************************//

begin
  {$I-}

  // Errores is used to add up all the "errorlevels" of the diferent encoders run.
  Errores := 0;

  // just in case, we initialize the vars
  ParamArtist := 'Unknown Artist';
  ParamAlbum := 'Unknown Album';
  ParamTitle := 'Unknown Title';
  ParamTrack := '0';
  ParamYear := '1900';
  ParamGenre := 'Unknown';

  // Get the system variables
  CsidlAppData := SpecialFolder(CSIDL_APPDATA);
  CsidlCdburnArea := SpecialFolder(CSIDL_CDBURN_AREA);
  CsidlCommonMusic := SpecialFolder(CSIDL_COMMON_MUSIC);
  CsidlDesktop := SpecialFolder(CSIDL_DESKTOP);
  CsidlDesktopDirectory := SpecialFolder(CSIDL_DESKTOPDIRECTORY);
  CsidlLocalAppdata := SpecialFolder(CSIDL_LOCAL_APPDATA);
  CsidlMyDocuments := SpecialFolder(CSIDL_MYDOCUMENTS);
  CsidlMyMusic := SpecialFolder(CSIDL_MYMUSIC);
  CsidlMyPictures := SpecialFolder(CSIDL_MYPICTURES);
  CsidlMyVideo := SpecialFolder(CSIDL_MYVIDEO);
  CsidlPersonal := SpecialFolder(CSIDL_PERSONAL);
  CsidlPhotoalbums := SpecialFolder(CSIDL_PHOTOALBUMS);
  CsidlPlaylists := SpecialFolder(CSIDL_PLAYLISTS);
  CsidlProfile := SpecialFolder(CSIDL_PROFILE);
  CsidlPrograms := SpecialFolder(CSIDL_PROGRAMS);
  CsidlProgramFiles := SpecialFolder(CSIDL_PROGRAM_FILES);
  CsidlProgramFilesCommon := SpecialFolder(CSIDL_PROGRAM_FILES_COMMON);
  CsidlSystem := SpecialFolder(CSIDL_SYSTEM);
  CsidlWindows := SpecialFolder(CSIDL_WINDOWS);

  // build the OWNPATH, and OWNNAME
  OWNPATH := ExcludeTrailingPathDelimiter(ExtractFilePath(ExpandFileName(ParamStr(0))));
  OWNNAME := ExtractFileName(ExpandFileName(ParamStr(0)));

  // count and load the received command line into a vector
  ParametrosCount := ParseCommandLine(CmdLine, vParametros);

  // load the parameters from the vector into the correct variables
  for Contador := 1 to ParametrosCount do begin
    case Contador of
      // the name of the INI file
      1: ParamINI := vParametros[Contador];
      // SOURCE file name (usually temporal names used)
      2: ParamSourceTemp := vParametros[Contador];
      // destination file name (usually temporal names used)
      3: ParamDestTemp := vParametros[Contador];
      // ARTIST Name
      4: ParamArtist := vParametros[Contador];
      // CD Name
      5: ParamAlbum := vParametros[Contador];
      // TRACK Name
      6: ParamTitle := vParametros[Contador];
      // TRACK Number
      7: ParamTrack := IntToStr(StrToInt(vParametros[Contador])); // this way, we remove padding
      // CD YEAR
      8: ParamYear := vParametros[Contador];
      // CD GENRE
      9: ParamGenre := vParametros[Contador];
    end;
  end;

  // Check if file MAREO.EXE.NOSCREENLOG exists ...
  if FileExists(OWNPATH+'\'+OWNNAME+'.NOSCREENLOG') then LogToScr := False else LogToScr := True;

  // Check if file MAREO.EXE.NOFILELOG exists ...
  if FileExists(OWNPATH+'\'+OWNNAME+'.NOFILELOG') then LogToTxt := False else LogToTxt := True;

  // Open the logfile
  if LogToTxt then begin
    Contador := 1;
    repeat
      AssignFile(logFile, OWNPATH+'\'+ChangeFileExt(OWNNAME, '.'+IntToStr(Contador)+'.log'));
      Rewrite(logFile);
      Inc(Contador);
    until IOResult = 0;
  end;

  // Imprimo el header
  PrintLogLn(Header1);
  PrintLogLn(Header2);
  PrintLogLn(Header3);
  PrintLogLn(Header4);
  PrintLogLn(Header5);
  PrintLogLn(Header1);
  PrintLogLn('');
  PrintLogLn('*** Received Command Line ***');
  PrintLogLn('');
  PrintLogLn(CmdLine);

  // ES UN CUE?
  if FileExists(ExcludeTrailingPathDelimiter(ExtractFilePath(ParamSourceTemp))+'\MAREO.CUE') then
    IsCue := True
  else
    IsCue := False;

  // ES UN V.A. CD?
  if UpperCase(ParamArtist) = 'V.A.' then begin
    IsVA := True;
    auxstr := ParamTitle;
    auxint := AnsiPos('/', auxstr);
    ParamArtist := Trim(AnsiLeftStr(auxstr, auxint-1));
    // Si es un CUE, el artista es "V.A."
    if IsCue then ParamArtist := 'V.A.';
    ParamTitle := Trim(AnsiRightStr(auxstr, Length(auxstr) - auxint));
    if true then;
  end
  else begin
    IsVA := False;
  end;

  // we now create the Clean Version of the Param variables.
  ARTISTCLEAN := Limpiar(ParamArtist);
  ALBUMCLEAN  := Limpiar(ParamAlbum);
  TITLECLEAN  := Limpiar(ParamTitle);
  TRACKCLEAN  := Limpiar(ParamTrack);
  YEARCLEAN   := Limpiar(ParamYear);
  GENRECLEAN  := Limpiar(ParamGenre);

  // if there is NO path specified for the ini, prepend ownpath.
  if ExcludeTrailingPathDelimiter(ExtractFilePath(ParamINI)) = '' then
    ParamINI := IncludeTrailingPathDelimiter(OwnPath) + ExtractFileName(ParamINI);

  // try to open the INI file. if the INI file could not be opened, message and stop
  AssignFile(iniFile, ParamINI);
  FileMode := fmOpenRead + fmShareDenyNone;
  Reset(iniFile);
  if (IOResult <> 0) then begin
    PrintLogLn('');
    PrintLogLn('ERROR: Sorry, but ' + ParamINI + ' does not exists (or could not be opened)!');
    PrintLogLn('');
    CloseFile(iniFile);
    if LogToTxt then CloseFile(logFile);
    Halt(1);
  end;

  // read the INI, searching for the controll lines
  Contador := 0;
  while (not Eof(iniFile)) and (Contador < 3) do begin
    Readln(iniFile, LineaDeTexto); LineaDeTexto := Trim(LineaDeTexto);
    if (LineaDeTexto <> '') and (Pos(';', LineaDeTexto) <> 1) then begin          // if it is not a comment process it
      Inc(Contador);
      // read the "type" (PADDINGZEROS, DELETEWAVFILE, CorrectionChar), delete from the line, and trim
      tipo := Trim(Copy(LineaDeTexto, 1, Pos('=', LineaDeTexto)-1)); Delete(LineaDeTexto, 1, Pos('=', LineaDeTexto)); LineaDeTexto := Trim(LineaDeTexto);
      // assign the value according to the "type"
      if uppercase(tipo) = 'PADDINGZEROS' then PaddingNumber := StrToInt(LineaDeTexto);
      if uppercase(tipo) = 'DELETEWAVFILE' then if uppercase(LineaDeTexto) = 'TRUE' then DeleteWav := true else DeleteWav := false;
      if uppercase(tipo) = 'CORRECTIONCHAR' then CorrectionChar := Trim(LineaDeTexto);
    end;
  end;

  // Intentamos leer el LASTTRACK
  AssignFile(LastTrackINI, OWNPATH + '\mareoLAST.ini');
  Reset(LastTrackINI);
  if (IOResult <> 0) then begin
    LastTrack := '';
  end else begin
    ReadLn(LastTrackINI, LastTrack);
    CloseFile(LastTrackINI);
  end;
  // si es un CUE, es un solo "track", por lo que LastTrack := ParamTrack
  if IsCUE then LastTrack := ParamTrack;


  // we pad the TRACK number
  TrackPadded := Pad(ParamTrack, PaddingNumber);

  PrintLogLn('');
  if IsVA then begin
    PrintLogLn('<<< ATTENTION: "V.A. CD": using V.A. naming scheme. >>>');
    PrintLogLn('');
  end;
  // PrintLogLn(ExcludeTrailingPathDelimiter(ExtractFilePath(ParamSourceTemp))+'\MAREO.CUE');
  if IsCUE then begin
    PrintLogLn('<<< ATTENTION: "CUE File": using CUE naming scheme. >>>');
    PrintLogLn('');
  end;
  PrintLogLn('*** Parsed Parameters ***');
  PrintLogLn('');
  PrintLogLn('INIFILE       (%1) = ' +ParamINI);
  PrintLogLn('[SOURCE]      (%2) = ' +ParamSourceTemp);
  PrintLogLn('[DESTTMP]     (%3) = ' +ParamDestTemp);
  PrintLogLn('[ARTIST]      (%4) = ' +ParamArtist);
  PrintLogLn('[ALBUM]       (%5) = ' +ParamAlbum);
  PrintLogLn('[TITLE]       (%6) = ' +ParamTitle);
  PrintLogLn('[TRACK]       (%7) = ' +ParamTrack);
  PrintLogLn('[YEAR]        (%8) = ' +ParamYear);
  PrintLogLn('[GENRE]       (%9) = ' +ParamGenre);
  for Contador := 1 to (ParametrosCount - ParametrosFijos) do
    PrintLogLn('[' +IntToStr(Contador) +']          (%' +IntToStr(ParametrosFijos + Contador) +') = ' + vParametros[ParametrosFijos + Contador]);
  PrintLogLn('');

  PrintLogLn('*** INI Parameters ***');
  PrintLogLn('');
  PrintLogLn('Padding Zeros      = ' + IntToStr(PaddingNumber));
  PrintLog('DeleteWavFile      = ');
  if DeleteWav = true then PrintLogLn('TRUE') else PrintLogLn('FALSE');
  PrintLogLn('CorrectionChar     = ' + CorrectionChar);

  if LastTrack <> '' then begin
    PrintLogLn('');
    PrintLogLn('*** mareoLAST.INI ***');
    PrintLogLn('');
    PrintLogLn('[LASTTRACK]          = ' + LastTrack);
    PrintLogLn('');
  end;

  EncoderOrder := 0;

  EXECUTEIF := '';
  ENCODEREXE := '';
  PARAMETERS := '';
  EXTENSION := '';
  RENAME := '';
  TEMPPATH := '';
  TEMPNAME := '';
  TEMPFULLNAME := '';
  FINALPATH := '';
  FINALNAME := '';
  FINALFULLNAME := '';
  VAFINALPATH := '';
  VAFINALNAME := '';
  VAFINALFULLNAME := '';
  CUEFINALPATH := '';
  CUEFINALNAME := '';
  CUEFINALFULLNAME := '';


  // ********************************************************************************************************* //
  // ***************************** comienzo a procesar los ENCODER ORDERS: MAIN2 ***************************** //
  // ********************************************************************************************************* //
  
  while not Eof(iniFile) do begin

    // read the line
    Readln(iniFile, LineaDeTexto);
    LineaDeTexto := Trim(LineaDeTexto);

    // if it is not a comment (it does not starts with a ;)
    if (LineaDeTexto <> '') and (Pos(';', LineaDeTexto) <> 1) then begin

      // take the the "type" (EXT, PATH, ENCODER, PARAMETERS, etc) from the action line
      tipo := Trim(Copy(LineaDeTexto, 1, Pos('=', LineaDeTexto)-1));

      // we check if it is a correct action line
      if Pos(UpperCase(tipo), 'EXECUTEIF FINALPATH FINALNAME VAFINALPATH VAFINALNAME CUEFINALPATH CUEFINALNAME EXTENSION ENCODEREXE PARAMETERS RENAME') = 0 then begin
        PrintLogLn(''); PrintLogLn('UNRECOGNIZED ACTION LINE: ' + LineaDeTexto); PrintLogLn('');
      end;

      // delete from the line the "type", and then trim "LineaDeTexto"
      Delete(LineaDeTexto, 1, Pos('=', LineaDeTexto)); LineaDeTexto := Trim(LineaDeTexto);

      if      (UpperCase(tipo) = 'EXECUTEIF')    then EXECUTEIF    := UpperCase(LineaDeTexto)
      else if (UpperCase(tipo) = 'FINALPATH')    then FINALPATH    := ExcludeTrailingPathDelimiter(LineaDeTexto)
      else if (UpperCase(tipo) = 'FINALNAME')    then FINALNAME    := LineaDeTexto
      else if (UpperCase(tipo) = 'VAFINALPATH')  then VAFINALPATH  := ExcludeTrailingPathDelimiter(LineaDeTexto)
      else if (UpperCase(tipo) = 'VAFINALNAME')  then VAFINALNAME  := LineaDeTexto
      else if (UpperCase(tipo) = 'CUEFINALPATH') then CUEFINALPATH := ExcludeTrailingPathDelimiter(LineaDeTexto)
      else if (UpperCase(tipo) = 'CUEFINALNAME') then CUEFINALNAME := LineaDeTexto
      else if (UpperCase(tipo) = 'EXTENSION')    then EXTENSION    := LineaDeTexto
      else if (UpperCase(tipo) = 'ENCODEREXE')   then ENCODEREXE   := LineaDeTexto
      else if (UpperCase(tipo) = 'PARAMETERS')   then PARAMETERS   := LineaDeTexto
      else if (UpperCase(tipo) = 'RENAME')       then RENAME       := LineaDeTexto;

    end; // END it is not a comment (it does not starts with a ;)

    // if is all ready to encode
    if (EXECUTEIF<>'') and (FINALPATH<>'') and (FINALNAME<>'') and (VAFINALPATH<>'') and (VAFINALNAME<>'') and (CUEFINALPATH<>'') and (CUEFINALNAME<>'') and (EXTENSION<>'') and (ENCODEREXE<>'') and (PARAMETERS<>'') and (RENAME<>'') then begin

      // increment the encoder order counter
      Inc(EncoderOrder);

      PrintLogLn('');
      PrintLogLn('');
      PrintLogLn('*** PROCESSING ENCODER ORDER # ' +IntToStr(EncoderOrder) +' ***');
      PrintLogLn('');

      //**********************************************************************************************************//
      //********************************** Destination Temporal Full Name ****************************************//
      //**********************************************************************************************************//

      //// DEST (TMP) FULL PATH ONLY: extract the path from ParamDestTemp
      TEMPPATH := ExcludeTrailingPathDelimiter(ExtractFilePath(ParamDestTemp));
      // if no path on ParamDestTemp (ie: tmp(207!.wav instead of c:\eac\tmp(207!.wav) use OWNPATH's path
      if TEMPPATH = '' then TEMPPATH := OWNPATH;

      //// DEST (TMP) NAME ONLY (NO EXTENSION): extract the filename, and remove the EXTENSION
      TEMPNAME := RemoveEXT(ExtractFileName(ParamDestTemp));

      //// DEST (TMP) FULL NAME
      TEMPFULLNAME := TEMPPATH + '\' + TEMPNAME + '.' + EXTENSION;

      //**********************************************************************************************************//
      //************************************* Destination Final Full Name ****************************************//
      //**********************************************************************************************************//

      //// replace the static literals on the, path and filename
      FINALPATH := ReplaceStaticLiterals(FINALPATH);
      FINALNAME := ReplaceStaticLiterals(FINALNAME);
      VAFINALPATH := ReplaceStaticLiterals(VAFINALPATH);
      VAFINALNAME := ReplaceStaticLiterals(VAFINALNAME);
      CUEFINALPATH := ReplaceStaticLiterals(CUEFINALPATH);
      CUEFINALNAME := ReplaceStaticLiterals(CUEFINALNAME);

      //// replace the dynamic literals on the, path and filename
      FINALPATH := ReplaceDynamicLiterals(FINALPATH);
      FINALNAME := ReplaceDynamicLiterals(FINALNAME);
      VAFINALPATH := ReplaceDynamicLiterals(VAFINALPATH);
      VAFINALNAME := ReplaceDynamicLiterals(VAFINALNAME);
      CUEFINALPATH := ReplaceDynamicLiterals(CUEFINALPATH);
      CUEFINALNAME := ReplaceDynamicLiterals(CUEFINALNAME);

      //// clean the, path and filename
      FINALPATH := ReplaceEndingFolderPeriods(Limpiar(FINALPATH));       FINALNAME := Limpiar(FINALNAME);
      VAFINALPATH := ReplaceEndingFolderPeriods(Limpiar(VAFINALPATH));   VAFINALNAME := Limpiar(VAFINALNAME);
      CUEFINALPATH := ReplaceEndingFolderPeriods(Limpiar(CUEFINALPATH)); CUEFINALNAME := Limpiar(CUEFINALNAME);

      //// DEST (FINAL) FULL NAME
      FINALFULLNAME := FINALPATH + '\' + FINALNAME + '.' + EXTENSION;
      VAFINALFULLNAME := VAFINALPATH + '\' + VAFINALNAME + '.' + EXTENSION;
      CUEFINALFULLNAME := CUEFINALPATH + '\' + CUEFINALNAME + '.' + EXTENSION;

      //**********************************************************************************************************//
      //************************** IF IT'S A VA CD, WE OVERRITE ALL NORMAL VARIABLES W/VA VALUES ******************//
      //**********************************************************************************************************//
      if IsVA then begin
        FINALFULLNAME := VAFINALFULLNAME;
        FINALPATH := VAFINALPATH;
        FINALNAME := VAFINALNAME;
      end;

      //**********************************************************************************************************//
      //************************** IF IT'S A CUE, WE OVERRITE ALL NORMAL VARIABLES W/CUE VALUES ******************//
      //**********************************************************************************************************//
      if IsCUE then begin
        FINALFULLNAME := CUEFINALFULLNAME;
        FINALPATH := CUEFINALPATH;
        FINALNAME := CUEFINALNAME;
      end;

      //**********************************************************************************************************//
      //************************** now we replace static literals and dynamic literals ***************************//
      //**********************************************************************************************************//

      //// Replace Static Literals
      EXECUTEIF := ReplaceStaticLiterals(EXECUTEIF);
      ENCODEREXE := ReplaceStaticLiterals(ENCODEREXE);
      PARAMETERS := ReplaceStaticLiterals(PARAMETERS);
      RENAME := ReplaceStaticLiterals(RENAME);

      //// Replace Dynamic Literals
      EXECUTEIF := ReplaceDynamicLiterals(EXECUTEIF);
      ENCODEREXE := ReplaceDynamicLiterals(ENCODEREXE);
      PARAMETERS := ReplaceDynamicLiterals(PARAMETERS);
      RENAME := ReplaceDynamicLiterals(RENAME);

      //**********************************************************************************************************//
      //********************************* we are ready to go, show what we have **********************************//
      //**********************************************************************************************************//

      // Print the report
      PrintLogLn('EXECUTE IF             = ' + EXECUTEIF);
      PrintLogLn('');
      PrintLogLn('NEW EXTENSION          = ' + EXTENSION);
      PrintLogLn('');
      PrintLogLn('TEMPORAL FULL NAME     = ' + TEMPFULLNAME);
      PrintLogLn('TEMPORAL PATH ONLY     = ' + TEMPPATH);
      PrintLogLn('TEMPORAL NAME ONLY     = ' + TEMPNAME);
      PrintLogLn('');
      PrintLogLn('RENAME FINAL FILE      = ' + RENAME);
      PrintLogLn('');
      if IsCUE then begin
        PrintLogLn('FINAL FULL NAME (CUE)  = ' + FINALFULLNAME);
        PrintLogLn('FINAL PATH ONLY (CUE)  = ' + FINALPATH);
        PrintLogLn('FINAL NAME ONLY (CUE)  = ' + FINALNAME);
      end
      else if IsVA then begin
        PrintLogLn('FINAL FULL NAME (V.A.) = ' + FINALFULLNAME);
        PrintLogLn('FINAL PATH ONLY (V.A.) = ' + FINALPATH);
        PrintLogLn('FINAL NAME ONLY (V.A.) = ' + FINALNAME);
      end
      else begin
        PrintLogLn('FINAL FULL NAME        = ' + FINALFULLNAME);
        PrintLogLn('FINAL PATH ONLY        = ' + FINALPATH);
        PrintLogLn('FINAL NAME ONLY        = ' + FINALNAME);
      end;
      PrintLogLn('');

      // si el "Eval" del EXECUTEIF es true, encodeo.
      if Eval(EXECUTEIF) then begin
        // if encoder = NONE, does not executes
        if UpperCase(ENCODEREXE) = 'NONE' then begin
          PrintLogLn('EXECUTING: ENCODER IS NONE, NO NEED TO EXECUTE.');
          Retorno := 0;
        end
        else begin
          if FileExists(ENCODEREXE) then begin
            PrintLogLn('EXECUTING: ' + ENCODEREXE + ' ' + PARAMETERS);
            Retorno := ExecuteAndWait(ENCODEREXE + ' ' + PARAMETERS);
          end else begin
            PrintLogLn('EXECUTION: ERROR: NOT FOUND: ' + ENCODEREXE);
            Retorno := 1;
          end;
          PrintLogLn('');
          if Retorno = 0 then begin
            PrintLogLn('EXECUTION: SUCCESS')
          end
          else begin
            Inc(Errores);
            PrintLogLn('EXECUTION: -ERROR- (' + IntToStr(Retorno) + ')');
          end;
        end;
        PrintLogLn('');

        // Si FINALFULLNAME = "NONE", no renombramos (es por que estamos usando un pre-procesador como el wavegain)
        if (RENAME = 'FALSE') then
          PrintLogLn('RENAME IS FALSE, NO need to rename.')
        else begin
          // me fijo si esta el directorio final, y si no, lo trato de crear.
          If Not(DirectoryExists(FINALPATH)) then begin
            PrintLog('DIRECTORY "' + FINALPATH + '" does NOT exists, creating ... ');
            if ForceDirectories(FINALPATH) then begin
              PrintLogLn('SUCCESS');
            end
            else begin
              PrintLogLn('-ERROR-');
              Inc(Errores);
            end;
          end
          else
            PrintLogLn('DIRECTORY "' + FINALPATH + '" allready exists.');
          PrintLogLn('');

          // rename the temporal name to the destination only if they are not = if they are, no need to rename!
          if ExpandFilename(TEMPFULLNAME) <> ExpandFilename(FINALFULLNAME) then begin
            // if the destination file already exists, try to delete it
            if FileExists(FINALFULLNAME) then begin
              PrintLog('DELETING: ' + FINALFULLNAME + ' ... ');
              if SysUtils.DeleteFile(FINALFULLNAME) then begin
                PrintLogLn('SUCCESS');
              end
              else begin
                Inc(Errores);
                PrintLogLn('-ERROR-');
              end;
              PrintLogLn('');
            end;
            // if RenameFile(ExpandFilename(TEMPFULLNAME), ExpandFilename(FINALFULLNAME)) then begin
            if RenameFile(TEMPFULLNAME, FINALFULLNAME) then begin
              // PrintLogLn('RENAMING: ' + ExpandFilename(TEMPFULLNAME) + ' =] ' + ExpandFilename(FINALFULLNAME) + ' ... SUCCESS');
              PrintLogLn('RENAMING: ' + TEMPFULLNAME + ' =] ' + FINALFULLNAME + ' ... SUCCESS');
            end
            else begin
              Inc(Errores);
              // PrintLogLn('RENAMING: ' + ExpandFilename(TEMPFULLNAME) + ' =] ' + ExpandFilename(FINALFULLNAME) + ' ... -ERROR-');
              PrintLogLn('RENAMING: ' + TEMPFULLNAME + ' =] ' + FINALFULLNAME + ' ... -ERROR-');
            end;
            PrintLogLn('');
          end;
        end;

        If IsCUE then begin
          PrintLogLn('CUE FILE: ' + ExcludeTrailingPathDelimiter(ExtractFilePath(ParamSourceTemp))+'\MAREO.CUE');
          PrintLogLn('CUE FILE: ' + FINALPATH + '\' + FINALNAME);
          PrintLogLn('CUE FILE: ' + EXTENSION);
          CopyCue(ExcludeTrailingPathDelimiter(ExtractFilePath(ParamSourceTemp))+'\MAREO.CUE', FINALPATH + '\' + FINALNAME, EXTENSION);
        end;

      end;

      // blanqueo las variables, y vuelvo a empezar
      EXECUTEIF := '';
      ENCODEREXE := '';
      PARAMETERS := '';
      EXTENSION := '';
      RENAME := '';
      TEMPPATH := '';
      TEMPNAME := '';
      TEMPFULLNAME := '';
      FINALPATH := '';
      FINALNAME := '';
      FINALFULLNAME := '';

    end; // END if is all ready to encode

  end; // END while

  PrintLogLn('');
  PrintLogLn('*** Encoder Orders Ends ***');

  // BORRO EL WAV SI ES NECESARIO
  if DeleteWav then begin
    PrintLogLn('');
    PrintLogLn('DeleteWaveFile is TRUE.');
    PrintLogLn('');
    if FileExists(ParamSourceTemp) then begin
      PrintLog('DELETING: ' + ParamSourceTemp + ' ... ');
      if SysUtils.DeleteFile(ParamSourceTemp) then begin
        PrintLogLn('SUCCESS');
      end
      else begin
        Inc(Errores);
        PrintLogLn('-ERROR-');
      end;
    end
    else begin
      PrintLogLn(ParamSourceTemp + ' DOES NOT EXISTS!');
    end;
  end
  else begin
    PrintLogLn('');
    PrintLogLn('DeleteWaveFile is FALSE.');
  end;

  // BORRO EL CUE SI ES NECESARIO
  If IsCUE then begin
    PrintLogLn('');
    if FileExists(ExcludeTrailingPathDelimiter(ExtractFilePath(ParamSourceTemp)) + '\MAREO.CUE') then begin
      PrintLog('DELETING ORIGINAL CUE FILE: ' + ExcludeTrailingPathDelimiter(ExtractFilePath(ParamSourceTemp)) + '\MAREO.CUE' + ' ... ');
      if SysUtils.DeleteFile(ExcludeTrailingPathDelimiter(ExtractFilePath(ParamSourceTemp))+'\MAREO.CUE') then begin
        PrintLogLn('SUCCESS');
      end
      else begin
        Inc(Errores);
        PrintLogLn('-ERROR-');
      end;
    end;
  end;

  PrintLogLn('');
  PrintLogLn('');
  PrintLogLn('*** DONE ***');
  PrintLogLn('');

  // si Errores es mayor a 0, aviso y pauso.
  if Errores <> 0 then begin
    PrintLogLn(IntToStr(Errores) +' errors ocurred. Press any key to end.');
    PrintLogLn('');
    ReadLn;
  end
  else begin
    PrintLogLn('NO errors ocurred.');
    PrintLogLn('');
  end;

  CloseFile(iniFile);

  if LogToTxt then CloseFile(logFile);

  // Termino, con el errorlevel de Errores.
  Halt(Errores);
 {$I+}
end.
