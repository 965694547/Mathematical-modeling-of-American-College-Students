clc,clear;

%% ��ʼ������
[number,txt,raw] = xlsread('C:/Users/GZF/Desktop/passingevents.xlsx');
storage = cell(1,400);

[x1,x2] = size(storage);
[hang,lie] = size(txt);

sum_pass_num = zeros(1,40);%�ܴ���������
Huskies_pass_num = zeros(1,40);%Huskies����������
Opponent_pass_num = zeros(1,40);%Opponent����������

Huskies_team_state = cell(40,40);%���ڼ�¼ÿ���Լҵ���Ա�ϳ���� �� Ϊ���� �� Ϊ��Ա��
Opponent_team_state = cell(40,40);%���ڼ�¼ÿ�����ֵ���Ա�ϳ���� �� Ϊ���� �� Ϊ��Ա��

Huskies_team_num = zeros(1,40);%���ڼ�¼ÿ���Լҵ���Ա��� �� Ϊ���� 
Opponent_team_num = zeros(1,40);%���ڼ�¼ÿ���Լҵ���Ա��� �� Ϊ���� 

%% ȡ���������
for num = 2:hang
    for i = 1:x2
        if(num > 2)%�ж��Ƿ�Ϊ��һ��
            if(~isempty(cell2mat(storage(1,i))))%�ж��Ƿ�Ϊ��
                if(strcmp(cell2mat(txt(num,2)),cell2mat(storage(1,i))))%�ж��Ƿ����������������
                    break;%����˳�     
                end
            else
                storage(1,i) = txt(num,2);
                break;%Ϊ�ձ���
            end
        else      %�ǵ�һ�θ�ֵ�˳�
            storage(1,1) = txt(num,2);
            break;
        end
    end
end 

%% �жϵ�һ�������Ĵ�����
for num = 1:hang
    if(number(num,1) == 1)
       sum_pass_num(1,1)=sum_pass_num(1,1)+1;
    else
        break;
    end
end

%% ����Huskies�Ͷ�ӦOpponent���Ե��ܴ�����
for num = 2:(sum_pass_num(1,1)+1)
    if(strcmp(cell2mat(txt(num,2)),cell2mat(storage(1,1))))
        Huskies_pass_num(1,1)=Huskies_pass_num(1,1)+1;
    else
        Opponent_pass_num(1,1)=Opponent_pass_num(1,1)+1;
    end
end

%% ͳ����Ա��Ϣ
for num = 2:(sum_pass_num(1,1)+1)
    if(strncmpi(cell2mat(txt(num,3)),cell2mat(storage(1,1)),4))
        %��ԱΪ���ѷ� 
        for i = 1:40
            if(~isempty(cell2mat(Huskies_team_state(1,i))))%�ж��Ƿ�Ϊ��
                if(strcmp(cell2mat(txt(num,3)),cell2mat(Huskies_team_state(1,i))))%�ж��Ƿ����������������
                    break;%����˳�     
                end
            else
                Huskies_team_state(1,i) = txt(num,3);
                break;%Ϊ�ձ���
            end
         end
    else
        %��ԱΪ���ַ�
         for i = 1:40
            if(~isempty(cell2mat(Opponent_team_state(1,i))))%�ж��Ƿ�Ϊ��
                if(strcmp(cell2mat(txt(num,3)),cell2mat(Opponent_team_state(1,i))))%�ж��Ƿ����������������
                    break;%����˳�     
                end
            else
                Opponent_team_state(1,i) = txt(num,3);
                break;%Ϊ�ձ���
            end     
         end       
    end  
end

%% ��Ա����
for i = 1:40      %Huskies��Ա����
    if(~isempty(cell2mat(Huskies_team_state(1,i))))%�ж��Ƿ�Ϊ��
        Huskies_team_num(1,1) = Huskies_team_num(1,1)+1;
    else
       break;
    end
end

for i = 1:40      %Opponent��Ա����
    if(~isempty(cell2mat(Opponent_team_state(1,i))))%�ж��Ƿ�Ϊ��
        Opponent_team_num(1,1) = Opponent_team_num(1,1)+1;
    else
       break;
    end
end

%% ����ͼ��ʼ��
Huskies_team_graph = cell(1,40); %ÿ�����������ͼ�۴洢���� ��Ϊ����
Huskies_team_graph(1,1) = {zeros(Huskies_team_num(1,1),Huskies_team_num(1,1))};%Huskies�ڽӾ���

Opponent_team_graph = cell(1,40); %ÿ�����������ͼ�۴洢���� ��Ϊ����
Opponent_team_graph(1,1) = {zeros(Opponent_team_num(1,1),Opponent_team_num(1,1))};%Opponent�ڽӾ���

Huskies_count_one = 0;  %Huskies OriginPlayerID��������
Huskies_count_two = 0;  %Huskies DestinationPlayerID��������

Opponent_count_one = 0; %Opponent OriginPlayerID��������
Opponent_count_two = 0; %Opponent DestinationPlayerID��������


%% ��¼��Աλ�ú�ʵʱ��ʱ��
Match_1H_count = zeros(1,40); %ÿ�������ϰ볡�ļ�ʱ
Match_2H_count = zeros(1,40); %ÿ�������ϰ볡�ļ�ʱ
unit_1H_time = zeros(1,40);%ÿ�������ϰ볡�ĵ�λʱ��ÿ���Ӷ���(���ݵ�λ)
unit_2H_time = zeros(1,40);%ÿ�������°볡�ĵ�λʱ��ÿ���Ӷ���(���ݵ�λ)
for num = 3:(sum_pass_num(1,1)+1)
    if(~strcmp(cell2mat(txt(num,5)),cell2mat(txt((num-1),5))))
        Match_1H_count(1,1)=num-2;
        break;
    end
end
Match_2H_count(1,1) = sum_pass_num(1,1);

unit_1H_time(1,1) = number(Match_1H_count(1,1),6)/240;
unit_2H_time(1,1) = number(Match_2H_count(1,1),6)/240;

Huskies_pixel_info = cell(Huskies_team_num(1,1),8);%�����ж�Ա�ڱ�����������һ����Ϣ��ȡ
%�� 1 x ���� ����
%�� 2 y ���� ����
%�� 3 x ���� �仯�� ����
%�� 4 y ���� �仯�� ����
%�� 5 ��Ϊ���
%�� 6 �������ʱ��
%�� 7 ��Ϣ����
%�� 8 �¼���¼��
Opponent_pixel_info = cell(Huskies_team_num(1,1),6);

%% �Զ�Ա���б��
for i = 1:Huskies_team_num(1,1)      %Huskies��Ա���
    char_value = Huskies_team_state{1,i};
    [x1,x2] = size(char_value);
    switch char_value(1,x2-1)
        case 'G'
            Huskies_pixel_info(i,5) = {40};
        case 'D'
            Huskies_pixel_info(i,5) = {30};
        case 'M'
            Huskies_pixel_info(i,5) = {20};            
        case 'F'
            Huskies_pixel_info(i,5) = {10};
    end
    switch char_value(1,x2)
        case '1'
            Huskies_pixel_info{i,5} = Huskies_pixel_info{i,5}+1;
        case '2'
            Huskies_pixel_info{i,5} = Huskies_pixel_info{i,5}+2;
        case '3'
            Huskies_pixel_info{i,5} = Huskies_pixel_info{i,5}+3;            
        case '4'
            Huskies_pixel_info{i,5} = Huskies_pixel_info{i,5}+4;
    end    
end
for i = 1:Opponent_team_num(1,1)      %Opponent��Ա���
    char_value = Opponent_team_state{1,i};
    [x1,x2] = size(char_value);
    switch char_value(1,x2-1)
        case 'G'
            Opponent_pixel_info(i,5) = {40};
        case 'D'
            Opponent_pixel_info(i,5) = {30};
        case 'M'
            Opponent_pixel_info(i,5) = {20};            
        case 'F'
            Opponent_pixel_info(i,5) = {10};
    end
    switch char_value(1,x2)
        case '1'
            Opponent_pixel_info{i,5} = Opponent_pixel_info{i,5}+1;
        case '2'
            Opponent_pixel_info{i,5} = Opponent_pixel_info{i,5}+2;
        case '3'
            Opponent_pixel_info{i,5} = Opponent_pixel_info{i,5}+3;            
        case '4'
            Opponent_pixel_info{i,5} = Opponent_pixel_info{i,5}+4;
    end    
end

%% ð������ С�ĺ���С
for i = 2 : Huskies_team_num(1,1)-1
    for j = Huskies_team_num(1,1) : -1 : i
        if Huskies_pixel_info{j,5} <  Huskies_pixel_info{j-1,5}
            num = Huskies_pixel_info{j,5};
            Huskies_pixel_info{j,5} = Huskies_pixel_info{j-1,5};
            Huskies_pixel_info{j-1,5} = num;
        end
    end
end
%С�ĺ���С
for i = 2 : Opponent_team_num(1,1)-1
    for j = Opponent_team_num(1,1) : -1 : i
        if Opponent_pixel_info{j,5} <  Opponent_pixel_info{j-1,5}
            num = Opponent_pixel_info{j,5};
            Opponent_pixel_info{j,5} = Opponent_pixel_info{j-1,5};
            Opponent_pixel_info{j-1,5} = num;
        end
    end
end

%% ����Ա������Ϣ
for num = 2:Match_1H_count(1,1)+1
    %% ��������Ϣ�ռ�
    char_value = txt{num,3};                                %������
    [x1,x2] = size(char_value);
    switch char_value(1,x2-1)
        case 'G'
                value = 40;
        case 'D'
                value = 30;
        case 'M'
                value = 20;            
        case 'F'
                value = 10;
    end
    switch char_value(1,x2)
        case '1'
                value = value+1;
        case '2'
                value = value+2;
        case '3'
                value = value+3;            
        case '4'
                value = value+4;
    end
    if(strncmpi(cell2mat(txt(num,3)),cell2mat(storage(1,1)),4)) %������
        if mod(value,10)>=3
               for i = Huskies_team_num(1,1):-1:1
                    if Huskies_pixel_info{i,5} == value
                        Huskies_pixel_info{i,1} = [Huskies_pixel_info{i,1},number(num-1,8)];%���Ѵ�����x
                        Huskies_pixel_info{i,2} = [Huskies_pixel_info{i,2},number(num-1,9)];%���Ѵ�����y
                        Huskies_pixel_info{i,6} = [Huskies_pixel_info{i,6},number(num-1,6)];%���Ѵ���ʱ��
                    end
               end 
        else
               for i = 1:Huskies_team_num(1,1)
                    if Huskies_pixel_info{i,5} == value
                        Huskies_pixel_info{i,1} = [Huskies_pixel_info{i,1},number(num-1,8)];%���Ѵ�����x
                        Huskies_pixel_info{i,2} = [Huskies_pixel_info{i,2},number(num-1,9)];%���Ѵ�����y
                        Huskies_pixel_info{i,6} = [Huskies_pixel_info{i,6},number(num-1,6)];%���Ѵ���ʱ��
                    end
               end
        end
    else
         if mod(value,10)>=3
               for i = Opponent_team_num(1,1):-1:1
                    if Opponent_pixel_info{i,5} == value
                        Opponent_pixel_info{i,1} = [Opponent_pixel_info{i,1},number(num-1,8)];%���ִ�����x
                        Opponent_pixel_info{i,2} = [Opponent_pixel_info{i,2},number(num-1,9)];%���ִ�����y
                        Opponent_pixel_info{i,6} = [Opponent_pixel_info{i,6},number(num-1,6)];%���ִ���ʱ��
                    end
               end 
        else
               for i = 1:Opponent_team_num(1,1)
                    if Opponent_pixel_info{i,5} == value
                        Opponent_pixel_info{i,1} = [Opponent_pixel_info{i,1},number(num-1,8)];%���ִ�����x
                        Opponent_pixel_info{i,2} = [Opponent_pixel_info{i,2},number(num-1,9)];%���ִ�����y
                        Opponent_pixel_info{i,6} = [Opponent_pixel_info{i,6},number(num-1,6)];%���ִ���ʱ��
                    end
               end
        end       
    end
%% ��������Ϣ�ռ�
    char_value = txt{num,4};                                %������
    [x1,x2] = size(char_value);
    switch char_value(1,x2-1)
        case 'G'
                value = 40;
        case 'D'
                value = 30;
        case 'M'
                value = 20;            
        case 'F'
                value = 10;
    end
    switch char_value(1,x2)
        case '1'
                value = value+1;
        case '2'
                value = value+2;
        case '3'
                value = value+3;            
        case '4'
                value = value+4;
    end
    if(strncmpi(cell2mat(txt(num,4)),cell2mat(storage(1,1)),4)) %������
        if mod(value,10)>=3
               for i = Huskies_team_num(1,1):-1:1
                    if Huskies_pixel_info{i,5} == value
                        Huskies_pixel_info{i,1} = [Huskies_pixel_info{i,1},number(num-1,10)];%���ѽ�����x
                        Huskies_pixel_info{i,2} = [Huskies_pixel_info{i,2},number(num-1,11)];%���ѽ�����y
                        Huskies_pixel_info{i,6} = [Huskies_pixel_info{i,6},number(num-1,6)];%���Ѵ���ʱ��
                    end
               end 
        else
               for i = 1:Huskies_team_num(1,1)
                    if Huskies_pixel_info{i,5} == value
                        Huskies_pixel_info{i,1} = [Huskies_pixel_info{i,1},number(num-1,10)];%���ѽ�����x
                        Huskies_pixel_info{i,2} = [Huskies_pixel_info{i,2},number(num-1,11)];%���ѽ�����y
                        Huskies_pixel_info{i,6} = [Huskies_pixel_info{i,6},number(num-1,6)];%���Ѵ���ʱ��
                    end
               end
        end
    else
         if mod(value,10)>=3
               for i = Opponent_team_num(1,1):-1:1
                    if Opponent_pixel_info{i,5} == value
                        Opponent_pixel_info{i,1} = [Opponent_pixel_info{i,1},number(num-1,10)];%���ֽ�����x
                        Opponent_pixel_info{i,2} = [Opponent_pixel_info{i,2},number(num-1,11)];%���ֽ�����y
                        Opponent_pixel_info{i,6} = [Opponent_pixel_info{i,6},number(num-1,6)];%���ִ���ʱ��
                    end
               end 
        else
               for i = 1:Opponent_team_num(1,1)
                    if Opponent_pixel_info{i,5} == value
                        Opponent_pixel_info{i,1} = [Opponent_pixel_info{i,1},number(num-1,10)];%���ֽ�����x
                        Opponent_pixel_info{i,2} = [Opponent_pixel_info{i,2},number(num-1,11)];%���ֽ�����y
                        Opponent_pixel_info{i,6} = [Opponent_pixel_info{i,6},number(num-1,6)];%���ִ���ʱ��
                    end
               end
        end       
    end
end

%% ��Ϣ���������Լ�ʱ���ڸ�������x��y�����ϵ�����
%��Ϣ������
for i = 1:Huskies_team_num(1,1)      %Huskies��Ա���
    char_value = Huskies_pixel_info{i,1};
    [x1,x2] = size(char_value);
    Huskies_pixel_info{i,7} = x2;  
end
for i = 1:Opponent_team_num(1,1)      %Opponent��Ա���
    char_value = Opponent_pixel_info{i,1};
    [x1,x2] = size(char_value);
    Opponent_pixel_info{i,7} = x2;  
end
%�����ʼ���
for i = 1:Huskies_team_num(1,1)      %Huskies��Ա���
    for num = 2:Huskies_pixel_info{i,7}+1
        if(num ~=Huskies_pixel_info{i,7}+1)
            Huskies_pixel_info{i,3} = [Huskies_pixel_info{i,3},Huskies_pixel_info{i,1}(1,num) - Huskies_pixel_info{i,1}(1,num-1)];
            Huskies_pixel_info{i,4} = [Huskies_pixel_info{i,4},Huskies_pixel_info{i,2}(1,num) - Huskies_pixel_info{i,2}(1,num-1)];
        else
            Huskies_pixel_info{i,3}(1,Huskies_pixel_info{i,7}) =  Huskies_pixel_info{i,3}(1,Huskies_pixel_info{i,7}-1);
            Huskies_pixel_info{i,4}(1,Huskies_pixel_info{i,7}) =  Huskies_pixel_info{i,4}(1,Huskies_pixel_info{i,7}-1);
        end
    end
end
for i = 1:Opponent_team_num(1,1)      %Opponent��Ա���
    for num = 2:Opponent_pixel_info{i,7}+1
        if(num ~=Opponent_pixel_info{i,7}+1)
            Opponent_pixel_info{i,3} = [Opponent_pixel_info{i,3},Opponent_pixel_info{i,1}(1,num) - Opponent_pixel_info{i,1}(1,num-1)];
            Opponent_pixel_info{i,4} = [Opponent_pixel_info{i,4},Opponent_pixel_info{i,2}(1,num) - Opponent_pixel_info{i,2}(1,num-1)];
        else
            Opponent_pixel_info{i,3}(1,Opponent_pixel_info{i,7}) =  Opponent_pixel_info{i,3}(1,Opponent_pixel_info{i,7}-1);
            Opponent_pixel_info{i,4}(1,Opponent_pixel_info{i,7}) =  Opponent_pixel_info{i,4}(1,Opponent_pixel_info{i,7}-1);
        end
    end
end
%% �¼���¼����ʼ��
for i = 1:Huskies_team_num(1,1)      %Huskies��Ա���
    Huskies_pixel_info{i,8} = 1;
end
for i = 1:Opponent_team_num(1,1)      %Opponent��Ա���
    Opponent_pixel_info{i,8} = 1;
end

%% ������Ӧ���ڽӾ�����Ϣ
for num = 2:(sum_pass_num(1,1)+1)
    %% ��������Ϣ�ռ�
    char_value = txt{num,3};                                %������
    [x1,x2] = size(char_value);
    switch char_value(1,x2-1)
        case 'G'
                value = 40;
        case 'D'
                value = 30;
        case 'M'
                value = 20;            
        case 'F'
                value = 10;
    end
    switch char_value(1,x2)
        case '1'
                value = value+1;
        case '2'
                value = value+2;
        case '3'
                value = value+3;            
        case '4'
                value = value+4;
    end
    if(strncmpi(cell2mat(txt(num,3)),cell2mat(storage(1,1)),4)) %������
        if mod(value,10)>=3
               for i = Huskies_team_num(1,1):-1:1
                    if Huskies_pixel_info{i,5} == value
                        Huskies_count_one = i;
                    end
               end 
        else
               for i = 1:Huskies_team_num(1,1)
                    if Huskies_pixel_info{i,5} == value
                        Huskies_count_one = i;
                    end
               end
        end
    else
         if mod(value,10)>=3
               for i = Opponent_team_num(1,1):-1:1
                    if Opponent_pixel_info{i,5} == value
                        Opponent_count_one = i;
                    end
               end 
        else
               for i = 1:Opponent_team_num(1,1)
                    if Opponent_pixel_info{i,5} == value
                        Opponent_count_one = i;
                    end
               end
        end       
    end
    %% ��������Ϣ�ռ�
    char_value = txt{num,4};                                %������
    [x1,x2] = size(char_value);
    switch char_value(1,x2-1)
        case 'G'
                value = 40;
        case 'D'
                value = 30;
        case 'M'
                value = 20;            
        case 'F'
                value = 10;
    end
    switch char_value(1,x2)
        case '1'
                value = value+1;
        case '2'
                value = value+2;
        case '3'
                value = value+3;            
        case '4'
                value = value+4;
    end
    if(strncmpi(cell2mat(txt(num,4)),cell2mat(storage(1,1)),4)) %������
        if mod(value,10)>=3
               for i = Huskies_team_num(1,1):-1:1
                    if Huskies_pixel_info{i,5} == value
                        Huskies_count_two = i ;    %��¼Huskies DestinationPlayerID����
                        Huskies_team_graph{1,1}(Huskies_count_one,Huskies_count_two) = Huskies_team_graph{1,1}(Huskies_count_one,Huskies_count_two) + 1;
                        Huskies_team_graph{1,1}(Huskies_count_two,Huskies_count_one) = Huskies_team_graph{1,1}(Huskies_count_two,Huskies_count_one) + 1;
                    end
               end 
        else
               for i = 1:Huskies_team_num(1,1)
                    if Huskies_pixel_info{i,5} == value
                        Huskies_count_two = i ;    %��¼Huskies DestinationPlayerID����
                        Huskies_team_graph{1,1}(Huskies_count_one,Huskies_count_two) = Huskies_team_graph{1,1}(Huskies_count_one,Huskies_count_two) + 1;
                        Huskies_team_graph{1,1}(Huskies_count_two,Huskies_count_one) = Huskies_team_graph{1,1}(Huskies_count_two,Huskies_count_one) + 1;
                    end
               end
        end
    else
         if mod(value,10)>=3
               for i = Opponent_team_num(1,1):-1:1
                    if Opponent_pixel_info{i,5} == value
                        Opponent_count_two = i;    %��¼Opponent DestinationPlayerID����
                        Opponent_team_graph{1,1}(Opponent_count_one,Opponent_count_two) = Opponent_team_graph{1,1}(Opponent_count_one,Opponent_count_two) + 1;
                        Opponent_team_graph{1,1}(Opponent_count_two,Opponent_count_one) = Opponent_team_graph{1,1}(Opponent_count_two,Opponent_count_one) + 1;
                    end
               end 
        else
               for i = 1:Opponent_team_num(1,1)
                    if Opponent_pixel_info{i,5} == value
                        Opponent_count_two = i;    %��¼Opponent DestinationPlayerID����
                        Opponent_team_graph{1,1}(Opponent_count_one,Opponent_count_two) = Opponent_team_graph{1,1}(Opponent_count_one,Opponent_count_two) + 1;
                        Opponent_team_graph{1,1}(Opponent_count_two,Opponent_count_one) = Opponent_team_graph{1,1}(Opponent_count_two,Opponent_count_one) + 1;
                    end
               end
        end       
    end
end
%% ��Ա���������ʼ��
Huskies_map_x = zeros(1,Huskies_team_num(1,1));
Huskies_map_y = zeros(1,Huskies_team_num(1,1));
Opponent_map_x = zeros(1,Opponent_team_num(1,1));
Opponent_map_y = zeros(1,Opponent_team_num(1,1));

[count_numeber,count_numeber]=size(Huskies_team_graph{1,1});

for i = 1:Huskies_team_num(1,1)      %Huskies��Ա���
    for num = 1 : Huskies_pixel_info{i,7}
        Huskies_map_x(1,i) = Huskies_map_x(1,i) + Huskies_pixel_info{i,1}(1,num);
    end
    Huskies_map_x(1,i) = Huskies_map_x(1,i)/Huskies_pixel_info{i,7};
end

for i = 1:Opponent_team_num(1,1)      %Huskies��Ա���
    for num = 1 : Opponent_pixel_info{i,7}
        Opponent_map_x(1,i) = Opponent_map_x(1,i) + Opponent_pixel_info{i,1}(1,num);
    end
    Opponent_map_x(1,i) = Opponent_map_x(1,i)/Opponent_pixel_info{i,7};
end

%% ��Ա������ܶȳ�ʼ��
Huskies_Close_num = zeros(Huskies_team_num(1,1),Huskies_team_num(1,1));
Opponent_Close_num = zeros(Opponent_team_num(1,1),Opponent_team_num(1,1));
Huskies_Close = zeros(Huskies_team_num(1,1),Huskies_team_num(1,1));
Opponent_Close = zeros(Opponent_team_num(1,1),Opponent_team_num(1,1));
Huskies_graph_x = 1:1:Huskies_team_num(1,1);
Huskies_graph_y = 1:1:Huskies_team_num(1,1);
Huskies_graph_z = Huskies_Close_num(Huskies_graph_x,Huskies_graph_y);
Opponent_graph_x = 1:1:Opponent_team_num(1,1);
Opponent_graph_y = 1:1:Opponent_team_num(1,1);
Opponent_graph_z = Opponent_Close_num(Opponent_graph_x,Opponent_graph_y);
s=40
%% ������Ӧ�Ĵ�����ܶȾ�����Ϣ����ʾ����
for num = 2:(sum_pass_num(1,1)+1)
    %% ��������Ϣ�ռ�
    char_value = txt{num,3};                                %������
    [x1,x2] = size(char_value);
    switch char_value(1,x2-1)
        case 'G'
                value = 40;
        case 'D'
                value = 30;
        case 'M'
                value = 20;            
        case 'F'
                value = 10;
    end
    switch char_value(1,x2)
        case '1'
                value = value+1;
        case '2'
                value = value+2;
        case '3'
                value = value+3;            
        case '4'
                value = value+4;
    end
    if(strncmpi(cell2mat(txt(num,3)),cell2mat(storage(1,1)),4)) %������
        if mod(value,10)>=3
               for i = Huskies_team_num(1,1):-1:1
                    if Huskies_pixel_info{i,5} == value
                        Huskies_count_one = i;
                    end
               end 
        else
               for i = 1:Huskies_team_num(1,1)
                    if Huskies_pixel_info{i,5} == value
                        Huskies_count_one = i;
                    end
               end
        end
    else
         if mod(value,10)>=3
               for i = Opponent_team_num(1,1):-1:1
                    if Opponent_pixel_info{i,5} == value
                        Opponent_count_one = i;
                    end
               end 
        else
               for i = 1:Opponent_team_num(1,1)
                    if Opponent_pixel_info{i,5} == value
                        Opponent_count_one = i;
                    end
               end
        end       
    end
    %% ��������Ϣ�ռ�
    char_value = txt{num,4};                                %������
    [x1,x2] = size(char_value);
    switch char_value(1,x2-1)
        case 'G'
                value = 40;
        case 'D'
                value = 30;
        case 'M'
                value = 20;            
        case 'F'
                value = 10;
    end
    switch char_value(1,x2)
        case '1'
                value = value+1;
        case '2'
                value = value+2;
        case '3'
                value = value+3;            
        case '4'
                value = value+4;
    end
    if(strncmpi(cell2mat(txt(num,4)),cell2mat(storage(1,1)),4)) %������
        if mod(value,10)>=3
               for i = Huskies_team_num(1,1):-1:1
                    if Huskies_pixel_info{i,5} == value
                        Huskies_count_two = i ;    %��¼Huskies DestinationPlayerID����
                        if num == 2
                            Huskies_Close_num = updata(Huskies_team_num(1,1),Huskies_Close_num,Huskies_count_one ...
                                ,Huskies_count_two,0,number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),s);
                        else
                            Huskies_Close_num = updata(Huskies_team_num(1,1),Huskies_Close_num,Huskies_count_one ...
                                        ,Huskies_count_two,number(num-2,6),number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),s);                            
                        end
                        Huskies_graph_z = Huskies_Close_num(Huskies_graph_x,Huskies_graph_y);
                        figure(1); bar3(Huskies_Close_num);
                        title('bar3'); xlabel('x'); ylabel('y'); zlabel('z');
                        pause(0.01);
                    end
               end 
        else
               for i = 1:Huskies_team_num(1,1)
                    if Huskies_pixel_info{i,5} == value
                        Huskies_count_two = i ;    %��¼Huskies DestinationPlayerID����
                        if num == 2
                            Huskies_Close_num = updata(Huskies_team_num(1,1),Huskies_Close_num,Huskies_count_one ...
                                ,Huskies_count_two,0,number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),s);
                        else
                            Huskies_Close_num = updata(Huskies_team_num(1,1),Huskies_Close_num,Huskies_count_one ...
                                        ,Huskies_count_two,number(num-2,6),number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),s);                            
                        end
                        Huskies_graph_z = Huskies_Close_num(Huskies_graph_x,Huskies_graph_y);
                        figure(1); bar3(Huskies_Close_num);
                        title('bar3'); xlabel('x'); ylabel('y'); zlabel('z');
                        pause(0.01);                       
                    end
               end
        end
    else
         if mod(value,10)>=3
               for i = Opponent_team_num(1,1):-1:1
                    if Opponent_pixel_info{i,5} == value
                        Opponent_count_two = i;    %��¼Opponent DestinationPlayerID����
                        if num == 2
                            Opponent_Close_num = updata(Opponent_team_num(1,1),Opponent_Close_num,Opponent_count_one ...
                                ,Opponent_count_two,0,number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),s);
                        else
                            Opponent_Close_num = updata(Opponent_team_num(1,1),Opponent_Close_num,Opponent_count_one ...
                                        ,Opponent_count_two,number(num-2,6),number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),s);                            
                        end
                        Opponent_graph_z = Opponent_Close_num(Opponent_graph_x,Opponent_graph_y);
%                         figure(2); mesh(Opponent_graph_x, Opponent_graph_y, Opponent_graph_z); %����ά��������
%                         title('mesh'); xlabel('x'); ylabel('y'); zlabel('z');
%                         pause(0.01);                       
                    end
               end 
        else
               for i = 1:Opponent_team_num(1,1)
                    if Opponent_pixel_info{i,5} == value
                        Opponent_count_two = i;    %��¼Opponent DestinationPlayerID����
                        if num == 2
                            Opponent_Close_num = updata(Opponent_team_num(1,1),Opponent_Close_num,Opponent_count_one ...
                                ,Opponent_count_two,0,number(num-1,6),0.01,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),s);
                        else
                            Opponent_Close_num = updata(Opponent_team_num(1,1),Opponent_Close_num,Opponent_count_one ...
                                        ,Opponent_count_two,number(num-2,6),number(num-1,6),0.01,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),s);                            
                        end
                        Opponent_graph_z = Opponent_Close_num(Opponent_graph_x,Opponent_graph_y);
%                         figure(2); mesh(Opponent_graph_x, Opponent_graph_y, Opponent_graph_z); %����ά��������
%                         title('mesh'); xlabel('x'); ylabel('y'); zlabel('z');
%                         pause(0.01);                         
                    end
               end
        end       
    end
end





