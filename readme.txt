                              BOOT NAVIGATOR
                               Version 1.10

 ÄÄÄ LICENCE AGREEMENT ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

 THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 THE AUTHOR OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES.  

 This program can be DISTRIBUTED, SOLD or MODIFIED in ANY way WITHOUT any
 notification to the author.

 ÄÄÄ INTRODUCTION ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

 Boot Navigator (BN) is such a program which allows you boot operating system
 (OS) from any of your primary partitions. Currently supported partition types
 are:
    FAT12 (DOS)
    NTFS  (NT)
    FAT32 (Win9x)
    4F    (QNX)
    Ext2  (Linux)

 If you want to boot from any other partition just change code of BN because
 source code is distributed with program.

 BN works in such a way:
    Finds all known (mentioned above) partitions and displays them.
    User can choose (by pressing 1, 2 or other numeric key) from which
     partition to boot.
     WARNING: If user press key for which coresponding patition doesn't exist
     (for example 6, but you have only 2 partitions) BN behavior is
     unpredictable.
    If user do not choose within 6 seconds Boot Navigator boots OS form
     the first partition.

 ÄÄÄ SYSTEM REQUIREMENTS ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

    386 CPU
    ATA compatible hard disk

 ÄÄÄ HOW TO INSTALL ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

    If you are under Windows enter DOS mode.
    Run install.bat
    Copy files mbr.exe, mbr.old and restore.bat to your system diskette.
    Reboot your computer.
    If something goes wrong boot from system diskette and run restore.bat.

 ÄÄÄ HOW TO UNINSTALL ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

    If you are under Windows enter DOS mode.
    Run restore.bat

 ÄÄÄ IMPORTANT NOTE FOR DEVELOPERS ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

    Please note that Boot Navigator code size can not exceed 446 bytes.

 ÄÄÄ CHANGES FROM PREVIOUS VERSIONS ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

 Version 1.10
    BN can now be used with disks larger than 8 GB.
    Fixed possible cursor flickering.

 Version 1.02
    Clears keyboard buffer before booting OS.
    Puts corsor to new line before booting OS.

 Version 1.01
    Shows partition size.

 Version 1.00
    First working version.

 ÄÄÄ SUPPORT ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

 If you have any remarks, sugestions or questions write me.
 E-mail: juramyko@soften.ktu.lt

                                                            Mykolas Juraitis