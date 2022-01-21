import os
import csv
import sys
import json
import signal
import logging
from ordered_set import OrderedSet


class Json2CSV:
    def __init__(self):
        self.init_log()
        self.stop = False
        # Signalling initialization
        signal.signal(signal.SIGINT, self.gracefull_stop)
        signal.signal(signal.SIGTERM, self.gracefull_stop)

    def gracefull_stop(self, *args):
        self.logger.critical('Process aborted')
        self.stop = True
        exit(3)

    def init_log(self, COUNTER_SEGMENTATION=10000):
        # Logger initialization
        self.logger = logging.getLogger('Json2CSV')
        self.logger.setLevel(logging.DEBUG)

        formatter = logging.Formatter(
            '[%(asctime)s][%(levelname)s] %(message)s',
            datefmt='%a, %d %b %Y %H:%M:%S'
        )
        stream_handler = logging.StreamHandler(sys.stdout)
        stream_handler.setFormatter(formatter)

        self.logger.addHandler(stream_handler)
        self.COUNTER_SEGMENTATION = COUNTER_SEGMENTATION

        return True

    def check_file(self, worked_file):
        # Rebuild and check if path is valid
        script_dir = os.path.dirname(os.path.realpath(__file__))

        if os.path.isabs(worked_file):
            file = worked_file
        else:
            file = os.path.join(script_dir, worked_file)

        try:
            os.stat(file)
        except FileNotFoundError:
            self.logger.critical('Given argument is not a file')
            exit(3)

        return(file)

    def convert(self, file):
        file = self.check_file(worked_file=file)

        self.logger.info('Conversion start')
        self.logger.info('Processing {}'.format(os.path.basename(file)))

        with open(file, 'r') as fin, open(file + '.csv', 'w') as fout:
            # CSV header generator
            # Make sure that every column names for CSV writer are collected
            # CSV writer need header information as parameter
            # Actually CSV writer can ignore columns with headers not stated in the list
            # We just make sure not a single of data column is skipped
            #   because first JSON not reflecting the entire schema

            self.logger.info('Collecting top-level keys for CSV header')
            headers = []
            counter = 0

            for line in fin:
                content = json.loads(line)
                for key in content.keys():
                    # We only get the top key of the dict made by json.loads()
                    headers.append(key)

                # Distinct header list and order them with the original order
                headers = list(OrderedSet(headers))
                counter += 1

                if counter % self.COUNTER_SEGMENTATION == 0:
                    self.logger.info('{} rows processed so far...'.format(counter))

            self.logger.info('{} row(s) processed. CSV header info collected'.format(counter))
            header = headers

            # Rewind the I/O from the beginning of the file
            fin.seek(0)

            self.logger.info('Writing to CSV')

            # Set dialect to unix for universal use
            writer = csv.DictWriter(fout, header, dialect='unix')
            writer.writeheader()
            counter = 0

            for line in fin:
                content = json.loads(line)

                # Since we only
                for key in content.keys():
                    if isinstance(content[key], dict):
                        content[key] = json.dumps(content[key])
                writer.writerow(content)
                counter += 1

                if counter % self.COUNTER_SEGMENTATION == 0:
                    self.logger.info('{} rows processed so far...'.format(counter))

            self.logger.info('{} row(s) processed. Conversion successfull'.format(counter))
            self.stop = True


if __name__ == "__main__":
    if len(sys.argv) == 1:
        print('Please state the JSON file to be processed as argument')
        exit(3)

    converter = Json2CSV()
    converter.COUNTER_SEGMENTATION = 1000000
    while not converter.stop:
        converter.convert(sys.argv[1])
