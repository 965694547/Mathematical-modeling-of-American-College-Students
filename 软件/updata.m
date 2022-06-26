function y = updata(up_data,close_mat,pass_out,pass_in,time_begin,time_end,Attenuation_factor,begin_value)
% 参数说明
%up_data 矩阵大小
%close_mat 输入要更新的矩阵
%pass_out 传球人编号
%pass_out 接球人编号
%time_begin 上一事件发生时间
%time_end 本次事件发生时间
%Attenuation_factor 衰减因子
%begin_value 衰减起始值

for i = 1:up_data
    for j = 1:up_data
        close_mat(i,j) = close_mat(i,j)*exp(-Attenuation_factor*(time_end - time_begin));        
    end
end
close_mat(pass_in,pass_out) = begin_value;
close_mat(pass_out,pass_in) = begin_value;
y = close_mat;


