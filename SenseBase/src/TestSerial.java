import java.io.IOException;
import net.tinyos.message.*;
import net.tinyos.packet.*;
import net.tinyos.util.*;
import java.io.*;


public class TestSerial implements MessageListener {

	private static final short TRANSFER_TO_TELOS = 1;
	private static final short TRANSFER_OK = 2;
	private static final short TRANSFER_FAIL = 3;
	private static final short TRANSFER_READY = 4;
	private static final short TRANSFER_FROM_TELOS = 5;
	private static final short TRANSFER_DONE = 6;
	
	private static final short DATAAMOUNT = 72;
	private static final short CHUNKWIDTH = 4;

	public static MoteIF moteIF;

	public static int currentChunk;

	public static int isReady = 0;
	public static short[][] data = new short[DATAAMOUNT][CHUNKWIDTH];

	public static statusMsg status = new statusMsg();
	public static chunkMsg payload = new chunkMsg();


	public TestSerial(MoteIF moteIF) {
		this.moteIF = moteIF;
		this.moteIF.registerListener(new chunkMsg(), this);
		this.moteIF.registerListener(new statusMsg(), this);
	}

	public void messageReceived(int to, Message message) {
		if(message.amType() == chunkMsg.AM_TYPE)
		{
			chunkMsg msg = (chunkMsg)message;
			//System.out.println(msg.toString());
			//System.out.println(msg.getElement_chunk(0) + "," + msg.getElement_chunk(1) + "," + msg.getElement_chunk(2) + "," + msg.getElement_chunk(3));
			short[] buf = msg.get_chunk();
			currentChunk = msg.get_chunkNum();
			data[currentChunk] = buf;
			/*data[currentChunk][0] = msg.getElement_chunk(0);
			data[currentChunk][1] = msg.getElement_chunk(1);
			data[currentChunk][2] = msg.getElement_chunk(2);
			data[currentChunk][3] = msg.getElement_chunk(3);*/
			System.out.println("Received chunk:" + currentChunk);
			System.out.println("Data was:" + data[currentChunk][0] + "," + data[currentChunk][1] + "," + data[currentChunk][2] + "," + data[currentChunk][3] + ",");
			//currentChunk++;
		}
		else if(message.amType() == statusMsg.AM_TYPE)
		{
			statusMsg msg = (statusMsg)message;
			
			if (msg.get_status() == TRANSFER_DONE)
			{
				System.out.println("Transfer is done. Writing to file");
				// reconstruct image
				File file = new File("data.txt");
				byte[] recData = new byte[DATAAMOUNT*CHUNKWIDTH];
				int cnt1 = 0;
				int cnt2 = 0;
				int cnt3 = 0;

				for (cnt1 = 0; cnt1 < DATAAMOUNT; cnt1++)
				{
					for(cnt2 = 0; cnt2 < CHUNKWIDTH; cnt2++)
					{
						recData[cnt3] = (byte)data[cnt1][cnt2];
						System.out.println("Data before casting:" + data[cnt1][cnt2]);
						System.out.println("Data in array is now:" + recData[cnt3]);
						cnt3++;
					}
				}
				try{
					FileOutputStream out = new FileOutputStream("/home/nicolai/data1.bin");
					try{
						out.write(recData);
						out.close();
						System.out.println("Data writing completed");
						System.exit(0);
					}
					catch(IOException exception){}
				}
				catch(FileNotFoundException exception){}

			}
		}
		else
		{
			System.out.println("unknown message");
		}
	}

	public static void main(String[] args) throws Exception {
		String source = null;
		source = "serial@/dev/ttyUSB0:telosb";
		PhoenixSource phoenix;
		if (source == null) {
			phoenix = BuildSource.makePhoenix(PrintStreamMessenger.err);
		}
		else {
			phoenix = BuildSource.makePhoenix(source, PrintStreamMessenger.err);
		}
		MoteIF mif = new MoteIF(phoenix);
		TestSerial serial = new TestSerial(mif);
				
		System.out.println("Requesting Data");
		status.set_status(TRANSFER_FROM_TELOS);
    	try{
		moteIF.send(0, status);
		}
		catch(IOException exception){System.out.println("exception thrown");}
	}
}
