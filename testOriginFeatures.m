
addpath('datasets/');
clear;
dataset = 'Jaffe';
load(dataset);



nKmeans = 20;


%lung, TOX_171, leukemia, Prostate_GE£¬warpPIE10P£¬warpAR10P,lymphoma,SMK_CAN_187
% fea = X;
% gnd = Y;

rand('twister',5489);
[nSmp,mFea] = size(fea);
nClass = length(unique(gnd));
% label = litekmeans(fea,nClass,'Replicates',20);
% MIhat = MutualInfo(gnd,label);
% MIhat = NMI_sqrt_lei(gnd,label);
% disp(['Clustering using all the ',num2str(size(fea,2)),' features. Clustering MIhat: ',num2str(MIhat)]);

for i = 1:nKmeans
        label = litekmeans(fea,nClass,'Replicates',1);
        arrNMI_max(i) = NMI_max_lei(gnd,label);
        arrNMI_sqrt(i) = NMI_sqrt_lei(gnd,label);
        arrACC(i) = ACC_Lei(gnd,label);
end

mNMI_max = mean(arrNMI_max);
sNMI_max = std(arrNMI_max);
mNMI_sqrt = mean(arrNMI_sqrt);
sNMI_sqrt = std(arrNMI_sqrt);
mACC = mean(arrACC);
sACC = std(arrACC);