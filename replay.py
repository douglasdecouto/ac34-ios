"""
Script to replay a dump (or trace) of AC34 streaming data over the
network.
"""

import argparse
from datetime import datetime
import socket
import sys
import time

import ac34

PORT = ac34.TEST_PORT

def main():
    parser = argparse.ArgumentParser(description="Replay AC34 stream onto standard out.")
    parser.add_argument('file', metavar='DUMP-FILE', type=str, nargs=1,
                        help='stream trace file')
    parser.add_argument('-p', '--port', metavar='PORT', type=int, default=PORT,
                        help='listen on this TCP port (%d)' % PORT)
    parser.add_argument('-s', '--speed', metavar='SPEED', default=1.0, type=float,
                        help='replay speed: 0 for no delays, 1.0 (default) for original speed, > 1.0 to slow down, < 1.0 to speed up.')
    parser.add_argument('--pace', metavar='SECS', default=None, type=float,
                        help='wait SECS between each package regardless of timestamps')
    parser.add_argument('-t', '--text', action='store_true', default=False,
                        help='print text summary of message instead of binary message data')
    parser.add_argument('-v', '--verbose', action='store_true', default=False,
                        help='Print verbose output to stderr')

    args = parser.parse_args()
    
    if args.speed < 0:
        print >>sys.stderr, "Replay speed must be >= 0"
        return -1

    if args.pace is not None and args.pace <= 0:
        print >>sys.stderr, "Replay pace must be > 0"
        return -1

    assert len(args.file) > 0

    verbose = args.verbose

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    sock.bind(('', args.port)) # host='' means accept connections on all interfaces

    print >>sys.stderr, "Listening on port %d" % args.port
    sock.listen(1)
    
    while True:
        infile = open(args.file[0]) 

        conn, addr = sock.accept()
        print >>sys.stderr, "Connection from %s:%d" % (addr[0], addr[1])

        # Assume that messages arrive ordered by timestamp, for a given
        # source... If different sources are muiltiplexed onto same stream
        # but they have different clocks, the different sources'
        # timestamps will be out of order relative to each other.
        #
        # Track timestamps by source id.
        first_timestamp = { }  # src id -> timestamp
        last_timestamp = { }   # src id -> timestamp
    
        first_msg_read_at = { } # src id -> real wall clock time
    
        n_bytes_hdr = 0
        n_bytes_body = 0
        n_msg = 0
    
        while infile:
            hdr = infile.read(ac34.HDR_LEN)
            if len(hdr) == 0:
                # End of file at a message boundary.  Not a problem!
                break
    
            if len(hdr) < ac34.HDR_LEN:
                print >>sys.stderr, "Incomplete header and out of data"
                break
    
            msg_type, timestamp, src_id, msg_len = ac34.parse_header(hdr)
            short_type_str, long_type_str, msg_func = ac34.get_msg_type_info(msg_type)
            if verbose:
                print >>sys.stderr, "%s type=%s ts=%s src=%d len=%d" % \
                    (datetime.now(), short_type_str, timestamp, src_id, msg_len)
            
            # Read body, _including_ trailing 4-byte CRC.
            body = infile.read(msg_len + 4)
            if len(body) < msg_len + 4:
                print >>sys.stderr, "ERROR: Incomplete body and out of data"
                break
    
            n_msg += 1
            n_bytes_hdr += len(hdr)
            n_bytes_body += len(body)
    
            if src_id not in first_timestamp:
                first_timestamp[src_id] = timestamp
                first_msg_read_at[src_id] = datetime.now()
            
            # Sometimes messages arrive out-of-order for a given sender.
            # In that case, don't update last timestamp as that would move
            # it 'backwards'.
            if src_id not in last_timestamp or \
                    (src_id in last_timestamp and last_timestamp[src_id] < timestamp):
                last_timestamp[src_id] = timestamp
               
            # Message delay from first message found in the stream,
            # multiplied by provided speed argument, in float seconds.
            desired_message_delay = (timestamp - first_timestamp[src_id]).total_seconds()
            desired_message_delay *= args.speed
            
            if verbose:
                print >>sys.stderr, "   %d last_ts=%s delay=%f" % \
                    (src_id, last_timestamp[src_id], desired_message_delay)
    
            def output_msg():
                if args.text:
                    conn.sendall("%d,%s,%d,%s,%d\n" % \
                                     (n_msg, timestamp, src_id, short_type_str, msg_len))
                         
                else:
                    conn.sendall(hdr)
                    conn.sendall(body)
    
            try:
                if args.pace:
                    # output at fixed pace interval
                    time.sleep(args.pace)
                    output_msg()
                else:
                    # output according to replay speed and timestamps
                    def elapsed():
                        return (datetime.now() - first_msg_read_at[src_id]).total_seconds()
                    while args.speed > 0 and (elapsed() < desired_message_delay):
                        time.sleep(0.2) # Sleep a bit so we don't burn too much CPU
                    output_msg()
            except IOError, ex:
                print >>sys.stderr, "ERROR sending data: %s" % ex
                break

        try:
            # May fail if other end killed connection abruptly.
            conn.shutdown(socket.SHUT_RDWR)
        except Exception, ex:
            print >>sys.stderr, "Couldn't shutdown connection properly: %s" % (ex)

        conn.close()
        
        print >>sys.stderr, "%d Messages" % n_msg
        print >>sys.stderr, "%d Header bytes (%.3f MB)" % (n_bytes_hdr, n_bytes_hdr / (1024.0*1024.0))
        print >>sys.stderr, "%d Body bytes (%.3f MB)" % (n_bytes_body, n_bytes_body / (1024.0*1024.0))
        print >>sys.stderr, "%d Total bytes (%.3f MB)" % (n_bytes_body+n_bytes_hdr, 
                                                          (n_bytes_hdr+n_bytes_body) / (1024.0*1024.0))
        
        for src_id in sorted(first_timestamp.keys()):
            print >>sys.stderr, "Source ID %d" % src_id
            if last_timestamp[src_id] > first_timestamp[src_id]:
                stream_duration = (last_timestamp[src_id] - first_timestamp[src_id])
                stream_secs = stream_duration.total_seconds()
                print >>sys.stderr, "   Total stream time %s (%.3f secs)" % (stream_duration, stream_secs)
                print >>sys.stderr, "   Effective bandwith %.3f Mbps" % \
                    ((n_bytes_hdr+n_bytes_body)*8.0/(1024.0*1024.0*stream_secs))
            else:
                print >>sys.stderr, "   n/a"


if __name__ == '__main__':
    main()
