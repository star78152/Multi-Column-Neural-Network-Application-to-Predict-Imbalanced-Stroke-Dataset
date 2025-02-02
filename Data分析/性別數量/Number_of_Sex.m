load('testdata');

x = test_input;
figname = 'Test-Number of Sex';
data_size = size(x(:,1))
z = [0;0;0];

for i = 1:data_size
    if x(i,1) ==1
        z(1,1)= z(1,1)+1;
        
    elseif x(i,1) ==2
        z(2,1)=z(2,1)+1;
    elseif x(i,1) ==3
        z(3,1)=z(3,1)+1;
    end
end

b = bar(z);
title(figname);
xlabel('�������O');			% x �b��������r
ylabel('�ƶq');	% y �b��������r
% �U�C���O�N x �b���ƥئr�令���
set(gca, 'xticklabel', {'�k','�k','��L'});

%��ܪ����Ϫ���
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

saveas(gcf,figname, 'jpg')

