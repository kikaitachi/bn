program MBR;

const
  ReadOperation  = 2;
  WriteOperation = 3;

procedure AccessSector(var Buf; Drive, Head : Byte; SecCyl : Word;
  Count : Byte; Operation : Byte); assembler;
asm
  push DS
  mov  CX,4                    { Retry 3 times when failed (recommends BIOS) }
 @Read:
  push CX
  les  BX,Buf
  mov  DL,Drive
  mov  DH,Head
  mov  CX,SecCyl
  mov  AL,Count
  mov  AH,Operation
  int  13h
  pop  CX
  jnc  @Finish
  { Reset controller }
  mov  AH,0
  mov  DL,Drive
  int  13h
  loop @Read
 @Finish:
  pop  DS
end;

var
  F : file;
  Buffer : array[0..511] of Byte;

begin
  WriteLn;
  WriteLn('MBR Tool.  Version 1.00');
  WriteLn('Copyright (c) 2000 by Mykolas Juraitis.');
  if ParamCount <> 2
  then begin
    WriteLn('USAGE: option file');
    WriteLn('               ');
    WriteLn('          ³     ÀÄ File name to Read/Write');
    WriteLn('          ÀÄÄÄÄÄÄÄ /R, /r - Read MBR to file');
    WriteLn('                   /W, /w - Write file to MBR (file size MUST be =< 512B)');
  end
  else begin
    AccessSector(Buffer, 128, 0, 1, 1, ReadOperation);
    Assign(F, ParamStr(2));
    if (ParamStr(1) = '/R') or (ParamStr(1) = '/r')
    then begin
      ReWrite(F, 1);
      BlockWrite(F, Buffer, 512);
      Close(F);
    end
    else if (ParamStr(1) = '/W') or (ParamStr(1) = '/w')
    then begin
      Reset(F, 1);
      BlockRead(F, Buffer, FileSize(F));
      Close(F);
      AccessSector(Buffer, 128, 0, 1, 1, WriteOperation);
    end
    else
      WriteLn('ERROR: Invalid parameters.');
  end;
end.