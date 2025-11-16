clear;
clc;
threadprocessnumberset=5;
parpool('Threads',threadprocessnumberset);  %Line 3-Line 4: Choose the parallel environment for solving Example Problem and set the process number or thread number for solving Example Problem.
format long;
rng((100*rand)*sum(datevec(datetime('now'))),'twister');
X=[-1,1];                                       
Y=[-1,1];  %Line 7-Line 8: Set the 2-dimensional space for searching for the answer of Example Problem.   
aset=5;  
bset=40;
cset=400;
dset=20;  %Line 9-Line 12: Set the values of the parameters of Example Algorithm.
xset=bset/threadprocessnumberset;
a=1;
while a<=aset
  XX=zeros(1,xset);             
  YY=zeros(1,xset);  %Line 16-Line 17: Let the set for storing (x1, y1) on each process or thread be an empty set.     
  spmd  
    x=1;
    while x<=xset
      x1=min(X)+(max(X)-min(X))*rand;             
      y1=min(Y)+(max(Y)-min(Y))*rand;  %Line 21-Line 22: Let (x1, y1) be a random point in the 2-dimensional space for searching for the answer of Example Problem.  
      c=1;
      d=1;
      while c<=cset
        x2=x1+(((min(X)-x1)+(max(X)-x1))+sign(rand-0.5)*((min(X)-x1)-(max(X)-x1)))/2^(1+19*rand)*rand;
        y2=y1+(((min(Y)-y1)+(max(Y)-y1))+sign(rand-0.5)*((min(Y)-y1)-(max(Y)-y1)))/2^(1+19*rand)*rand;   
        if d~=dset
          if x1^2+y1^2>x2^2+y2^2
            x1=x2;
            y1=y2;
            c=c+1;
            d=1;
          else
            d=d+1;
          end
        else
          if x1^2+y1^2>x2^2+y2^2
            x1=x2;
            y1=y2;
            c=c+1;
            d=1;
          else
            c=c+1;
            d=1;
          end
        end
      end  %Line 23-Line 48: Let (x1, y1) approach the answer of Example Problem.
      XX(1,x)=x1;
      YY(1,x)=y1;  %Line 49-Line 50: Store (x1, y1) in the set for storing (x1, y1) on each process or thread. 
      x=x+1;
    end
  end
  X=gather(XX);
  Y=gather(YY);
  X=[X{:}];
  Y=[Y{:}];
  XY=[X;Y];  %Line 54-Line 58: Gather the set for storing (x1, y1) on each process or thread.
  writematrix(XY,'C:\Users\于子豪\Desktop\2\6. Data\XY.xlsx','Sheet',1,'Range','A1:AN2');  %Line 59: Store the computed answers of Example Problem in Excel.
  a=a+1;
end 
delete(gcp('nocreate'));  %Line 62: Shut down the parallel pool for solving Example Problem.