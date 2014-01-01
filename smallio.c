/* smallio.c -- READ and WRITE for Small in C, CRB, Jul 30, 2007 */

/**********************************************************************\
    smallio -- READ and WRITE for Small in C
\**********************************************************************/

// 07/30/2007 CRB Original coding.
// 08/02/2007 CRB Added code and test program.
// 08/19/2007 CRB Reversed args for SMALL, pass UNIT by reference.
// 08/27/2007 CRB Intercept EOL = -1 from ioop read.
// 12/16/2013 CRB Correct off by one error in write loop.
// 12/17/2013 CRB Just hacking.
// 12/26/2013 CRB short -> long for 32-bit Small

#include <stdio.h>
#include "grandios.h"

#define CR 0x0D		// carriage return
#define LF 0x0A		// line feed

int READ(long LINE[], long * pUNIT)
{
    int i, iret, unit;
    char line[MAXLEN+2];

    unit = *pUNIT;
    iret = ioop(-1, unit, line);
    if ( iret == 0 )
    {   // a valid line of text has been read
        if ( line[0] == -1 )
	{
	    // a blank line has been detected
	    LINE[0] = 1;
	    LINE[1] = ' ';
	    return 1;
	}
	for ( i = 0; line[i]; i++ )
	{
//	    if ( line[i] == LF || line[i] == -1 )
	    if ( line[i] == -1 )
	    {
		LINE[i+1] = CR;
		break;
	    }
	    else
		LINE[i+1] = line[i];
	}
	LINE[0] = i;
	return 1;	// return success
    }
    else if ( iret == 1 )
    {   // end of file has been detected
	LINE[0] = 0;
	return 0;	// return EOF
    }
    else
    {    // error on read operation
	LINE[0] = 0;
	return -1;	// return error
    }
}

void WRITE(long LINE[], long * pUNIT)
{
    int i, len, unit;
    char line[MAXLEN+2];

    unit = *pUNIT;
    len = LINE[0];
    if ( len == 0 )
	line[0] = 0;
    else {
	for ( i = 0; i < len; i++ )
	{
	    if ( LINE[i+1] == CR )
		line[i] = LF;
	    else
		line[i] = LINE[i+1];
	}
	line[len] = -1;		// obo error corrected 12/16/2013
    }
    ioop(1, unit, line);
}

#ifdef TEST
int progr(void)
{
    int status;
    long buffer[MAXLEN+2];
    long inch = 1, outch = 3;

    while ( 1 )
    {
	status = READ( buffer, &inch);
	if ( status != 1 )
	    break;
	WRITE( buffer, &outch);
    }
    if ( status == -1 )
	fputs("Read error\n", stderr);
    else
	fputs("Read end of file\n", stdout);
}
#endif
