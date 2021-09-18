
addpath('./datasets/');
clear;
dataset = 'YaleB';
load(dataset);

%UMIST
% fea = fea';
% gnd = gnd';


%lung, TOX_171, leukemia, Prostate_GE£¬warpPIE10P£¬warpAR10P,lymphoma,SMK_CAN_187
% fea = X;
% gnd = Y;
%======================setup=======================
nKmeans = 20;


rand('twister',5489);
[nSmp,mFea] = size(fea);
nClass = length(unique(gnd));
label = litekmeans(fea,nClass,'Replicates',20);
MIhat = MutualInfo(gnd,label);
% MIhat = NMI_sqrt_lei(gnd,label)
disp(['Clustering using all the ',num2str(size(fea,2)),' features. Clustering MIhat: ',num2str(MIhat)]);


k = 5;


lambda = [10^-6, 10^-4,10^-2,1,10^2,10^4,10^6];
gamma = [10^-6, 10^-4,10^-2,1,10^2,10^4,10^6];
T = 50;
S = 50;
c = nClass;
W =rand(mFea, nClass);
B = rand(nClass, c);
E = rand(nSmp, c);


%create a folder named by the name of dataset
if exist(dataset) == 0
    mkdir(dataset);
end



[nSmp,nFea] = size(fea);
if nFea>=300
    FeaNumCandi = [50,100,150,200,250,300];
else
    FeaNumCandi = [50,80,110,140,170,200];
end


bestNMI_max = zeros(length(FeaNumCandi),1);
bestNMI_sqrt = zeros(length(FeaNumCandi),1);
bestACC = zeros(length(FeaNumCandi),1);

bestsNMI_max = zeros(length(FeaNumCandi),1);
bestsNMI_sqrt = zeros(length(FeaNumCandi),1);
bestsACC = zeros(length(FeaNumCandi),1);

%print the setup information
disp(['Dataset: ',dataset]);
disp(['class_num=',num2str(nClass),',','num_kmeans=',num2str(nKmeans)]);

t_start = clock;

%Clustering using selected features
for lam = lambda
    for gam = gamma
%         for nu = nuCandi
%             Y = Y_init;
%             disp(['alpha=',num2str(alpha),',','beta=',num2str(beta),',','nu=',num2str(nu)]);
            disp(['lam=', num2str(lam), ',', 'gam=', num2str(gam)]);
            result_path = strcat(dataset,'\','lam=', num2str(lam),',', 'gam=', num2str(gam),'_result.mat');
            mtrResult = [];
%             best_fea = [];
%             Z = zeros(size(fea,1),length(unique(gnd)));
%             W = RSFS(fea,L,Z,Y,alpha,beta,nu,maxIter);
            X_2 = SOCFS(fea', nClass, W, B, E, lam, gam, T, S);
            X_2 = X_2';

%             [dumb idx] = sort(sum(Weight.*Weight,2),'descend');
            orderFeature_path = strcat(dataset,'\','feaIdx_','lam=', num2str(lam), ',', 'gam=', num2str(gam),'.mat');
            save(orderFeature_path,'X_2');
            
            for feaIdx = 1:length(FeaNumCandi)
                feaNum = FeaNumCandi(feaIdx);
                newfea = fea(:,X_2(:,1:feaNum));
                rand('twister',5489);
                arrNMI_max = zeros(nKmeans,1);
                arrNMI_sqrt = zeros(nKmeans,1);
                
                
                
                arrACC = zeros(nKmeans,1);
                for i = 1:nKmeans
                    label = litekmeans(newfea,nClass,'Replicates',1);
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
                if mNMI_sqrt>bestNMI_sqrt(feaIdx)
                    bestNMI_sqrt(feaIdx) = mNMI_sqrt;
                    bestsNMI_sqrt(feaIdx) = sNMI_sqrt;
                end
                if mACC > bestACC(feaIdx)
                    bestACC(feaIdx) = mACC;
                    bestsACC(feaIdx) = sACC;
                end
                if mNMI_max > bestNMI_max(feaIdx)
                    bestNMI_max(feaIdx) = mNMI_max;
                    bestsNMI_max(feaIdx) = sNMI_max;
%                     best_newfea = idx(1:feaNum);
                end
                mtrResult = [mtrResult,[feaNum,mNMI_max,sNMI_max,mNMI_sqrt,sNMI_sqrt,mACC,sACC, lam, gam]'];
%                 best_fea = [best_fea, best_newfea]; 
            end
            save(result_path,'mtrResult');
%             save(result_path,'best_fea');
%         end
    end
end
t_end = clock;
disp(['exe time: ',num2str(etime(t_end,t_start))]);

%save the best results among all the parameters
result_path = strcat(dataset,'\','best','_result_',dataset,'_SOCFS','.mat');
save(result_path,'FeaNumCandi','bestNMI_sqrt','bestsNMI_sqrt','bestACC','bestsACC','bestNMI_max','bestsNMI_max');

f = 1;
