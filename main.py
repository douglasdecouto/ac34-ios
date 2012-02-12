import binascii  # compute_crc() calls the crc32 function
from datetime import datetime
import socket



HOST      = "127.0.01"
#HOST      = "157.125.69.155"
LIVE_PORT = 4940
TEST_PORT = 4941 

# Header sync byte magic numbers
SYNC1 = 0x47
SYNC2 = 0x83

def bytes_to_num(buf):
    """ 
    Convert multibyte buffer into an integer value.  Bytes must be in
    little-endian order.  This function pays no attention to overflow,
    etc.

    :param buf: bytes to convert.
    :returns: integer value.
    """
    val = 0
    for i in range(len(buf) - 1, -1, -1):
        val = val*256 + ord(buf[i])
    return val

def compute_crc(buf, crc_so_far=0):
    """
    :param buf: bytes to compute CRC over.

    :param crc_so_far: value of CRC of bytes seen so far.  To compute
    the CRC over multiple buffers, pass the previous buffer's CRC as
    *crc_so_far*.  Use 0 (defult) for the first time.

    :returns: CRC value.
    """
    return binascii.crc32(buf, crc_so_far) & 0xFFffFFff



# Message action functions.  They can raise MessageException if there
# was an error handling the message.  

class MessageException(Exception):
    pass

# To be used for shared/global data and state.
DATA = { }


def msg_nop(body):
    return

def msg_heartbeat(body):
    if len(body) != 4:
        raise MessageException("Heartbeat message too short")
    heartbeat = bytes_to_num(body)
    print "Heartbeat", heartbeat
    if 'last_heartbeat' not in DATA:
        DATA['last_heartbeat'] = heartbeat
    else:
        last_hb = DATA['last_heartbeat']
        delta_hb = heartbeat - last_hb
        if delta_hb != 1:
            raise MessageException("Skipped %d heartbeats (this %d, last %d)" % \
                                       (delta_hb - 1, heartbeat, last_hb))

def msg_race_status(body):
    pass

CHATTER_TYPES = {
    1: "Yacht Message",
    2: "Umpire Message",
    3: "Race Officer Message",
    4: "Commentary",
    5: "Machine-Generated Message",
}

def msg_chatter(body):
    if len(body) < 3:
        raise MessageException("Incomplete header in chatter message")
    msg_version = ord(body[0])
    msg_type = ord(body[1])
    msg_type_str = CHATTER_TYPES.get(msg_type, "Unknown Message Type")
    msg_len = ord(body[2])
    if len(body) != msg_len + 3:
        raise MessageException("Too few bytes in chatter message")
    
    ## Docs say chatter text is null-terminated but that's not true
    ## for the supplied test data.
    # last_char = body[-1]
    # if ord(last_char) != 0:
    #     msg = "Bad terminator, expected 0 but got 0x%x ('%s')" % (ord(last_char), last_char)
    #     raise MessageException(msg)

    print "Chatter [%s]: '%s'" % (msg_type_str, body[4:])


def msg_display_text(body):
    if len(body) < 4:
        raise MessageException("Incomplete header in display text message")
    msg_version = ord(body[0])
    ack_number = bytes_to_num(body[1:3])
    num_lines = ord(body[3])
    line_offset = 4
    for line_idx in range(num_lines):
        if len(body) < line_offset + 2:
            raise MessageException("Incomplete message header in display text message, line index %d" % line_idx)
        line_num = ord(body[line_offset])
        text_len = ord(body[line_offset + 1])
        if len(body) < line_offset + 2 + text_len:
            raise MessageException("Incomplete message data in display text message, line index %d, line number %d" % (line_idx, line_num))
        msg_text = body[line_offset+2:line_offset+2+text_len]
        print "Display Text [%02d] '%s'" % (line_num, msg_text)

    # XXX Handle special line numbers for committee boat displays and
    # penalty line (15, 100-103) and special text values for these
    # lines.
                       


# Message types. Dict of:
#    type code -> tuple of (short name, long name, handler function)
MESSAGE_TYPES = {
    1:  ("MT_HEARTBEAT", "Heartbeat", msg_heartbeat),
    12: ("MT_RACE_START_STATUS", "Race Status", msg_race_status),
    20: ("MT_DISPLAY_TEXT", "Display Text Message", msg_display_text),
    26: ("MT_XML_MESSAGE", "XML Message", msg_nop),
    27: ("MT_RACE_START_STATUS", "Race Start Status", msg_nop),
    29: ("MT_YACHT_EVENT", "Yacht Event Code", msg_nop),
    31: ("MT_YACHT_ACTION", "Yacht Action Code", msg_nop),
    36: ("MT_CHATTER_TEXT", "Chatter Text", msg_chatter),
    37: ("MT_BOAT_LOCATION", "Boat Location", msg_nop),
    38: ("MT_MARK_ROUNDING", "Mark Rounding", msg_nop),
}




def main():

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((HOST, TEST_PORT))

    while s:
        # Read and parse the header.  Multi-byte values are in
        # little-endian byte-order.
        hdr = s.recv(15)

        # Check sync bytes.  We should never be out of sync as we are
        # reading this data over TCP.  If we wanted to be really
        # paranoid, we would scan the input stream until we found the
        # sync bytes indicating the start of the message.
        if ord(hdr[0]) != SYNC1 or ord(hdr[1]) != SYNC2:
            raise Exception("Bad sync bytes 0x%x 0x%x" % (ord(hdr[0]), ord(hdr[1])))

        msg_type = ord(hdr[2])

        # Read timestamp, which is 6 byes indicating ms since 1 Jan
        # 1970 (conveniently same as UNIX/Python 'epoch').
        timestamp_ms = bytes_to_num(hdr[3:9])
        timestamp = datetime.fromtimestamp(timestamp_ms/1000.0)

        source_id = bytes_to_num(hdr[9:13])
        
        # Length of body of message
        msg_len = bytes_to_num(hdr[13:15])

        short_type_str, long_type_str, msg_func = \
            MESSAGE_TYPES.get(msg_type, ("UNKNOWN", "Unknown Message Type", msg_nop))
        # print "TYPE", long_type_str
        # print "TS", timestamp
        # print "SRC", source_id
        # print "LEN", msg_len

        # print "%s,%s" % (timestamp, long_type_str)

        body = s.recv(msg_len)
        actual_crc = compute_crc(hdr)
        actual_crc = compute_crc(body, actual_crc)

        crc_buf = s.recv(4)
        intended_crc = bytes_to_num(crc_buf)
        
        if actual_crc != intended_crc:
            raise Exception("Bad CRC value")

        try:
            msg_func(body)
        except MessageException, ex:
            print "ERROR handling message:", str(ex)

if __name__ == '__main__':
    main()
