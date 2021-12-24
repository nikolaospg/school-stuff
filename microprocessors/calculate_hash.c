
/** This is the function that calculates the hash in the C implementation.
 *  It works by getting the string (char* a) and a lookup table as arguments.
 *  The lookup table is a vector, which matches every capital latin character to an integer.
 *  We used this, in order to be able to get the mapping of the capital characters in an easy and fast way.
 *  The C implementation only returns an integer of the value, the assembly implementation returns the address as
 *  stated in the exercise */
int c_hash_calc(char* a, int* lookup);

/** This is the assembly version of the hash calculation algorithm. It was done by "converting" the prototype C code in assembly*/

__asm int* ass_hash_calc(char* a, int* lookup, int* dst){
		//PROLOGUE, INITIALISATIONS:
		
		/********************************************************/
		//R0->char indexing
		//R1->lookup_table starting point
		//R2->destination to the memory
		//R3->used as temporal register for computations
		//R4->used as the hash sum
		/*********************************************************/
		
		PUSH {R4}
		MOV R4,#0    
		MOV R3,#0   
					  
		//FINISHED PROLOGUE AND INITIALISATIONS
		
		//With this flag we implement the Null termination test. If we are in the end of the string, we branch in the epilogue.
FINISH_TEST										

		LDRB R3, [R0]	//temp=a[string_index];
		ADD  R0, #1	// string_index++;
		CMP  R3, #0
		BEQ EPILOGUE
		
		/*With this label, we implement the test for the capital letters.
			The double comparisons are done, using the double CMP trick*/
CAPITAL_TEST									

		CMP R3,#64
		BLT NUMBER_TEST
		CMP R3,#91
		BGT NUMBER_TEST
		SUB R3,R3,#65
		LSL R3, #2				//Doing this because we are indexing integers not chars, therefore the offset should be on 32 bits, not 8 bits.
		LDR R3,[R1,R3]
		ADD R4,R4,R3
		B FINISH_TEST
		/*Finished with the Capital letter test*/
		
		/*In a similar manner, this is the test for the numbers:*/
NUMBER_TEST
		
		CMP R3,#47
		BLT FINISH_TEST
		CMP R3,#58
		BGT FINISH_TEST
		SUB R4,R4,R3
		ADD R4,R4,#48
		B FINISH_TEST
		/*Finished with the numbers too*/
		
		//In the epilogue, we pop the non-scratch registers from the stack and return to the main function.
		//Also, the R0 register gets the returned value.
EPILOGUE
 
		STR R4, [R2]  //store the hash in the memory
		MOV R0, R2					  // put the adress in register R0 to return
		POP {R4}                                           //Epilogue
		BX LR
	
		
}

int main(){
	
    char a[]="Ar, PE 2!";
    int lookup[]={18, 11, 10, 21, 7, 5, 9, 22, 17, 2, 12, 3, 19, 1, 14, 16, 20, 8, 23, 4, 26, 15, 6, 24, 13, 25};           //The mapping done on the exercise
		int hash;
		int hash2=0;
		int* ip;
				ip=&hash2;
		
    
		hash=c_hash_calc(a, lookup);						//C calculation
		ip= (ass_hash_calc(a,lookup,ip));					//Assembly calculation
			
			
		/*Test of correctness. By accepting that the C implementation is true (It is easier to make the tests on C,
			we compare the two results. If they are different, then the R4 register gets a specific value, else it gets 
			another value. This is the way we thought in order to implement the test, because we wanted to avoid the 
			stdio library. 
			The change is done using inline assembly code.*/
		if(hash!=*ip){
				__asm("MOV R4,#0x11111111")
				return 0;
		}
		else{
				__asm("MOV R4,#0x01111111");
				return 1;
		}
		/*Finished the correctness test*/
		
}

int c_hash_calc(char* a, int* lookup){

    /* Initialising variables that will be later used to implement the algorithm.*/
    int string_index=0;
    int lookup_index=0;                   //Initialising with this value, because it corresponds to 'A'. This way, the case of 'A' will give me index=0 when making the subtraction.
    char temp;
    int hash=0;
    /*Finished initialising the useful variables*/

    /*In every iteration of the while loop we check one character of the string. The check stops at the N termination*/
    while(a[string_index]!='\0'){
        temp=a[string_index];

        /*Testing whether we have a capital letter. The 'A' corresponds to 65, and 'Z' to 90 in the ASCII standard*/
        if(temp>64 && temp<91){
            lookup_index=(int)temp-65;          //With the (int) typecasting I get the ASCII value of the character
            hash=hash+lookup[lookup_index];
        }
        /*Finished with the capital letter test.*/

        /*Testing for a number. Again, '0' corresponds to 48 and '9' to 57*/
        else if(temp>47 && temp<58){            
            hash=hash-(int)temp+48;
        }
        /*Finished with the capital letters*/

        string_index++;
    }
    /*Checked every single character and got our results*/

    return hash;
}
