
function [T2]=ute_4echo_fit(TE1,TE2,TE3,TE4)

TE = [2.6E-3; 5.2E-3; 7.8E-3];
T2 = zeros(size(TE1));

for x=1:256,
   for y=1:256,
    % Only process a pixel if it isn't background
           if(TE1(x,y))> 500
               
               y_e=[double(TE2(x,y))/double(TE1(x,y)),double(TE3(x,y))/double(TE1(x,y)),double(TE4(x,y))/double(TE1(x,y))]';
               y_loge=-(log(y_e));
             
               r = TE\y_loge;
               
                if ((r<0.0)|| (1/r>1500.0)) 
                    T2(x,y)=0.0;
                else
                T2(x,y)=1/r;
               
                end;
           else
               T2(x,y)=0.0;
           end;
        end;
    end;

