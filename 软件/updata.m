function y = updata(up_data,close_mat,pass_out,pass_in,time_begin,time_end,Attenuation_factor,begin_value)
% ����˵��
%up_data �����С
%close_mat ����Ҫ���µľ���
%pass_out �����˱��
%pass_out �����˱��
%time_begin ��һ�¼�����ʱ��
%time_end �����¼�����ʱ��
%Attenuation_factor ˥������
%begin_value ˥����ʼֵ

for i = 1:up_data
    for j = 1:up_data
        close_mat(i,j) = close_mat(i,j)*exp(-Attenuation_factor*(time_end - time_begin));        
    end
end
close_mat(pass_in,pass_out) = begin_value;
close_mat(pass_out,pass_in) = begin_value;
y = close_mat;


