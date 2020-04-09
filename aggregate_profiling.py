# -*- coding: utf-8 -*-
import argparse
import os
import random
import re

def gen_filename(firstline):
   nodot = firstline.strip()[::-1].replace('.','')
   nodollar_nodot = nodot.replace('$', '')
   noq = nodollar_nodot.replace('?', '')
   nodot_noslash = noq.replace('/', '')
   nobracket_nodot_noslash = nodot_noslash.replace('[', '')
   nobracket2_nodot_noslash = nobracket_nodot_noslash.replace(']', '')
   return nobracket2_nodot_noslash.replace(' ', '')

def parse_profiling(indir, outdir, threshold):
   if not os.path.exists(outdir):
      os.makedirs(outdir)
   dashpat = re.compile("^---")
   percentpat = re.compile(r'[(](.*?)[%]')
   for subdir, dirs, files in os.walk(indir):
       for file in files:
           infile = subdir + os.sep + file
           #print(filepath)
           dashcount = 0
           with open(infile, 'r') as inf:
              see2nddash = False
              process = False
              si = 0
              summary = ""
              content = ""
              outfile = ""
              for i, line in enumerate(inf):
                  if (len(line.strip()) == 0):
                     continue
                  search = dashpat.search(line)
                  if (search is not None):
                     dashcount = dashcount + 1
                  if (dashcount == 2):
                     if (see2nddash is False):
                         see2nddash = True
                         per = percentpat.findall(line)
                         if (len(per) > 0 and float(per[0]) > threshold):
                            process = True
                            summary = line
                            continue
                         #print(line)
                     if (process):
                        if (si == 0):
                           outfile = gen_filename(line)
                           print("'{s}'".format(s=outfile))
                           sumfile = outdir + os.sep + outfile + "_sum.txt"
                           with open(sumfile, 'a+') as outf:
                              outf.write(summary)
                        content = content + line
                        si = si + 1
              if (len(content) > 0 and len(outfile) > 0):
                 contfile = outdir + os.sep + outfile + "_content.txt"
                 if (os.path.isfile(contfile) is False):
                    with open(contfile, 'w+') as contf:
                       contf.write(content)
                        

if __name__=="__main__":
   parser = argparse.ArgumentParser()
   parser.add_argument("-i", "--input", help="Specify the input directory where all profiling files locate")
   parser.add_argument("-o", "--output", help="Specify the output directory")
   parser.add_argument("-t", "--threshold", type=int, default=10, help="Sepcify the hot function percentage to print [10~90], default is 10 percent")
   args = parser.parse_args()
   if args.input is None or args.output is None:
      print("No input directory or output directory")
   else:
      parse_profiling(args.input, args.output, args.threshold)
