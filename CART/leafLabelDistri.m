function [ outputlist ] = leafLabelDistri( leafList )
% Given leafList, distribution of the labels is calculated.  

L=cell(1,length(leafList));
for k = 1:length(leafList) % ʵ�ֶ�ÿ������Ԥ������һ��ͳ�ƣ����ֱ������Ԫ����Ԥ�����ĸ���
    classes = unique(leafList{k});
    elements= zeros(1,length(classes));
    for i = 1:length(leafList{k})
        for j=1:length(classes)
            if (leafList{k}(i) == classes(j))
                elements(j)=elements(j)+1;
                break
            end
        end
    end
    elements = elements./length(leafList{k});
    L{k}=[elements ; classes'];
end

output = sumLeafProb(L);
output(1,:) = output(1,:)/length(L); %����õ�output��0��1��Ԥ��ֵ���֮������ƽ����
x_label = find(max(output(1,:)));
outputlist = output(2,x_label);
% if output(1,1)>=output(1,2)
%     outputlist = output(2,1);
% else
%     outputlist = output(2,2);
    
% disp(join(["Percentage :", string(output(1,:))]));
% disp(join(["Label      :", string(output(2,:))]));
end