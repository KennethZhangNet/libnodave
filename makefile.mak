#
# Makefile to build a Windows Version of LIBNODAVE using the free command line tools
# from Borland.
#
# type 'make' to build libnodave.dll and some statically linked test programs.
# type 'make dynamic' to make libnodave.dll and some dynamically linked test programs.
#
# The directory where the tools are:
#
BCCPATH=../bin
CC=$(BCCPATH)/bcc32
LL=$(BCCPATH)/ilink32

CFLAGS= -I..\include -c -DBCCWIN -DDAVE_LITTLE_ENDIAN

PROGRAMS=testMPI.exe testPPI.exe \
testPPI_IBH.exe testPPI_IBHload.exe testPPIload.exe \
testMPIload.exe testISO_TCP.exe testISO_TCPload.exe testIBH.exe testMPI_IBHload.exe  

DYNAMIC_PROGRAMS=testMPId.exe testPPId.exe testISO_TCPd.exe testIBHd.exe testPPI_IBHd.exe

LIBRARIES=libnodave.dll

all: $(PROGRAMS) $(LIBRARIES)

dynamic: $(DYNAMIC_PROGRAMS)

testISO_TCP.exe: nodave.obj openSocketw.obj testISO_TCP.obj
	$(LL) /r /Tpe /L..\lib ..\lib\c0x32 testISO_TCP.obj openSocketw.obj nodave.obj, testISO_TCP.exe,,CW32 IMPORT32	
testMPI.exe: setportw.obj nodave.obj testMPI.obj 
	$(LL) /r /Tpe /L..\lib ..\lib\c0x32 setportw.obj nodave.obj testMPI.obj, testMPI.exe,,CW32 IMPORT32 ws2_32
testIBH.exe: openSocketw.obj nodave.obj testIBH.obj 
	$(LL) /r /Tpe /L..\lib ..\lib\c0x32 openSocketw.obj nodave.obj testIBH.obj, testIBH.exe,,CW32 IMPORT32 ws2_32	
testIBHd.exe: libnodave.dll testIBH.obj 
	$(LL) /r /Tpe /L..\lib ..\lib\c0x32 testIBH.obj, testIBHd.exe,,CW32 IMPORT32 ws2_32 libnodave.lib	
testPPI_IBH.exe: openSocketw.obj nodave.obj testPPI_IBH.obj 
	$(LL) /r /Tpe /L..\lib ..\lib\c0x32 openSocketw.obj nodave.obj testPPI_IBH.obj, testPPI_IBH.exe,,CW32 IMPORT32 ws2_32	
testPPI_IBHd.exe: libnodave.dll testPPI_IBH.obj 
	$(LL) /r /Tpe /L..\lib ..\lib\c0x32 testPPI_IBH.obj, testPPI_IBHd.exe,,CW32 IMPORT32 ws2_32 libnodave.lib	
testMPId.exe: libnodave.dll testMPI.obj
	$(LL) /r /Tpe /L..\lib ..\lib\c0x32 testMPI.obj , testMPId.exe,,CW32 IMPORT32 ws2_32 libnodave.lib
testPPI.exe: testPPI.obj nodave.obj setportw.obj 
	$(LL) /r /Tpe /L..\lib ..\lib\c0x32 setportw.obj nodave.obj testPPI.obj, testPPI.exe,,CW32 IMPORT32
testPPId.exe: libnodave.dll testPPI.obj
	$(LL) /r /Tpe /L..\lib ..\lib\c0x32 testPPI.obj, testPPId.exe,,libnodave CW32 IMPORT32 ws2_32
testISO_TCPd.exe: libnodave.dll testISO_TCP.obj
	$(LL) /r /Tpe /L..\lib ..\lib\c0x32 testISO_TCP.obj, testISO_TCPd.exe,,CW32 IMPORT32 ws2_32 libnodave.lib
testPPIload.exe: nodave.obj setportw.obj testPPIload.obj 
	$(LL) /r /Tpe /L..\lib ..\lib\c0x32 setportw.obj nodave.obj testPPIload.obj, testPPIload.exe,,CW32 IMPORT32
testMPIload.exe: nodave.obj setportw.obj testMPIload.obj 
	$(LL) /r /Tpe /L..\lib ..\lib\c0x32 setportw.obj nodave.obj testMPIload.obj, testMPIload.exe,,CW32 IMPORT32
testISO_TCPload.exe: nodave.obj  openSocketw.obj testISO_TCPload.obj 
	$(LL) /r /Tpe /L..\lib ..\lib\c0x32 openSocketw.obj nodave.obj testISO_TCPload.obj, testISO_TCPload.exe,,CW32 IMPORT32	
testMPI_IBHload.exe: nodave.obj  openSocketw.obj testMPI_IBHload.obj 
	$(LL) /r /Tpe /L..\lib ..\lib\c0x32 openSocketw.obj nodave.obj testMPI_IBHload.obj, testMPI_IBHload.exe,,CW32 IMPORT32	
testPPI_IBHload.exe: nodave.obj  openSocketw.obj testPPI_IBHload.obj 
	$(LL) /r /Tpe /L..\lib ..\lib\c0x32 openSocketw.obj nodave.obj testPPI_IBHload.obj, testPPI_IBHload.exe,,CW32 IMPORT32	
libnodave.dll: nodave.obj setportw.obj openSocketw.obj
	$(LL) /v /C /Gn /w /Gk /r /Tpd /L..\lib ..\lib\c0d32 nodave setportw openSocketw , libnodave.dll,,IMPORT32 CW32
        $(BCCPATH)/implib libnodave.lib libnodave.dll
#
# delete all but the sources:
#
clean: 	
	del /f /q *.tds *.il? *.obj *.map *.lib *.dll *.exe *.exp
#
# delete all but what is needed for distribution:
#
distclean: 	
	del /f /q *.tds *.il? *.obj *.map

nodave.obj: nodave.c nodave.h
	$(CC) $(CFLAGS) -DDOEXPORT nodave.c
setportw.obj: setportw.c
	$(CC) $(CFLAGS) -DDOEXPORT setportw.c
openSocketw.obj: openSocketw.c
	$(CC) $(CFLAGS) -DDOEXPORT openSocketw.c
