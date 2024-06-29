This aspect of the BONUS program has some slight differences. It is much more of an elaborate program and is the format often associated with creating a well structured and functional program, with several pruposes. Although, there is an addition data layer, which is the BADBONUS aka bad output bonus, representing missing or bad data, the focus is on the PROCEDURE division. 

To start, there is the BADBONUS added to this program. The purpose of this file is to check for data that is not read in the input file, INBONUS. Therefore, that layer that we will see will be used for quality assurance purpose. This will then be used to refine the data in order to then correct them and then recount the data. This will not be done in this program, but it is an example of how bad data can be traced as part of a count. 

The PROCEDURE division is divided into input of the file and tracking the variables in their file, then the write aspect of the output file creation and the read input at the end of the program. 

With the input aspect of the files, the program starts with the Mainline. This is the summary of how the input will be read. So the file goes with P0200, 0300, 0400, and culminating into 0900, which then exits from the program. This may seem confiusing, but, it follows logically, in terms of the end part of the program being a read input, which then calls the other process of the input 0200 - 0400. 

What's happening is that the mainline of the program is starting the program from 0900. That is activating the initalizing of the files, then the file is read through the conditional statements, with the last statement, being an else statement, that is starting the program, aka 0900. It starts the program, then reads the variables and their PIC clauses. This in turn has the objective that if the program is unable to read the data due to spaces or data not lining up, then send the data to the BADBONUS file to be written. Else, write the good data into the INBONUS file. Both files have to have their counts as to how many total were in the file, split into how many records are in INBONUS and how many are in BADBONUS. 

The count in the count file, REC_IN is done by using the PERFORM-THRU statement. This loop is reading the input of the file and finding the good data and writing it into the INBONUS file and adding +1 to the count and vice versa for BADBONUS. See below:

        TOTAL RECORDS READ = 0047 (This is the total)
        TOTAL GOOD RECORDS = 0032 
        TOTAL BAD RECORDS = 0015

This is done by the calulation on the on the 0400 wrap up section of the code: 

        IF W01-REC-IN = (W01-REC-OUT + W01-REC-BAD)
            MOVE +0 TO RETURN-CODE
        ELSE
            DISPLAY 'BONUS - RECORD COUNT OUT OF BALANCE'
            MOVE +99 TO RETURN-CODE

Here we see how the calculation is being handled. THe REC_IN is the total, so the total gets output first. Then when the write record for INBONUS and BADBONUS, respectively 0700 and 0800, the count for the respective counts for W01-REC-OUT and W01-REC_BAD is happening there: 

        WRITE OUT-BONUS-REC
            ADD +1 TO W01-REC-OUT

        WRITE BAD-BONUS-REC
            ADD +1 TO W01-REC-BAD

Here is a representation of the calculation: 

        W01-REC-IN = (W01-REC-OUT + W01-REC-BAD)
        47         = (32           + 15        )

        32 = W01-REC-OUT when W01-REC-OUT++
        15 = W01-REC-BAD when W01-REC-OUT++

So why is it that the read input is the last part of the program?

The answer is simple. The program has to perform the record read and count. How will it know to do that. It has to be at the end of the program, when we have established that the program starts from there and has to perform the read function, then it must close out the file and go to the write function, to write to their respective files and perform the count via the input PERFORM-THRU statements in the conditional logic. 