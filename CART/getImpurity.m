function [ impurity ] = getImpurity( labels )
% Calculating Gini Impurity
if(isempty(labels))
    impurity=0;
else
%     [elements, ~] = hist(labels, unique(labels));
%     for i=1:length(elements)
%         elements(i)=(elements(i)/length(labels))^2;
%     end
    num_label0 = length(find(labels == 0));
    num_label1 = length(find(labels == 1));
    num_label2 = length(find(labels == 2));
    num_label3 = length(find(labels == 3));
    num_label4 = length(find(labels == 4));
    %impurity = 1-sum(elements);
    impurity = 1- (num_label0/length(labels))^2 - (num_label1/length(labels))^2 - (num_label2/length(labels))^2- (num_label3/length(labels))^2- (num_label4/length(labels))^2;
end
end