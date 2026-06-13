(**************************************************************************
QuArK -- Quake Army Knife -- 3D game editor
Copyright (C) QuArK Development Team

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

https://quark.sourceforge.io/ - Contact information in AUTHORS.TXT
**************************************************************************)
unit HTTP;

{$INCLUDE DelphiCompat.inc}

interface

uses DelphiCompat, Windows, Classes;

//We can't use WinInet here, because that creates a load-time dependency on wininet.dll,
//which might not exist on Windows 95 RTM. So we're copy-pasting part from it,
//and dynamically loading wininet.dll instead.
type
  HINTERNET = Pointer;

type
  THTTPConnection = class
  private
    Online, Connected, UsingSSL, Requesting: Boolean;
    InetHandle, InetConnection, InetResource: HINTERNET;
  public
    function GoOnline: Boolean;
    procedure GoOffline;
    procedure ConnectTo(const HostName: string; const UseSSL: Boolean = False);
    procedure CloseConnect;
    procedure FileRequest(const FileName: string);
    function FileQueryInfo(Flag: DWORD; Default: Integer = 0): Integer;
    procedure CloseRequest;
    procedure ReadFile(FileData: TMemoryStream; DataStart, DataLength: cardinal);
    //Easy-to-use function:
    procedure GetFile(const FileName: string; FileData: TMemoryStream);
    destructor Destroy; override;
  end;

 {------------------------}

implementation

uses StrUtils, SysUtils, Logging, QkExceptions;

const
  StatusBufferLength : DWORD = 256;
  FileBufferLength : DWORD = 65536;

 {------------------------}

//Everything in this section is based on WinInet

const
  winetdll = 'wininet.dll';

  INTERNET_OPEN_TYPE_PRECONFIG = 0;
  {$EXTERNALSYM INTERNET_OPEN_TYPE_PRECONFIG}
  INTERNET_DEFAULT_HTTP_PORT = 80;
  {$EXTERNALSYM INTERNET_DEFAULT_HTTP_PORT}
  INTERNET_DEFAULT_HTTPS_PORT = 443;
  {$EXTERNALSYM INTERNET_DEFAULT_HTTPS_PORT}
  INTERNET_SERVICE_HTTP = 3;
  {$EXTERNALSYM INTERNET_SERVICE_HTTP}
  INTERNET_FLAG_RELOAD = $80000000;
  {$EXTERNALSYM INTERNET_FLAG_RELOAD}
  INTERNET_FLAG_NO_CACHE_WRITE = $04000000;
  {$EXTERNALSYM INTERNET_FLAG_NO_CACHE_WRITE}
  INTERNET_FLAG_SECURE = $00800000;
  {$EXTERNALSYM INTERNET_FLAG_SECURE}
  HTTP_QUERY_CONTENT_LENGTH = 5;
  {$EXTERNALSYM HTTP_QUERY_CONTENT_LENGTH}
  HTTP_QUERY_STATUS_CODE = 19;
  {$EXTERNALSYM HTTP_QUERY_STATUS_CODE}

type
  INTERNET_PORT = Word; 
  {$EXTERNALSYM INTERNET_PORT}

var
  HWinInet: HMODULE;

  InternetOpen: function (lpszAgent: LPCTSTR; dwAccessType: DWORD; lpszProxy, lpszProxyBypass: LPCTSTR; dwFlags: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM InternetOpen}
  InternetCloseHandle: function (hInet: HINTERNET): BOOL; stdcall;
  {$EXTERNALSYM InternetCloseHandle}
  InternetConnect: function (hInet: HINTERNET; lpszServerName: LPCTSTR; nServerPort: INTERNET_PORT; lpszUsername: LPCTSTR; lpszPassword: LPCTSTR; dwService: DWORD; dwFlags: DWORD; dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM InternetConnect}
  HttpOpenRequest: function(hConnect: HINTERNET; lpszVerb, lpszObjectName, lpszVersion, lpszReferrer: LPCTSTR; lplpszAcceptTypes: PLPCTSTR; dwFlags: DWORD; dwContext: DWORD): HINTERNET; stdcall;
  {$EXTERNALSYM HttpOpenRequest}
  HttpSendRequest: function(hRequest: HINTERNET; lpszHeaders: LPCTSTR; dwHeadersLength: DWORD; lpOptional: Pointer; dwOptionalLength: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpSendRequest}
  HttpQueryInfo: function(hRequest: HINTERNET; dwInfoLevel: DWORD; lpvBuffer: Pointer; var lpdwBufferLength: DWORD; var lpdwReserved: DWORD): BOOL; stdcall;
  {$EXTERNALSYM HttpQueryInfo}
  //InternetSetFilePointer: function(hFile: HINTERNET; lDistanceToMove: Longint; pReserved: Pointer; dwMoveMethod, dwContext: DWORD): DWORD; stdcall;
  InternetSetFilePointer: function(hFile: HINTERNET; lDistanceToMove: Longint; lpDistanceToMoveHigh: PLongint; dwMoveMethod, dwContext: DWORD_PTR): DWORD; stdcall;
  {$EXTERNALSYM InternetSetFilePointer}
  InternetReadFile: function(hFile: HINTERNET; lpBuffer: Pointer; dwNumberOfBytesToRead: DWORD; var lpdwNumberOfBytesRead: DWORD): BOOL; stdcall;
  {$EXTERNALSYM InternetReadFile}

function LoadWinInet: Boolean;
begin
  HWinInet := SafeLoadLibrary(winetdll);
  If HWinInet = 0 Then
  begin
    Result := False;
    Exit;
  end;
  @InternetOpen := GetProcAddress(HWinInet, {$IFDEF UNICODE}'InternetOpenW'{$ELSE}'InternetOpenA'{$ENDIF});
  If @InternetOpen = nil Then
  begin
    Result := False;
    Exit;
  end;
  @InternetCloseHandle := GetProcAddress(HWinInet, 'InternetCloseHandle');
  If @InternetCloseHandle = nil Then
  begin
    Result := False;
    Exit;
  end;
  @InternetConnect := GetProcAddress(HWinInet, {$IFDEF UNICODE}'InternetConnectW'{$ELSE}'InternetConnectA'{$ENDIF});
  If @InternetConnect = nil Then
  begin
    Result := False;
    Exit;
  end;
  @HttpOpenRequest := GetProcAddress(HWinInet, {$IFDEF UNICODE}'HttpOpenRequestW'{$ELSE}'HttpOpenRequestA'{$ENDIF});
  If @HttpOpenRequest = nil Then
  begin
    Result := False;
    Exit;
  end;
  @HttpSendRequest := GetProcAddress(HWinInet, {$IFDEF UNICODE}'HttpSendRequestW'{$ELSE}'HttpSendRequestA'{$ENDIF});
  If @HttpSendRequest = nil Then
  begin
    Result := False;
    Exit;
  end;
  @HttpQueryInfo := GetProcAddress(HWinInet, {$IFDEF UNICODE}'HttpQueryInfoW'{$ELSE}'HttpQueryInfoA'{$ENDIF});
  If @HttpQueryInfo = nil Then
  begin
    Result := False;
    Exit;
  end;
  @InternetSetFilePointer := GetProcAddress(HWinInet, 'InternetSetFilePointer');
  If @InternetSetFilePointer = nil Then
  begin
    Result := False;
    Exit;
  end;
  @InternetReadFile := GetProcAddress(HWinInet, 'InternetReadFile');
  If @InternetReadFile = nil Then
  begin
    Result := False;
    Exit;
  end;
  Result:=True;
end;

procedure UnloadWinInet;
begin
  @InternetReadFile := nil;
  @InternetSetFilePointer := nil;
  @HttpQueryInfo := nil;
  @HttpSendRequest := nil;
  @HttpOpenRequest := nil;
  @InternetConnect := nil;
  @InternetOpen := nil;
  @InternetCloseHandle := nil;
  FreeLibrary(HWinInet);
  HWinInet:=0;
end;

 {------------------------}

destructor THTTPConnection.Destroy;
begin
  if Online then
    GoOffline;

  inherited;
end;

function THTTPConnection.GoOnline: Boolean;
begin
  if Online then
    GoOffline;

  if HWinInet=0 then
    if not LoadWinInet then
    begin
      Result:=False;
      Exit;
    end;

  InetHandle:=InternetOpen(PChar('QuArK'), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if InetHandle=nil then
    LogAndRaiseLastOSError('Unable to open internet connection.');
  Online:=True;
  Result:=True;
end;

procedure THTTPConnection.GoOffline;
begin
  if not Online then
    Exit;

  if Connected then
    CloseConnect;
  if InternetCloseHandle(InetHandle)=false then
  begin
    LogWindowsError(GetLastError(), 'THTTPConnection.GoOffline: InternetCloseHandle failed!');
    //Exit;
  end;
  Online:=False;
  InetHandle:=nil;
end;

procedure THTTPConnection.ConnectTo(const HostName: string; const UseSSL: Boolean);
begin
  if not Online then
    raise exception.create('Not online.');
  if Connected then
    CloseConnect;

  if UseSSL then
    InetConnection:=InternetConnect(InetHandle, PChar(HostName), INTERNET_DEFAULT_HTTPS_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0)
  else
    InetConnection:=InternetConnect(InetHandle, PChar(HostName), INTERNET_DEFAULT_HTTP_PORT, nil, nil, INTERNET_SERVICE_HTTP, 0, 0);
  if InetConnection=nil then
    LogAndRaiseLastOSError('Unable to open internet connection.');
  Connected:=True;
  UsingSSL:=UseSSL;
end;

procedure THTTPConnection.CloseConnect;
begin
  if not Connected then
    Exit;

  if InternetCloseHandle(InetConnection)=false then
  begin
    LogWindowsError(GetLastError(), 'THTTPConnection.CloseConnect: InternetCloseHandle failed!');
    //Exit;
  end;
  Connected:=False;
  InetConnection:=nil;
end;

procedure THTTPConnection.FileRequest(const FileName: string);
begin
  if not Connected then
    raise exception.create('Not connected.');
  if Requesting then
    CloseRequest;

  //We might need to set this as accepted type: 'binary/octet-stream'
  if UsingSSL then
    InetResource:=HttpOpenRequest(InetConnection, PChar('GET'), PChar(FileName), nil, nil, nil, INTERNET_FLAG_RELOAD + INTERNET_FLAG_NO_CACHE_WRITE + INTERNET_FLAG_SECURE, 0)
  else
    InetResource:=HttpOpenRequest(InetConnection, PChar('GET'), PChar(FileName), nil, nil, nil, INTERNET_FLAG_RELOAD + INTERNET_FLAG_NO_CACHE_WRITE, 0);
  if InetResource=nil then
    LogAndRaiseLastOSError('Can not access file to download.');
  if HttpSendRequest(InetResource, nil, 0, nil, 0)=false then
    LogAndRaiseLastOSError('Can not access file to download.');
  Requesting:=True;
end;

procedure THTTPConnection.CloseRequest;
begin
  if not Requesting then
    Exit;

  if InternetCloseHandle(InetResource)=false then
  begin
    LogWindowsError(GetLastError(), 'THTTPConnection.CloseRequest: InternetCloseHandle failed!');
    //Exit;
  end;
  Requesting:=False;
  InetResource:=nil;
end;

function THTTPConnection.FileQueryInfo(Flag: DWORD; Default: Integer = 0): Integer;
var
  StatusBuffer: PByte;
  BufferLength: DWORD;
  HeaderIndex: DWORD;
begin
  if not Requesting then
    raise exception.create('Not requesting.');

  GetMem(StatusBuffer, StatusBufferLength);
  try
    HeaderIndex:=0;
    BufferLength:=StatusBufferLength;

    if HttpQueryInfo(InetResource, Flag, StatusBuffer, BufferLength, HeaderIndex)=false then
    begin
      LogWindowsError(GetLastError(), 'THTTPConnection.FileQueryInfo: HttpQueryInfo failed!');
      Result:=Default;
      Exit;
    end;

    //Truncate the buffer.
    ReallocMem(StatusBuffer, BufferLength + SizeOf(Char)); //Note: The returned byte count does not include the null-terminator.

    Result:=StrToIntDef(PChar(StatusBuffer), Default);
  finally
    FreeMem(StatusBuffer);
  end;
end;

procedure THTTPConnection.ReadFile(FileData: TMemoryStream; DataStart, DataLength: cardinal);
var
  Buffer: PByte;
  BufferLength: DWORD;
begin
  if not Requesting then
    raise exception.create('Not requesting.');

  if DataStart<>0 then
  begin
    if (InternetSetFilePointer(InetResource, DataStart, nil, FILE_BEGIN, 0) = INVALID_SET_FILE_POINTER) and (GetLastError() <> NO_ERROR) then
      LogAndRaiseLastOSError('Cannot download file. Data transfer failed.');
  end;

  FileData.Seek(0, soFromBeginning);
  FileData.SetSize(DataLength);

  GetMem(Buffer, FileBufferLength);
  try
    repeat
      if InternetReadFile(InetResource, Buffer, FileBufferLength, BufferLength)=false then
        LogAndRaiseLastOSError('Cannot download file. Data transfer failed.');
      if BufferLength>0 then
        FileData.WriteBuffer(Buffer^, BufferLength);
    until BufferLength=0;
  finally
    FreeMem(Buffer);
  end;
  if FileData.Position <> FileData.Size then
  begin
    Log(LOG_WARNING, 'THTTPConnection.ReadFile: FileData does NOT fill buffer completely!');
    Buffer:=AllocMem(FileData.Size - FileData.Position);
    try
      FileData.WriteBuffer(Buffer, FileData.Size - FileData.Position);
    finally
      FreeMem(Buffer);
    end;
  end;
end;

procedure THTTPConnection.GetFile(const FileName: string; FileData: TMemoryStream);
var
  StatusValue: Integer;
  ResourceSize: Cardinal;
begin
  if not Connected then
    raise exception.create('Cannot download file: not connected.');

  FileRequest(FileName);
  try
    StatusValue:=FileQueryInfo(HTTP_QUERY_STATUS_CODE, 200);
    if StatusValue<>200 then
    begin
      Log(LOG_WARNING, 'THTTPConnection.GetFile: Wrong HTTP status: %d!', [StatusValue]);
      //FIXME: Properly handle StatusValue!
      raise exception.create('Cannot download file: file info query failed.');
    end;

    //Retrieve the index-filesize...
    ResourceSize:=FileQueryInfo(HTTP_QUERY_CONTENT_LENGTH, 0);
    if ResourceSize=0 then
    begin
      //DanielPharos: This is not considered to be an error.
      //raise exception.create('Cannot download file: Filesize is zero.');
      Exit;
    end;

    ReadFile(FileData, 0, ResourceSize);
  finally
    CloseRequest;
  end;
end;

initialization
finalization
  UnloadWinInet();
end.
