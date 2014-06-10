README.txt -- For runoff subdirectory, CRB, Jun 9, 2014

Contents of this subdirectory
smallrunoffpaper.pdf        Paper describing Small Runoff written in Small
srmain.pdf                  Main module of Small Runoff
srcommand.pdf               Command module
sraction.pdf                Action module
srprocess.pdf               Text processing module

This subdirectory contains a paper describing Small Runoff and the scanned
source code in four modules written in Small for the CP/M operating system. 

Small Runoff is a text formatting program based on the book [1] by Kernighan
and Plauger, and similar to many such programs called Runoff or Formatter that
were popular at the time.

The paper was originally written by Joe Felsenstein for his version of the
program called Seattle Runoff written in Pascal. I rewrote the paper to
describe the version of the program I rewrote in Small and used to format my
Master of Science thesis [2].

The source code is in four modules. The main module interfaces to the
operating system, CP/M in this case, and sets up the input and output files to
begin processing. The command module parses about two dozen different
formatting commands that can be embedded in the text to be processed. Commands
are escaped by beginning with a period character in column one. The action
module conatains many of the procedures for formatting the text. The process
module completes processing of a line of text for output.

 1. B. W. Kernighan, P. J. Plauger, Software Tools, Addison-Wesley, Reading,
Mass., 1976.
 2. C. R. Britten, Small: A Contribution to the Mobile Programming System,
University of Washington Master of Science Thesis, Seattle, Washington, 1982. 
