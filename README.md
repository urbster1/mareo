# MAREO
[<span>download</span>](https://hydrogenaud.io/index.php?PHPSESSID=v40obis8lgupf2oi1i2vn6ee13&action=dlattach;topic=59569.0;attach=7064 "download")
[<span>support</span>](http://www.hydrogenaudio.org/forums/index.php?s=&showtopic=44559&view=findpost&p=391888 "support")
[MAREO: Multiple Applications Runner for EAC and Others](https://hydrogenaud.io/index.php?PHPSESSID=v40obis8lgupf2oi1i2vn6ee13&action=dlattach;topic=59569.0;attach=7064 "Permalink")
-------------------------------------------------------------------------------------------------

INTRODUCTION
============

MAREO, spanish for ‘dizziness’, is a special program for CD rippers and other audio compression frontends that has the ability to execute multiple encoders for each track ripped, allowing to encode to multiple audio formats at the same time.

It can be used to rip to FLAC (for archival) and MP3 (for MP3 Player use) at once, or to WavPack and Ogg Vorbis, or to Monkey’s Audio and AAC, etc.

Once properly configured, MAREO is called from the frontend software (be it EAC or Others), as if it where an encoder, which in turn would execute all the encoders it has been instructed to, passing them the required parameters such as source and destination file, album artist, album name, track number, track name, album date, genre, etc.

It can also be used to execute pre-processor and post-processor programs, like WaveGain and MP3Gain respectively.

MAREO is also capable of handling "multi-file-generator" encoders, like OptimFROG and WavPack.

MAREO comes pre-configured, and has been tested to work with the following encoders and/or processors:

1. LAME MP3
2. Ogg Vorbis
3. iTunes MP4/AAC (w/iTunesEncode)
4. QuickTime Pro MP4/AAC (w/Qutibacoas)
5. Nero Digital Quality MP4 & 3GPP Audio Codec
6. Nero AAC (w/NAACenc)
7. MusePack
8. FLAC
9. WavPack (including hybrid with correction file)
10. OptimFROG (including correction file)
11. WaveGain
12. MP3Gain
13. WAPET
14. AtomicParsley

MAREO has also been tested to work with the following rippers:

1. Exact Audio Copy (EAC)
2. Plextools Professional XL
3. Audiograbber
4. dBpowerAMP
5. foobar2000
6. CDex

MAREO is an open source/GPL-licensed application developed using Borland’s Delphi, and is my (very) humble contribution to the excellent [Hydrogenaudio](http://www.hydrogenaudio.org) community.

MAREO is very easy to set up. It consist of only 2 steps:

1. Configuring the CD Ripper to call MAREO (as if it where a command line encoder (CLI)),
2. and telling MAREO how do we want it to encode.

But before you start, [download MAREO](https://hydrogenaud.io/index.php?PHPSESSID=v40obis8lgupf2oi1i2vn6ee13&action=dlattach;topic=59569.0;attach=7064) **4.0** and [uncompress](http://www.7-zip.org) it to your ripper’s folder.

CONFIGURING THE CD RIPPER
=========================

MAREO, when called from the CD ripper, expects to receive on the command line, and in this order, the following parameters:

INIFILE SOURCE DESTTMP ARTIST ALBUM TITLE TRACK YEAR GENRE 1 .. N

|         |                                                                                                  |
|---------|--------------------------------------------------------------------------------------------------|
| INIFILE | name of the plain text (ASCII) file that holds MAREO’s configuration (usually mareo.ini).        |
| SOURCE  | name of the temporal WAV file produced by the CD ripper (example: c:\\ripper\\mtmp(207!.wav).    |
| DESTTMP | name of the temporal encoded file produced by the encoders (example: c:\\ripper\\mtmp(207!.mp3). |
| ARTIST  | album/cd artist name (example: Marc Antony).                                                     |
| ALBUM   | album/cd name (example: Mended).                                                                 |
| TITLE   | song/track name (example: I Swear).                                                              |
| TRACK   | song/track number (example: 7).                                                                  |
| YEAR    | year the album/cd was produced.                                                                  |
| GENRE   | genre the album/cd belongs to.                                                                   |
| 1 … n   | Any parameter passed by the ripper to MAREO, after the genre.                                    |

Lets see some ripper setup examples.

EXACT AUDIO COPY (EAC) SETUP (screen shot)
==========================================

Press F11 or use the menus: EAC =\] Compression Options. Once on the Compression options dialog box, under the External Compression tab, set the fields as follows:

1. Parameter passing scheme: User Defined Encoder
2. Use file extension: the file extension of the first encoder you are going to use(\*)
3. Program, including path, used for compression: MAREO’s full path
4. Additional command line options: mareo.ini %s %d "%a" "%g" "%t" "%n" %y "%m"
5. Add ID3 tag: unchecked
6. Delete WAV after compression: unchecked

IMPORTANT: double quotes (") are used to enclose parameters that can have spaces inside. EAC automatically encloses source (%s) and destination (%d) file names with double quotes (") if required so it is not needed in either case.

(\*): If you want MAREO to rename all the files, you must cheat EAC. EAC gets confused when MAREO ends and it can’t find the encoded file to rename, as MAREO has already renamed it, so out of confusion EAC deletes the file that has matching extension with the one defined in EAC’s config! The workaround is to define EAC’s "Use file extension" to any one not being actually used, for example XXX. If you set the extension to XXX, EAC can’t find any matching file, and it goes ok. (You can also set EAC’s naming scheme to one different that the one MARE would use, like only album - track (%C - %N). Anyone would work, as MAREO would be renaming).

PLEXTOOLS PROFESSIONAL XL SETUP (screen shot)
=============================================

Choose Disc Functions, then Disc Extraction in the Functions Window.

1. Output Path: The folder where you want to store the temporary Wave files. Press the Preferences Button -\] Disc Extraction
2. Audio Format: Choose External Encoder. Press the Extra Options button
3. Select the program: MAREO’s full path
4. Command Line Arguments: mareo.ini %S %O "%A" "%C" "%T" "%N" %Y "%G"
5. File Extension: Choose one of the following extensions: .flac / .ogg / .ape
6. Tag info is included in the command line arguments: checked

The Filename Options under Disc Extraction just name the temporary wave files after the user defined naming scheme, not the files encoded with MAREO. PlexTools Professional XL deletes the Wave files automatically, so the DeleteWavFile option in mareo.ini is always FALSE.

IMPORTANT: In the trackfield under Disc Extraction, one needs to right click on a track and choose MP3 ID3 Tag. Make sure, that you choose freedb in the ‘Get CD TEXT from’ field at the bottom! (I think this tweak only has to be applied once. PTPXL will save the configuration)

IMPORTANT: Double quotes (") are used to enclose parameters that can have spaces inside. EAC automatically encloses source (%s) and destination (%d) file names with double quotes (") if required so it is not needed in either case.

AUDIOGRABBER SETUP (screen shot)
================================

Click on Settings menu, then MP3 settings.

1. Check "External Encoder"
2. Browse for mareo.exe
3. Predefined Arguments: User Defined
4. Arguments: mareo.ini %s %d "%1" "%2" "%4" "%3" "%6" "%7"
5. File Extension: the file extension of the 1st format you are going to encode into

IMPORTANT: Double quotes (") are used to enclose parameters that can have spaces inside. Audiograbber uses the short path/name for source (%s) and destination (%d) so it is not needed to enclose in either case.

DBPOWERAMP SETUP (screen shot)
==============================

IMPORTANT: There seems to be an error on the latest CLI of dBpowerAMP that prevents it from working. Next version of dBpowerAMP should work again.

You need to download and install the Generic CLI. Define MAREO command line by running Start \]\] Programs \]\] dBpowerAMP Music Converter \]\] Create Generic CLI.

1. Shown Name: MAREO
2. Use Cli Encoder: (browse for) mareo.exe
3. File Extension: the file extension of the 1st format you are going to encode into

Press Create, and then close this dialog box. Start dBpowerAMP and press the Options button.

Under the Audio CD Input Options, in Rip to, select MAREO, uncheck Write ID tags, and press Settings button.

Check and confirm mareo.exe location, and press OK.

In Command Line, complete with: mareo.ini \[InFile\] \[OutFile\] \[IDArtist\] \[IDAlbum\] \[IDTrack\] \[IDTrackNumber\] \[IDYear\] \[IDGenre\] and press OK.

CDEX SETUP (screen shot)
========================

Press F4 or use the menus: Set CDex Options =\] Settings. Once on the CDex configuration dialog box, under the Encoder tab, set the fields as follows:

1. Encoder: External Encoder
2. Encoder path: (browse for) mareo.exe
3. File Extension: the file extension of the 1st format you are going to encode into
4. Parameter string: mareo.ini %1 %2 "%a" "%b" "%t" "%tn" "%y" "%g"
5. Don’t delete ripped WAV file after conversion: checked

IMPORTANT: Double quotes (") are used to enclose parameters that can have spaces inside. CDex uses the short path/name for source (%1) and destination (%2) so it is not needed in either case.

FOOBAR2000′S DISKWRITER SETUP (screen shot)
===========================================

1. Control-P. Tools, Converter, Add New.
2. Encoder: Custom
3. Encoder: (browse for) mareo.exe
4. Extension: extension of the 1st encoded file (or the file that fb2k would rename).
5. Parameters: mareo.ini %s %d "%artist%" "%album%" "%title%" %tracknumber%" "%date%" "%genre%"
6. Display Name: MAREO

foobar2000 likes to rename its converted files, so, when you define the INI, the encoder order with the same extension that was defined on the previous steps, must be set to RENAME = FALSE. More on it latter.

For example, if in (4.) Extension: mp3, the MP3 encoder order must be set to RENAME = FALSE.

IMPORTANT: Double quotes (") are used to enclose parameters that can have spaces inside.

CONFIGURING MAREO
=================

Now that the CD ripper is ready, we must tell MAREO how we want to encode.

But first, some introduction to \[PLACEHOLDERS\].

\[PLACEHOLDERS\]
================

\[PLACEHOLDERS\] are memory cells that hold a text value.

For example, when ripping the eleventh track of Queen’s "Bohemian Rhapsody", MAREO could receive:

mareo.ini "c:\\temp\\track.wav" "c:\\temp\\track.ogg" "Queen" "A Night At The Opera" "Bohemian Rhapsody" "11" 1975 "Rock"

MAREO would take each parameter, and load it on the corresponding \[PLACEHOLDER\]:

|                     |                                                                                            |
|---------------------|--------------------------------------------------------------------------------------------|
| \[SOURCE\]          | c:\\temp\\track.wav                                                                        |
| \[DESTTMP\]         | c:\\temp\\track.ogg                                                                        |
| \[ARTIST\]          | Queen                                                                                      |
| \[ALBUM\]           | A Night At The Opera                                                                       |
| \[TITLE\]           | Bohemian Rhapsody                                                                          |
| \[TRACK\]           | 11                                                                                         |
| \[YEAR\]            | 1975                                                                                       |
| \[GENRE\]           | Rock                                                                                       |
| \[DESTTMPPATH\]     | MAREO would extract from \[DESTTMP\] the destination temporal PATH.                        |
| \[DESTTMPNAME\]     | MAREO would extract from \[DESTTMP\] the destination temporal NAME, with no extension.     |
| \[DESTTMPFULLNAME\] | destination temporal full name: \[DESTTMPPATH\] + \\ + \[DESTTMPNAME\] + . + \[EXTENSION\] |

Latter, when processing the configuration INI, each time MAREO encounters a \[PLACEHOLDER\], it would replace it with the correct value.

For example, if we are telling MAREO that the command line parameters for the oggenc.exe encoder are:

-q 4.25 "\[source\]" -o "\[desttmp\]" -a "\[artist\]" -l "\[album\]" -t "\[title\]" -N \[track\] -d \[year\] -G "\[genre\]"

MAREO would read it to:

-q 4.25 "c:\\temp\\track.wav" -o " c:\\temp\\track.ogg" -a "Queen" -l "A Night At The Opera" -t "Bohemian Rhapsody" -N 11 -d 1975 -G "Rock"

The list of \[PLACEHOLDERS\] that MAREO recognizes is:

|                 |                                                                                              |
|-----------------|----------------------------------------------------------------------------------------------|
| \[PLACEHOLDER\] | VALUE                                                                                        |
| \[SOURCE\]      | temporal source FULL file name, command line arameter \#2 passed by the ripper to MAREO      |
| \[DESTTMP\]     | temporal destination FULL file name, command line arameter \#3 passed by the ripper to MAREO |
| \[ARTIST\]      | CD Artist Name, command line arameter \#4 passed by the ripper to MAREO                      |
| \[ALBUM\]       | CD Name, command line arameter \#5 passed by the ripper to MAREO                             |
| \[TITLE\]       | Track (song) Name, command line arameter \#6 passed by the ripper to MAREO                   |
| \[TRACK\]       | Track (song) Number, command line arameter \#7 passed by the ripper to MAREO                 |
| \[TRACKPADDED\] | \[TRACK\] padded with PaddingZeros                                                           |
| \[YEAR\]        | Year of the CD release, command line arameter \#8 passed by the ripper to MAREO              |
| \[GENRE\]       | CD’s Music Genre, command line arameter \#9 passed by the ripper to MAREO                    |
| \[1\] .. \[N\]  | Any parameter passed by the ripper to MAREO, after the genre.                                |

FOLDER \[PLACEHOLDERS\]
=======================

MAREO also recognizes some virtual folders, like "My Documents", so if your "My Documents" folders is actually at "c:\\document and settings\\username\\documents\\", you can reference it by using the \[MYDOCUMENTS\] \[PLACEHOLDER\].

You can use mareoSpecialFolders.exe, to test what MAREO detects.

The full list of virtual folders’ \[PLACEHOLDERS\] is:

|                      |                                                                                                                                                                                                        |
|----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| \[PLACEHOLDER\]      | VALUE                                                                                                                                                                                                  |
| \[APPDATA\]          | file system directory that serves as a common repository for application-specific data. A typical path is C:\\Documents and Settings\\username\\Application Data.                                      |
| \[CDBURN\_AREA\]     | file system directory acting as a staging area for files waiting to be written to CD. A typical path is C:\\Documents and Settings\\username\\Local Settings\\Application Data\\Microsoft\\CD Burning. |
| \[COMMON\_MUSIC\]    | file system directory that serves as a repository for music files common to all users. A typical path is C:\\Documents and Settings\\All Users\\Documents\\My Music.                                   |
| \[DESKTOP\]          | virtual folder representing the Windows desktop, the root of the namespace.                                                                                                                            |
| \[DESKTOPDIRECTORY\] | file system directory used to physically store file objects on the desktop (not to be confused with the desktop folder itself). A typical path is C:\\Documents and Settings\\username\\Desktop.       |
| \[LOCAL\_APPDATA\]   | file system directory that serves as a data repository for local (nonroaming) applications. A typical path is C:\\Documents and Settings\\username\\Local Settings\\Application Data.                  |
| \[MYDOCUMENTS\]      | virtual folder representing the My Documents desktop item.                                                                                                                                             |
| \[MYMUSIC\]          | file system directory that serves as a common repository for music files. A typical path is C:\\Documents and Settings\\User\\My Documents\\My Music.                                                  |
| \[MYPICTURES\]       | file system directory that serves as a common repository for image files. A typical path is C:\\Documents and Settings\\username\\My Documents\\My Pictures.                                           |
| \[MYVIDEO\]          | file system directory that serves as a common repository for video files. A typical path is C:\\Documents and Settings\\username\\My Documents\\My Videos.                                             |
| \[PERSONAL\]         | virtual folder representing the My Documents desktop item. This is equivalent to CSIDL\_MYDOCUMENTS.                                                                                                   |
| \[PHOTOALBUMS\]      | virtual folder used to store photo albums, typically username\\My Pictures\\Photo Albums. Windows Vista and later.                                                                                     |
| \[PLAYLISTS\]        | virtual folder used to store play albums, typically username\\My Music\\Playlists. Windows Vista and later.                                                                                            |
| \[PROFILE\]          | user’s profile folder. A typical path is C:\\Documents and Settings\\username.                                                                                                                         |
| \[PROGRAM\_FILES\]   | Program Files folder. A typical path is C:\\Program Files.                                                                                                                                             |
| \[PROGRAM\_COMMON\]  | A folder for components that are shared across applications. A typical path is C:\\Program Files\\Common.                                                                                              |
| \[PROGRAMS\]         | file system directory that contains the user’s program groups (which are themselves file system directories). A typical path is C:\\Documents and Settings\\username\\Start Menu\\Programs.            |
| \[SYSTEM\]           | Windows System folder. A typical path is C:\\Windows\\System32.                                                                                                                                        |
| \[WINDOWS\]          | Windows directory or SYSROOT. This corresponds to the %windir% or %SYSTEMROOT% environment variables. A typical path is C:\\Windows.                                                                   |

MAREO.INI
=========

MAREO’s configuration is defined on an INI file. An INI file, is like any TXT file created by notepad, but with .INI extension, instead than .TXT. Its basically a clean ASCII file.

MAREO reads the specified INI file (as the first command line parameter it receives, INIFILE), searching for instructions on what an how to do it.

I have included a fully configured, example INI file with MAREO’s package, called, you guessed it mareo.ini. I fully recommend that you now open that file with notepad, so you can better understand what I mean.

The INI file consists of comments, "general options", and "encoders orders".

Any line that starts with a ";" is considered a comment, and is ignored by MAREO. For example:

; MAREO - Multiple Applications Runner for EAC and Others - by Kwanbis - Releasen under the GPL
; this is a comment

MAREO.INI GENERAL SETTINGS.
===========================

There are four, at the moment, general options that affect how MAREO works, on the mareo.ini file. They should be at the top of the file, before any "encoder order":

; ————————————————————————————————————————————————————
; NUMBER OF ZEROS TO PAD THE TRACK NUMBER (0 to disable)
; ————————————————————————————————————————————————————
PaddingZeros = 2

; ————————————————————————————————————————————————————
; IS MAREO REQUIRED TO LOG TO THE SCREEN?
; ————————————————————————————————————————————————————
LogToScreen = TRUE

; ————————————————————————————————————————————————————
; IS MAREO REQUIRED TO LOG TO A TXT/LOG FILE?
; ————————————————————————————————————————————————————
LogToFile = TRUE

; ————————————————————————————————————————————————————
; IS MAREO REQUIRED TO DELETE THE WAV FILE AFTER ENCODING (TRUE) OR THE CD RIPPER DOES (FALSE)?
; ————————————————————————————————————————————————————
DeleteWavFile = FALSE

MAREO.INI ENCODER ORDERS
========================

For each encoder we want MAREO to execute, an "encoder order" must be defined.

This is done by defining 7 "Action Lines": EXECUTEIF,  FINALPATH,  FINALNAME,  EXTENSION,  ENCODEREXE,  PARAMETERS,  RENAME.

|             |                                                                                                                                                                                                                                                                                                                                     |
|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ACTION LINE | EXPLANATION                                                                                                                                                                                                                                                                                                                         |
| EXECUTEIF   | Posible values are:                                                                                                                                                                                                                                                                                                                 
               1. TRUE (always executes),                                                                                                                                                                                                                                                                                                           
               2. LASTTRACK it uses whats on the mareoLAST.INI and evaluates agains current track number,                                                                                                                                                                                                                                           
               3. XXX = YYY: in this last case MAREO evaluates the formula, and if true, it executes the encoder order.                                                                                                                                                                                                                             
               For example, EXECUTEIF = \[track\] = \[1\] Assuming that in \[1\] MAREO is getting the last track number from the ripper, and that it is for example, 12, and that the current track number is 4, MAREO would evaluate 4 = 12, which is false, and not execute. When track number is 12, MAREO would evaluate 12 = 12, and execute.  |
| FINALPATH   | the path to place the encoded file, example: C:\\Music\\\[artist\] - \[album\]                                                                                                                                                                                                                                                      |
| FINALNAME   | the name of the encoded file, example: \[track\]. \[title\]                                                                                                                                                                                                                                                                         |
| EXTENSION   | the extension of the encoded file, example: mp3                                                                                                                                                                                                                                                                                     |
| ENCODEREXE  | the full file name of the encoder executable (lame.exe), including, if not in the same folder as MAREO, the full path (c:\\encoders\\lame.exe).                                                                                                                                                                                     |
| PARAMETERS  | the command line parameters we would normally pass to the encoder, as if we where running it from a command prompt.                                                                                                                                                                                                                 |
| RENAME      | Posible values: TRUE or FALSE. if TRUE, MAREO would rename as per the FINALPATH, FINALNAME and EXTENSION options.                                                                                                                                                                                                                   |

EXTENSION, FINALPATH, FINALNAME, FINALFULLNAME, are loaded into the corresponding \[PLACEHOLDERS\] by MAREO.

|                   |                                                                                                          |
|-------------------|----------------------------------------------------------------------------------------------------------|
| \[EXTENSION\]     | file extension of the encoder without the dot (ex: MP3), as specified to MAREO on the INI, as EXTENSION. |
| \[FINALPATH\]     | destination final PATH as specified to MAREO on the INI, as PATH.                                        |
| \[FINALNAME\]     | destination final NAME as specified to MAREO on the INI, as FILENAME, with no extension.                 |
| \[FINALFULLNAME\] | destination final FINALPATH+FINALNAME+extension.                                                         |

MAREO.EXE IN ACTION
===================

Lets go back to our example where we where ripping Queen’s "Bohemian Rhapsody", and at the moment where the ripper just finished ripping the eleventh track, it calls MAREO to encode, by executing:

mareo.exe mareo.ini "c:\\temp\\track.wav" "c:\\temp\\track.flac" "Queen" "A Night At The Opera" "Bohemian Rhapsody" "11" 1975 "Rock"

MAREO starts, it loads each parameter into the specific \[PLACEHOLDER\], and then it opens mareo.ini. It skips the all the comments, till it gets to the first general option line:

\* PaddingZeros = 2
MAREO immediately creates a \[PLACEHOLDER\] called \[trackpadded\] by adding two zeros at the left of the track number, and then cuting the rightmost two characters. In this case, 11 becomes 11, as it is already a 2 chars string, but if \[track\] had been 4, \[trackpadded\] would have been 04.

It then reads general option line:
\* LogToScreen = TRUE
This line just tells MAREO that we want it to log to the screen.

It then reads general option line:
\* LogToFile = TRUE
This line just tells MAREO that we want it to log to a txt file, called mareo.log.

It then reads general option line:
\* DeleteWavFile = FALSE
This line tells MAREO when it finish with the encoder orders, we don’t want it to delete the original wav file.

Now MAREO has read the general options, and it continues to read the INI file, searching for encoder orders.

The first encoder order it finds, is:

; —————————————————————————————————————————
; FLAC ENCODER ORDER
; —————————————————————————————————————————
EXECUTEIF = TRUE
FINALPATH = \[PERSONAL\]\\Music\\\[artist\] - \[album\]\\
FINALNAME = \[track\]. \[title\]
EXTENSION = flac
ENCODEREXE = c:\\encoders\\flac.exe
PARAMETERS = -5 "\[source\]" -o "\[DESTTMP\]" -T artist="\[artist\]" -T album="\[album\]" -T title="\[title\]" -T tracknumber="\[track\]" -T date="\[year\]" -T genre="\[genre\]"
RENAME = FALSE

\* The first action line, EXECUTEIF = TRUE, is set to true, so it know it must execute this encoder order.
\* The second action line, FINALPATH = \[PERSONAL\]\\Music\\\[artist\] - \[album\]\\, is transformed by MAREO into "C:\\My Documents\\Music\\Queen - A Night At The Opera\\", and assigned to the \[FINALPATH\] \[PLACEHOLDER\].
\* The third action line, FINALNAME = \[track\]. \[title\], is transformed by MAREO into "11. Bohemian Rhapsody", and assigned to the \[FINALNAME\] \[PLACEHOLDER\].
\* The fourth action line, EXTENSION = flac, tells MAREO to assign "flac" to the \[EXTENSION\] \[PLACEHOLDER\].

MAREO then creates the \[FINALFULLNAME\] \[PLACEHOLDER\], which consists of \[FINALPATH\] + \\ + \[FINALNAME\] + . + \[EXTENSION\].
MAREO also creates the \[DESTTMPFULLNAME\] placeholder, which consists of \[DESTTMPPATH\] + \\ + \[DESTTMPNAME\] + . + \[EXTENSION\].

\* The fifth action line, tells MAREO the location and name of the encoder: "c:\\encoders\\flac.exe"
\* The sixth action line, tells MAREO the parameters we need to pass to the encoder. MAREO reads it, and replaces all the \[PLACEHOLDERS\], with the correct values, transforming it into:
-5 "c:\\temp\\track.wav" -o "c:\\temp\\track.flac" -T artist="Queen" -T album="A Night At The Opera" -T title="Bohemian Rhapsody" -T tracknumber="11" -T date="1975" -T genre="Rock"

\* Last action line, RENAME = FALSE, tells MAREO not to rename the resulting file, as it would be done by someone else, probably the ripper itself.

MAREO is now ready to execute the encoder order. It calls the encoder as:

c:\\encoders\\flac.exe -5 "c:\\temp\\track.wav" -o "c:\\temp\\track.flac" -T artist="Queen" -T album="A Night At The Opera" -T title="Bohemian Rhapsody" -T tracknumber="11" -T date="1975" -T genre="Rock"

Flac.exe runs, and it generates c:\\temp\\track.flac.

MAREO knows it must not rename the file, so it leaves it there, so the ripper can take care of it.

MAREO then reads the next encoder order:

; —————————————————————————————————————————
; OGG VORBIS ENCODER ORDER
; —————————————————————————————————————————
EXECUTEIF = TRUE
FINALPATH = \[PERSONAL\]\\Music\\\[artist\] - \[album\]\\
FINALNAME = \[track\]. \[title\]
EXTENSION = ogg
ENCODEREXE = c:\\encoders\\oggenc.exe
PARAMETERS = -q 4.25 "\[source\]" -o "\[DESTTMP\]" -a "\[artist\]" -l "\[album\]" -t "\[title\]" -N "\[track\]" -d "\[year\]" -G "\[genre\]"
RENAME = TRUE

EXECUTEIF is TRUE, so MAREO executes oggenc.exe, as:

c:\\encoders\\oggenc.exe -q 4.25 "c:\\temp\\track.wav" -o " c:\\temp\\track.ogg" -a "Queen" -l "A Night At The Opera" -t "Bohemian Rhapsody" -N 11 -d 1975 -G "Rock"

Oggenc.exe runs and generates c:\\temp\\track.ogg

MAREO know it must rename the file, to \[FINALFULLNAME\], and so it does.

PRE-PROCESSORS
==============

Pre-processors are programs that process a file, before the actual encoding occurs. The most common example being WaveGain. WaveGain is a tool that can take a wav file, and "normalize" the sound volume as defined by the user. This has the effect of having all the sound files at the same volume. With MAREO, we can make WaveGain normalize the wav files before doing the encodes. It is commonly set up as the first encoder order, so all the subsequent encodes start with a wav file already normalized.

To use WaveGain with MAREO then set the encoder order as:

; \*\*\* WAVEGAIN PRE-PROCESSING EXAMPLE \*\*\*
EXECUTEIF = TRUE
FINALPATH = NONE
FINALNAME = NONE
EXTENSION = NONE
ENCODEREXE = wavegain.exe
PARAMETERS = -radio -apply -noclip "\[source\]"
RENAME = FALSE

NOTICE the action line "RENAME = NONE". This tells MAREO not to rename the wav file to anything, in effect leaving the original and temporal wav file ready to be encoded.

Wavegain runs only in "TRACK MODE".

POST-PROCESSORS
===============

Post-Processors are programs that process a file after an encoding has occurred. The most common example is MP3Gain. Like Wavegain, MP3Gain is a tool that can take an mp3 file, and "normalize" the sound volume as defined by the user. This has the effect of having all the sound files at the same volume. But MP3Gain normalizes MP3 files, and no WAV files, so we must run it after the MP3 encode. MP3Gain should normally be set up as the next encoder before the MP3 one.

Assuming the mp3 file compression options was set as follows:

FINALPATH = C:\\Music\\\[artist\] - \[album\]\\
FINALNAME = \[track\]. \[title\]
EXTENSION = mp3

To use MP3Gain with MAREO then, set the encoder order after the MP3 has been generated as:

; \*\*\* MP3Gain POST-PROCESSING EXAMPLE \*\*\*
EXECUTEIF = TRUE
FINALPATH = C:\\Music\\\[artist\] - \[album\]\\
FINALNAME = \[track\]. \[title\]
EXTENSION = mp3
ENCODER = mp3gain.exe
PARAMETERS = /k /r /s r \[destfinalfullname\]
RENAME = FALSE

NOTICE the action line "RENAME = FALSE". This tells MAREO to not try to rename the MP3 file to anything, in effect leaving the MP3 file name as it was.

Why if renaming is not used, we still need to define PATH, FILENAME, EXTENSION? MAREO pre-process the PATH, FILENAME, and removes any non legal characters. So a original file name as "example: this is it" is transformed by MAREO to "example\_ this is it".

ALBUM MODE: RUNNING AFTER ALL THE TRACKS
========================================

There could be occasions where you would like to run a certain encoder (most likey a post-processor), after all the files have been processed. The most common situation, is to run MP3Gain in ALBUM mode.

Assuming the mp3 file compression options was set as follows:

FINALPATH = C:\\Music\\\[artist\] - \[album\]\\
FINALNAME = \[track\]. \[title\]
EXTENSION = mp3

To do run MP3Gain in album mode, you need to define an "encoder order" like this:

; \*\*\* MP3Gain POST-PROCESSING EXAMPLE \*\*\*
EXECUTEIF = LASTTRACK
FINALPATH = C:\\Music\\\[artist\] - \[album\]\\
FINALNAME = \[track\]. \[title\]
EXTENSION = mp3
ENCODER = mp3gain.exe
PARAMETERS = /k /a /s r \[finalpath**short**\]\\\*.mp3
RENAME = TRUE

Again, we still need to define PATH, FILENAME, EXTENSION because MAREO use them to create \[FINALPATH\].

But here you can see that we are using \[FINALPATH**SHORT**\] why and what is it?

\[FINALPATH**SHORT**\] is the DOS (no spaces) version of \[FINALPATH\], and is required because mp3gain does not works with paths with spaces.

\[LASTTRACK\]
=============

But how does MAREO knows when has the last file been ripped? There is an adittional utility called MAREOlast. If you run MAREOlast it would ask you how many tracks a CD has. You only need to imput a number, like 12, and press enter.

MAREOlast would then create a file, mareoLAST.INI, that MAREO reads to see how many tracks there are on an album. This value is loaded into the \[LASTTRACK\] placeholder.

MY RIPPER CAN PASS THE LAST TRACK NUMBER!
=========================================

There are rippers that know, and can pass, the number of tracks to MAREO. For example, EAC. So we need to pass MAREO the number of tracks this album has.

We would normally setup the ripper as: INIFILE SOURCE DESTTMP ARTIST ALBUM TITLE TRACK YEAR GENRE

But we would be adding the last track as the 10th parameter: INIFILE SOURCE DESTTMP ARTIST ALBUM TITLE TRACK YEAR GENRE TOTALTRACKS

For EAC, that would be: mareo.ini %s %d "%a" "%g" "%t" "%n" %y "%m" %x

%x in EAC means "TOTAL NUMBER OF TRACKS", so we are telling EAC to pass that number to MAREO, as the 10th parameter.

But how do we use it in MAREO? Instead of defining: EXECUTEIF = LASTTRACK define EXECUTEIF = \[1\] = \[TRACK\]

\[1\] is the \[PLACEHOLDER\] for the 10th command sent to MAREO (\[2\] for the 11th, etc).

At each run, MAREO would evaluate the formula, and when \[1\]’s value, matches the one of \[TRACK\], it would execute the encoder order.

MULTI FILE ENCODERS
===================

Multi-File Encoders are encoders that generate two or more files from a single WAV. The most common explanation for such a behavior, is what is called hybrid encoders. Hybrid encoders can produce a "lossy" file, and a "correction" file.

Basically, one can use the small lossy file to listen to the music, but if the need to recover the original file arises, these encoders can take the info on the lossy file, and with the info on the correction file, produce an exact copy of the original.

This is an alternative of having a lossless FLAC file for archival, and a lossy MP3 file for playing. The advantage of hybrid encoders, is that usually the lossy+correction files size equals the size of a lossless only file. The most common hybrid encoders are WavPack and OptimFrog. If we want to use MAREO with an encoder that generates 2 files (ore more), we need to create two encoder orders, one for each file:

; \*\* NORMAL FILE\*\*
EXECUTEIF = TRUE
FINALPATH = C:\\Music\\\[artist\] - \[album\]\\
FINALNAME = \[track\]. \[title\]
EXTENSION = ofs
ENCODER = ofs.exe
PARAMETERS = -correction "\[source\]"
RENAME = TRUE

; \*\* CORRECTION FILE (RENAME ONLY) \*\*
EXECUTEIF = TRUE
FINALPATH = C:\\Music\\\[artist\] - \[album\]\\
FINALNAME = \[track\]. \[title\]
EXTENSION = ofc
ENCODER = NONE
PARAMETERS = NONE
RENAME = TRUE

When MAREO encounters ENCODER = NONE it does not executes anything, and then renames the OFC file (created by ofs.exe on the previous encoder order) to the correct name.

This is it. Happy ripping!

FREQUENTLY ASKED QUESTIONS (FAQ)
================================

Q: What is an INI file?

A: An ini file is basically a TXT file that includes information on how a program should behave. Inside the mareo.zip you would see a file called mareo.INI. You can edit it with notepad, is the configuration file for MAREO.

Q: The fist encoded file is being deleted!

A: You are probably using EAC, and letting MAREO do all the renaming of files, which is ok, but confuses EAC. If you want MAREO to rename all the files, you must cheat EAC. EAC gets confused when MAREO ends and it can’t find the encoded file to rename, as MAREO has already renamed it, so out of confusion EAC deletes the file that has matching extension with the one defined in EAC’s config! So define the extension in EAC config to any one not being actually used, for example XXX. If you set the extension to XXX, EAC can’t find any matching file, and it goes ok.

Q: MAREO is not renaming the a file, why?

A: Change the Rename to TRUE (Rename = TRUE) in the INI file.

Q: When i tell EAC to not open external compressor, MAREO crashes.

A: Change LogToFile to FALSE (LogToFile = FALSE) in the INI file.

