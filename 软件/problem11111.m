clc,clear;

%% Initialization data
[number,txt,raw] = xlsread('C:/Users/Administrator/Desktop/bisai/2020_Problem_D_DATA/passingevents.csv');
storage = cell(1,40);
storage_num = 0;
[x1,x2] = size(storage);
[hang,lie] = size(txt);
j = 0;
sum_pass_num = zeros(1,40);%Total passes matrix
Huskies_pass_num = zeros(1,40);%HuskiesPass number matrix
Opponent_pass_num = zeros(1,40);%OpponentPass number matrix

Huskies_team_state = cell(40,40);%It is used to record the playing situation of each home player, and the number of games is listed as the player name
Opponent_team_state = cell(40,40);%It is used to record the playing situation of each home player, and the number of games is listed as the player name

Huskies_team_num = zeros(1,40);%Used to record the player number of each game as a game 
Opponent_team_num = zeros(1,40);%Used to record the player number of each game as a game 
%% Field graph initialization
Huskies_team_graph = cell(1,40); %The graph storage variable of each game passing is listed as the number of games
Huskies_team_graph(1,1) = {zeros(Huskies_team_num(1,1),Huskies_team_num(1,1))};%Huskies adjacency matrix

Opponent_team_graph = cell(1,40); %The graph storage variable of each game passing is listed as the number of games
Opponent_team_graph(1,1) = {zeros(Opponent_team_num(1,1),Opponent_team_num(1,1))};%Opponentadjacency matrix

Huskies_count_one = 0;  %Huskies OriginPlayerID Enumeration variables
Huskies_count_two = 0;  %Huskies DestinationPlayerID Enumeration variables

Opponent_count_one = 0; %Opponent OriginPlayerID Enumeration variables
Opponent_count_two = 0; %Opponent DestinationPlayerID Enumeration variables
%% Take out the team name
for num = 2:hang
    for i = 1:x2
        if(num > 2)%Judge whether it is the first time
            if(~isempty(cell2mat(storage(1,i))))%Judge whether it is empty
                if(strcmp(cell2mat(txt(num,2)),cell2mat(storage(1,i))))%Judge whether it is equal to all of them
                    break;%Equal exit     
                end
            else
                storage(1,i) = txt(num,2);
                break;%Empty storage
            end
        else      %It is the first assignment exit
            storage(1,1) = txt(num,2);
            break;
        end
    end
end 

%% Judge the number of passes in each game
for i = 1:38
    if i == 1
        for num = 1:hang-1
            if(number(num,1) == i)
               sum_pass_num(1,i)=sum_pass_num(1,i)+1;
            else
                j = sum_pass_num(1,i);
                break;
            end
        end
    else
        for num = j+1:hang-1
            if(number(num,1) == i)
               sum_pass_num(1,i)=sum_pass_num(1,i)+1;
            else
                j = j + sum_pass_num(1,i);
                break;
            end
        end        
    end
    
end

%% Count the total passes of Huskies and corresponding opponents
j = 0;
for i = 1:38
    for num = 2:(sum_pass_num(1,i)+1)
        if i == 1
            if(strcmp(cell2mat(txt(num,2)),cell2mat(storage(1,1))))
                Huskies_pass_num(1,1)=Huskies_pass_num(1,1)+1;
            else
                Opponent_pass_num(1,1)=Opponent_pass_num(1,1)+1;
            end
        else
            if(strcmp(cell2mat(txt((num-1+j),2)),cell2mat(storage(1,1))))
                Huskies_pass_num(1,i)=Huskies_pass_num(1,i)+1;
            else
                Opponent_pass_num(1,i)=Opponent_pass_num(1,i)+1;
            end            
        end
    end
    j = j + sum_pass_num(1,i);
end

%% Statistics of players
j = 0;
for count = 1:38
    if count == 1
        for num = 2:(sum_pass_num(1,1)+1)
            if(strncmpi(cell2mat(txt(num,3)),cell2mat(storage(1,1)),4))
                %Members are teammates 
                for i = 1:40
                    if(~isempty(cell2mat(Huskies_team_state(1,i))))%Judge whether it is empty
                        if(strcmp(cell2mat(txt(num,3)),cell2mat(Huskies_team_state(1,i))))%Judge whether it is equal to all of them
                            break;%Equal exit     
                        end
                    else
                        Huskies_team_state(1,i) = txt(num,3);
                        break;%Empty storage
                    end
                 end
            else
                %Members are counterparties
                 for i = 1:40
                    if(~isempty(cell2mat(Opponent_team_state(1,i))))%Judge whether it is empty
                        if(strcmp(cell2mat(txt(num,3)),cell2mat(Opponent_team_state(1,i))))%Judge whether it is equal to all of them
                            break;%Equal exit     
                        end
                    else
                        Opponent_team_state(1,i) = txt(num,3);
                        break;%Empty storage
                    end     
                 end       
            end  
        end
    else
        for num = 2:(sum_pass_num(1,count)+1)
            if(strncmpi(cell2mat(txt((num+j),3)),cell2mat(storage(1,1)),4))
                %Members are teammates 
                for i = 1:40
                    if(~isempty(cell2mat(Huskies_team_state(count,i))))%Judge whether it is empty
                        if(strcmp(cell2mat(txt((num+j),3)),cell2mat(Huskies_team_state(count,i))))%Judge whether it is equal to all of them
                            break;%Equal exit     
                        end
                    else
                        Huskies_team_state(count,i) = txt((num+j),3);
                        break;%Empty storage
                    end
                 end
            else
                %Members are counterparties
                 for i = 1:40
                    if(~isempty(cell2mat(Opponent_team_state(count,i))))%Judge whether it is empty
                        if(strcmp(cell2mat(txt((num+j),3)),cell2mat(Opponent_team_state(count,i))))%Judge whether it is equal to all of them
                            break;%Equal exit     
                        end
                    else
                        Opponent_team_state(count,i) = txt((num+j),3);
                        break;%Empty storage
                    end     
                 end       
            end  
        end        
    end
    j = j + sum_pass_num(1,count);
end

%% Player count
for count = 1:38
    for i = 1:40      %Huskies player count
        if(~isempty(cell2mat(Huskies_team_state(count,i))))%Judge whether it is empty
            Huskies_team_num(1,count) = Huskies_team_num(1,count)+1;
        else
           break;
        end
    end
end
for count = 1:38
    for i = 1:40      %Opponent player count
        if(~isempty(cell2mat(Opponent_team_state(count,i))))%Judge whether it is empty
            Opponent_team_num(1,count) = Opponent_team_num(1,count)+1;
        else
           break;
        end
    end
end
%% Field graph initialization
Huskies_team_graph = cell(1,40); %The graph storage variable of each game passing is listed as the number of games
Opponent_team_graph = cell(1,40); %The graph storage variable of each game passing is listed as the number of games
for count = 1:38
    Huskies_team_graph(1,count) = {zeros(Huskies_team_num(1,count),Huskies_team_num(1,count))};%Huskies adjacency matrix
    Opponent_team_graph(1,count) = {zeros(Opponent_team_num(1,count),Opponent_team_num(1,count))};%Response adjacency matrix
end
Huskies_count_one = zeros(1,40);  %Huskies originplayerid count variable
Huskies_count_two = zeros(1,40);  %Huskies destinationplayerid count variable

Opponent_count_one = zeros(1,40); %Response originplayerid count variable
Opponent_count_two = zeros(1,40); %Response destinationplayerid count variable


%% Record personnel location and real-time time time
Match_1H_count = zeros(1,40); %Timing of the first half of each game
Match_2H_count = zeros(1,40); %Timing of the first half of each game
unit_1H_time = zeros(1,40);%What is the unit time per minute in the first half of each game (data unit)
unit_2H_time = zeros(1,40);%What is the unit time per minute in the second half of each game (data unit)
j = 0;
for count = 1:38
    if count == 1
        for num = 3:(sum_pass_num(1,1)+1)
            if(~strcmp(cell2mat(txt(num,5)),cell2mat(txt((num-1),5))))
                Match_1H_count(1,1)=num-2;
                break;
            end
        end
        Match_2H_count(1,1) = sum_pass_num(1,1);

        unit_1H_time(1,1) = number(Match_1H_count(1,1),6)/240;
        unit_2H_time(1,1) = number(Match_2H_count(1,1),6)/240;
    else
         for num = 3:sum_pass_num(1,count)
            if(~strcmp(cell2mat(txt(num+j,5)),cell2mat(txt((num+j-1),5))))
                Match_1H_count(1,count)=num-2;
                break;
            end
        end
        Match_2H_count(1,count) = sum_pass_num(1,count);

        unit_1H_time(1,count) = number(j+Match_1H_count(1,count),6)/240;
        unit_2H_time(1,count) = number(j+Match_2H_count(1,count),6)/240;       
    end
    j = j + sum_pass_num(1,count);
end

Huskies_pixel_info = cell(1,40);
for count = 1:38
    Huskies_pixel_info{1,count} = cell(Huskies_team_num(1,count),8);%One information extraction for all players in this game
end

Opponent_pixel_info = cell(1,40);
for count = 1:38
    Opponent_pixel_info{1,count} = cell(Huskies_team_num(1,count),8);
end

%Column 1 x coordinate array

%Column 2 y coordinate array

%Column 3 x coordinate rate of change array

%Column 4 y-coordinate change rate array

%Column 5 is the label

%Column 6 coordinate update time

%Column 7 number of messages

%Column 8 event recorder
%% Label team members
for count = 1:38
        for i = 1:Huskies_team_num(1,count)      %Huskies player number
            char_value = Huskies_team_state{count,i};
            [x1,x2] = size(char_value);
            switch char_value(1,x2-1)
                case 'G'
                    Huskies_pixel_info{1,count}(i,5) = {40};
                case 'D'
                    Huskies_pixel_info{1,count}(i,5) = {30};
                case 'M'
                    Huskies_pixel_info{1,count}(i,5) = {20};            
                case 'F'
                    Huskies_pixel_info{1,count}(i,5) = {10};
            end
            switch char_value(1,x2)
                case '1'
                    Huskies_pixel_info{1,count}{i,5} = Huskies_pixel_info{1,count}{i,5}+1;
                case '2'
                    Huskies_pixel_info{1,count}{i,5} = Huskies_pixel_info{1,count}{i,5}+2;
                case '3'
                    Huskies_pixel_info{1,count}{i,5} = Huskies_pixel_info{1,count}{i,5}+3;            
                case '4'
                    Huskies_pixel_info{1,count}{i,5} = Huskies_pixel_info{1,count}{i,5}+4;
                case '5'
                    Huskies_pixel_info{1,count}{i,5} = Huskies_pixel_info{1,count}{i,5}+5;
            end    
        end
        for i = 1:Opponent_team_num(1,count)      %Opponent player number
            char_value = Opponent_team_state{count,i};
            [x1,x2] = size(char_value);
            switch char_value(1,x2-1)
                case 'G'
                    Opponent_pixel_info{1,count}(i,5) = {40};
                case 'D'
                    Opponent_pixel_info{1,count}(i,5) = {30};
                case 'M'
                    Opponent_pixel_info{1,count}(i,5) = {20};            
                case 'F'
                    Opponent_pixel_info{1,count}(i,5) = {10};
            end
            switch char_value(1,x2)
                case '1'
                    Opponent_pixel_info{1,count}{i,5} = Opponent_pixel_info{1,count}{i,5}+1;
                case '2'
                    Opponent_pixel_info{1,count}{i,5} = Opponent_pixel_info{1,count}{i,5}+2;
                case '3'
                    Opponent_pixel_info{1,count}{i,5} = Opponent_pixel_info{1,count}{i,5}+3;            
                case '4'
                    Opponent_pixel_info{1,count}{i,5} = Opponent_pixel_info{1,count}{i,5}+4;
                case '5'
                    Opponent_pixel_info{1,count}{i,5} = Opponent_pixel_info{1,count}{i,5}+5;
            end    
        end
end

%% Bubble sort small number small
for count = 1:38
        for i = 2 : Huskies_team_num(1,count)-1
            for j = Huskies_team_num(1,count) : -1 : i
                if Huskies_pixel_info{1,count}{j,5} <  Huskies_pixel_info{1,count}{j-1,5}
                    num = Huskies_pixel_info{1,count}{j,5};
                    Huskies_pixel_info{1,count}{j,5} = Huskies_pixel_info{1,count}{j-1,5};
                    Huskies_pixel_info{1,count}{j-1,5} = num;
                end
            end
        end

        for i = 2 : Opponent_team_num(1,count)-1
            for j = Opponent_team_num(1,count) : -1 : i
                if Opponent_pixel_info{1,count}{j,5} <  Opponent_pixel_info{1,count}{j-1,5}
                    num = Opponent_pixel_info{1,count}{j,5};
                    Opponent_pixel_info{1,count}{j,5} = Opponent_pixel_info{1,count}{j-1,5};
                    Opponent_pixel_info{1,count}{j-1,5} = num;
                end
            end
        end
end

%% Coordinate information with team members
j = 0;
for count = 1:38
    if count == 1
        for num = 2:Match_2H_count(1,count)+1
            char_value = txt{num,3};                                %Pass player
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
                case '5'
                        value = value+5; 
            end
            if(strncmpi(cell2mat(txt(num,3)),cell2mat(storage(1,1)),4)) %Pass player
                if mod(value,10)>=3
                       for i = Huskies_team_num(1,count):-1:1
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_pixel_info{1,count}{i,1} = [Huskies_pixel_info{1,count}{i,1},number(num-1,8)];%Teammate passer x
                                Huskies_pixel_info{1,count}{i,2} = [Huskies_pixel_info{1,count}{i,2},number(num-1,9)];%Teammate passer y
                                Huskies_pixel_info{1,count}{i,6} = [Huskies_pixel_info{1,count}{i,6},number(num-1,6)];%Teammate passer time
                                break;
                            end
                       end 
                else
                       for i = 1:Huskies_team_num(1,count)
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_pixel_info{1,count}{i,1} = [Huskies_pixel_info{1,count}{i,1},number(num-1,8)];%Teammate passer x
                                Huskies_pixel_info{1,count}{i,2} = [Huskies_pixel_info{1,count}{i,2},number(num-1,9)];%Teammate passer y
                                Huskies_pixel_info{1,count}{i,6} = [Huskies_pixel_info{1,count}{i,6},number(num-1,6)];%Teammate passer time
                                break;
                            end
                       end
                end
            else
                 if mod(value,10)>=3
                       for i = Opponent_team_num(1,count):-1:1
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_pixel_info{1,count}{i,1} = [Opponent_pixel_info{1,count}{i,1},number(num-1,8)];%Opponent passer x
                                Opponent_pixel_info{1,count}{i,2} = [Opponent_pixel_info{1,count}{i,2},number(num-1,9)];%Opponent passer y
                                Opponent_pixel_info{1,count}{i,6} = [Opponent_pixel_info{1,count}{i,6},number(num-1,6)];%Opponent passer time
                                break;
                            end
                       end 
                else
                       for i = 1:Opponent_team_num(1,count)
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_pixel_info{1,count}{i,1} = [Opponent_pixel_info{1,count}{i,1},number(num-1,8)];%%Opponent passer x
                                Opponent_pixel_info{1,count}{i,2} = [Opponent_pixel_info{1,count}{i,2},number(num-1,9)];%%Opponent passer y
                                Opponent_pixel_info{1,count}{i,6} = [Opponent_pixel_info{1,count}{i,6},number(num-1,6)];%Opponent passer time
                                break;
                            end
                       end
                end       
            end
            char_value = txt{num,4};                                %Receiver
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
                case '5' 
                        value = value+5;
            end
            if(strncmpi(cell2mat(txt(num,4)),cell2mat(storage(1,1)),4)) %Pass player
                if mod(value,10)>=3
                       for i = Huskies_team_num(1,count):-1:1
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_pixel_info{1,count}{i,1} = [Huskies_pixel_info{1,count}{i,1},number(num-1,10)];%Teammate passer x
                                Huskies_pixel_info{1,count}{i,2} = [Huskies_pixel_info{1,count}{i,2},number(num-1,11)];%Teammate passer y
                                Huskies_pixel_info{1,count}{i,6} = [Huskies_pixel_info{1,count}{i,6},number(num-1,6)];%Passing time of teammates
                                break;
                            end
                       end 
                else
                       for i = 1:Huskies_team_num(1,count)
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_pixel_info{1,count}{i,1} = [Huskies_pixel_info{1,count}{i,1},number(num-1,10)];%Teammate passer x
                                Huskies_pixel_info{1,count}{i,2} = [Huskies_pixel_info{1,count}{i,2},number(num-1,11)];%Teammate passer y
                                Huskies_pixel_info{1,count}{i,6} = [Huskies_pixel_info{1,count}{i,6},number(num-1,6)];%Passing time of teammates
                                break;
                            end
                       end
                end
            else
                 if mod(value,10)>=3
                       for i = Opponent_team_num(1,count):-1:1
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_pixel_info{1,count}{i,1} = [Opponent_pixel_info{1,count}{i,1},number(num-1,10)];%Opponent passer x
                                Opponent_pixel_info{1,count}{i,2} = [Opponent_pixel_info{1,count}{i,2},number(num-1,11)];%Opponent passer y
                                Opponent_pixel_info{1,count}{i,6} = [Opponent_pixel_info{1,count}{i,6},number(num-1,6)];%Opponent passing time
                                break;
                            end
                       end 
                else
                       for i = 1:Opponent_team_num(1,count)
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_pixel_info{1,count}{i,1} = [Opponent_pixel_info{1,count}{i,1},number(num-1,10)];%Opponent passer x
                                Opponent_pixel_info{1,count}{i,2} = [Opponent_pixel_info{1,count}{i,2},number(num-1,11)];%Opponent passer y
                                Opponent_pixel_info{1,count}{i,6} = [Opponent_pixel_info{1,count}{i,6},number(num-1,6)];%Opponent passing time
                                break;
                            end
                       end
                end       
            end
        end
    else
        for num = 2:Match_2H_count(1,count)+1
            char_value = txt{num+j,3};                                %Pass player
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
                case '5'
                        value = value+5;
            end
            if(strncmpi(cell2mat(txt(num+j,3)),cell2mat(storage(1,1)),4)) %Pass player
                if mod(value,10)>=3
                       for i = Huskies_team_num(1,count):-1:1
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_pixel_info{1,count}{i,1} = [Huskies_pixel_info{1,count}{i,1},number(num-1+j,8)];%Teammate passer x
                                Huskies_pixel_info{1,count}{i,2} = [Huskies_pixel_info{1,count}{i,2},number(num-1+j,9)];%Teammate passer y
                                Huskies_pixel_info{1,count}{i,6} = [Huskies_pixel_info{1,count}{i,6},number(num-1+j,6)];%Passing time of teammates
                                break;
                            end
                       end 
                else
                       for i = 1:Huskies_team_num(1,count)
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_pixel_info{1,count}{i,1} = [Huskies_pixel_info{1,count}{i,1},number(num-1+j,8)];%Teammate passer x
                                Huskies_pixel_info{1,count}{i,2} = [Huskies_pixel_info{1,count}{i,2},number(num-1+j,9)];%Teammate passer y
                                Huskies_pixel_info{1,count}{i,6} = [Huskies_pixel_info{1,count}{i,6},number(num-1+j,6)];%Passing time of teammates
                                break;
                            end
                       end
                end
            else
                 if mod(value,10)>=3
                       for i = Opponent_team_num(1,count):-1:1
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_pixel_info{1,count}{i,1} = [Opponent_pixel_info{1,count}{i,1},number(num-1+j,8)];
                                Opponent_pixel_info{1,count}{i,2} = [Opponent_pixel_info{1,count}{i,2},number(num-1+j,9)];
                                Opponent_pixel_info{1,count}{i,6} = [Opponent_pixel_info{1,count}{i,6},number(num-1+j,6)];
                                break;
                            end
                       end 
                else
                       for i = 1:Opponent_team_num(1,count)
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_pixel_info{1,count}{i,1} = [Opponent_pixel_info{1,count}{i,1},number(num-1+j,8)];
                                Opponent_pixel_info{1,count}{i,2} = [Opponent_pixel_info{1,count}{i,2},number(num-1+j,9)];
                                Opponent_pixel_info{1,count}{i,6} = [Opponent_pixel_info{1,count}{i,6},number(num-1+j,6)];
                                break;
                            end
                       end
                end       
            end
            char_value = txt{num+j,4};                               
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
                case '5'
                        value = value+5;
            end
             if(strncmpi(cell2mat(txt(num+j,4)),cell2mat(storage(1,1)),4)) 
                if mod(value,10)>=3
                       for i = Huskies_team_num(1,count):-1:1
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_pixel_info{1,count}{i,1} = [Huskies_pixel_info{1,count}{i,1},number(num-1+j,10)];
                                Huskies_pixel_info{1,count}{i,2} = [Huskies_pixel_info{1,count}{i,2},number(num-1+j,11)];
                                Huskies_pixel_info{1,count}{i,6} = [Huskies_pixel_info{1,count}{i,6},number(num-1+j,6)];
                                break;
                            end
                       end 
                else
                       for i = 1:Huskies_team_num(1,count)
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_pixel_info{1,count}{i,1} = [Huskies_pixel_info{1,count}{i,1},number(num-1+j,10)];
                                Huskies_pixel_info{1,count}{i,2} = [Huskies_pixel_info{1,count}{i,2},number(num-1+j,11)];
                                Huskies_pixel_info{1,count}{i,6} = [Huskies_pixel_info{1,count}{i,6},number(num-1+j,6)];
                                break;
                            end
                       end
                end
            else
                 if mod(value,10)>=3
                       for i = Opponent_team_num(1,count):-1:1
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_pixel_info{1,count}{i,1} = [Opponent_pixel_info{1,count}{i,1},number(num-1+j,10)];
                                Opponent_pixel_info{1,count}{i,2} = [Opponent_pixel_info{1,count}{i,2},number(num-1+j,11)];
                                Opponent_pixel_info{1,count}{i,6} = [Opponent_pixel_info{1,count}{i,6},number(num-1+j,6)];
                                break;
                            end
                       end 
                else
                       for i = 1:Opponent_team_num(1,count)
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_pixel_info{1,count}{i,1} = [Opponent_pixel_info{1,count}{i,1},number(num-1+j,10)];
                                Opponent_pixel_info{1,count}{i,2} = [Opponent_pixel_info{1,count}{i,2},number(num-1+j,11)];
                                Opponent_pixel_info{1,count}{i,6} = [Opponent_pixel_info{1,count}{i,6},number(num-1+j,6)];
                                break;
                            end
                       end
                end       
            end           
        end        
    end
    j = j + Match_2H_count(1,count);
end

%% Calculation of information quantity and increment of each point in X and Y direction in time
%Information count
for count = 1:38
    for i = 1:Huskies_team_num(1,count)      %Huskies player number
        char_value = Huskies_pixel_info{1,count}{i,1};
        [x1,x2] = size(char_value);
        Huskies_pixel_info{1,count}{i,7} = x2;  
    end
    for i = 1:Opponent_team_num(1,count)      %Opponent player number
        char_value = Opponent_pixel_info{1,count}{i,1};
        [x1,x2] = size(char_value);
        Opponent_pixel_info{1,count}{i,7} = x2;  
    end
end
%Growth rate calculation
for count = 1:38
    for i = 1:Huskies_team_num(1,count)      
        if(Huskies_pixel_info{1,count}{i,7}~=1)
            for num = 2:Huskies_pixel_info{1,count}{i,7}+1
                if(num ~=Huskies_pixel_info{1,count}{i,7}+1)
                    Huskies_pixel_info{1,count}{i,3} = [Huskies_pixel_info{1,count}{i,3},Huskies_pixel_info{1,count}{i,1}(1,num) - Huskies_pixel_info{1,count}{i,1}(1,num-1)];
                    Huskies_pixel_info{1,count}{i,4} = [Huskies_pixel_info{1,count}{i,4},Huskies_pixel_info{1,count}{i,2}(1,num) - Huskies_pixel_info{1,count}{i,2}(1,num-1)];
                else
                    Huskies_pixel_info{1,count}{i,3}(1,Huskies_pixel_info{1,count}{i,7}) =  Huskies_pixel_info{1,count}{i,3}(1,Huskies_pixel_info{1,count}{i,7}-1);
                    Huskies_pixel_info{1,count}{i,4}(1,Huskies_pixel_info{1,count}{i,7}) =  Huskies_pixel_info{1,count}{i,4}(1,Huskies_pixel_info{1,count}{i,7}-1);
                end
            end
        else
            Huskies_pixel_info{1,count}{i,3}(1,Huskies_pixel_info{1,count}{i,7}) = 0;
            Huskies_pixel_info{1,count}{i,4}(1,Huskies_pixel_info{1,count}{i,7}) = 0; 
        end
    end
    for i = 1:Opponent_team_num(1,count)      %Opponent player number
        if(Opponent_pixel_info{1,count}{i,7}~=1)
            for num = 2:Opponent_pixel_info{1,count}{i,7}+1
                if(num ~=Opponent_pixel_info{1,count}{i,7}+1)
                    Opponent_pixel_info{1,count}{i,3} = [Opponent_pixel_info{1,count}{i,3},Opponent_pixel_info{1,count}{i,1}(1,num) - Opponent_pixel_info{1,count}{i,1}(1,num-1)];
                    Opponent_pixel_info{1,count}{i,4} = [Opponent_pixel_info{1,count}{i,4},Opponent_pixel_info{1,count}{i,2}(1,num) - Opponent_pixel_info{1,count}{i,2}(1,num-1)];
                else
                    Opponent_pixel_info{1,count}{i,3}(1,Opponent_pixel_info{1,count}{i,7}) =  Opponent_pixel_info{1,count}{i,3}(1,Opponent_pixel_info{1,count}{i,7}-1);
                    Opponent_pixel_info{1,count}{i,4}(1,Opponent_pixel_info{1,count}{i,7}) =  Opponent_pixel_info{1,count}{i,4}(1,Opponent_pixel_info{1,count}{i,7}-1);
                end
            end
        else
            Opponent_pixel_info{1,count}{i,3}(1,Opponent_pixel_info{1,count}{i,7}) =  0;
            Opponent_pixel_info{1,count}{i,4}(1,Opponent_pixel_info{1,count}{i,7}) =  0;
        end
    end
end

%% Event recorder initialization
for count = 1:38
    for i = 1:Huskies_team_num(1,count)      %Huskies player number
        Huskies_pixel_info{1,count}{i,8} = 1;
    end
    for i = 1:Opponent_team_num(1,count)      %Opponent player number
        Opponent_pixel_info{1,count}{i,8} = 1;
    end
end
%% Search the corresponding adjacency matrix information
j = 0;
for count = 1:38
    if count == 1
        for num = 2:Match_2H_count(1,count)+1
            char_value = txt{num,3};                              
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
                case '5' 
                        value = value+5;
            end
            if(strncmpi(cell2mat(txt(num,3)),cell2mat(storage(1,1)),4)) 
                if mod(value,10)>=3
                       for i = Huskies_team_num(1,count):-1:1
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_one = i;
                                break;
                            end
                       end 
                else
                       for i = 1:Huskies_team_num(1,count)
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_one = i;
                                break;
                            end
                       end
                end
            else
                 if mod(value,10)>=3
                       for i = Opponent_team_num(1,count):-1:1
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_one = i;
                                break;
                            end
                       end 
                else
                       for i = 1:Opponent_team_num(1,count)
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_one = i;
                                break;
                            end
                       end
                end       
            end
            char_value = txt{num,4};                              
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
                case '5'
                        value = value+5;
            end
            if(strncmpi(cell2mat(txt(num,4)),cell2mat(storage(1,1)),4)) 
                if mod(value,10)>=3
                       for i = Huskies_team_num(1,count):-1:1
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_two = i ;    %Record huskies destinationplayerid number
                                Huskies_team_graph{1,count}(Huskies_count_one,Huskies_count_two) = Huskies_team_graph{1,count}(Huskies_count_one,Huskies_count_two) + 1;
                                Huskies_team_graph{1,count}(Huskies_count_two,Huskies_count_one) = Huskies_team_graph{1,count}(Huskies_count_two,Huskies_count_one) + 1;
                                break;
                            end
                       end 
                else
                       for i = 1:Huskies_team_num(1,count)
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_two = i ;    %Record huskies destinationplayerid number
                                Huskies_team_graph{1,count}(Huskies_count_one,Huskies_count_two) = Huskies_team_graph{1,count}(Huskies_count_one,Huskies_count_two) + 1;
                                Huskies_team_graph{1,count}(Huskies_count_two,Huskies_count_one) = Huskies_team_graph{1,count}(Huskies_count_two,Huskies_count_one) + 1;
                                break;
                            end
                       end
                end
            else
                 if mod(value,10)>=3
                       for i = Opponent_team_num(1,count):-1:1
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_two = i;    %Record the response destinationplayerid number
                                Opponent_team_graph{1,count}(Opponent_count_one,Opponent_count_two) = Opponent_team_graph{1,count}(Opponent_count_one,Opponent_count_two) + 1;
                                Opponent_team_graph{1,count}(Opponent_count_two,Opponent_count_one) = Opponent_team_graph{1,count}(Opponent_count_two,Opponent_count_one) + 1;
                                break;
                            end
                       end 
                else
                       for i = 1:Opponent_team_num(1,count)
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_two = i;    %Record the response destinationplayerid number
                                Opponent_team_graph{1,count}(Opponent_count_one,Opponent_count_two) = Opponent_team_graph{1,count}(Opponent_count_one,Opponent_count_two) + 1;
                                Opponent_team_graph{1,count}(Opponent_count_two,Opponent_count_one) = Opponent_team_graph{1,count}(Opponent_count_two,Opponent_count_one) + 1;
                                break;
                            end
                       end
                end       
            end
        end
    else
        for num = 2:Match_2H_count(1,count)+1
            char_value = txt{num+j,3};                               
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
            if(strncmpi(cell2mat(txt(num+j,3)),cell2mat(storage(1,1)),4)) 
                if mod(value,10)>=3
                       for i = Huskies_team_num(1,count):-1:1
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_one = i;
                                break;
                            end
                       end 
                else
                       for i = 1:Huskies_team_num(1,count)
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_one = i;
                                break;
                            end
                       end
                end
            else
                 if mod(value,10)>=3
                       for i = Opponent_team_num(1,count):-1:1
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_one = i;
                                break;
                            end
                       end 
                else
                       for i = 1:Opponent_team_num(1,count)
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_one = i;
                                break;
                            end
                       end
                end       
            end
            char_value = txt{num+j,4};                     
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
             if(strncmpi(cell2mat(txt(num+j,4)),cell2mat(storage(1,1)),4))
                if mod(value,10)>=3
                       for i = Huskies_team_num(1,count):-1:1
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_two = i ;  
                                Huskies_team_graph{1,count}(Huskies_count_one,Huskies_count_two) = Huskies_team_graph{1,count}(Huskies_count_one,Huskies_count_two) + 1;
                                Huskies_team_graph{1,count}(Huskies_count_two,Huskies_count_one) = Huskies_team_graph{1,count}(Huskies_count_two,Huskies_count_one) + 1;
                                break;
                            end
                       end 
                else
                       for i = 1:Huskies_team_num(1,count)
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_two = i ;    
                                Huskies_team_graph{1,count}(Huskies_count_one,Huskies_count_two) = Huskies_team_graph{1,count}(Huskies_count_one,Huskies_count_two) + 1;
                                Huskies_team_graph{1,count}(Huskies_count_two,Huskies_count_one) = Huskies_team_graph{1,count}(Huskies_count_two,Huskies_count_one) + 1;
                                break;
                            end
                       end
                end
            else
                 if mod(value,10)>=3
                       for i = Opponent_team_num(1,count):-1:1
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_two = i ;    
                                Opponent_team_graph{1,count}(Opponent_count_one,Opponent_count_two) = Opponent_team_graph{1,count}(Opponent_count_one,Opponent_count_two) + 1;
                                Opponent_team_graph{1,count}(Opponent_count_two,Opponent_count_one) = Opponent_team_graph{1,count}(Opponent_count_two,Opponent_count_one) + 1;
                                break;
                            end
                       end 
                else
                       for i = 1:Opponent_team_num(1,count)
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_two = i ;  
                                Opponent_team_graph{1,count}(Opponent_count_one,Opponent_count_two) = Opponent_team_graph{1,count}(Opponent_count_one,Opponent_count_two) + 1;
                                Opponent_team_graph{1,count}(Opponent_count_two,Opponent_count_one) = Opponent_team_graph{1,count}(Opponent_count_two,Opponent_count_one) + 1;
                                break;
                            end
                       end
                end       
            end           
        end        
    end
    j = j + Match_2H_count(1,count);
end

%% Initialization of players' passing compactness
Huskies_Close_num = cell(1,40);
Opponent_Close_num = cell(1,40);
Huskies_graph_z = cell(1,40);
Opponent_graph_z = cell(1,40);
for count = 1:38
    Huskies_Close_num{1,count} = zeros(Huskies_team_num(1,count),Huskies_team_num(1,count));
    Opponent_Close_num{1,count} = zeros(Opponent_team_num(1,count),Opponent_team_num(1,count));
    Huskies_graph_z{1,count} = zeros(Huskies_team_num(1,count),Huskies_team_num(1,count));
    Opponent_graph_z{1,count}= zeros(Opponent_team_num(1,count),Opponent_team_num(1,count));
end
%% Search for the corresponding pass compactness matrix information
j = 0;
for count = 1:38
    if count == 1
        for num = 2:Match_2H_count(1,count)+1
            char_value = txt{num,3};                                %Pass player
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
                case '5'
                        value = value+5;
            end
            if(strncmpi(cell2mat(txt(num,3)),cell2mat(storage(1,1)),4)) 
                if mod(value,10)>=3
                       for i = Huskies_team_num(1,count):-1:1
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_one = i;
                                break;
                            end
                       end 
                else
                       for i = 1:Huskies_team_num(1,count)
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_one = i;
                                break;
                            end
                       end
                end
            else
                 if mod(value,10)>=3
                       for i = Opponent_team_num(1,count):-1:1
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_one = i;
                                break;
                            end
                       end 
                else
                       for i = 1:Opponent_team_num(1,count)
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_one = i;
                                break;
                            end
                       end
                end       
            end
            char_value = txt{num,4};                      
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
                case '5'
                        value = value+5;
            end
            if(strncmpi(cell2mat(txt(num,4)),cell2mat(storage(1,1)),4)) 
                if mod(value,10)>=3
                       for i = Huskies_team_num(1,count):-1:1
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_two = i ;    
                                if num == 2
                                    Huskies_Close_num{1,count} = updata(Huskies_team_num(1,count),Huskies_Close_num{1,count},Huskies_count_one ...
                                        ,Huskies_count_two,0,number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),120);
                                else
                                    Huskies_Close_num{1,count} = updata(Huskies_team_num(1,count),Huskies_Close_num{1,count},Huskies_count_one ...
                                                ,Huskies_count_two,number(num-2,6),number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),120);                            
                                end
                                Huskies_graph_z{1,count} = Huskies_graph_z{1,count} + Huskies_Close_num{1,count};
                                break;
                            end
                       end 
                else
                       for i = 1:Huskies_team_num(1,count)
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_two = i ;   
                                if num == 2
                                    Huskies_Close_num{1,count} = updata(Huskies_team_num(1,count),Huskies_Close_num{1,count},Huskies_count_one ...
                                        ,Huskies_count_two,0,number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),120);
                                else
                                    Huskies_Close_num{1,count} = updata(Huskies_team_num(1,count),Huskies_Close_num{1,count},Huskies_count_one ...
                                                ,Huskies_count_two,number(num-2,6),number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),120);                            
                                end
                                Huskies_graph_z{1,count} = Huskies_graph_z{1,count} + Huskies_Close_num{1,count};
                                break;
                            end
                       end
                end
            else
                 if mod(value,10)>=3
                       for i = Opponent_team_num(1,count):-1:1
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_two = i;    
                                if num == 2
                                    Opponent_Close_num{1,count} = updata(Opponent_team_num(1,count),Opponent_Close_num{1,count},Opponent_count_one ...
                                        ,Opponent_count_two,0,number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),120);
                                else
                                    Opponent_Close_num{1,count} = updata(Opponent_team_num(1,count),Opponent_Close_num{1,count},Opponent_count_one ...
                                                ,Opponent_count_two,number(num-2,6),number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),120);                            
                                end
                                Opponent_graph_z{1,count} = Opponent_graph_z{1,count} + Opponent_Close_num{1,count};
                                break;
                            end
                       end 
                else
                       for i = 1:Opponent_team_num(1,count)
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_two = i;  
                                if num == 2
                                    Opponent_Close_num{1,count} = updata(Opponent_team_num(1,count),Opponent_Close_num{1,count},Opponent_count_one ...
                                        ,Opponent_count_two,0,number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),120);
                                else
                                    Opponent_Close_num{1,count} = updata(Opponent_team_num(1,count),Opponent_Close_num{1,count},Opponent_count_one ...
                                                ,Opponent_count_two,number(num-2,6),number(num-1,6),0.1,10,number(num-1,8),number(num-1,9),number(num-1,10),number(num-1,11),120);                            
                                end
                                Opponent_graph_z{1,count} = Opponent_graph_z{1,count} + Opponent_Close_num{1,count};
                                break;
                            end
                       end
                end       
            end
        end
    else
        for num = 2:Match_2H_count(1,count)+1
            char_value = txt{num+j,3};                      
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
                case '5'
                        value = value+5;
            end
            if(strncmpi(cell2mat(txt(num+j,3)),cell2mat(storage(1,1)),4))
                if mod(value,10)>=3
                       for i = Huskies_team_num(1,count):-1:1
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_one = i;
                                break;
                            end
                       end 
                else
                       for i = 1:Huskies_team_num(1,count)
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_one = i;
                                break;
                            end
                       end
                end
            else
                 if mod(value,10)>=3
                       for i = Opponent_team_num(1,count):-1:1
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_one = i;
                                break;
                            end
                       end 
                else
                       for i = 1:Opponent_team_num(1,count)
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_one = i;
                                break;
                            end
                       end
                end       
            end
            char_value = txt{num+j,4};                                
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
                case '5'
                        value = value+5;                        
            end
             if(strncmpi(cell2mat(txt(num+j,4)),cell2mat(storage(1,1)),4)) 
                if mod(value,10)>=3
                       for i = Huskies_team_num(1,count):-1:1
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_two = i ;    
                                if num == 2
                                    Huskies_Close_num{1,count} = updata(Huskies_team_num(1,count),Huskies_Close_num{1,count},Huskies_count_one ...
                                        ,Huskies_count_two,0,number(num-1+j,6),0.1,10,number(num-1+j,8),number(num-1+j,9),number(num-1+j,10),number(num-1+j,11),120);
                                else
                                    Huskies_Close_num{1,count} = updata(Huskies_team_num(1,count),Huskies_Close_num{1,count},Huskies_count_one ...
                                                ,Huskies_count_two,number(num-2+j,6),number(num-1+j,6),0.1,10,number(num-1+j,8),number(num-1+j,9),number(num-1+j,10),number(num-1+j,11),120);                            
                                end
                                Huskies_graph_z{1,count} = Huskies_graph_z{1,count} + Huskies_Close_num{1,count};
                              
                                break;
                            end
                       end 
                else
                       for i = 1:Huskies_team_num(1,count)
                            if Huskies_pixel_info{1,count}{i,5} == value
                                Huskies_count_two = i ;    
                                if num == 2
                                    Huskies_Close_num{1,count} = updata(Huskies_team_num(1,count),Huskies_Close_num{1,count},Huskies_count_one ...
                                        ,Huskies_count_two,0,number(num-1+j,6),0.1,10,number(num-1+j,8),number(num-1+j,9),number(num-1+j,10),number(num-1+j,11),120);
                                else
                                    Huskies_Close_num{1,count} = updata(Huskies_team_num(1,count),Huskies_Close_num{1,count},Huskies_count_one ...
                                                ,Huskies_count_two,number(num-2+j,6),number(num-1+j,6),0.1,10,number(num-1+j,8),number(num-1+j,9),number(num-1+j,10),number(num-1+j,11),120);                            
                                end
                                Huskies_graph_z{1,count} = Huskies_graph_z{1,count} + Huskies_Close_num{1,count};                                
                                break;
                            end
                       end
                end
            else
                 if mod(value,10)>=3
                       for i = Opponent_team_num(1,count):-1:1
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_two = i ;  
                                if num == 2
                                    Opponent_Close_num{1,count} = updata(Opponent_team_num(1,count),Opponent_Close_num{1,count},Opponent_count_one ...
                                        ,Opponent_count_two,0,number(num-1+j,6),0.1,10,number(num-1+j,8),number(num-1+j,9),number(num-1+j,10),number(num-1+j,11),120);
                                else
                                    Opponent_Close_num{1,count} = updata(Opponent_team_num(1,count),Opponent_Close_num{1,count},Opponent_count_one ...
                                                ,Opponent_count_two,number(num-2+j,6),number(num-1+j,6),0.1,10,number(num-1+j,8),number(num-1+j,9),number(num-1+j,10),number(num-1+j,11),120);                            
                                end
                                Opponent_graph_z{1,count} = Opponent_graph_z{1,count} + Opponent_Close_num{1,count};
                                break;
                            end
                       end 
                else
                       for i = 1:Opponent_team_num(1,count)
                            if Opponent_pixel_info{1,count}{i,5} == value
                                Opponent_count_two = i ;    
                                if num == 2
                                    Opponent_Close_num{1,count} = updata(Opponent_team_num(1,count),Opponent_Close_num{1,count},Opponent_count_one ...
                                        ,Opponent_count_two,0,number(num-1+j,6),0.1,10,number(num-1+j,8),number(num-1+j,9),number(num-1+j,10),number(num-1+j,11),120);
                                else
                                    Opponent_Close_num{1,count} = updata(Opponent_team_num(1,count),Opponent_Close_num{1,count},Opponent_count_one ...
                                                ,Opponent_count_two,number(num-2+j,6),number(num-1+j,6),0.1,10,number(num-1+j,8),number(num-1+j,9),number(num-1+j,10),number(num-1+j,11),120);                            
                                end
                                Opponent_graph_z{1,count} = Opponent_graph_z{1,count} + Opponent_Close_num{1,count};
                                break;
                            end
                       end
                end       
            end           
        end        
    end
    j = j + Match_2H_count(1,count);
end

%% Initialization of player coordinate variable
Huskies_map_x = cell(1,40);
Huskies_map_y = cell(1,40);
Opponent_map_x = cell(1,40);
Opponent_map_y = cell(1,40);
for count = 1:38
    Huskies_map_x{1,count} = zeros(1,Huskies_team_num(1,count));
    Huskies_map_y{1,count}=  zeros(1,Huskies_team_num(1,count));
    Opponent_map_x{1,count} =zeros(1,Opponent_team_num(1,count));
    Opponent_map_y{1,count} = zeros(1,Opponent_team_num(1,count));
end

%% Calculation of players' average coordinates
for count = 1:38
    for i = 1:Huskies_team_num(1,count)      
        for j = 1:Huskies_pixel_info{1,count}{i,7}
            Huskies_map_x{1,count}(1,i) = Huskies_map_x{1,count}(1,i) + Huskies_pixel_info{1,count}{i,1}(1,j);
            Huskies_map_y{1,count}(1,i) = Huskies_map_y{1,count}(1,i) + Huskies_pixel_info{1,count}{i,2}(1,j);
        end
 
        Huskies_map_x{1,count}(1,i) = Huskies_map_x{1,count}(1,i)/Huskies_pixel_info{1,count}{i,7};
        Huskies_map_y{1,count}(1,i) = Huskies_map_y{1,count}(1,i)/Huskies_pixel_info{1,count}{i,7};
    end
    
    for i = 1:Opponent_team_num(1,count)      
        for j = 1:Opponent_pixel_info{1,count}{i,7}
            Opponent_map_x{1,count}(1,i) = Opponent_map_x{1,count}(1,i) + Opponent_pixel_info{1,count}{i,1}(1,j);
            Opponent_map_y{1,count}(1,i) = Opponent_map_y{1,count}(1,i) + Opponent_pixel_info{1,count}{i,2}(1,j);
        end

        Opponent_map_x{1,count}(1,i) = Opponent_map_x{1,count}(1,i)/Opponent_pixel_info{1,count}{i,7};
        Opponent_map_y{1,count}(1,i) = Opponent_map_y{1,count}(1,i)/Opponent_pixel_info{1,count}{i,7};        
    end
end

%% Output compactness of Excel
xlswrite('C:/Users/Administrator/Desktop/ms/close.xls',Huskies_graph_z{1,1},'game1','B2');
%% Initialization of player distance variable

Huskies_sum = zeros(1,40);
Opponent_sum = zeros(1,40);
%% Huskies shows the original
figure(1);
plot(Huskies_map_x{1,1}(1,:),Huskies_map_y{1,1}(1,:),'o');
hold on;
%Draw weights
for i=1:Huskies_team_num(1,1)
    for j=i:Huskies_team_num(1,1)
        if Huskies_team_graph{1,1}(i,j)~=0
            c=num2str(Huskies_team_graph{1,1}(i,j));            %Convert the weight in the matrix to character type             
            text((Huskies_map_x{1,1}(1,i)+Huskies_map_x{1,1}(1,j))/2,(Huskies_map_y{1,1}(1,i)+Huskies_map_y{1,1}(1,j))/2,c,'Fontsize',10);  %Show weight of edge
            line([Huskies_map_x{1,1}(1,i) Huskies_map_x{1,1}(1,j)],[Huskies_map_y{1,1}(1,i) Huskies_map_y{1,1}(1,j)]);      %Connection
        end
        
        text(Huskies_map_x{1,1}(1,i),Huskies_map_y{1,1}(1,i),num2str(Huskies_pixel_info{1,1}{i,5}),'Fontsize',14,'color','r');   %Display the sequence number of the point            
    end
end
title('Huskies full screen');
%% The audience displays the original 
figure(2);
plot(Opponent_map_x{1,1}(1,:),Opponent_map_y{1,1}(1,:),'o');
hold on;
%Draw weights
for i=1:Opponent_team_num(1,1)
    for j=i:Opponent_team_num(1,1)
        if Opponent_team_graph{1,1}(i,j)~=0
            c=num2str(Opponent_team_graph{1,1}(i,j));            %Convert the weight in the matrix to character type            
            text((Opponent_map_x{1,1}(1,i)+Opponent_map_x{1,1}(1,j))/2,(Opponent_map_y{1,1}(1,i)+Opponent_map_y{1,1}(1,j))/2,c,'Fontsize',10);  %Show weight of edge
            line([Opponent_map_x{1,1}(1,i) Opponent_map_x{1,1}(1,j)],[Opponent_map_y{1,1}(1,i) Opponent_map_y{1,1}(1,j)]);     %Connection
        end
        
        text(Opponent_map_x{1,1}(1,i),Opponent_map_y{1,1}(1,i),num2str(Opponent_pixel_info{1,1}{i,5}),'Fontsize',14,'color','r');   %Display the sequence number of the point           
    end
end
title('Original view of the whole audience');
%% Huskies whole field display initialization change
Huskies_map_value = cell(1,2);
Huskies_w_line = zeros(1,Huskies_team_num(1,1));
graph_mat = Huskies_team_graph{1,1};
Huskies_map_value{1,1} = Huskies_map_x{1,1};
Huskies_map_value{1,2} = Huskies_map_y{1,1};

%% Huskies display changes
for x1 = 1:Huskies_team_num(1,1)    %Process weight matrix
    for x2 = 1:Huskies_team_num(1,1)
        if graph_mat(x1,x2) <= 6
           graph_mat(x1,x2) = 0;
        end
    end
end

for x1 = 1:Huskies_team_num(1,1)    %Query how many weight lines each person has vertical count
    for x2 = 1:Huskies_team_num(1,1)
        if (graph_mat(x1,x2) ~= 0)&&(x1~=x2)
           Huskies_w_line(1,x1) = Huskies_w_line(1,x1)+1;
        end
    end
end

for i = 1:Huskies_team_num(1,1)    %Query how many weight lines each person has vertical count
    if(Huskies_w_line(1,i) == 0)
        Huskies_map_value{1,1}(1,i) = -1;%Don't draw this point.
        Huskies_map_value{1,2}(1,i) = -1;
    end
end
figure(3);
plot(Huskies_map_value{1,1}(1,:),Huskies_map_value{1,2}(1,:),'o');
axis([0 100 0 100]);%Range of axes
hold on;
%Draw weights
for i=1:Huskies_team_num(1,1)
    for j=i:Huskies_team_num(1,1)
        if graph_mat(i,j)~=0
            c=num2str(graph_mat(i,j));            %Convert the weight in the matrix to character type              
            text((Huskies_map_value{1,1}(1,i)+Huskies_map_value{1,1}(1,j))/2,(Huskies_map_value{1,2}(1,i)+Huskies_map_value{1,2}(1,j))/2,c,'Fontsize',10);  %Show weight of edge
            line([Huskies_map_value{1,1}(1,i) Huskies_map_value{1,1}(1,j)],[Huskies_map_value{1,2}(1,i) Huskies_map_value{1,2}(1,j)]);      %Connection
        end
        if Huskies_w_line(1,i) ~= 0
            text(Huskies_map_value{1,1}(1,i),Huskies_map_value{1,2}(1,i),num2str(Huskies_pixel_info{1,1}{i,5}),'Fontsize',14,'color','r');   %Display the sequence number of the point 
        end
    end
end
title('Main members of Huskies');
%% Initial change of response full field display
Opponent_map_value = cell(1,2);
Opponent_w_line = zeros(1,Opponent_team_num(1,1));
graph_mat = Opponent_team_graph{1,1};
Opponent_map_value{1,1} = Opponent_map_x{1,1};
Opponent_map_value{1,2} = Opponent_map_y{1,1};

%% Response whole field display change
for x1 = 1:Opponent_team_num(1,1)    %Process weight matrix
    for x2 = 1:Opponent_team_num(1,1)
        if graph_mat(x1,x2) <= 3
           graph_mat(x1,x2) = 0;
        end
    end
end

for x1 = 1:Opponent_team_num(1,1)    %Query how many weight lines each person has vertical count
    for x2 = 1:Opponent_team_num(1,1)
        if (graph_mat(x1,x2) ~= 0)&&(x1~=x2)
           Opponent_w_line(1,x1) = Opponent_w_line(1,x1)+1;
        end
    end
end

for i = 1:Opponent_team_num(1,1)    %Query how many weight lines each person has vertical count
    if(Opponent_w_line(1,i) == 0)||(Opponent_pixel_info{1,1}{i,5}==11)
        Opponent_map_value{1,1}(1,i) = -1;
        Opponent_map_value{1,2}(1,i) = -1;
    end
end
figure(4);
plot(Opponent_map_value{1,1}(1,:),Opponent_map_value{1,2}(1,:),'o');
axis([0 100 0 100]);
hold on;

for i=1:Opponent_team_num(1,1)
    for j=i:Opponent_team_num(1,1)
        if (graph_mat(i,j)~=0)&&(Opponent_pixel_info{1,1}{i,5}~=11)
            c=num2str(graph_mat(i,j));                        
            text((Opponent_map_value{1,1}(1,i)+Opponent_map_value{1,1}(1,j))/2,(Opponent_map_value{1,2}(1,i)+Opponent_map_value{1,2}(1,j))/2,c,'Fontsize',10); 
            line([Opponent_map_value{1,1}(1,i) Opponent_map_value{1,1}(1,j)],[Opponent_map_value{1,2}(1,i) Opponent_map_value{1,2}(1,j)]);     
        end
        if (Opponent_w_line(1,i) ~= 0)&&(Opponent_pixel_info{1,1}{i,5}~=11)
            text(Opponent_map_value{1,1}(1,i),Opponent_map_value{1,2}(1,i),num2str(Opponent_pixel_info{1,1}{i,5}),'Fontsize',14,'color','r');    
        end
    end
end
title('Main members of the audience');
figure(5); bar3(Huskies_graph_z{1,2});
title('Huskies_close'); xlabel('x'); ylabel('y'); zlabel('z');

figure(6); bar3(Opponent_graph_z{1,2});
title('Opponent_close'); xlabel('x'); ylabel('y'); zlabel('z');