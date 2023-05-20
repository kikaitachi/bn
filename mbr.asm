; 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
;        PROGRAM: Boot Navigator
;        VERSION: 1.10
;         AUTHOR: Mykolas Juraitis
;   LEGAL STATUS: Freeware
; LAST EDIT DATE: 6 September, 2001
; 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

bits 16
org 7E00h

start:
  ; Set stack & segment registers
  xor       AX, AX
  mov       SS, AX
  mov       SI, 7C00h
  mov       SP, SI
  push      AX
  push      AX
  pop       ES
  pop       DS
  ; Copy self from 0000h:7C00h to 0000h:7E00h
  mov       DI, 7E00h
  mov       CX, 256
  rep       movsw
  jmp       copied + 512      ; Jump to copy
copied:
  mov       BP, intro
  call      print             ; Print 'Choose partition:'
  call      enumparts         ; Enumerate patitions to boot from (AL = 0)
  mov       BP, press
  call      print             ; Print "Press 1, 2, ..."
  int       1Ah               ; Get ticks in DX (AH = 0)
  mov       DI, DX            ; Remember ticks in DI
  mov       SI, time          ; Move time (seconds to wait) addess to SI
  mov       BP, user
  call      print             ; Print message for user
waituser:
  mov       AH, 0h
  int       1Ah               ; Get ticks in DX
  ; Test if passed 18 ticks (it is near 1 second)
  sub       DX, DI
  cmp       DX, 18
  jl        notpassed
  ; Decrease time left
  dec       byte [SI]
  ; Update saved ticks (increase by 18)
  add       DI, 18
  call      print             ; Print message for user
notpassed:
  ; Time out ?
  mov       AL, '1'           ; Emulate that pressed key '1'
  cmp       byte [SI], '0'
  je        finish
  ; If key pressed then exit
  mov       AH, 01h
  int       16h               ; Pressed key code in AL
  jz        waituser          ; Loop
  ; Clear keyboard buffer
  xor       AH, AH
  int       16h
finish:
  ; Load selected OS
  mov       byte [count + 3], '0'
  xor       EBX, EBX
  mov       [lba1], EBX
  call      enumparts
loados:
  mov       EBX, [SI + 8]
  mov       [lba1], EBX
  call      read
  ; WriteLn;
  mov       BP, newln
  call      print
  ; Give control to loaded OS
  jmp       start - 512

; 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; DESCRIPTION:
;   Prints Pascal type string.
; IN:
;   DS:BP - Address of string to print.
; CORRUPTED:
;   None
; 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

print:

  pusha
  mov       AH, 0Eh
  mov       SI, BP
  movzx     CX, byte [SI]
  inc       SI
symbolLoop:
  lodsb
  int       10h
  loop      symbolLoop
  popa
  ret

; 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; DESCRIPTION:
;   Prints decimal number.
; IN:
;   AX - Number to print.
; CORRUPTED:
;   AX, BX, DX
; 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

printnumber:

  or        AX, AX
  je        printed
  xor       DX, DX
  mov       BX, 10
  div       BX
  push      DX
  call      printnumber
  pop       AX
  add       AX, 0E30h         ; Remainder in AL, AH = 0E - write char
  int       10h
printed:
  ret

; 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; DESCRIPTION:
;   Reads sector from disk to memory at address 0000h:7C00h.
; CORRUPTED:
;   None
; 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

read:

  pusha
  mov       AH, 42h
  mov       DL, 80h
  mov       SI, size
  int       13h
  popa
  ret

; 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; DESCRIPTION:
;   Prints/Loads partitions.
; IN:
;   AL = 0 - print, else - load (AL = '1', '2', ...).
; CORRUPTED:
;   EDI, SI, CX
; 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

enumparts:

  mov       EDI, [lba1]             ; Save LBA
  mov       SI, 7C00h + 01BEh       ; Offset to partition table
  mov       CX, 4                   ; Partition table has maximum 4 entries
processentries:                     ; Loop through partition table
  pusha                             ; Save registers which can be destroyed in inner loop
  mov       [lba1], EDI             ; Restore LBA
  call      read                    ; Reread partiton table because it can be overwritten by recursive call (extended partition)
  mov       CX, knownPartCount      ; Number of known bootable partitions types
  mov       DI, knownPartitions     ; DI points to first known partition
processpartitions:                  ; Loop througn known partition types
  mov       BL, [DI]                ; Read partition type byte
  inc       DI                      ; Now DI point to partition name string
  cmp       [SI + 4], BL            ; Compare current partition type with known
  jne       nextpart
  ; Print partition index
  mov       BP, count               ; Offset to partition number in printed list
  inc       byte [BP + 3]           ; Increase found partitions count
  cmp       AL, [BP + 3]            ; If found partition which user want to load
  je        loados                  ; then load it
  cmp       AL, 0                   ; Need print partition
  jne       nextpartition           ; No printing
  call      print                   ; Print partition number in list
  ; Print partiton name
  mov       BP, DI
  call      print
  ; Print partition size
  push      AX
  ; Print ", "
  mov       BP, size1
  call      print
  ; Print size
  mov       EAX, [SI + 0Ch]
  shr       EAX, 11
  call      printnumber
  ; Print " MB"
  mov       BP, size2
  call      print
  pop       AX
nextpart:
  movzx     BX, byte [DI]
  add       DI, BX
  inc       DI
  loop      processpartitions
;  cmp       byte [SI + 4], 05h      ; Extended partition (05h, 0Fh) ?
;  je        extendedPart
;  cmp       byte [SI + 4], 0Fh
;  jne       nextpartition           ; Partition is unknown
  jmp       nextpartition           ; Partition is unknown
extendedPart:
  mov       EAX, [SI + 8]
  mov       [lba1], EAX             ; LBA of extended partition table
  call      enumparts               ; Analyze extended partition
nextpartition:
  popa
  add       SI, 10h
  loop      processentries
  ret

; 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴
; Data
; 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴

  CR equ 13
  LF equ 10

  ; Disk address packet
  size      db 10h
  reserved1 db 0
  blocks    db 1
  reserved2 db 0
  bufferOfs dw 7C00h
  bufferSeg dw 0
  lba1      dd 0
  lba2      dd 0

  count db 05,'  0. '
  intro db 21, CR, LF, 'Choose partition:', CR, LF
  press db 17, 'Press 1, 2, ...', CR, LF
  user  db 46, CR, 'If you don', 27h, 't choose in '
  time  db '6'
        db ' sec. boots first OS.'
  size1 db 02, ', '
  size2 db 05, ' MB', CR, LF
  newln db 02, CR, LF

  ; Supported partitions has folowing format:
  ;    Partition type (1 byte)
  ;    Partition name which is Pascal type string (1 byte length & data)

  knownPartCount equ 5

knownPartitions

  db 01h, 03, 'DOS'                 ; fat12
  db 07h, 02, 'NT'                  ; ntfs
  db 0Bh, 05, 'Win9x'               ; fat32
  db 4Fh, 03, 'QNX'                 ; QNX
  db 83h, 05, 'Linux'               ; ext2