clc,clear;
%Macro definition
position_x = 1;                 %col 1 x coordinate  array
position_y = 2;                 %col 2 y coordinate  array
v_x = 3;                        %col 3 x Coordinate change array
v_y = 4;                        %col 4 y Coordinate change array?
name = 5;                       %col 5 Grade
e_time = 6;                     %col 6 Event update time
player_event_num = 7;           %col 7 Event sum
player_event_count = 8;         %col 8 Record variables
player_game_state = 9;          %col 9 state of athletes
player_time = 10;               %State change time
xiachang  = 11;
%% Init data
[number,txt,raw] = xlsread('C:/Users/Administrator/Desktop/bisai/2020_Problem_D_DATA/passingevents.csv');
[number_1,txt_1,raw_1] = xlsread('C:/Users/Administrator/Desktop/bisai/2020_Problem_D_DATA/fullevents.csv');
[hang,lie] = size(txt);
[hang_1,lie_1] = size(txt_1);
field_num = 1:1:38;
Huskies_pass_num = zeros(1,38);                     %Huskies Pass number matrix
Opponent_pass_num = zeros(1,38);                    %Opponent Pass number matrix
Huskies_team_state = cell(40,30);                   %Huskies team state matrix row game_number col team_name
Opponent_team_state = cell(40,30);                  %Opponent team state matrix row game_number col team_name
Huskies_team_num = zeros(1,38);                     %Huskies team number matrix col game_number 
Opponent_team_num = zeros(1,38);                    %Opponent team number matrix col game_number 
Huskies_count_one = 0;                              %Huskies OriginPlayerID Record variables
Huskies_count_two = 0;                              %Huskies DestinationPlayerID Record variables
Opponent_count_one = 0;                             %Opponent OriginPlayerID Record variables
Opponent_count_two = 0;                             %Opponent DestinationPlayerID Record variables
Match_1H_count = zeros(1,38);                       %First half of game time col game_number
Match_2H_count = zeros(1,38);                       %Second half of game time col game_number
unit_1H_time = zeros(1,38);                         %First half of game Unit conversion col game_number
unit_2H_time = zeros(1,38);                         %Second half of game Unit conversion col game_number
%% Find out how many teams record their names and their names
[team_storage,team_num] = species_count(2,2,hang,txt);
%% Query event home directory type
[event_type,event_type_num] = species_count(7,2,hang_1,txt_1);
%% Query event subdirectory type
[sub_event_type,sub_type_num] = sub_species_count(7,event_type_num,8,2,hang_1,txt_1,event_type);
%% Record the number of passes per game
sum_pass_num = numder_species_sum(1 , 1 , (hang-1) , number , field_num , 38);
%% Number of recorded events
sum_event = numder_species_sum(1 , 1 , (hang_1-1) , number_1 , field_num , 38);
%% Count the total passes of Huskies and opponent
j = 1;
for i = 1:38
    Huskies_pass_num(1,i) = species_sum(2,j+1,j+sum_pass_num(1,i),txt,team_storage{1,1});
    Opponent_pass_num(1,i) = sum_pass_num(1,i) - Huskies_pass_num(1,i);
    j = j + sum_pass_num(1,i);
end
%% Record the time of changing field
j = 0;
for i = 1:38
    Match_1H_count(1,i) = species_sum(5,j+1,j+sum_event(1,i),txt_1,'1H');
    Match_2H_count(1,i) = sum_event(1,i);
    unit_1H_time(1,i) = number_1(Match_1H_count(1,i)+j,6)/3600;   %Conversion to seconds
    unit_2H_time(1,i) = number_1(Match_2H_count(1,i)+j,6)/3600;
    j = j + sum_event(1,i);
end
%% Count player name information
j = 1;
for i = 1:38
    [Huskies_team_state(i,:),Huskies_team_num(1,i),Opponent_team_state(i,:),Opponent_team_num(1,i)] = player_species_count(3,j+1,j+sum_event(1,i),txt_1,team_storage{1,1}); 
    j = j + sum_event(1,i);
end
%% Member information cell initialization
Huskies_pixel_info = cell(1,38);
Opponent_pixel_info = cell(1,38);
for count = 1:38
    Huskies_pixel_info{1,count} = cell(Huskies_team_num(1,count),10);
    Opponent_pixel_info{1,count} = cell(Huskies_team_num(1,count),10);
end

for count = 1:38
    for i = 1:Huskies_team_num(1,count)
        Huskies_pixel_info{1,count}{i,player_game_state} = 0;
    end
end
%% Event recorder initialization
for count = 1:38
    for i = 1:Huskies_team_num(1,count)      
        Huskies_pixel_info{1,count}{i,8} = 1;
        Huskies_pixel_info{1,count}{i,9} = 0;
    end
    for i = 1:Opponent_team_num(1,count)     
        Opponent_pixel_info{1,count}{i,8} = 1;
        Opponent_pixel_info{1,count}{i,9} = 0;
    end
end
%% Label team members
for count = 1:38
    for i = 1:Huskies_team_num(1,count)      
        Huskies_pixel_info{1,count}{i,name} = player_str_to_number(Huskies_team_state{count,i});
    end
    for i = 1:Opponent_team_num(1,count)      
        Opponent_pixel_info{1,count}{i,name} = player_str_to_number(Opponent_team_state{count,i});
    end    
end
%% Bubble sort 
for count = 1:38
	for i = 2 : Huskies_team_num(1,count)-1
		for j = Huskies_team_num(1,count) : -1 : i
			if Huskies_pixel_info{1,count}{j,name} <  Huskies_pixel_info{1,count}{j-1,name}
				num = Huskies_pixel_info{1,count}{j,name};
				Huskies_pixel_info{1,count}{j,name} = Huskies_pixel_info{1,count}{j-1,name};
				Huskies_pixel_info{1,count}{j-1,name} = num;
			end
		end
	end
  
	for i = 2 : Opponent_team_num(1,count)-1
		for j = Opponent_team_num(1,count) : -1 : i
			if Opponent_pixel_info{1,count}{j,name} <  Opponent_pixel_info{1,count}{j-1,name}
				num = Opponent_pixel_info{1,count}{j,name};
				Opponent_pixel_info{1,count}{j,name} = Opponent_pixel_info{1,count}{j-1,name};
				Opponent_pixel_info{1,count}{j-1,name} = num;
			end
		end
	end
end
%% Record team coordinate information
j=1;
char_value = 0;
i = 0;
flag = 0;
for count = 1:38
    for num = 1:sum_event(1,count)
        if ~strcmp(txt_1{num+j,7},'Substitution')
            char_value = player_str_to_number(txt_1{num+j,3});
            [i , flag] = search_player(txt_1{num+j,3},char_value,Huskies_pixel_info{1,count},Huskies_team_num(1,count),Opponent_pixel_info{1,count},Opponent_team_num(1,count));
            if flag == 2
				Huskies_pixel_info{1,count}{i,position_x} = [Huskies_pixel_info{1,count}{i,position_x},number_1(num-1+j,9)];                    %Huskies Pass player x position
				Huskies_pixel_info{1,count}{i,position_y} = [Huskies_pixel_info{1,count}{i,position_y},number_1(num-1+j,10)];                   %Huskies Pass player y position
				Huskies_pixel_info{1,count}{i,e_time} = [Huskies_pixel_info{1,count}{i,e_time},number_1(num-1+j,6)];                            %Huskies Pass time
				Huskies_pixel_info{1,count}{i,player_time} = [Huskies_pixel_info{1,count}{i,player_time},txt_1{num+j,5}];
				if ((Huskies_pixel_info{1,count}{i,player_game_state} ~= 3)&&(Huskies_pixel_info{1,count}{i,player_game_state} ~= 2))
					Huskies_pixel_info{1,count}{i,player_game_state} = 1;
				end
            else
				Opponent_pixel_info{1,count}{i,position_x} = [Opponent_pixel_info{1,count}{i,position_x},(100-number_1(num-1+j,9))];    %Opponent Pass player x position
				Opponent_pixel_info{1,count}{i,position_y} = [Opponent_pixel_info{1,count}{i,position_y},(100-number_1(num-1+j,10))];   %Opponent Pass player y position
				Opponent_pixel_info{1,count}{i,e_time} = [Opponent_pixel_info{1,count}{i,e_time},number_1(num-1+j,6)];                  %Opponent Pass time
				Opponent_pixel_info{1,count}{i,player_time} = [Opponent_pixel_info{1,count}{i,player_time},txt_1{num+j,5}];
				if ((Opponent_pixel_info{1,count}{i,player_game_state} ~= 3)&&(Opponent_pixel_info{1,count}{i,player_game_state} ~= 2))
					Opponent_pixel_info{1,count}{i,player_game_state} = 1;                       
				end
            end
            if ~isempty(txt_1{num+j,4})
			   char_value = player_str_to_number(txt_1{num+j,4});
			   [i , flag] = search_player(txt_1{num+j,4},char_value,Huskies_pixel_info{1,count},Huskies_team_num(1,count),Opponent_pixel_info{1,count},Opponent_team_num(1,count));
			   if flag == 2
					Huskies_pixel_info{1,count}{i,position_x} = [Huskies_pixel_info{1,count}{i,position_x},number_1(num-1+j,11)];
					Huskies_pixel_info{1,count}{i,position_y} = [Huskies_pixel_info{1,count}{i,position_y},number_1(num-1+j,12)];
					Huskies_pixel_info{1,count}{i,e_time} = [Huskies_pixel_info{1,count}{i,e_time},number_1(num-1+j,6)];
					Huskies_pixel_info{1,count}{i,player_time} = [Huskies_pixel_info{1,count}{i,player_time},txt_1{num+j,5}];
					if ((Huskies_pixel_info{1,count}{i,player_game_state} ~= 3)&&(Huskies_pixel_info{1,count}{i,player_game_state} ~= 2))
						Huskies_pixel_info{1,count}{i,player_game_state} = 1;
					end
			   else
					Opponent_pixel_info{1,count}{i,position_x} = [Opponent_pixel_info{1,count}{i,position_x},(100-number_1(num-1+j,11))];
					Opponent_pixel_info{1,count}{i,position_y} = [Opponent_pixel_info{1,count}{i,position_y},(100-number_1(num-1+j,12))];
					Opponent_pixel_info{1,count}{i,e_time} = [Opponent_pixel_info{1,count}{i,e_time},number_1(num-1+j,6)];
					Opponent_pixel_info{1,count}{i,player_time} = [Opponent_pixel_info{1,count}{i,player_time},txt_1{num+j,5}];
					if ((Opponent_pixel_info{1,count}{i,player_game_state} ~= 3)&&(Opponent_pixel_info{1,count}{i,player_game_state} ~= 2))
						Opponent_pixel_info{1,count}{i,player_game_state} = 1;                           
					end                          
				end
            end
        else
			char_value = player_str_to_number(txt_1{num+j,3});
			[i , flag] = search_player(txt_1{num+j,3},char_value,Huskies_pixel_info{1,count},Huskies_team_num(1,count),Opponent_pixel_info{1,count},Opponent_team_num(1,count));           
			if flag == 2
				Huskies_pixel_info{1,count}{i,player_game_state} = 2;                      %substitution
				Huskies_pixel_info{1,count}{i,e_time} = [Huskies_pixel_info{1,count}{i,e_time},number_1(num-1+j,6)];        %substitution time
				Huskies_pixel_info{1,count}{i,player_time} = [Huskies_pixel_info{1,count}{i,player_time},txt_1{num+j,5}];
			else
				Opponent_pixel_info{1,count}{i,player_game_state} = 2; 
				Opponent_pixel_info{1,count}{i,e_time} = [Opponent_pixel_info{1,count}{i,e_time},number_1(num-1+j,6)];
				Opponent_pixel_info{1,count}{i,player_time} = [Opponent_pixel_info{1,count}{i,player_time},txt_1{num+j,5}];
			end
			if ~isempty(txt_1{num+j,4})
				char_value = player_str_to_number(txt_1{num+j,4});
				[i , flag] = search_player(txt_1{num+j,4},char_value,Huskies_pixel_info{1,count},Huskies_team_num(1,count),Opponent_pixel_info{1,count},Opponent_team_num(1,count));           
				if flag == 2
					Huskies_pixel_info{1,count}{i,player_game_state} = 3; 
					Huskies_pixel_info{1,count}{i,e_time} = [Huskies_pixel_info{1,count}{i,e_time},number_1(num-1+j,6)];
					Huskies_pixel_info{1,count}{i,player_time} = [Huskies_pixel_info{1,count}{i,player_time},txt_1{num+j,5}];
				else
					Opponent_pixel_info{1,count}{i,player_game_state} = 3;
					Opponent_pixel_info{1,count}{i,e_time} = [ Opponent_pixel_info{1,count}{i,e_time},number_1(num-1+j,6)];
					Opponent_pixel_info{1,count}{i,player_time} = [Opponent_pixel_info{1,count}{i,player_time},txt_1{num+j,5}];
				end
			end
        end
    end
    j = j + sum_event(1,count);
    flag = 1;
end
%% Information quantity calculation
for count = 1:38
    for i = 1:Huskies_team_num(1,count)      
        char_value = Huskies_pixel_info{1,count}{i,position_x};
        [x1,x2] = size(char_value);
        Huskies_pixel_info{1,count}{i,player_event_num} = x2;  
    end
    for i = 1:Opponent_team_num(1,count)      
        char_value = Opponent_pixel_info{1,count}{i,position_x};
        [x1,x2] = size(char_value);
        Opponent_pixel_info{1,count}{i,player_event_num} = x2;  
    end
end
%% Initialization of player coordinate variable
Huskies_map_x = cell(1,38);
Huskies_map_y = cell(1,38);
Opponent_map_x = cell(1,38);
Opponent_map_y = cell(1,38);
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
            Huskies_map_x{1,count}(1,i) = Huskies_map_x{1,count}(1,i) + Huskies_pixel_info{1,count}{i,position_x}(1,j);
            Huskies_map_y{1,count}(1,i) = Huskies_map_y{1,count}(1,i) + Huskies_pixel_info{1,count}{i,position_y}(1,j);
        end
        Huskies_map_x{1,count}(1,i) = Huskies_map_x{1,count}(1,i)/Huskies_pixel_info{1,count}{i,player_event_num};
        Huskies_map_y{1,count}(1,i) = Huskies_map_y{1,count}(1,i)/Huskies_pixel_info{1,count}{i,player_event_num};
    end
    for i = 1:Opponent_team_num(1,count)      
        for j = 1:Opponent_pixel_info{1,count}{i,7}
            Opponent_map_x{1,count}(1,i) = Opponent_map_x{1,count}(1,i) + Opponent_pixel_info{1,count}{i,position_x}(1,j);
            Opponent_map_y{1,count}(1,i) = Opponent_map_y{1,count}(1,i) + Opponent_pixel_info{1,count}{i,position_y}(1,j);
        end
        Opponent_map_x{1,count}(1,i) = Opponent_map_x{1,count}(1,i)/Opponent_pixel_info{1,count}{i,player_event_num};
        Opponent_map_y{1,count}(1,i) = Opponent_map_y{1,count}(1,i)/Opponent_pixel_info{1,count}{i,player_event_num};        
    end
end
%% Search the corresponding adjacency matrix information
j=1;
Huskies_team_graph = cell(1,38); %Huskies Graph theory storage variable of game passing col game_number
Opponent_team_graph = cell(1,38); %Opponent Graph theory storage variable of game passing col game_number
for count = 1:38
    Huskies_team_graph{1,count} = zeros(Huskies_team_num(1,count),Huskies_team_num(1,count));%Huskies adjacency matrix
    Opponent_team_graph{1,count} = zeros(Opponent_team_num(1,count),Opponent_team_num(1,count));%Opponent adjacency matrix
end
for count = 1:38
    for num = 1:sum_pass_num(1,count)
		char_value = player_str_to_number(txt{num+j,3});
		[i , flag] = search_player(txt{num+j,3},char_value,Huskies_pixel_info{1,count},Huskies_team_num(1,count),Opponent_pixel_info{1,count},Opponent_team_num(1,count));        
		if flag == 2
			Huskies_count_one = i;                             %Record passers
		else
			Opponent_count_one = i;                           
		end 
		char_value = player_str_to_number(txt{num+j,4});
		[i , flag] = search_player(txt{num+j,4},char_value,Huskies_pixel_info{1,count},Huskies_team_num(1,count),Opponent_pixel_info{1,count},Opponent_team_num(1,count));        
		if flag == 2
			Huskies_count_two = i ;     %Record passers
			Huskies_team_graph{1,count}(Huskies_count_one,Huskies_count_two) = Huskies_team_graph{1,count}(Huskies_count_one,Huskies_count_two) + 1;
			Huskies_team_graph{1,count}(Huskies_count_two,Huskies_count_one) = Huskies_team_graph{1,count}(Huskies_count_two,Huskies_count_one) + 1;
		else
			Opponent_count_two = i;    %Record Opponent Destination Player ID number
			Opponent_team_graph{1,count}(Opponent_count_one,Opponent_count_two) = Opponent_team_graph{1,count}(Opponent_count_one,Opponent_count_two) + 1;
			Opponent_team_graph{1,count}(Opponent_count_two,Opponent_count_one) = Opponent_team_graph{1,count}(Opponent_count_two,Opponent_count_one) + 1;
		end            
    end
    j = j + sum_pass_num(1,count);
end
%% Initialization of players' passing compactness
Huskies_Close_num = cell(1,38);
Opponent_Close_num = cell(1,38);
Huskies_graph_z = cell(1,38);
Opponent_graph_z = cell(1,38);
for count = 1:38
    Huskies_Close_num{1,count} = zeros(Huskies_team_num(1,count),Huskies_team_num(1,count));
    Opponent_Close_num{1,count} = zeros(Opponent_team_num(1,count),Opponent_team_num(1,count));
    Huskies_graph_z{1,count} = zeros(Huskies_team_num(1,count),Huskies_team_num(1,count));
    Opponent_graph_z{1,count}= zeros(Opponent_team_num(1,count),Opponent_team_num(1,count));
end
%% Search for the corresponding pass compactness matrix information
j = 1;
for count = 1:38
    for num = 1:sum_pass_num(1,count)
		char_value = player_str_to_number(txt{num+j,3});
		[i , flag] = search_player(txt{num+j,3},char_value,Huskies_pixel_info{1,count},Huskies_team_num(1,count),Opponent_pixel_info{1,count},Opponent_team_num(1,count));        
		if flag == 2
			Huskies_count_one = i;                             %Record passers
		else
			Opponent_count_one = i;                             %Record passers
		end 
		char_value = player_str_to_number(txt{num+j,4});
		[i , flag] = search_player(txt{num+j,4},char_value,Huskies_pixel_info{1,count},Huskies_team_num(1,count),Opponent_pixel_info{1,count},Opponent_team_num(1,count));        
		if flag == 2
			Huskies_count_two = i ;   
			if num == 1
				Huskies_Close_num{1,count} = updata(Huskies_team_num(1,count),Huskies_Close_num{1,count},Huskies_count_one ,Huskies_count_two,0,number(num-1+j,6),0.1,10,number(num-1+j,8),number(num-1+j,9),number(num-1+j,10),number(num-1+j,11),120);
			else
				Huskies_Close_num{1,count} = updata(Huskies_team_num(1,count),Huskies_Close_num{1,count},Huskies_count_one ,Huskies_count_two,number(num-2+j,6),number(num-1+j,6),0.1,10,number(num-1+j,8),number(num-1+j,9),number(num-1+j,10),number(num-1+j,11),120);                            
			end
			Huskies_graph_z{1,count} = Huskies_graph_z{1,count} + Huskies_Close_num{1,count};
		else
			Opponent_count_two = i;   
			if num == 1
				Opponent_Close_num{1,count} = updata(Opponent_team_num(1,count),Opponent_Close_num{1,count},Opponent_count_one ,Opponent_count_two,0,number(num-1+j,6),0.1,10,number(num-1+j,8),number(num-1+j,9),number(num-1+j,10),number(num-1+j,11),120);
			else
				Opponent_Close_num{1,count} = updata(Opponent_team_num(1,count),Opponent_Close_num{1,count},Opponent_count_one ,Opponent_count_two,number(num-2+j,6),number(num-1+j,6),0.1,10,number(num-1+j,8),number(num-1+j,9),number(num-1+j,10),number(num-1+j,11),120);                            
			end
			Opponent_graph_z{1,count} = Opponent_graph_z{1,count} + Opponent_Close_num{1,count};
		end            
    end
    j = j + sum_pass_num(1,count);
end
%% Ball control rate information
Huskies_C_R_U = zeros(1,38); %First half possession time
Huskies_C_R_D = zeros(1,38); %Possession time in the second half
Huskies_C_R_S = zeros(1,38); %Full court possession time
Opponent_C_R_U = zeros(1,38); 
Opponent_C_R_D = zeros(1,38);
Opponent_C_R_S = zeros(1,38);
Huskies_C_U_rate = zeros(1,38); %First half possession rate
Huskies_C_D_rate = zeros(1,38); %Possession time in the second half
Huskies_C_S_rate= zeros(1,38); %Full court possession time
Opponent_C_U_rate = zeros(1,38); 
Opponent_C_D_rate = zeros(1,38);
Opponent_C_S_rate = zeros(1,38);
ball_judge = 3;
former_ball_judge = 3;
j = 1;
event_flag = 0;
event_ball_number = zeros(1,hang_1);
event_attack_number = zeros(1,hang_1);
ball_flag = 0;
attack_flag = 0;
Huskies_control_begain = -1;
Huskies_control_end = 0;
Opponent_control_begain = -1;
Opponent_control_end = 0;
%Generate ball weight array
for count = 1:38
    for num = 1:sum_event(1,count)
        event_flag= Judge_ball_right(txt_1{num+j,7},txt_1{num+j,8});
        if (floor(event_flag/10) == 1)||(floor(event_flag/10) == 3)||(floor(event_flag/10) == 9)
            if strncmpi(txt_1{num+j,2},'Huskies',4)
                event_attack_number(1,num+j) = 1;
            else
                event_attack_number(1,num+j) = 2;
            end
        else 
            event_attack_number(1,num+j) = event_attack_number(1,num+j-1);
        end
        if (floor(event_flag/10) == 3)
            if strncmpi(txt_1{num+j,2},'Huskies',4)
                event_ball_number(1,num+j) = 1;
            else
                event_ball_number(1,num+j) = 2;
            end
        elseif (floor(event_flag/10) == 2)||(floor(event_flag/10) == 4) 
            event_ball_number(1,num+j) = event_ball_number(1,num+j-1);
        else
            event_ball_number(1,num+j) = 0;
        end        
    end
    j = j + sum_event(1,count);
end
j = 1;
for count = 1:38
    for num = 1:Match_1H_count(1,i)
        if(Huskies_control_begain == -1)&&(event_ball_number(1,num+j)==1)
            Huskies_control_begain = num+j;
            Huskies_control_end = -1;
        elseif(Huskies_control_end == -1)&&(event_ball_number(1,num+j)~=1)
            Huskies_control_end =  num+j;
            Huskies_C_R_U(1,count) = Huskies_C_R_U(1,count)+(number_1(Huskies_control_end,6) - number_1(Huskies_control_begain,6));
            Huskies_control_begain = -1;
        end
        if(Opponent_control_begain == -1)&&(event_ball_number(1,num+j)==2)
            Opponent_control_begain = num+j;
            Opponent_control_end = -1;
        elseif(Opponent_control_end == -1)&&(event_ball_number(1,num+j)~=2)
            Opponent_control_end =  num+j;
            Opponent_C_R_U(1,count) = Opponent_C_R_U(1,count)+(number_1(Opponent_control_end,6) - number_1(Opponent_control_begain,6));
            Opponent_control_begain = -1;
        end        
    end
    j = j + Match_1H_count(1,i);
    for num = 1:(Match_2H_count(1,i)-Match_1H_count(1,i))     
        if(Huskies_control_begain == -1)&&(event_ball_number(1,num+j)==1)
            Huskies_control_begain = num+j;
            Huskies_control_end = -1;
        elseif(Huskies_control_end == -1)&&(event_ball_number(1,num+j)~=1)
            Huskies_control_end =  num+j;
            Huskies_C_R_D(1,count) = Huskies_C_R_D(1,count)+(number_1(Huskies_control_end,6) - number_1(Huskies_control_begain,6));
            Huskies_control_begain = -1;
        end
        
        if(Opponent_control_begain == -1)&&(event_ball_number(1,num+j)==2)
            Opponent_control_begain = num+j;
            Opponent_control_end = -1;
        elseif(Opponent_control_end == -1)&&(event_ball_number(1,num+j)~=2)
            Opponent_control_end =  num+j;
            Opponent_C_R_D(1,count) = Opponent_C_R_D(1,count)+(number_1(Opponent_control_end,6) - number_1(Opponent_control_begain,6));
            Opponent_control_begain = -1;
        end     
    end
    Huskies_C_R_S(1,count) = Huskies_C_R_U(1,count) + Huskies_C_R_D(1,count);
    Opponent_C_R_S(1,count) = Opponent_C_R_U(1,count) + Opponent_C_R_D(1,count);
    %First half possession
    Huskies_C_U_rate(1,count) = Huskies_C_R_U(1,count)/(Huskies_C_R_U(1,count)+Opponent_C_R_U(1,count));
    Opponent_C_U_rate(1,count) = Opponent_C_R_U(1,count)/(Huskies_C_R_U(1,count)+Opponent_C_R_U(1,count));
    %Possession in the second half
    Huskies_C_D_rate(1,count) = Huskies_C_R_D(1,count)/(Huskies_C_R_D(1,count)+Opponent_C_R_D(1,count));
    Opponent_C_D_rate(1,count) = Opponent_C_R_D(1,count)/(Huskies_C_R_D(1,count)+Opponent_C_R_D(1,count));
    %Total possession
    Huskies_C_S_rate(1,count) = Huskies_C_R_S(1,count)/(Huskies_C_R_S(1,count)+Opponent_C_R_S(1,count));
    Opponent_C_S_rate(1,count) = Opponent_C_R_S(1,count)/(Huskies_C_R_S(1,count)+Opponent_C_R_S(1,count));    
    j = j + (Match_2H_count(1,i)-Match_1H_count(1,i)); 
end
%% Huskies all players show
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
title('Opponent all players show');
%% Opponent all players show
figure(2);
plot(Opponent_map_x{1,1}(1,:),Opponent_map_y{1,1}(1,:),'o');
hold on;
for i=1:Opponent_team_num(1,1)
    for j=i:Opponent_team_num(1,1)
        if Opponent_team_graph{1,1}(i,j)~=0
            c=num2str(Opponent_team_graph{1,1}(i,j));                         
            text((Opponent_map_x{1,1}(1,i)+Opponent_map_x{1,1}(1,j))/2,(Opponent_map_y{1,1}(1,i)+Opponent_map_y{1,1}(1,j))/2,c,'Fontsize',10);  
            line([Opponent_map_x{1,1}(1,i) Opponent_map_x{1,1}(1,j)],[Opponent_map_y{1,1}(1,i) Opponent_map_y{1,1}(1,j)]);    
        end
        
        text(Opponent_map_x{1,1}(1,i),Opponent_map_y{1,1}(1,i),num2str(Opponent_pixel_info{1,1}{i,5}),'Fontsize',14,'color','r');              
    end
end
title('Opponent all players show');
%% Huskies whole field display initialization 
Huskies_map_value = cell(1,2);
Huskies_w_line = zeros(1,Huskies_team_num(1,1));
graph_mat = Huskies_team_graph{1,1};
Huskies_map_value{1,1} = Huskies_map_x{1,1};
Huskies_map_value{1,2} = Huskies_map_y{1,1};
%% Huskies key members display
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
        Huskies_map_value{1,1}(1,i) = -1;%not draw this point
        Huskies_map_value{1,2}(1,i) = -1;
    end
end
figure(3);plot(Huskies_map_value{1,1}(1,:),Huskies_map_value{1,2}(1,:),'o');
axis([0 100 0 100]);hold on;
for i=1:Huskies_team_num(1,1)
    for j=i:Huskies_team_num(1,1)
        if graph_mat(i,j)~=0
            c=num2str(graph_mat(i,j));                      
            text((Huskies_map_value{1,1}(1,i)+Huskies_map_value{1,1}(1,j))/2,(Huskies_map_value{1,2}(1,i)+Huskies_map_value{1,2}(1,j))/2,c,'Fontsize',10);  
            line([Huskies_map_value{1,1}(1,i) Huskies_map_value{1,1}(1,j)],[Huskies_map_value{1,2}(1,i) Huskies_map_value{1,2}(1,j)]);   
        end
        if Huskies_w_line(1,i) ~= 0
            text(Huskies_map_value{1,1}(1,i),Huskies_map_value{1,2}(1,i),num2str(Huskies_pixel_info{1,1}{i,5}),'Fontsize',14,'color','r'); 
        end
    end
end
title('Huskies key members display');
%% Opponen key members init
Opponent_map_value = cell(1,2);
Opponent_w_line = zeros(1,Opponent_team_num(1,1));
graph_mat = Opponent_team_graph{1,1};
Opponent_map_value{1,1} = Opponent_map_x{1,1};
Opponent_map_value{1,2} = Opponent_map_y{1,1};
%% Opponen key members display
for x1 = 1:Opponent_team_num(1,1)    
    for x2 = 1:Opponent_team_num(1,1)
        if graph_mat(x1,x2) <= 3
           graph_mat(x1,x2) = 0;
        end
    end
end
for x1 = 1:Opponent_team_num(1,1)    
    for x2 = 1:Opponent_team_num(1,1)
        if (graph_mat(x1,x2) ~= 0)&&(x1~=x2)
           Opponent_w_line(1,x1) = Opponent_w_line(1,x1)+1;
        end
    end
end
for i = 1:Opponent_team_num(1,1)    
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
title('Opponen key members display');
figure(5); bar3(Huskies_graph_z{1,2});
title('Huskies_close'); xlabel('x'); ylabel('y'); zlabel('z');
figure(6); bar3(Opponent_graph_z{1,2});
title('Opponent_close'); xlabel('x'); ylabel('y'); zlabel('z');
%% Thermal chart
Huskies_Thermal_chart = zeros(102,102);
for num = 2:hang_1
        if (event_attack_number(1,num) == 1)
            if ~isnan(number_1(num-1,9))
                Huskies_Thermal_chart((number_1(num-1,9)+1) , number_1(num-1,10)+1) =Huskies_Thermal_chart(number_1(num-1,9)+1 ,number_1(num-1,10)+1) + 1 ;
            end
            if ~isempty(txt_1{num,4})
                if ~isnan(number_1(num-1,9))
                    Huskies_Thermal_chart(number_1(num-1,11)+1 , number_1(num-1,12)+1) =Huskies_Thermal_chart(number_1(num-1,11)+1 , number_1(num-1,12)+1) + 1 ;
                end
            end
        end
end
Huskies_Thermal_chart(1,1) = 0;
Huskies_Thermal_chart(101,101) = 0;
Huskies_Thermal_chart(101,1) = 0;
figure(7);
[X,Y]=meshgrid(linspace(1,102),linspace(1,102));
subplot(1,1,1);
pcolor(Huskies_Thermal_chart);
title('Thermal_chart');hold on;