# -*- coding: utf-8 -*-
import argparse
import os
import random
import re

def sampiling(infile, hitsamples):
   dashpat = re.compile("^---")
   percentpat = re.compile(r'[(](.*?)[%]')
   sum=0.0
   c=0
   with open(infile, 'r') as inf:
      for i, line in enumerate(inf):
          search = dashpat.search(line)
          if (search is None):
             continue
          items = line.split(' ')
          if (len(items) > 4 and int(items[4]) > hitsamples):
             per = percentpat.findall(line)
             sum = sum + float(per[0])
             c = c + 1
   if (c != 0):
      print("{f}: {s}".format(f=infile, s=sum/c))

if __name__=="__main__":
   parser = argparse.ArgumentParser()
   parser.add_argument("-i", "--input", help="Specify the input the summary file")
   parser.add_argument("-t", "--threshold", type=int, default=1000, help="Sepcify the hot function sampling threshold, default is 1000")
   args = parser.parse_args()
   if args.input is None:
      print("No input directory")
   else:
      sampiling(args.input, args.threshold)
