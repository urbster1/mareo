unit uExecuteAndWait;

interface

function ExecuteAndWait(const CommandLine: string): cardinal;

implementation

uses WinTypes;

const ErrUINT = High(Cardinal);

function ExecuteAndWait(const CommandLine: string): cardinal;
var tSI : TStartupInfo; tPI : TProcessInformation; dwI : DWORD;
begin
 Result := ErrUINT;
 FillChar(tSI, sizeof(TStartupInfo), 0);
 tSI.cb := sizeof(TStartupInfo);
 if (CreateProcess(nil, pchar(CommandLine), nil, nil, False, 0, nil, nil, tSI, tPI)) then begin
   dwI := WaitForSingleObject(tPI.hProcess, INFINITE);
   if (dwI = WAIT_OBJECT_0) then
     if (GetExitCodeProcess(tPI.hProcess, dwI)) then
       Result := dwI;
   CloseHandle(tPI.hProcess);
   CloseHandle(tPI.hThread);
 end;
end;

end.
 