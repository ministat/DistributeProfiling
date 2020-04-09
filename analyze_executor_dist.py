# -*- coding: utf-8 -*-
import argparse
import os
import random
import re

def parse_profiling(infile, threshold):
   dashpat = re.compile("^===")
   sum = 0
   top = 0
   slave_node = ""
   top_queue = ""
   with open(infile, 'r') as inf:
      for i, line in enumerate(inf):
          if (len(line.strip()) == 0):
             continue
          search = dashpat.search(line)
          if (search is not None):
             if (top > 0 and float(top) / float(sum) >= threshold):
                print("Slavenode: {s}, top executor: {ex}, count: {c}".format(s=slave_node, ex=top_queue, c=top))
             slave_node = line.strip()
             sum = 0
             top = 0
             top_queue = ""
          else:
             items = line.split(',')
             if (len(items) == 2):
                executor = int(items[1])
                if (executor > top):
                   top = executor
                   top_queue_items = items[0].split("@")
                   top_queue = top_queue_items[1]
                sum = sum + executor


if __name__=="__main__":
   parser = argparse.ArgumentParser()
   parser.add_argument("-i", "--input", help="Specify the input file")
   parser.add_argument("-t", "--threshold", type=float, default=0.5, help="Sepcify the executor density on the same slave node, default is 0.5")
   args = parser.parse_args()
   if args.input is None:
      print("No input directory or output directory")
   else:
      parse_profiling(args.input, args.threshold)
