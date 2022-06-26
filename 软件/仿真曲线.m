[number,txt,raw] = xlsread('C:/Users/GZF/Desktop/6-D2-D6.xlsx');
state=1;
temp = zeros(3,2880);%×Ü´«ÇòÊı¾ØÕó
for num=2:2880
    for i=1:14
        if(num>number(i,1))
            temp(1,num)=temp(1,num)+exp(1-(num-number(i,1))/1500);
        
        end
    end
    temp(2,num)= temp(2,num-1);
   if(num>number(state,1))
        temp(2,num)= temp(2,num)+exp(1-1/20*sqrt((number(state,3)-number(state,5))^2+(number(state,4)-number(state,6))^2));
        state=state+1;
   end
    temp(3,num)=temp(2,num)* temp(1,num);
end

        