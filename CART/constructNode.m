function [ ] = constructNode( node, set, labels, maxImp, numRandFeatures)
% Training nodes on a decision tree recursively untill max impurity 
% satisfied

% Best split among randomly choosen features����������������ѡ��numRandFeatures������������ѵ�
separationPoint = getSeparation(set, labels, numRandFeatures);
% Current node Impurity���õ���ǰ�ڵ�Ļ���ָ��
separationPoint(1) = getImpurity(labels);
% Setting current node info
setData(node, separationPoint);
% Prepairing 2 sub nodes.
subNode1 = treeNode();
subNode2 = treeNode();
% Connecting 2 subnodes to current node
setHigher(subNode1, node);
setLower(subNode2, node);
% Prepairing the subsets����ѵ�������ض��㣨separationPOint��2��������ѵ�����ָ�������Ӽ�
subSets = getSubSets(set, labels, separationPoint(3), separationPoint(2));
%subSetList{1} = subSet1;   subSetList{2} = labels1;    subSetList{3} = subSet2;    subSetList{4} = labels2;
imp1 = getImpurity(subSets{2});
imp2 = getImpurity(subSets{4});

% Stop condition of the recursion and training subsets of current node.��ǰ�ڵ�ĵݹ��ѵ���Ӽ���ֹͣ����

if (imp1 < maxImp)
    setData(subNode1, subSets{2});
    %disp('node �Ѿ�����')
   % disp(['imp1 = ',num2str(imp1)])
else
    %disp(['imp1 = ',num2str(imp1)])
    constructNode(subNode1, subSets{1}, subSets{2}, maxImp, ...
        numRandFeatures);
end

if (imp2 < maxImp)
    %disp(['imp2 = ',num2str(imp2)])
    setData(subNode2, subSets{4});
else
    %disp(['imp2 = ',num2str(imp2)])
    constructNode(subNode2, subSets{3}, subSets{4}, maxImp, ...
        numRandFeatures);
end
end