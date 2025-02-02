load('traindata');

x = train_output;
figname = 'Train  Data';
data_size = size(x(:,end))
z = [0;0];

for i = 1:data_size
    if x(i,end) ==0
        z(1,1)= z(1,1)+1;
        
    else
        z(2,1)=z(2,1)+1;
    end
end

b = bar(z);
title(figname);
xlabel('分類類別');			% x 軸的說明文字
ylabel('數量');	% y 軸的說明文字
% 下列指令將 x 軸的數目字改成月數
set(gca, 'xticklabel', {'0','1'});

%顯示長條圖的值
xtips1 = b(1).XEndPoints;
ytips1 = b(1).YEndPoints;
labels1 = string(b(1).YData);
text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')

saveas(gcf,'Test Data Output', 'jpg')

