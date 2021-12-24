PbA=[2835280     1563404      446498       23671%Total number of bit errors array for SNR 5,10,15,20
     2684379     1380207      315790        8476
     2548965     1230881      222617        3053
     2436999     1110294      158022        1036
     2337740     1009202      114727         311
     2256106      931371       85977         125
     2183935      865785       66900          48
     2122360      812637       55018          15
     2076567      771584       48303          10
     2033402      738215       44009          11
     1998033      712773       42291          17
     1970872      694535       41869          18
     1952235      677255       41572          15
     1935547      668102       42145          14
     1927598      661591       42606          17
     1927674      658514       42501          17];
 
 PbB=[303557      190023      107745       54516 %Total number of bit errors array for SNR 16,17,18,19
      196247      112625       56329       24064
      126292       64475       28177       10522
       81550       36749       14198        4537
       53989       21322        6870        1917
       36335       12885        3610         736
       26058        8534        1990         337
       20481        5826        1235         170
       17390        4845         920         137
       15710        4430         869         143
       15228        4317         950         132
       15300        4368         925         136
       15501        4489        1004         146
       15570        4585        1058         166
       15948        4678        1053         168
       16030        4745        1039         167];
   
   
 
 
 Pb5=zeros(16,1);     %The vectors holding the errors for various SNR
 Pb10=zeros(16,1);
 Pb15=zeros(16,1);
 Pb20=zeros(16,1);
 Pb16=zeros(16,1);
 Pb17=zeros(16,1);
 Pb18=zeros(16,1);
 Pb19=zeros(16,1);
 theta=[30 34 38 42 46 50 54 58 62 66 70 74 78 82 86 90];       %The angle vector( X-AXIS)

 
 for i=1:16       %dinei tis times diairemenes me ton arithmo tvn stalmenwn symbolwn
     Pb5(i)=(PbA(i,1)/12)*10^(-6);
     Pb10(i)=(PbA(i,2)/12)*10^(-6);
     Pb15(i)=(PbA(i,3)/12)*10^(-6);
     Pb20(i)=(PbA(i,4)/12)*10^(-6);
     Pb16(i)=(PbB(i,1)/12)*10^(-6);
     Pb17(i)=(PbB(i,2)/12)*10^(-6);
     Pb18(i)=(PbB(i,3)/12)*10^(-6);
     Pb19(i)=(PbB(i,4)/12)*10^(-6);
 end
 
 Pb13=[830364
      660119
      531887
      431407
      357080
      300142
      261930
      231217
      210788
      197508
      189166
      184122
      180754
      178948
      177399
      177884]*(10^(-6)/12);  

  semilogy(theta,Pb5,'-+k'),grid,xlabel('theta angle,degrees'),ylabel('BER')
  hold on
 semilogy(theta,Pb10,'-ok'),grid,xlabel('theta angle,degrees'),ylabel('BER')
  semilogy(theta,Pb13,'-hk'),grid,xlabel('theta angle,degrees'),ylabel('BER')
semilogy(theta,Pb15,'-*k'),grid,xlabel('theta angle,degrees'),ylabel('BER')
 semilogy(theta,Pb16,'-dk'),grid,xlabel('theta angle,degrees'),ylabel('BER')
 semilogy(theta,Pb17,'-<k'),grid,xlabel('theta angle,degrees'),ylabel('BER')
semilogy(theta,Pb18,'->k'),grid,xlabel('theta angle,degrees'),ylabel('BER')
 semilogy(theta,Pb19,'-pk'),grid,xlabel('theta angle,degrees'),ylabel('BER')
semilogy(theta,Pb20,'-sk'),grid,xlabel('theta angle,degrees'),ylabel('BER')

  legend('SNR 5dB','SNR 10dB','SNR 13dB','SNR 15dB','SNR 16dB','SNR 17dB','SNR 18dB','SNR 19dB','SNR 20dB')
 
