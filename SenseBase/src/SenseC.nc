#include "Timer.h"
#include <stdio.h>
#include <string.h>
#include "Flash.h"
#include "TestSerial.h"

module SenseC {
	uses {
		interface SplitControl as Control;
		interface Receive as ReceiveData;
		interface AMSend as SendData;
		interface Receive as ReceiveStatus;
		interface AMSend as SendStatus;
		interface Packet;
		interface PacketAcknowledgements as PacketAck;

		interface Boot;
		interface Leds;
		interface Timer<TMilli>;
		interface Read<uint16_t> as TempRead;
		interface Read<uint16_t> as LightRead;

		interface Flash;
	}
}
implementation {
	// sampling frequency in binary milliseconds
	#define SAMPLING_FREQUENCY 10000
	#define MAX_SAMPLES 72

	uint16_t centiGrade;
	uint16_t luminance;
	uint8_t data[4];
	uint8_t dataOut[4];
	uint16_t dataCnt = 0;
	uint16_t outCnt = 0;

	message_t packet;
	message_t chunk_pkt;
	message_t status_pkt;
	
	int sendIndex = 0;

	event void Boot.booted() {
		call Timer.startPeriodic(SAMPLING_FREQUENCY); // 5 minutes = 300000
		call Leds.led1On();
		call Flash.erase();
		//call Control.start();
	}

	event void Timer.fired() {
		call TempRead.read();

		call LightRead.read();
	}
	void sendStatusMessage(uint8_t status) {
		status_msg_t * statusMsg = (status_msg_t * ) call Packet.getPayload(
				&status_pkt, sizeof(status_msg_t));
		statusMsg->status = status;
		statusMsg->chunkNum  = sendIndex; 

		call PacketAck.noAck(&status_pkt);

		if(call SendStatus.send(AM_BROADCAST_ADDR, &status_pkt,
				sizeof(status_msg_t)) == SUCCESS) {
			// Transfer succeeded.
		}
	}

	void sendChunkMessage(uint8_t * source) {
		chunk_msg_t * chunkMsg = (chunk_msg_t * ) call Packet.getPayload(&chunk_pkt,
				sizeof(chunk_msg_t));
				/*dataOut[0] = 12;
				dataOut[1] = 34;
				dataOut[2] = 56;
				dataOut[3] = 78;*/
		memcpy(chunkMsg->chunk, source, 4);
		//memcpy(chunkMsg->chunk, dataOut, 4);
		//chunkMsg->chunk[0] = 12;
		//chunkMsg->chunk[1] = 34;
		//chunkMsg->chunk[2] = 56;
		//chunkMsg->chunk[3] = 78;
		
		chunkMsg->chunkNum  = sendIndex;
		
		call PacketAck.noAck(&chunk_pkt);

		if(call SendData.send(AM_BROADCAST_ADDR, &chunk_pkt, sizeof(chunk_msg_t)) == SUCCESS) {
			// Transfer succeeded.
		}
	}

	event void TempRead.readDone(error_t result, uint16_t val) {
		// TODO Auto-generated method stub
		if(result == SUCCESS) {
			centiGrade = (-39.60 + 0.01 * val);
			data[0] = (uint8_t) centiGrade >> 8;
			data[1] = (uint8_t) centiGrade >> 0;

			//printf("Current temp is: %d \r\n", centiGrade);
		}
		else {
			printf("Error reading from sensor! \r\n");
		}
	}

	event void LightRead.readDone(error_t result, uint16_t val) {
		if(result == SUCCESS) {
			luminance = 2.5 * (val / 4096.0) * 6250.0;
			data[2] = (uint8_t) luminance >> 8;
			data[3] = (uint8_t) luminance >> 0;
			call Flash.write(data, dataCnt);

			//printf("data contains: %d, %d, %d, %d \r\n", data[0], data[1], data[2],data[3]);
		}
		else {
			printf("Error reading from sensor! \r\n");
		}
	}

	event void Flash.writeDone(error_t result) {
		// TODO Auto-generated method stub
		dataCnt++;
		call Leds.led0Toggle();
		if(dataCnt == (MAX_SAMPLES) )
		{
			call Leds.led2On();
			call Timer.stop();
			call Control.start();
			//call Flash.read(dataOut,outCnt);
		}
	}

	event void Flash.readDone(error_t result) {
		sendChunkMessage(dataOut);
		/*printf("data contains: %d, %d, %d, %d \r\n", dataOut[0], dataOut[1], dataOut[2],dataOut[3]);
		outCnt++;
		if(outCnt < MAX_SAMPLES)
		{
			call Flash.read(dataOut,outCnt);
		}*/
	}

	event void Flash.eraseDone(error_t result) {
	}

	event void Control.startDone(error_t error) {
		// TODO Auto-generated method stub
	}
	event void Control.stopDone(error_t error) {
		// TODO
	}

	event void SendData.sendDone(message_t * msg, error_t error) {
		// TODO Auto-generated method stub
		if (&chunk_pkt == msg)
		{
			sendIndex++;
			
			if(sendIndex < MAX_SAMPLES)
			{
				call Flash.read(dataOut,sendIndex);
			}
			else
			{
				sendStatusMessage(TRANSFER_DONE);
			}
		}
	}

	event message_t * ReceiveData.receive(message_t * msg, void * payload,
			uint8_t len) {

		return msg;
	}

	event message_t * ReceiveStatus.receive(message_t * msg, void * payload,
			uint8_t len) {
		if(len != sizeof(status_msg_t)) {
			return msg;
		}
		else {
			status_msg_t* statusMsg = (status_msg_t*)payload;
			
			if(statusMsg->status == TRANSFER_TO_TELOS)
			{
				// TODO
			}
			else if (statusMsg->status == TRANSFER_OK)
			{
				// Transfer was ok
			}
			else if (statusMsg->status == TRANSFER_DONE)
			{
				// full transfer complete
			}
			else if (statusMsg->status == TRANSFER_FAIL)
			{
				// TODO
			}
			else if (statusMsg->status == TRANSFER_READY)
			{
			}
			else if (statusMsg->status == TRANSFER_FROM_TELOS)
			{
				sendIndex = 0;
				call Flash.read(dataOut, sendIndex);
			}
			else
			{
			}
			return msg;
		}
	}

	event void SendStatus.sendDone(message_t * msg, error_t error) {
		// TODO Auto-generated method stub
	}
}