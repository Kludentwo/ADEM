#include "Timer.h"
#include <stdio.h>
#include <string.h>
#include "Flash.h"
#include "TestSerial.h"

module SenseC
{
	provides interface Sensing;
	uses {
		interface Boot;
		interface Leds;
		interface Timer<TMilli>;
		interface Read<uint16_t> as TempRead;
		interface Read<uint16_t> as LightRead;
		//interface Packet;
		interface Flash;
	}
}
implementation
{
	// sampling frequency in binary milliseconds
	#define SAMPLING_FREQUENCY 10000
	
	uint16_t centiGrade;
	uint16_t luminance;
	uint8_t data[4];
	uint8_t dataOut[4];
	uint16_t dataCnt = 0;
	uint16_t outCnt = 0;
	//chunk_msg_t* dataBuf = (chunk_msg_t*) call Packet.getPayload(&chunk_pkt, sizeof(chunk_msg_t));
	
 
	event void Boot.booted() {
		call Timer.startPeriodic(SAMPLING_FREQUENCY); // 30 minutes = 1800000
		call Leds.led1On();
	}

	event void Timer.fired() 
	{
 		call TempRead.read();
 		
 		call LightRead.read();
	}

	event void TempRead.readDone(error_t result, uint16_t val){
		// TODO Auto-generated method stub
		if(result == SUCCESS)
		{
			centiGrade = (-39.60 + 0.01 * val);
			data[0] = (uint8_t)centiGrade >> 8;
			data[1] = (uint8_t)centiGrade >> 0;
			
	
			//printf("Current temp is: %d \r\n", centiGrade);
		}
		else
		{
			printf("Error reading from sensor! \r\n");
		}
	}

	event void LightRead.readDone(error_t result, uint16_t val){
		// TODO Auto-generated method stub
		if(result == SUCCESS)
		{
			luminance = 2.5 * (val / 4096.0) * 6250.0;
			data[2] = (uint8_t)luminance >> 8;
			data[3] = (uint8_t)luminance >> 0;
			dataCnt++;
			
			//memcpy(dataBuf->chunk,data,4);
			
			call Flash.erase();
	
			//printf("Current light intensity is: %d \r\n", luminance);
			printf("data contains: %d, %d, %d, %d \r\n", data[0], data[1], data[2], data[3]);
			//printf("dataBuf contains: %d, %d, %d, %d \r\n", dataBuf->chunk[0], dataBuf->chunk[1], dataBuf->chunk[2], dataBuf->chunk[3]);
			
			
		}
		else
		{
			printf("Error reading from sensor! \r\n");
		}
	}

	event void Flash.writeDone(error_t result){
		// TODO Auto-generated method stub
		outCnt++;
		call Flash.read(dataOut, outCnt);
	}

	event void Flash.readDone(error_t result){
		// TODO Auto-generated method stub
		uint16_t Outtemperature = 0;
		uint16_t Outluminance = 0;
		printf("dataOut contains: %d, %d, %d, %d \r\n", dataOut[0], dataOut[1], dataOut[2], dataOut[3]);
		
		
		Outtemperature = (dataOut[0] << 8) + dataOut[1];
		Outluminance = (dataOut[2] << 8) + dataOut[3];
		printf("Current light intensity is: %d and temperature is: %d \r\n", Outluminance, Outtemperature);
	}
	
	event void Flash.eraseDone(error_t result)
	{
		call Flash.write(data, dataCnt);
	}
}
