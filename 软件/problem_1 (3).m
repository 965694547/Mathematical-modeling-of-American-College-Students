clc,clear;

%% 初始化数据
[number,txt,raw] = xlsread('C:/Users/GZF/Desktop/passingevents.xlsx');
storage = cell(1,400);

[x1,x2] = size(storage);
[hang,lie] = size(txt);

sum_pass_num = zeros(1,40);%总传球数矩阵
Huskies_pass_num = zeros(1,40);%Huskies传球数矩阵
Opponent_pass_num = zeros(1,40);%Opponent传球数矩阵

Huskies_team_state = cell(40,40);%用于记录每场自家的球员上场情况 行 为场次 列 为球员名
Opponent_team_state = cell(40,40);%用于记录每场对手的球员上场情况 行 为场次 列 为球员名

Huskies_team_num = zeros(1,40);%用于记录每场自家的球员编号 列 为场次 
Opponent_team_num = zeros(1,40);%用于记录每场自家的球员编号 列 为场次 

%% 取出球队名称
for num = 2:hang
    for i = 1:x2
        if(num > 2)%判断是否为第一次
            if(~isempty(cell2mat(storage(1,i))))%判断是否为空
                if(strcmp(cell2mat(txt(num,2)),cell2mat(storage(1,i))))%判断是否与其中所有项相等
                    break;%相等退出     
                end
            else
                storage(1,i) = txt(num,2);
                break;%为空保存
            end
        else      %是第一次赋值退出
            storage(1,1) = txt(num,2);
            break;
        end
    end
end 

%% 判断第一场比赛的传球数
for num = 1:hang
    if(number(num,1) == 1)
       sum_pass_num(1,1)=sum_pass_num(1,1)+1;
    else
        break;
    end
end

%% 计数Huskies和对应Opponent各自的总传球数
for num = 2:(sum_pass_num(1,1)+1)
    if(strcmp(cell2mat(txt(num,2)),cell2mat(storage(1,1))))
        Huskies_pass_num(1,1)=Huskies_pass_num(1,1)+1;
    else
        Opponent_pass_num(1,1)=Opponent_pass_num(1,1)+1;
    end
end

%% 统计球员信息
for num = 2:(sum_pass_num(1,1)+1)
    if(strncmpi(cell2mat(txt(num,3)),cell2mat(storage(1,1)),4))
        %成员为队友方 
        for i = 1:40
            if(~isempty(cell2mat(Huskies_team_state(1,i))))%判断是否为空
                if(strcmp(cell2mat(txt(num,3)),cell2mat(Huskies_team_state(1,i))))%判断是否与其中所有项相等
                    break;%相等退出     
                end
            else
                Huskies_team_state(1,i) = txt(num,3);
                break;%为空保存
            end
         end
    else
        %成员为对手方
         for i = 1:40
            if(~isempty(cell2mat(Opponent_team_state(1,i))))%判断是否为空
                if(strcmp(cell2mat(txt(num,3)),cell2mat(Opponent_team_state(1,i))))%判断是否与其中所有项相等
                    break;%相等退出     
                end
            else
                Opponent_team_state(1,i) = txt(num,3);
                break;%为空保存
            end     
         end       
    end  
end

%% 球员计数
for i = 1:40      %Huskies球员计数
    if(~isempty(cell2mat(Huskies_team_state(1,i))))%判断是否为空
        Huskies_team_num(1,1) = Huskies_team_num(1,1)+1;
    else
       break;
    end
end

for i = 1:40      %Opponent球员计数
    if(~isempty(cell2mat(Opponent_team_state(1,i))))%判断是否为空
        Opponent_team_num(1,1) = Opponent_team_num(1,1)+1;
    else
       break;
    end
end

%% 场次图初始化
Huskies_team_graph = cell(1,40); %每场比赛传球的图论存储变量 列为场次
Huskies_team_graph(1,1) = {zeros(Huskies_team_num(1,1),Huskies_team_num(1,1))};%Huskies邻接矩阵

Opponent_team_graph = cell(1,40); %每场比赛传球的图论存储变量 列为场次
Opponent_team_graph(1,1) = {zeros(Opponent_team_num(1,1),Opponent_team_num(1,1))};%Opponent邻接矩阵

Huskies_count_one = 0;  %Huskies OriginPlayerID计数变量
Huskies_count_two = 0;  %Huskies DestinationPlayerID计数变量

Opponent_count_one = 0; %Opponent OriginPlayerID计数变量
Opponent_count_two = 0; %Opponent DestinationPlayerID计数变量


%% 记录人员位置和实时的时间
Match_1H_count = zeros(1,40); %每场比赛上半场的计时
Match_2H_count = zeros(1,40); %每场比赛上半场的计时
unit_1H_time = zeros(1,40);%每场比赛上半场的单位时间每分钟多少(数据单位)
unit_2H_time = zeros(1,40);%每场比赛下半场的单位时间每分钟多少(数据单位)
for num = 3:(sum_pass_num(1,1)+1)
    if(~strcmp(cell2mat(txt(num,5)),cell2mat(txt((num-1),5))))
        Match_1H_count(1,1)=num-2;
        break;
    end
end
Match_2H_count(1,1) = sum_pass_num(1,1);

unit_1H_time(1,1) = number(Match_1H_count(1,1),6)/240;
unit_2H_time(1,1) = number(Match_2H_count(1,1),6)/240;

Huskies_pixel_info = cell(Huskies_team_num(1,1),8);%对所有队员在本场比赛进行一个信息提取
%列 1 x 坐标 数组
%列 2 y 坐标 数组
%列 3 x 坐标 变化率 数组
%列 4 y 坐标 变化率 数组
%列 5 人为标号
%列 6 坐标更新时刻
%列 7 信息数量
%列 8 事件记录器
Opponent_pixel_info = cell(Huskies_team_num(1,1),6);

%% 对队员进行标号
for i = 1:Huskies_team_num(1,1)      %Huskies球员编号
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
for i = 1:Opponent_team_num(1,1)      %Opponent球员编号
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

%% 冒泡排序 小的号码小
for i = 2 : Huskies_team_num(1,1)-1
    for j = Huskies_team_num(1,1) : -1 : i
        if Huskies_pixel_info{j,5} <  Huskies_pixel_info{j-1,5}
            num = Huskies_pixel_info{j,5};
            Huskies_pixel_info{j,5} = Huskies_pixel_info{j-1,5};
            Huskies_pixel_info{j-1,5} = num;
        end
    end
end
%小的号码小
for i = 2 : Opponent_team_num(1,1)-1
    for j = Opponent_team_num(1,1) : -1 : i
        if Opponent_pixel_info{j,5} <  Opponent_pixel_info{j-1,5}
            num = Opponent_pixel_info{j,5};
            Opponent_pixel_info{j,5} = Opponent_pixel_info{j-1,5};
            Opponent_pixel_info{j-1,5} = num;
        end
    end
end

%% 跟队员坐标信息
for num = 2:Match_1H_count(1,1)+1
    %% 传球者信息收集
    char_value = txt{num,3};                                %传球者
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
    if(strncmpi(cell2mat(txt(num,3)),cell2mat(storage(1,1)),4)) %传球者
        if mod(value,10)>=3
               for i = Huskies_team_num(1,1):-1:1
                    if Huskies_pixel_info{i,5} == value
                        Huskies_pixel_info{i,1} = [Huskies_pixel_info{i,1},number(num-1,8)];%队友传球者x
                        Huskies_pixel_info{i,2} = [Huskies_pixel_info{i,2},number(num-1,9)];%队友传球者y
                        Huskies_pixel_info{i,6} = [Huskies_pixel_info{i,6},number(num-1,6)];%队友传球时刻
                    end
               end 
        else
               for i = 1:Huskies_team_num(1,1)
                    if Huskies_pixel_info{i,5} == value
                        Huskies_pixel_info{i,1} = [Huskies_pixel_info{i,1},number(num-1,8)];%队友传球者x
                        Huskies_pixel_info{i,2} = [Huskies_pixel_info{i,2},number(num-1,9)];%队友传球者y
                        Huskies_pixel_info{i,6} = [Huskies_pixel_info{i,6},number(num-1,6)];%队友传球时刻
                    end
               end
        end
    else
         if mod(value,10)>=3
               for i = Opponent_team_num(1,1):-1:1
                    if Opponent_pixel_info{i,5} == value
                        Opponent_pixel_info{i,1} = [Opponent_pixel_info{i,1},number(num-1,8)];%对手传球者x
                        Opponent_pixel_info{i,2} = [Opponent_pixel_info{i,2},number(num-1,9)];%对手传球者y
                        Opponent_pixel_info{i,6} = [Opponent_pixel_info{i,6},number(num-1,6)];%对手传球时刻
                    end
               end 
        else
               for i = 1:Opponent_team_num(1,1)
                    if Opponent_pixel_info{i,5} == value
                        Opponent_pixel_info{i,1} = [Opponent_pixel_info{i,1},number(num-1,8)];%对手传球者x
                        Opponent_pixel_info{i,2} = [Opponent_pixel_info{i,2},number(num-1,9)];%对手传球者y
                        Opponent_pixel_info{i,6} = [Opponent_pixel_info{i,6},number(num-1,6)];%对手传球时刻
                    end
               end
        end       
    end
%% 接球者信息收集
    char_value = txt{num,4};                                %接球者
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
    if(strncmpi(cell2mat(txt(num,4)),cell2mat(storage(1,1)),4)) %接球者
        if mod(value,10)>=3
               for i = Huskies_team_num(1,1):-1:1
                    if Huskies_pixel_info{i,5} == value
                        Huskies_pixel_info{i,1} = [Huskies_pixel_info{i,1},number(num-1,10)];%队友接球者x
                        Huskies_pixel_info{i,2} = [Huskies_pixel_info{i,2},number(num-1,11)];%队友接球者y
                        Huskies_pixel_info{i,6} = [Huskies_pixel_info{i,6},number(num-1,6)];%队友传球时刻
                    end
               end 
        else
               for i = 1:Huskies_team_num(1,1)
                    if Huskies_pixel_info{i,5} == value
                        Huskies_pixel_info{i,1} = [Huskies_pixel_info{i,1},number(num-1,10)];%队友接球者x
                        Huskies_pixel_info{i,2} = [Huskies_pixel_info{i,2},number(num-1,11)];%队友接球者y
                        Huskies_pixel_info{i,6} = [Huskies_pixel_info{i,6},number(num-1,6)];%队友传球时刻
                    end
               end
        end
    else
         if mod(value,10)>=3
               for i = Opponent_team_num(1,1):-1:1
                    if Opponent_pixel_info{i,5} == value
                        Opponent_pixel_info{i,1} = [Opponent_pixel_info{i,1},number(num-1,10)];%对手接球者x
                        Opponent_pixel_info{i,2} = [Opponent_pixel_info{i,2},number(num-1,11)];%对手接球者y
                        Opponent_pixel_info{i,6} = [Opponent_pixel_info{i,6},number(num-1,6)];%对手传球时刻
                    end
               end 
        else
               for i = 1:Opponent_team_num(1,1)
                    if Opponent_pixel_info{i,5} == value
                        Opponent_pixel_info{i,1} = [Opponent_pixel_info{i,1},number(num-1,10)];%对手接球者x
                        Opponent_pixel_info{i,2} = [Opponent_pixel_info{i,2},number(num-1,11)];%对手接球者y
                        Opponent_pixel_info{i,6} = [Opponent_pixel_info{i,6},number(num-1,6)];%对手传球时刻
                    end
               end
        end       
    end
end

%% 信息数量计算以及时刻内各个点在x和y方向上的增量
%信息量计数
for i = 1:Huskies_team_num(1,1)      %Huskies球员编号
    char_value = Huskies_pixel_info{i,1};
    [x1,x2] = size(char_value);
    Huskies_pixel_info{i,7} = x2;  
end
for i = 1:Opponent_team_num(1,1)      %Opponent球员编号
    char_value = Opponent_pixel_info{i,1};
    [x1,x2] = size(char_value);
    Opponent_pixel_info{i,7} = x2;  
end
%增长率计算
for i = 1:Huskies_team_num(1,1)      %Huskies球员编号
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
for i = 1:Opponent_team_num(1,1)      %Opponent球员编号
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
%% 事件记录器初始化
for i = 1:Huskies_team_num(1,1)      %Huskies球员编号
    Huskies_pixel_info{i,8} = 1;
end
for i = 1:Opponent_team_num(1,1)      %Opponent球员编号
    Opponent_pixel_info{i,8} = 1;
end

%% 搜索相应的邻接矩阵信息
for num = 2:(sum_pass_num(1,1)+1)
    %% 传球者信息收集
    char_value = txt{num,3};                                %传球者
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
    if(strncmpi(cell2mat(txt(num,3)),cell2mat(storage(1,1)),4)) %传球者
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
    %% 接球者信息收集
    char_value = txt{num,4};                                %接球者
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
    if(strncmpi(cell2mat(txt(num,4)),cell2mat(storage(1,1)),4)) %接球者
        if mod(value,10)>=3
               for i = Huskies_team_num(1,1):-1:1
                    if Huskies_pixel_info{i,5} == value
                        Huskies_count_two = i ;    %记录Huskies DestinationPlayerID号码
                        Huskies_team_graph{1,1}(Huskies_count_one,Huskies_count_two) = Huskies_team_graph{1,1}(Huskies_count_one,Huskies_count_two) + 1;
                        Huskies_team_graph{1,1}(Huskies_count_two,Huskies_count_one) = Huskies_team_graph{1,1}(Huskies_count_two,Huskies_count_one) + 1;
                    end
               end 
        else
               for i = 1:Huskies_team_num(1,1)
                    if Huskies_pixel_info{i,5} == value
                        Huskies_count_two = i ;    %记录Huskies DestinationPlayerID号码
                        Huskies_team_graph{1,1}(Huskies_count_one,Huskies_count_two) = Huskies_team_graph{1,1}(Huskies_count_one,Huskies_count_two) + 1;
                        Huskies_team_graph{1,1}(Huskies_count_two,Huskies_count_one) = Huskies_team_graph{1,1}(Huskies_count_two,Huskies_count_one) + 1;
                    end
               end
        end
    else
         if mod(value,10)>=3
               for i = Opponent_team_num(1,1):-1:1
                    if Opponent_pixel_info{i,5} == value
                        Opponent_count_two = i;    %记录Opponent DestinationPlayerID号码
                        Opponent_team_graph{1,1}(Opponent_count_one,Opponent_count_two) = Opponent_team_graph{1,1}(Opponent_count_one,Opponent_count_two) + 1;
                        Opponent_team_graph{1,1}(Opponent_count_two,Opponent_count_one) = Opponent_team_graph{1,1}(Opponent_count_two,Opponent_count_one) + 1;
                    end
               end 
        else
               for i = 1:Opponent_team_num(1,1)
                    if Opponent_pixel_info{i,5} == value
                        Opponent_count_two = i;    %记录Opponent DestinationPlayerID号码
                        Opponent_team_graph{1,1}(Opponent_count_one,Opponent_count_two) = Opponent_team_graph{1,1}(Opponent_count_one,Opponent_count_two) + 1;
                        Opponent_team_graph{1,1}(Opponent_count_two,Opponent_count_one) = Opponent_team_graph{1,1}(Opponent_count_two,Opponent_count_one) + 1;
                    end
               end
        end       
    end
end
%% 球员坐标变量初始化
Huskies_map_x = zeros(1,Huskies_team_num(1,1));
Huskies_map_y = zeros(1,Huskies_team_num(1,1));
Opponent_map_x = zeros(1,Opponent_team_num(1,1));
Opponent_map_y = zeros(1,Opponent_team_num(1,1));

[count_numeber,count_numeber]=size(Huskies_team_graph{1,1});

for i = 1:Huskies_team_num(1,1)      %Huskies球员编号
    for num = 1 : Huskies_pixel_info{i,7}
        Huskies_map_x(1,i) = Huskies_map_x(1,i) + Huskies_pixel_info{i,1}(1,num);
    end
    Huskies_map_x(1,i) = Huskies_map_x(1,i)/Huskies_pixel_info{i,7};
end

for i = 1:Opponent_team_num(1,1)      %Huskies球员编号
    for num = 1 : Opponent_pixel_info{i,7}
        Opponent_map_x(1,i) = Opponent_map_x(1,i) + Opponent_pixel_info{i,1}(1,num);
    end
    Opponent_map_x(1,i) = Opponent_map_x(1,i)/Opponent_pixel_info{i,7};
end

%% 队员传球紧密度初始化
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
%% 搜索相应的传球紧密度矩阵信息并显示出来
for num = 2:(sum_pass_num(1,1)+1)
    %% 传球者信息收集
    char_value = txt{num,3};                                %传球者
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
    if(strncmpi(cell2mat(txt(num,3)),cell2mat(storage(1,1)),4)) %传球者
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
    %% 接球者信息收集
    char_value = txt{num,4};                                %接球者
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
    if(strncmpi(cell2mat(txt(num,4)),cell2mat(storage(1,1)),4)) %接球者
        if mod(value,10)>=3
               for i = Huskies_team_num(1,1):-1:1
                    if Huskies_pixel_info{i,5} == value
                        Huskies_count_two = i ;    %记录Huskies DestinationPlayerID号码
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
                        Huskies_count_two = i ;    %记录Huskies DestinationPlayerID号码
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
                        Opponent_count_two = i;    %记录Opponent DestinationPlayerID号码
                        if num == 2
                            Opponent_Close_num = updata(Opponent_team_num(1,1),Opponent_Close_num,Opponent_count_one ...
                                ,Opponent_count_two,0,number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),s);
                        else
                            Opponent_Close_num = updata(Opponent_team_num(1,1),Opponent_Close_num,Opponent_count_one ...
                                        ,Opponent_count_two,number(num-2,6),number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),s);                            
                        end
                        Opponent_graph_z = Opponent_Close_num(Opponent_graph_x,Opponent_graph_y);
%                         figure(2); mesh(Opponent_graph_x, Opponent_graph_y, Opponent_graph_z); %画三维网格曲面
%                         title('mesh'); xlabel('x'); ylabel('y'); zlabel('z');
%                         pause(0.01);                       
                    end
               end 
        else
               for i = 1:Opponent_team_num(1,1)
                    if Opponent_pixel_info{i,5} == value
                        Opponent_count_two = i;    %记录Opponent DestinationPlayerID号码
                        if num == 2
                            Opponent_Close_num = updata(Opponent_team_num(1,1),Opponent_Close_num,Opponent_count_one ...
                                ,Opponent_count_two,0,number(num-1,6),0.01,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),s);
                        else
                            Opponent_Close_num = updata(Opponent_team_num(1,1),Opponent_Close_num,Opponent_count_one ...
                                        ,Opponent_count_two,number(num-2,6),number(num-1,6),0.01,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),s);                            
                        end
                        Opponent_graph_z = Opponent_Close_num(Opponent_graph_x,Opponent_graph_y);
%                         figure(2); mesh(Opponent_graph_x, Opponent_graph_y, Opponent_graph_z); %画三维网格曲面
%                         title('mesh'); xlabel('x'); ylabel('y'); zlabel('z');
%                         pause(0.01);                         
                    end
               end
        end       
    end
end





