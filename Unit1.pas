unit Unit1;

interface

uses
 Forms, DCPcrypt2, DCPsha512, Classes, DCPblockciphers, DCPrijndael,
  Controls, StdCtrls,  FileCtrl, Windows, SysUtils,Dialogs, INIFiles;

type
  TForm1 = class(TForm)
    DCP_rijndael1: TDCP_rijndael;
    DCP_sha5121: TDCP_sha512;
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    Memo2: TMemo;
    Button3: TButton;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  DirectorySelected:boolean;

implementation

uses ActiveX, ComObj, Variants, Math;

{$R *.dfm}

function GetModuleFileNameStr(Instance: THandle): string;
var
  buffer: array [0..MAX_PATH] of Char;
begin
  GetModuleFileName( Instance, buffer, MAX_PATH);
  Result := buffer;
end;

function GetHardwareString(LogMemo:TStrings):string;
var
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  i:integer;
  str,part,drive,tempStr:string;
  tstr1,tstr2,tstr3,tstr4,tstr5:string;

  function GetValueSafe(Value:Variant):string;
  begin
    if Value=NULL then result:=''
    else result:=String(Value);
  end;

begin
  result:='';
  tempStr:='';

  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer('', 'root\CIMV2', '', '');
  FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_Processor','WQL',0);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  LogMemo.Add('Processor info:');
  i:=0;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    tstr1:=GetValueSafe(FWbemObject.Name);
    tstr2:=GetValueSafe(FWbemObject.Caption);
    tstr3:=GetValueSafe(FWbemObject.Description);
    tstr4:=GetValueSafe(FWbemObject.Manufacturer);
    tstr5:=GetValueSafe(FWbemObject.ProcessorId);

    tempStr:=tempStr+tstr1+tstr2+tstr3+tstr4+tstr5;

    LogMemo.Add('Device #'+inttostr(i));
    LogMemo.Add('Name='+tstr1);
    LogMemo.Add('Caption='+tstr2);
    LogMemo.Add('Description='+tstr3);
    LogMemo.Add('Manufacturer='+tstr4);
    LogMemo.Add('ProcessorId='+tstr5);

    {Writeln(Format('Caption         %s',[String(FWbemObject.Caption)]));// String
    Writeln(Format('Description     %s',[String(FWbemObject.Description)]));// String
    Writeln(Format('Manufacturer    %s',[String(FWbemObject.Manufacturer)]));// String
    Writeln(Format('Name            %s',[String(FWbemObject.Name)]));// String
    Writeln(Format('ProcessorId     %s',[String(FWbemObject.ProcessorId)]));// String  }

    FWbemObject:=Unassigned;
    inc(i);
  end;

  LogMemo.Add('-------------------------------------------------');
  //FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  //FWMIService   := FSWbemLocator.ConnectServer('', 'root\CIMV2', '', '');
  FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_PhysicalMemory','WQL',0);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  LogMemo.Add('Memory info:');
  i:=0;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    tstr1:=GetValueSafe(FWbemObject.Name);
    tstr2:=GetValueSafe(FWbemObject.BankLabel);
    tstr3:=GetValueSafe(FWbemObject.DeviceLocator);
    tstr4:=GetValueSafe(FWbemObject.PartNumber);
    tstr5:=GetValueSafe(FWbemObject.SerialNumber);

    tempStr:=tempStr+{tstr1+}tstr2+tstr3+tstr4+tstr5;

    LogMemo.Add('Device #'+inttostr(i));
    LogMemo.Add('Name='+tstr1);
    LogMemo.Add('PartNumber='+tstr4);
    LogMemo.Add('SerialNumber='+tstr5);
    LogMemo.Add('DeviceLocator='+tstr3);
    LogMemo.Add('BankLabel='+tstr2);

    {Writeln(Format('BankLabel        %s',[String(FWbemObject.BankLabel)]));// String
    Writeln(Format('DeviceLocator    %s',[String(FWbemObject.DeviceLocator)]));// String
    Writeln(Format('Name             %s',[String(FWbemObject.Name)]));// String
    Writeln(Format('PartNumber       %s',[String(FWbemObject.PartNumber)]));// String
    Writeln(Format('SerialNumber     %s',[String(FWbemObject.SerialNumber)]));// String    }

    FWbemObject:=Unassigned;
    inc(i);
  end;

  LogMemo.Add('-------------------------------------------------');
  //FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  //FWMIService   := FSWbemLocator.ConnectServer('', 'root\CIMV2', '', '');
  FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_BIOS','WQL',0);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  LogMemo.Add('BIOS info:');
  i:=0;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    tstr1:=GetValueSafe(FWbemObject.Name);
    tstr2:=GetValueSafe(FWbemObject.Manufacturer);
    tstr3:=GetValueSafe(FWbemObject.SerialNumber);
    tstr4:=GetValueSafe(FWbemObject.Version);

    tempStr:=tempStr+tstr1+tstr2+tstr3+tstr4;

    LogMemo.Add('Device #'+inttostr(i));
    LogMemo.Add('Name='+tstr1);
    LogMemo.Add('Manufacturer='+tstr2);
    LogMemo.Add('SerialNumber='+tstr3);
    LogMemo.Add('Version='+tstr4);

    {Writeln(Format('Manufacturer    %s',[String(FWbemObject.Manufacturer)]));// Array of String
    Writeln(Format('Name            %s',[String(FWbemObject.Name)]));// Array of String
    Writeln(Format('SerialNumber    %s',[String(FWbemObject.SerialNumber)]));// String
    Writeln(Format('Version         %s',[String(FWbemObject.Version)]));// String }

    FWbemObject:=Unassigned;
    inc(i);
  end;

  LogMemo.Add('-------------------------------------------------');
  //FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  //FWMIService   := FSWbemLocator.ConnectServer('', 'root\CIMV2', '', '');
  FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_BaseBoard','WQL',0);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  LogMemo.Add('Motherboard info:');
  i:=0;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    tstr1:=GetValueSafe(FWbemObject.Name);
    tstr2:=GetValueSafe(FWbemObject.Manufacturer);
    tstr3:=GetValueSafe(FWbemObject.Product);

    tempStr:=tempStr+{tstr1+}tstr2+tstr3;

    LogMemo.Add('Device #'+inttostr(i));
    LogMemo.Add('Name='+tstr1);
    LogMemo.Add('Manufacturer='+tstr2);
    LogMemo.Add('Product='+tstr3);

    {Writeln(Format('Manufacturer    %s',[String(FWbemObject.Manufacturer)]));// String
    Writeln(Format('Name            %s',[String(FWbemObject.Name)]));// Array of String
    Writeln(Format('Product         %s',[String(FWbemObject.Product)]));// String}

    FWbemObject:=Unassigned;
    inc(i);
  end;

  LogMemo.Add('-------------------------------------------------');
  //определяем, к какому разделу относится диск C
  part:='';
  FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_LogicalDiskToPartition','WQL',0);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    str:=GetValueSafe(FWbemObject.Dependent);
    i:=pos('=',str);
    if i<>0 then
    begin
      delete(str,1,i);

      i:=pos('C:',str);
      if i<>0 then
      begin
        str:=GetValueSafe(FWbemObject.Antecedent);
        i:=pos('"',str);
        if i<>0 then
        begin
          delete(str,1,i);
          i:=pos('"',str);

          if i<>0 then
          begin
            part:=copy(str,1,i-1);

            FWbemObject:=Unassigned;
            break;
          end;
        end;
      end;
    end;

    FWbemObject:=Unassigned;
  end;

  LogMemo.Add('Disk C partition='+part);

  //определяем название физического диска для нужного раздела
  drive:='';
  FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_DiskDriveToDiskPartition','WQL',0);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    str:=GetValueSafe(FWbemObject.Dependent);
    i:=pos(part,str);
    if i<>0 then
    begin
      str:=GetValueSafe(FWbemObject.Antecedent);

      i:=pos('="',str);
      if i<>0 then
      begin
        delete(str,1,i+1);

        i:=pos('"',str);
        if i<>0 then
        begin
          drive:=copy(str,1,i-1);

          FWbemObject:=Unassigned;
          break;
        end;
      end;
    end;

    FWbemObject:=Unassigned;
  end;

  //удаляем двойные слешы
  i:=1;
  while i<length(drive) do
  begin
    if (drive[i]='\')and(drive[i+1]='\') then
    begin
      delete(drive,i+1,1);
    end;

    inc(i);
  end;

  LogMemo.Add('Disk C drive='+drive);

  LogMemo.Add('-------------------------------------------------');
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer('', 'root\CIMV2', '', '');
  FWbemObjectSet:= FWMIService.ExecQuery('SELECT * FROM Win32_DiskDrive','WQL',0);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  LogMemo.Add('HardDisk info:');
  i:=0;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    if FWbemObject.SerialNumber=NULL then
    begin
      FWbemObject:=Unassigned;
      continue;
    end;

    str:=GetValueSafe(FWbemObject.Name);
    if str=drive then
    begin
      tstr1:=GetValueSafe(FWbemObject.Name);
      tstr2:=GetValueSafe(FWbemObject.Model);
      tstr3:=GetValueSafe(FWbemObject.Caption);
      tstr4:=GetValueSafe(FWbemObject.SerialNumber);

      tempStr:=tempStr+tstr1+tstr2+tstr3+tstr4;

      LogMemo.Add('Device #'+inttostr(i));
      LogMemo.Add('Name='+tstr1);
      LogMemo.Add('Model='+tstr2);
      LogMemo.Add('Caption='+tstr3);
      LogMemo.Add('SerialNumber='+tstr4);
    end;

    {Writeln(Format('Model           %s',[String(FWbemObject.Model)]));// String
    Writeln(Format('Name            %s',[String(FWbemObject.Name)]));// String
    Writeln(Format('SerialNumber    %s',[String(FWbemObject.SerialNumber)]));// Array of String
    Writeln(Format('Caption                        %s',[String(FWbemObject.Caption)]));// String}

    FWbemObject:=Unassigned;
    inc(i);
  end;

  FWbemObjectSet:=Unassigned;
  FWMIService:=Unassigned;
  FSWbemLocator:=Unassigned;

  str:='';
  part:='';
  drive:='';

  result:=tempStr;
  tempStr:='';
end;

procedure EncryptDirectory(Directory:string; FileMask:string; SQLHost,SQLDatabase,SQLLogin,SQLPass,HardwareStr:string);
var inputFile:TFileStream;
tempBuffer:TMemoryStream;
CipherIV: array of byte;     // the initialisation vector (for chaining modes)
HashDigest, FileHash, FinalHashKey: array of byte;   // the result of hashing the passphrase with the salt
Salt: array of byte;         // a random salt to help prevent precomputated attacks
FileReadBuffer:array[0..16383] of byte;  //буфер для чтения файла для хеша
SaltLen:byte;
i,read,j:integer;
sr:TSearchRec;
FileAttr:integer;
ExPath:string;
FilePath:string;
str,str1:string;
begin
  inputFile:=nil;
  tempBuffer:=nil;
  FileAttr:=faAnyFile-faDirectory-faSymLink-faVolumeID;
  ExPath:=ExtractFilePath(Directory);
  setlength(CipherIV,form1.DCP_rijndael1.BlockSize div 8);
  setlength(HashDigest,form1.DCP_sha5121.HashSize div 8);
  setlength(FileHash,form1.DCP_sha5121.HashSize div 8);
  setlength(FinalHashKey,32);  //кол-во байт ключа шифрования
  randomize;

  try
    tempBuffer:=TMemoryStream.Create;

    if FindFirst(Directory+FileMask,FileAttr,sr)=0 then
    begin
      repeat
        if (sr.Attr and FileAttr) = sr.Attr then
        begin
          FilePath:=ExPath+sr.Name;  //узнаём полный путь к файлу
          SaltLen:=random(9)+7;  //определяем кол-во байтов для соли
          setlength(Salt,SaltLen+1);  //выделяем память под соль
          Salt[0]:=SaltLen;  //вписываем первым байтом кол-во байтов соли
          for i:=1 to length(Salt)-1 do
            Salt[i]:=random(256);     //заполняем соль рандомными цифрами
          for i:=0 to length(CipherIV)-1 do
            CipherIV[i]:=random(256);    //заполняем вектор инициализации рандомными цифрами

          form1.Memo1.Lines.Add('Working on file='+ExPath+sr.Name+'    SaltLength='+inttostr(length(Salt)));

          str1:='';
          for j:=0 to length(Salt)-1 do
            str1:=str1+inttohex(Salt[j],2);
          //form1.Memo1.Lines.Add('Salt='+str1);
          str1:='';
          for j:=0 to length(CipherIV)-1 do
            str1:=str1+inttohex(CipherIV[j],2);
          //form1.Memo1.Lines.Add('InitVector='+str1);

          //склеиваем ключ и делаем хеш
          form1.DCP_sha5121.Init;
          form1.DCP_sha5121.Update(Salt[0],sizeof(salt));
          str:=FilePath+SQLHost+SQLDatabase+SQLLogin+SQLPass+HardwareStr;
          //form1.Memo1.Lines.Add('PathStr='+str);
          form1.DCP_sha5121.UpdateStr(str);
          str:='';
          form1.DCP_sha5121.Final(HashDigest[0]);
          //преобразуем хеш, берем только четные
          for i:=0 to length(FinalHashKey)-1 do
            FinalHashKey[i]:=HashDigest[(i+1)*2-2];
          form1.DCP_sha5121.Burn;

          str1:='';
          for j:=0 to length(FinalHashKey)-1 do
            str1:=str1+inttohex(FinalHashKey[j],2);

          //form1.Memo1.Lines.Add('Key hash formed, keyhash='+str1);
          form1.Memo1.Lines.Add('Key hash formed');

          //инициализируем шифр и шифруем файл в поток
          inputFile:=TFileStream.Create(FilePath,fmOpenRead);
          form1.DCP_rijndael1.Init(FinalHashKey[0],min(form1.DCP_rijndael1.MaxKeySize,sizeof(FinalHashKey)*8),CipherIV);
          form1.DCP_rijndael1.CipherMode:=cmCBC;
          form1.DCP_rijndael1.EncryptStream(inputFile,tempBuffer,inputFile.Size);
          //очищаем ключи
          form1.DCP_rijndael1.Burn;
          for i:=0 to length(FinalHashKey)-1 do
            FinalHashKey[i]:=$FF;

          form1.Memo1.Lines.Add('File encrypted');

          //вычисляем хеш файла
          inputFile.Position:=0;
          form1.DCP_sha5121.Init;
          repeat
            read:=inputFile.Read(FileReadBuffer,sizeof(FileReadBuffer));
            form1.DCP_sha5121.Update(FileReadBuffer,read);
          until read<>sizeof(FileReadBuffer);
          form1.DCP_sha5121.Final(FileHash[0]);
          form1.DCP_sha5121.Burn;

          str:='';
          for i:=0 to length(FileHash)-1 do
            str:=str+inttohex(FileHash[i],2);
          form1.Memo1.Lines.Add('File hash formed, hash='+str);

          //закрываем файл и перезаписываем его
          inputFile.Free;
          inputFile:=TFileStream.Create(FilePath,fmCreate);
          inputFile.WriteBuffer(Salt[0],length(Salt));  //записываем вначале соль
          inputFile.WriteBuffer(CipherIV[0],length(CipherIV));  //записываем вектор инициализации
          inputFile.WriteBuffer(FileHash[0],length(FileHash));  //записываем хеш исходного файла для проверки правильного декодирования
          inputFile.CopyFrom(tempBuffer,0);  //записываем закодированный файл
          inputFile.Free;
          inputFile:=nil;

          form1.Memo1.Lines.Add('File rewritten');

          //очищаем поток
          tempBuffer.Clear;
        end;
      until FindNext(sr)<>0;
    end;  //if FindFirst(CypherDir+'*.wav',FileAttr,sr)=0 then
  except
    on e:exception do
    begin
      form1.Memo1.Lines.Add('Exception in encripting files with message='+e.Message);
      if inputFile<>nil then inputFile.Free;
      if tempBuffer<>nil then tempBuffer.Free;
      FindClose(sr);
      exit;
    end;
  end;

  setlength(Salt,0);
  setlength(CipherIV,0);
  setlength(HashDigest,0);
  setlength(FileHash,0);
  setlength(FinalHashKey,0);
  if inputFile<>nil then inputFile.Free;
  if tempBuffer<>nil then tempBuffer.Free;
  FindClose(sr);

  //ищем директории и идём по ним
  FileAttr:=faAnyFile-faSymLink-faVolumeID;
  if FindFirst(Directory+'*.*',FileAttr,sr)=0 then
  begin
    repeat
      if ((sr.Attr and FileAttr) = sr.Attr)and((sr.Attr and faDirectory)<>0)and(sr.Name<>'.')and(sr.Name<>'..') then
      begin
        //нашли директорию, вызываем процедуру ещё раз
        EncryptDirectory(ExPath+sr.Name+'\',FileMask,SQLHost,SQLDatabase,SQLLogin,SQLPass,HardwareStr);
      end;
    until FindNext(sr)<>0;
  end;
  FindClose(sr);
end;

procedure EncryptFile(FilePath:string; SQLHost,SQLDatabase,SQLLogin,SQLPass,HardwareStr:string);
var inputFile:TFileStream;
tempBuffer:TMemoryStream;
CipherIV: array of byte;     // the initialisation vector (for chaining modes)
HashDigest, FileHash, FinalHashKey: array of byte;   // the result of hashing the passphrase with the salt
Salt: array of byte;         // a random salt to help prevent precomputated attacks
FileReadBuffer:array[0..16383] of byte;  //буфер для чтения файла для хеша
SaltLen:byte;
i,read:integer;
FileAttr:integer;
str:string;
begin
  inputFile:=nil;
  tempBuffer:=nil;
  FileAttr:=faAnyFile-faDirectory-faSymLink-faVolumeID;
  setlength(CipherIV,form1.DCP_rijndael1.BlockSize div 8);
  setlength(HashDigest,form1.DCP_sha5121.HashSize div 8);
  setlength(FileHash,form1.DCP_sha5121.HashSize div 8);
  setlength(FinalHashKey,32);  //кол-во байт ключа шифрования
  randomize;

  try
    tempBuffer:=TMemoryStream.Create;

        begin
          //FilePath:=ExPath+sr.Name;  //узнаём полный путь к файлу
          SaltLen:=random(9)+7;  //определяем кол-во байтов для соли
          setlength(Salt,SaltLen+1);  //выделяем память под соль
          Salt[0]:=SaltLen;  //вписываем первым байтом кол-во байтов соли
          for i:=1 to length(Salt)-1 do
            Salt[i]:=random(256);     //заполняем соль рандомными цифрами
          for i:=0 to length(CipherIV)-1 do
            CipherIV[i]:=random(256);    //заполняем вектор инициализации рандомными цифрами

          form1.Memo1.Lines.Add('Working on file='+FilePath+'    SaltLength='+inttostr(length(Salt)));

          //склеиваем ключ и делаем хеш
          form1.DCP_sha5121.Init;
          form1.DCP_sha5121.Update(Salt[0],sizeof(salt));
          str:=FilePath+SQLHost+SQLDatabase+SQLLogin+SQLPass+HardwareStr;
          form1.DCP_sha5121.UpdateStr(str);
          str:='';
          form1.DCP_sha5121.Final(HashDigest[0]);
          //преобразуем хеш, берем только четные
          for i:=0 to length(FinalHashKey)-1 do
            FinalHashKey[i]:=HashDigest[(i+1)*2-2];
          form1.DCP_sha5121.Burn;

          form1.Memo1.Lines.Add('Key hash formed');

          //инициализируем шифр и шифруем файл в поток
          inputFile:=TFileStream.Create(FilePath,fmOpenRead);
          form1.DCP_rijndael1.Init(FinalHashKey[0],min(form1.DCP_rijndael1.MaxKeySize,sizeof(FinalHashKey)*8),CipherIV);
          form1.DCP_rijndael1.CipherMode:=cmCBC;
          form1.DCP_rijndael1.EncryptStream(inputFile,tempBuffer,inputFile.Size);
          //очищаем ключи
          form1.DCP_rijndael1.Burn;
          for i:=0 to length(FinalHashKey)-1 do
            FinalHashKey[i]:=$FF;

          form1.Memo1.Lines.Add('File encrypted');

          //вычисляем хеш файла
          inputFile.Position:=0;
          form1.DCP_sha5121.Init;
          repeat
            read:=inputFile.Read(FileReadBuffer,sizeof(FileReadBuffer));
            form1.DCP_sha5121.Update(FileReadBuffer,read);
          until read<>sizeof(FileReadBuffer);
          form1.DCP_sha5121.Final(FileHash[0]);
          form1.DCP_sha5121.Burn;

          str:='';
          for i:=0 to length(FileHash)-1 do
            str:=str+inttohex(FileHash[i],2);
          form1.Memo1.Lines.Add('File hash formed, hash='+str);

          //закрываем файл и перезаписываем его
          inputFile.Free;
          inputFile:=TFileStream.Create(FilePath,fmCreate);
          inputFile.WriteBuffer(Salt[0],length(Salt));  //записываем вначале соль
          inputFile.WriteBuffer(CipherIV[0],length(CipherIV));  //записываем вектор инициализации
          inputFile.WriteBuffer(FileHash[0],length(FileHash));  //записываем хеш исходного файла для проверки правильного декодирования
          inputFile.CopyFrom(tempBuffer,0);  //записываем закодированный файл
          inputFile.Free;
          inputFile:=nil;

          form1.Memo1.Lines.Add('File rewritten');

          //очищаем поток
          tempBuffer.Clear;
        end;
  except
    on e:exception do
    begin
      form1.Memo1.Lines.Add('Exception in encripting files with message='+e.Message);
      if inputFile<>nil then inputFile.Free;
      if tempBuffer<>nil then tempBuffer.Free;
      exit;
    end;
  end;

  setlength(Salt,0);
  setlength(CipherIV,0);
  setlength(HashDigest,0);
  setlength(FileHash,0);
  setlength(FinalHashKey,0);
  if inputFile<>nil then inputFile.Free;
  if tempBuffer<>nil then tempBuffer.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var str1:string;
begin
  str1:=GetCurrentDir;
  if SelectDirectory('Выбор папки для шифрования','',str1)=true then
  begin
    form1.Edit1.Text:=str1;
    DirectorySelected:=true;
    form1.Button2.Enabled:=true;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetCurrentDirectory(PChar(ExtractFilePath(GetModuleFileNameStr(0))));
  DirectorySelected:=false;
end;

procedure TForm1.Button2Click(Sender: TObject);
var IniPath,HardLogPath:string;
IniDir:string;
INIFile:TINIFile;
SQLHost,SQLDB,SQLUser,SQLPass,HardwareStr:string;
begin
  //очищаем основное поле
  form1.Memo1.Clear;

  //если по какой либо причине директория не выбрана, то выходим
  if DirectorySelected=false then
  begin
    application.MessageBox('Директория для хранения звуковых файлов не выбрана','Ошибка',mb_ok);
    exit;
  end;

  //ищем файл настроек программы автодиктора
  IniDir:=ExtractFilePath(GetModuleFileNameStr(0));
  IniPath:=IniDir+'WNKSystem_AutoDictor.ini';

  form1.Memo1.Lines.Add('Searching for settings file with path='+IniPath);

  if FileExists(IniPath)=false then
  begin
    application.MessageBox('Файл настроек программы не найден'+#10+#13+'Укажите расположение файла настроек','Ошибка',mb_ok);

    form1.OpenDialog1.InitialDir:=ExtractFilePath(IniPath);
    form1.OpenDialog1.Title:='Выберите файл настроек';
    form1.OpenDialog1.Options:=form1.OpenDialog1.Options - [ofAllowMultiSelect];
    //form1.OpenDialog1.Filter:='All Files (*.*)|*.*';
    if form1.OpenDialog1.Execute=false then exit
    else IniPath:=form1.OpenDialog1.FileName;
  end;

  //открываем и читаем настройки
  INIFile:=TINIFile.Create(IniPath);

  //проверяем нужные нам параметры
  if (INIFile.ValueExists('DB','HostName')=false)or
  (INIFile.ValueExists('DB','Database')=false)or
  (INIFile.ValueExists('DB','User')=false)or
  (INIFile.ValueExists('DB','Pass')=false) then
  begin
    application.MessageBox('В файле настроек отсутствуют нужные настройки','Ошибка',mb_ok);
    INIFile.Free;
    exit;
  end;

  form1.Memo1.Lines.Add('Settings file='+IniPath);

  //читаем параметры
  SQLHost:=INIFile.ReadString('DB','HostName','');
  SQLDB:=INIFile.ReadString('DB','Database','');
  SQLUser:=INIFile.ReadString('DB','User','');
  SQLPass:=INIFile.ReadString('DB','Pass','');

  INIFile.Free;

  form1.Memo1.Lines.Add('Settings readed');
  form1.Memo1.Lines.Add('Host='+SQLHost);
  form1.Memo1.Lines.Add('DB='+SQLDB);
  form1.Memo1.Lines.Add('User='+SQLUser);
  form1.Memo1.Lines.Add('Pass='+SQLPass);

  //формируем строку железа
  form1.Memo2.Clear;
  HardwareStr:=GetHardwareString(form1.Memo2.Lines);

  //шифруем
  EncryptDirectory(form1.Edit1.Text+'\','*.wav',SQLHost,SQLDB,SQLUser,SQLPass,HardwareStr);

  //проверяем и записываем лог железа в файл
  HardLogPath:=ExtractFilePath(IniPath)+'Hardware.nfo';
  form1.Memo1.Lines.Add('Hardware log file='+HardLogPath);
  if FileExists(HardLogPath) then
  begin
    application.MessageBox('Файл с характеристиками железа уже существует и будет ПЕРЕЗАПИСАН!!!'+#10+#13+'Сохраните этот файл перед закрытием данного окна, иначе он будет утерян','ВНИМАНИЕ',mb_OK);
  end;
  form1.Memo2.Lines.SaveToFile(HardLogPath);

  form1.Memo1.Lines.Add('DONE');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var ExeName,str,code:string;
handl:integer;
si:TStartupInfo;
pi:TProcessInformation;
begin
  //создаём батник
  ExeName:='"'+GetModuleFileNameStr(0)+'"';
  str:=ChangeFileExt(GetModuleFileNameStr(0),'.bat');

  handl:=FileCreate(str);

  code:=':repeat'+#13+#10+'del '+ExeName+#13+#10+'if Exist '+ExeName+' goto repeat'+#13+#10+'del "'+str+'"';

  ZeroMemory(@si,sizeof(si));
  ZeroMemory(@pi,sizeof(pi));
  si.cb:=sizeof(si);

  if handl<0 then exit;
  if FileSeek(handl,0,2)=-1 then exit;
  if FileWrite(handl,code[1],length(code))=-1 then exit;
  FileClose(handl);

  //CreateProcess(nil,PChar(str),nil,nil,false,0,@si,@pi);  

  CreateProcess(nil, PChar(str), nil, nil, false, 0, nil, nil, si, pi);
end;

procedure TForm1.Button3Click(Sender: TObject);
var IniPath,HardLogPath:string;
IniDir,str:string;
INIFile:TINIFile;
SQLHost,SQLDB,SQLUser,SQLPass,HardwareStr:string;
i:integer;
begin
  //очищаем основное поле
  form1.Memo1.Clear;

  //ищем файл настроек программы автодиктора
  IniDir:=ExtractFilePath(GetModuleFileNameStr(0));
  IniPath:=IniDir+'WNKSystem_AutoDictor.ini';

  form1.Memo1.Lines.Add('Searching for settings file with path='+IniPath);

  if FileExists(IniPath)=false then
  begin
    application.MessageBox('Файл настроек программы не найден'+#10+#13+'Укажите расположение файла настроек','Ошибка',mb_ok);

    form1.OpenDialog1.InitialDir:=ExtractFilePath(IniPath);
    form1.OpenDialog1.Title:='Выберите файл настроек';
    form1.OpenDialog1.Options:=form1.OpenDialog1.Options - [ofAllowMultiSelect];
    //form1.OpenDialog1.Filter:='All Files (*.*)|*.*';
    if form1.OpenDialog1.Execute=false then exit
    else IniPath:=form1.OpenDialog1.FileName;
  end;

  //выбераем файлы
  form1.OpenDialog1.InitialDir:=ExtractFilePath(IniPath);
  form1.OpenDialog1.Title:='Выберите файлы для шифрования';
  form1.OpenDialog1.Options:=form1.OpenDialog1.Options + [ofAllowMultiSelect];
  if form1.OpenDialog1.Execute=false then exit;

  //открываем и читаем настройки
  INIFile:=TINIFile.Create(IniPath);

  //проверяем нужные нам параметры
  if (INIFile.ValueExists('DB','HostName')=false)or
  (INIFile.ValueExists('DB','Database')=false)or
  (INIFile.ValueExists('DB','User')=false)or
  (INIFile.ValueExists('DB','Pass')=false) then
  begin
    application.MessageBox('В файле настроек отсутствуют нужные настройки','Ошибка',mb_ok);
    INIFile.Free;
    exit;
  end;

  form1.Memo1.Lines.Add('Settings file='+IniPath);

  //читаем параметры
  SQLHost:=INIFile.ReadString('DB','HostName','');
  SQLDB:=INIFile.ReadString('DB','Database','');
  SQLUser:=INIFile.ReadString('DB','User','');
  SQLPass:=INIFile.ReadString('DB','Pass','');

  INIFile.Free;

  form1.Memo1.Lines.Add('Settings readed');

  //формируем строку железа
  form1.Memo2.Clear;
  HardwareStr:=GetHardwareString(form1.Memo2.Lines);

  //шифруем
  for i:=0 to form1.OpenDialog1.Files.Count-1 do
  begin
    str:=form1.OpenDialog1.Files[i];
    EncryptFile(str,SQLHost,SQLDB,SQLUser,SQLPass,HardwareStr);
  end;

  //проверяем и записываем лог железа в файл
  HardLogPath:=ExtractFilePath(IniPath)+'Hardware.nfo';
  form1.Memo1.Lines.Add('Hardware log file='+HardLogPath);
  if FileExists(HardLogPath) then
  begin
    application.MessageBox('Файл с характеристиками железа уже существует и будет ПЕРЕЗАПИСАН!!!'+#10+#13+'Сохраните этот файл перед закрытием данного окна, иначе он будет утерян','ВНИМАНИЕ',mb_OK);
  end;
  form1.Memo2.Lines.SaveToFile(HardLogPath);

  form1.Memo1.Lines.Add('DONE');
end;

procedure TForm1.Button4Click(Sender: TObject);
var str:string;
begin
  str:=ChangeFileExt(GetModuleFileNameStr(0),'.log');

  form1.Memo1.Lines.SaveToFile(str);
end;

end.
