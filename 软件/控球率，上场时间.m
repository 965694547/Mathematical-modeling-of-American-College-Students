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
%%初始化数据2
[number_full,txt_full,raw_full] = xlsread('C:/Users/GZF/Desktop/fullevents.xlsx');

[hang_full,lie_full] = size(txt_full);

sum_round_num=zeros(1,40);%回合数矩阵（第一场）
EventType=cell(40,40);%用于事件的种类


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

%%统计第一场回合数
for num = 1:hang_full
    if(number_full(num,1) == 1)
       sum_round_num(1,1)=sum_round_num(1,1)+1;
    else
        break;
    end
end

%% 统计事件状态
for num = 2:(sum_round_num(1,1)+1)
        for i = 1:40
            if(~isempty(cell2mat(EventType(1,i))))%判断是否为空
                if(strcmp(cell2mat(txt_full(num,7)),cell2mat(EventType(1,i))))%判断是否与其中所有项相等
                    break;%相等退出     
                end
            else
                EventType(1,i) = txt_full(num,7);
                break;%为空保存
            end
        end
end

%%统计球员第一场上场时间
for num=1:(sum_round_num(1,1)+1)
    Huskies_team_state(2,num)={[2888000]};
    Opponent_team_state(2,num)={[2888000]};%所有有名字的球员都上过场，初始值为2888000
end

for num = 2:(sum_round_num(1,1)+1)
    if(strcmp(cell2mat(txt_full(num,7)),cell2mat(EventType(1,10))))%判断是否为替换下场
        if(strncmpi(cell2mat(txt_full(num,3)),cell2mat(storage(1,1)),4))
        %成员为队友方 
            for i = 1:40
                if(strcmp(cell2mat(txt_full(num,3)),cell2mat(Huskies_team_state(1,i)))) %判断被替换的人
                    Huskies_team_state(2,i)={number_full(num,6)-0};%%%%%%%
                    break;
                end
            end
            for i = 1:40
                if(strcmp(cell2mat(txt_full(num,4)),cell2mat(Huskies_team_state(1,i)))) %判断替换的人
                    Huskies_team_state(2,i)={288000-number_full(num,6)};%%%%%%%%%%
                    break;
                end
            end
        else
            for i = 1:40
                if(strcmp(cell2mat(txt_full(num,3)),cell2mat(Huskies_team_state(1,i)))) %判断被替换的人
                    Opponent_team_state(2,i)={number_full(num,6)-0};%%%%%%%%%%%%
                    break;
                end
            end
            for i = 1:40
                if(strcmp(cell2mat(txt_full(num,4)),cell2mat(Opponent_team_state(1,i)))) %判断替换的人
                    Opponent_team_state(2,i)={288000-number_full(num,6)};%%%%%%%
                    break;
                end
            end
        end
    end
end
%% 判断第一场比赛的总传球数
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

%%统计全赛季友军的控球率
control=zeros(40,40);%%控球时长
for target=1:38

sum_round_num=zeros(1,40);%回合数矩阵（第一场）
first=1;

for num = 1:59271
    if(number_full(num,1) == target)
       sum_round_num(1,1)=sum_round_num(1,1)+1;
    end
end
for num = 1:59271
    if(number_full(num,1) == target)
       sum_round_num(1,2)=num;
        break;
    end
end
%%传球成功率与控球率（全赛季）

 if(strcmp(cell2mat(txt_full(sum_round_num(1,2)+1,2)),cell2mat(storage(1,1))))
        last_state=0;%%0代表上一次持球为己方，1代表上一次持球为对手
    else
        last_state=1;%%0代表上一次持球为己方，1代表上一次持球为对手
end

last_time=0;%%控球时间长度

for num = sum_round_num(1,2)+1:(sum_round_num(1,2)+sum_round_num(1,1)-1)
     if(~(strncmpi(cell2mat(txt_full(num,3)),cell2mat(storage(1,1)),4))&&(last_state==0)) %成员为队手方,上次持球为对队友
         control(target,1)=number_full(num-1,6)-last_time+control(target,1);
         last_state=1;
     end
      if(strncmpi(cell2mat(txt_full(num,3)),cell2mat(storage(1,1)),4)&&(last_state==1))
          last_time=number_full(num,6);
           last_state=0;
      end
end

control(target,2)=control(target,1)/2880
     
end
        
%%传球成功次数，传球失败次数
last_state=0;
pass=zeros(4,14);
 for num = 2:(sum_pass_num(1,1)+1)
    if(strncmpi(cell2mat(txt(num,3)),cell2mat(storage(1,1)),4))
        for i=1:14
            if(strcmp(cell2mat(txt(num,3)),cell2mat(Huskies_team_state(1,i))))
                pass(1,i)=pass(1,i)+1;
                break;
            end
        end
    else
         for i=1:14
            if(strcmp(cell2mat(txt(num,3)),cell2mat(Opponent_team_state(1,i))))
                pass(2,i)=pass(2,i)+1;
                break;
            end
         end
    end
     if(~(strncmpi(cell2mat(txt_full(num,3)),cell2mat(storage(1,1)),4))&&(last_state==0)) %成员为队手方,上次持球为对队友
         for i=1:14
            if(strcmp(cell2mat(txt(num-1,3)),cell2mat(Huskies_team_state(1,i))))
                pass(3,i)=pass(3,i)+1;
                break;
            end
        end
         last_state=1;
     end
      if(strncmpi(cell2mat(txt_full(num,3)),cell2mat(storage(1,1)),4)&&(last_state==1))
          for i=1:14
            if(strcmp(cell2mat(txt(num-1,3)),cell2mat(Huskies_team_state(1,i))))
                pass(4,i)=pass(4,i)+1;
                break;
            end
        end
           last_state=0;
      end
 end
    
%strncmpi(cell2mat(txt(2,3)),cell2mat(storage(1,1)),10)
%storage(1,1)=cellstr('aaaaaa');
% strcmp(cell2mat(txt(4,2)),cell2mat(txt(2,2)))
%isempty(cell2mat(storage(1,1)))