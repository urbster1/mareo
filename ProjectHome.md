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

MAREO is an open source/GPL-licensed application developed using Borland’s Delphi, and is my (very) humble contribution to the excellent Hydrogenaudio community.

MAREO is very easy to set up. It consist of only 2 steps:

1. Configuring the CD Ripper to call MAREO (as if it where a command line encoder (CLI)),
2. and telling MAREO how do we want it to encode.