#include "TestSerial.h"
#include "Timer.h"
#include "Flash.h"
#include "StorageVolumes.h"

configuration SenseAppC {
}
implementation {

	components SenseC, MainC, LedsC, new TimerMilliC();
	components SerialActiveMessageC as AM;
	components FlashC;
	components new BlockStorageC(BLOCK_VOLUME);

	SenseC.Boot->MainC;
	SenseC.Control->AM;
	SenseC.ReceiveData->AM.Receive[AM_CHUNK_MSG];
	SenseC.SendData->AM.AMSend[AM_CHUNK_MSG];
	SenseC.ReceiveStatus->AM.Receive[AM_STATUS_MSG];
	SenseC.SendStatus->AM.AMSend[AM_STATUS_MSG];
	SenseC.PacketAck->AM.PacketAcknowledgements;
	SenseC.Packet->AM;
	SenseC.Leds->LedsC;
	SenseC.Timer->TimerMilliC;
	SenseC.Flash->FlashC;
	FlashC.BlockRead->BlockStorageC.BlockRead;
	FlashC.BlockWrite->BlockStorageC.BlockWrite;

	components SerialPrintfC;

	components new SensirionSht11C() as TempSensor;

	SenseC.TempRead->TempSensor.Temperature;

	components new HamamatsuS1087ParC() as LightSensor;

	SenseC.LightRead->LightSensor;
}