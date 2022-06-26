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
%%��ʼ������2
[number_full,txt_full,raw_full] = xlsread('C:/Users/GZF/Desktop/fullevents.xlsx');

[hang_full,lie_full] = size(txt_full);

sum_round_num=zeros(1,40);%�غ������󣨵�һ����
EventType=cell(40,40);%�����¼�������


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

%%ͳ�Ƶ�һ���غ���
for num = 1:hang_full
    if(number_full(num,1) == 1)
       sum_round_num(1,1)=sum_round_num(1,1)+1;
    else
        break;
    end
end

%% ͳ���¼�״̬
for num = 2:(sum_round_num(1,1)+1)
        for i = 1:40
            if(~isempty(cell2mat(EventType(1,i))))%�ж��Ƿ�Ϊ��
                if(strcmp(cell2mat(txt_full(num,7)),cell2mat(EventType(1,i))))%�ж��Ƿ����������������
                    break;%����˳�     
                end
            else
                EventType(1,i) = txt_full(num,7);
                break;%Ϊ�ձ���
            end
        end
end

%%ͳ����Ա��һ���ϳ�ʱ��
for num=1:(sum_round_num(1,1)+1)
    Huskies_team_state(2,num)={[2888000]};
    Opponent_team_state(2,num)={[2888000]};%���������ֵ���Ա���Ϲ�������ʼֵΪ2888000
end

for num = 2:(sum_round_num(1,1)+1)
    if(strcmp(cell2mat(txt_full(num,7)),cell2mat(EventType(1,10))))%�ж��Ƿ�Ϊ�滻�³�
        if(strncmpi(cell2mat(txt_full(num,3)),cell2mat(storage(1,1)),4))
        %��ԱΪ���ѷ� 
            for i = 1:40
                if(strcmp(cell2mat(txt_full(num,3)),cell2mat(Huskies_team_state(1,i)))) %�жϱ��滻����
                    Huskies_team_state(2,i)={number_full(num,6)-0};%%%%%%%
                    break;
                end
            end
            for i = 1:40
                if(strcmp(cell2mat(txt_full(num,4)),cell2mat(Huskies_team_state(1,i)))) %�ж��滻����
                    Huskies_team_state(2,i)={288000-number_full(num,6)};%%%%%%%%%%
                    break;
                end
            end
        else
            for i = 1:40
                if(strcmp(cell2mat(txt_full(num,3)),cell2mat(Huskies_team_state(1,i)))) %�жϱ��滻����
                    Opponent_team_state(2,i)={number_full(num,6)-0};%%%%%%%%%%%%
                    break;
                end
            end
            for i = 1:40
                if(strcmp(cell2mat(txt_full(num,4)),cell2mat(Opponent_team_state(1,i)))) %�ж��滻����
                    Opponent_team_state(2,i)={288000-number_full(num,6)};%%%%%%%
                    break;
                end
            end
        end
    end
end
%% �жϵ�һ���������ܴ�����
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

%%ͳ��ȫ�����Ѿ��Ŀ�����
control=zeros(40,40);%%����ʱ��
for target=1:38

sum_round_num=zeros(1,40);%�غ������󣨵�һ����
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
%%����ɹ���������ʣ�ȫ������

 if(strcmp(cell2mat(txt_full(sum_round_num(1,2)+1,2)),cell2mat(storage(1,1))))
        last_state=0;%%0������һ�γ���Ϊ������1������һ�γ���Ϊ����
    else
        last_state=1;%%0������һ�γ���Ϊ������1������һ�γ���Ϊ����
end

last_time=0;%%����ʱ�䳤��

for num = sum_round_num(1,2)+1:(sum_round_num(1,2)+sum_round_num(1,1)-1)
     if(~(strncmpi(cell2mat(txt_full(num,3)),cell2mat(storage(1,1)),4))&&(last_state==0)) %��ԱΪ���ַ�,�ϴγ���Ϊ�Զ���
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
        
%%����ɹ�����������ʧ�ܴ���
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
     if(~(strncmpi(cell2mat(txt_full(num,3)),cell2mat(storage(1,1)),4))&&(last_state==0)) %��ԱΪ���ַ�,�ϴγ���Ϊ�Զ���
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