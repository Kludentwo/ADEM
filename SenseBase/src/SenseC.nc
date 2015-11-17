#include "Timer.h"
#include <stdio.h>
#include <string.h>

module SenseC
{
	provides interface Sensing;
	uses {
		interface Boot;
		interface Leds;
		interface Timer<TMilli>;
		interface Read<uint16_t> as TempRead;
		interface Read<uint16_t> as LightRead;
	}
}
implementation
{
	// sampling frequency in binary milliseconds
	#define SAMPLING_FREQUENCY 5000
	
	uint16_t centiGrade;
	uint16_t luminance;
 
	event void Boot.booted() {
		call Timer.startPeriodic(SAMPLING_FREQUENCY); // 30 minutes = 1800000
		call Leds.led1On();
	}

	event void Timer.fired() 
	{
 		if(call TempRead.read() == SUCCESS)
 		{
 			call Leds.led2Toggle();
 		}
 		else
 		{
 			call Leds.led0Toggle();
 		}
 		if(call LightRead.read() == SUCCESS)
 		{
 			call Leds.led2Toggle();
 		}
 		else
 		{
 			call Leds.led0Toggle();	
 		}
	}

	event void TempRead.readDone(error_t result, uint16_t val){
		// TODO Auto-generated method stub
		if(result == SUCCESS)
		{
			centiGrade = (-39.60 + 0.01 * val);
	
			printf("Current temp is: %d \r\n", centiGrade);
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
	
			printf("Current light intensity is: %d \r\n", luminance);
		}
		else
		{
			printf("Error reading from sensor! \r\n");
		}
	}
}
