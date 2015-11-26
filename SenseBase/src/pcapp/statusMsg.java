/**
 * This class is automatically generated by mig. DO NOT EDIT THIS FILE.
 * This class implements a Java interface to the 'statusMsg'
 * message type.
 */

public class statusMsg extends net.tinyos.message.Message {

    /** The default size of this message type in bytes. */
    public static final int DEFAULT_MESSAGE_SIZE = 3;

    /** The Active Message type associated with this message. */
    public static final int AM_TYPE = -1;

    /** Create a new statusMsg of size 3. */
    public statusMsg() {
        super(DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /** Create a new statusMsg of the given data_length. */
    public statusMsg(int data_length) {
        super(data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new statusMsg with the given data_length
     * and base offset.
     */
    public statusMsg(int data_length, int base_offset) {
        super(data_length, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new statusMsg using the given byte array
     * as backing store.
     */
    public statusMsg(byte[] data) {
        super(data);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new statusMsg using the given byte array
     * as backing store, with the given base offset.
     */
    public statusMsg(byte[] data, int base_offset) {
        super(data, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new statusMsg using the given byte array
     * as backing store, with the given base offset and data length.
     */
    public statusMsg(byte[] data, int base_offset, int data_length) {
        super(data, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new statusMsg embedded in the given message
     * at the given base offset.
     */
    public statusMsg(net.tinyos.message.Message msg, int base_offset) {
        super(msg, base_offset, DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new statusMsg embedded in the given message
     * at the given base offset and length.
     */
    public statusMsg(net.tinyos.message.Message msg, int base_offset, int data_length) {
        super(msg, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
    /* Return a String representation of this message. Includes the
     * message type name and the non-indexed field values.
     */
    public String toString() {
      String s = "Message <statusMsg> \n";
      try {
        s += "  [chunkNum=0x"+Long.toHexString(get_chunkNum())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [status=0x"+Long.toHexString(get_status())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      return s;
    }

    // Message-type-specific access methods appear below.

    /////////////////////////////////////////////////////////
    // Accessor methods for field: chunkNum
    //   Field type: int, unsigned
    //   Offset (bits): 0
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'chunkNum' is signed (false).
     */
    public static boolean isSigned_chunkNum() {
        return false;
    }

    /**
     * Return whether the field 'chunkNum' is an array (false).
     */
    public static boolean isArray_chunkNum() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'chunkNum'
     */
    public static int offset_chunkNum() {
        return (0 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'chunkNum'
     */
    public static int offsetBits_chunkNum() {
        return 0;
    }

    /**
     * Return the value (as a int) of the field 'chunkNum'
     */
    public int get_chunkNum() {
        return (int)getUIntBEElement(offsetBits_chunkNum(), 16);
    }

    /**
     * Set the value of the field 'chunkNum'
     */
    public void set_chunkNum(int value) {
        setUIntBEElement(offsetBits_chunkNum(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'chunkNum'
     */
    public static int size_chunkNum() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'chunkNum'
     */
    public static int sizeBits_chunkNum() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: status
    //   Field type: short, unsigned
    //   Offset (bits): 16
    //   Size (bits): 8
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'status' is signed (false).
     */
    public static boolean isSigned_status() {
        return false;
    }

    /**
     * Return whether the field 'status' is an array (false).
     */
    public static boolean isArray_status() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'status'
     */
    public static int offset_status() {
        return (16 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'status'
     */
    public static int offsetBits_status() {
        return 16;
    }

    /**
     * Return the value (as a short) of the field 'status'
     */
    public short get_status() {
        return (short)getUIntBEElement(offsetBits_status(), 8);
    }

    /**
     * Set the value of the field 'status'
     */
    public void set_status(short value) {
        setUIntBEElement(offsetBits_status(), 8, value);
    }

    /**
     * Return the size, in bytes, of the field 'status'
     */
    public static int size_status() {
        return (8 / 8);
    }

    /**
     * Return the size, in bits, of the field 'status'
     */
    public static int sizeBits_status() {
        return 8;
    }

}
