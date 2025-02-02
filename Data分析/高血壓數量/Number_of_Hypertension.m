load('traindata1');

x = train_input;
figname = 'Train Data-Number of Hypertension';
data_size = size(x(:,1))
z = [0;0];

for i = 1:data_size
    if x(i,3) ==0
        z(1,1)= z(1,1)+1;
        
    elseif x(i,3) ==1
        z(2,1)=z(2,1)+1;

    end
end

b = bar(z);
title(figname);
xlabel('Category');			% x �b��������r
ylabel('Quantity');	% y �b��������r
% �U�C���O�N x �b�����O
set(gca, 'xticklabel', {'0','1'});

%��ܪ����Ϫ���
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

saveas(gcf,figname, 'jpg')

